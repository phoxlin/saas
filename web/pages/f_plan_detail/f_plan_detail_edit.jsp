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

	Entity f_plan_detail=(Entity)request.getAttribute("f_plan_detail");
	boolean hasF_plan_detail=f_plan_detail!=null&&f_plan_detail.getResultCount()>0;
%>
<!DOCTYPE HTML>
<html>
 <head>
  <jsp:include page="/public/edit_base.jsp" />
  <script type="text/javascript">
    var entity = "f_plan_detail";
    var form_id = "f_plan_detailFormObj";
    var lockId=new UUID();
    $(document).ready(function() {

    //insert js

    });
  </script>
  <script type="text/javascript" charset="utf-8" src="pages/f_plan_detail/f_plan_detail.js"></script>
 </head>
<body>
	  <form class="l-form" id="f_plan_detailFormObj" method="post">
	    <ul>
	      <li style="width: 90px; text-align: left;">id(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_plan_detail__id" name="f_plan_detail__id" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:true,validType:'length[0,24]'" value='<%=hasF_plan_detail?f_plan_detail.getStringValue("id"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">gym(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_plan_detail__gym" name="f_plan_detail__gym" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:true,validType:'length[0,50]'" value='<%=hasF_plan_detail?f_plan_detail.getStringValue("gym"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">cust_name(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_plan_detail__cust_name" name="f_plan_detail__cust_name" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:true,validType:'length[0,50]'" value='<%=hasF_plan_detail?f_plan_detail.getStringValue("cust_name"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">排课明细id(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_plan_detail__plan_list_id" name="f_plan_detail__plan_list_id" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:true,validType:'length[0,24]'" value='<%=hasF_plan_detail?f_plan_detail.getStringValue("plan_list_id"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">星期：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_plan_detail__week" name="f_plan_detail__week" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:false,validType:'length[0,24]'" value='<%=hasF_plan_detail?f_plan_detail.getStringValue("week"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">开始时间：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createDateTimeBox("f_plan_detail__statr_time",hasF_plan_detail?f_plan_detail.getStringValue("statr_time"):"",false,"width:164px;")%>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">结束：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createDateTimeBox("f_plan_detail__end_time",hasF_plan_detail?f_plan_detail.getStringValue("end_time"):"",false,"width:164px;")%>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	  </form>
 </body>
</html>