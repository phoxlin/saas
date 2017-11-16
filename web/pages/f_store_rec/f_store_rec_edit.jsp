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
	
	Entity f_store_rec=(Entity)request.getAttribute("f_store_rec");
	boolean hasF_store_rec=f_store_rec!=null&&f_store_rec.getResultCount()>0;
%>
<!DOCTYPE HTML>
<html>
 <head>
  <jsp:include page="/public/edit_base.jsp" />
  <script type="text/javascript">
    var entity = "f_store_rec";
    var form_id = "f_store_recFormObj";
    var lockId=new UUID();
    $(document).ready(function() {
		$("#f_store_rec__goods_id").combobox({
			onChange: function (n,o) {
				$.ajax({
					url:"fit-bg-good-version-query-by-goodsId",
					type:"POST",
					dataType:"JSON",
					async:false,
					data:{goods_id:n},
					success:function(data){
						if(data.rs == "Y"){
							$("#f_store_rec__goods_version_id").combobox({
								 data:data.list,
								 valueField:'id',    
								 textField:'version'   
							});
						}else{
							error(data.rs);
						}
					}
				});
			}
		});
  });
  </script>
  <script type="text/javascript" charset="utf-8" src="pages/f_store_rec/f_store_rec.js"></script>
 </head>
<body>
	  <form class="l-form" id="f_store_recFormObj" method="post">
	    <input id="f_store_rec__id" name="f_store_rec__id" type="hidden" value='<%=hasF_store_rec?f_store_rec.getStringValue("id"):""%>'/>
	    <input id="f_store_rec__cust_name" name="f_store_rec__cust_name" type="hidden" value='<%=hasF_store_rec?f_store_rec.getStringValue("cust_name"):""%>'/>
	    <input id="f_store_rec__gym" name="f_store_rec__gym" type="hidden" value='<%=hasF_store_rec?f_store_rec.getStringValue("gym"):""%>'/>
	    <ul>
	      <li style="width: 90px; text-align: left;">仓库(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createSelectBySql("f_store_rec__store_id","select id code,store_name note from f_store",hasF_store_rec?f_store_rec.getStringValue("store_id"):"",true,"{'style':'width:164px'}") %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">商品(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%-- <input id="f_store_rec__goods_id" name="f_store_rec__goods_id" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:true,validType:'length[0,24]'" value='<%=hasF_store_rec?f_store_rec.getStringValue("goods_id"):""%>'/>
 --%>	          <%=UI.createSelectBySql("f_store_rec__goods_id","select id code,goods_name note from f_goods",hasF_store_rec?f_store_rec.getStringValue("goods_id"):"",true,"{'style':'width:164px'}") %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">商品规格(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%-- <input id="f_store_rec__goods_version_id" name="f_store_rec__goods_version_id" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:true,validType:'length[0,24]'" value='<%=hasF_store_rec?f_store_rec.getStringValue("goods_version_id"):""%>'/>
 --%>	           <%=UI.createSelectBySql("f_store_rec__goods_version_id","select id code,version note from f_good_version "+(hasF_store_rec?"where goods_id = '" +f_store_rec.getStringValue("goods_id")+"'":""),hasF_store_rec?f_store_rec.getStringValue("goods_version_id"):"",true,"{'style':'width:164px'}") %>
	          
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">出入库编号：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_store_rec__rec_no" name="f_store_rec__rec_no" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:false,validType:'length[0,50]'" value='<%=hasF_store_rec?f_store_rec.getStringValue("rec_no"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">出入库类型(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%-- <input id="f_store_rec__type" name="f_store_rec__type" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:true,validType:'length[0,20]'" value='<%=hasF_store_rec?f_store_rec.getStringValue("type"):""%>'/>
 --%>	      <%=UI.createSelect("f_store_rec__type","PUB_C019",hasF_store_rec?f_store_rec.getStringValue("type"):"",true,"{'style':'width:164px'}") %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">入库数量(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_store_rec__nums_in" name="f_store_rec__nums_in" class="easyui-numberbox" style="width: 164px;" type="text" data-options="precision:0,required:true" value='<%=hasF_store_rec?f_store_rec.getStringValue("nums_in"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">出库数量(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_store_rec__nums_out" name="f_store_rec__nums_out" class="easyui-numberbox" style="width: 164px;" type="text" data-options="precision:0,required:true" value='<%=hasF_store_rec?f_store_rec.getStringValue("nums_out"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">仓库之前库存(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_store_rec__total_nums" name="f_store_rec__total_nums" class="easyui-numberbox" style="width: 164px;" type="text" data-options="precision:0,required:true" value='<%=hasF_store_rec?f_store_rec.getStringValue("total_nums"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">仓库之后库存(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_store_rec__after_total_nums" name="f_store_rec__after_total_nums" class="easyui-numberbox" style="width: 164px;" type="text" data-options="precision:0,required:true" value='<%=hasF_store_rec?f_store_rec.getStringValue("after_total_nums"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	     <%if(hasF_store_rec && !"".equals(f_store_rec.getStringValue("mem_id"))){ %>
			<li style="width: 90px; text-align: left;">购买会员：</li>
			  <li style="width: 170px; text-align: left;">
		        <div class="l-text" style="width: 168px;">
		        	<%=UI.createSelectBySql("f_store_rec__mem_id", "select id code,mem_name note from f_mem_"+f_store_rec.getStringValue("gym")+" where id = '"+f_store_rec.getStringValue("mem_id")+"'", hasF_store_rec?f_store_rec.getStringValue("mem_id"):"", true, "{'style':'width:164px'}") %>
		          <div class="l-text-l"></div>
		          <div class="l-text-r"></div>
		        </div>
		      </li>
		      <li style="width: 40px;"></li>
			<%}else if(hasF_store_rec && !"".equals(f_store_rec.getStringValue("emp_id"))){ %>
			<li style="width: 90px; text-align: left;">购买员工：</li>
			  <li style="width: 170px; text-align: left;">
		        <div class="l-text" style="width: 168px;">
		        <%=UI.createSelectBySql("f_store_rec__emp_id", "select id code,name note from f_emp where id = '"+f_store_rec.getStringValue("emp_id")+"'",  hasF_store_rec?f_store_rec.getStringValue("emp_id"):"", true, "{'style':'width:164px'}") %>
		          <div class="l-text-l"></div>
		          <div class="l-text-r"></div>
		        </div>
		      </li>
		      <li style="width: 40px;"></li>
			
			<%} %>
	    </ul>
	    <%if(hasF_store_rec && "004".equals(f_store_rec.getStringValue("type"))){%>
		    <ul>
		      <li style="width: 90px; text-align: left;">应付金额(*)：</li>
	       <li style="width: 170px; text-align: left;">
		        <div class="l-text" style="width: 168px;">
		          <input id="f_store_rec__ca_price" name="f_store_rec__ca_price" class="easyui-numberbox" precision="2" style="width: 164px;" type="text" data-options="precision:0,required:true" value='<%=hasF_store_rec?Utils.toPriceFromLongStr(f_store_rec.getStringValue("ca_amt")):""%>'/>
		          <div class="l-text-l"></div>
		          <div class="l-text-r"></div>
		        </div>
		      </li>
		      <li style="width: 40px;"></li>
		        <li style="width: 90px; text-align: left;">实付金额(*)：</li>
	       <li style="width: 170px; text-align: left;">
		        <div class="l-text" style="width: 168px;">
		          <input id="f_store_rec__real_price" name="f_store_rec__real_price" class="easyui-numberbox" precision="2" style="width: 164px;" type="text" data-options="precision:0,required:true" value='<%=hasF_store_rec?Utils.toPriceFromLongStr(f_store_rec.getStringValue("real_amt")):""%>'/>
		          <div class="l-text-l"></div>
		          <div class="l-text-r"></div>
		        </div>
		      </li>
		      <li style="width: 40px;"></li>
		    </ul>
		    <ul>
		      <li style="width: 90px; text-align: left;">现金(*)：</li>
	       <li style="width: 170px; text-align: left;">
		        <div class="l-text" style="width: 168px;">
		          <input id="f_store_rec__ca_price" name="f_store_rec__ca_price" class="easyui-numberbox" precision="2" style="width: 164px;" type="text" data-options="precision:0,required:true" value='<%=hasF_store_rec?Utils.toPriceFromLongStr(f_store_rec.getStringValue("cash_amt")):""%>'/>
		          <div class="l-text-l"></div>
		          <div class="l-text-r"></div>
		        </div>
		      </li>
		      <li style="width: 40px;"></li>
		        <li style="width: 90px; text-align: left;">会员储值卡(*)：</li>
	       <li style="width: 170px; text-align: left;">
		        <div class="l-text" style="width: 168px;">
		          <input id="f_store_rec__real_price" name="f_store_rec__real_price" class="easyui-numberbox" precision="2" style="width: 164px;" type="text" data-options="precision:0,required:true" value='<%=hasF_store_rec?Utils.toPriceFromLongStr(f_store_rec.getStringValue("card_amt")):""%>'/>
		          <div class="l-text-l"></div>
		          <div class="l-text-r"></div>
		        </div>
		      </li>
		      <li style="width: 40px;"></li>
		    </ul>
		    <ul>
		      <li style="width: 90px; text-align: left;">银行卡刷卡(*)：</li>
	       <li style="width: 170px; text-align: left;">
		        <div class="l-text" style="width: 168px;">
		          <input id="f_store_rec__ca_price" name="f_store_rec__ca_price" class="easyui-numberbox" precision="2" style="width: 164px;" type="text" data-options="precision:0,required:true" value='<%=hasF_store_rec?Utils.toPriceFromLongStr(f_store_rec.getStringValue("card_cash_amt")):""%>'/>
		          <div class="l-text-l"></div>
		          <div class="l-text-r"></div>
		        </div>
		      </li>
		      <li style="width: 40px;"></li>
		        <li style="width: 90px; text-align: left;">代金券(*)：</li>
	       <li style="width: 170px; text-align: left;">
		        <div class="l-text" style="width: 168px;">
		          <input id="f_store_rec__real_price" name="f_store_rec__real_price" class="easyui-numberbox" precision="2" style="width: 164px;" type="text" data-options="precision:0,required:true" value='<%=hasF_store_rec?Utils.toPriceFromLongStr(f_store_rec.getStringValue("vouchers_amt")):""%>'/>
		          <div class="l-text-l"></div>
		          <div class="l-text-r"></div>
		        </div>
		      </li>
		      <li style="width: 40px;"></li>
		    </ul>
		    <ul>
		      <li style="width: 90px; text-align: left;">微信(*)：</li>
	       <li style="width: 170px; text-align: left;">
		        <div class="l-text" style="width: 168px;">
		          <input id="f_store_rec__ca_price" name="f_store_rec__ca_price" class="easyui-numberbox" precision="2" style="width: 164px;" type="text" data-options="precision:0,required:true" value='<%=hasF_store_rec?Utils.toPriceFromLongStr(f_store_rec.getStringValue("wx_amt")):""%>'/>
		          <div class="l-text-l"></div>
		          <div class="l-text-r"></div>
		        </div>
		      </li>
		      <li style="width: 40px;"></li>
		        <li style="width: 90px; text-align: left;">支付宝(*)：</li>
	       <li style="width: 170px; text-align: left;">
		        <div class="l-text" style="width: 168px;">
		          <input id="f_store_rec__real_price" name="f_store_rec__real_price" class="easyui-numberbox" precision="2" style="width: 164px;" type="text" data-options="precision:0,required:true" value='<%=hasF_store_rec?Utils.toPriceFromLongStr(f_store_rec.getStringValue("ali_amt")):""%>'/>
		          <div class="l-text-l"></div>
		          <div class="l-text-r"></div>
		        </div>
		      </li>
		      <li style="width: 40px;"></li>
		    </ul>
	    <%} %>
	    <ul>
	     <li style="width: 90px; text-align: left;">操作人(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%-- <input id="f_store_rec__emp_id" name="f_store_rec__emp_id" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:true,validType:'length[0,24]'" value='<%=hasF_store_rec?f_store_rec.getStringValue("emp_id"):""%>'/>
 --%>	      <%=UI.createSelectBySql("f_store_rec__op_id","select id code,name note from f_emp "+(hasF_store_rec?" where id ='"+f_store_rec.getStringValue("op_id")+"'":""),hasF_store_rec?f_store_rec.getStringValue("op_id"):"",true,"{'style':'width:164px'}") %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <li style="width: 90px; text-align: left;">操作时间(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createDateTimeBox("f_store_rec__op_time",hasF_store_rec?f_store_rec.getStringValue("op_time"):"",true,"width:164px;")%>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">备注：</li>
       <li style="width: 470px; text-align: left;">
	        <div class="l-text" style="width: 468px;height: 60px;">
	          <textarea id="f_store_rec__remark" name="f_store_rec__remark" class="easyui-validatebox"  style="width: 99%;height: 50px;"  data-options="required:false,validType:'length[0,100]'" ><%=hasF_store_rec?f_store_rec.getStringValue("remark"):""%></textarea>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	  </form>
 </body>
</html>