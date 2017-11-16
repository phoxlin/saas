<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>拍照</title>
<jsp:include page="/public/base.jsp" />
</head>
<body>
<!-- <input value="拍照" type="button" onclick="showCamera()"> -->
<!-- 视频显示区域 -->
	<div id="camera_area" style="border: 1px solid red; display: none; position: absolute; left: 30%; top: 20%; z-index: 998">
		<video id="myvideo" autoplay>
		</video>
		<div>
			<input type="button" value="点击拍照" class='btn-success' onclick="take_photo()" style="width: 48%; height: 30px;  z-index: 999"> 
			<input type="button" value="取消 " class='btn' onclick="cancel()" style="width: 48%; height: 30px;  z-index: 999">
		</div>
	</div>
	<!-- 图像成型区域 -->
	<div id='photo_area' style="display: none; position: absolute;left: 30%; top: 20%; border: 1px solid green; z-index: 998">
		<!-- 小图片 -->
		<canvas id="canvas" width="480" height="480"></canvas>
		<!-- 大图片 -->
		<canvas id="bigPhoto" width="960" height="960" style="display: none;"></canvas>
		<div>
			<input type="button" class="btn-success" value="保存" onclick="save_photo()" style="width: 158px; height: 30px; z-index: 999; position: inherit;" > 
			<input type="button"  class="btn" value="重新拍摄" onclick="showCamera()" style="width: 158px; height: 30px; position: inherit; z-index: 999;" > 
			<input type="button" class="btn" value="取消" onclick="cancel()" style="width: 158px; height: 30px; position: inherit; z-index: 999;">
		</div>
	</div>
</body>
<script type="text/javascript">
//摄像头准备
function camera_ready(){
	var getUserMedia = (navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia);   
	
	getUserMedia.call(navigator, {
		video : true,
		audio : false
	}, function(localMediaStream) {
		var video = document.getElementById('myvideo');
		video.src = window.URL.createObjectURL(localMediaStream);
		video.onloadedmetadata = function(e) {
			console.log("Label: " + localMediaStream.label);
			console.log("AudioTracks", localMediaStream.getAudioTracks());
			console.log("VideoTracks", localMediaStream.getVideoTracks());
		};
		$("#camera_area").toggle();
		$("#photo_area").hide();
	}, function(e) {
		console.log('Reeeejected!', e);
		error("请连接摄像头!");
	});
	//context = canvas.getContext("2d")
	//alert("照相准备完毕");
}

var mem_id = '';
var mem_gym = '';

function showCamera(id,gym) {
	mem_id = id;
	mem_gym = gym;
	try {
		camera_ready();
	} catch (e) {
		error("请使用支持HTML5的浏览器");
	}
}

function take_photo(){
	  var context = canvas.getContext("2d")
	  var video = document.getElementById('myvideo');
	  // 640X480 为视频尺寸
	  //展示480X480 左右忽略80
	  ///小图片用于展示
	  context.drawImage(video, -80, 0, 640, 480);
	  //大图片用于保存
	  //1280X960 
	  //保存960X960 左右忽略160
	  var c=document.getElementById("bigPhoto");
	  var ctx=c.getContext("2d");
	  ctx.drawImage(video,-160, 0, 1280, 960);
	  //隐藏视频区
	  $("#camera_area").hide();
	  //打开照片区
	  $("#photo_area").show();
	 /*  $("#canvas").show();
	  $("#bigPhoto").hide(); */
}

function cancel(){
	 $("#camera_area").hide();
	 $("#photo_area").hide();
}

function save_photo(){
	console.log("mem_id:"+mem_id+",mem_gym:"+mem_gym);
	var uid = mem_id;
	//目前显示的是小图片，上传的是大图片,
	//var c=document.getElementById("canvas");//上传小图片480X480
	var c=document.getElementById("bigPhoto");//上传大图片960X960
	var imgData =c.toDataURL("image/png").substr(22);
	//火狐浏览器提示达到post请求大小限制，后台接受数据为 null
	//好像是 火狐浏览器的问题，腾讯浏览器谷歌没得问题
	//如果上传不了就打开上传小图片
	//var imgData1 = imgData.substring(0,imgData.length/2);
	//var imgData2 = imgData.substring(imgData.length/2,imgData.length);
	$.ajax({
    	  url : "fit-bg-mem-save-header",
    	  type: "POST",
    	 // contentType:"multipart/form-data",
    	  data : {
    		  mem_id : mem_id,
    		  mem_gym : mem_gym,
    		  imgData : imgData
    		  //imgData1:imgData1,
    		  //imgData2:imgData2
    	  },
    	  dataType:"json",
    	  success: function(data) {
    		  if(data.rs == 'Y'){
    			 successMsg("上传成功");
				 $("#photo_area").hide();
    			var imgPaht = data.path+"?imageView2/1/w/200/h/180";
				 $("img[name=mem_info_header]").attr("src",imgPath);
				 $("img[name=mem_info_header"+mem_id+"]").attr("src",imgPath);
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
</script>
</html>