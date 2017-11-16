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

</head>

<body>
	<button data-event="test">在顶层页打开对话框</button>
	<button data-event="reload">刷新本框架页</button>
	<div id="value"></div>
	<script src="public/sb_admin2/bower_components/jquery/dist/jquery.min.js"></script>
	<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/artDialog7/dialog.js"></script>
	<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/artDialog7/dialog-plus.js"></script>

	<script>
		// demo
		window.console = window.console || {
			log : function() {
			}
		}

		$('button[data-event=test]').on('click', function() {
			top.dialog({
				id : 'test-dialog',
				title : 'loading..',
				url : 'public/sb_admin2/bower_components/artDialog7/iframe/index.jsp',
				//quickClose: true,
				onshow : function() {
					console.log('onshow');
				},
				oniframeload : function() {
					console.log('oniframeload');
				},
				onclose : function() {
					if (this.returnValue) {
						$('#value').html(this.returnValue);
					}
					console.log('onclose');
				},
				onremove : function() {
					console.log('onremove');
				}
			}).show(this);
			return false;
		});

		$('button[data-event=reload]').on('click', function() {
			location.reload();
			return false;
		});
		
		
		function test(){
			alert(1);
		}
	</script>
</body>

</html>