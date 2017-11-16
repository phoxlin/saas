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

	Entity f_words=(Entity)request.getAttribute("f_words");
	boolean hasF_words=f_words!=null&&f_words.getResultCount()>0;
%>
<!DOCTYPE HTML>
<html>
 <head>
  <jsp:include page="/public/edit_base.jsp" />
  <script type="text/javascript">
    var entity = "f_words";
    var form_id = "f_wordsFormObj";
    var lockId=new UUID();
    $(document).ready(function() {

    //insert js

    });
  </script>
  <script type="text/javascript" charset="utf-8" src="pages/f_words/f_words.js"></script>
 </head>
<body>
	  <form class="l-form" id="f_wordsFormObj" method="post">
	    <input id="f_words__id" name="f_words__id" type="hidden" value='<%=hasF_words?f_words.getStringValue("id"):""%>'/>
	    <ul>
	      <li style="width: 90px; text-align: left;">GYM(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_words__gym" name="f_words__gym" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:true,validType:'length[0,50]'" value='<%=hasF_words?f_words.getStringValue("gym"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">CUST_NAME(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_words__cust_name" name="f_words__cust_name" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:true,validType:'length[0,50]'" value='<%=hasF_words?f_words.getStringValue("cust_name"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">MEM_ID(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_words__mem_id" name="f_words__mem_id" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:true,validType:'length[0,24]'" value='<%=hasF_words?f_words.getStringValue("mem_id"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">类型(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_words__type" name="f_words__type" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:true,validType:'length[0,20]'" value='<%=hasF_words?f_words.getStringValue("type"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">上课ID(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_words__pri_order_id" name="f_words__pri_order_id" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:true,validType:'length[0,24]'" value='<%=hasF_words?f_words.getStringValue("pri_order_id"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">评价分数(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_words__cent" name="f_words__cent" class="easyui-numberbox" style="width: 164px;" type="text" data-options="precision:0,required:true" value='<%=hasF_words?f_words.getStringValue("cent"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">评价内容：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;height: 60px;">
	          <textarea id="f_words__content" name="f_words__content" class="easyui-validatebox"  style="width: 99%;height: 50px;"  data-options="required:false,validType:'length[0,100]'" ><%=hasF_words?f_words.getStringValue("content"):""%></textarea>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">STATE(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_words__state" name="f_words__state" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:true,validType:'length[0,20]'" value='<%=hasF_words?f_words.getStringValue("state"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	  </form>
 </body>
</html>