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

	Entity f_box=(Entity)request.getAttribute("f_box");
	boolean hasF_box=f_box!=null&&f_box.getResultCount()>0;
%>
<!DOCTYPE HTML>
<html>
 <head>
  <jsp:include page="/public/edit_base.jsp" />
  <script type="text/javascript">
    var entity = "f_box";
    var form_id = "f_boxFormObj";
    var lockId=new UUID();
    $(document).ready(function() {
    //insert js
    });
  </script>
  <script type="text/javascript" charset="utf-8" src="pages/f_box/f_box.js"></script>
 </head>
<body>
	  <form class="l-form" id="f_boxFormObj" method="post">
	<%--      
	    <ul>
    <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_box__id" name="f_box__id"   style="width: 164px;" type="text" style="width: 164px;" value='<%=hasF_box?f_box.getStringValue("id"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>

	      <li style="width: 90px; text-align: left;">cust_name：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_box__cust_name" name="f_box__cust_name"  style="width: 164px;" type="text"  value='<%=hasF_box?f_box.getStringValue("cust_name"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	    </ul>
	     --%>
	    <ul>
	    <li style="width: 90px; text-align: left;">健身房：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_box__gym" name="f_box__gym"  type="text" style="width: 164px;" value='<%=hasF_box?f_box.getStringValue("gym"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	    </ul>
	    <ul>	      
	    <li style="width: 90px; text-align: left;">柜子编号：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_box__box_no" name="f_box__box_no" style="width: 164px;" type="text"  value='<%=hasF_box?f_box.getStringValue("box_no"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">区域编号(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_box__area_no" name="f_box__area_no" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:true,validType:'length[0,100]'" value='<%=hasF_box?f_box.getStringValue("area_no"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    
	    <ul>
	      <li style="width: 90px; text-align: left;">箱柜数量(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_box__box_nums" name="f_box__box_nums" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:true,validType:'length[0,100]'" value='<%=hasF_box?f_box.getStringValue("box_nums"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_box__state" name="f_box__state"  type="hidden"  value='<%=hasF_box?f_box.getStringValue("state"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
 	  </form>
 	  
 </body>
</html>