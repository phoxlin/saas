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

	Entity f_private_record=(Entity)request.getAttribute("f_private_record");
	boolean hasF_private_record=f_private_record!=null&&f_private_record.getResultCount()>0;
%>
<!DOCTYPE HTML>
<html>
 <head>
  <jsp:include page="/public/edit_base.jsp" />
  <script type="text/javascript">
    var entity = "f_private_record";
    var form_id = "f_private_recordFormObj";
    var lockId=new UUID();
    $(document).ready(function() {

    //insert js

    });
  </script>
  <script type="text/javascript" charset="utf-8" src="pages/f_private_record/f_private_record.js"></script>
 </head>
<body>
	  <form class="l-form" id="f_private_recordFormObj" method="post">
	    <input id="f_private_record__id" name="f_private_record__id" type="hidden" value='<%=hasF_private_record?f_private_record.getStringValue("id"):""%>'/>
	    <input id="f_private_record__cust_name" name="f_private_record__cust_name" type="hidden" value='<%=hasF_private_record?f_private_record.getStringValue("cust_name"):""%>'/>
	    <input id="f_private_record__gym" name="f_private_record__gym" type="hidden" value='<%=hasF_private_record?f_private_record.getStringValue("gym"):""%>'/>
	    <ul>
	      <li style="width: 90px; text-align: left;">会员(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_private_record__mem_id" name="f_private_record__mem_id" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:true,validType:'length[0,24]'" value='<%=hasF_private_record?f_private_record.getStringValue("mem_id"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">教练(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createSelectBySql("f_private_record__pt_id","select id code,name note from f_emp",hasF_private_record?f_private_record.getStringValue("pt_id"):"",true,"{'style':'width:164px'}") %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">确认人：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createSelectBySql("f_private_record__op_id","select id code,name note from f_emp",hasF_private_record?f_private_record.getStringValue("op_id"):"",false,"{'style':'width:164px'}") %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">确认时间：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createDateTimeBox("f_private_record__op_time",hasF_private_record?f_private_record.getStringValue("op_time"):"",false,"width:164px;")%>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">课程(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createSelectBySql("f_private_record__card_id","select id code,card_name note from F_card",hasF_private_record?f_private_record.getStringValue("card_id"):"",true,"{'style':'width:164px'}") %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">状态(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_private_record__state" name="f_private_record__state" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:true,validType:'length[0,100]'" value='<%=hasF_private_record?f_private_record.getStringValue("state"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">开始时间：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createDateTimeBox("f_private_record__start_time",hasF_private_record?f_private_record.getStringValue("start_time"):"",false,"width:164px;")%>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">结束时间：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createDateTimeBox("f_private_record__end_time",hasF_private_record?f_private_record.getStringValue("end_time"):"",false,"width:164px;")%>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">会员反馈：</li>
       <li style="width: 470px; text-align: left;">
	        <div class="l-text" style="width: 468px;height: 60px;">
	          <textarea id="f_private_record__comment" name="f_private_record__comment" class="easyui-validatebox"  style="width: 99%;height: 50px;"  data-options="required:false,validType:'length[0,1000]'" ><%=hasF_private_record?f_private_record.getStringValue("comment"):""%></textarea>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	  </form>
 </body>
</html>