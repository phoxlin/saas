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

	Entity f_user_lesson=(Entity)request.getAttribute("f_user_lesson");
	boolean hasF_user_lesson=f_user_lesson!=null&&f_user_lesson.getResultCount()>0;
%>
<!DOCTYPE HTML>
<html>
 <head>
  <jsp:include page="/public/edit_base.jsp" />
  <script type="text/javascript">
    var entity = "f_user_lesson";
    var form_id = "f_user_lessonFormObj";
    var lockId=new UUID();
    $(document).ready(function() {

    //insert js

    });
  </script>
  <script type="text/javascript" charset="utf-8" src="pages/f_user_lesson/f_user_lesson.js"></script>
 </head>
<body>
	  <form class="l-form" id="f_user_lessonFormObj" method="post">
	    <ul>
	      <li style="width: 90px; text-align: left;">CUST_NAME(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_user_lesson__cust_name" name="f_user_lesson__cust_name" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:true,validType:'length[0,50]'" value='<%=hasF_user_lesson?f_user_lesson.getStringValue("cust_name"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">GYM(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_user_lesson__gym" name="f_user_lesson__gym" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:true,validType:'length[0,50]'" value='<%=hasF_user_lesson?f_user_lesson.getStringValue("gym"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">会员ID(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_user_lesson__mem_id" name="f_user_lesson__mem_id" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:true,validType:'length[0,24]'" value='<%=hasF_user_lesson?f_user_lesson.getStringValue("mem_id"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">售课员工ID(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_user_lesson__emp_id" name="f_user_lesson__emp_id" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:true,validType:'length[0,24]'" value='<%=hasF_user_lesson?f_user_lesson.getStringValue("emp_id"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">教练ID：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_user_lesson__pt_id" name="f_user_lesson__pt_id" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:false,validType:'length[0,24]'" value='<%=hasF_user_lesson?f_user_lesson.getStringValue("pt_id"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">课程类型(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_user_lesson__lesson_type" name="f_user_lesson__lesson_type" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:true,validType:'length[0,20]'" value='<%=hasF_user_lesson?f_user_lesson.getStringValue("lesson_type"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">课程ID(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_user_lesson__lesson_id" name="f_user_lesson__lesson_id" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:true,validType:'length[0,24]'" value='<%=hasF_user_lesson?f_user_lesson.getStringValue("lesson_id"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">总节数(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_user_lesson__total_nums" name="f_user_lesson__total_nums" class="easyui-numberbox" style="width: 164px;" type="text" data-options="precision:0,required:true" value='<%=hasF_user_lesson?f_user_lesson.getStringValue("total_nums"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">剩余节数(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_user_lesson__remain_nums" name="f_user_lesson__remain_nums" class="easyui-numberbox" style="width: 164px;" type="text" data-options="precision:0,required:true" value='<%=hasF_user_lesson?f_user_lesson.getStringValue("remain_nums"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">合同编号：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_user_lesson__contract_no" name="f_user_lesson__contract_no" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:false,validType:'length[0,100]'" value='<%=hasF_user_lesson?f_user_lesson.getStringValue("contract_no"):""%>'/>
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
	          <input id="f_user_lesson__state" name="f_user_lesson__state" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:true,validType:'length[0,20]'" value='<%=hasF_user_lesson?f_user_lesson.getStringValue("state"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">购课时间(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createDateTimeBox("f_user_lesson__buy_time",hasF_user_lesson?f_user_lesson.getStringValue("buy_time"):"",true,"width:164px;")%>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">到期时间：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createDateTimeBox("f_user_lesson__deadline",hasF_user_lesson?f_user_lesson.getStringValue("deadline"):"",false,"width:164px;")%>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">实收金额(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_user_lesson__real_amt" name="f_user_lesson__real_amt" class="easyui-numberbox" style="width: 164px;" type="text" data-options="precision:0,required:true" value='<%=hasF_user_lesson?f_user_lesson.getStringValue("real_amt"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">备注：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;height: 60px;">
	          <textarea id="f_user_lesson__remark" name="f_user_lesson__remark" class="easyui-validatebox"  style="width: 99%;height: 50px;"  data-options="required:false,validType:'length[0,100]'" ><%=hasF_user_lesson?f_user_lesson.getStringValue("remark"):""%></textarea>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	  </form>
 </body>
</html>