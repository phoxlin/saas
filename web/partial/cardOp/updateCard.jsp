<%@page import="com.mingsokj.fitapp.utils.GymUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%
	FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
	if (user == null) {
		request.getRequestDispatcher("/").forward(request, response);
	}
	String gym = user.getViewGym();
	String cust_name = user.getCust_name();
	String card_type = request.getParameter("card_type");
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
<script type="text/javascript">
<!--
	template.config({
		sTag : '<#', eTag: '#>'
	});
//-->
$(function() {
    getCardByType('<%=card_type%>');
});
	function getCardByType(type) {
		if (type == "002") {
			$("#amtDiv").css("display", "block")
		} else {
			$("#amtDiv").css("display", "none")
		}
		if (type == "003" || type == "006") {
			$("#timesDiv").css("display", "block")
		} else {
			$("#timesDiv").css("display", "none")
		}
		Cardtype = type;
		$
				.ajax({
					type : "POST",
					url : "fit-ws-bg-Mem-getCard",
					data : {
						card_type : type
					},
					dataType : "json",
					async : false,
					success : function(data) {
						if (data.rs == "Y") {
							var partialBuyCard_CardTpl = document
									.getElementById('partialBuyCard_CardTpl').innerHTML;
							var partialBuyCard_CardTplHtml = template(
									partialBuyCard_CardTpl, {
										list : data.data
									});
							$('#partialBuyCard_CardTplDiv').html(
									partialBuyCard_CardTplHtml);
						} else {
							error(data.rs);
						}
					}
				});
	}
	function getsendCardMsg() {
		$.ajax({
			type : "POST",
			url : "fit-ws-bg-Mem-getCard",
			data : {},
			dataType : "json",
			async : false,
			success : function(data) {
				if (data.rs == "Y") {
					var card = data.data;
					var option = "<option value='0'>--请选择--</option>";
					for (var i = 0; i < card.length; i++) {
						option += "<option value='"+card[i].id+"'>"
								+ card[i].card_name + "</option>";
					}
					$("#sendCard").html(option);
				} else {
					error(data.rs);
				}
			}
		});
	}
	function showCardDetial(id) {
		$.ajax({
			type : "POST",
			url : "fit-ws-bg-Mem-getCardDetial",
			data : {
				card_id : id
			},
			dataType : "json",
			async : false,
			success : function(data) {
				if (data.rs == "Y") {
					var price = data.data.fee;
					var days = data.data.days;
					var times = data.data.times;
					$("#cardName").val(data.data.card_name);
					$("#price").val(price);
					if (days == undefined) {
						days = "永久有效";
					}
					$("#day").val(days);
					$("#times").val(times);
					$("#amt").val(data.data.amt);
				} else {
					error(data.rs);
				}

			}
		});
	}
	function updateCard(win, pwin, fk_user_id, fk_user_card_id, card_type) {
		var updateCard = "";
		$(':radio[name=cards]').each(function() {
			if ($(this).prop('checked')) {
				updateCard = $(this).val();
			}
		});
		if (updateCard.length <= 0) {
			alert("请选择一张卡");
			return;
		}
		$.ajax({
			type : "POST",
			url : "fit-ws-bg-Mem-updateCard",
			data : {
				fk_user_id : fk_user_id,
				fk_user_card_id : fk_user_card_id,
				card_type : card_type,
				updateCard : updateCard
			},
			dataType : "json",
			async : false,
			success : function(data) {
				if (data.rs == "Y") {
					var fee = data.fee;
					top.dialog({
						title : '提示',
						content : "您确定要升级此卡，需补交金额：￥" + fee,
						okValue : '确定',
						ok : function() {
									
							var data = {
							        title: "升级",
							        flow: "com.mingsokj.fitapp.flow.impl.升级Flow",
							        userType: 'mem',
							        //消费对象，会员【mem】，员工【emp】，匿名消费【anonymous】
							        userId: fk_user_id,
							        //消费对象id，如果是匿名的就为-1
							        //////////////////////上面参数为必填参数/////////////////////////////////////////////
							        fk_user_id : fk_user_id,
									fk_user_card_id : fk_user_card_id,
									card_type : card_type,
									updateCard : updateCard,
									emp_id : '<%=user.getId()%>',
							        gymName : '<%=GymUtils.getGymName(user.getViewGym())%>',
									emp_name : '<%=user.getLoginName()%>',
									gym : "<%=gym%>",
									cust_name : "<%=cust_name%>",
									real_amt: fee,
							        caPrice : fee,
							    };

							    showPay(data,
							    function() {
									win.close();
									setTimeout(function (){
										pwin.location.reload();
									}, 1000 );
							    });
						},
						cancelValue : '取消',
						cancel : function() {
						}
					}).showModal();

				} else {
					error(data.rs);
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
	        height: 700,
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
	function Unbundled(type) {
	    if ("sales" == type) {
	        $("#salesName").html("");
	        $("#sales").val("");
	    }
	    if ("coach" == type) {
	        $("#coachName").html("");
	        $("#coach").val("");
	    }
	}
</script>
</head>
<script type="text/html" id="partialBuyCard_CardTpl">
                  <# if(list){
                      for(var i = 0;i<list.length;i++){
                  #>
                          <div class="card-panel" onclick="showCardDetial('<#=list[i].id#>')">
                              <input type="radio"  name="cards" value="<#=list[i].id#>" id="<#=list[i].id#>"> 
                              <label for="<#=list[i].id#>">
                              	<span></span>
                              	<b><#=list[i].card_name#></b>
                              </label>
                           </div>
                  <# }}#>
               </script>
<body style="overflow-y: hidden;">
	<!-- 卡信息 -->
	<div class="buy-card-info">
		<div class="container">
			<div id="partialBuyCard_CardTplDiv" style="display: inline-block;"></div>
			<div class="row" style="margin-top: 15px;">
				<div class="col-xs-6">
					<div class="input-panel">
						<label>卡种名称</label> <input type="text" id="cardName" readonly="readonly" />
					</div>
				</div>
				<div class="col-xs-6">
					<div class="input-panel">
						<label>金&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;额</label> <input type="text" id="price" />
					</div>
				</div>
				<div class="col-xs-6">
					<div class="input-panel">
						<label>天&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;数</label> <input type="text" id="day" readonly="readonly" />
					</div>
				</div>
				<div class="col-xs-6" id="timesDiv" style="display: none;">
					<div class="input-panel">
						<label>次&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;数</label> <input type="text" id="times" readonly="readonly" />
					</div>
				</div>
				<div class="col-xs-6" id="amtDiv" style="display: none;">
					<div class="input-panel">
						<label>储值金额</label> <input type="text" id="amt" readonly="readonly" />
					</div>
				</div>
				<div class="col-xs-6">
					<div class="input-panel">
						<label>所属会籍</label>
						<div class="bind">
							<div class="col-xs-10" onclick="getemps('sales')">
								<span style="vertical-align: super;" id="salesName">点击选择会籍</span> <input type="hidden" id="sales"> <span class="sub-title"></span>
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
								<span style="vertical-align: super;" id="coachName">点击选择教练</span> <input type="hidden" id="coach"> <span class="sub-title"></span>
							</div>
							<div class="col-xs-2">
								<button onclick="Unbundled('coach')">解绑</button>
							</div>
						</div>
					</div>
				</div>
				<div class="col-xs-12">
					<div class="input-panel">
						<textarea placeholder="其他自定义信息" id="remark"></textarea>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>