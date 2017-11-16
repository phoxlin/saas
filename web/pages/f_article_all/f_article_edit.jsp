<%@page import="java.text.SimpleDateFormat"%>
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
	
	Entity f_article=(Entity)request.getAttribute("f_article");
	boolean hasF_article=f_article!=null&&f_article.getResultCount()>0;
%>
<!DOCTYPE HTML>
<html>
 <head>
  <jsp:include page="/public/edit_base.jsp" />
  <script type="text/javascript">
    var entity = "f_article";
    var form_id = "f_articleFormObj";
    var lockId=new UUID();
    $(document).ready(function() {

    //insert js

    });
  </script>
  <script type="text/javascript" charset="utf-8" src="pages/f_article/f_article.js"></script>
 </head>
<body>
	  <form class="l-form" id="f_articleFormObj" method="post">
	    <input id="f_article__id" name="f_article__id" type="hidden" value='<%=hasF_article?f_article.getStringValue("id"):""%>'/>
	    <input id="f_article__cust_name" name="f_article__cust_name" type="hidden" value='<%=hasF_article?f_article.getStringValue("cust_name"):"-1"%>'/>
	    <input id="f_article__gym" name="f_article__gym" type="hidden" value='<%=hasF_article?f_article.getStringValue("gym"):"-1"%>'/>
	    <input id="f_article__create_time" name="f_article__create_time" type="hidden" value='<%=hasF_article?f_article.getStringValue("create_time"):new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())%>'/>
	    <input id="f_article__emp_id" name="f_article__emp_id" type="hidden" value='<%=hasF_article?f_article.getStringValue("emp_id"):user.getId()%>'/>
	    <ul>
	      <li style="width: 90px; text-align: left;">标题(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_article__title" name="f_article__title" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:true,validType:'length[0,200]'" value='<%=hasF_article?f_article.getStringValue("title"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">文章类型(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createSelectBySql("f_article__art_type", "select id code,type note from f_generic_type where cust_name = '-1' and gym ='-1' and table_name = 'f_article' and state='001'", hasF_article?f_article.getStringValue("art_type"):"", true, "{'style':'width:164px'}") %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">简介(*)：</li>
       <li style="width: 470px; text-align: left;">
	        <div class="l-text" style="width: 468px;height: 60px">
	          <textarea id="f_article__summary" name="f_article__summary" class="easyui-validatebox"  style="width: 464px;height:50px" data-options="required:true,validType:'length[0,400]'"><%=hasF_article?f_article.getStringValue("summary"):""%></textarea>
	          <%-- <input id="f_article__summary" name="f_article__summary" class="easyui-validatebox"  style="width: 464px;" type="text" data-options="required:true,validType:'length[0,100]'" value='<%=hasF_article?f_article.getStringValue("summary"):""%>'/>
 --%>	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">图片：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_article__pic_url" name="f_article__pic_url" type="hidden" 
	          value="<%=hasF_article?f_article.getStringValue("pic_url"):""%>">
	          <a href="javascript:uploadFile('f_article__pic_url','','');" 
	          class="btn btn-xs btn-default btn-block" style="width: 100px;">上传文件</a>
	          <div id="_f_article__pic_url" name="_f_article__pic_url">
	          <a href='' target='_blank'>
	          <img src='<%=hasF_article?(f_article.getStringValue("pic_url")+"?imageView2/1/w/50/h/50"):"" %>'>
	          </a>
	          </div>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">状态(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createSelect("f_article__state","ARTICLE_STATE",hasF_article?f_article.getStringValue("state"):"Y",true,"{'style':'width:164px'}") %>
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
	          <%=UI.createDateTimeBox("f_article__release_time",hasF_article?f_article.getStringValue("release_time"):"",true,"width:164px;")%>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">点赞数：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_article__num" name="f_article__num" class="easyui-numberbox" style="width: 164px;" type="text" data-options="precision:0,required:false" value='<%=hasF_article?f_article.getStringValue("num"):"0"%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	     <ul>
	      <li style="width: 90px; text-align: left;">作者：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_article__author" name="f_article__author" class="easyu-validatebox" style="width: 164px;" type="text" data-options="precision:0,required:false" value='<%=hasF_article?f_article.getStringValue("author"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">内容：</li>
       <li style="width: 470px; text-align: left;">
	        <div class="l-text" style="width: 468px;height: 330px;">
	          <%=UI.createEditor("f_article__content",hasF_article?f_article.getStringValue("content"):"",false,new UI_Op("width:99%;height:310px;","")) %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	  </form>
 </body>
</html>