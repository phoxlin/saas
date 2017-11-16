<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.db.Entity"%>
<%@page import="com.jinhua.server.tools.UI"%>
<%@page import="com.jinhua.server.tools.UI_Op"%>
<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
	if (user == null) {
		request.getRequestDispatcher("/").forward(request, response);
	}

	Entity f_plan = (Entity) request.getAttribute("f_plan");
	boolean hasF_plan = f_plan != null && f_plan.getResultCount() > 0;
	String id = request.getParameter("id");
	String plan_id = request.getParameter("plan_id");
	String gym = user.getViewGym();
	String plan_name = request.getParameter("plan_name");
%>
<!DOCTYPE html style="height: 100%;">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<base
	href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<script
	src="public/sb_admin2/bower_components/jquery/dist/jquery.min.js"></script>
<jsp:include page="/public/edit_base.jsp" />
<script type="text/javascript" charset="utf-8"
	src="public/ueditor/ueditor.config.js"></script>
<script type="text/javascript" charset="utf-8"
	src="public/ueditor/ueditor.all.min.js">
	
</script>


<link type="text/css" href="public/bootstrap/css/bootstrap.min.css"
	rel="stylesheet" media="screen">
<link type="text/css" href="partial/lessionplan/files/panel.css"
	rel="stylesheet" media="screen">
<link type="text/css" href="public/sb_admin2/bower_components/font-awesome/css/font-awesome.min.css" rel="stylesheet" media="screen">
<link type="text/css" href="public/fit/css/Base.css" rel="stylesheet" media="screen">
<link rel="stylesheet" type="text/css"
	href="public/sb_admin2/bower_components/artDialog7/css/dialog.css">
<script type="text/javascript" charset="utf-8"
	src="public/sb_admin2/bower_components/artDialog7/dialog.js"></script>
<script type="text/javascript" charset="utf-8"
	src="public/sb_admin2/bower_components/artDialog7/dialog-plus.js"></script>
<script type="text/javascript" charset="utf-8"
	src="public/js/template.js"></script>
<script type="text/javascript" charset="utf-8" src="app/js/date.js"></script>
<script type="text/javascript">
<!--
template.config({sTag: '<#', eTag: '#>'});
//-->
var plan_name = '<%=Utils.isNull(plan_name)?"":plan_name%>';
	$(function(){
		 $.ajax({
		        type: "POST",
		        url: "fit-action-lesson-showLessonDetail",
		        data: {
		        	id:'<%=id%>',
		        	type : 'show'
			},
			dataType : "json",
			async : false,
			success : function(data) {
				if (data.rs == "Y") {
					var list = data.list;
					var planTpl = document.getElementById('planTpl').innerHTML;
					var planTplHtml = template(planTpl, {
						list : data.list
					});
					var week = "";
					if(list[0].week==1){
						week = "星期天";
					}
					if(list[0].week==2){
						week = "星期一";
					}
					if(list[0].week==3){
						week = "星期二";
					}
					if(list[0].week==4){
						week = "星期三";
					}
					if(list[0].week==5){
						week = "星期四";
					}
					if(list[0].week==6){
						week = "星期五";
					}
					if(list[0].week==7){
						week = "星期六";
					}
					var startTime = list[0].start_time;
					var endTime = list[0].end_time;
					$("#lessonTime").html(week+startTime+"-"+endTime);
					$("#lesson_time").val(list[0].lesson_time+" "+startTime+":"+endTime);
					if(list.length<2){
						planTplHtml += "<tr><td class=align-center' colspan='7' style='text-align: center;vertical-align:middle;height: 240px; background-position: center center; background-repeat: no-repeat;'><div class='none-info font-90'>暂无数据</div></td></tr>";
					}
					$('#planDiv').html(planTplHtml);
					
					$("#yuyinButton").click(function(){
						if(data.list && data.list.length>0){
								var cls = data.list[0];
								
								var start_time = new Date().Format("yyyy-MM-dd ") +cls.start_time+":00";
								start_time = new Date(start_time).getTime(); 
								var end_time = new Date().Format("yyyy-MM-dd ") +cls.end_time+":00";
								end_time = new Date(end_time).getTime(); 
								var now = new Date().getTime();
								var text = "";
								if(start_time >= now){
									var id = cls.id;
									//上课前
									text += "各位小伙伴们请注意啦,课程"+plan_name+"即将在"+cls.start_time+"开课,请做好准备。" 
								}else if(end_time >= now && start_time <= now){
									//上课中
									text += "各位小伙伴们请注意啦,课程"+plan_name+"已经在"+cls.start_time+"开课了,预计到"+cls.end_time+"结束,还没有去上课的小伙伴请抓紧时间。" 
								}else{
									//课上完了
									text += "欢乐的时光总是过了那么快,我们的团课" +plan_name +"已经结束了,如果有什么意见或者建议,请告诉我们哦,欢迎下次再约。";
								}
						}
						playYuyin(text);
					});
				} else {
					error(data.rs);
				}

			}
		});
		
	});
	
	function playYuyin(text){
		if(text != ""){
			$("iframe[name=yuyin_iframe]").remove();
			var iframe = document.createElement("iframe");//IE可用
			iframe.name = 'yuyin_iframe'
				document.body.appendChild(iframe);
			$(iframe).hide();
			
			$(iframe).attr("src","http://tts.baidu.com/text2audio?lan=zh&pid=101&ie=UTF-8&text="+text+"&spd=5");
		}
	}
	
	function getemps(type,plan_list_id,plan_id){
		  var typeName="会员";
		  var lesson_time = $("#lesson_time").val();
		  var d = new Date(lesson_time.replace(/-/g,"/")); 
		  if(new Date().getTime() > d.getTime()){
			  alert("课程预约已经结束")
			  return;
		  }
		 top.dialog({
		        url: "partial/chioceMem.jsp?gym="+'<%=gym%>',
		        title: "选择"+typeName,
		        width: 920,
		        height: 430,
		        okValue: "确定",
		        ok: function() {
		        	var iframe = $(window.parent.document).contents().find("[name=" + top.dialog.getCurrent().id + "]")[0].contentWindow;
		            iframe.saveId(this);
		           var mem = store.getJson("mem");
		        var mem_id = mem.id;
		           order_lesson(mem_id,plan_list_id,plan_id);
		           store.set('mem',{});
		            return false;
		        },
		        cancelValue:"取消",
		        cancel:function(){
		        	return true;
		        }
		    }).showModal();
	}
</script>

<script type="text/javascript" src="partial/js/cashier.js"></script>
</head>
<style>
</style>
<body style="height: 100%;">
	<div class="popup-cont" style="width: 900px;height: 500px;overflow: auto;">
		<div class="toolbar-top">
			<div class="syllabusTime" style="width: 200px;">
				<span class="title">课程时间</span> <span class="syllabusWeekTime" id="lessonTime">星期一
					18:30-19:30</span>
					<input type="hidden" id="lesson_time"/>
			</div>
			<button onclick="showEditPlan('<%=plan_id %>')" class="btn btn-primary search-btn" name="editSyllabusInfo"
				style="margin-top: 0; float: right; width: 110px; border-color: #2282db; background-color: #eee; color: #4d4d4d;">修改课程信息</button>
			<button class="btn btn-primary search-btn" name="editSyllabusTime"
				onclick="showEditTime('<%=id %>')" style="margin-top: 0; float: right;">修改时间</button>
			<button type="button" id="yuyinButton" class="btn btn-default btn-sm" style="float: right;margin-right: 8px;">
				<span class="glyphicon glyphicon-volume-up"></span>
	        </button>
		</div>
		<div class="toolbar" style="height: 45px;">
			<button class="btn btn-primary search-btn" name="helpSub"
				style="margin-top: 0; float: left" onclick="getemps('mem','<%=id%>','<%=plan_id%>')">代约课</button>
			<input type="text" name="username" class="input-text width-150"
				placeholder="预约人" id="userName"> <input type="text" name="phone"
				class="input-text width-150" placeholder="手机号" id ="phone">
			<button class="btn btn-primary search-btn" name="submit"
				style="margin-top: 0" onclick="searchLesson('<%=id%>')">搜索</button>
		</div>
		<div style="margin: 15px;">
			<div name="checkTable" class="ctrl table-basic">
				<div class="table-header clearfix" style="display: none;">
					<div class="message"></div>
					<div
						class="pager-outer pager-head clearfix ctrl table-pager pull-right table-pager-input">
						<button class="btn btn-sm btn-first" disabled="disabled">
							<i class="fa fa-arrow-left"></i>
						</button>
						<button class="btn btn-sm btn-prev" disabled="disabled">
							<i class="fa fa-chevron-left"></i>
						</button>
						<span class="current"> <input class="page-index"
							type="number" value="0"> / <strong class="page-count">1</strong>
						</span>
						<button class="btn btn-sm btn-next" disabled="disabled">
							<i class="fa fa-chevron-right"></i>
						</button>
						<button class="btn btn-sm btn-last" disabled="disabled">
							<i class="fa fa-arrow-right"></i>
						</button>
					</div>
				</div>
				<table class="table table-list">
					<thead>
						<tr>
							<th col-key="insertTime"><strong>预约时间</strong></th>
							<!-- <th col-key="lurk"><strong>购课情况</strong></th> -->
							<th col-key="username"><strong>预约人</strong></th>
							<th col-key="phone"><strong>手机号</strong></th>
							<th col-key="personalTrainerCardName"><strong>私教卡</strong></th>
							<th col-key="status"><strong>当前状态</strong></th>
							<th col-key="action"><strong>操作</strong></th>
						</tr>
					</thead>
					<tbody style="font-size: 15px;" id="planDiv">
						
					</tbody>
				</table>
				<!-- <div class="table-footer clearfix">
					<span class="addpend-record">共1条记录</span>
					<div
						class="pager-outer pager-tail clearfix ctrl table-pager pull-right table-pager-input">
						<button class="btn btn-sm btn-first" disabled="disabled">
							<i class="fa fa-arrow-left"></i>
						</button>
						<button class="btn btn-sm btn-prev" disabled="disabled">
							<i class="fa fa-chevron-left"></i>
						</button>
						<span class="current"> <input class="page-index"
							type="number" value="0"> / <strong class="page-count">1</strong>
						</span>
						<button class="btn btn-sm btn-next" disabled="disabled">
							<i class="fa fa-chevron-right"></i>
						</button>
						<button class="btn btn-sm btn-last" disabled="disabled">
							<i class="fa fa-arrow-right"></i>
						</button>
					</div>
				</div> -->
			</div>
		</div>
	</div>
	<script type="text/html" id="planTpl">
                  <# if(list){
                      for(var i = 1;i<list.length;i++){
                  #>
					<tr>

				<td key="insertTime" class="align-center" style="width: 270px;"><#=list[i].start_time.substring(0,16)#></td>
<td key="insertTime" class="align-center" style="width: 200px;"><#=list[i].mem_name#></td>
<td key="insertTime" class="align-center" style="width: 200px;"><#=list[i].phone#></td>
<td key="insertTime" class="align-center" style="width: 200px;"><#=list[i].card_name || "不需要绑卡"#></td>
<td key="insertTime" class="align-center" style="width: 200px;">
	<#if(list[0].state == "001"){#>
						未上课
					<# }else if(list[0].state == "002"){#>
						已上课
					<#}else{#>
					正在上课
					<#}#>
					</td>

<td key="insertTime" class="align-center" style="width: 200px;">
	<#if(list[i].order_state == "001"){#>
	<button class="btn btn-sm" name="cancel" onclick="cancelYuYue('<#=list[i].id#>','<#=list[0].id#>')">取消预约</button>
					<# }else{#>
						已取消
					<#}#>
					</td>

</tr>
                  <# }}#>
            </script>
</body>
</html>