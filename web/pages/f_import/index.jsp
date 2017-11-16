
<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
	if (user == null) {
		request.getRequestDispatcher("/").forward(request, response);
	}
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
		var url = "public/sb_admin2/bower_components/qiniu/index.jsp?count="
				+ count + "&ext=" + ext;
		art.dialog.open(url, {
			title : '上传文件',
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
		<jsp:include page="/public/header.jsp" />
		<div class="container-fluid">
			<div class="main main2">
				<div class="nav-bar">
					<a href="main.jsp" class="back"><p>
							<i class="fa fa-arrow-left"></i> <span>返回主页</span>
						</p></a>
					<ul>
						<li><a class="cur"><p>
									<i class="fa fa-map-marker"></i><span>数据导入</span>
								</p></a></li>
					</ul>
				</div>

				<div class="row">
					<div class="col-lg-12 col-md-12 col-xs-12 panel ">
						<div class="right">
							<div class="row active" style="height: auto;">
								<div class="col-lg-12 ">
									<h4>卡种</h4>
									<div class="col-lg-12">
										<div class="col-lg-3">
											<div class="col-lg-8">
												<a href="excel/卡种模板.xlsx" target="_blank">卡种模板下载</a>
											</div>
										</div>
										<div class="col-lg-3">
											<input type="hidden" id="cards">
											<button class="btn btn-primary-plain" onclick="importInfos('cards')">导入卡种</button>
										</div>
									</div>
								</div>
								<div class="col-lg-12 ">
									<h4>员工</h4>
									<div class="col-lg-12">
										<div class="col-lg-3">
											<div class="col-lg-8">
												<a href="excel/员工模板.xlsx" target="_blank">员工模板下载</a>
											</div>
										</div>
										<div class="col-lg-3">
											<input type="hidden" id="employee">
											<button class="btn btn-primary-plain" onclick="importInfos('employee')">导入员工</button>
										</div>
									</div>
								</div>
								<div class="col-lg-12 ">
									<h4>会员</h4>
									<div class="col-lg-12">
										<div class="col-lg-3">
											<div class="col-lg-8">
												<a href="excel/会员模板.xlsx" target="_blank">会员模板下载</a>
											</div>
										</div>
										<div class="col-lg-3">
											<input type="hidden" id="users">
											<button class="btn btn-primary-plain" onclick="importInfos('users')">导入会员</button>
										</div>
									</div>
								</div>
								<div class="col-lg-12 ">
									<h4>商品</h4>
									<div class="col-lg-12">
										<div class="col-lg-3">
											<div class="col-lg-8">
												<a href="excel/商品模板.xlsx" target="_blank">商品模板下载</a>
											</div>
										</div>
										<div class="col-lg-3">
											<input type="hidden" id="goods">
											<button class="btn btn-primary-plain" onclick="importInfos('goods')">导入商品</button>
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
