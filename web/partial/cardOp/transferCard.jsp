<%@page import="com.mingsokj.fitapp.utils.GymUtils"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);

if (user == null) {
	request.getRequestDispatcher("/").forward(request, response);
}
	String cust_name = user.getCust_name();
	String fk_user_id = request.getParameter("fk_user_id");
	String fk_user_card_id = request.getParameter("fk_card_id");
	String fee = request.getParameter("fee");
	String fk_user_gym = request.getParameter("fk_user_gym");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<link rel="stylesheet" type="text/css" href="public/sb_admin2/bower_components/bootstrap/dist/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="partial/css/addMem.css">
<link rel="stylesheet" type="text/css" href="public/fit/css/btn.css">
<script src="public/js/store.js"></script>
<script src="public/sb_admin2/bower_components/jquery/dist/jquery.min.js"></script>
<script type="text/javascript" charset="utf-8" src="public/js/template.js"></script>
<script type="text/javascript" charset="utf-8" src="partial/js/pay.js"></script>
<script type="text/javascript" charset="utf-8" src="partial/js/cashier.js"></script>

<title>转卡</title>
<script type="text/javascript">
	$(function() {
		$.ajax({
			type : "POST",
			url : "fit-transferCard-queryGymByCard",
			data : {
				fk_user_card_id :'<%=fk_user_card_id%>',
				fk_user_gym :'<%=fk_user_gym%>',
				fk_user_id : '<%=fk_user_id%>'
			},
			dataType : "json",
			async : false,
			success : function(data) {
				if (data.rs == "Y") {
					var gym = data.gym;
					 var option="";
					for(var i = 0;i<gym.length;i++){
						option+="<option value='"+gym[i].gym+"'>"+gym[i].gym_name+"</option>";
					}
					$("#gym").html(option);
				} else {
					alert(data.rs);
				}
			}
		});
	});
	function getMem(){
		var gym = $("#gym").val();
		 top.dialog({
		        url: "partial/chioceMem.jsp?gym="+gym,
		        title: "选择会员",
		        width: 820,
		        height: 430,
		        okValue: "确定",
		        ok: function() {
		        	var iframe = $(window.parent.document).contents().find("[name=" + top.dialog.getCurrent().id + "]")[0].contentWindow;
		            iframe.saveId(this);
		           var mem = store.getJson("mem");
		           if(mem){
		        	   $("#name").html(mem.name);
		        	   $("#mem_id").val(mem.id);
		           }
		           store.set('mem',{});
		           
		            return false;
		        },
		        cancelValue:"取消",
		        cancel:function(){
		        	return true;
		        }
		    }).showModal();
	}
	function tCard(win,window){
		var toGym = $("#gym").val();
		var gym = "<%=user.getViewGym()%>";
		var mem_id = $("#mem_id").val();
		var remark = $("#remark").val();
		var fee = $("#fee").val();
		var transCardNo = $("#transCardNo").val();
		if(gym.length<=0){
			alert("请选择健身房");
			return;
		}
		if(mem_id.length<=0){
			alert("请选择会员");
			return;
		}
		 var data={
					title:"转卡收费",
					flow : "com.mingsokj.fitapp.flow.impl.转卡Flow",
					userType:"mem",//消费对象，会员【mem】，员工【emp】，匿名消费【anonymous】
					userId : '<%=fk_user_id%>',//消费对象id，如果是匿名的就为-1
					//////////////////////上面参数为必填参数/////////////////////////////////////////////
					toGym:toGym,
					caPrice : fee,
					gym : gym,
					cust_name:'<%=cust_name%>',
					mem_id : mem_id,
					remark : remark,
					fk_user_card_id : '<%=fk_user_card_id%>',
					fk_user_gym :'<%=fk_user_gym%>', 
					fk_user_id : '<%=fk_user_id%>',
			        gymName : '<%=GymUtils.getGymName(user.getViewGym())%>',
			 		emp_name : '<%=user.getLoginName()%>',
			 		transCardNo:transCardNo
				};
			
			showPay(data,function() {
				alert("转卡成功");
				setTimeout(function (){
				   window.location.reload();
				}, 1000 );
			});
	}
function ChangeCardGetName(name,data){
	$("#name").html(name);
	$("#mem_id").val(data.mem_id);
}
</script>
</head>
<body>
	<div class="user-basic-info">
		<div class="container">
			<div class="col-xs-12">
				<div class="input-panel">
					<label>会员健身房</label> 
					<select id="gym">
						<option>--请选择--</option>
					</select>
				</div>
			</div>
			<div class="col-xs-12">
				<div class="input-panel">
					<label>&nbsp;&nbsp;会员姓名&nbsp;&nbsp;</label>
					<div class="bind">
						<div class="col-xs-10" onclick="getMem()">
							<span class="sub-title" id="name">点击选择用户</span>
							<input type="hidden" id="mem_id" />
						</div>
					</div>
				</div>
			</div>
			<div class="col-xs-12">
				<p >或者创建一个新会员</p>
				<button onclick="show_create_mem()" type="button" class="btn btn-primary search-btn" name="newVipUser"> &nbsp;创建新会员&nbsp; </button>
			</div>
			<div class="col-xs-12" style="margin-top: 10px;">
				<div class="input-panel">
					<textarea placeholder="备注信息" id="remark"></textarea>
				</div>
			</div>
              <div class="col-xs-12">
				<div class="input-panel">
					<label style="padding: 0 10px !important;">转卡实收金额</label> 
					<input type="number" id="fee" style="width: calc(100% - 112px)"  value="<%=fee %>"/>
				</div>
			</div>
              <div class="col-xs-12">
              	<div class="input-panel">
					<label style="padding: 0 10px !important;">卡号一并转移</label> 
					<select id="transCardNo">
						<option value="N">否</option>
						<option value="Y">是</option>
					</select>
				</div>
			</div>
		</div>
	</div>


</body>
</html>