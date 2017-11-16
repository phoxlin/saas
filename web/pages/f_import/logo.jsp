	<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="java.io.File"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
	if (user == null || !user.getCD().contains("YP_IMPORT")) {
		request.getRequestDispatcher("/").forward(request, response);
	}
	String cust_name = user.getCust_name();
%>
<!DOCTYPE html>
<html lang="en">

<head>
<jsp:include page="/public/base.jsp"></jsp:include>
<title>数据导入</title>
<style type="text/css">
.panel-title {
	text-align: center;
}
a,a:hover, a:VISITED{color: #3eafad;}
</style>
<script type="text/javascript" src="public/jqueryLoader/js/jquery-ui-jqLoding.js"></script>
<script type="text/javascript">
	//导入数据
	function importInfos(type) {
		uploadFile(function() {
			doImport(type);
		}, type);
	}
	function doImport(type) {
		var url = $("#" + type).val();
		$(this).jqLoading();
		$.ajax({
			url : "yp-ws-import-logo",
			type : "POST",
			dataType : "json",
			data : {
				url : url,
				type: type
			},
			success : function(data) {
				$(this).jqLoading("destroy");
				if (data.rs == "Y") {
					success("上传成功");
				} else {
					error(data.rs);
				}
			}
		});
	}

	function uploadFile(func, field_name, ext, count) {
		if (typeof (ext) == "undefined") {
			ext = "png";
		}
		if (typeof (count) == "undefined") {
			count = 1;
		}
		var url = "public/sb_admin2/bower_components/qiniu/index.jsp?count="
				+ count + "&ext=" + ext;
		art.dialog.open(url, {
			title : '上传LOGO',
			width : 800,
			height : 400,
			okVal : "确定",
			ok : function() {
				var iframe = this.iframe.contentWindow;
				var names = iframe.document.getElementsByName('uploaded_file');
				var info = [];
				var urls = [];
				for (var i = 0; i < names.length; i++) {
					var o = {};
					var name = names[i];
					o.url = name.attributes["href"].value;
					o.filename = name.attributes["data-name"].value;
					info.push(o);
					urls.push(o.url);
				}

				var upload_result_tpl = document
						.getElementById('upload_result_tpl').innerHTML;
				var content = template(upload_result_tpl, {
					info : info,
					field_name : field_name
				});

				$('#_' + field_name).html(content);
				$('#' + field_name).val(urls.join(','));

				func();
				return false;
			}
		});
	}
</script>
</head>
<body>

	<div class="widget">
		<jsp:include page="/public/header.jsp">
			<jsp:param value="LOGO上传" name="view" />
		</jsp:include>
		<div class="container-fluid">
			<div class="main">
				<div class="row">
					<div class="col-lg-12 col-md-12 col-xs-12 panel ">
						<div class="right">
							<div class="row active" style="height: auto;">
								<div class="col-lg-12 ">
									<h4>APP端logo <span style="font-size: 13px; color: #dd0000">(注：图片格式为png)</span></h4>
									<div class="col-lg-12">
										<div class="col-lg-3">
										<%
											String baseUrl = Utils.getWebRootPath();
											String fileUrl = "app/images/logo/" + cust_name + "/logo2.png";
											File file = new File(baseUrl+fileUrl);
											if (file.exists()) {
										%>
											<img src="<%=fileUrl%>" style="width: 90%;background-color: #ccc;"/>
										<%		
											} else{
										%>
											还未上传logo
										<%		
											}
										%>
										</div>
										<div class="col-lg-3">
											<input type="hidden" id="app">
											<button class="btn btn-primary-plain" onclick="importInfos('app')">上传LOGO</button>
										</div>
									</div>
								</div>
								<div class="col-lg-12" style="margin-top: 20px;">
									<h4>后台logo <span style="font-size: 13px; color: #dd0000">(注：图片格式为png)</span></h4>
									<div class="col-lg-12">
										<div class="col-lg-3">
										<%
											fileUrl = "public/images/" + cust_name + "/logo.png";
											file = new File(baseUrl+fileUrl);
											if (file.exists()) {
										%>
											<img src="<%=fileUrl%>" style="width: 90%;background-color: #ccc;"/>
										<%		
											} else{
										%>
											还未上传logo
										<%		
											}
										%>
										</div>
										<div class="col-lg-3">
											<input type="hidden" id="bg">
											<button class="btn btn-primary-plain" onclick="importInfos('bg')">上传LOGO</button>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
