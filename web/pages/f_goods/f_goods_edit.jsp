<%@page import="com.jinhua.server.db.impl.EntityImpl"%>
<%@page import="com.jinhua.server.db.DBUtils"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.jinhua.server.db.impl.DBM"%>
<%@page import="com.jinhua.server.db.IDB"%>
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

	Entity f_goods=(Entity)request.getAttribute("f_goods");
	boolean hasF_goods=f_goods!=null&&f_goods.getResultCount()>0;
	
	String cust_name = user.getCust_name();
	String gym = user.getViewGym();
	//查询商品规格
	IDB db = new DBM();
	Connection conn = null ;
	Entity en = null;
	int version_num = 1;//标识规格条数
	if(hasF_goods){
		try{
			conn = db.getConnection();
			en = new EntityImpl("f_good_version",conn);
			int s =en.executeQuery("select * from f_good_version where goods_id = ? order by num desc",new Object[]{f_goods.getStringValue("id")});
			//en.setValue("goods_id", f_goods.getStringValue("id"));
			//int s = en.search();
			version_num = s;
		}catch(Exception e){
			
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
  <script type="text/javascript">
    var entity = "f_goods";
    var form_id = "f_goodsFormObj";
    var lockId=new UUID();
    $(document).ready(function() {

    //insert js

    });
  </script>
  <script type="text/javascript" charset="utf-8" src="pages/f_goods/f_goods.js"></script>
  <style type="text/css">
  	.easyui-numberbox{
  		margin-top: -5px
  	}
  	h3{
  		margin-top: 10px
  	}
  </style>
 </head>
<body>
	<div style="width: 1040px;height:480px;overflow: auto">
	  <form class="l-form" id="f_goodsFormObj" method="post">
	    <input id="f_goods__id" name="f_goods__id" type="hidden" value='<%=hasF_goods?f_goods.getStringValue("id"):""%>'/>
	    <input id="f_goods__cust_name" name="f_goods__cust_name" type="hidden" value='<%=hasF_goods?f_goods.getStringValue("cust_name"):cust_name%>'/>
	    <input id="f_goods__gym" name="f_goods__gym" type="hidden" value='<%=hasF_goods?f_goods.getStringValue("gym"):gym%>'/>
	    <input id="f_goods__first_letter" name="f_goods__first_letter" type="hidden" value='<%=hasF_goods?f_goods.getStringValue("first_letter"):""%>'/>
	    <input id="f_goods__create_time" name="f_goods__create_time" type="hidden" value='<%=hasF_goods?f_goods.getStringValue("create_time"):""%>'/>
	 	<ul style="background-color: #f2f3f5;height: 50px">
	 	<li>
		    <h3>商品基本信息 </h3>
	 	</li>
	    </ul>
	    <ul>
	      <li style="width: 100px; text-align: left;">分类(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" class="input-panel" style="width: 168px;">
	          <%=UI.createSelectBySql("f_goods__type","select id code,type_name note from f_goods_type where cust_name = '"+cust_name+"' and gym = '"+gym+"'",hasF_goods?f_goods.getStringValue("type"):"",true,"{'style':'width:164px','class':'input-text'}") %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 100px; text-align: left;">商品名称(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_goods__goods_name" name="f_goods__goods_name" class="easyui-validatebox input-text"  style="width: 164px;" type="text" data-options="required:true,validType:'length[0,50]'" value='<%=hasF_goods?f_goods.getStringValue("goods_name"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	       <li style="width: 100px; text-align: left;">状态(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createSelect("f_goods__state","GOOD_STATE",hasF_goods?f_goods.getStringValue("state"):"sale",true,"{'style':'width:164px'}") %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <%-- <ul>
	      <li style="width: 100px; text-align: left;">商品售价(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_goods__goods_price" name="f_goods__goods_price" class="easyui-numberbox" precision="2" style="width: 164px;" type="text" data-options="precision:0,required:true" value='<%=hasF_goods?Utils.toPriceFromLongStr(f_goods.getStringValue("goods_price")):"0"%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 100px; text-align: left;">商品进价(*)：</li>
       <li style="width: 170px; text-align: left;">	
	        <div class="l-text" style="width: 168px;">
	          <input id="f_goods__goods_bprice" name="f_goods__goods_bprice" class="easyui-numberbox" precision="2" style="width: 164px;" type="text" data-options="precision:0,required:true" value='<%=hasF_goods?Utils.toPriceFromLongStr(f_goods.getStringValue("goods_bprice")):"0"%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	       <li style="width: 100px; text-align: left;">员工价(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_goods__emp_price" name="f_goods__emp_price" class="easyui-numberbox" precision="2" style="width: 164px;" type="text" data-options="precision:0,required:true" value='<%=hasF_goods?Utils.toPriceFromLongStr(f_goods.getStringValue("emp_price")):"0"%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul> --%>
	    <ul style="height: 60px">
	      <li style="width: 100px; text-align: left;">图片地址：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_goods__pic_url" name="f_goods__pic_url" type="hidden" value="<%=hasF_goods?f_goods.getStringValue("pic_url"):""%>"><a href="javascript:uploadFile('f_goods__pic_url','','');" class="btn btn-xs btn-default btn-block" style="width: 100px;">上传文件</a><div id="_f_goods__pic_url" name="_f_goods__pic_url"><a href='' target='_blank'><img src='<%=hasF_goods?(f_goods.getStringValue("pic_url")==null?"":f_goods.getStringValue("pic_url")+"?imageView2/1/w/50/h/50"):"" %>'></a></div>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 100px; text-align: left;">标签：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_goods__labels" name="f_goods__labels" class="easyui-validatebox" data-options="required:false,validType:'length[0,100]'"  style="width: 164px;" type="text" data-options="required:false,validType:'length[0,100]'" value='<%=hasF_goods?f_goods.getStringValue("labels"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    
	  	<ul style="background-color: #f2f3f5;height: 50px">
	  		<li>
	  	  		<h3>规格与库存 </h3>
	  	  	</li>
	    </ul>
	    <ul>
	     <li style="display: none" id="store_select"> <%=UI.createSelectBySql("store_id", "select id code,store_name note from f_store where cust_name = '"+cust_name+"' and gym ='"+gym+"' and state='001'", "", false, "{'style':'width:124px'}") %></li>
	    </ul>
	    <ul>
	    <li>
	    	<table>
	    		<thead>
	    			<tr>
	    				<th width="60px">
	    				<%if(!"detail".equals(request.getParameter("type"))){ %>
		    				<input type="button" onclick="addTr()" value="添加">
	    				<%} %>
	    				</th>
	    				<th width="110px">规格名称</th>
	    				<th width="110px">条形码</th>
	    				<th width="80px">成本</th>
	    				<th width="80px">售价</th>
	    				<th width="80px">员工价</th>
	    				<th width="80px">库存</th>
	    				<th width="80px">已销售</th>
	    				<th width="100px">仓库</th>
	    				<%if(!"detail".equals(request.getParameter("type"))){ %>
		    				<th width="150px">操作</th>
	    				<%} %>
	    			</tr>
	    		</thead>
	    		<tbody id="version_body">
	    			<%if(hasF_goods){
				    	for(int i = 0;i<en.getValues().size();i++){
					    %>   
					    <tr>
					    	<td><font color='green'>存在</font>:   	
						    	<input type="hidden" name="f_good_version__id" value="<%=en.getStringValue("id",i) %>">
						    	<input type="hidden" name="f_good_version__cust_name" value="<%=en.getStringValue("cust_name",i) %>">
						    	<input type="hidden" name="f_good_version__gym" value="<%=en.getStringValue("gym",i)%>">
						    	<input type="hidden" name="f_good_version__goods_id" value="<%=en.getStringValue("goods_id",i)%>">
						    	<input type="hidden" name="f_good_version__sales_num" value="<%=en.getStringValue("sales_num",i)%>">
					    	</td>
					    	<td><input type="text" class="easyui-validatebox" data-options="required:true,validType:'length[0,100]'" name="f_good_version__version" value="<%=en.getStringValue("version",i)%>"/></td>
					    	<td><input type="text" name="f_good_version__bar_code" value="<%=en.getStringValue("bar_code",i)%>"/></td>
					    	<td><input type="number" class="easyui-numberbox" precision="2" data-options="required:true,validType:'length[0,100]'" style="width: 80px" name="f_good_version__goods_bprice" value="<%=Utils.toPriceFromLongStr(en.getStringValue("goods_bprice",i))%>"/></td>
					    	<td><input type="number" class="easyui-numberbox" precision="2" data-options="required:true,validType:'length[0,100]'" style="width: 80px" name="f_good_version__goods_price" value="<%=Utils.toPriceFromLongStr(en.getStringValue("goods_price",i))%>"/></td>
					    	<td><input type="number" class="easyui-numberbox" precision="2" data-options="required:true,validType:'length[0,100]'" style="width: 80px" name="f_good_version__emp_price" value="<%=Utils.toPriceFromLongStr(en.getStringValue("emp_price",i))%>"/></td>
					    	<td><input type="number" class="easyui-numberbox" data-options="required:true,validType:'length[0,100]'" readonly="readonly" style="width: 80px" name="f_good_version__num" value="<%=en.getStringValue("num",i)%>"/></td>
					    	<td><input type="number" class="easyui-numberbox" data-options="required:true,validType:'length[0,100]'" readonly="readonly" style="width: 80px" name="f_good_version__sales_num" value="<%=en.getStringValue("sales_num",i)%>"/></td>
					    	<td> <%=UI.createSelectBySql("f_good_version__store_id", "select id code,store_name note from f_store where cust_name = '"+cust_name+"' and gym ='"+gym+"'", en.getStringValue("store_id",i), true, "{'style':'width:134px'}") %></td>
					    	<%if(!"detail".equals(request.getParameter("type"))){ %>
					    	<td>
					    		<input type="button" onclick="deleteVersion('<%=en.getStringValue("id",i)%>',this)" value="彻底删除">
					    	</td>
					    	<%} %>
					    </tr>
					<% }}else{%>
					<%-- <tr>
					    <td><font color='red' style="width: 10px">新增</font>:</td>
				    	<td><input name="f_good_version__version" type="text" class="easyui-validatebox" data-options="required:true,validType:'length[0,100]'"/>
				    	<input type="hidden" name="f_good_version__id" value="">
				    	<input type="hidden" name="f_good_version__cust_name" value="<%=cust_name %>">
				    	<input type="hidden" name="f_good_version__gym" value="<%=gym%>">
				    	<input type="hidden" name="f_good_version__goods_id" value="">
				    	<input type="hidden" name="f_good_version__sales_num" value="">
				    	</td>
				    	<td><input type="text" name="f_good_version__bar_code"/></td>
				    	<td><input type="number" class="easyui-numberbox" precision="2" data-options="required:true,validType:'length[0,100]'" style="width: 80px" name="f_good_version__goods_bprice"/></td>
				    	<td><input type="number" class="easyui-numberbox" precision="2" data-options="required:true,validType:'length[0,100]'" style="width: 80px" name="f_good_version__goods_price"/></td>
				    	<td><input type="number" class="easyui-numberbox" precision="2" data-options="required:true,validType:'length[0,100]'" style="width: 80px" name="f_good_version__emp_price"/></td>
				    	<td><input type="text" class="easyui-numberbox" data-options="required:true,validType:'length[0,100]'" style="width: 80px" name="f_good_version__num"/></td>
				    	<td><input type="text" class="easyui-numberbox" data-options="required:true,validType:'length[0,100]'" value="0" disabled="disabled" style="width: 80px" name="f_good_version__sales_num"/></td>
				    	<td> <%=UI.createSelectBySql("f_good_version__store_id", "select id code,store_name note from f_store where cust_name = '"+cust_name+"' and gym ='"+gym+"' and state='001'", "", true, "{'style':'width:135px'}") %></td>
				    	<td><input type="button" onclick="remove(this)" value="移除"></td>
					</tr>   --%> 
				    <% }%>
	    		</tbody>
	    	</table>
	    </li>
	    </ul>
	    
	    
	    <%-- <ul>
		    <h3>规格与库存 </h3>
	    </ul>
	    
	    <ul>
	     <li style="width: 770px; text-align: left;"><font color='red'>以下是商品规格,比如：商品怡宝,分为2L、1L、250ml等,前台显示</font><font color="green">怡宝(2L)</font><font color='red'>或者</font><font color='green'>脉动(水蜜桃),脉动(青柠)</font>
	     <input type="button" onclick="addOneTr()" value="添加一行"></li>
	     <li style="display: none" id="store_select"> <%=UI.createSelectBySql("store_id", "select id code,store_name note from f_store where cust_name = '"+cust_name+"' and gym ='"+gym+"'", "", false, "{'style':'width:124px'}") %></li>
	    </ul>
	    <%if(hasF_goods){
	    	for(int i = 0;i<en.getValues().size();i++){
	    %>
			<ul>
		    	<li><font color='green'>存在</font>规格(*):</li>
		    	<li><input name="f_good_version__version" type="text" value="<%=en.getStringValue("version",i)%>"/>
		    	<input type="hidden" name="f_good_version__id" value="<%=en.getStringValue("id",i) %>">
		    	<input type="hidden" name="f_good_version__cust_name" value="<%=en.getStringValue("cust_name",i) %>">
		    	<input type="hidden" name="f_good_version__gym" value="<%=en.getStringValue("gym",i)%>">
		    	<input type="hidden" name="f_good_version__goods_id" value="<%=en.getStringValue("goods_id",i)%>">
		    	<input type="hidden" name="f_good_version__sales_num" value="<%=en.getStringValue("sales_num",i)%>">
		    	</li>
		    	<li>售价(*):</li>
		    	<li><input type="text" style="width: 80px" name="f_good_version__goods_price" value="<%=Utils.toPriceFromLongStr(en.getStringValue("goods_price",i))%>"/></li>
		    	<li>成本(*):</li>
		    	<li><input type="text" style="width: 80px" name="f_good_version__goods_bprice" value="<%=Utils.toPriceFromLongStr(en.getStringValue("goods_bprice",i))%>"/></li>
		    	<li>员工价(*):</li>
		    	<li><input type="text" style="width: 80px" name="f_good_version__emp_price" value="<%=Utils.toPriceFromLongStr(en.getStringValue("emp_price",i))%>"/></li>
		    	<li>条形码(*):</li>
		    	<li><input type="text" name="f_good_version__bar_code" value="<%=en.getStringValue("bar_code",i)%>"/></li>
		    	<li>库存(*):</li>
		    	<li><input type="text" style="width: 80px" name="f_good_version__num" value="<%=en.getStringValue("num",i)%>"/></li>
		    	<li>仓库(*):</li>
		    	<li> <%=UI.createSelectBySql("f_good_version__store_id", "select id code,store_name note from f_store where cust_name = '"+cust_name+"' and gym ='"+gym+"'", en.getStringValue("store_id",i), true, "{'style':'width:134px'}") %></li>
		    	<li><input type="button" onclick="deleteVersion('<%=en.getStringValue("id",i)%>',this)" value="彻底删除"></li>
		    </ul>	    
	    <% }}else{%>
		    <ul>
		    	<li><font color='red' style="width: 10px">新增</font></li>
		    	<li>规格(*):</li>
		    	<li><input name="f_good_version__version" type="text"/>
		    	<input type="hidden" name="f_good_version__id" value="">
		    	<input type="hidden" name="f_good_version__cust_name" value="<%=cust_name %>">
		    	<input type="hidden" name="f_good_version__gym" value="<%=gym%>">
		    	<input type="hidden" name="f_good_version__goods_id" value="">
		    	<input type="hidden" name="f_good_version__sales_num" value="">
		    	</li>
		    	<li>售价(*):</li>
		    	<li><input type="number" style="width: 80px" name="f_good_version__goods_price"/></li>
		    	<li>成本(*):</li>
		    	<li><input type="number" style="width: 80px" name="f_good_version__goods_bprice"/></li>
		    	<li>员工价(*):</li>
		    	<li><input type="number" style="width: 80px" name="f_good_version__emp_price"/></li>
		    	<li>条形码(*):</li>
		    	<li><input type="text" name="f_good_version__bar_code"/></li>
		    	<li>库存(*):</li>
		    	<li><input type="text" style="width: 80px" name="f_good_version__num"/></li>
		    	<li>仓库(*):</li>
		    	<li> <%=UI.createSelectBySql("f_good_version__store_id", "select id code,store_name note from f_store where cust_name = '"+cust_name+"' and gym ='"+gym+"'", "", true, "{'style':'width:135px'}") %></li>
		    	<li><input type="button" onclick="remove(this)" value="移除"></li>
		    </ul>
	    <% }%>--%>
	   <%-- <ul style="background-color: #f2f3f5;height: 50px;margin-top: 80px">
	    	<li>
	    		<h3 id="goods_show">商品展示 </h3>
	    	</li>
	    </ul>
	    <ul>
	      <li style="width: 100px; text-align: left;">简介：</li>
       <li style="width: 800px; text-align: left;">
	        <div class="l-text" style="width: 800px;">
	          <input id="f_goods__summary" name="f_goods__summary" class="easyui-validatebox"  style="width: 794px;" type="text" data-options="required:false,validType:'length[0,400]'" value='<%=hasF_goods?f_goods.getStringValue("summary"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	     <ul>
	      <li style="width: 100px; text-align: left;">图文内容：</li>
       <li style="width: 800px; text-align: left;">
	        <div class="l-text" style="width: auto;height:auto; ;">
	          <%=UI.createEditor("f_goods__content",hasF_goods?f_goods.getStringValue("content"):"这里是用手机端展示给用户查看的描述",false,new UI_Op("width:99%;height:150px;","")) %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul> --%>
		</form>
		</div>
 </body>
 <script type="text/javascript">
 
function addTr(){
	var selectData = $("#store_select select").combobox("getData");
	var store_select = "<input type='text' name='f_good_version__store_id'/>";
	var text = '<tr>'+
    '<td><font color="red" style="width: 10px">新增</font>:</td>'+
	'<td><input name="f_good_version__version" type="text" class="easyui-validatebox" data-options="required:true,validType:\'length[0,100]\'"/>'+
	'<input type="hidden" name="f_good_version__id" value="">'+
	'<input type="hidden" name="f_good_version__cust_name" value="<%=cust_name %>">'+
	'<input type="hidden" name="f_good_version__gym" value="<%=gym%>">'+
	'<input type="hidden" name="f_good_version__goods_id" value="">'+
	'</td>'+
	'<td><input type="text" name="f_good_version__bar_code"/></td>'+
	'<td><input type="number" class="easyui-numberbox" precision="2" data-options="required:true,validType:\'length[0,100]\'" style="width: 80px" name="f_good_version__goods_bprice"/></td>'+
	'<td><input type="number" class="easyui-numberbox" precision="2" data-options="required:true,validType:\'length[0,100]\'" style="width: 80px" name="f_good_version__goods_price"/></td>'+
	'<td><input type="number" class="easyui-numberbox" precision="2" data-options="required:true,validType:\'length[0,100]\'" style="width: 80px" name="f_good_version__emp_price"/></td>'+
	'<td><input type="text" class="easyui-numberbox" data-options="required:true,validType:\'length[0,100]\'" style="width: 80px" name="f_good_version__num"/></td>'+
	'<td><input type="text" class="easyui-numberbox" data-options="required:true,validType:\'length[0,100]\'" value="0" disabled="disabled" style="width: 80px" name="f_good_version__sales_num"/></td>'+
	'<td>'+store_select+'</td>'+
	'<td><input type="button" onclick="remove(this)" value="移除"></td>'+
	'</tr>';   
	
	$("#version_body").append(text);
	$("input[name=f_good_version__store_id]").last().combobox({
		data:selectData,
	    valueField:'value',    
	    textField:'text',
	    required:true,
	    editable:false,
	    validType:'myRequired[1]'
	});  
	//表单验证
	$("#version_body tr:last input[name=f_good_version__version]").validatebox({    
	    required: true,    
	});  
	$("#version_body tr:last input[name=f_good_version__goods_bprice]").numberbox({    
	    required: true,    
	});  
	$("#version_body tr:last input[name=f_good_version__goods_price]").numberbox({    
	    required: true,    
	});  
	$("#version_body tr:last input[name=f_good_version__emp_price]").numberbox({    
	    required: true,    
	});  
	$("#version_body tr:last input[name=f_good_version__num]").numberbox({    
	    required: true,    
	});  
	$("#version_body tr:last input[name=f_good_version__sales_num]").numberbox({    
	    required: true,    
	});  
}
 
 function addOneTr(){
	var selectData = $("#store_select select").combobox("getData");
	var store_select = "<input type='text' name='f_good_version__store_id'/>";
	var text = '<ul><li><font color="red" style="width: 10px">新增</font></li><li>规格(*):</li>'+
		'<li><input name="f_good_version__version" type="text"/>'+
	   	'<input type="hidden" name="f_good_version__id" value="">'+
	   	'<input type="hidden" name="f_good_version__goods_id" value="">'+
	   	'<input type="hidden" name="f_good_version__sales_num" value="">'+
	   	'<input type="hidden" name="f_good_version__cust_name" value="<%=cust_name%>">'+
	   	'<input type="hidden" name="f_good_version__gym" value="<%=gym%>">'+
	   	'</li>'+
	   	'<li>售价(*):</li>'+
	   	'<li><input type="text" style="width: 80px" name="f_good_version__goods_price"/></li>'+
	   	'<li>成本(*):</li>'+
	   	'<li><input type="text" style="width: 80px" name="f_good_version__goods_bprice"/></li>'+
	   	'<li>员工价(*):</li>'+
	   	'<li><input type="text" style="width: 80px" name="f_good_version__emp_price"/></li>'+
	   	'<li>条形码(*):</li>'+
	   	'<li><input type="text" name="f_good_version__bar_code"/></li>'+
	   	'<li>库存(*):</li>'+
	   	'<li><input type="text" style="width: 80px" name="f_good_version__num"/></li>'+
	   	'<li>仓库(*):</li>'+
	   	'<li>'+store_select+'</li>'+
		'<li><input type="button" onclick="remove(this)" value="移除"></li></ul>';
	   	
	//$("#f_goodsFormObj").append(text);
	$("#goods_show").parent().before(text);
	$("input[name=f_good_version__store_id]").last().combobox({
		data:selectData,
	    valueField:'value',    
	    textField:'text',
	    required:true,
	    editable:false,
	    validType:'myRequired[1]'
	});  
 }
 
 function deleteVersion(versionId,t){
	 dialog({
		title : '操作提醒',
		content :"确认要删除该规格的商品?",
		okValue : "确认",
		ok : function() {
			var flag = false;
			$.ajax({
				url:"fit-goods-version-del",
				type:"POST",
				dataType:"JSON",
				data:{version_id:versionId},
				async:false,
				success:function(data){
					if(data.rs == "Y"){
						success("删除成功");
					   $(t).parent().parent().remove();
					   flag = true;
					}
				}
			});
			return flag;
		},
		cancelValue : "取消",
		cancel : function() {
			return true;
		}
 	}).showModal();
 }
 
 function same(){
	 
 }
 
 function remove(t){
	 $(t).parent().parent().remove();
 }
 </script>
</html>