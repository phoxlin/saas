<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String cashier_handNo = request.getParameter("cashier_handNo");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<script src="public/sb_admin2/bower_components/jquery/dist/jquery.min.js"></script>
<script type="text/javascript" src="public/sb_admin2/bower_components/bootstrap/dist/js/bootstrap.min.js"></script>
<link rel="stylesheet" type="text/css" href="public/sb_admin2/bower_components/bootstrap/dist/css/bootstrap.min.css">
<link rel="stylesheet" media="all" href="partial/css/cashier.css" />
<link rel="stylesheet" media="all" href="public/fit/css/btn.css" />
<script type="text/javascript" charset="utf-8" src="public/js/template.js"></script>
<script type="text/javascript">

  $(function(){
	  $.ajax({
			type : "POST",
			url : "fit-cashier-seachMemByHandNo",
			data : {
				cashier_handNo : '<%=cashier_handNo%>',
			},
			dataType : "json",
			success : function(data) {
				if (data.rs == "Y") {
					var user = data.user;
					if(user){
					$("#userName").html(user.mem_name);
					$("#phone").html(user.phone);
					$("#checkin_time").html(user.checkin_time);
					}
				} else {
					alert(data.rs);
				}
				$("#remark").val("");
			}
		}); 
  });


	function backHandNo(win, window) {
		var remark = $("#remark").val();
		$.ajax({
			type : "POST",
			url : "fit-cashier-backHandNo",
			data : {
				cashier_handNo : '<%=cashier_handNo%>',
				remark : remark
			},
			dataType : "json",
			success : function(data) {
				if (data.rs == "Y") {
					alert("归还成功");
					window.location.reload();
				} else {
					alert(data.rs);
				}
				$("#remark").val("");
			}
		});

	}
</script>
</head>
<body>
	<div class="row">
		<div class="col-xs-4" style="text-align: center;">
			<img src="public/fit/images/cashier/default_head.png"  style="height:170px; width: 170px;border: 3px solid #dedede; margin: 50px auto 0 auto;">
			<div id="userName" style="margin: 0; display: block; height: 40px; width: 100%; line-height: 40px; font-size: 20px; font-weight: 100;"></div>
			<div id="phone" style="margin: 0; display: block; height: 20px; width: 100%; line-height: 20px; font-size: 18px; font-weight: 100;"></div>
		</div>
		<div class="col-xs-8"  style="text-align: center;">
			<div  style="margin: 10px; line-height: 20px; font-size: 18px; font-weight: 100;color: #aeadad;">
			 签到时间：<span id="checkin_time"></span>
			</div>
			<div style="width: 350px; height: 100px; text-align: center; font-size: 60px; border-radius: 4px; border: 1px solid #dedede; color: red; margin: 20px auto 0 auto; background-color: rgb(235,235,228);">
				<%=cashier_handNo%>
			</div>
			<div style="margin: 0; display: block; height: 40px; width: 350px; line-height: 40px; font-size: 16px; font-weight: 100; text-align: left; margin-left: 95px; color: #aeadad;">备注</div>
			<textarea id="remark" class="form-control" rows="3" style="width: 350px; margin-left: 95px; height: 80px;" placeholder=""></textarea>
		</div>
	</div>

</body>
</html>