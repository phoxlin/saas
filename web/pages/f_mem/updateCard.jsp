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
			String fk_user_id = request.getParameter("fk_user_id");
			String fk_user_gym = request.getParameter("fk_user_gym");
			String fk_card_id = request.getParameter("fk_card_id");
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
	showCardDetial('<%=fk_card_id%>');
});
function showCardDetial(id) {
    $.ajax({
        type: "POST",
        url: "fit-mem-getUserCardDetial",
        data: {
            fk_user_id : '<%=fk_user_id%>',
            fk_user_gym : '<%=fk_user_gym%>',
            fk_card_id : id
        },
        dataType: "json",
        async: false,
        success: function(data) {
            if (data.rs == "Y") {
            	var card = data.card;
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

function getemps(type) {
    var typeName = "员工";
    if ("sales" == type) {
        typeName = "会籍";
    } else if ("coach" == type) {
        typeName = "教练";
    }
    top.dialog({
        url: "partial/chioceEmp.jsp?userType=" + type,
        title: "选择" + typeName,
        width: 820,
        height: 550,
        okValue: "确定",
        ok: function() {
            var iframe = $(window.parent.document).contents().find("[name=" + top.dialog.getCurrent().id + "]")[0].contentWindow;
            iframe.saveId(this);
            var sales = store.getJson("sales");
            var salesid = sales.id;
            if (salesid) {
                $("#salesName").html(sales.name);
                $("#sales_id").val(sales.id);
            }
            store.set('sales', {});
            var coach = store.getJson("coach");
            var coachid = coach.id;
            if (coachid) {
                $("#coachName").html(coach.name);
                $("#coach_id").val(coach.id);
            }
            store.set('coach', {});

            return false;
        },
        cancelValue: "取消",
        cancel: function() {
            return true;
        }
    }).showModal();
}
function getMem(type) {
    var typeName = "会员";
    top.dialog({
        url: "partial/chioceMem.jsp?gym=" + '<%=gym%>',
        title: "选择" + typeName,
        width: 920,
        height: 430,
        okValue: "确定",
        ok: function() {
            var iframe = $(window.parent.document).contents().find("[name=" + top.dialog.getCurrent().id + "]")[0].contentWindow;
            iframe.saveId(this);
            var mem = store.getJson("mem");
            $("#memName").html(mem.name);
            $("#mem_id").val(mem.id);
            store.set('mem', {});
            return false;
        },
        cancelValue: "取消",
        cancel: function() {
            return true;
        }
    }).showModal();
}
function toDecimal(x) {
    var f = parseFloat(x);
    if (isNaN(f)) {
        return 0;
    }
    f = parseFloat(f.toFixed(2));
    return f;
}
function Unbundled(type) {
    if ("sales" == type) {
        $("#salesName").html("点击选择会籍");
        $("#sales_id").val("");
    }
    if ("coach" == type) {
        $("#coachName").html("点击选择教练");
        $("#coach").val("");
    }
    if ("mem" == type) {
        $("#coachName").html("点击选择会员");
        $("#coach_id").val("");
    }
}

//查找会员的推荐人
function new_mem_search_recommend() {
    var phone = $("#mem_name").val();
    if (phone.length != 11) {
        return;
    }
    $.ajax({
        type: "POST",
        url: "fit-cashier-search_recommend",
        dataType: "json",
        data: {
            phone: phone
        },
        success: function(data) {
            if (data.rs == "Y") {
                var list = data.list;
                if (list.length > 0) {
                    var memName = list[0].refer_mem_name;
                    var salesName = list[0].mc_name;
                    var coachName = list[0].pt_name;
                    if (memName != undefined && memName != "") {
                        $("#memName").html(memName);
                    }
                    if (salesName != undefined && salesName != "") {
                        $("#salesName").html(salesName);
                    }
                    if (coachName != undefined && coachName != "") {
                        $("#coachName").html(coachName);
                    }
                    var mc_id = list[0].mc_id;
                    var pt_id = list[0].pt_names;
                    var refer_mem_id = list[0].refer_mem_id;
                    if (mc_id != undefined && mc_id != "") {
                        $("#sales_id").val(mc_id);
                    }
                    if (pt_id != undefined && pt_id != "") {
                        $("#coach_id").val(pt_id);
                    }
                    if (refer_mem_id != undefined && refer_mem_id != "") {
                        $("#mem_id").val(refer_mem_id);
                    }
                }

            } else {
                alert(data.rs);
            }
            $("#remark").val("");
        }
    });

}
 function updateCards(win,wind){
	 var real_amt= $("#price").val();
	 var create_time= $("#create_time").val();
	 var deadLine= $("#day").val();
	 var times= $("#times").val();
	 var sales_id= $("#sales_id").val();
	 var coach_id= $("#coach_id").val();
	 var remark= $("#remark").val();
	 
	 $.ajax({
	        type: "POST",
	        url: "fit-mem-updateCard",
	        dataType: "json",
	        data: {
	        	real_amt : real_amt,
	        	create_time : create_time,
	        	deadLine : deadLine,
	        	times : times,
	        	sales_id : sales_id ,
	        	coach_id : coach_id,
	        	remark : remark ,
	        	fk_user_id : '<%=fk_user_id%>',
	            fk_user_gym : '<%=fk_user_gym%>',
	            fk_card_id : '<%=fk_card_id%>',
	        },
	        success: function(data) {
	            if (data.rs == "Y") {
	            	alert("修改成功");
	            	wind.location.reload();
	        }
	        }
	     });
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
					<div class="col-xs-10" onclick="getemps('sales')">
						<span style="vertical-align: super;" id="salesName">点击选择会籍</span> <input type="hidden" id="sales_id"> <span class="sub-title"></span>
					</div>
					<div class="col-xs-2">
						<button onclick="Unbundled('sales')">解绑</button>
					</div>
				</div>
			</div>
		</div>
		<div class="col-xs-6">
			<div class="input-panel">
				<label>所属教练</label>
				<div class="bind">
					<div class="col-xs-10" onclick="getemps('coach')">
						<span style="vertical-align: super;" id="coachName">点击选择教练</span> <input type="hidden" id="coach_id"> <span class="sub-title"></span>
					</div>
					<div class="col-xs-2">
						<button onclick="Unbundled('coach')">解绑</button>
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

