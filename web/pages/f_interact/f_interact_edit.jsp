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

	Entity f_interact=(Entity)request.getAttribute("f_interact");
	boolean hasF_interact=f_interact!=null&&f_interact.getResultCount()>0;
	Entity f_interact_pic=(Entity)request.getAttribute("f_interact_pic");
	boolean hasF_interact_pic=f_interact_pic!=null&&f_interact_pic.getResultCount()>0;
%>
<!DOCTYPE HTML>
<html>
 <head>
  <jsp:include page="/public/edit_base.jsp" />
  <script type="text/javascript">
    var entity = "f_interact";
    var form_id = "f_interactFormObj";
    var lockId=new UUID();
    $(document).ready(function() {

    //insert js

    });
  </script>
  <script type="text/javascript" charset="utf-8" src="pages/f_interact/f_interact.js"></script>
 </head>
<body>
	  <form class="l-form" id="f_interactFormObj" method="post">
          <input id="f_interact__id" name="f_interact__id" type="hidden" value='<%=hasF_interact?f_interact.getStringValue("id"):""%>'/>
          <input id="f_interact__cust_name" name="f_interact__cust_name" type="hidden" value='<%=hasF_interact?f_interact.getStringValue("cust_name"):""%>'/>
          <input id="f_interact__gym" name="f_interact__gym" type="hidden" value='<%=hasF_interact?f_interact.getStringValue("gym"):""%>'/>
	    <ul>
	      <li style="width: 90px; text-align: left;">发布者(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_interact__user_name" name="f_interact__user_name" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:true,validType:'length[0,24]'" value='<%=hasF_interact?f_interact.getStringValue("user_name"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">可见范围(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	        	<%=UI.createSelect("f_interact__auth_type", "INTERACT_AUTH_TYPE", hasF_interact?f_interact.getStringValue("auth_type"):"", true, "{'style':'width:164px'}") %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      </ul>
	      <ul>
	      <li style="width: 90px; text-align: left;">发布时间(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createDateTimeBox("f_interact__release_time",hasF_interact?f_interact.getStringValue("release_time"):"",true,"width:164px;")%>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">点赞数：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_interact__g_num" name="f_interact__g_num" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:true,validType:'length[0,24]'" value='<%=hasF_interact?f_interact.getStringValue("g_num"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">内容：</li>
       <li style="width: 470px; text-align: left;">
	        <div class="l-text" style="width: 468px;height: 100px;">
	          <textarea id="f_interact__content" name="f_interact__content" class="easyui-validatebox"  style="width: 99%;height: 50px;resize: none;"  data-options="required:false,validType:'length[0,65000]'" ><%=hasF_interact?f_interact.getStringValue("content"):""%></textarea>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">图片：</li>
       	<li style="width: 470px; text-align: left;">
	        <div class="l-text" style="width: 468px;height: 60px;">
	        	<%
	        		if(hasF_interact_pic){
	        			for(int i=0; i<f_interact_pic.getMaxResultCount(); i++){
	        	%>
	        		<img src="<%=f_interact_pic.getStringValue("pic_link", i) %>" style="max-width: 200px;"/>
	        	<%
	        			}
	        		}
	        	%>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	  </form>
 </body>
</html>