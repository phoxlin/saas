<%@page import="com.mingsokj.fitapp.utils.GymUtils"%>
<%@page import="java.util.Map"%>
<%@page import="com.mingsokj.fitapp.utils.MemUtils"%>
<%@page import="com.jinhua.server.c.Codes"%>
<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="com.jinhua.server.c.Code"%>
<%@page import="com.jinhua.server.db.Entity"%>
<%@page import="com.jinhua.server.db.impl.EntityImpl"%>
<%@page import="com.jinhua.server.db.DBUtils"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.jinhua.server.db.impl.DBM"%>
<%@page import="com.jinhua.server.db.IDB"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%
	FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
	String gym = user.getViewGym();
	String cust_name = user.getCust_name();

	String fk_user_gym = request.getParameter("fk_user_gym");
	String buy_card_id = request.getParameter("buy_card_id");
	String fk_user_id = request.getParameter("fk_user_id");

	String msg = "";
	Integer useable_times = 0;
	String leave_unit_price="0";
	int leave_unit = 0;

		Map<String, Object> cardMap = MemUtils.getMemCardsById(buy_card_id, fk_user_id, cust_name, gym);
		if(cardMap != null){
			String  lu = cardMap.get("leave_unit")+"";
			if(lu != null&&!"null".equals(lu)){
			  leave_unit = Integer.parseInt(lu);
			}
			 leave_unit_price = cardMap.get("leave_unit_price")+"";
			if ( leave_unit == 0 || leave_unit_price == null || "".equals(leave_unit_price)) {
				msg="该会员卡还没有设置请假时间周期\\价格";
			}
			String leave_free_times = cardMap.get("leave_free_times")+"";
			if("null".equals(leave_free_times)||"".equals(leave_free_times)){
				leave_free_times="0";
			}
			
			String leave_times = cardMap.get("leave_times")+"";
			if("null".equals(leave_times)||"".equals(leave_times)){
				leave_times="0";
			}
			useable_times = Integer.parseInt(leave_free_times) -  Integer.parseInt(leave_times);
			
		}else{
			msg="该会员卡不存在,无法请假";
		}

		
%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<link rel="stylesheet" type="text/css" href="public/sb_admin2/bower_components/bootstrap/dist/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="partial/css/addMem.css">
<link rel="stylesheet" type="text/css" href="public/fit/css/btn.css">
<script src="public/js/store.js"></script>
<script src="public/sb_admin2/bower_components/jquery/dist/jquery.min.js"></script>
<script type="text/javascript" charset="utf-8" src="public/js/template.js"></script>
<script type="text/javascript" charset="utf-8" src="partial/js/pay.js"></script>
<title>请假</title>
<script type="text/javascript">
var leave_unit_price = '<%=leave_unit_price%>';
function formatDate(date) {
	  var d = new Date(date),
	    month = '' + (d.getMonth() + 1),
	    day = '' + d.getDate(),
	    year = d.getFullYear();
	 
	  if (month.length < 2) month = '0' + month;
	  if (day.length < 2) day = '0' + day;
	 
	  return [year, month, day].join('-');
	}

 function doLeave(win, window,fk_user_id,fk_user_gym,card_id){
	 
	 <%if (!"".equals(msg)) {%>
	 window.location.reload();
		 return;
	 <%}%>
	 
	 var startTime = $("#startTime").val();
	 var endTimes = $("#endTimes").val();
	 var fee = $("#fee").val();
	 var remark = $("#remark").val();
	 if(!startTime){
		 alert("开始时间不能为空");
		 return;
	 }
	 if(!endTimes){
		 alert("结束时间不能为空");
		 return;
	 }
	 if(startTime>endTimes){
		 alert("结束时间不能小于开始时间");
		 return;
	 }
	 var f = $("#free").is(":checked");
	 
	 var leave_num = $("#leave_num").val();
	 
	 
	 var data={
				title:"请假收费",
				flow : "com.mingsokj.fitapp.flow.impl.请假Flow",
				userType:"mem",//消费对象，会员【mem】，员工【emp】，匿名消费【anonymous】
				userId : fk_user_id,//消费对象id，如果是匿名的就为-1
				//////////////////////上面参数为必填参数/////////////////////////////////////////////
				
				caPrice : fee,
				
				card_id : card_id,
				 fk_user_id : fk_user_id,
		         fk_user_gym : fk_user_gym,
		         leave_num : leave_num,
		         startTime : startTime,
		         endTimes : endTimes,
		         fee : fee,
		         remark : remark,
		         buy_card_id:'<%=buy_card_id%>',
		         is_free:f,
		         gymName : '<%=GymUtils.getGymName(user.getViewGym())%>',
		 		 emp_name : '<%=user.getLoginName()%>'
		};

		showPay(data, function() {
			alert("请假成功");
			setTimeout(function() {
				window.location.reload();
			}, 1000);
		});

	}

	function calMoney() {
		var start_time = $("#startTime").val();
		var end_time = $("#endTimes").val();
		var leave_num = $("#leave_num").val();
		var unit = $("#leave_unit").val();
		if (start_time && leave_num) {
			var start = new Date(start_time.replace(/"-"/g, "/") + " 00:00:00");
			var t = start.getTime() + leave_num * unit * 24 * 3600 * 1000;
			var e = new Date(t)
			var end = formatDate(e);
			$("#endTimes").val(end);
			var price = leave_unit_price * leave_num;
			var f = $("#free").is(":checked");
			if (f) {
				$("#fee").val(0);
			} else {
				$("#fee").val(price);
			}
		}
	}
</script>
</head>
<body>
	<%
		if (!"".equals(msg)) {
	%>
	<div class="user-basic-info">
		<p><%=msg%></p>
		<p>需要前往卡种管理设置</p>
	</div>
	<%
		} else {
	%>
	<div class="user-basic-info">
		<div class="container">
			<div class="col-xs-6">
				<div class="input-panel">
					<label>请假周期</label> <input type="number" min="1" id="leave_num" onkeyup="calMoney()" />
				</div>
				<p>实际请假天数为请假数量*该会员卡设置的请假单位</p>
			</div>
			<div class="col-xs-6">
				<div class="input-panel">
					<input type="hidden" id="leave_unit" value="<%=leave_unit%>"> <label>当前单位</label> 
					<input disabled="disabled" value="<%=Codes.note("DATE_UNIT",leave_unit+"")%>" type="text" />

				</div>
				<p>&nbsp;</p>
			</div>
			<div class="col-xs-6">
				<div class="input-panel">
					<label>开始时间</label> <input type="date" id="startTime" onchange="calMoney()" />
				</div>
			</div>
			<div class="col-xs-6">
				<div class="input-panel">
					<label>结束时间</label> <input disabled="disabled" type="date" id="endTimes" />
				</div>
			</div>
			<div class="col-xs-6">
				<div class="input-panel">
					<label>应收金额</label> <input type="text" id="fee" readonly="readonly"/>
				</div>
				<p>请输入会员请假所收取的金额</p>
			</div>
			<div class="col-xs-6">
				<div class="input-panel">
					<%-- <label>免费次数:<%=useable_times %></label><%if(useable_times>0){ %><span><input type="checkbox" id="free"  style="width: 40px" />免费请假</span><%} %>
 --%>
					<%
						if (useable_times > 0) {
					%><label>免费请假</label> <input type="checkbox" id="free" onclick="calMoney()" />
					<%
						}
					%>
				</div>
				<p>
					<%
						if (useable_times > 0) {
					%>当前会员卡剩余免费请假次数:<%=useable_times%>
					<%
						}
					%>
				</p>
			</div>
			<div class="col-xs-12">
				<div class="input-panel">
					<textarea id="remark"></textarea>
				</div>
				<p>可在此备注会员请假原因等信息</p>
			</div>
		</div>
	</div>
	<%
		}
	%>

</body>
</html>