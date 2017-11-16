<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.ms.QmToolbar"%>
<%@page import="com.sun.javafx.scene.control.skin.ToolBarSkin"%>
<%@page import="com.jinhua.server.db.Column"%>
<%@page import="com.jinhua.server.task.TaskGridLegend"%>
<%@page import="com.jinhua.server.task.TaskInfo"%>
<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
	if(user == null || !user.hasPower("sm_manageMems")){
		request.getRequestDispatcher("/").forward(request, response);
	}
	String cust_name = user.getCust_name();
	String taskcode = "f_mem";
	String taskname = "会员管理";
	String sId = request.getParameter("sid");
	
	TaskInfo task=new TaskInfo("f_mem",user);
	TaskGridLegend grid=task.getGridLegend("f_mem");
	
%>
<!DOCTYPE html>
<html>
<head>
<title><%=taskname%></title>
<jsp:include page="/public/base.jsp" />
<link rel="stylesheet" media="all" href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/public/css/bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="public/css/user.css">
<style type="text/css">
.data-container{margin-top: -13px;}
html, body{min-height: 100%;height: auto;}
</style>
<script type="text/javascript" src="pages/f_mem/index.js"></script>
<script type="text/javascript" src="pages/f_mem/f_mem.js"></script>
</head>
<body>
	<div class="widget">
		<jsp:include page="/public/header.jsp"></jsp:include>
		<div class="container-fluid">
			<div class="main main2 mem-filter">
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
									<i class="fa fa-map-marker"></i><span>会员管理</span>
								</p>
							</a>
						</li>
					</ul>
				</div>
				
				<ul class="nav nav-tabs nav-tabs-custom" role="tablist">
					<li role="presentation" class="active"><a href="#tab1" aria-controls="tab1" role="tab" data-toggle="tab" onclick="showAllMem()"> <span class="nav-tabs-left"></span> <span class="nav-tabs-text">全部会员</span> <span class="nav-tabs-right"></span>
					</a></li>
					<li role="presentation"><a href="#tab2" aria-controls="tab2" role="tab" data-toggle="tab"  onclick="showMaintainMem()"> <span class="nav-tabs-left"></span> <span class="nav-tabs-text">会员维护</span> <span class="nav-tabs-right"></span>

					</a></li>
					<li role="presentation"><a href="#tab3" aria-controls="tab3" role="tab" data-toggle="tab"  onclick="showPotentialMem()"> <span class="nav-tabs-left"></span> <span class="nav-tabs-text">潜在客户</span> <span class="nav-tabs-right"></span>
					</a></li>
				</ul>

				<div class="tab-content" style="height: 130px;">
					<div role="tabpanel" class="tab-pane fade in active" id="tab1"></div>
					<div role="tabpanel" class="tab-pane fade in" id="tab2"></div>
					<div role="tabpanel" class="tab-pane fade in" id="tab3"></div>
				</div>
			</div>
		</div>
	</div>
	
			
	<script type="text/javascript">
		function setValue(val){
			var setVal=$(val).parent().find("input").val();
			var flag=$(val).parent().find("input").attr('name');
			$("."+flag).parent().find('[data-flag="value"]').html(setVal);
			$("."+flag).popover('hide');
		}
	
		$(function() {
			$("#tab1").load("pages/f_mem/all_mem.jsp");
			$(".easyui-datebox").each(function(){
				var placeholder = $(this).attr("placeholder");
				$(this).next(".datebox").children(".textbox-text").attr("placeholder",placeholder);
			});
			//新增的会员popover
			$(".new-mem").popover({
				trigger : 'click',
				html : true,
				content : "<div style='width: 150px;'>查找最近 <input type='number' name='new-mem' class='filter-input' style='width: 50px;' value='3'/> 天内新增的会员</div><button onclick='setValue(this)' class='btn btn-primary custom-btn-primary' style='width: auto;float:right;'>确定</button>",
				placement : "bottom"
			});
			//即将到期popover
			$(".deadline").popover({
				trigger : 'click',
				html : true,
				content : "<div style='width: 150px;'>查找最近 <input type='number' name='deadline' class='filter-input' style='width: 50px;' value='20'/> 天内会员卡即将到期</div><button onclick='setValue(this)' class='btn btn-primary custom-btn-primary' style='width: auto;float:right;'>确定</button>",
				placement : "bottom"
			});
			//即将生日popover
			$(".birthday-popover").popover({
				trigger : 'click',
				html : true,
				content : "<div style='width: 150px;'>查找最近 <input type='number' name='birthday-popover' class='filter-input' style='width: 50px;' value='7'/> 天内即将生日的会员</div><button onclick='setValue(this)' class='btn btn-primary custom-btn-primary' style='width: auto;float:right;'>确定</button>",
				placement : "bottom"
			});
			//消费能力popover
			$(".usedMoney").popover({
				trigger : 'click',
				html : true,
				content : "<div style='width: 150px;'>查找共消费 <input type='number' name='usedMoney' class='filter-input' style='width: 50px;' value='5000'/> 元以上的会员</div><button onclick='setValue(this)' class='btn btn-primary custom-btn-primary' style='width: auto;float:right;'>确定</button>",
				placement : "bottom"
			});
			//未来消费popover
			$(".notcheckin").popover({
				trigger : 'click',
				html : true,
				content : "<div style='width: 150px;'>查找最近 <input type='number' name='notcheckin' class='filter-input' style='width: 50px;' value='7'/> 天内未来会所消费的会员</div><button onclick='setValue(this)' class='btn btn-primary custom-btn-primary' style='width: auto;float:right;'>确定</button>",
				placement : "bottom"
			});
			//请假popover
			$(".yp_leave").popover({
				trigger : 'click',
				html : true,
				content : "<div style='width: 150px;'>查找已经请假 <input type='number' name='yp_leave' class='filter-input' style='width: 50px;' value='30'/> 天以上的会员</div><button onclick='setValue(this)' class='btn btn-primary custom-btn-primary' style='width: auto;float:right;'>确定</button>",
				placement : "bottom"
			});
			//累计推荐入会popover
			$(".refer_phone").popover({
				trigger : 'click',
				html : true,
				content : "<div style='width: 150px;'>查找累计介绍 <input type='number' name='refer_phone' class='filter-input' style='width: 50px;' value='3'/> 位会员入会的会员</div><button onclick='setValue(this)' class='btn btn-primary custom-btn-primary' style='width: auto;float:right;'>确定</button>",
				placement : "bottom"
			});
			//会员兴趣popover
			$(".mem_like").popover({
				trigger : 'click',
				html : true,
				content : "<div style='width: 150px;'>查找喜欢 <input type='text' name='mem_like' class='filter-input' style='width: 100px;' value=''/> 的会员</div><button onclick='setValue(this)' class='btn btn-primary custom-btn-primary' style='width: auto;float:right;'>确定</button>",
				placement : "bottom"
			});
			//跟单内容popover
			$(".contact_content").popover({
				trigger : 'click',
				html : true,
				content : "<div style='width: 150px;'>查找之前沟通过 <input type='text' name='contact_content' class='filter-input' style='width: 100px;' value=''/> 的会员</div><button onclick='setValue(this)' class='btn btn-primary custom-btn-primary' style='width: auto;float:right;'>确定</button>",
				placement : "bottom"
			});

			//点击其他区域，隐藏popover
			$(document).on('click',function(event) {
				var target = $(event.target);
				if (!target.hasClass('popover')
						&& !target.hasClass('filter-input')
						&& target.parent('.popover-content').length === 0
						&& target.parent('.popover-title').length === 0
						&& target.parent('.popover').length === 0
						&& (target.attr("class") == undefined || target.attr("class").indexOf("icon-calendar") < 0)) {
					$('.icon-calendar').popover('hide');
				}
			});
		});

		//筛选
		function search() {
			$(".end-popover").popover('hide');
			$(".birthday-popover").popover('hide');
		}
		getQueryType();
		function showAllMem(){
			$("#tab1").load("pages/f_mem/all_mem.jsp");
			$("#tab2").html("");
			$("#tab3").html("");
		}
		function showMaintainMem(){
			$("#tab1").html("");
			$("#tab2").load("pages/f_mem/maintainMem.jsp");
			$("#tab3").html("");
		}
		function showPotentialMem(){
			$("#tab1").html("");
			$("#tab2").html("");
			$("#tab3").load("pages/f_mem/potentialMem.jsp");
		}
	</script>
</body>
</html>