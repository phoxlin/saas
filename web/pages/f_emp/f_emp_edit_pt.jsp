<%@page import="com.mingsokj.fitapp.m.MemInfo"%>
<%@page import="com.mingsokj.fitapp.utils.MemUtils"%>
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

	Entity f_emp=(Entity)request.getAttribute("f_emp");
	boolean hasF_emp=f_emp!=null&&f_emp.getResultCount()>0;
	MemInfo mem = null;
	if(hasF_emp){
		mem = MemUtils.getMemInfo(f_emp.getStringValue("id"), f_emp.getStringValue("gym"));
	}
	String role = request.getParameter("role");
	
%>
<!DOCTYPE HTML>
<html>
 <head>
  <jsp:include page="/public/edit_base.jsp" />
  <script type="text/javascript">
    var entity = "f_emp";
    var form_id = "f_empFormObj";
    var lockId=new UUID();
    $(document).ready(function() {

    //insert js

    });
  </script>
  <script type="text/javascript" charset="utf-8" src="pages/f_emp/f_emp.js"></script>
 </head>
<body>
	  <form class="l-form" id="f_empFormObj" method="post">
	    <input id="f_emp__id" name="f_emp__id" type="hidden" value='<%=hasF_emp?f_emp.getStringValue("id"):""%>'/>
	    <ul>
	      <li style="width: 90px; text-align: left;">教练姓名(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	        	<%=hasF_emp?mem.getName():"" %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">图片1：</li>
      	 <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_emp__pic1" name="f_emp__pic1" type="hidden" value="<%=hasF_emp?f_emp.getStringValue("pic1"):""%>"><a href="javascript:uploadFile('f_emp__pic1','','');" class="btn btn-xs btn-default btn-block" style="width: 100px;">上传文件</a><div id="_f_emp__pic1" name="_f_emp__pic1"><a href='' target='_blank'><img></a></div>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	       <li style="width: 90px; text-align: left;">图片2：</li>
      	 <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_emp__pic2" name="f_emp__pic2" type="hidden" value="<%=hasF_emp?f_emp.getStringValue("pic2"):""%>"><a href="javascript:uploadFile('f_emp__pic2','','');" class="btn btn-xs btn-default btn-block" style="width: 100px;">上传文件</a><div id="_f_emp__pic2" name="_f_emp__pic2"><a href='' target='_blank'><img></a></div>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">图片3：</li>
      	 <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_emp__pic3" name="f_emp__pic3" type="hidden" value="<%=hasF_emp?f_emp.getStringValue("pic3"):""%>"><a href="javascript:uploadFile('f_emp__pic3','','');" class="btn btn-xs btn-default btn-block" style="width: 100px;">上传文件</a><div id="_f_emp__pic3" name="_f_emp__pic3"><a href='' target='_blank'><img></a></div>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">标签：</li>
       <li style="width: 470px; text-align: left;">
	        <div class="l-text" style="width: 468px;">
	          <input id="f_emp__labels" name="f_emp__labels" class="easyui-validatebox"  style="width: 464px;" type="text" data-options="required:false,validType:'length[0,100]'" value='<%=hasF_emp?f_emp.getStringValue("labels"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">简介：</li>
       <li style="width: 470px; text-align: left;">
	        <div class="l-text" style="width: 468px;">
	          <input id="f_emp__summary" name="f_emp__summary" class="easyui-validatebox"  style="width: 464px;" type="text" data-options="required:false,validType:'length[0,400]'" value='<%=hasF_emp?f_emp.getStringValue("summary"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">图文内容：</li>
       <li style="width: 470px; text-align: left;">
	        <div class="l-text" style="width: 468px;height:320px;">
	          <%=UI.createEditor("f_emp__content",hasF_emp?f_emp.getStringValue("content"):"",false,new UI_Op("width:99%;height:300px;","")) %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	  </form>
 </body>
</html>