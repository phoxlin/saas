<%@page import="com.jinhua.server.db.Entity"%>
<%@page import="com.jinhua.server.tools.UI"%>
<%@page import="com.jinhua.server.tools.UI_Op"%>
<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	User user = SystemUtils.getSessionUser(request, response);
	if (user == null) {
		request.getRequestDispatcher("/").forward(request, response);
	}

	Entity f_store = (Entity) request.getAttribute("f_store");
	boolean hasF_store = f_store != null && f_store.getResultCount() > 0;
	String type = request.getParameter("type");
%>
<!DOCTYPE HTML>

<html>
<jsp:include page="/public/base.jsp" />
<link rel="stylesheet" media="all"
	href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/public/css/bootstrap.min.css" />
<script type="text/javascript" charset="utf-8"
	src="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/public/js/bootstrap.min.js">
	
</script>
<head>


<script type="text/javascript" charset="utf-8"
	src="pages/f_set/index.js"></script>
<style>
.div1 input {
	margin-left: 10px;
}

.div1 label {
	cursor: pointer;
}
</style>
</head>
<body>
	<p style="color: #919191;">勾选设置需要打印的参数，如未设置则全部打印</p>
	<%
		if (type.equals("001")) {
	%>
	<form id="f_set_print001" method="post"
		class="horizontal-form clib-style-type">
		<h3>会员信息</h3>
		<div class="div1">
			<label> <input type="checkbox" name="memMsg" value="mem_name"
				id="mem_name" />会员姓名
			</label> <label> <input type="checkbox" name="memMsg" value="sex"
				id="sex" />性别
			</label> <label> <input type="checkbox" name="memMsg" value="phone"
				id="phone" />手机号
			</label> <label> <input type="checkbox" name="memMsg"
				value="birthday" id="birthday" />出生日期
			</label> <label> <input type="checkbox" name="memMsg" value="mem_no"
				id="mem_no" />会员卡号
			</label> <label> <input type="checkbox" name="memMsg" value="id_card"
				id="id_card" />身份证号码
			</label> <label> <input type="checkbox" name="memMsg"
				value="create_time" id="create_time" />入会时间
			</label> <label> <input type="checkbox" name="memMsg" value="mc_id"
				id="mc_id" />会籍顾问
			</label>
		</div>
		<h3>卡信息</h3>
		<div class="div1">
			<label> <input type="checkbox" name="cardMsg"
				value="card_name" id="card_name" />卡名称
			</label> <label> <input type="checkbox" name="cardMsg" value="days"
				id="days" />有效天数
			</label> <label> <input type="checkbox" name="memMsg"
				value="deadline" id="deadline" />到期时间
			</label> <label> <input type="checkbox" name="memMsg"
				value="active_time" id="active_time" />开卡时间
			</label> <label> <input type="checkbox" name="memMsg"
				value="buy_time" id="buy_time" />充值时间
			</label> <label> <input type="checkbox" name="memMsg"
				value="real_amt" id="real_amt" />实收金额
			</label>
			<label> <!-- <input type="checkbox" name="memMsg"
				value="card_deposit_amt,card_deposit_amt1,card_deposit_amt2,card_deposit_amt3" id="card_deposit_amt" />发卡押金 -->
				<input type="checkbox" name="memMsg"
				value="card_deposit_amt" id="card_deposit_amt" />发卡押金
			</label> 
			<label> <input type="checkbox" name="memMsg"
				value="give_days,give_times,give_amt" id="give_days" />赠品
			</label>
			<label> <input type="checkbox" name="cardMsg"
				value="leave_free_times" id="leave_free_times" />免费请假次数
			</label>
			<label> <input type="checkbox" name="memMsg"
				value="u.remark" id="u_remark" />备注
			</label>
		</div>
	</form>
	<%
		} else if (type.equals("006")) {
	%>
	<form id="f_set_print006" method="post"
		class="horizontal-form clib-style-type">
		<h3>会员信息</h3>
		<div class="div1">
			<label> <input type="checkbox" name="memMsg" value="mem_name"
				id="mem_name" />会员姓名
			</label> <label> <input type="checkbox" name="memMsg" value="sex"
				id="sex" />性别
			</label> <label> <input type="checkbox" name="memMsg" value="phone"
				id="phone" />手机号
			</label> <label> <input type="checkbox" name="memMsg"
				value="birthday" id="birthday" />出生日期
			</label> <label> <input type="checkbox" name="memMsg" value="mem_no"
				id="mem_no" />会员卡号
			</label> <label> <input type="checkbox" name="memMsg" value="id_card"
				id="id_card" />身份证号码
			</label> <label> <input type="checkbox" name="memMsg"
				value="create_time" id="create_time" />入会时间
			</label> 
			<label> <input type="checkbox" name="memMsg" value="mc_id"
				id="mc_id" />会籍顾问
			</label>
			<label> <input type="checkbox" name="memMsg" value="pt_id"
				id="pt_id" />私教教练
			</label>
		</div>
		<h3>卡信息</h3>
		<div class="div1">
			<label> <input type="checkbox" name="cardMsg"
				value="card_name" id="card_name" />私教卡卡名称
			</label> <label> <input type="checkbox" name="cardMsg" value="days"
				id="days" />有效天数
			</label> <label> <input type="checkbox" name="cardMsg"
				value="buy_times" id="buy_times" />有效课数
			</label> <label> <input type="checkbox" name="memMsg"
				value="deadline" id="deadline" />到期时间
			</label> <label> <input type="checkbox" name="memMsg"
				value="active_time" id="active_time" />开卡时间
			</label> <label> <input type="checkbox" name="memMsg"
				value="buy_time" id="buy_time" />充值时间
			</label> <label> <input type="checkbox" name="memMsg"
				value="real_amt" id="real_amt" />实收金额
			</label>
			<label> <input type="checkbox" name="cardMsg"
				value="leave_free_times" id="leave_free_times" />免费请假次数
			</label>
			<label> <input type="checkbox" name="memMsg"
				value="give_days,give_times,give_amt" id="give_days" />赠品
			</label>
			<label><!--  <input type="checkbox" name="memMsg"
				value="card_deposit_amt,card_deposit_amt1,card_deposit_amt2,card_deposit_amt3" id="card_deposit_amt" />发卡押金
			</label> --> 
			<input type="checkbox" name="memMsg"
				value="card_deposit_amt" id="card_deposit_amt" />发卡押金
			</label> 
			<label> <input type="checkbox" name="memMsg"
				value="u.remark" id="u_remark" />备注
			</label>
		</div>
	</form>
	<%
		} else if (type.equals("003")) {
	%>
	<form id="f_set_print003" method="post"
		class="horizontal-form clib-style-type">
		<h3>会员信息</h3>
		<div class="div1">
			<label> <input type="checkbox" name="memMsg" value="mem_name"
				id="mem_name" />会员姓名
			</label> <label> <input type="checkbox" name="memMsg" value="sex"
				id="sex" />性别
			</label> <label> <input type="checkbox" name="memMsg" value="phone"
				id="phone" />手机号
			</label> <label> <input type="checkbox" name="memMsg"
				value="birthday" id="birthday" />出生日期
			</label> <label> <input type="checkbox" name="memMsg" value="mem_no"
				id="mem_no" />会员卡号
			</label> <label> <input type="checkbox" name="memMsg" value="id_card"
				id="id_card" />身份证号码
			</label> <label> <input type="checkbox" name="memMsg"
				value="create_time" id="create_time" />入会时间
			</label> <label> <input type="checkbox" name="memMsg" value="mc_id"
				id="mc_id" />会籍顾问
			</label>
			<label> <input type="checkbox" name="cardMsg"
				value="leave_free_times" id="leave_free_times" />免费请假次数
			</label>
		</div>
		<h3>卡信息</h3>
		<div class="div1">
			<label> <input type="checkbox" name="cardMsg"
				value="card_name" id="card_name" />卡名称
			</label> <label> <input type="checkbox" name="cardMsg" value="days"
				id="days" />有效天数
			</label> <label> <input type="checkbox" name="cardMsg" value="times"
				id="times" />有效次数
			</label> <label> <input type="checkbox" name="memMsg"
				value="deadline" id="deadline" />到期时间
			</label> <label> <input type="checkbox" name="memMsg"
				value="active_time" id="active_time" />开卡时间
			</label> <label> <input type="checkbox" name="memMsg"
				value="buy_time" id="buy_time" />充值时间
			</label> <label> <input type="checkbox" name="memMsg"
				value="real_amt" id="real_amt" />实收金额
			</label>
			<label> <input type="checkbox" name="memMsg"
				value="give_days,give_times,give_amt" id="give_days" />赠品
			</label>
			<label><!--  <input type="checkbox" name="memMsg"
				value="card_deposit_amt,card_deposit_amt1,card_deposit_amt2,card_deposit_amt3" id="card_deposit_amt" />发卡押金 -->
				<input type="checkbox" name="memMsg"
				value="card_deposit_amt" id="card_deposit_amt" />发卡押金
			</label> 
			<label> <input type="checkbox" name="memMsg"
				value="u.remark" id="u_remark" />备注
			</label>
		</div>
	</form>
	<%
		} else if (type.equals("002")) {
	%>
	<form id="f_set_print002" method="post"
		class="horizontal-form clib-style-type">
		<h3>会员信息</h3>
		<div class="div1">
			<label> <input type="checkbox" name="memMsg" value="mem_name"
				id="mem_name" />会员姓名
			</label> <label> <input type="checkbox" name="memMsg" value="sex"
				id="sex" />性别
			</label> <label> <input type="checkbox" name="memMsg" value="phone"
				id="phone" />手机号
			</label> <label> <input type="checkbox" name="memMsg"
				value="birthday" id="birthday" />出生日期
			</label> <label> <input type="checkbox" name="memMsg" value="mem_no"
				id="mem_no" />会员卡号
			</label> <label> <input type="checkbox" name="memMsg" value="id_card"
				id="id_card" />身份证号码
			</label> <label> <input type="checkbox" name="memMsg"
				value="create_time" id="create_time" />入会时间
			</label> <label> <input type="checkbox" name="memMsg" value="mc_id"
				id="mc_id" />会籍顾问
			</label>
		</div>
		<h3>卡信息</h3>
		<div class="div1">
			<label> <input type="checkbox" name="cardMsg"
				value="card_name" id="card_name" />卡名称
			</label> <label> <input type="checkbox" name="cardMsg" value="days"
				id="days" />有效天数
			</label> <label> <input type="checkbox" name="cardMsg" value="amt"
				id="amt" />储值金额
			</label> <label> <input type="checkbox" name="memMsg"
				value="deadline" id="deadline" />到期时间
			</label> <label> <input type="checkbox" name="memMsg"
				value="active_time" id="active_time" />开卡时间
			</label> <label> <input type="checkbox" name="memMsg"
				value="buy_time" id="buy_time" />充值时间
			</label> <label> <input type="checkbox" name="memMsg"
				value="real_amt" id="real_amt" />实收金额
			</label>
			<label> <!-- <input type="checkbox" name="memMsg"
				value="card_deposit_amt,card_deposit_amt1,card_deposit_amt2,card_deposit_amt3" id="card_deposit_amt" />发卡押金 -->
				<input type="checkbox" name="memMsg"
				value="card_deposit_amt" id="card_deposit_amt" />发卡押金
			</label> 
			<label> <input type="checkbox" name="memMsg"
				value="give_days,give_times,give_amt" id="give_days" />赠品
			</label>
			<label> <input type="checkbox" name="memMsg"
				value="u.remark" id="u_remark" />备注
			</label>
		</div>
	</form>
	<%
		}
	%>
</body>
<script type="text/javascript">
$(function() {
	$.ajax({
		type : "POST",
		url : "fit-action-gym-getPrintSet",
		data : {
			type : '<%=type%>',
			},
			dataType : "json",
			async : false,
			success : function(data) {
				if (data.rs == "Y") {
					var printCardMsg = data.listCard;
					var printMemMsg = data.listMem;
					if (printCardMsg.length > 0) {
						for (var i = 0; i < printCardMsg.length; i++) {
							$("#"+printCardMsg[i]).attr("checked","checked");
						}
					}
					if (printMemMsg.length > 0) {
						for (var i = 0; i < printMemMsg.length; i++) {
							if(printMemMsg[i] =="u.remark"){
								$("#u_remark").attr("checked","checked");
							}
							$("#"+printMemMsg[i]).attr("checked","checked");
						}
					}

				} else {
					error(data.rs);
				}

			}

		});

	});
</script>

</html>
