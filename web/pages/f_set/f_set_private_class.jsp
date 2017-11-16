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
.div1{
	float:left;
}
#f_set_private input{
	margin-left: 15px;
}
p{
    margin-left: 82px;
}
</style>
</head>
<body>
	 <form id="f_set_private" method="post" >
	 <div class="div1">
	 <span>私教运营时段</span>
	 </div>
	 	<div class="div1">
	 	<input type="time" name="start-time" id="start-time" value="08:00"/>
	 	<span>至</span>
	 	<input type="time" name="end-time" id="end-time" value="21:00"/>
	 	<p class="help-block" style="margin-left: 0px;">俱乐部用户可以预约的私人教练的时间段。</p>
	 	</div>
	 <div class="div1">
	 
	 <span>APP消课确认机制</span>
	 	<label><input type="radio" name="checkType" id="index0" value="3"/>三方确认</label>
	 	<label><input type="radio" name="checkType" id="index1"value="2" checked="checked"/>两方确认</label>
	 	<p class="help-block">三方确认,需要教练，会员，前台三方确认，两方确认只需要教练和会员确认</p>
	 	</div>
	 	
	 <div class="div1">
	 
	 <span>前台消课指纹验证</span>
	 	<label><input type="radio" name="needFingerPrint" id="needFingerPrint1" value="Y"/>需要</label>
	 	<label><input type="radio" name="needFingerPrint" id="needFingerPrint2"value="N" checked="checked"/>不需要</label>
	 	<p class="help-block">前台消课是否需要验证会员的指纹.</p>
	 	</div>
	 	
<!-- 	 <div class="div1"> -->
<!-- 	 <span>延迟评价</span> -->
<!-- 	 	<input type="number" name="delay" id="delay" value="1"/>分钟 -->
<!-- 	 	<p class="help-block">输入延迟分钟数，系统会在会员确认私教课消次后，延迟若干分钟向会员发出评价邀请</p> -->
<!-- 	 	<p class="help-block">输入0或小于0时，则关闭此功能</p> -->
<!-- 	 	</div> -->
<!-- 	 	<div class="div1"> -->
<!-- 	 <span>私教卡确认机制</span> -->
<!-- 	 	<input type="radio" name="coachType" id="coachMany" value="2" checked="checked"/>一对多<span style="color: #737373;">&nbsp;会员可同时绑定多个私教</span> -->
<!-- 	 	<input type="radio" name="coachType" id="coachOne" value="1"/>一对一<span style="color: #737373;">&nbsp;会员可同时绑定一个私教</span> -->
	 	
<!-- 	 	</div> -->
	 </form>
</body>
<script type="text/javascript">
	
</script>

</html>
