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
	String cust_name = user.getCust_name();
	String gym = user.getViewGym();
	
	Entity f_store=(Entity)request.getAttribute("f_store");
	boolean hasF_store=f_store!=null&&f_store.getResultCount()>0;
%>
<!DOCTYPE HTML>
<html>
 <head>
  <jsp:include page="/public/edit_base.jsp" />
  <script type="text/javascript">
    var entity = "f_store";
    var form_id = "f_storeFormObj";
    var lockId=new UUID();
    $(document).ready(function() {

    //insert js

    });
  </script>
  <script type="text/javascript" charset="utf-8" src="pages/f_store/f_store.js"></script>
 </head>
<body>
	  <form class="l-form" id="f_storeFormObj" method="post">
	  <input type="hidden" name="f_store__id" value="<%=hasF_store?f_store.getStringValue("id"):"" %>">
	  <input type="hidden" name="f_store__cust_name" value="<%=hasF_store?f_store.getStringValue("cust_name"):cust_name %>">
	  <input type="hidden" name="f_store__gym" value="<%=hasF_store?f_store.getStringValue("gym"):gym %>">
	  <input type="hidden" name="f_store__pid" value="<%=hasF_store?f_store.getStringValue("pid"):"-1" %>"/>
	  <ul>
	      <li style="width: 90px; text-align: left;">仓库名称(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_store__store_name" name="f_store__store_name" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:true,validType:'length[0,200]'" value='<%=hasF_store?f_store.getStringValue("store_name"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      
	  <%if(hasF_store){ %>
	      <li style="width: 90px; text-align: left;">状态(*)：</li>
      	  <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createSelect("f_store__state", "PUB_C015", hasF_store?f_store.getStringValue("state"):"", true, "{'style':'width:168px'}") %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	  <%}else{ %>    
		  <input type="hidden" name="f_store__state" value="<%=hasF_store?f_store.getStringValue("state"):"001" %>"/>
	  <%} %>
	    <%-- <ul>
	       <li style="width: 90px; text-align: left;">父仓库(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createSelectBySql("f_store__pid", "select id code,store_name note from f_store where cust_name ='"+cust_name+"' and gym = '"+gym+"' and pid = '-1'" + (hasF_store?" and id !='"+f_store.getStringValue("id")+"'":""), hasF_store?f_store.getStringValue("pid"):"", false, "{'style':'width:168px'}")%>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul> --%>
	  </form>
 </body>
</html>