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

	Entity f_goods_price_change=(Entity)request.getAttribute("f_goods_price_change");
	boolean hasF_goods_price_change=f_goods_price_change!=null&&f_goods_price_change.getResultCount()>0;
%>
<!DOCTYPE HTML>
<html>
 <head>
  <jsp:include page="/public/edit_base.jsp" />
  <script type="text/javascript">
    var entity = "f_goods_price_change";
    var form_id = "f_goods_price_changeFormObj";
    var lockId=new UUID();
    $(document).ready(function() {

    //insert js

    });
  </script>
  <script type="text/javascript" charset="utf-8" src="pages/f_goods_price_change/f_goods_price_change.js"></script>
 </head>
<body>
	  <form class="l-form" id="f_goods_price_changeFormObj" method="post">
	    <input id="f_goods_price_change__id" name="f_goods_price_change__id" type="hidden" value='<%=hasF_goods_price_change?f_goods_price_change.getStringValue("id"):""%>'/>
	    <input id="f_goods_price_change__cust_name" name="f_goods_price_change__cust_name" type="hidden" value='<%=hasF_goods_price_change?f_goods_price_change.getStringValue("cust_name"):""%>'/>
	    <input id="f_goods_price_change__gym" name="f_goods_price_change__gym" type="hidden" value='<%=hasF_goods_price_change?f_goods_price_change.getStringValue("gym"):""%>'/>
	    <ul>
	      <li style="width: 90px; text-align: left;">商品(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createSelectBySql("f_goods_price_change__goods_id","select id code,goods_name note from f_goods",hasF_goods_price_change?f_goods_price_change.getStringValue("goods_id"):"",true,"{'style':'width:164px'}") %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">规格(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createSelectBySql("f_goods_price_change__version_id","select id code,version note from f_good_version",hasF_goods_price_change?f_goods_price_change.getStringValue("version_id"):"",true,"{'style':'width:164px'}") %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">修改前进价：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_goods_price_change__before_bprice" name="f_goods_price_change__before_bprice" class="easyui-numberbox" style="width: 164px;" type="text" data-options="precision:0,required:false" value='<%=hasF_goods_price_change?Utils.toPriceFromLongStr(f_goods_price_change.getStringValue("before_bprice")):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">修改后进价：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_goods_price_change__after_bprice" name="f_goods_price_change__after_bprice" class="easyui-numberbox" style="width: 164px;" type="text" data-options="precision:0,required:false" value='<%=hasF_goods_price_change?Utils.toPriceFromLongStr(f_goods_price_change.getStringValue("after_bprice")):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">修改前售价：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_goods_price_change__before_price" name="f_goods_price_change__before_price" class="easyui-numberbox" style="width: 164px;" type="text" data-options="precision:0,required:false" value='<%=hasF_goods_price_change?Utils.toPriceFromLongStr(f_goods_price_change.getStringValue("before_price")):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">修改后售价：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_goods_price_change__after_price" name="f_goods_price_change__after_price" class="easyui-numberbox" style="width: 164px;" type="text" data-options="precision:0,required:false" value='<%=hasF_goods_price_change?Utils.toPriceFromLongStr(f_goods_price_change.getStringValue("after_price")):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">修改前员工价：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_goods_price_change__before_emp_price" name="f_goods_price_change__before_emp_price" class="easyui-numberbox" style="width: 164px;" type="text" data-options="precision:0,required:false" value='<%=hasF_goods_price_change?Utils.toPriceFromLongStr(f_goods_price_change.getStringValue("before_emp_price")):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">修改后员工价：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_goods_price_change__after_emp_price" name="f_goods_price_change__after_emp_price" class="easyui-numberbox" style="width: 164px;" type="text" data-options="precision:0,required:false" value='<%=hasF_goods_price_change?Utils.toPriceFromLongStr(f_goods_price_change.getStringValue("after_emp_price")):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">修改人(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createSelectBySql("f_goods_price_change__op_id","select id code,name note from f_emp  where cust_name = '"+cust_name+"' and gym ='"+gym+"'",hasF_goods_price_change?f_goods_price_change.getStringValue("op_id"):"",true,"{'style':'width:164px'}") %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">修改时间(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createDateTimeBox("f_goods_price_change__op_time",hasF_goods_price_change?f_goods_price_change.getStringValue("op_time"):"",true,"width:164px;")%>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	  </form>
 </body>
</html>