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
	String gym = user.getViewGym();
	Entity f_plan=(Entity)request.getAttribute("f_plan");
	boolean hasF_plan=f_plan!=null&&f_plan.getResultCount()>0;
%>
<!DOCTYPE HTML>
<html>
 <head>
  <jsp:include page="/public/edit_base.jsp" />
  <script type="text/javascript">
    var entity = "f_plan";
    var form_id = "f_planFormObj";
    var lockId=new UUID();
    $(document).ready(function() {

    //insert js

    });
  </script>
  <script type="text/javascript" charset="utf-8" src="pages/f_plan/f_plan.js"></script>
 </head>
<body>
<div style="width: 1190px;height: 480px;overflow: auto;">
	  <form class="l-form" id="f_planFormObj" method="post">
	    <input id="f_plan__id" name="f_plan__id" type="hidden" value='<%=hasF_plan?f_plan.getStringValue("id"):""%>'/>
	    <input id="f_plan__cust_name" name="f_plan__cust_name" type="hidden" value='<%=hasF_plan?f_plan.getStringValue("cust_name"):""%>'/>
	    <input id="f_plan__gym" name="f_plan__gym" type="hidden" value='<%=hasF_plan?f_plan.getStringValue("gym"):""%>'/>
	    <input id="f_plan__type" name="f_plan__type" type="hidden" value='<%=hasF_plan?f_plan.getStringValue("type"):""%>'/>
	    <input id="f_plan__lession_id" name="f_plan__lession_id" type="hidden" value='<%=hasF_plan?f_plan.getStringValue("lession_id"):""%>'/>
	    <input id="f_plan__user_id" name="f_plan__user_id" type="hidden" value='<%=hasF_plan?f_plan.getStringValue("user_id"):""%>'/>
	    <input id="f_plan__state" name="f_plan__state" type="hidden" value='<%=hasF_plan?f_plan.getStringValue("state"):""%>'/>
	    <ul>
	      <li style="width: 90px; text-align: left;">团课名称(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_plan__plan_name" name="f_plan__plan_name" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:true,validType:'length[0,50]'" value='<%=hasF_plan?f_plan.getStringValue("plan_name"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">私教：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createSelectBySql("f_plan__pt_id","select a.id code,a.mem_name note from f_mem_"+gym+" a,f_emp b where a.id=b.id and b.pt='Y'",hasF_plan?f_plan.getStringValue("pt_id"):"",false,"{'style':'width:164px'}") %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">上课地点：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_plan__addr_name" name="f_plan__addr_name" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:false,validType:'length[0,50]'" value='<%=hasF_plan?f_plan.getStringValue("addr_name"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">预约上限人数：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_plan__top_num" name="f_plan__top_num" class="easyui-numberbox" style="width: 164px;" type="text" data-options="precision:0,required:false" value='<%=hasF_plan?f_plan.getStringValue("top_num"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">开课人数：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_plan__start_num" name="f_plan__start_num" class="easyui-numberbox" style="width: 164px;" type="text" data-options="precision:0,required:false" value='<%=hasF_plan?f_plan.getStringValue("start_num"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">会员多少分钟前可以取消：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_plan__cancel_cent" name="f_plan__cancel_cent" class="easyui-numberbox" style="width: 164px;" type="text" data-options="precision:0,required:false" value='<%=hasF_plan?f_plan.getStringValue("cancel_cent"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">是否扣次：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createSelect("f_plan__is_free","PUB_C001",hasF_plan?f_plan.getStringValue("is_free"):"",true,"{'style':'width:164px'}") %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">图片地址：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_plan__pic_url" name="f_plan__pic_url" type="hidden" value="<%=hasF_plan?f_plan.getStringValue("pic_url"):""%>"><a href="javascript:uploadFile('f_plan__pic_url','','');" class="btn btn-xs btn-default btn-block" style="width: 100px;">上传文件</a><div id="_f_plan__pic_url" name="_f_plan__pic_url"><a href='' target='_blank'><img src='?imageView2/1/w/50/h/50'></a></div>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	   
	      <li style="width: 90px; text-align: left;">绑卡：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	        <%=UI.createSelectBySql("f_plan__card_names","SELECT id as code ,CARD_NAME as note FROM f_card WHERE GYM='"+gym+"' AND CARD_TYPE='006'",hasF_plan?f_plan.getStringValue("card_names"):"",false,"{'style':'width:164px'}") %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">是否体验课程：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createSelect("f_plan__experience","PUB_C001",hasF_plan?f_plan.getStringValue("experience"):"",true,"{'style':'width:164px'}") %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">标签：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_plan__labels" name="f_plan__labels" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:false,validType:'length[0,100]'" value='<%=hasF_plan?f_plan.getStringValue("labels"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">简介：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_plan__summary" name="f_plan__summary" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:false,validType:'length[0,400]'" value='<%=hasF_plan?f_plan.getStringValue("summary"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    
	    <ul>
	       <li style="width: 90px; text-align: left;">图文内容：</li>
       <li style="width: 470px; text-align: left;">
	        <div class="l-text" style="width: 470px;height: 260px;">
	          <%=UI.createEditor("f_plan__content",hasF_plan?f_plan.getStringValue("content"):"",false,new UI_Op("width:99%;height:210px;","")) %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    
	  </form>
	  </div>
 </body>
</html>