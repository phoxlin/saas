<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.db.Entity"%>
<%@page import="com.jinhua.server.tools.UI"%>
<%@page import="com.jinhua.server.tools.UI_Op"%>
<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	FitUser user = (FitUser)SystemUtils.getSessionUser(request, response);
	if (user == null) {
		request.getRequestDispatcher("/").forward(request, response);
	}
	String cust_name = user.getCust_name();
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>课程管理</title>
<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<script src="public/sb_admin2/bower_components/jquery/dist/jquery.min.js"></script>
<link type="text/css" href="partial/lessionplan/files/bootstrap.css" rel="stylesheet" media="screen">
<link type="text/css" href="partial/lessionplan/files/panel.css" rel="stylesheet" media="screen">
<link type="text/css" href="public/sb_admin2/bower_components/font-awesome/css/font-awesome.min.css" rel="stylesheet" media="screen">
<link type="text/css" href="public/fit/css/Base.css" rel="stylesheet" media="screen">
<link rel="stylesheet" type="text/css" href="public/sb_admin2/bower_components/artDialog7/css/dialog.css">
<link rel="stylesheet" type="text/css" href="public/css/header.css">
<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/artDialog7/dialog.js"></script>
<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/artDialog7/dialog-plus.js"></script>
<script type="text/javascript" src="partial/js/cashier.js"></script>
<script type="text/javascript">
	
//添加排期
function planLession(){
    var url = "partial/lessionplan/addPaiQi.jsp";
    dialog({
        url: url,
        title: "添加排期",
        width: 800,
        height: 540,
        okValue: "确定",
        ok: function() {
            var iframe = $(window.parent.document).contents().find("div[i=dialog]:first iframe")[0].contentWindow;
            iframe.addPaiQi(this, document);
            return false;
        },
        cancelValue: "取消",
        cancel: function() {
            return true;
        }
    }).showModal();
}

	$(function(){
		$.ajax({
	        type: "POST",
	        url: "fit-action-lesson-showPaiQi",
	        dataType: "json",
	        data : {
				
				type : 'show'
			},
	        async: false,
	        success: function(data) {
	            if (data.rs == "Y") {
	            	var list = data.list;
	            	var showPaiQiHtml = "";
	            	var showPaiQiHtml2 = "";
	            	for(var i =0;i < list.length; i++){
	            		showPaiQiHtml +="<td key='plan_name' class='align-center' style='width: 200px;'>"+list[i].plan_name+"</td><td key='plan_name' class='align-center' style='width: 200px;'>"+list[i].name+"</td><td key='plan_name' class='align-center' style='width: 346px;'>"+
						list[i].start_time.substring(0,10)+"至"+list[i].end_time.substring(0,10)+"</td><td key='plan_name' class='align-center' style='width: 200px;'>"+"<button class='btn btn-sm' onclick='showPaiQi(\""+list[i].id+"\")'>查看</button>"+"</td><td key='plan_name' class='align-center' style='width: 200px;'>"+list[i].num+
						"</td><td key='plan_name' class='align-center' style='width: 200px;'>"+list[i].emp_name+
						"</td><td key='plan_name' class='align-center' style='width: 200px;'>"+list[i].create_time.substring(0,16)+"</td><td key='plan_name' class='align-center' style='width: 200px;'><button class='btn btn-sm' onclick='editPaiQi(\""+list[i].plan_list_id+"\")'>编辑</button><button class='btn btn-sm' name='remove' onclick='deletePlan(\""+list[i].plan_list_id+"\")'>删除</button>";
	            		showPaiQiHtml2 +="<tr>"+showPaiQiHtml+"</tr>";
	            		showPaiQiHtml = "";
	            	}
	            	$("#showPaiQi").html(showPaiQiHtml2);
	            } else {
	                error(data.rs);
	            }

	        }
	    });
		
	});
</script>
<style>

</style>
</head>

<body class="panel">
	<div class="page-wrapper">
		<jsp:include page="../../public/header.jsp"></jsp:include>
		<div class="page-main page-main-cashier" style="width: 1200px;">
			<div class="nav-bar">
				<a href="main.jsp" class="back">
					<p>
						<i class="fa fa-arrow-left"></i> 
						<span>返回主页</span>
					</p>
				</a>
				<ul>
					<li>
						<a class="cur">
							<p>
								<i class="fa fa-map-marker"></i><span>课程管理</span>
							</p>
						</a>
						<a href="javascript:;" class="subscribeTimeLimit" onclick="showSetPlanOrder()">
							<p>
								<i class="fa fa-cog"></i><span>团课预约时限</span>
							</p>
					</a> 
					<a href="javascript:;" onclick="javascript:planLessionTuan();" class="addGroup">
						<p><i class="fa fa-plus"></i> <span>添加团课</span></p>
                    </a>
                    <a href="javascript:;" onclick="javascript:planLession();" class="addGroup">
                    	<p><i class="fa fa-plus"></i> <span>添加排期</span></p>
                    </a>
					<a href="javascript:;" class="help">
							<p>
								<i class="fa fa-question-circle"></i> <span>帮助</span>
							</p>
					</a></li>
				</ul>
			</div>
			<div class="container-tab">
				<ul class="tabs">
					<li name="syllabusOrder"><a href="partial/lessionplan/index.jsp">周课表</a></li>
					<li  class="active" name="syllabusGroupWeekTable"><a href="partial/lessionplan/index2.jsp">团课排期</a></li>
				</ul>
			</div>
			<div class="container-btn searchbar" style="display: block; padding-top: 10px; height: 70px; text-align: center;">
				<div style="float: none; clear: both; margin-bottom: 14px;"></div>
				<button class="btn btn-primary search-btn addGroup"  name="addSyllabusGroup" onclick="javascript:planLession();" style="margin-top: 0; float: left;">添加排期</button>
				<input class="input-text width-150" type="text" id="plan_name" name="plan_name" placeholder="课程名称" style="margin-left: -37%;">
				<input class="input-text width-150" type="text" id="coach" name="coach" placeholder="教练姓名">
				<input class="input-text width-150" type="text" id="address" name="address" placeholder="上课地点">
				<button class="btn btn-primary search-btn" name="submit" onclick="searchPaiQi()">搜索</button>
				<!-- <select name="is_free" class="select width-100">
					<option value="001">正常</option>
					<option value="002">已删除</option>
				</select> -->
			</div>
			<table class="table table-list">
					<thead>
						<tr>
							<th col-key="title"><strong>课程名称</strong></th>
							<th col-key="coach"><strong>教练</strong></th>
							<th col-key="startTime"><strong>日期</strong></th>
							<th col-key="seeTime"><strong>时间</strong></th>
							<th col-key="lessonTotal"><strong>课程数量</strong></th>
							<th col-key="manager"><strong>操作人</strong></th>
							<th col-key="addTime"><strong>添加时间</strong></th>
							<th col-key="action"><strong>操作</strong></th>
						</tr>
					</thead>
					<tbody id="showPaiQi">
						
					</tbody>
				</table>
		</div>
	</div>
</body>
</html>