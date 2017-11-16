<%@page import="com.mingsokj.fitapp.m.MemInfo"%>
<%@page import="com.mingsokj.fitapp.utils.MemUtils"%>
<%@page import="com.mingsokj.fitapp.utils.GymUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%
	String fk_user_id = request.getParameter("fk_user_id");
	FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);

	if (user == null) {
		request.getRequestDispatcher("/").forward(request, response);
	}
	String gym = user.getViewGym();
	String cust_name = user.getCust_name();
	MemInfo	mem = MemUtils.getMemInfo(fk_user_id, cust_name);
    String mem_no  = mem.getMem_no();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html style="height: 100%;">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>购卡</title>
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
<!--
	template.config({
		sTag : '<#', eTag: '#>'
	});
//-->
function buyCard(win, window, fk_user_id) {
	
    //如果选择了私教卡必须选择教练
    var card_type_state = $("#card_type_state").val();
    var coach_id = $("#coach_id").val();
    var sales_id = $("#sales_id").val();
    if(sales_id == undefined || sales_id.length<=0){
    	alert("请选择会籍");
        return;
    }
    if (card_type_state == "006") {
        if (coach_id == "" || coach_id == undefined || coach_id.length <= 0) {
            alert("请选择教练");
            return;
        }
    }
    var card = "";
    $(':radio[name=cards]').each(function() {
        if ($(this).prop('checked')) {
            card = $(this).val();
        }
    });
    if (card.length <= 0) {
        alert("请选择一张卡");
        return;
    }
    var activate_type = $("#activate_type").val();
    var active_time = $("#active_time").val();
    

    var remark = $("#remark").val();
    var real_amt = $("#price").val();
    var source = $("#source").val();
    var cardNum = $("#cardNum").val();
    var cardNum1 = $("#cardNum1").val() || "";
    var cardNum2 = $("#cardNum2").val() || "";
    var cardNum3 = $("#cardNum3").val() || "";
    var contract_no = $("#contract_no").val();
//     if(contract_no == undefined || contract_no.length <=0){
//     	alert("请生成合同号");
//     	return;
//     }
    var sendCard = $("#sendCard").val();
    var give_days = $("#give_days").val();
    var give_times = $("#give_times").val();
    var give_amt = $("#give_amt").val();
    var salesName = $("#salesName").html();
    var card_cash_int = $("#card_cash_int").val();
    var card_cash_fee = $("#card_cash_fee").val();
    var times = $("#times").val();
    var single_price = $("#single_price").val();
    
    var caPrice = Number(real_amt);
    var yajin = 0;
    if (cardNum != "") {
        caPrice += Number(card_cash_fee);
        yajin += Number(card_cash_fee);
    }
    if (cardNum1 != "") {
        caPrice += Number(card_cash_fee);
        yajin += Number(card_cash_fee);
    }
    if (cardNum2 != "") {
        caPrice += Number(card_cash_fee);
        yajin += Number(card_cash_fee);
    }
    if (cardNum3 != "") {
        caPrice += Number(card_cash_fee);
        yajin += Number(card_cash_fee);
    }

    var preFee = $("#preFee").val();
    var pre_fee = 0;
    var preId = "";
    if (preFee != "0") {
        preId = preFee.split("_")[0];
        pre_fee = Number(preFee.split("_")[1]);
    }
    caPrice = caPrice - pre_fee;
    
    if ("Y" == card_cash_int&& '<%=mem_no%>' =="" ) {
        if (cardNum.length <= 0) {
            alert("请填写卡号");
            return;
        }
    }
    var  discount = caPrice - yajin;
    if (discount < 0) {
    	 caPrice = yajin;
    }
    var data = {
        title: "购卡",
        flow: "com.mingsokj.fitapp.flow.impl.购卡Flow",
        userType: 'mem',
        //消费对象，会员【mem】，员工【emp】，匿名消费【anonymous】
        userId: fk_user_id,
        //消费对象id，如果是匿名的就为-1
        //////////////////////上面参数为必填参数/////////////////////////////////////////////
        card_id: card,
        preId: preId,
        pre_fee: pre_fee,
        activate_type: activate_type,
        active_time: active_time,
        sales_id: sales_id,
        sales_name: $("#salesName").html(),
        coach_id: coach_id,
        coach_name: $("#coachName").html(),
        source: source,
        real_amt: real_amt,
        caPrice: caPrice,
        contract_no: contract_no,
        remark: remark,
        gym: "<%=gym%>",
        cust_name: "<%=cust_name%>",
        cardNum: cardNum,
        cardNum1: cardNum1,
        cardNum2: cardNum2,
        cardNum3: cardNum3,
        sendCard: sendCard,
        give_times: give_times,
        give_days: give_days,
        op_id: '<%=user.getId()%>',
        salesName: salesName,
        card_cash_int: card_cash_int,
        card_cash_fee: yajin,
        gymName: '<%=GymUtils.getGymName(user.getViewGym())%>',
        emp_name: '<%=user.getLoginName()%>',
        times:times,
        single_price:single_price
    };
     
    if (discount < 0) {
        top.dialog({
            title: '确认',
            content: '抵扣金额大于卡片的价格，是否要使用抵扣?',
            okValue: "确定",
            ok: function() {
                showPay(data,
                function() {
                    win.close();
                    setTimeout(function() {
                        window.location.reload();
                    },
                    1000);
                });
            },
            cancelValue: "取消",
            cancel: function() {
                return true;
            }
        }).showModal();
    } else {
        showPay(data,
        function() {
        	//发卡
        	if(data.card_cash_int == "Y"){
        		var cardNum = data.cardNum;
        		var cardNum1 = data.cardNum1;
        		var cardNum2 = data.cardNum2;
        		var cardNum3 = data.cardNum3;
        		if(cardNum!='undefined' && cardNum.length>0){
           			alert("请将主卡放置读卡器上方,点击确定后开始写卡");
           			var rs = writeCard2(cardNum);
           			/* var i = 0;
    				while(rs == "N"){
    					var falg = confirm("主卡号写卡失败,是否重试");
    					if(falg){
    						rs = writeCard2(cardNum);
    						i++;
    					}else{
    						rs = "Y";
    					}
    					if(i == 3){
    						rs = "Y";
    						alert("写卡失败次数过多,请检查读卡器连接或者联系管理员");
    					}
    				} */
           		}
           		if(cardNum1!='undefined' && cardNum1.length>0){
           			alert("请将副卡1放置读卡器上方,待读卡器显示绿灯,点击确定后开始写卡");
           			var rs = writeCard2(cardNum1);
           			/* var i = 0;
    				while(rs == "N"){
    					var falg = confirm("副卡1写卡失败,是否重试");
    					if(falg){
    						rs = writeCard2(cardNum1);
    						i++;
    					}else{
    						rs = "Y";
    					}
    					if(i == 3){
    						rs = "Y";
    						alert("写卡失败次数过多,请检查读卡器连接或者联系管理员");
    					}
    				} */
           		}
           		if(cardNum2!='undefined' && cardNum2.length>0){
           			alert("请将副卡2放置读卡器上方,待读卡器显示绿灯,点击确定后开始写卡");
           			var rs = writeCard2(cardNum2);
           			/* var i = 0;
    				while(rs == "N"){
    					var falg = confirm("副卡2写卡失败,是否重试");
    					if(falg){
    						rs = writeCard2(cardNum2);
    						i++;
    					}else{
    						rs = "Y";
    					}
    					if(i == 3){
    						rs = "Y";
    						alert("写卡失败次数过多,请检查读卡器连接或者联系管理员");
    					}
    				} */
           		}
           		if(cardNum3!='undefined'  && cardNum3.length>0){
           			alert("请将副卡3放置读卡器上方,待读卡器显示绿灯,点击确定后开始写卡");
           			var rs = writeCard2(cardNum3);
           			/* var i = 0;
    				while(rs == "N"){
    					var falg = confirm("副卡3写卡失败,是否重试");
    					if(falg){
    						rs = writeCard2(cardNum3);
    						i++;
    					}else{
    						rs = "Y";
    					}
    					if(i == 3){
    						rs = "Y";
    						alert("写卡失败次数过多,请检查读卡器连接或者联系管理员");
    					}
    				} */
           		}        		
        	}
            win.close();
            setTimeout(function() {
                window.location.reload();
            },
            2000);
        });
    }

}
$(function() {
    $.ajax({
        type: "POST",
        url: "fit-cashier-search_recommend",
        dataType: "json",
        data: {
            fk_user_id: '<%=fk_user_id%>'
        },
        success: function(data) {
            if (data.rs == "Y") {
                var list = data.list;
                if (list.length > 0) {
                    $("#birthday").val(list[0].birthday);
                    $("#id_card").val(list[0].id_card);
                    var mem_name = list[0].mem_name;
                    var salesName = list[0].mc_name;
                    var coachName = list[0].pt_name;
                    if(mem_name != undefined || mem_name.length>0){
                    	
                    $("#mem_name").val(list[0].mem_name);
                    }
                    if(salesName != undefined && salesName.length>0){
                    	 $("#salesName").html(list[0].mc_name);
                    }
                    if(coachName != undefined && coachName.length>0){
                    $("#coachName").html(list[0].pt_name);
                  
                    }
                   
                    var mc_id = list[0].mc_id;
                    var pt_id = list[0].pt_names;
                    var refer_mem_phone = list[0].refer_mem_phone;
                    if (mc_id != undefined) {
                        $("#sales_id").val(mc_id);
                    }
                    if (pt_id != undefined) {
                        $("#coach_id").val(pt_id);
                    }
                }
            } else {
                alert(data.rs);
            }
            $("#remark").val("");
        }
    });

});
</script>
</head>
<body style="height: 100%;">
	<div style="height: 100%; overflow-y: auto; overflow-x: hidden;">
		<jsp:include page="/partial/cardOp/addMem_buyCard.jsp">
			<jsp:param value="<%=fk_user_id%>" name="fk_user_id" />
		</jsp:include>
	</div>
</body>
</html>