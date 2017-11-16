<%@page import="com.jinhua.server.upload.QiniuAction"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">


<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">

<meta charset="UTF-8">
<title>test</title>
<style>
body {
	margin: 0;
}

#doc {
	height: 60px;
}

#doc iframe {
	display: block;
	width: 130px;
	border: 1px solid #CCC;
	height: 30px;
	margin: 10px auto 0 auto;
}
</style>
</head>

<body>
	<script>
		!/http/.test(location.protocol)
				&& document.write('<h1>请在服务端预览（部分浏览器本地 iframe 会跨域无权限）</h1>');
		
		function test(){
			var url ="public/sb_admin2/bower_components/artDialog7/iframe/main.jsp";
			$('#doc').html(parseInt($('#doc').html())+1);
			var d = dialog({
			    title: 'message',
			    url: url,
			    ok:function(){
			    	var iframe = $(window.parent.document).contents().find("[name="+dialog.getCurrent().id+"]")[0].contentWindow;
			    	iframe.test();
			    }
			});
			d.show();
		}
	</script>
	<div id="doc">
	1
	</div>
	
	<input type="button" value="iframe test" onclick="test()">
	<script src="public/sb_admin2/bower_components/jquery/dist/jquery.min.js"></script>
	<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/artDialog7/dialog.js"></script>
	<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/artDialog7/dialog-plus.js"></script>

</body>

</html>