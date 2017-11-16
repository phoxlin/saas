<%@page import="com.mingsokj.fitapp.utils.GymUtils"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	FitUser user = (FitUser)SystemUtils.getSessionUser(request, response);
	if (user == null) {
		request.getRequestDispatcher("/").forward(request, response);
	}
	String gym = user.getViewGym();
	String cust_name = user.getCust_name();
%>
<!DOCTYPE html>
<html style="height: 100%">
<head>
<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新入会</title>
<link rel="stylesheet" type="text/css" href="public/sb_admin2/bower_components/bootstrap/dist/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="partial/css/addMem.css">
<link rel="stylesheet" type="text/css" href="public/fit/css/btn.css">
<script src="public/js/store.js"></script>
<script src="public/sb_admin2/bower_components/jquery/dist/jquery.min.js"></script>
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
$(function(){
});
function andMem(win) {
    var mem_name = $("#mem_name").val();
    if (mem_name.length <= 0) {
        alert("会员名字不能为空");
        return;
    }
    var coach = $("#coach_id").val();
    //如果选择私教卡，必须选择教练
    if($("#card_type_state").val() == "006"){
    	if(coach == undefined || coach.length<=0 || coach == ""){
    		 alert("请选择教练");
    	        return;
    	}
    }
    var sex = $("#sex").val();
    var birthday = $("#birthday").val();
    var id_card = $("#id_card").val();
    var phone = $("#phone").val();
    var contract_no = $("#contract_no").val();
    var coach_id = $("#coach_id").val();
    var sales_id = $("#sales_id").val();
    var refer_mem_id = $("#mem_id").val();
    var salesName = $("#salesName").html();
    var phoneRegex = /^1[3|4|5|7|8]\d{9}$/;
    if ( phone.length <= 0) {
        alert("会员电话不能为空");
        return;
    }else if(!phoneRegex.test(phone)) {
    	alert("请检查电话号码是否正确!");
		return false;
    }
    if ( birthday.length <= 0) {
        alert("请选择生日");
        return;
    }
    
//     if ( contract_no.length <= 0) {
//         alert("请输入合同编号");
//         return;
//     }
    if ( sales_id.length <= 0 || salesName.length <= 0) {
        alert("请选择会籍");
        return;
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
    var coach = $("#coach_id").val();
    var remark = $("#remark").val();
    var real_amt = $("#price").val();
    var contract_no = $("#contract_no").val();
    var source = $("#source").val();
    var cardNum = $("#cardNum").val() || "";
    var cardNum1 = $("#cardNum1").val() ||"";
    var cardNum2= $("#cardNum2").val() ||"";
    var cardNum3 = $("#cardNum3").val() ||"";
    var sendCard = $("#sendCard").val();
    var give_days = $("#give_days").val();
    var give_times = $("#give_times").val();
    var give_amt = $("#give_amt").val();
    var fit_purpose = $("#fit_purpose").val();
    
    var card_cash_int = $("#card_cash_int").val();
    var card_cash_fee = $("#card_cash_fee").val();
    var caPrice = Number(real_amt);
    var times = $("#times").val();
    var single_price = $("#single_price").val();
    var yajin = 0;
    if(cardNum !=""){
    	caPrice += Number(card_cash_fee);
    	yajin += Number(card_cash_fee);
    }
    if(cardNum1 !=""){
    	caPrice += Number(card_cash_fee);
    	yajin +=  Number(card_cash_fee);
    }
    if(cardNum2 !=""){
    	caPrice += Number(card_cash_fee);
    	yajin +=  Number(card_cash_fee);
    }
    if(cardNum3 !=""){
    	caPrice += Number(card_cash_fee);
    	yajin +=  Number(card_cash_fee);
    }
    var pic1 = $("#pic1").val();
    
    if("Y"==card_cash_int){
   	 if (cardNum.length <= 0) {
   	        alert("请填写卡号");
   	        return;
   	    }
   }
    var sales = $("#sales_id").val();
    var data = {
        title: "添加会员",
        flow: "com.mingsokj.fitapp.flow.impl.添加会员Flow",
        userType: 'mem',
        //消费对象，会员【mem】，员工【emp】，匿名消费【anonymous】
        userId: "-1",
        //消费对象id，如果是匿名的就为-1
        //////////////////////上面参数为必填参数/////////////////////////////////////////////
        mem_name: mem_name,
        refer_mem_id: refer_mem_id,
        sex: sex,
        birthday: birthday,
        id_card: id_card,
        phone: phone,
        card_id: card,
        activate_type: activate_type,
        active_time: active_time,
        sales_id: sales_id,
        sales_name : $("#salesName").html(),
        coach_id : coach_id,
        coach_name : $("#coachName").html(),
        source: source,
        coach: coach,
        real_amt: real_amt,
        caPrice : caPrice,
        contract_no: contract_no,
        remark: remark,
        gym: "<%=gym %>",
        cust_name: "<%=cust_name%>",
        cardNum : cardNum ,
        cardNum1 : cardNum1 ,
        cardNum2 : cardNum2 ,
        cardNum3 : cardNum3 ,
        sendCard : sendCard,
        give_times : give_times,
        give_days : give_days,
        op_id :'<%=user.getId()%>',
        salesName :salesName,
        card_cash_int : card_cash_int,
        op_id :'<%=user.getId()%>',
        card_cash_fee : yajin,
        fit_purpose : fit_purpose,
        gymName : '<%=GymUtils.getGymName(user.getViewGym())%>',
		emp_name : '<%=user.getLoginName()%>',
		pic1 : pic1,
		times:times,
        single_price:single_price
    };

    showPay(data,
    function() {
       	if(data.card_cash_int == "Y"){
       		var cardNum = data.cardNum;
       		var cardNum1 = data.cardNum1;
       		var cardNum2 = data.cardNum2;
       		var cardNum3 = data.cardNum3;
       		if(cardNum!='undefined' && cardNum.length>0){
       			alert("请将主卡放置读卡器上方,待读卡器显示绿灯,点击确定后开始写卡");
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
        setTimeout(function (){
        	win.close();
         		}, 4000 );
    });
}

</script>
</head>
<body style="height: 100%">
	<div style="height: 100%; overflow-y: auto;">
		<jsp:include page="/partial/addMem_basicMsg.jsp"></jsp:include>
	<%-- 	<jsp:include page="/partial/addMem_otherMsg.jsp"></jsp:include> --%>
		<jsp:include page="/partial/cardOp/addMem_buyCard.jsp"></jsp:include>
	<%-- 	<jsp:include page="/partial/pay.jsp"></jsp:include> --%>
	</div>
</body>
</html>