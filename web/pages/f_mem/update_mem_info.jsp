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
$(function() {
    $("#checkInNo").focus();
    //标签
    $(".tabs-inner li").click(function() {
        $(".tabs-inner li").each(function() {
            $(this).removeClass("active");
        });
        $(this).addClass("active");
        var a = $(this).children("a").attr("data-hash");
        var p = $(this).parent().siblings(".tab-content");
        $(p).children("div").removeClass("active");
        $(a).addClass("active");
    });

    //算高度
    var h = $(window).height() - $(".user-top").outerHeight(true) - $(".tabs-inner-checkin").outerHeight(true) - 30;
    $(".custom-tab-content").height(h);

    $.ajax({
        type: "POST",
        url: "fit-query-mem",
        data: {
            id: '<%=fk_user_id%>',
            gym: '<%=fk_user_gym%>'
        },
        dataType: "json",
        async: false,
        success: function(data) {
            if (data.rs == "Y") {
            	var memInfo = data.map.xx;
            	var cards = data.cards;
                var checkinfo = data.checkinfo;
                var rentBoxinfo = data.boxinfo;
//                 基本信息
               if(memInfo){
                $("#mem_name").val(memInfo.mem_name);
                $("#mem_phone").val(memInfo.phone);
                $("#mem_no").html(memInfo.mem_no);
                var option ="";
                if(memInfo.sex=="男"){
                 option ="<option value='male' selected>男</option><option value='famale'>女</option>";
                }else{
                 option ="<option value='male' >男</option><option value='famale' selected>女</option>";
                }
                $("#mem_sex").html(option);
                
                $("#birthday").val(memInfo.birthday);
                $("#pt_id").html(memInfo.pt_names);
                $("#mc_id").html(memInfo.mc_id);
                $("#user_type").html(memInfo.user_type);
                $("#mc_name").html(memInfo.mcName);
                $("#pt_name").html(memInfo.ptName);
                $("#remain_amt").val(memInfo.remainAmtStr);
                $("#state").html(memInfo.stateStr);
                if(memInfo.picUrl){
                	$("#user_head").attr("src",memInfo.picUrl+"?imageView2/1/w/200/h/180")
                }
               }
                //会员卡
                var cardInfoTpl = document.getElementById('update_cardTpl').innerHTML;
                var cardInfoTplHtml = template(cardInfoTpl, {
                    list: cards,
                    fk_user_id: '<%=fk_user_id%>',
                    fk_user_gym: '<%=user.getViewGym()%>',
					pid : memInfo.pid
				});
			$('#update_card_info').html(cardInfoTplHtml);
						} else {
							alert(data.rs);
						}
					}
				});
	});
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
            	 $("#mc_name").html(sales.name);
                 $("#mc_id").val(sales.id);
               
            }
            store.set('sales', {});
            var coach = store.getJson("coach");
            var coachid = coach.id;
            if (coachid) {
            	 $("#pt_name").html(coach.name);
                 $("#pt_id").val(coach.id);
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
function updateMemInfo(){
	var mem_name = $("#mem_name").val();
	var mem_phone = $("#mem_phone").val();
	var mem_sex = $("#mem_sex").val();
	var birthday = $("#birthday").val();
	var pt_id = $("#pt_id").val();
	var mc_id = $("#mc_id").val();
	var remain_amt = $("#remain_amt").val();
	
	  $.ajax({
	        type: "POST",
	        url: "fit-mem-update",
	        data: {
	            id: '<%=fk_user_id%>',
	            mem_name : mem_name,
	            mem_phone : mem_phone,
	            mem_sex : mem_sex,
	            birthday : birthday,
	            pt_id : pt_id,
	            mc_id : mc_id,
	            remain_amt : remain_amt
			},
			dataType : "json",
			async : false,
			success : function(data) {
				if (data.rs == "Y") {
					alert("修改成功");
                    location.reload();
				}
			}
		});

	}
    function updateCard(infoId,gym){
    	 top.dialog({
    	        url: "pages/f_mem/updateCard.jsp?fk_user_id=<%=fk_user_id%>&fk_card_id="+infoId+"&fk_user_gym="+gym,
    	        title: '修改',
    	        width: 880,
    	        height: 480,
    	        okValue: "修改",
    	        ok: function() {
    	            var iframe = $(window.parent.document).contents().find("[name=" + $(this)[0].id + "]")[0].contentWindow;
    	            iframe.updateCards(this, window);
    	            return false;
    	        },
    	        cancelValue: "取消",
    	        cancel: function() {
    	            return true;
    	        }
    	    }).showModal();
    	
    }
	//图片上传成功后需要拼接URL
	var baseUrl = "${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}";
</script>
<style>
	.user-basic-info ul>li:FIRST-CHILD {
		margin-bottom: 10px;
	}
</style>
</head>
<body style="overflow-y: hidden;">
	<!-- 视频显示区域 -->
	<div class="user-top">
		<div class="user-header" style="position: relative;">
			<img id="user_head" name="mem_info_header" src="partial/images/default_head.png?imageView2/1/w/200/h/180">
			<div class="take-photo" onclick="showCamera('<%=fk_user_id%>','<%=fk_user_gym%>')" style="cursor: pointer;">
				<i class="photo" style="margin-left: 10px"></i> 拍摄头像
			</div>
		</div>
		<div class="user-basic-info">
			<div>
				<ul>
					<li>姓&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;名 :<input type="text" id="mem_name" style="width:140px;" /></li>
					<li>电话号码 :<input type="text" id="mem_phone" style="width:140px;" /></li>
					<li class="line-one"  onclick="getemps('sales')">所属会籍：<span id="mc_name"></span> <input type="hidden" id="mc_id"></li>
					<li>卡&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;号 :<span id="mem_no"></span></li>
					<li>状态：<span id="state"></span></li>
				</ul>
			</div>
			<div>
				<ul style="margin-right: 0;">
					<li>性&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;别： <select id="mem_sex" style="width:155px;"></select> </li>
					<li>生&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日：<input type="date" id="birthday" style="width:155px;margin-left: 3px;" /></li>
					<li class="line-one" onclick="getemps('coach')" >所属教练：<span id="pt_name"></span><input type="hidden" id="pt_id"></li>
					<li>储值余额:<input type="number" id="remain_amt" style="width:140px;" /></li>
				</ul>
			</div>
		</div>
		<div style="float: unset;">
			<button class="btn btn-primary" onclick="updateMemInfo()">修改</button>
		</div>
		 
	</div>


	<div class="user-info" id="update_card_info" style="border-top: 1px solid #e4e4e4;overflow-y: auto;height: 440px;"></div>
	<jsp:include page="/partial/tpl/template.jsp"></jsp:include>
</body>
</html>