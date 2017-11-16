<%@page import="com.mingsokj.fitapp.utils.GymUtils"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
	if (user == null) {
		request.getRequestDispatcher("/").forward(request, response);
	}
	String gym = user.getViewGym();
	String cust_name = user.getCust_name();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
%>
<!DOCTYPE html>
<html style="height: 100%">
<head>
<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>预付定金</title>
<link rel="stylesheet" type="text/css" href="public/sb_admin2/bower_components/bootstrap/dist/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="partial/css/addMem.css">
<link rel="stylesheet" type="text/css" href="public/fit/css/btn.css">
<script src="public/js/store.js"></script>
<script src="public/sb_admin2/bower_components/jquery/dist/jquery.min.js"></script>
<script type="text/javascript" charset="utf-8" src="public/js/template.js"></script>
<script type="text/javascript" charset="utf-8" src="partial/js/pay.js"></script>
<script type="text/javascript">
	function payMoney(win,fk_user_gym,fk_user_id) {
		var pre_money = $("#pre_money").val();
		var real_money = $("#real_money").val();
		var user_time = $("#user_time").val();
		
		 var re = /^[0-9]+.?[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/  
		if(!re.test(pre_money)){
			alert("请输入正确预付金额");
			return;
		}
		if(!re.test(real_money)){
			alert("请输入正确抵扣金额");
			return;
		}
		 top.dialog({
	  		    title: '提示',
	  		  content : "你确定要预付定金【"+pre_money+"】抵扣【"+real_money+"】",
	  		    okValue: '确定',
	  		    ok: function () {
	  		    	 var data = {
	  		    	        title: "预付定金",
	  		    	        flow: "com.mingsokj.fitapp.flow.impl.预付定金Flow",
	  		    	        userType: 'mem',
	  		    	        //消费对象，会员【mem】，员工【emp】，匿名消费【anonymous】
	  		    	        userId: fk_user_id,
	  		    	        //消费对象id，如果是匿名的就为-1
	  		    	        //////////////////////上面参数为必填参数/////////////////////////////////////////////
	  		    	        fk_user_id: fk_user_id,
	  		    	        pre_money: pre_money,
	  		    	        real_money: real_money,
	  		    	        user_time: user_time,
	  		    	        real_amt: pre_money,
	  		    	        caPrice : pre_money,
	  		    	        gym: fk_user_gym,
	  		    	        cust_name: "<%=cust_name%>",
	  		    	        emp_id: "<%=user.getId()%>",
	  		    	        gymName : '<%=GymUtils.getGymName(user.getViewGym())%>',
	  					    emp_name : '<%=user.getLoginName()%>',
	  					    payTime : '<%=sdf.format(new Date())%>'
	  		    	    };
	  		    	    showPay(data,
	  		    	    function() {
	  		    	    	alert("付费成功");
	  		    	        win.close();
	  		    	    });
	  		    	
	  		    },
	  		    cancelValue: '取消',
	  		    cancel: function () {}
	  		}).showModal();
	}
	function clearNoNum(obj){ 
	    obj.value = obj.value.replace(/[^\d.]/g,"");  //清除“数字”和“.”以外的字符  
	    obj.value = obj.value.replace(/\.{2,}/g,"."); //只保留第一个. 清除多余的  
	    obj.value = obj.value.replace(".","$#$").replace(/\./g,"").replace("$#$","."); 
	    obj.value = obj.value.replace(/^(\-)*(\d+)\.(\d\d).*$/,'$1$2.$3');//只能输入两个小数  
	    if(obj.value.indexOf(".")< 0 && obj.value !=""){//以上已经过滤，此处控制的是如果没有小数点，首位不能为类似于 01、02的金额 
	        obj.value= parseFloat(obj.value); 
	    } 
	    } 
</script>

</head>
<body>
	<div class="user-basic-info">
		<div class="container">
			<div class="col-xs-12">
				<div class="col-xs-6" style="padding: 0;">
					<div class="input-panel">
						<label>预付</label> <input type="text" id="pre_money" onblur="clearNoNum(this)" />
					</div>
				</div>
				<div class="col-xs-6 input-panel" style="padding: 0; padding-left: 0;">
					<div class="input-panel">
						<label>抵扣</label> <input type="text" id="real_money" onblur="clearNoNum(this)" />
					</div>
				</div>
			</div>
<!-- 			<div class="col-xs-12"> -->
<!-- 				<div class="col-xs-6" style="padding: 0;"> -->
<!-- 					<div class="input-panel"> -->
<!-- 						<label>使用时间</label> <input type="date" id="user_time"  /> -->
<!-- 					</div> -->
<!-- 				</div> -->
<!-- 			</div> -->
		</div>
	</div>

</body>
</html>