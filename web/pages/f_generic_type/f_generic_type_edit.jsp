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
	String table_name = request.getParameter("table_name");

	Entity f_generic_type=(Entity)request.getAttribute("f_generic_type");
	boolean hasF_generic_type=f_generic_type!=null&&f_generic_type.getResultCount()>0;
	
	if("sm".equals(user.getState())){
		cust_name = "-1";
		gym = "-1";
	}
%>
<!DOCTYPE HTML>
<html>
 <head>
  <jsp:include page="/public/edit_base.jsp" />
  <script type="text/javascript">
    var entity = "f_generic_type";
    var form_id = "f_generic_typeFormObj";
    var lockId=new UUID();
    $(document).ready(function() {

    //insert js

    });
  </script>
  <script type="text/javascript" charset="utf-8" src="pages/f_generic_type/f_generic_type.js"></script>
 </head>
<body>
	  <form class="l-form" name="f_generic_typeFormObj" id="f_generic_typeFormObj" method="post">
	    <input id="f_generic_type__id" name="f_generic_type__id" type="hidden" value='<%=hasF_generic_type?f_generic_type.getStringValue("id"):""%>'/>
	    <input id="f_generic_type__cust_name" name="f_generic_type__cust_name" type="hidden" value='<%=hasF_generic_type?f_generic_type.getStringValue("cust_name"):cust_name%>'/>
	    <input id="f_generic_type__gym" name="f_generic_type__gym" type="hidden" value='<%=hasF_generic_type?f_generic_type.getStringValue("gym"):gym%>'/>
	    <input id="f_generic_type__table_name" name="f_generic_type__table_name" type="hidden" value='<%=hasF_generic_type?f_generic_type.getStringValue("table_name"):table_name%>'/>
	    <ul>
	      <li style="width: 90px; text-align: left;">类型(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_generic_type__type" name="f_generic_type__type" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:true,validType:'length[0,100]'" value='<%=hasF_generic_type?f_generic_type.getStringValue("type"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">排序(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_generic_type__sort" name="f_generic_type__sort" class="easyui-numberbox" style="width: 164px;" type="text" data-options="precision:0,required:true" value='<%=hasF_generic_type?f_generic_type.getStringValue("sort"):"0"%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">状态(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createSelect("f_generic_type__state", "PUB_C015", hasF_generic_type?f_generic_type.getStringValue("state"):"001", true, "{'style':'width:164px'}") %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	       <li style="width: 270px; text-align: left;">说明:排序数值越大该类型的文章越靠前</li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <%if("f_article".equals(table_name)){ 
	    	String other = hasF_generic_type?f_generic_type.getStringValue("other"):"";
	    %>
	    <ul>
	    <li style="width: 90px; text-align: left;">微信显示位置(*)：</li>
	    	<%//cust_name的账号登录的
    		if("sm".equals(user.getState())){
    		%>
	    	<li><label><input type="radio" onclick="showPic('s2')" <%if("s2".equals(other)){ %> checked="checked" <%} %> name="f_generic_type__other" value="s2">全局样式一</label>
	    	<li style="width: 80px;"></li>
	    	<li><label><input type="radio" onclick="showPic('s4')" <%if("s3".equals(other)){ %> checked="checked" <%} %> name="f_generic_type__other" value="s3">全局样式二</label>
	    	<li style="width: 80px;"></li>
	    	<%}else{ %>
	    	<li><label><input type="radio" onclick="showPic('s1')" <%if("s1".equals(other)){ %> checked="checked" <%} %> name="f_generic_type__other" value="s1">俱乐部专题</label>
	    	<li style="width: 80px;"></li>
	    	<li><label><input type="radio" onclick="showPic('s4')" <%if("s4".equals(other)){ %> checked="checked" <%} %> name="f_generic_type__other" value="s4">俱乐部动态</label>
	    	<li style="width: 80px;"></li>
	    	<%} %>
	    
	    </ul>
	    <ul <%if(!"s1".equals(other)){ %> style="display: none" <%} %> id="s1">
	    	<li>俱乐部专题</li>
	    	<li style="width: 40px;"></li>
	    	<li><img alt="" src="pages/f_generic_type/style1.png" width="270px" height="90px"></li>
	    </ul>
	    <ul <%if(!"s2".equals(other)){ %> style="display: none" <%} %> id="s2">
	    	<li>全局样式一</li>
	    	<li style="width: 40px;"></li>
	    	<li><img alt="" src="pages/f_generic_type/style2.png" width="250px" height="180px"></li>
	    </ul>
	    <ul <%if(!"s3".equals(other)){ %> style="display: none" <%} %> id="s3">
	    	<li>全局样式二</li>
	    	<li style="width: 40px;"></li>
	    	<li><img alt="" src="pages/f_generic_type/style3.png" width="270px" height="180px"></li>
	    </ul>
	    <ul <%if(!"s4".equals(other)){ %> style="display: none" <%} %> id="s4">
	    	<li>俱乐部动态</li>
	    	<li style="width: 40px;"></li>
	    	<li><img alt="" src="pages/f_generic_type/style3.png" width="270px" height="180px"></li>
	    </ul>
	    <%} %>
	  </form>
 </body>
 <script type="text/javascript">
function showPic(id){
	if("s1"==id){
		$("#s1").show();
		$("#s2").hide();
		$("#s3").hide();
		$("#s4").hide();
	}
	if("s2"==id){
		$("#s1").hide();
		$("#s2").show();
		$("#s3").hide();
		$("#s4").hide();
	}
	if("s3"==id){
		$("#s1").hide();
		$("#s2").hide();
		$("#s3").show();
		$("#s4").hide();
	}
	if("s4"==id){
		$("#s1").hide();
		$("#s2").hide();
		$("#s3").hide();
		$("#s4").show();
	}
}
 </script>
</html>