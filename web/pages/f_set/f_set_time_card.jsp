<%@page import="com.jinhua.server.db.Entity"%>
<%@page import="com.jinhua.server.tools.UI"%>
<%@page import="com.jinhua.server.tools.UI_Op"%>
<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%

	User user=SystemUtils.getSessionUser(request, response);
	if(user==null){ request.getRequestDispatcher("/").forward(request, response);}

	Entity f_store=(Entity)request.getAttribute("f_store");
	boolean hasF_store=f_store!=null&&f_store.getResultCount()>0;
%>
<!DOCTYPE HTML>

<html>
<style>
.div1{
	
}
</style>
 <head>
  <jsp:include page="/public/edit_base.jsp" />

  <script type="text/javascript" charset="utf-8" src="pages/f_set/index.js"></script>
 </head>
<body>
	  <form class="l-form" id="f_set_time_card" method="post">
	   <div class="main">
			<div class="menu-container">
				<div class="menus">
					<div class="div1">
						<span>最长请假天数</span><input type="text" value="" id="leaveDays" />天
						<p>拥有时间卡的会员，在其有效时间内可请假总天数的上限。</p>
					</div>
					<div class="div1">
						<span>最短请假天数</span><input type="text" value="" id="lessLeaveDays" />天
						<input type="checkbox" id="aci" name="aci"/>前台可根据具体情况选择最晚期限或操作当天
						<p>拥有时间卡的会员，在其有效时间内一次请假的最少天数。</p>
					</div>
					<div class="div1">
						<span>最晚开卡期限</span><input type="text" value="" id="leaveDays" />天
						<p>拥有时间卡的会员，必须在该期限内开卡；</p>
<p>如果超过该期限仍未开卡，开卡时会将该会员的时间卡设置为他的最晚开卡时间。</p>
					</div>
					<div class="div1">
						<span>最短请假天数</span><input type="text" value="" id="leaveDays" />天
						<input type="radio" id="index0" name="record" value="0"/>开启
						<input type="radio" id="index1" name="record" value="1"/>关闭
						<p>关闭此功能，会员将不能在APP和微信中查看自己的充值记录和消费记录</p>
					</div>
				</div>
			</div>
		</div>
	  </form>
 </body>
 
</html>