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

	Entity f_active_words=(Entity)request.getAttribute("f_active_words");
	boolean hasF_active_words=f_active_words!=null&&f_active_words.getResultCount()>0;
%>
<!DOCTYPE HTML>
<html>
 <head>
  <jsp:include page="/public/edit_base.jsp" />
  <script type="text/javascript">
    var entity = "f_active_words";
    var form_id = "f_active_wordsFormObj";
    var lockId=new UUID();
    $(document).ready(function() {

    //insert js

    });
  </script>
  <script type="text/javascript" charset="utf-8" src="pages/f_active_words/f_active_words.js"></script>
 </head>
<body>
	  <form class="l-form" id="f_active_wordsFormObj" method="post">
	    <input id="f_active_words__id" name="f_active_words__id" type="hidden" value='<%=hasF_active_words?f_active_words.getStringValue("id"):""%>'/>
	    <ul>
	      <li style="width: 90px; text-align: left;">活动名称(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createSelectBySql("f_active_words__act_id","select id code,title note from f_active",hasF_active_words?f_active_words.getStringValue("act_id"):"",true,"{'style':'width:164px'}") %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">评论时间(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createDateTimeBox("f_active_words__create_time",hasF_active_words?f_active_words.getStringValue("create_time"):"",true,"width:164px;")%>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">所在会所(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createSelectBySql("f_active_words__fk_user_gym","select gym code,gym_name note from f_gym where cust_name ='"+cust_name+"'",hasF_active_words?f_active_words.getStringValue("fk_user_gym"):"",true,"{'style':'width:164px'}") %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">评论人(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createSelectBySql("f_active_words__fk_user_id","select id code,mem_name note from f_mem_"+gym+(hasF_active_words?( " where id ='"+ f_active_words.getStringValue("fk_user_id")+"'"):" limit 0,10"),hasF_active_words?f_active_words.getStringValue("fk_user_id"):"",true,"{'style':'width:164px'}") %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">分数(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_active_words__cent" name="f_active_words__cent" class="easyui-numberbox" style="width: 164px;" type="text" data-options="precision:0,required:true" value='<%=hasF_active_words?f_active_words.getStringValue("cent"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">评论内容：</li>
       <li style="width: 470px; text-align: left;">
	        <div class="l-text" style="width: 468px;height: 60px;">
	          <textarea id="f_active_words__content" name="f_active_words__content" class="easyui-validatebox"  style="width: 99%;height: 50px;"  data-options="required:false,validType:'length[0,400]'" ><%=hasF_active_words?f_active_words.getStringValue("content"):""%></textarea>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	  </form>
 </body>
</html>