function showPay(formData, callback) {
	var title = formData.title;
	if (title == null || title.length <= 0) {
		title = "xx支付页面";
	}
	if (formData.userType == 'emp') {
		// 表示员工消费
	}
	var changePrice = "Y";
	if ("com.mingsokj.fitapp.flow.impl.商品销售Flow" == formData.flow) {
		changePrice = "N";
		// 商品销售不能异价
	}
	top.dialog({
						url : "pay.jsp?userType=" + formData.userType
								+ "&userId=" + formData.userId + "&caPrice="
								+ formData.caPrice + "&changePrice="
								+ changePrice + "&type=" + formData.flow,
						title : title,
						width : 800,
						skin : "pay-dialog",
						okValue : "确定",
						ok : function() {

							var iframe = $(window.parent.document)
									.contents()
									.find(
											"[name="
													+ top.dialog.getCurrent().id
													+ "]")[0].contentWindow;
							iframe.saveSubmit(formData, this, document,
									callback);
							return false;
						},
						cancelValue : "取消",
						cancel : function() {
							return true;
						}
					}).showModal();
}

// 打印小票
function printXiaoPiao(xiaoPType, formData, payData, obj) {
	// 单次入场券
	if ("com.mingsokj.fitapp.flow.impl.购卡Flow" != xiaoPType) {
		if ("com.mingsokj.fitapp.flow.impl.散客购票Flow" == xiaoPType) {
			if (obj) {
				var 	html ="";
				for (var i = 0; i < obj.length; i++) {
					var xx = obj[i];
					html += template($("#oncePaper").html(), {
						gym_name : formData.gymName,
						emp_name : formData.emp_name,
						pay_time : formData.payTime,
						price : xx.real_amt,
						fitId : xx.buy_id,
						deadline : xx.deadline,
						checkin_no : xx.checkin_no
					});
					html += "<br/>";
				}
				$("#once-paper-print-div").html(html);
				divPrint('once-paper-print-div');
			}
		} else {
			if (obj && obj != null && obj != []) {
				var html = template($("#normalPaper").html(), {
					gym_name : formData.gymName,
					emp_name : formData.emp_name,
					pay_time : formData.payTime,
					data : obj
				});
				$("#paper-print-div").html(html);
				divPrint("paper-print-div");
			}
		}
	}
}

function divPrint(printElementId) {
	var headElements = '<meta charset="utf-8" />,<meta http-equiv="X-UA-Compatible" content="IE=edge"/>';
	var options = {
		mode : "iframe",
		popClose : true,
		extraCss : "",
		retainAttr : [ "class", "style" ],
		extraHead : headElements
	};
	$("#" + printElementId).printArea(options);
}

// 打印合同
function printContract(contractType, buy_id, formData, payData) {
	var mem_gym = formData.gym;// 会员所在会所"&formData="+JSON.stringify(formData)+"&payData="+JSON.stringify(payData)
	var give_card = formData.card_cash_int;// 是否发卡

	window.open("pages/f_set/f_set_contract_print2.jsp?type=" + contractType
			+ "&buy_id=" + buy_id + "&mem_gym=" + mem_gym + "&give_card="
			+ give_card);
}
