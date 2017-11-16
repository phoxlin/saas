<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%
	String cardType = request.getParameter("cardType");
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>购买天数卡</title>
<jsp:include page="/public/base.jsp" />
<link rel="stylesheet" media="all" href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/public/css/bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="public/css/user.css">
<script type="text/javascript" charset="utf-8" src="partial/js/cashier.js"></script>
<style type="text/css">
</style>
</head>
<script type="text/javascript">
$(function() {
	$.ajax({
		type : "POST",
		url : "fit-ws-bg-Mem-getCard",
		data : {
			card_type : '<%=cardType%>'
		},
		dataType : "json",
		async : false,
		success : function(data) {
			if (data.rs == "Y") {
				var cardTpl = document.getElementById('cardTpl').innerHTML;
		        var cardTplHtml = template(cardTpl, {
					list : data.data
				});
		       $('#cardDiv').html(cardTplHtml);
			} else {
				error(data.rs);
			}

		}
	});
	$(':checkbox[name=card]').each(function() {
		$(this).click(function() {
			if ($(this).prop('checked')) {
				$(':checkbox[name=card]').prop("checked",false);
				$(this).prop('checked', 'checked');
			}
		});
	});
});

function addcard(){
	var url="";
	var type = '<%=cardType%>';
	var title = "";
	if (type == '001') {
		url = "pages/f_mem/addCard/addDaysCard.jsp";
		title = "添加天数卡";
	} else if (type == "002") {
		url = "pages/f_mem/addCard/addMoneyCard.jsp";
		title = "添加储值卡";
	} else if (type == "003") {
		url = "pages/f_mem/addCard/addTimesCard.jsp";
		title = "添加次数卡";
	} else if (type == "006") {
		url = "pages/f_mem/addCard/addClassCard.jsp";
		title = "添加私教卡";
	}
	top.dialog({
	    url: url,
	    title: title,
	    width: 800,
	    height: 550,
	    okValue: "确定",
	    ok: function() {
	        var iframe = $(window.parent.document).contents().find("[name=" + top.dialog.getCurrent().id + "]")[0].contentWindow;
	        iframe.addCard(this, document, window);
	        return false;
	    }
	}).showModal();
}
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
				$("#price").val(price);
				$("#real_amt").val(price);
				if (days == undefined) {
					days = "永久有效";
				}
				$("#day").val(days);
				$("#times").val(times);
			} else {
				error(data.rs);
			}

		}
	});
}
function showActiveTime() {
	var activate_type = $("#activate_type").val();
	if ("003" == activate_type) {
		$("#activate_time_div").css("display", "block");
	} else {
		$("#activate_time_div").css("display", "none");

	}
}
function buyCard(win, doc, window, fk_user_id) {
	var card = "";
	$(':checkbox[name=card]').each(function() {
		if ($(this).prop('checked')) {
			card = $(this).val();
		}
	});
	var activate_type = $("#activate_type").val();
	var active_time = $("#active_time").val();
	var sales = $("#sales").val();
	var remark = $("#remark").val();
	var real_amt = $("#real_amt").val();
	var contract_no = $("#contract_no").val();
	var source = $("#source").val();
	$.ajax({
		type : "POST",
		url : "fit-ws-bg-Mem-buyCard",
		data : {
			fk_user_id : fk_user_id,
			card_id : card,
			activate_type : activate_type,
			active_time : active_time,
			sales : "-1",
			source : source,
			real_amt : real_amt,
			contract_no : contract_no,
			remark : remark
		},
		dataType : "json",
		async : false,
		success : function(data) {
			if (data.rs == "Y") {
				callback_info("购买成功", function() {
					window.location.reload();
				});
			} else {
				error(data.rs);
			}

		}
	});

}
</script>
<body style="height: 100%;">
	<div style="height: 100%;">
		<ol class="breadcrumb">
			<li>1.选择卡种</li>
		</ol>
		<script type="text/html" id="cardTpl">
       <#
         if(list){  
         for(var i = 0;i<list.length;i++){#>
			<div class="col-md-2">
				<div class="checkbox">
					<label> <input type="checkbox" name="card"  onclick="showCardDetial('<#=list[i].id#>');" value="<#=list[i].id#>"><#=list[i].card_name#>
					</label>
				</div>
			</div>
       <#}}#>
		<div class="col-md-2">
		<button class="btn btn-default" type="button" onclick="addcard()">+ 添加卡种</button>
		</div>
     </script>
		<div class="row" id="cardDiv"></div>
		<ol class="breadcrumb">
			<li>2.设置信息</li>
		</ol>
		<form class="form-horizontal">
			<div class="form-group">
				<label for="inputEmail3" class="col-sm-2 control-label">金额</label>
				<div class="col-sm-10">
					<input type="text" style="width: 220px;" class="form-control" id="price" readonly="readonly"> <span id="helpBlock" class="help-block">卡种设置的默认金额</span>
				</div>
			</div>
			<%
				if ("003".equals(cardType)) {
			%>
			<div class="form-group">
				<label class="col-sm-2 control-label">充值次数</label>
				<div class="col-sm-10">
					<input type="text" style="width: 220px;" class="form-control" id="times" readonly="readonly">
				</div>
			</div>
			<%
				}
			%>
			<div class="form-group">
				<label class="col-sm-2 control-label">有效天数</label>
				<div class="col-sm-10">
					<input type="text" style="width: 220px;" class="form-control" id="day" readonly="readonly">
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-2 control-label">实收金额￥</label>
				<div class="col-sm-10">
					<input type="text" style="width: 220px;" class="form-control" id="real_amt"> <span id="helpBlock" class="help-block">可输入本次充值实际收取的金额，将会用于会籍或教练的销售统计</span>
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-2 control-label">激活方式</label>
				<div class="col-sm-10">
					<select style="width: 220px;" class="form-control" id="activate_type" name="activate_type" onchange="showActiveTime()">
						<option value="001">立即激活</option>
						<option value="002">首次刷卡开卡</option>
						<option value="003">指定日期开卡</option>
					</select>
				</div>
			</div>
			<div class="form-group" style="display: none;" id="activate_time_div">
				<label class="col-sm-2 control-label">开卡时间</label>
				<div class="col-sm-10">
					<input type="date" id="active_time" style="width: 220px;" class="form-control" name="active_time">
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-2 control-label">所属会籍</label>
				<div class="col-sm-10">
					<select style="width: 220px;" class="form-control" id="sales" name="sales">
					</select> <span id="helpBlock" class="help-block">选择本次销售的会籍</span>
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-2 control-label">合同编号</label>
				<div class="col-sm-10">
					<input type="text" style="width: 220px;" class="form-control" id="contract_no"> <span id="helpBlock" class="help-block">可输入与会员签约的合同编号</span>
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-2 control-label">业绩来源</label>
				<div class="col-sm-10">
					<select id="source" style="width: 220px;"  class="form-control">
					     <option value="1">WI-到访</option>
						<option value="2">APPT-电话邀约</option>
						<option value="3">BR-转介绍</option>
						<option value="4">TI-电话咨询</option>
						<option value="5">DI-拉访</option>
						<option value="6">POS</option>
						<option value="7">场开</option>
						<option value="8">体测</option>
						<option value="9">续费</option></select> <span id="helpBlock" class="help-block">请选择该笔业绩的来源，如POS等</span>
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-2 control-label">备注</label>
				<div class="col-sm-10">
					<textarea id="remark" style="height: 100px; width: 450px; resize: none;" placeholder="备注"></textarea>
					<span id="helpBlock" class="help-block">可在此备注本次充值的一些特殊情况</span>
				</div>
			</div>
		</form>
	</div>

</body>
</html>