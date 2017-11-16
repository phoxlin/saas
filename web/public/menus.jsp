<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Navigation -->
<style>
.messager-body {
	padding: 0px
}
</style>
<nav class="navbar navbar-default navbar-static-top" role="navigation" style="margin-bottom: 0">
	<!-- #include file="public/header.html" -->

	<script>
	function clock(){
		myDate = new Date();
		$("#date").text(myDate.toLocaleString());
	}
		$(function(){
			$.ajax({
				url : "getUser",
				type : "post",
				dataType : "json",
				success : function(data) {
					if ("Y" == data.rs)
						$("#name").text(data.name);
				},
				error : function() {
				}
			});
			var myDate;
			setInterval("clock()",60);
		})
	</script>
	<div style="float: right; margin-right: 100px; margin-top: 12px">
		<div style="margin-right: 100px">
			用户名：<span id="name"></span> &nbsp; | &nbsp;<span id="date"></span> &nbsp; &nbsp; <a href="exit.html">退出系统</a>
		</div>
	</div>

	<div class="navbar-default sidebar" role="navigation">
		<div class="sidebar-nav navbar-collapse">
			<ul class="nav" id="side-menu">
				<!-- 		<li class="sidebar-search">
					<div class="input-group custom-search-form">
						<input type="text" class="form-control" placeholder="Search..."> <span class="input-group-btn">
							<button class="btn btn-default" type="button">
								<i class="fa fa-search"></i>
							</button>
						</span>
					</div> /input-group
				</li> -->

				<li class="active"><a href="#">系统开发<span class="fa arrow"></span></a>
					<ul class="nav nav-second-level collapse in" aria-expanded="true">
						<li><a href="public/pub/sys_task_todo/index.jsp"><i class="fa fa-cog"></i>待办任务</a> 
						<a href="public/pub/sys_task_finish/index.jsp"><i class="fa fa-cog"></i>已完成任务</a> 
						<a href="public/designer/db.html"><i class="fa fa-list-ul fa-fw"></i>数据库管理</a> 
						<a href="public/designer/index.html"><i class="fa fa-list-ul fa-fw"></i>通用查询管理</a>  
							
						</li>

					</ul> <!-- /.nav-second-level --></li>
			</ul>
		</div>
		<!-- /.sidebar-collapse -->
	</div>
	<!-- 模态框（Modal） -->
	<div class="modal" id="Modalshow" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="height: 100px; width: 200px; margin: 0px auto; margin-top: 300px;">
		<div class="modal-dialog" style="height: 20%; width: 71%;">
			<div class="modal-content">
				<div class="modal-body" id="finding">正在查询中......</div>
			</div>
		</div>
	</div>
</nav>

