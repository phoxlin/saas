
<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
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

a, a:hover, a:VISITED {
	color: #3eafad;
}
</style>
<script type="text/javascript" src="public/jqueryLoader/js/jquery-ui-jqLoding.js"></script>
<script type="text/javascript">
	//导入数据
	function importInfos(type) {
		uploadFile(function() {
			doImport(type);
		}, type);
	}
	function doImport(type, confirm) {
		var controller = "";
		if (type == 'cards') {
			controller = "ws-import-excel-cards";
		} else if (type == 'users') {
			controller = "ws-import-excel-users";
		} else if (type == 'employee') {
			controller = "ws-import-excel-employee";
		} else if (type == 'goods') {
			controller = "ws-import-excel-goods";
		} else {
			error("不清楚的数据导入类型");
			return;
		}

		var url = $("#" + type).val();
		$(this).jqLoading();
		$.ajax({
			url : controller,
			type : "POST",
			dataType : "json",
			data : {
				url : url,
				confirm : confirm
			},
			success : function(data) {
				$(this).jqLoading("destroy");
				if (data.rs == "Y") {
					success("上传成功，共导入【" + data.count + "】条数据");
				} else {
					if (data.flag == 'msg') {
						art.dialog({
							title : "提示",
							content : data.rs,
							lock : true,
							ok : function() {
								doImport(type, "Y");
								return true;
							},
							okValue : "确定",
							cancel : function() {
							}
						});
					} else {
						error(data.rs);
					}
				}
			}
		});
	}

	function uploadFile(func, field_name, ext, count) {
		if (typeof (ext) == "undefined") {
			ext = "xls,xlsx";
		}
		if (typeof (count) == "undefined") {
			count = 1;
		}
		var id="id_"+new Date().getTime();
		var url = "public/sb_admin2/bower_components/qiniu/index.jsp?count="+ count + "&ext=" + ext;
		top.dialog({
					url : url,
					title : '上传文件',
					width : 800,
					height : 400,
					okVal : "确定",
					id : id,
					ok : function() {
						var iframe = $(window.parent.document).contents().find("[name=" + id + "]")[0].contentWindow;
						console.log(111);
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
		
						var upload_result_tpl = document.getElementById('upload_result_tpl').innerHTML;
						var content = template(upload_result_tpl, { info : info, field_name : field_name });
		
						$('#_' + field_name).html(content);
						$('#' + field_name).val(urls.join(','));
		
						func();
						return false;
					}
		}).show();
	}
</script>
</head>
<body style="background-color: white;">

	<div class="widget">
		<div class="container-fluid">
			<div class="row">
				<div class="col-xs-12">
					<div class="right">
						<div class="row">
							<div class="col-xs-6">
								<div class="col-lg-8">
									<a href="excel/会员模板.xlsx" target="_blank">会员模板下载</a>
								</div>
							</div>
							<div class="col-xs-6 ">
								<input type="hidden" id="users">
								<button class="btn btn-primary-plain" onclick="importInfos('users')">上传会员模板数据</button>
							</div>
						</div>
						<div class="row">
							<div class="col-xs-12">
								<div class="panel panel-default">
								  <div class="panel-body" style="height: 330px;    margin-top: 20px;">
								   	<div class="alert alert-warning alert-dismissible" role="alert" style="margin-bottom: 10px;">
									  <strong>提示:</strong> 
									</div>
									<div class="alert alert-info" role="alert" style="margin: 5px;">先下载【会员模板】，并按照模板格式添加数据;</div>
									<div class="alert alert-info" role="alert" style="margin: 5px;">点击 【上传会员模板数据】按钮进行上传;</div>
									<div class="alert alert-info" role="alert" style="margin: 5px;">系统会进行数据格式检查并返回数据的基本信息，确认无误后请点击【保存上次数据】按钮完成数据保存</div>
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
