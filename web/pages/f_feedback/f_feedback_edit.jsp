<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.db.Entity"%>
<%@page import="com.jinhua.server.tools.UI"%>
<%@page import="com.jinhua.server.tools.UI_Op"%>
<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%

	FitUser user=(FitUser)SystemUtils.getSessionUser(request, response);
	if(user==null){ request.getRequestDispatcher("/").forward(request, response);}

	Entity f_feedback=(Entity)request.getAttribute("f_feedback");
	boolean hasF_feedback=f_feedback!=null&&f_feedback.getResultCount()>0;
	String gym = user.getViewGym();
%>
<!DOCTYPE HTML>
<html>
 <head>
  <jsp:include page="/public/edit_base.jsp" />
  <script type="text/javascript">
    var entity = "f_feedback";
    var form_id = "f_feedbackFormObj";
    var lockId=new UUID();
    $(document).ready(function() {

    //insert js

    });
  </script>
  <script type="text/javascript" charset="utf-8" src="pages/f_feedback/f_feedback.js"></script>
 </head>
<body>
	  <form class="l-form" id="f_feedbackFormObj" method="post">
	    <input id="f_feedback__id" name="f_feedback__id" type="hidden" value='<%=hasF_feedback?f_feedback.getStringValue("id"):""%>'/>
	    <input id="f_feedback__gym" name="f_feedback__gym" type="hidden" value='<%=hasF_feedback?f_feedback.getStringValue("gym"):""%>'/>
	    <input id="f_feedback__cust_name" name="f_feedback__cust_name" type="hidden" value='<%=hasF_feedback?f_feedback.getStringValue("cust_name"):""%>'/>
	    <ul>
	      <li style="width: 90px; text-align: left;">意见内容(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;height: 160px;">
	          <%=UI.createEditor("f_feedback__content",hasF_feedback?f_feedback.getStringValue("content"):"",true,new UI_Op("width:99%;height:150px;","")) %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">用户联系方式：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_feedback__mem_msg" name="f_feedback__mem_msg" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:false,validType:'length[0,100]'" value='<%=hasF_feedback?f_feedback.getStringValue("mem_msg"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	         <li style="width: 90px; text-align: left;">提交时间(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createDateTimeBox("f_feedback__create_date",hasF_feedback?f_feedback.getStringValue("create_date"):"",true,"width:164px;")%>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">是否处理(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createSelect("f_feedback__stete","PUB_C001",hasF_feedback?f_feedback.getStringValue("stete"):"",true,"{'style':'width:164px'}") %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	  </form>
 </body>
</html>