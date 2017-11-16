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
	    <input id="f_emp__cust_name" name="f_emp__cust_name" type="hidden" value='<%=hasF_emp?f_emp.getStringValue("cust_name"):""%>'/>
	    <input id="f_emp__gym" name="f_emp__gym" type="hidden" value='<%=hasF_emp?f_emp.getStringValue("gym"):""%>'/>
	    <ul>
	      <li style="width: 90px; text-align: left;">姓名(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_emp__name" name="f_emp__name" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:true,validType:'length[0,100]'" value='<%=hasF_emp?f_emp.getStringValue("name"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">登录名：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_emp__login_name" name="f_emp__login_name" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:true,validType:'length[0,50]'" value='<%=hasF_emp?f_emp.getStringValue("login_name"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">密码：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_emp__pwd" name="f_emp__pwd" class="easyui-validatebox"  style="width: 164px;" type="password" data-options="required:true,validType:'length[0,50]'" value='<%=hasF_emp?f_emp.getStringValue("pwd"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">WX_OPEN_ID：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_emp__wx_open_id" name="f_emp__wx_open_id" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:false,validType:'length[0,100]'" value='<%=hasF_emp?f_emp.getStringValue("wx_open_id"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">APP_OPEN_ID：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_emp__app_open_id" name="f_emp__app_open_id" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:false,validType:'length[0,100]'" value='<%=hasF_emp?f_emp.getStringValue("app_open_id"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">手机号码：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_emp__phone" name="f_emp__phone" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:false,validType:'length[0,11]'" value='<%=hasF_emp?f_emp.getStringValue("phone"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	      <input id="f_emp__mc" name="f_emp__mc" type="hidden" value='<%=hasF_emp?f_emp.getStringValue("mc"):""%>'/>
	      <input id="f_emp__pt" name="f_emp__pt" type="hidden" value='<%=hasF_emp?f_emp.getStringValue("pt"):""%>'/>
	      <input id="f_emp__op" name="f_emp__op" type="hidden" value='<%=hasF_emp?f_emp.getStringValue("op"):""%>'/>
	      <input id="f_emp__ex_mc" name="f_emp__ex_mc" type="hidden" value='<%=hasF_emp?f_emp.getStringValue("ex_mc"):""%>'/>
	      <input id="f_emp__ex_pt" name="f_emp__ex_pt" type="hidden" value='<%=hasF_emp?f_emp.getStringValue("ex_pt"):""%>'/>
	   <%--  <ul>
	      <li style="width: 90px; text-align: left;">PT：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createSelect("f_emp__pt","PUB_C003",hasF_emp?f_emp.getStringValue("pt"):"",false,"{'style':'width:164px'}") %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">MC：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createSelect("f_emp__mc","PUB_C003",hasF_emp?f_emp.getStringValue("mc"):"",false,"{'style':'width:164px'}") %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">OP：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createSelect("f_emp__op","PUB_C003",hasF_emp?f_emp.getStringValue("op"):"",false,"{'style':'width:164px'}") %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">EX_PT：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createSelect("f_emp__ex_pt","PUB_C003",hasF_emp?f_emp.getStringValue("ex_pt"):"",false,"{'style':'width:164px'}") %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul> --%>
	    <ul>
	     <%--  <li style="width: 90px; text-align: left;">EX_MC：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createSelect("f_emp__ex_mc","PUB_C003",hasF_emp?f_emp.getStringValue("ex_mc"):"",false,"{'style':'width:164px'}") %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li> --%>
	      <li style="width: 90px; text-align: left;">图片地址：</li>
       <li style="width: 470px; text-align: left;">
	        <div class="l-text" style="width: 468px;">
	          <input id="f_emp__pic_url" name="f_emp__pic_url" type="hidden" value="<%=hasF_emp?f_emp.getStringValue("pic_url"):""%>"><a href="javascript:uploadFile('f_emp__pic_url','','');" class="btn btn-xs btn-default btn-block" style="width: 100px;">上传文件</a><div id="_f_emp__pic_url" name="_f_emp__pic_url"><a href='' target='_blank'><img></a></div>
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
	          <%=UI.createSelect("f_emp__state","PUB_C201",hasF_emp?f_emp.getStringValue("state"):"",true,"{'style':'width:164px'}") %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">标签：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_emp__labels" name="f_emp__labels" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:false,validType:'length[0,100]'" value='<%=hasF_emp?f_emp.getStringValue("labels"):""%>'/>
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
	        <div class="l-text" style="width: 468px;height: 160px;">
	          <%=UI.createEditor("f_emp__content",hasF_emp?f_emp.getStringValue("content"):"",false,new UI_Op("width:99%;height:150px;","")) %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	  </form>
 </body>
</html>