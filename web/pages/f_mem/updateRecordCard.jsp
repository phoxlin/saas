<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="com.mingsokj.fitapp.utils.MemUtils"%>
<%@page import="com.mingsokj.fitapp.m.MemInfo"%>
<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
			if (user == null) {
				request.getRequestDispatcher("/").forward(request, response);
			}
			String cust_name = user.getCust_name();
			String gym = user.getViewGym();
			String fk_update_id = request.getParameter("fk_update_id");
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<link rel="stylesheet" type="text/css" href="public/sb_admin2/bower_components/bootstrap/dist/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="partial/css/addMem.css">
<link rel="stylesheet" type="text/css" href="public/fit/css/btn.css">
<script src="public//js/store.js"></script>
<script src="public/sb_admin2/bower_components/jquery/dist/jquery.min.js"></script>
<link rel="stylesheet" type="text/css" href="public/sb_admin2/bower_components/artDialog7/css/dialog.css">
<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/artDialog7/dialog.js"></script>
<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/artDialog7/dialog-plus.js"></script>

<script type="text/javascript" charset="utf-8" src="public/js/template.js"></script>
<script type="text/javascript" charset="utf-8" src="partial/js/pay.js"></script>
<script type="text/javascript" charset="utf-8" src="partial/js/smartCard.js"></script>

<!-- 消息样式 -->
<link rel="stylesheet" type="text/css" href="public/message/css/messenger.css">
<link rel="stylesheet" type="text/css" href="public/message/css/messenger-theme-future.css">
<link rel="stylesheet" type="text/css" href="public/message/css/messenger-theme-ice.css">
<!-- 消息js -->
<script src="public/message/js/messenger.min.js"></script>
<script src="public/message/js/messenger-theme-future.js"></script>
<script type="text/javascript">
$(function(){
	showCardDetial('<%=fk_update_id%>');
});
function showCardDetial(id) {
    $.ajax({
        type: "POST",
        url: "fit-mem-update-getUserCardDetial",
        data: {
            fk_update_id : id
        },
        dataType: "json",
        async: false,
        success: function(data) {
            if (data.rs == "Y") {
            	var card = data.cards;
            	var card_type = card.card_type;
                $("#cardName").val(card.card_name);
                $("#price").val(toDecimal(card.real_amt/100));
                $("#day").val(card.deadline);
                $("#create_time").val(card.active_time);
                $("#salesName").html(card.mc_name);
                $("#sales_id").val(card.mc_id);
                $("#coachName").html(card.pt_name);
                $("#coach_id").val(card.pt_id);
                $("#remark").val(card.remark);
                if(card_type == "003"){
                	var remain_times = card.remain_times;
                	console.log(remain_times);
                	 $("#times").val(remain_times);
                	 $("#timesDiv").css("display", "block");
                }else{
                	 $("#timesDiv").css("display", "none");
                	
                }
                
            } else {
                alert(data.rs);
            }
        }
    });
}

function toDecimal(x) {
    var f = parseFloat(x);
    if (isNaN(f)) {
        return 0;
    }
    f = parseFloat(f.toFixed(2));
    return f;
}

</script>
<style>
.col-xs-10 {
	height: 18px;
}
</style>
<!-- 卡信息 -->
<div class="buy-card-info">
	<div class="container">
		<div class="col-xs-6">
			<span class="need">*</span>
			<div class="input-panel">
				<label>卡种名称</label> <input type="text" id="cardName" readonly="readonly" />
			</div>
		</div>
		<div class="col-xs-6">
			<span class="need">*</span>
			<div class="input-panel">
				<label>实付金额</label> <input type="text" id="price"  />
			</div>
		</div>
		<div class="col-xs-6">
			<span class="need">*</span>
			<div class="input-panel">
				<label>开卡日期</label> <input type="date" id="create_time" />
			</div>
		</div>
		<div class="col-xs-6">
			<span class="need">*</span>
			<div class="input-panel">
				<label>到期日期</label> <input type="date" id="day" />
			</div>
		</div>
		<div class="col-xs-6" id="timesDiv" style="display: none;">
			<span class="need">*</span>
			<div class="input-panel">
				<label>次&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;数</label> <input type="number" id="times" />
			</div>
		</div>
		<div class="col-xs-6">
			<span class="need">*</span>
			<div class="input-panel">
				<label>所属会籍</label>
				<div class="bind">
					<div class="col-xs-12" >
						<span style="vertical-align: super;" id="salesName">点击选择会籍</span> <input type="hidden" id="sales_id"> <span class="sub-title"></span>
					</div>
				</div>
			</div>
		</div>
		<div class="col-xs-6">
			<div class="input-panel">
				<label>所属教练</label>
				<div class="bind">
					<div class="col-xs-12">
						<span style="vertical-align: super;" id="coachName">点击选择教练</span> <input type="hidden" id="coach_id"> <span class="sub-title"></span>
					</div>
				</div>
			</div>
		</div>
		<div class="col-xs-12">
			<div class="input-panel">
				<label>备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注</label> <input type="text" id="remark" />
			</div>
		</div>
	</div>
</div>

