<%@page import="javax.swing.text.DefaultEditorKit.CutAction"%>
<%@page import="com.mingsokj.fitapp.utils.GymUtils"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.User"%>
<%@page import="org.apache.poi.hssf.record.PageBreakRecord"%>
<%@page import="java.io.File"%>
<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String fk_user_id = request.getParameter("fk_user_id");
	String fk_user_gym = request.getParameter("fk_user_gym");
	FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
	String gym = user.getViewGym();
	String cust_name = user.getCust_name();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<link rel="stylesheet" media="all" href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/public/sb_admin2/bower_components/bootstrap/dist/css/bootstrap.min.css" />
<link rel="stylesheet" media="all" href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/public/css/print.css" />
<script src="public/sb_admin2/bower_components/jquery/dist/jquery.min.js"></script>
<script type="text/javascript" src="public/sb_admin2/bower_components/bootstrap/dist/js/bootstrap.min.js"></script>
<link rel="stylesheet" media="all" href="partial/css/cashier.css" />
<link rel="stylesheet" media="all" href="public/fit/css/btn.css" />
<link rel="stylesheet" type="text/css" href="public/fit/css/pager.css">
<link href="public/fit/css/font-awesome.min.css" rel="stylesheet">
<script type="text/javascript" charset="utf-8" src="public/js/template.js"></script>
<script type="text/javascript" charset="utf-8" src="partial/js/mem.js"></script>
<link href="partial/css/dialog.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="public/sb_admin2/bower_components/artDialog7/css/dialog.css">
<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/artDialog7/dialog.js"></script>
<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/artDialog7/dialog-plus.js"></script>
<script type="text/javascript" charset="utf-8" src="partial/js/cashier.js"></script>
<script type="text/javascript" charset="utf-8" src="partial/js/takePhoto.js"></script>
<script type="text/javascript" src="public/js/jquery.PrintArea.js"></script>
<!-- 消息样式 -->
<link rel="stylesheet" type="text/css" href="public/message/css/messenger.css">
<link rel="stylesheet" type="text/css" href="public/message/css/messenger-theme-future.css">
<link rel="stylesheet" type="text/css" href="public/message/css/messenger-theme-ice.css">
<!-- 消息js -->
<script src="public/message/js/messenger.min.js"></script>
<script src="public/message/js/messenger-theme-future.js"></script>
<script src="public/js/store.js"></script>
<script type="text/javascript">
<!--
template.config({sTag: '<#', eTag: '#>'});
//-->

</script>
<!-- 会员操作JS -->
<script type="text/javascript">
$(function(){    //算高度
    var h = $(window).height() - $(".user-top").outerHeight(true) - $(".tabs-inner-checkin").outerHeight(true) - 30;
    $(".custom-tab-content").height(h);
    xx();
	});
	function xx(update_id){
		  $.ajax({
		        type: "POST",
		        url: "fit-mem-update-record",
		        data: {
		        	fk_user_id : '<%=fk_user_id%>',
		            gym: '<%=fk_user_gym%>',
		            update_id : update_id
		        },
		        dataType: "json",
		        async: false,
		        success: function(data) {
		            if (data.rs == "Y") {
		            	var memInfo = data.user;
		             	var cards = data.cards;
		               if(memInfo){
		                $("#mem_name").html(memInfo.mem_name);
		                $("#mem_phone").html(memInfo.phone);
		                $("#mem_no").html(memInfo.mem_no);
		                $("#mem_sex").html(memInfo.sex);
		                $("#birthday").html(memInfo.birthday);
		                $("#user_type").html(memInfo.user_type);
		                $("#mc_name").html(memInfo.mcName);
		                $("#pt_name").html(memInfo.ptName);
		                $("#remain_amt").html(memInfo.remainAmtStr);
		                $("#state").html(memInfo.stateStr);
		                if(memInfo.picUrl){
		                	$("#user_head").attr("src",memInfo.picUrl+"?imageView2/1/w/200/h/180")
		                }
		               }
		               var upate_time = data.upate_time;
		               if(upate_time){
		            	   var option="";
		            	   var selected="";
		                     for(var i = 0; i<upate_time.length;i++){
		                    	 if(upate_time[i].id == update_id){
		                    		 selected="selected";
		                    	 }else{
		                    		 selected="";
		                    	 }
		            	       option += "<option value='"+upate_time[i].id+"' "+ selected+" >"+upate_time[i].create_time+"</option>";
		                     }
		               $("#update_time").html(option);
		               }
		                //会员卡
		                 var cardInfoTpl = document.getElementById('update_record_cardTpl').innerHTML;
		                 var cardInfoTplHtml = template(cardInfoTpl, {
		                     list: cards,
		                    fk_user_id: '<%=fk_user_id%>',
		                    fk_user_gym: '<%=fk_user_gym%>',
		 					pid : memInfo.pid
		 				});
		 			$('#update_card_info').html(cardInfoTplHtml);
								} else {
									alert(data.rs);
								}
							}
						});
	}
    function updateRecordCard(msgId){
    	 top.dialog({
    	        url: "pages/f_mem/updateRecordCard.jsp?fk_update_id="+msgId,
    	        title: '修改',
    	        width: 880,
    	        height: 480,
    	        cancelValue: "关闭",
    	        cancel: function() {
    	            return true;
    	        }
    	    }).showModal();
    	
    }
	function showUpdateRecord(){
		var id = $("#update_time").val();
		xx(id);
	}
</script>
<style>
.user-basic-info ul>li:FIRST-CHILD {
	margin-bottom: 10px;
}
</style>
</head>
<body style="overflow-y: hidden;">
	<div>
		修改时间：<select id="update_time" onchange="showUpdateRecord();"></select>

	</div>
	<!-- 视频显示区域 -->
	<div class="user-top">
		<div class="user-header" style="position: relative;">
			<img id="user_head" name="mem_info_header" src="partial/images/default_head.png?imageView2/1/w/200/h/180">
		</div>
		<div class="user-basic-info">
			<div>
				<ul>
					<li>姓&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;名 :<span id="mem_name"></span></li>
					<li>电话号码 : <span id="mem_phone"></span></li>
					<li class="line-one">所属会籍：<span id="mc_name"></span>
					</li>
					<li>卡&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;号 :<span id="mem_no"></span></li>
					<li>状态：<span id="state"></span></li>
				</ul>
			</div>
			<div>
				<ul style="margin-right: 0;">
					<li>性&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;别： <span id="mem_sex"></span></li>
					<li>生&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日: <span id="birthday"></span></li>
					<li class="line-one">所属教练：<span id="pt_name"></span></li>
					<li>储值余额:<span id="remain_amt"></span></li>
				</ul>
			</div>
		</div>
	</div>
	<div class="user-info" id="update_card_info" style="border-top: 1px solid #e4e4e4; overflow-y: auto; height: 440px;"></div>
	<jsp:include page="/partial/tpl/template.jsp"></jsp:include>
</body>
</html>