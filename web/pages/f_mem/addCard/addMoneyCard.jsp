<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/public/base.jsp" />
<link rel="stylesheet" media="all" href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/public/css/bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="public/css/user.css">
<title>添加储值卡</title>
</head>
<script type="text/javascript">
	function addCard(win, doc,window) {
		var card_name = $.trim($("#card_name").val());
		var card_days = $.trim($("#card_days").val());
		var card_fee = $.trim($("#card_fee").val());
		var checkin_fee = $.trim($("#checkin_fee").val());
		var card_amt = $.trim($("#card_amt").val());
		if (card_name.length == 0) {
			error("卡名称不能为空");
			return false;
		}
		if (card_days.length == 0) {
			error("有效天数不能为空");
			return false;
		}
		if (card_amt.length == 0) {
			error("储值金额不能为空");
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
				card_days : card_days,
				card_fee : card_fee,
				card_amt : card_amt,
				share : share,
				checkin_fee : checkin_fee,
				card_type : "002"
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
<body  style="padding:20px">
	<div class="alert alert-warning" role="alert">卡种=默认值，可帮助前台快速制卡，也可提高输入的准确性，制卡时只需要点选即可自动默认相关项</div>
	<form class="form-horizontal" id="addDaysCardForm">
		<div class="form-group">
			<label class="col-sm-2 control-label">储值卡名称</label>
			<div class="col-sm-10">
				<input type="text" class="form-control" id="card_name">
				<span class="help-block">如：储值卡、水吧卡、私教储值卡……</span>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">储值金额</label>
			<div class="col-sm-10">
				<input type="number" class="form-control" id="card_amt" value="0">
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">卡种售价</label>
			<div class="col-sm-10">
				<input type="number" class="form-control" id="card_fee" value="0">
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">有效天数</label>
			<div class="col-sm-10">
				<input type="number" class="form-control" id="card_days" > 
				<span id="helpBlock" class="help-block">例如：365 ,到期自动失效</span>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">储值卡入场费</label>
			<div class="col-sm-10">
				<input type="number" class="form-control" id="checkin_fee" > 
				<span id="helpBlock" class="help-block">例如：使用该卡入场一次的费用</span>
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