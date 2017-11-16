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

	Entity f_goods_type=(Entity)request.getAttribute("f_goods_type");
	boolean hasF_goods_type=f_goods_type!=null&&f_goods_type.getResultCount()>0;
%>
<!DOCTYPE HTML>
<html>
 <head>
  <jsp:include page="/public/edit_base.jsp" />
  <script type="text/javascript">
    var entity = "f_goods_type";
    var form_id = "f_goods_typeFormObj";
    var lockId=new UUID();
    $(document).ready(function() {

    //insert js

    });
  </script>
  <script type="text/javascript" charset="utf-8" src="pages/f_goods_type/f_goods_type.js"></script>
 </head>
<body>
	  <form class="l-form" id="f_goods_typeFormObj" method="post">
	    <input id="f_goods_type__id" name="f_goods_type__id" type="hidden" value='<%=hasF_goods_type?f_goods_type.getStringValue("id"):""%>'/>
	    <input id="f_goods_type__cust_name" name="f_goods_type__cust_name" type="hidden" value='<%=hasF_goods_type?f_goods_type.getStringValue("cust_name"):cust_name%>'/>
	    <input id="f_goods_type__gym" name="f_goods_type__gym" type="hidden" value='<%=hasF_goods_type?f_goods_type.getStringValue("gym"):gym%>'/>
	    <input id="f_goods_type__pid" name="f_goods_type__pid" type="hidden" value='<%=hasF_goods_type?f_goods_type.getStringValue("pid"):"-1"%>'/>
	    <ul>
	      <li style="width: 90px; text-align: left;">名称(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_goods_type__type_name" name="f_goods_type__type_name" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:true,validType:'length[0,200]'" value='<%=hasF_goods_type?f_goods_type.getStringValue("type_name"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	     <%--  <li style="width: 90px; text-align: left;">父分类：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createSelectBySql("f_goods_type__pid", "select id code,type_name note from f_goods_type where cust_name = '"+cust_name+"' and gym = '"+gym+"' and pid ='-1'" + (hasF_goods_type?" and id !='"+f_goods_type.getStringValue("id")+"'":""), hasF_goods_type?f_goods_type.getStringValue("pid"):"-1", false, "{'style':'width:164px'}") %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li> --%>
	      <li style="width: 90px; text-align: left;">排序(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input type="number" id="f_goods_type__sort" name="f_goods_type__sort" class="easyui-numberbox" style="width: 164px;" type="text" data-options="precision:0,required:true" value='<%=hasF_goods_type?f_goods_type.getStringValue("sort"):"0"%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	         <li style="width: 40px;"></li>
	   </ul>
	          <%if(hasF_goods_type){%>
	    <ul>      
	      <li style="width: 90px; text-align: left;">状态(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
		       <%=UI.createSelect("f_goods_type__state","PUB_C015",hasF_goods_type?f_goods_type.getStringValue("state"):"",true,"{'style':'width:164px'}") %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	          <% } else{ %>
	              <input id="f_goods_type__state" name="f_goods_type__state" type="hidden" value='<%=hasF_goods_type?f_goods_type.getStringValue("state"):"001"%>'/>
	          <%}%>	        	
	    <ul>
	       <li style="width: 470px; text-align: left;">
		        <div class="l-text" style="width: 468px;">
		        	<font color="red">(说明):排序数字越大在商品销售中的分类排序会越靠前</font>
		          <div class="l-text-l"></div>
		          <div class="l-text-r"></div>
		        </div>
		      </li>
		      <li style="width: 40px;"></li>
	    </ul>
	  </form>
 </body>
</html>