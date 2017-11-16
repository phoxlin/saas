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

<link rel="stylesheet" type="text/css" href="public/bootstrap/css/bootstrap.min.css">
<!-- MetisMenu CSS -->

<link rel="stylesheet" type="text/css" href="public/sb_admin2/bower_components/easyui-1.4.4/themes/bootstrap/easyui.css">
<link rel="stylesheet" type="text/css" href="public/sb_admin2/bower_components/easyui-1.4.4/themes/icon.css">


<script src="public/sb_admin2/bower_components/easyui-1.4.4/jquery.min.js"></script>

<!-- Bootstrap Core JavaScript -->

<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/easyui-1.4.4/jquery.easyui.min.js"></script>
<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/easyui-1.4.4/locale/easyui-lang-zh_CN.js"></script>


<!-- bootstap datetime -->

<script type="text/javascript" charset="utf-8" src="public/js/json2.js"></script>
<script type="text/javascript" charset="utf-8" src="public/js/template.js"></script>



<script type="text/javascript">
<!--
template.config({sTag: '<#', eTag: '#>'});
//-->

</script>

</head>
<body>
	<h2>Basic Messager</h2>
	<p>Click on each button to see a distinct message box.</p>
	<div style="margin:20px 0;">
		<a href="" class="easyui-linkbutton" onclick="show()">Show</a>
		<a href="#" class="easyui-linkbutton" onclick="slide()">Slide</a>
		<a href="#" class="easyui-linkbutton" onclick="fade()">Fade</a>
		<a href="JavaScript:;" class="easyui-linkbutton" onclick="progress()">Progress</a>
	</div>
	<script type="text/javascript">
		function show(){
			$.messager.show({
				title:'My Title',
				msg:'Message will be closed after 4 seconds.',
				showType:'show'
			});
		}
		function slide(){
			$.messager.show({
				title:'My Title',
				msg:'Message will be closed after 5 seconds.',
				timeout:5000,
				showType:'slide'
			});
		}
		function fade(){
			$.messager.show({
				title:'My Title',
				msg:'Message never be closed.',
				timeout:0,
				showType:'fade'
			});
		}
		function progress(){
			var win = $.messager.progress({
				title:'Please waiting',
				msg:'Loading data...'
			});
			setTimeout(function(){
				$.messager.progress('close');
			},5000)
		}
	</script>
</body>
</html>