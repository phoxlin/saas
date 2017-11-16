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
<script type="text/javascript" charset="utf-8" src="partial/js/fingerPrint.js"></script>
<script type="text/javascript" src="public/js/jquery.PrintArea.js"></script>
<!-- 消息样式 -->
<link rel="stylesheet" type="text/css" href="public/message/css/messenger.css">
<link rel="stylesheet" type="text/css" href="public/message/css/messenger-theme-future.css">
<link rel="stylesheet" type="text/css" href="public/message/css/messenger-theme-ice.css">
<!-- 消息js -->
<script src="public/message/js/messenger.min.js"></script>
<script src="public/message/js/messenger-theme-future.js"></script>
<script type="text/javascript">
<!--
template.config({sTag: '<#', eTag: '#>'});
//-->

var tips=[
          {queryStr:'',text:'',angle:'',distance:'',showAfter:'',hideAfter:''},
          {queryStr:'',text:'',angle:'',distance:'',showAfter:'',hideAfter:''},
          {queryStr:'',text:'',angle:'',distance:'',showAfter:'',hideAfter:''},
          {queryStr:'',text:'',angle:'',distance:'',showAfter:'',hideAfter:''}
          ];

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
                $("#mem_no").html(memInfo.mem_no);
                $("#birthday").html(memInfo.birthday);
                $("#user_type").html(memInfo.user_type);
                $("#sales_name").html(memInfo.mcName);
                $("#pt_name").html(memInfo.ptName);
                $("#remain_amt").html(memInfo.remainAmtStr);
                $("#state").html(memInfo.stateStr);
                if(memInfo.picUrl){
                	$("#user_head").attr("src",memInfo.picUrl+"?imageView2/1/w/200/h/180")
                }
               }
                //租柜
                
                if (!$.isEmptyObject(rentBoxinfo) ) {
                	 var area_no = rentBoxinfo.area_no;
                     var box_no = rentBoxinfo.box_no;
                     var boxHtml =area_no+"区"+box_no+"号;";
                     if(boxHtml.length>0){
                  	   $('#boxSpan_li').show();
                  	   $("#boxSpan").html(boxHtml);
                     }else{
                  	   $('#boxSpan_li').hide();
                     }
                }
                //会员卡
                var cardInfoTpl = document.getElementById('cardTpl').innerHTML;
                var cardInfoTplHtml = template(cardInfoTpl, {
                    list: cards,
                    fk_user_id: '<%=fk_user_id%>',
                    fk_user_gym: '<%=user.getViewGym()%>',
                    pid : memInfo.pid
                });
                $('#card_info').html(cardInfoTplHtml);
                if (!$.isEmptyObject(cards) ) {
                
                    var select = "";
                    for (var i = 0; i < cards.length; i++) {
                        var cardType = cards[i].card_type;

                        if (cardType != "006") {
                            select += "<option value='" + cards[i].card_id + "'>" + cards[i].card_name + "</option>";
                        }
                    }
                    $("#enterCardSelect").html(select);
                    //签到信息
                    if (checkinfo  && checkinfo.is_backhand == "N") {
                        var handNo = checkinfo.hand_no;
                        $("#checkInDiv").css("display", "none");
                        $("#checkOutDiv").css("display", "block");
                        if (handNo != undefined) {
                            $("#checkOutNo").val("归还 " + handNo + "号 手环");
                        } else {
                            $("#checkOutNo").val("");
                        }
                    } else {
                        $("#checkOutDiv").css("display", "none");
                        $("#checkInDiv").css("display", "block");
                    }
                } else {
                    $("#checkOutDiv").css("display", "none");
                    $("#checkInDiv").css("display", "none");
                }
            } else {
                alert(data.rs);
            }
        }
    });
});

function showBuyCardPage(fk_user_id) {
    top.dialog({
        url: "partial/cardOp/partialBuyCard.jsp?fk_user_id="+fk_user_id,
        title: '购卡',
        width: 980,
        height: 580,
        okValue: "购买",
        ok: function() {
            var iframe = $(window.parent.document).contents().find("[name=" + $(this)[0].id + "]")[0].contentWindow;
            iframe.buyCard(this, window, fk_user_id);
            return false;
        },
        cancelValue: "取消",
        cancel: function() {
            return true;
        }
    }).showModal();
}
//转卡
function transferCard(fk_user_id,fk_card_id,fk_user_gym){
	 $.ajax({
        type: "POST",
        url: "fit-transferCard-fee",
        data: {
        },
        dataType: "json",
        async: false,
        success: function(data) {
            if (data.rs == "Y") {
            	var  fee= data.fee;
				top.dialog({
			        url: "partial/cardOp/transferCard.jsp?fk_user_id="+fk_user_id+"&fk_card_id="
			        		+fk_card_id+"&fk_user_gym="+fk_user_gym+"&fee="+fee,
			        title: "转卡",
			        width: 650,
			        height: 500,
			        okValue: "确定",
			        ok: function() {
			            var iframe = $(window.parent.document).contents().find("[name=" + $(this)[0].id + "]")[0].contentWindow;
			            iframe.tCard(this, window);
			            return false;
			        },
			        cancelValue: "取消",
			        cancel: function() {
			            return true;
			        }
			    }).showModal();
			            	
            } else {
                alert(data.rs);
            }
        }
    });
}
//消次
function reduceTimes(fk_user_id,fk_card_id,fk_user_gym,type){
	top.dialog({
        url: "partial/cardOp/reduceTimes.jsp",
        title: type,
        width: 650,
        height: 400,
        okValue: "确定",
        ok: function() {
            var iframe = $(window.parent.document).contents().find("[name=" + $(this)[0].id + "]")[0].contentWindow;
            iframe.reduceTimes(this, window,fk_user_id,fk_card_id,fk_user_gym,type);
            return false;
        }, 
        cancelValue: "取消",
        cancel: function() {
            return true;
        }
    }).showModal();
}
//请假
function toLeave(fk_user_id,buy_card_id,fk_user_gym,card_id){
	top.dialog({
        url: "partial/cardOp/leave.jsp?fk_user_gym="+fk_user_gym+"&buy_card_id="+buy_card_id+"&fk_user_id="+fk_user_id,
        title: "请假",
        width: 950,
        height: 400,
        okValue: "确定",
        ok: function() {
            var iframe = $(window.parent.document).contents().find("[name=" + $(this)[0].id + "]")[0].contentWindow;
            iframe.doLeave(this, window,fk_user_id,fk_user_gym,card_id);
            return false;
        },
        cancelValue: "取消",
        cancel: function() {
            return true;
        }
    }).showModal();
}
//销假
function salesLeave(fk_user_id,fk_user_gym){
	  $.ajax({
	      type: "POST",
	      url: "fit-cashier-salesLeave",
	      data: {
	          fk_user_id : fk_user_id,
	          fk_user_gym : fk_user_gym
	      },
	      dataType: "json",
	      async: false,
	      success: function(data) {
	          if (data.rs == "Y") {
	              alert("销假成功");
	               window.location.reload();
	          } else {
	              alert(data.rs);
	          }
	      }
	  });
	 
}
//激活卡
function activeCard(fk_user_id,fk_card_id,fk_user_gym){
	 dialog({
	    title: '提示',
	    content: "您确定要激活此卡",
	        		    okValue: '确定',
	        		    ok: function () {
	        		    	  $.ajax({
	        		    	      type: "POST",
	        		    	      url: "fit-cashier-activeCard",
	        		    	      data: {
	        		    	          fk_user_id: fk_user_id,
	        		    	          fk_card_id: fk_card_id,
	        		    	          fk_user_gym: fk_user_gym
	        		    	      },
	        		    	      dataType: "json",
	        		    	      async: false,
	        		    	      success: function(data) {
	        		    	           if (data.rs == "Y") {
	        		    	        	    alert("激活成功");
	                                     window.location.reload();
	        		    	          } else {
	        		    	              alert(data.rs);
	        		    	          }
	        		    	      }
	        		    	  });
	        		    },
	        		    cancelValue: '取消',
	        		    cancel: function () {}
	        		}).showModal();
	
}
//退卡
function backCard(fk_user_id,fk_card_id,fk_user_gym,confm){
  $.ajax({
      type: "POST",
      url: "fit-cashier-backCard",
      data: {
          fk_user_id: fk_user_id,
          fk_card_id: fk_card_id,
          fk_user_gym: fk_user_gym,
          back : "N",
      },
      dataType: "json",
      async: false,
      success: function(data) {
          if (data.rs == "Y") {
        	  dialog({
        		    title: '提示',
        		    content: "您确定要退卡，退还金额：￥<input type='number' value='"+data.backmoney+"' id='backMoney'>",
        		    okValue: '确定',
        		    ok: function () {
        		    	  $.ajax({
        		    	      type: "POST",
        		    	      url: "fit-cashier-backCard",
        		    	      data: {
        		    	          fk_user_id: fk_user_id,
        		    	          fk_card_id: fk_card_id,
        		    	          fk_user_gym: fk_user_gym,
        		    	          cust_name : '<%=cust_name%>',
        		    	          backMoney :$("#backMoney").val(),
        		    	          back : "Y"
        		    	      },
        		    	      dataType: "json",
        		    	      async: false,
        		    	      success: function(data) {
        		    	           if (data.rs == "Y") {
        		    	        	    alert("退卡成功");
                                     window.location.reload();
        		    	          } else {
        		    	              alert(data.rs);
        		    	          }
        		    	      }
        		    	  });
        		    },
        		    cancelValue: '取消',
        		    cancel: function () {}
        		}).showModal();
          } else {
              alert(data.rs);
          }
      }
  });
}
//退押金
function setting(fk_user_id){
  $.ajax({
      type: "POST",
      url: "fit-card_retreat",
      data: {
          fk_user_id: fk_user_id,
          back : "N",
      },
      dataType: "json",
      async: false,
      success: function(data) {
          if (data.rs == "Y") {
        	  top.dialog({
        		    title: '提示',
        		    content: "您确定要退押金，退还金额：￥"+data.card_money,
        		    okValue: '确定',
        		    ok: function () {
        		    	  $.ajax({
        		    	      type: "POST",
        		    	      url: "fit-card_retreat",
        		    	      data: {
        		    	          fk_user_id: fk_user_id,
        		    	          back : "Y"
        		    	      },
        		    	      dataType: "json",
        		    	      async: false,
        		    	      success: function(data) {
        		    	           if (data.rs == "Y") {
        		    	        	    alert("退押金成功");
                                     window.location.reload();
        		    	          } else {
        		    	              alert(data.rs);
        		    	          }
        		    	      }
        		    	  });
        		    },
        		    cancelValue: '取消',
        		    cancel: function () {}
        		}).showModal();
          } else {
              alert(data.rs);
          }
      }
  });
}


//签到小票补打
function printPaper(checkinId){
	var box = $("#boxSpan").text()+"";
	 $.ajax({
         type: "POST",
         url: "fit-userinfo-getCheckInMsg",
         data: {
        	 checkinId: checkinId,
        	 fk_user_gym: '<%=fk_user_gym%>'
         },
         dataType: "json",
         async: false,
         success: function(data) {
         	  var obj = data.obj;
         	if(obj && obj != null && obj != []){
         	var html = template($("#normalPaper").html(), {
         	    gym_name: "<%=GymUtils.getGymName(user.getViewGym())%>",
         	    emp_name: "<%=user.getLoginName()%>",
         	    pay_time: "<%=sdf.format(new Date())%>",
         	    data:obj,
         	    box: box
         	});
         	$("#paper-print-div").html(html);
         	var headElements = '<meta charset="utf-8" />,<meta http-equiv="X-UA-Compatible" content="IE=edge"/>';
         	var options = {
         	    mode: "iframe",
         	    popClose: true,
         	    extraCss: "",
         	    retainAttr: ["class", "style"],
         	    extraHead: headElements
         	};
         	$("#paper-print-div").printArea(options);
            }
         }
     });
}
function checkOut() {
    $.ajax({
        type: "POST",
        url: "fit-userinfo-checkOut",
        data: {
            fk_user_id: '<%=fk_user_id%>',
			},
			dataType : "json",
			async : false,
			success : function(data) {
				if (data.rs == "Y") {
					alert("出场成功");
					parent.location.reload();
				} else {
					alert(data.rs);
				}
			}
		});
	}
	//升级卡
	function updateCard(fk_user_id, fk_card_id, card_type) {
		top.dialog(
						{
							url : "partial/cardOp/updateCard.jsp?card_type="
									+ card_type,
							title : '升级会员卡',
							width : 1100,
							height : 500,
							okValue : "升级",
							ok : function() {
								var iframe = $(window.parent.document)
										.contents().find(
												"[name=" + $(this)[0].id + "]")[0].contentWindow;
								iframe.updateCard(this, window, fk_user_id,
										fk_card_id, card_type);
								return false;
							},
							cancelValue : "取消",
							cancel : function() {
								return true;
							}
						}).showModal();
	}
	//挂失
	function reportedLoss(fk_user_id, fk_user_gym) {
		top.dialog({
			title : '提示',
			content : "确定要挂失",
			okValue : '确定',
			ok : function() {
				$.ajax({
					type : "POST",
					url : "fit-cashier-reportedLoss",
					data : {
						fk_user_id : fk_user_id,
						fk_user_gym : fk_user_gym
					},
					dataType : "json",
					async : false,
					success : function(data) {
						if (data.rs == "Y") {
							alert("挂失成功");
							parent.location.reload();
						} else {
							alert(data.rs);
						}
					}
				});
			},
			cancelValue : '取消',
			cancel : function() {
			}
		}).showModal();

	}
	//补卡
	function reportedget(fk_user_id, fk_user_gym) {
		top.dialog(
						{
							url : "partial/cardOp/repairCard.jsp",
							title : '补卡',
							width : 800,
							height : 200,
							okValue : "确定",
							ok : function() {
								var iframe = $(window.parent.document)
										.contents().find(
												"[name=" + $(this)[0].id + "]")[0].contentWindow;
								iframe.doRepairCard(this, window, fk_user_gym,
										fk_user_id);
								return false;
							},
							cancelValue : "取消",
							cancel : function() {
								return true;
							}
						}).showModal();
	}
	//付定金
	function prePay(fk_user_id, fk_user_gym) {
		top
				.dialog(
						{
							url : "partial/prepaidDeposit.jsp",
							title : '付定金',
							width : 800,
							height : 150,
							okValue : "确定",
							ok : function() {
								var iframe = $(window.parent.document)
										.contents().find(
												"[name=" + $(this)[0].id + "]")[0].contentWindow;
								iframe.payMoney(this, fk_user_gym, fk_user_id);
								return false;
							},
							cancelValue : "取消",
							cancel : function() {
								return true;
							}
						}).showModal();
	}

	function recharge(fk_user_id, fk_user_gym) {
		top.dialog(
						{
							url : "partial/cardOp/recharge.jsp",
							title : '充值',
							width : 800,
							height : 150,
							okValue : "确定",
							ok : function() {
								var iframe = $(window.parent.document)
										.contents().find(
												"[name=" + $(this)[0].id + "]")[0].contentWindow;
								iframe.payMoney(this, window, fk_user_gym,
										fk_user_id);
								return false;
							},
							cancelValue : "取消",
							cancel : function() {
								return true;
							}
						}).showModal();
	}

	//图片上传成功后需要拼接URL
	var baseUrl = "${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}";
</script>
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
			<p class="user-name">
				<button class="btn btn-custom" id="box" style="padding: 0 5px;" onclick="salesLeave('<%=fk_user_id%>','<%=fk_user_gym%>')">销假</button>
				<!-- <button class="btn btn-custom" id="box" style="padding: 0 5px;">租柜</button>
				<button class="btn btn-custom" id="box" style="padding: 0 5px;">退柜</button> -->
				<!-- 				<button class="btn btn-custom" id="box" style="padding: 0 5px;">租柜押金</button> -->
				<button class="btn btn-custom" id="box" style="padding: 0 5px;" onclick="setting('<%=fk_user_id%>','<%=fk_user_gym%>')">退押金</button>
				<!-- 				<button class="btn btn-custom" id="box" style="padding: 0 5px;">退卡</button> -->
				<button class="btn btn-custom" id="box" style="padding: 0 5px;" onclick="reportedLoss('<%=fk_user_id%>','<%=fk_user_gym%>')">挂失</button>
				<button class="btn btn-custom" id="box" style="padding: 0 5px;" onclick="reportedget('<%=fk_user_id%>','<%=fk_user_gym%>')">补卡</button>
				<button class="btn btn-custom" id="box" style="padding: 0 5px;" onclick="prePay('<%=fk_user_id%>','<%=fk_user_gym%>')">付定金</button>
				<button class="btn btn-custom" id="box" style="padding: 0 5px;" onclick="registerFinger('<%=fk_user_id%>','<%=fk_user_gym%>')">指纹录入</button>
				<button class="btn btn-custom" id="box" style="padding: 0 5px;" onclick="validateFinger('<%=fk_user_id%>')">指纹识别</button>
				<!-- 				<button class="btn btn-custom" id="box" style="padding: 0 5px;">详细信息</button> -->
			</p>
			<div>
				<ul>
					<li>卡&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;号：<span id="mem_no"></span></li>
					<li>状态：<span id="state"></span></li>
					<li class="line-one">所属会籍：<span id="sales_name"></span></li>
					<li id="boxSpan_li" style="display: none;">已租箱柜：<span id="boxSpan" style="color: red;"></span></li>
				</ul>
			</div>
			<div>
				<ul>
					<li>生&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日：<span id="birthday"></span></li>
					<li>储值卡余额：<span id="remain_amt" style="color: red;"></span><span style="color: red;">元</span></li>
					<li class="line-one">所属教练：<span id="pt_name"></span></li>
					<!-- 					<li>今日已入场 15:30</li> -->
				</ul>
			</div>
			<!-- 			<p class="remark">备注：</p> -->
		</div>
		<div class="row" style="float: none;" id="checkInDiv">
			<select id="enterCardSelect">
			</select> <input type="text" placeholder="输入手环号,选填" id="checkInNo">
			<button class="btn btn-green btn-small" name="ringSubmit" onclick="checkIn('','<%=fk_user_id%>','<%=fk_user_gym%>')">确认入场</button>
		</div>
		<div class="row" style="float: left; display: none;" id="checkOutDiv">
			<input type="text" id="checkOutNo" readonly="readonly" style="border: 0px solid #fff; color: red; width: 200px;">
			<button class="btn btn-green btn-small" name="ringSubmit" onclick="checkOut()">离场</button>
		</div>
	</div>


	<div class="user-info" style="clear: both;">
		<ul class="tabs-inner tabs-inner-checkin">
			<li class="active"><a data-hash="#card_info">会员卡</a></li>
			<li onclick="old_card_list('<%=fk_user_id%>')"><a data-hash="#old_card_info">失效会员卡</a></li>
			<li onclick="consume_list('<%=fk_user_id%>')"><a data-hash="#pay_info">消费记录</a></li>
			<li onclick="leaveinfo_list('<%=fk_user_id%>')"><a data-hash="#leave_info">请假记录</a></li>
			<li onclick="checkin_list('<%=fk_user_id%>')"><a data-hash="#inout_info">出/入场</a></li>
		</ul>
		<div class="tab-content custom-tab-content" style="clear: both;">
			<div id="card_info" class="active"></div>
			<div id="old_card_info"></div>
			<div id="pay_info">
				<table class="custom-table">
					<thead>
						<tr>
							<th>消费项目</th>
							<th>消费金额</th>
							<th>消费时间</th>
							<th>操作人</th>
						</tr>
					</thead>
					<tbody id="consumeList">
					</tbody>
				</table>
			</div>
			<div id="old_card_info"></div>
			<div id="pay_info"></div>
			<div id="leave_info"></div>
			<div id="inout_info"></div>
		</div>
	</div>
	<jsp:include page="/partial/tpl/template.jsp"></jsp:include>
	<jsp:include page="/partial/piaoTpl.jsp"></jsp:include>
</body>
</html>