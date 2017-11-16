
function registerFingerChoice(mem_id){
	
}


//识别指纹
function validateFinger(mem_id,fun){
	
	var result = "";  
	var fingerData1 = "";
	var fingerData2 = "";
	$.ajax({
		type : "POST",
		url : "fit-cashier-mem-query-finger",
		data : {
			mem_id : mem_id
		},
		dataType : "json",
		async : false,
		success : function(data) {
			if (data.rs == "Y") {
				fingerData1 = data.fingerData1 || "";
				fingerData2 = data.fingerData2 || "";
			} else {
				alert(data.rs);
			}
		}
	});
	
	if(!fingerData1 && !fingerData2){
		errorMsg("该会员无指纹数据,无法验证");
		return;
	}
	
	/*// 引入 events 模块
	var events = require('events');
	// 创建 eventEmitter 对象
	var eventEmitter = new events.EventEmitter();*/

	try {
		var events = require('events'); 
		var emitter = new events.EventEmitter(); 
		
		emitter.on('validateFingerOver', function() { 
			//eval(fun+"('"+c+"')");
		}); 
		
		successMsg("请在10秒内按下指纹验证");
		var path = require("path");  
		var execPath = path.dirname(process.execPath);//nw.exe运行地址    
		var cp = require('child_process')
		result = cp.spawn(execPath + "\\finger_print_model\\Finger.exe", ['read',fingerData1,fingerData2]);  
		result.on('close', function(code) {  
			//successMsg("指纹识别程序已关闭");
			//emitter.emit('validateFingerOver'); 
		});  
		result.stdout.on('data', function(data) {  
			try{
				var obj = JSON.parse(data);
				if(obj.rs == "Y"){
					var code = obj.code;
					if(code == "Y"){
						c = code; 
						successMsg("认证成功");
						//eval(fun+"('"+c+"')");
					}else{
						errorMsg("认证失败");
					}
				}else{
					errorMsg(obj.rs);
				}
			}catch(e){
				
			}
			
		});  
		result.stderr.on('data', function(data) {  
		    console.log('stderr: ' + data);  
		});  
	} catch (e) {
		errorMsg("需要使用古德菲力客户端");
		console.log(e);
		//alert('读卡失败');
	}
	time = new Date().getTime();
	xx(fun,c);
}

var c = "";
var time = "";

function xx(fun,code){
	var now = new Date().getTime();
	if((now - time)/1000 >= 10){
		return;
	}
	if(!code){
		setTimeout(function(){
			 xx(fun,c);
		},1000);
	}else{
		eval(fun+"('"+c+"')");
		c = "";
	}
}
//录入指纹
function registerFinger(mem_id){
	successMsg("录入需要在60秒内完成3次指纹采集,请输入第1次");
	var result = "";  
	//需要3次指纹印记
	var i = "";
	try {
		var path = require("path");  
		var execPath = path.dirname(process.execPath);//nw.exe运行地址    
		var cp = require('child_process')
		result = cp.spawn(execPath + "\\finger_print_model\\Finger.exe", ['register']);  
		result.on('close', function(code) {  
			//successMsg("指纹识别程序已关闭");
		});  
		result.stdout.on('data', function(data) {  
			var obj = JSON.parse(data);
			if(obj.rs == "Y"){
				if(obj.code == "0" || obj.code == "1"){
					successMsg("请采集第" + (Number(obj.code) +2) +"次指纹");
				}else{
					insertFingerToDB(mem_id,obj.code);
				}
			}else{
				if(obj.rs == "-22"){
					errorMsg("指纹合并失败,请重试");
				}else{
					errorMsg("指纹合成失败,错误代码"+obj.rs);
				}
			}
		});  
		result.stderr.on('data', function(data) {  
		    console.log('stderr: ' + data);  
		});  

	} catch (e) {
		 errorMsg("需要使用古德菲力客户端");
		console.log(e);
		//alert('读卡失败');
	}
	
	
}
//更新数据库
function insertFingerToDB(mem_id,fingerData){
	top.dialog({
		title : '指纹录入',
		content : "请选择保存该指纹到:<label for='finger1'><input type='radio' id='finger1' name='finger' value='finger1'>指纹1</label>" +
				"<label for='finger2'><input type='radio' id='finger2' name='finger' value='finger2'>指纹2</label>",
		okValue : '确定',
		ok : function() {
			var finger = $(window.parent.document).find("input[type='radio']:checked").val();
			if(!finger){
				alert("请选择一项指纹保存");
				return;
			}
			//var iframe = $(window.parent.document).contents().find("div[i=dialog]:last").prev().find("iframe").contentWindow;
			$.ajax({
				type : "POST",
				url : "fit-cashier-mem-add-finger",
				data : {
					mem_id : mem_id,
					finger : finger,
					fingerData : fingerData
				},
				dataType : "json",
				async : false,
				success : function(data) {
					if (data.rs == "Y") {
						var divs = $(window.parent.document).contents().find("div[i=dialog]");
						var iframe = $(divs[divs.length -2]).find("iframe")[0].contentWindow;
						iframe.successMsg("指纹保存成功!");
					} else {
						alert(data.rs);
					}
				}
			});
		},
		cancelValue : '取消',
		cancel : function() {
		}
	}).showModal();
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

