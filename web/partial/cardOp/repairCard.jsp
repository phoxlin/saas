<%@page import="com.mingsokj.fitapp.utils.GymUtils"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String fk_user_id = request.getParameter("fk_user_id");
	String fk_user_card_id = request.getParameter("fk_card_id");
	String fee = request.getParameter("fee");
	String fk_user_gym = request.getParameter("fk_user_gym");
	FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
	if (user == null) {
		request.getRequestDispatcher("/").forward(request, response);
	}
	String cust_name = user.getCust_name();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<link rel="stylesheet" type="text/css" href="public/sb_admin2/bower_components/bootstrap/dist/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="partial/css/addMem.css">
<link rel="stylesheet" type="text/css" href="public/fit/css/btn.css">
<script src="public/sb_admin2/bower_components/jquery/dist/jquery.min.js"></script>
<script type="text/javascript" charset="utf-8" src="partial/js/pay.js"></script>
<script type="text/javascript" charset="utf-8" src="partial/js/smartCard.js"></script>

<!-- 消息样式 -->
<link rel="stylesheet" type="text/css" href="public/message/css/messenger.css">
<link rel="stylesheet" type="text/css" href="public/message/css/messenger-theme-future.css">
<link rel="stylesheet" type="text/css" href="public/message/css/messenger-theme-ice.css">
<!-- 消息js -->
<script src="public/message/js/messenger.min.js"></script>
<script src="public/message/js/messenger-theme-future.js"></script>

<title>补卡</title>
<script type="text/javascript">
function createCardNo(id) {
    $.ajax({
        type: "POST",
        url: "fit-cashier-createCardNo",
        data: {},
        dataType: "json",
        async: false,
        success: function(data) {
            if (data.rs == "Y") {
                $("#" + id).val(data.code);
            } else {
                error(data.rs);
            }

        }
    });
}
	function doRepairCard(win, window,fk_user_gym,fk_user_id) {
		var cardNum = $("#cardNum").val();
		if(cardNum.length<=0){
			alert("请填写卡号");
			return;
		}
		 $.ajax({
	           type: "POST",
	           url: "fit-cashier-reportedgetFee",
	           data: {
	   			},
	   			dataType : "json",
	   			async : false,
	   			success : function(data) {
	   				if (data.rs == "Y") {
	   					var fee= data.fee;
	   				    var data = {
	   				        title: "补卡手续费",
	   				        flow: "com.mingsokj.fitapp.flow.impl.补卡Flow",
	   				        userType: 'mem',
	   				        //消费对象，会员【mem】，员工【emp】，匿名消费【anonymous】
	   				        userId: fk_user_id,
	   				        //消费对象id，如果是匿名的就为-1
	   				        //////////////////////上面参数为必填参数/////////////////////////////////////////////
	   				        sales: "-1",
	   				        mem_no:cardNum,
	   				        real_amt: fee,
	   				        caPrice : fee,
	   				        gym : fk_user_gym,
	   				        cust_name : '<%=cust_name%>',
	  		    	        gymName : '<%=GymUtils.getGymName(user.getViewGym())%>',
	  					    emp_name : '<%=user.getLoginName()%>',
	  					    payTime : '<%=sdf.format(new Date())%>'
	   				    };
	   				 	
	   				    showPay(data,
	   				    function() {
	   				    	writeCard(cardNum);//写卡
	   						win.close();
	   				     setTimeout(function (){
	   					    window.location.reload();
	   				 		}, 1000 );
	   				    });
	   				} else {
	   					alert(data.rs);
	   				}
	   			}
	   		});
	}
</script>
</head>
<body>
	<div class="container">
		<div class="row" style="margin-top: 15px;">
			<div class="col-xs-6">
				<div class="input-panel">
					<label>主&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;卡</label>
					<div class="bind">
						<div class="col-xs-9">
							<input type="text" placeholder="自动生成卡号" id="cardNum" style="width: 100%" />
						</div>
						<div class="col-xs-3">
							<button onclick="createCardNo('cardNum')">生成卡号</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>