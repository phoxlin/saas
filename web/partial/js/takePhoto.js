var take_photo_flag =false;

function getPicture(fun) {
	if(take_photo_flag){
		return;
	}
	try {
		if(take_photo_flag){
			return;
		}
		take_photo_flag = true;
		var path = require("path");  
		var execPath = path.dirname(process.execPath);//nw.exe运行地址    
		var cwdPath = process.cwd();  
		cwdPath = cwdPath.replace("/","\\");
		const exec = require('child_process').exec;//产生exec，同时传入.bat文件
		exec(execPath + '\\take_photo_model\\OperateCamera.exe', (err, stdout, stderr) => {
		  if (stderr) {
		  console.log(err.message);
		  }
			if(stdout){
				var obj = JSON.parse(stdout);
				if(obj.result=='Y'){
					var imgPath = "";
					if(obj.url =='' || obj.url == null){
						imgPath = obj.key;
					}else{
						imgPath = obj.url;	
					}
					eval(fun+"('"+imgPath+"')");
				}
			}	
			take_photo_flag = false;
		  console.log(stdout);
		});
	} catch (e) {
		console.log(e);
		errorMsg("请使用客户端,并连接摄像头");
		take_photo_flag = false;
	}finally{
		//take_photo_flag = false;
	}
}


function showCamera(mem_id,mem_gym) {
	
	/*var imgPath = baseUrl +"/public/fit/images/logo.png?imageView2/1/w/200/h/180";
	
	var doc =window.parent.document;
	$(doc).find("img[name=mem_info_header"+mem_id+"]").attr("src",imgPath);
	$("img[name=mem_info_header]").attr("src",imgPath);
	*/
	try {
		if(take_photo_flag){
			return;
		}
		take_photo_flag = true;
		var path = require("path");  
		var execPath = path.dirname(process.execPath);//nw.exe运行地址    
		var cwdPath = process.cwd();  
		cwdPath = cwdPath.replace("/","\\");
		const exec = require('child_process').exec;//产生exec，同时传入.bat文件
		exec(execPath + '\\take_photo_model\\OperateCamera.exe', (err, stdout, stderr) => {
		  if (stderr) {
		  console.log(err.message);
		  }
			if(stdout){
				var obj = JSON.parse(stdout);
				if(obj.result=='Y'){
					var imgPath = "";
					if(obj.url =='' || obj.url == null){
						imgPath =  obj.key;
					}else{
						imgPath = obj.url;	
					}
					//var imgPath = "${pageContext.request.contextPath}/" + obj.key;
					uploadImg(imgPath,mem_id,mem_gym);
				}
			}	
			take_photo_flag = false;
		  console.log(stdout);
		});
	} catch (e) {
		console.log(e);
		errorMsg("请使用客户端,并连接摄像头");
		take_photo_flag = false;
	}finally{
		//take_photo_flag = false;
	}
}


function uploadImg(imgPath,mem_id,mem_gym){
	 
	$.ajax({
  	  url : "fit-bg-mem-save-header-imgPath",
  	  type: "POST",
  	  data : {
  		  mem_id : mem_id,
  		  mem_gym : mem_gym,
  		  imgPath : imgPath
  	  },
  	  dataType:"json",
  	  success: function(data) {
  		  if(data.rs == 'Y'){
  			 successMsg("上传成功");
  			 
  			var path = baseUrl +"/"+ imgPath+"?imageView2/1/w/200/h/180";
  			try {
  				var doc =window.parent.document;
  				$(doc).find("img[name=mem_info_header"+mem_id+"]").attr("src",path);
  				$("img[name=mem_info_header]").attr("src",path);
			} catch (e) {
				$("img[name=mem_info_header"+mem_id+"]").attr("src",path);
			}
  			
  		  }else{
  			 errorMsg("上传失败,原因:"+data.rs);
  		  }
  	  },
  	  error : function(){
  		  errorMsg("操作超时,请重试");
  	  }
    })
	
}



function successMsg(msg){
	Messenger().post(msg);
};
function errorMsg(msg){
	Messenger().post({
		  message: msg,
		  type: 'error',
		  showCloseButton: true
		});
};