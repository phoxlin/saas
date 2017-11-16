<%@page import="com.mingsokj.fitapp.m.Gym"%>
<%@page import="com.jinhua.server.db.impl.EntityImpl"%>
<%@page import="com.jinhua.server.db.impl.DBM"%>
<%@page import="com.jinhua.server.db.IDB"%>
<%@page import="com.jinhua.server.db.DBUtils"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
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
	FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
	if (user == null) {
		request.getRequestDispatcher("/").forward(request, response);
	}

	Entity f_card = (Entity) request.getAttribute("f_card");
	boolean hasF_card = f_card != null && f_card.getResultCount() > 0;
	String card_type = "";
	List<String> cardViewGym = new ArrayList<String>();
	if (hasF_card) {
		card_type = f_card.getStringValue("card_type");
		//卡种可见门店
		Connection conn = null;
		Boolean hasEmp = false;
		Boolean hasBind = false;
		IDB db = new DBM();
		Entity en = null;
		try {
			conn = db.getConnection();
			en = new EntityImpl(conn);
			int s = en.executeQuery("select * from f_card_gym where fk_card_id = ?",
					new Object[]{f_card.getStringValue("id")});
			for (int i = 0; i < s; i++) {
				cardViewGym.add(en.getStringValue("view_gym", i));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (conn != null) {
				DBUtils.freeConnection(conn);
			}
		}

	}
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
%>
<!DOCTYPE HTML>
<html style="height: 100%">
<head>
<jsp:include page="/public/edit_base.jsp" />
<script type="text/javascript">
	function showCardDetial(id) {
		$.ajax({
			type : "POST",
			url : "fit-ws-bg-Mem-getCardDetial",
			data : {
				card_id : id
			},
			dataType : "json",
			async : false,
			success : function(data) {
				if (data.rs == "Y") {
					var price = data.data.fee;
					var days = data.data.days;
					var times = data.data.times;
					$("#cardName").val(data.data.card_name);
					$("#price").val(price);
					if (days == undefined) {
						days = "永久有效";
					}
					$("#day").val(days);
					$("#times").val(times);
					$("#amt").val(data.data.amt);
				} else {
					error(data.rs);
				}

			}
		});
	}
	var entity = "f_card";
	var form_id = "f_cardFormObj";
	var lockId = new UUID();
	$(document).ready(function() {
		$("#f_card__card_type").combobox({
			onChange : function(nv, ov) {
				if ("001" == nv || "003" == nv || "006" == nv) {
					$("#leave_ul1").show();
					$("#leave_ul2").show();
				} else {
					$("#leave_ul1").hide();
					$("#leave_ul2").hide();
				}
				if ("006" == nv) {
					$("#viewGymUl").hide();
					$("#viewGymUl input").prop("checked", false);
				} else {
					$("#viewGymUl").show();
				}
			}
		});
		//insert js

	});
</script>
<script type="text/javascript" charset="utf-8" src="pages/f_card/f_card.js"></script>
</head>
<script type="text/html" id="partialBuyCard_CardTpl">
                  <# if(list){
                      for(var i = 0;i<list.length;i++){
                  #>
                          <div class="card-panel" onclick="showCardDetial('<#=list[i].id#>')">
                              <input type="radio"  name="cards" value="<#=list[i].id#>" id="<#=list[i].id#>"> 
                              <label for="<#=list[i].id#>">
                              	<span></span>
                              	<b><#=list[i].card_name#></b>
                              </label>
                           </div>
                  <# }}#>
               </script>
<body style="height: 100%">
	<div style="height: 100%; overflow-y: auto;">
		<form class="l-form" id="f_cardFormObj" method="post">
			<input id="f_card__id" name="f_card__id" type="hidden" value='<%=hasF_card ? f_card.getStringValue("id") : ""%>' /> <input id="f_card__cust_name" name="f_card__cust_name" type="hidden" value='<%=hasF_card ? f_card.getStringValue("cust_name") : user.getCust_name()%>' /> <input id="f_card__gym" name="f_card__gym" type="hidden" value='<%=hasF_card ? f_card.getStringValue("gym") : user.getViewGym()%>' /> <input id="f_card__op_user_id" name="f_card__op_user_id" type="hidden" value='<%=hasF_card ? f_card.getStringValue("op_user_id") : user.getId()%>' /> <input id="f_card__op_time" name="f_card__op_time" type="hidden" value='<%=hasF_card ? f_card.getStringValue("op_time") : sdf.format(new Date())%>' />
			<ul>
				<li style="width: 90px; text-align: left;">卡种名称(*)：</li>
				<li style="width: 470px; text-align: left;">
					<div class="l-text" style="width: 468px;">
						<input id="f_card__card_name" name="f_card__card_name" class="easyui-validatebox" style="width: 464px;" type="text" data-options="required:true,validType:'length[0,200]'" value='<%=hasF_card ? f_card.getStringValue("card_name") : ""%>' />
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
			</ul>
			<ul>
				<li style="width: 90px; text-align: left;">卡种类型(*)：</li>
				<li style="width: 170px; text-align: left;">
					<div class="l-text" style="width: 168px;">
						<%=UI.createSelect("f_card__card_type", "CARD_TYPE",
					hasF_card ? f_card.getStringValue("card_type") : "", true, "{'style':'width:164px'}")%>
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
				<li style="width: 90px; text-align: left;">天数：</li>
				<li style="width: 170px; text-align: left;">
					<div class="l-text" style="width: 168px;">
						<input id="f_card__days" name="f_card__days" class="easyui-numberbox" style="width: 164px;" type="text" data-options="precision:0,required:false" value='<%=hasF_card ? f_card.getStringValue("days") : "365"%>' />
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
			</ul>
			<ul>
				<li style="width: 90px; text-align: left;">储值卡金额：</li>
				<li style="width: 170px; text-align: left;">
					<div class="l-text" style="width: 168px;">
						<input id="f_card__amt" name="f_card__amt" class="easyui-numberbox" style="width: 164px;" type="text" data-options="precision:0,required:false" value='<%=hasF_card ? f_card.getStringValue("amt") : ""%>' />
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
				<li style="width: 90px; text-align: left;">次卡次数：</li>
				<li style="width: 170px; text-align: left;">
					<div class="l-text" style="width: 168px;">
						<input id="f_card__times" name="f_card__times" class="easyui-numberbox" style="width: 164px;" type="text" data-options="precision:0,required:false" value='<%=hasF_card ? f_card.getStringValue("times") : ""%>' />
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
			</ul>
			<ul>
				<li style="width: 90px; text-align: left;">储值卡入场费：</li>
				<li style="width: 170px; text-align: left;">
					<div class="l-text" style="width: 168px;">
						<input id="f_card__checkin_fee" name="f_card__checkin_fee" class="easyui-numberbox" style="width: 164px;" type="text" data-options="precision:0,required:false" value='<%=hasF_card ? f_card.getStringValue("checkin_fee") : ""%>' />
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
				<li style="width: 90px; text-align: left;">售价：</li>
				<li style="width: 170px; text-align: left;">
					<div class="l-text" style="width: 168px;">
						<input id="f_card__fee" name="f_card__fee" class="easyui-numberbox" style="width: 164px;" type="text" data-options="required:true,validType:'length[0,10]'" value='<%=hasF_card ? f_card.getStringValue("fee") : ""%>' />
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
			</ul>
			<ul id="leave_ul1" <%if (!"001".equals(card_type) && !"003".equals(card_type) && !"006".equals(card_type)) {%> style="display: none" <%}%>>
				<li style="width: 90px; text-align: left;">请假单位：</li>
				<li style="width: 170px; text-align: left;">
					<div class="l-text" style="width: 168px;">
						<%=UI.createSelect("f_card__leave_unit", "DATE_UNIT",
					hasF_card ? f_card.getStringValue("leave_unit") : "", false, "{'style':'width:164px'}")%>
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
				<li style="width: 90px; text-align: left;">请假单位价格：</li>
				<li style="width: 170px; text-align: left;">
					<div class="l-text" style="width: 168px;">
						<input id="f_card__leave_unit_price" name="f_card__leave_unit_price" class="easyui-numberbox" style="width: 164px;" type="text" data-options="precision:0,required:false" value='<%=hasF_card ? Utils.toPriceFromLongStr(f_card.getStringValue("leave_unit_price")) : ""%>' />
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
			</ul>
			<ul id="leave_ul2" <%if (!"001".equals(card_type) && !"003".equals(card_type) && !"006".equals(card_type)) {%> style="display: none" <%}%>>
				<li style="width: 90px; text-align: left;">免费请假次数：</li>
				<li style="width: 170px; text-align: left;">
					<div class="l-text" style="width: 168px;">
						<input id="f_card__leave_free_times" name="f_card__leave_free_times" class="easyui-numberbox" style="width: 164px;" type="text" data-options="precision:0,required:false" value='<%=hasF_card ? f_card.getStringValue("leave_free_times") : ""%>' />
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>


			</ul>
			<ul>
				<li style="width: 90px; text-align: left;">备注：</li>
				<li style="width: 470px; text-align: left;">
					<div class="l-text" style="width: 468px; height: 60px;">
						<textarea id="f_card__remark" name="f_card__remark" class="easyui-validatebox" style="width: 99%; height: 50px;" data-options="required:false,validType:'length[0,65000]'"><%=hasF_card ? f_card.getStringValue("remark") : ""%></textarea>
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
						<%=UI.createSelect("f_card__state", "card_sale_state",
					hasF_card ? f_card.getStringValue("state") : "", true, "{'style':'width:164px'}")%>
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
				<li style="width: 90px; text-align: left;">是否APP销售(*)：</li>
				<li style="width: 170px; text-align: left;">
					<div class="l-text" style="width: 168px;">
						<%=UI.createSelect("f_card__show_app", "PUB_C001",
					hasF_card ? f_card.getStringValue("show_app") : "", true, "{'style':'width:164px'}")%>
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
			</ul>
			<ul>
				<li style="width: 90px; text-align: left;">APP售价：</li>
				<li style="width: 170px; text-align: left;">
					<div class="l-text" style="width: 168px;">
						<input id="f_card__app_amt" name="f_card__app_amt" class="easyui-numberbox" style="width: 164px;" type="text" data-options="precision:0,required:false" value='<%=hasF_card ? f_card.getStringValue("app_amt") : ""%>' />
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
				<li style="width: 90px; text-align: left;">是否可以单独购买：</li>
				<li style="width: 170px; text-align: left;">
					<div class="l-text" style="width: 168px;">
						<%=UI.createSelect("f_card__is_lession_only", "PUB_C001",
					hasF_card ? f_card.getStringValue("is_lession_only") : "Y", false, "{'style':'width:164px'}")%>
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
			</ul>
			<ul>
				<li style="width: 90px; text-align: left;">图片地址：</li>
				<li style="width: 170px; text-align: left;">
					<div class="l-text" style="width: 168px;">
						<input id="f_card__pic_url" name="f_card__pic_url" class="easyui-validatebox" style="width: 164px;" type="text" data-options="required:false,validType:'length[0,255]'" value='<%=hasF_card ? f_card.getStringValue("pic_url") : ""%>' />
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
				<li style="width: 90px; text-align: left;" title="请输入0-100">商品折扣(%)：</li>
				<li style="width: 170px; text-align: left;">
					<div class="l-text" style="width: 168px;">
						<input id="f_card__count" name="f_card__count" class="easyui-numberbox" precision="2" style="width: 164px;" type="text" data-options="required:false,validType:'length[0,255]',min:0,max:100" value='<%=hasF_card ? f_card.getStringValue("count") : ""%>' />
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
						<input id="f_card__labels" name="f_card__labels" class="easyui-validatebox" style="width: 464px;" type="text" data-options="required:false,validType:'length[0,100]'" value='<%=hasF_card ? f_card.getStringValue("labels") : ""%>' />
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
			</ul>
			<ul>
				<li style="width: 90px; text-align: left;">简介：</li>
				<li style="width: 470px; text-align: left;">
					<div class="l-text" style="width: 468px; height: 60px">
						<textarea id="f_card__summary" name="f_card__summary" class="easyui-validatebox" style="width: 99%; height: 50px;" data-options="required:false,validType:'length[0,400]'"><%=hasF_card ? f_card.getStringValue("summary") : ""%></textarea>
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
			</ul>
			<ul>
				<li style="width: 90px; text-align: left;">图文内容：</li>
				<li style="width: 470px; text-align: left;">
					<div class="l-text" style="width: 468px; height: 60px">
						<textarea id="f_card__content" name="f_card__content" class="easyui-validatebox" style="width: 99%; height: 50px;" data-options="required:false,validType:'length[0,400]'"><%=hasF_card ? f_card.getStringValue("content") : ""%></textarea>
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
			</ul>
			<ul>
				<li style="width: 90px; text-align: left;">是否共享：</li>
				<li style="width: 170px; text-align: left;">
					<div class="l-text" style="width: 168px;">
						<%=UI.createSelect("f_card__is_share", "PUB_C001",
					hasF_card ? f_card.getStringValue("is_share") : "", false, "{'style':'width:164px'}")%>
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
				<li style="width: 90px; text-align: left;">是否家庭卡：</li>
				<li style="width: 170px; text-align: left;">
					<div class="l-text" style="width: 168px;">
						<%=UI.createSelect("f_card__is_fanmily", "PUB_C001",
					hasF_card ? f_card.getStringValue("is_fanmily") : "", false, "{'style':'width:164px'}")%>
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
			</ul>
			<%
				if (user.is系统管理员() && user.hasPower("sm_buycards")) {
			%>
			<ul id="viewGymUl" >
				<li style="width: 90px; text-align: left;">可见会所：</li>
				<li>
					<%
						List<Gym> gyms = user.getCust().viewGyms;
							for (int i = 0; i < gyms.size(); i++) {
					%> <label> <input type="checkbox" name="viewGym" value="<%=gyms.get(i).gym%>" <%if (cardViewGym.contains(gyms.get(i).gym)) {%> checked <%}%>> <%=gyms.get(i).gymName%>
				</label> <%
 	}
 %>
				</li>
			</ul>
			<%
				}
			%>
		</form>
	</div>
</body>
</html>