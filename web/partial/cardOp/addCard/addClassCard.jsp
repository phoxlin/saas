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
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	FitUser user = (FitUser)SystemUtils.getSessionUser(request, response);
	if (user == null) {
		request.getRequestDispatcher("/").forward(request, response);
	}

	Entity f_card = (Entity) request.getAttribute("f_card");
	boolean hasF_card = f_card != null && f_card.getResultCount() > 0;
	String card_type = "";
	List<String> cardViewGym = new ArrayList<String>();
	if(hasF_card){
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
			int s = en.executeQuery("select * from f_card_gym where fk_card_id = ?",new Object[]{f_card.getStringValue("id")});
			for(int i=0;i<s;i++){
				cardViewGym.add(en.getStringValue("view_gym", i));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			if(conn !=null){
				DBUtils.freeConnection(conn);
			}
		}
			
	}
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	
	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/public/base.jsp" />
<link rel="stylesheet" media="all" href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/public/css/bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="public/css/user.css">
<link rel="stylesheet" type="text/css" href="public/sb_admin2/bower_components/bootstrap/dist/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="partial/css/addMem.css">
<link rel="stylesheet" type="text/css" href="public/fit/css/btn.css">
<script src="public/sb_admin2/bower_components/jquery/dist/jquery.min.js"></script>
<title>添加次数卡</title>
</head>
<script type="text/javascript">
	function addCard(win, doc, window) {
		var f_card__show_app = $.trim($("#f_card__show_app").val());
		var f_card__app_amt = $.trim($("#f_card__app_amt").val());
		var f_card__is_share = $.trim($("#f_card__is_share").val());
		var f_card__count = $.trim($("#f_card__count").val());
		var f_card__is_lession_only = $.trim($("#f_card__is_lession_only").val());
		var f_card__labels = $.trim($("#f_card__labels").val());
		var f_card__checkin_fee = $.trim($("#f_card__checkin_fee").val());
		var f_card__summary = $.trim($("#f_card__summary").val());
		
		var card_name = $.trim($("#card_name").val());
		var card_times = $.trim($("#card_times").val());
		var card_days = $.trim($("#card_days").val());
		var card_fee = $.trim($("#card_fee").val());
		
		var card_leave_free_times = $.trim($("#card_leave_free_times").val());
		var is_fanmily = $("#is_fanmily").val();
		var card_leave_unit = $("#leave_unit").val();
		var card_leave_unit_price = $.trim($("#card_leave_unit_price").val());
		if(card_leave_unit !="" && card_leave_unit_price==""){
			error("勾选了请假周期需要设置每个周期的价钱");
			return false;
		}
		
		if (card_name.length == 0) {
			error("卡名称不能为空");
			return false;
		}
		if (card_times.length == 0) {
			error("充值次数不能为空");
			return false;
		}
		if (card_fee.length == 0) {
			error("卡种售价不能为空");
			return false;
		}
		
		if(Number(f_card__count)>100){
			error("商品折扣不能高于100%");
			return false;
		}
		var viewGym ="";
		  $('input:checkbox[name=viewGym]:checked').each(function(i){
		       if(0==i){
		    	   viewGym = $(this).val();
		       }else{
		    	   viewGym += (","+$(this).val());
		       }
		  });
		$.ajax({
			type : "POST",
			url : "fit-ws-bg-Mem-addDaysCard",
			data : {
				card_name : card_name,
				card_times : card_times,
				card_days : card_days,
				card_fee : card_fee,
				card_type : "006",
				card_leave_free_times : card_leave_free_times,
				card_leave_unit : card_leave_unit,
				card_leave_unit_price : card_leave_unit_price,
				is_fanmily : is_fanmily,
				f_card__show_app : f_card__show_app,
				f_card__app_amt : f_card__app_amt,
				f_card__is_share : f_card__is_share,
				f_card__count : f_card__count,
				f_card__is_lession_only : f_card__is_lession_only,
				f_card__labels : f_card__labels,
				f_card__checkin_fee : f_card__checkin_fee,
				f_card__summary : f_card__summary,
				viewGym : viewGym
			},
			dataType : "json",
			async : false,
			success : function(data) {
				if (data.rs == "Y") {
					callback_info("保存成功", function() {
						window.location.reload();
					});
				} else {
					error(data.rs);
				}

			}
		});
	}
	function show_app(){
		var f_card__show_app = $("#f_card__show_app").val();
		if(f_card__show_app == "Y"){
			$("#show_app_div").show();
		}else if(f_card__show_app == "N"){
			$("#show_app_div").hide();
		}
	}
	function countSingPrice(){
		var card_times = $("#card_times").val();
		var card_fee = $("#card_fee").val();
		$("#sige_fee").val(toDecimal(card_fee/card_times));
	}

	function toDecimal(x) { 
	    var f = parseFloat(x); 
	    if (isNaN(f)) { 
	      return 0; 
	    } 
	    f= parseFloat(f.toFixed(2));
	    return f; 
	  } 
</script>
<body style="padding: 20px">
	<div class="container">
		<div class="alert alert-warning" role="alert">卡种=默认值，可帮助前台快速制卡，也可提高输入的准确性，制卡时只需要点选即可自动默认相关项</div>
		<div class="col-xs-6">
			<span class="need">*</span>
			<div class="input-panel">
				<label>卡&nbsp;名&nbsp;称</label> <input type="text" id="card_name" /> <span id="helpBlock" class="help-block">如：私教卡、恢复私教卡、女神养成、产后恢复……</span>
			</div>
		</div>
		<div class="col-xs-6">
			<span class="need">*</span>
			<div class="input-panel">
				<label>充值次数</label> <input type="number" id="card_times" value="10" onkeyup="countSingPrice()" /> <span id="helpBlock" class="help-block">例如：365</span>
			</div>
		</div>
		<div class="col-xs-6">
			<span class="need">*</span>
			<div class="input-panel">
				<label>卡种售价</label> <input type="number" id="card_fee" value="0" onkeyup="countSingPrice()">
			</div>
		</div>
		<div class="col-xs-6">
			<span class="need">*</span>
			<div class="input-panel">
				<label>单&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;价</label> <input type="number" id="sige_fee" readonly="readonly">
			</div>
		</div>
		<div class="col-xs-6">
			<div class="input-panel">
				<label>有效天数</label> <input type="number" id="card_days" value="365" /> <span id="helpBlock" class="help-block">例如：365 ,到期自动失效</span>
			</div>
		</div>
		<div class="col-xs-6" >
				<div class="input-panel">
					<label class="mini">是否APP销售</label>
					<select id="f_card__show_app" onchange="show_app()">
					<option value="N">否</option>
					 <option value="Y">是</option>
					</select>
				</div>
			</div>
			<div class="col-xs-6" id = "show_app_div" style="display:none;">
				<div class="input-panel">
					<label style="padding: 0 15px!important;">&nbsp;APP售价&nbsp;&nbsp;</label>
					<input type="number" id = "f_card__app_amt"/>
				</div>
			</div>
		<div class="col-xs-6" >
				<div class="input-panel">
					<label class="mini">是否单独销售</label>
					<select id="f_card__is_lession_only">
					 <option value="Y">是</option>
					<option value="N">否</option>
					</select>
				</div>
			</div>
		<div class="col-xs-6">
			<div class="input-panel">
					<label>请假周期</label> <select id="leave_unit">
<!-- 					 <option value="">--请选择--</option> -->
					 <option value="1">天</option>
					 <option value="7">周(7天)</option>
					 <option value="30">月(30天)</option>
					 <option value="90">季度(90天)</option>
					 <option value="365">年(365天)</option>
					</select>
					<span id="helpBlock" class="help-block">不必选,如设置为周,在请假的时候按7天的倍数请假</span> 
				</div>
		</div>
		<div class="col-xs-6" >
				<div class="input-panel">
					<label>免费次数</label> <input type="text"  id="card_leave_free_times"  value="0" />
				</div>
			</div>
			<div class="col-xs-6" >
				<div class="input-panel">
					<label>请假费用</label> <input type="text"  id="card_leave_unit_price"  value="0" />
				</div>
			</div>
			<div class="col-xs-12" >
				<div class="input-panel">
					<label>简&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;介</label> <input type="text"  id="f_card__summary"/>
				</div>
			</div>
			<div class="col-xs-12" >
				<%
					List<Gym> gyms = user.getMemInfo().getCust().viewGyms;
					for(int i=0;i<gyms.size();i++){ %>
						<label>
							<input type="checkbox" name="viewGym" value="<%=gyms.get(i).gym %>" <%if(cardViewGym.contains(gyms.get(i).gym)){ %> checked <% }%>>
							<%=gyms.get(i).gymName %>
						</label>
					
					<%} %>
			</div>
	</div>
</body>
</html>