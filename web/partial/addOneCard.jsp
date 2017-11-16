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
		var card_times = 1;
		var card_days = $.trim($("#card_days").val());
		var card_fee = $.trim($("#card_fee").val());
		var card_leave_days = $.trim($("#card_leave_days").val());
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
		if (card_fee < 0) {
			error("卡售价不能为负");
			return false;
		}
		if (card_days <= 0) {
			card_days = 1;
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
				card_leave_days : card_leave_days,
				card_type : "005",
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
<body>
	<div class="alert alert-warning" role="alert">卡种=默认值，可帮助前台快速制卡，也可提高输入的准确性，制卡时只需要点选即可自动默认相关项</div>
	<form class="form-horizontal" id="addDaysCardForm">
		<div class="form-group">
			<label class="col-sm-2 control-label">单次卡名称</label>
			<div class="col-sm-10">
				<input type="text" class="form-control" id="card_name">
				<span id="helpBlock" class="help-block">如：普通次卡、充值赠送、活动次卡……</span>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">有效天数</label>
			<div class="col-sm-10">
				<input type="number" class="form-control" id="card_days" > 
				<span id="helpBlock" class="help-block">不填写或为负数则默认为1天，填写则到期自动失效</span>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">卡种售价</label>
			<div class="col-sm-10">
				<input type="number" class="form-control" id="card_fee" value="0">
			</div>
		</div>
	</form>
</body>
</html>