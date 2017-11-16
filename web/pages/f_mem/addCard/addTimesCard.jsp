<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/public/base.jsp" />
<link rel="stylesheet" media="all" href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/public/css/bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="public/css/user.css">
<title>添加次数卡</title>
</head>
<script type="text/javascript">
	function addCard(win, doc, window) {
		var card_name = $.trim($("#card_name").val());
		var card_times = $.trim($("#card_times").val());
		var card_days = $.trim($("#card_days").val());
		var card_fee = $.trim($("#card_fee").val());
		
		var card_leave_free_times = $.trim($("#card_leave_free_times").val());
		var card_leave_unit = $.trim($("input:radio:checked").val()||"");
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
		var share="";
		$(':radio[name=share]').each(function() {
				if ($(this).prop('checked')) {
					share = $(this).val();
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
				card_leave_free_times : card_leave_free_times,
				card_leave_unit : card_leave_unit,
				card_leave_unit_price : card_leave_unit_price,
				card_type : "003",
				share:share
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
</script>
<body  style="padding:20px;"  >
	<div style="" class="alert alert-warning" role="alert">卡种=默认值，可帮助前台快速制卡，也可提高输入的准确性，制卡时只需要点选即可自动默认相关项</div>
	<form class="form-horizontal" id="addDaysCardForm">
		<div class="form-group">
			<label class="col-sm-2 control-label">次卡名称</label>
			<div class="col-sm-10">
				<input type="text" class="form-control" id="card_name">
				<span id="helpBlock" class="help-block">如：普通次卡、充值赠送、活动次卡……</span>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">充值次数</label>
			<div class="col-sm-10">
				<input type="number" class="form-control" id="card_times" value="0"> 
				<span id="helpBlock" class="help-block">例如：365</span>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">有效天数</label>
			<div class="col-sm-4">
				<input type="number" class="form-control" id="card_days" > 
				<span id="helpBlock" class="help-block">到期自动失效,不填写则永不过期</span>
			</div>
			<label class="col-sm-2 control-label">卡种售价</label>
			<div class="col-sm-4">
				<input type="number" class="form-control" id="card_fee" value="0">
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">请假周期</label>
			<div class="col-sm-2">
				<label><input class="" name="leave_unit" type="radio" value="1">天</label>
			</div>
			<div class="col-sm-2">
				<label><input class="" name="leave_unit" type="radio" value="7">周(7天)</label>
			</div>
			<div class="col-sm-2">
				<label><input class="" name="leave_unit" type="radio" value="30">月(30天)</label>
			</div>
			<div class="col-sm-2">
				<label><input class="" name="leave_unit" type="radio" value="90">季度(90天)</label>
			</div>
			<div class="col-sm-2">
				<label><input class="" name="leave_unit" type="radio" value="365">年(365天)</label>
			</div>
		</div>
		<div class="form-group">
			
			<label class="col-sm-2 control-label">可免费请假次数</label>
			<div class="col-sm-4">
				<input type="number" class="form-control" id="card_leave_free_times" value="0"> <span id="helpBlock" class="help-block"></span>
			</div>
			<label class="col-sm-2 control-label">请假费用</label>
			<div class="col-sm-4">
				<input type="number" min="0" class="form-control" id="card_leave_unit_price"> <span id="helpBlock" class="help-block"></span>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">分享设置</label>
			<div class="col-sm-10">
				<label style="width: 82px;">
				    <input type="radio" name="share" style="width: 20px; margin-left: 6px; margin-top: 8px;" value="N" checked="checked">禁止分享
				</label>
			    <label style="width: 82px; ">
			         <input type="radio" name="share" style="width: 20px; margin-top: 8px;" value="Y">允许分享
			    </label>
				 <span id="helpBlock" class="help-block">特色营销功能，允许会员可通过微信分享此卡给好友</span>
				 <span id="helpBlock" class="help-block">好友获得次卡后，可到店体验，系统自动为相关会籍添加此潜客</span>
			</div>
		</div>
	</form>
</body>
</html>