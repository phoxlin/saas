<%@page import="java.util.ArrayList"%>
<%@page import="com.mingsokj.fitapp.m.Gym"%>
<%@page import="java.util.List"%>
<%@page import="com.jinhua.server.db.DBUtils"%>
<%@page import="com.jinhua.server.db.impl.EntityImpl"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.jinhua.server.db.IDB"%>
<%@page import="com.jinhua.server.db.impl.DBM"%>
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
	Entity f_active=(Entity)request.getAttribute("f_active");
	boolean hasF_active=f_active!=null&&f_active.getResultCount()>0;
	String type = request.getParameter("type");
	//查询活动项目
	IDB db = new DBM();
	Connection conn = null ;
	Entity en = null;
	int item_num = 0;//标识规格条数
	Entity view_gym =null;
	List<String> gyms = new ArrayList<>();
	//查询可见会所
	if(hasF_active){
		try{
			conn = db.getConnection();
			en = new EntityImpl("f_active_item",conn);
			item_num =en.executeQuery("select * from f_active_item where act_id = ?",new Object[]{f_active.getStringValue("id")});
			
			view_gym = new EntityImpl("f_active_gym",conn);
			int s =view_gym.executeQuery("select * from f_active_gym where act_id = ?", new Object[]{f_active.getStringValue("id")});
			if(s > 0){
				for(int i=0;i<s;i++){
					gyms.add(view_gym.getStringValue("view_gym",i));
				}
			}
			//en.setValue("goods_id", f_goods.getStringValue("id"));
			//int s = en.search();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			if(conn!=null){
				DBUtils.freeConnection(conn);
			}
		}
		
	}
	
	
%>
<!DOCTYPE HTML>
<html>
 <head>
  <jsp:include page="/public/edit_base.jsp" />
  <base	href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
  <script type="text/javascript">
    var entity = "f_active";
    var form_id = "f_activeFormObj";
    var lockId=new UUID();
    //当前员工可见会所
    var user_view_gyms = new Array();
    
    <%for(int i=0;i<gyms.size();i++){%>
    	user_view_gym.push('<%=gyms.get(i)%>');
    <%}%>
    $(document).ready(function() {

    //insert js

    });
  </script>
  <style type="text/css">
  	.easyui-numberbox{
  		margin-top: -5px
  	}
  	h3{
  	margin-top: 10px
  	}
  </style>
  <script type="text/javascript" charset="utf-8" src="pages/f_active/f_active.js"></script>
 </head>
<body>
	<div style="width: 990px;height:700px;overflow: auto">		
	  <form class="l-form" id="f_activeFormObj" method="post">
	    <input id="f_active__id" name="f_active__id" type="hidden" value='<%=hasF_active?f_active.getStringValue("id"):""%>'/>
	    <input id="f_active__cust_name" name="f_active__cust_name" type="hidden" value='<%=hasF_active?f_active.getStringValue("cust_name"):cust_name%>'/>
	    <input id="f_active__gym" name="f_active__gym" type="hidden" value='<%=hasF_active?f_active.getStringValue("gym"):gym%>'/>
	    <input id="f_active__create_time" name="f_active__create_time" type="hidden" value='<%=hasF_active?f_active.getStringValue("create_time"):""%>'/>
	    <input id="f_active__fk_user_id" name="f_active__fk_user_id" type="hidden" value='<%=hasF_active?f_active.getStringValue("fk_user_id"):user.getId()%>'/>
	    <input id="f_active__for_mem" name="f_active__for_mem" type="hidden" value='<%=hasF_active?f_active.getStringValue("for_mem"):"N"%>'/>
	    <ul style="background-color: #f2f3f5;height: 50px">
		 	<li>
			    <h3>活动基本信息 </h3>
		 	</li>
	    </ul>
	    
	    <ul>
	      <li style="width: 90px; text-align: left;">标题(*)：</li>
       <li style="width: 470px; text-align: left;">
	        <div class="l-text" style="width: 468px;">
	          <input id="f_active__title" class="easyui-validatebox input" name="f_active__title" style="width: 464px;" type="text" data-options="required:true,validType:'length[0,400]'" value='<%=hasF_active?f_active.getStringValue("title"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">开始时间(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createDateTimeBox("f_active__start_time",hasF_active?f_active.getStringValue("start_time"):"",true,"width:164px;")%>
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
	          <input id="f_active__summary" name="f_active__summary" class="easyui-validatebox"  style="width: 464px;" type="text" data-options="required:false,validType:'length[0,4000]'" value='<%=hasF_active?f_active.getStringValue("summary"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      
	      <li style="width: 90px; text-align: left;">结束时间(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createDateTimeBox("f_active__end_time",hasF_active?f_active.getStringValue("end_time"):"",true,"width:164px;")%>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">可否分享(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createSelect("f_active__is_share", "PUB_C001_1", hasF_active?f_active.getStringValue("is_share"):"N", true, "{'style':'width:168px'}") %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">状态(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createSelect("f_active__state", "ACTIVE_STATE", hasF_active?f_active.getStringValue("state"):"ready", true, "{'style':'width:168px'}") %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	       <%--  <li style="width: 90px; text-align: left;">首页推荐：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	        	<%=UI.createSelect("f_active__index_commend", "PUB_C001_1", hasF_active?f_active.getStringValue("index_commend"):"N", false, "{'style':'width:168px'}") %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li> --%>
	    </ul>
	    <ul>
	       <li style="width: 90px; text-align: left;">限参与次数：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	        	<input id="f_active__num" name="f_active__num" min="0" class="easyui-numberbox" style="width: 165px;" type="number" data-options="precision:0,required:true" value='<%=hasF_active?f_active.getStringValue("num"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	       <li style="width: 90px; text-align: left;">图片：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_active__pic_url" name="f_active__pic_url" type="hidden" value="<%=hasF_active ?f_active.getStringValue("pic_url"):""%>"><a href="javascript:uploadFile('f_active__pic_url','','');" class="btn btn-xs btn-default btn-block" style="width: 100px;">上传文件</a><div id="_f_active__pic_url" name="_f_active__pic_url">
	          <a href='<%=hasF_active?(f_active.getStringValue("pic_url")+"?imageView2/1/w/50/h/50"):"javascript:void(0)" %>' target='_blank'><img src='<%=hasF_active?(f_active.getStringValue("pic_url")+"?imageView2/1/w/50/h/50"):"" %>'></a></div>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	    </ul>
	    <ul id="cardTypeUl" style="background-color: #f2f3f5;height: 50px;">
		 	<li>
			    <h3>活动项目 </h3>
		 	</li>
		 	<li style="width: 40px"></li>
		 	<li style="margin-top: 10px" onclick="showCards('001')">
		 		时间卡+
		 	</li>
		 	<li style="width: 40px;"></li>
		 	<li style="margin-top: 10px" onclick="showCards('003')">
		 		次卡+
		 	</li>
		 	<li style="width: 40px;" ></li>
		 	<li style="margin-top: 10px" onclick="showCards('002')">
		 		储值卡+
		 	</li>
		 	<li style="width: 40px;" ></li>
		 	<li style="margin-top: 10px" onclick="showCards('006')">
		 		私教课程卡+
		 	</li>
		 	<li style="width: 40px;"></li>
		 	<li style="margin-top: 10px" onclick="showCards('005')">
		 		单次入场卷+
		 	</li>
		 	<!-- <li style="width: 40px;" onclick="showGoods()"></li>
		 	<li style="margin-top: 10px">
		 		商品+
		 	</li> -->
	    </ul>
	    
	    <!-- 卡列表 -->
	    <ul id="cardList">
	    	<%if("add".equals(type)) {%><li>点击项目类型,选择会员卡</li><%} %>
	    </ul>
	    <%if(item_num >0){
	    	for(int i=0;i<item_num;i++){
	    %>
	    	<ul data-exists="Y" id="<%=en.getStringValue("prj_id",i) %>">	
	    		<li style="width: 90px; text-align: left;">项目名：</li>
      			 <li style="width: 170px; text-align: left;">
	       		 <div class="l-text" style="width: 168px;">
	       		 <input id="f_active_item__id" type="hidden" name="f_active_item__id" value="<%=en.getStringValue("id",i) %>">
	       		 <input id="f_active_item__prj_type" type="hidden" name="f_active_item__prj_type" value="<%=en.getStringValue("prj_type",i) %>">
	       		 <input id="f_active_item__prj_id" type="hidden" name="f_active_item__prj_id" value="<%=en.getStringValue("prj_id",i) %>">
	       		 <input id="f_active_item__prj_name" name="f_active_item__prj_name" class="easyui-validatebox" style="width: 168px;" type="text" data-options="precision:0,required:true" value='<%=en.getStringValue("prj_name",i) %>'/>
	       		 	
	         	 <div class="l-text-l"></div>
	         	 <div class="l-text-r"></div>
	        </div>
	      </li>
	    	<li style="width: 40px;"></li>
	    		<li style="width: 90px; text-align: left;">原价：</li>
      			 <li style="width: 170px; text-align: left;">
	       		 <div class="l-text" style="width: 168px;">
	       		 <input id="f_active_item__price" name="f_active_item__price" min="0" class="easyui-numberbox" style="width: 168px;" type="number" data-options="precision:2,required:true" value='<%=Utils.toPriceFromLongStr(en.getStringValue("price",i)) %>'/>
	       		 	
	         	 <div class="l-text-l"></div>
	         	 <div class="l-text-r"></div>
	        </div>
	      </li>
	    	<li style="width: 40px;"></li>
	    		<li style="width: 90px; text-align: left;">活动价：</li>
      			 <li style="width: 170px; text-align: left;">
	       		 <div class="l-text" style="width: 168px;">
	       		 <input id="f_active_item__act_price" name="f_active_item__act_price" min="0" class="easyui-numberbox" style="width: 168px;" type="number" data-options="precision:2,required:true" value='<%=Utils.toPriceFromLongStr(en.getStringValue("act_price",i)) %>'/>
	       		 	
	         	 <div class="l-text-l"></div>
	         	 <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 10px;"></li>
	      <li style="width: 40px;">
	      <%if(!"detail".equals(type)){ %>
	      <a href='javascript:void(0)' onclick="removeItem(this,'<%=en.getStringValue("id",i)%>')">删除</a>
	      <%} %>
	      </li>
	    </ul>
	     <ul>
	    		<li style="width: 90px; text-align: left;">项目备注：</li>
      			 <li style="width: 770px; text-align: left;">
	       		 <div class="l-text" style="width: 768px;">
	       		 <input id="f_active_item__remark" name="f_active_item__remark" min="0" class="" style="width: 768px;" type="text"  value='<%=en.getStringValue("remark",i) %>'/>
	       		 	
	         	 <div class="l-text-l"></div>
	         	 <div class="l-text-r"></div>
	        </div>
	      	</li>
	    </ul>
	    <%}} %>
	    
	     <%-- 	<ul style="background-color: #f2f3f5;height: 50px" id="act_content">
	     
		 <li>
			    <h3>参与会所 </h3>
		 	</li>
	    </ul>
	    <ul>
	    	<%
		 		List<Gym> list = user.getMem().getCust().viewGyms;
			 	for(int i=0;i<list.size();i++){
			 	Gym g = list.get(i);
			%>
				<li><label><input type="checkbox" <%if(gyms.contains(g.gym)){ %> checked="checked" <%} %> onclick="" name="view_gym" value="<%=g.gym %>"><%=g.gymName %></label></li><li style="width: 10px;"></li>
			<% 		
			 	}
		 	%> 
	    </ul>--%>
	    <ul style="background-color: #f2f3f5;height: 50px" id="act_content">
		 	<li>
			    <h3>活动展示信息 </h3>
		 	</li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">详细图文介绍：</li>
       <li style="width: 770px; text-align: left;">
	        <div class="l-text" style="width: 100%;height: 100%;">
	          <%=UI.createEditor("f_active__content",hasF_active?f_active.getStringValue("content"):"",false,new UI_Op("width:99%;height:300px;","")) %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	  </form>
	</div>  
 </body>
 
 <script type="text/html" id="itemTpl">
 		<ul id="<#=item.id#>">	
	    		<li style="width: 90px; text-align: left;">项目名：</li>
      			 <li style="width: 170px; text-align: left;">
	       		 <div class="l-text" style="width: 168px;">
				 <input id="f_active_item__id" type="hidden" name="f_active_item__id" value="">
	       		 <input id="f_active_item__prj_type" type="hidden" name="f_active_item__prj_type" value="<#=item.card_type#>">
	       		 <input id="f_active_item__prj_id" type="hidden" name="f_active_item__prj_id" value="<#=item.id#>">
	       		 <input id="f_active_item__prj_name" name="f_active_item__prj_name" class="easyui-validatebox" style="width: 168px;" type="text" data-options="precision:0,required:true" value='<#=item.card_name#>'/>
	       		 	
	         	 <div class="l-text-l"></div>
	         	 <div class="l-text-r"></div>
	        </div>
	      </li>
	    	<li style="width: 40px;"></li>
	    		<li style="width: 90px; text-align: left;">原价：</li>
      			 <li style="width: 170px; text-align: left;">
	       		 <div class="l-text" style="width: 168px;">
	       		 <input id="f_active_item__price" name="f_active_item__price" min="0" class="easyui-numberbox" style="width: 168px;" type="number" data-options="precision:2,required:true" value='<#=item.fee#>'/>
	       		 	
	         	 <div class="l-text-l"></div>
	         	 <div class="l-text-r"></div>
	        </div>
	      </li>
	    	<li style="width: 40px;"></li>
	    		<li style="width: 90px; text-align: left;">活动价：</li>
      			 <li style="width: 170px; text-align: left;">
	       		 <div class="l-text" style="width: 168px;">
	       		 <input id="f_active_item__act_price" name="f_active_item__act_price" min="0" class="easyui-numberbox" style="width: 168px;" type="number" data-options="precision:2,required:true" value=''/>
	       		 	
	         	 <div class="l-text-l"></div>
	         	 <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 10px;"></li>
	      <li style="width: 40px;"><a href='javascript:void(0)' onclick="remove(this)">取消</a></li>
	    </ul>
 		<ul>
	    		<li style="width: 90px; text-align: left;">项目备注：</li>
      			 <li style="width: 770px; text-align: left;">
	       		 <div class="l-text" style="width: 768px;">
	       		 <input id="f_active_item__remark" name="f_active_item__remark" min="0" class="" style="width: 768px;" type="text"  value=''/>
	       		 	
	         	 <div class="l-text-l"></div>
	         	 <div class="l-text-r"></div>
	        </div>
	      	</li>
	    </ul>
</script>
<script type="text/javascript">
function check_view_gym(view_gym){
	
}

$(function(){
/* 	$("#f_active__for_mem").combobox({onChange:function(x,y){
		if("N" == x){
			$("#cardTypeUl").show();
			$("#cardList").show();
		}else{
			$("#cardTypeUl").hide();
			$("#cardList").hide();
			$("input[name=f_active_item__id]").parent().parent().parent().next().remove();
			$("input[name=f_active_item__id]").parent().parent().parent().remove();
			$("input[type='checkbox']").prop("checked",false);;
		}
		}
	}); */
});

</script>


</html>