function bindWx(confirm2) {
	
	var phone = $('#wx-phone').val();
	var vcode = $('#wx-verification-code').val();
	var isEmp = $('#isEmpCheckbox').is(':checked');

	if (phone == null || phone.length <= 0) {
		$.toast('请输入手机号码')
		$('#wx-phone').focus();
		return;
	}

	if(vcode==null||vcode.length<=0){
		$.toast('请输入验证码');
		return;
	}
	
	var code = $('#wx-verification-code2').val();
	if (vcode != code) {
		$.toast('验证码错误')
		$('#wx-verification-code').focus();
		return;
	}
	$.showIndicator();
	$.ajax({
		type : 'POST',
		url : 'f-ws-app-bindWx',
		data : {
			cust_name : cust_name,
			gym : gym,
			phone : phone,
			wxOpenId : wxOpenId,
			confirm : confirm2
		},
		dataType : 'json',
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				if (data.flag == 'old-phone') {
					$.confirm("手机号码使用过，重新绑定?", function() {
						bindWx("Y");
					});
				} else if (data.flag == 'bind-new-phone') {
					$.confirm("手机号码其他微信上绑定了，是否确认重新绑定?", function() {
						bindWx("Y");
					});
				} else {
					location.reload();
				}
			} else {
				$.toast(data.rs);
			}
		},
		error : function(xhr, type) {
			$.hideIndicator();
			$.toast("您的网速不给力啊，再来一次吧");
		}
	});
}

function showBuyCard() {
	if (logined != 'Y') {
		openPopup(".wxloginPopup");
		return;
	}
	$.showIndicator();
	$.ajax({
		type : 'POST',
		url : 'yp-ws-app-getCards',
		data : {
			cust_name : cust_name,
			gym : gym
		},
		dataType : 'json',
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				var tpl = document.getElementById("buyCardsTpl").innerHTML;
				content = template(tpl, {
					data : data.cards,
					logo_url : data.logo_url
				});
				$("#buyCardsDiv").html(content);
				openPopup(".popup-buyCards");

			} else {
				$.toast(data.rs);

			}
		},
		error : function(xhr, type) {
			$.hideIndicator();
			$.toast("您的网速不给力啊，再来一次吧");
		}
	});
}
// 查看我的会员卡
function showMyCard() {

	$.showIndicator();
	$.ajax({
		type : 'POST',
		url : 'yp-ws-app-getMyCards',
		data : {
			cust_name : cust_name,
			gym : gym,
			id : id
		},
		dataType : 'json',
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				var tpl = document.getElementById("buyCardsTpl2").innerHTML;
				content = template(tpl, {
					data : data.cards,
					logo_url : data.logo_url
				});
				$("#buyCardsDiv2").html(content);
				openPopup(".popup-myCards");
			} else {
				$.toast(data.rs);

			}
		},
		error : function(xhr, type) {
			$.hideIndicator();
			$.toast("您的网速不给力啊，再来一次吧");
		}
	})
}
// 查看我的会员卡详情
function getMYCardMsg(mem_id) {
	openPopup(".popup-myCardsDetail");
	$.showIndicator();
	$.ajax({
		type : 'POST',
		url : 'yp-ws-app-getMyCardsMsg',
		data : {
			cust_name : cust_name,
			gym : gym,
			id : mem_id,
			mem_id : id
		},
		dataType : 'json',
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				var tpl = document.getElementById("myCardsTpl").innerHTML;
				content = template(tpl, {
					data : data.cards,
					logo_url : data.logo_url,
					str : data.str
				});
				$("#myCardsDetailDiv").html(content);

			} else {
				$.toast(data.rs);

			}
		},
		error : function(xhr, type) {
			$.hideIndicator();
			$.toast("您的网速不给力啊，再来一次吧");
		}
	})
}
// 获取我的单张会员卡信息
function getCardMsg(card_id, fee) {
	$.showIndicator();
	$.ajax({
		type : 'POST',
		url : 'yp-ws-app-getCardsDetial',
		data : {
			card_id : card_id,
			gym : gym,
			cust_name : cust_name,
			id : id
		},
		dataType : 'json',
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				var tpl = document.getElementById("cardDetialTpl").innerHTML;
				var content = template(tpl, {
					list : data.data,
					mem : data.list,
					logo_url : "public/" + cust_name + "/images/logo.png"
				});
				//如果为空可以修改
				var mem_name = data.list[0].mem_name;
				var sex = data.list[0].sex;
				var birthday = data.list[0].birthday;
				var id_card = data.list[0].idCard;
				$("#cardDetialDiv").html(content);
				if(mem_name == undefined || mem_name.length<=0){
					$("#new_edit_mem_name").removeAttr("readonly");
				}
				if(birthday == undefined || birthday.length<=0){
					$("#new_birthday").removeAttr("readonly");
				}
				if(id_card == undefined || id_card.length<=0){
					$("#new_edit_id_card").removeAttr("readonly");
				}
				if(sex == undefined || sex.length<=0){
					$("#new_edit_mem_sex").removeAttr("disabled");
				}
				openPopup(".popup-cardDetial");
				$("#" + id + "_Checkbox").css("display", "inline-block");
				$("#" + id).attr("checked", "checked");
				if(data.data.app_amt){
					$("#card_price").html(data.data.app_amt);
				} else {
					$("#card_price").html(data.data.fee);
				}
				$("#card_id").val(card_id);
				if (data.data) {
					$(".popup-cardDetial .title").text(data.data.card_name);
				} else {
					$(".popup-cardDetial .title").text("会员卡详情");
				}
				//数量变动
				if("006" == data.data.card_type){
					//var onePrice = Number(data.data.app_fee ?data.data.app_fee : data.data.fee) / Number(data.data.times);
					$("#buyPrivateNumber").on("input propertychange",function(){
						var onePrice = $("#sign_price").text();
						var times = $(this).val();
						if(times < 1){
							$(this).val(1);
							$("#card_price").text(Number(onePrice));
							
						}else{
							$("#card_price").text(Math.floor(Number(onePrice)*Number(times)));
						}
					
					});
				}
				
			} else {
				$.toast(data.rs);

			}
		},
		error : function(xhr, type) {
			$.hideIndicator();
			$.toast("您的网速不给力啊，再来一次吧");
		}
	})
}

function buyCards() {
	var user_id = id
	var edit_mem_name = $("#new_edit_mem_name").val();
	var edit_id_card = $("#new_edit_id_card").val();
	var birthday = $("#new_birthday").val();
	var sex = $("#new_edit_mem_sex").val();
	
	var priTimes = $("#buyPrivateNumber").val() || "";
	
	if(sex == undefined || sex.length<=0){
		$.toast("请选择性别");
		return;
	}
	if(edit_mem_name == undefined || edit_mem_name.length<=0){
		$.toast("请填写姓名");
		return;
	}
	
	if(birthday == undefined || birthday.length<=0){
		$.toast("请填写生日");
		return;
	}
	if(edit_id_card == undefined || edit_id_card.length<=0){
		$.toast("请填写身份证号");
		return;
	}
	var card_id = $("#card_id").val();
	if (!card_id) {
		$.toast("请选择一张会员卡");
		return;
	}
	var carsProtocol = $("#card_Protocol").prop("checked");
	if (!carsProtocol) {
		$.toast("请阅读并同意会员卡购买协议");
		return;
	}
	var total_fee = $("#card_price").text();
	if (total_fee != 0) {
		// 获取订单号
		var timestamp = (new Date()).valueOf();
		var out_trade_no = cust_name + "-" + timestamp;
		// 商品描述
		var subject = "";
		// 费用
		var wx_open_id = wxOpenId;
		var appIdParamName = "wx." + cust_name + ".appId";
		var appsecretParamName = "wx." + cust_name + ".appSecret";
		var keyParamName = "wx." + cust_name + ".key";
		var MchIdParamName = "wx." + cust_name + ".MchId";
		$.showIndicator();
		$.ajax({
			type : 'POST',
			url : 'jh_wx_pay',
			data : {
				out_trade_no : out_trade_no,
				subject : subject,
				total_fee : total_fee,
				wx_open_id : wx_open_id,
				appIdParamName : appIdParamName,
				appsecretParamName : appsecretParamName,
				keyParamName : keyParamName,
				MchIdParamName : MchIdParamName
			},
			dataType : 'json',
			success : function(data) {
				$.hideIndicator();
				if (data.rs == "Y") {
					var d = data.data;
					// 调起支付
					paycallpay(d.appid, d.timeStamp, d.nonceStr, d.packages,
							d.sign, out_trade_no, total_fee, card_id, gym,
							cust_name, user_id,edit_mem_name,edit_id_card,birthday,sex,priTimes);
				} else {
					$.toast("支付出错");
				}
			},
			error : function(xhr, type) {
				$.hideIndicator();
				$.toast("您的网速不给力啊，再来一次吧");
			}
		});

	} else {

		buyCardsToBuy(card_id, gym, cust_name, user_id, "",edit_mem_name,edit_id_card,birthday,sex,priTimes);
	}
}

function paycallpay(appId, timeStamp, nonceStr, packageValue, paySign,
		out_trade_no, total_fee, card_id, gym, cust_name, user_id,edit_mem_name,edit_id_card,birthday,sex,priTimes) {
	WeixinJSBridge.invoke('getBrandWCPayRequest', {
		"appId" : appId,
		"timeStamp" : timeStamp,
		"nonceStr" : nonceStr,
		"package" : packageValue,
		"signType" : "MD5",
		"paySign" : paySign
	}, function(res) {
		WeixinJSBridge.log(res.err_msg);
		if (res.err_msg == "get_brand_wcpay_request:ok") {
			// 使用以上方式判断前端返回,微信团队郑重提示：res.err_msg将在用户支付成功后返回 ok，但并不保证它绝对可靠。
			buyCardsToBuy(card_id, gym, cust_name, user_id, out_trade_no,edit_mem_name,edit_id_card,birthday,sex,priTimes);
		} else if (res.err_msg == "get_brand_wcpay_request:cancel") {
			$.toast("您取消了支付");
		} else {
			$.toast("支付失败，请稍后在试!");
		}
	})
}

function buyCardsToBuy(card_id, gym, cust_name, user_id, out_trade_no,edit_mem_name,edit_id_card,birthday,sex,priTimes) {
	$.showIndicator();
	$.ajax({
		type : 'POST',
		url : 'yp-ws-app-buyCard',
		data : {
			id : card_id,
			gym : gym,
			cust_name : cust_name,
			fk_user_id : user_id,
			out_trade_no : out_trade_no,
			edit_mem_name : edit_mem_name,
			edit_id_card : edit_id_card,
			birthday : birthday,
			sex : sex,
			wxOpenId : wxOpenId,
			priTimes,priTimes//购买私教的节数
		},
		dataType : 'json',
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				$.alert("购买成功");
				closePopup('.popup-cardDetial');
			} else {
				$.toast(data.rs);
			}
		},
		error : function(xhr, type) {
			$.hideIndicator();
			$.toast("您的网速不给力啊，再来一次吧");
		}
	});
}

// 显示体验课
function showEcprienceLesson() {
	$.showIndicator();
	$.ajax({
		type : 'POST',
		url : 'fit-app-action-showExperienceLesson',
		data : {
			gym : gym,
			cust_name : cust_name
		},
		dataType : 'json',
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				var tpl = document.getElementById("showLessonTpl").innerHTML;
				content = template(tpl, {
					data : data.list,
					logo_url : ""
				});
				$("#showLessonDiv").html(content);
				openPopup(".popup-experienceLesson");
			} else {
				$.toast(data.rs);

			}
		},
		error : function(xhr, type) {
			$.hideIndicator();
			$.toast("您的网速不给力啊，再来一次吧");
		}
	})
}
// 私人教练
function showEmpList() {
	$.showIndicator();
	$
			.ajax({
				type : 'POST',
				url : 'fit-ws-app-getEmpList',
				dataType : 'json',
				data : {
					cust_name : cust_name,
					gym : gym
				},
				success : function(data) {
					$.hideIndicator();
					if (data.rs == "Y") {
						var empListTpl = document.getElementById("empListTpl").innerHTML;
						content = template(empListTpl, {
							data : data.list,
						});
						$("#empListDiv").html(content);
						openPopup(".popup-empList");
					} else {
						$.toast(data.rs);

					}
				},
				error : function(xhr, type) {
					$.hideIndicator();
					$.toast("您的网速不给力啊，再来一次吧");
				}
			})
}
// 显示教练详情
function shwoEmpDetial(fk_emp_id) {
	$.showIndicator();
	$
			.ajax({
				type : 'POST',
				url : 'fit-ws-app-getEmpDetial',
				dataType : 'json',
				data : {
					cust_name : cust_name,
					gym : gym,
					fk_emp_id : fk_emp_id
				},
				success : function(data) {
					$.hideIndicator();
					if (data.rs == "Y") {
						var EmpDetialTpl = document
								.getElementById("EmpDetialTpl").innerHTML;
						content = template(EmpDetialTpl, {
							data : data.list,
						});
						content = content.replace(/&amp;/g, "&");
						content = content.replace(/&lt;/g, "<");
						content = content.replace(/&gt;/g, ">");
						content = content.replace(/&nbsp;/g, " ");
						content = content.replace(/&#39;/g, "\'");
						content = content.replace(/&quot;/g, "\"");
						$("#EmpDetialtDiv").html(content);
						openPopup(".popup-empDetial");
					} else {
						$.toast(data.rs);

					}
				},
				error : function(xhr, type) {
					$.hideIndicator();
					$.toast("您的网速不给力啊，再来一次吧");
				}
			})

}
// 显示
function getLessonMsg(id) {
	$.showIndicator();
	$.ajax({
		type : 'POST',
		url : 'fit-app-action-showLessonDetail',
		data : {
			id : id
		},
		dataType : 'json',
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				var tpl = document.getElementById("getLessonTpl").innerHTML;
				content = template(tpl, {
					data : data.list,
					logo_url : ""
				});
				content = content.replace(/&amp;/g, "&");
				content = content.replace(/&lt;/g, "<");
				content = content.replace(/&gt;/g, ">");
				content = content.replace(/&nbsp;/g, " ");
				content = content.replace(/&#39;/g, "\'");
				content = content.replace(/&quot;/g, "\"");
				$("#getLessonDiv").html(content);
				$("#title").html(data.list[0].plan_name);
				openPopup(".popup-showLessonDetail");

			} else {
				$.toast(data.rs);

			}
		},
		error : function(xhr, type) {
			$.hideIndicator();
			$.toast("您的网速不给力啊，再来一次吧");
		}
	})

}
// 添加意见
function saveFeedback() {
	var content = $("#content").val();
	var mem_msg = $("#mem_msg").val();
	if (content == "") {
		$.alert("请填写内容");
		return;
	}
	$.showIndicator();
	$.ajax({
		type : "POST",
		url : "fit-app-action-saveQuestion",
		data : {
			content : content,
			mem_msg : mem_msg,
			gym : gym,
			mem_id:id,
			cust_name:cust_name
		},
		dataType : "json",
		async : false,
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				$.alert("感谢您的宝贵意见，建议已记录，我们会及时改进");
				 $("#content").val("");
			     $("#mem_msg").val("");
				closePopup(".popup-feedback");
			} else {
				$.hideIndicator();
				$.toast(data.rs);
			}
		},
		error : function(xhr, type) {
			$.hideIndicator();
			$.toast("您的网速不给力啊，再来一次吧");
		}
	});

}

// 显示健身圈
function showInteract(num, obj) {
	if (logined != 'Y') {
		openPopup(".wxloginPopup");
		return;
	}

	$.showIndicator();
	$.ajax({
		type : "POST",
		url : "fit-app-action-interactList",
		data : {
			cust_name : cust_name,
			gym : gym,
			user_id : id,
			num : num
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				var tpl = document.getElementById("interactListTpl").innerHTML;
				var content = template(tpl, {
					list : data.list,
					flag : data.flag,
					next : data.next
				});
				if(obj){
					$(obj).before(content);
					if("Y" == data.flag){
						$(obj).text("已经没有了");
						$(obj).unbind("click");
						$(obj).removeAttr("onclick");
					} else if("N" == data.flag){
						$(obj).removeAttr("onclick");
						$(obj).unbind("click");
						$(obj).bind("click", function(){showInteract(data.next, obj)});
					}
				} else {
					$("#interactContent").html(content);
				}
				if ($(".popup-addInteract").hasClass("modal-in")) {
					closePopup(".popup-addInteract");
				}
			} else {
				$.toast(data.rs);
			}
		},
		error : function(xhr, type) {
			$.hideIndicator();
			$.toast("您的网速不给力啊，再来一次吧");
		}
	});
}
/**
 * 打卡查询
 * 
 * @returns
 */
function querySignIn() {
	$.showIndicator();
	$.ajax({
		type : "POST",
		url : "fit-app-action-sign-query",
		data : {
			cust_name : cust_name,
			gym : gym,
			user_id : id
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				$("#sign_in_count").text(data.sign_count || 0);
				if (data.sign_in == "Y") {
					$("#sign_in_flag").text("今日已打");
					has_sign = true;
				} else {
					$("#sign_in_flag").text("未打卡");
				}
				/*$("#sign_in_flag").parent().click(function() {
					sign_in_write_diary();
				});*/
			} else {
				$.toast(data.rs);
			}
		},
		error : function(xhr, type) {
			$.hideIndicator();
			$.toast("您的网速不给力啊，再来一次吧");
		}
	});
}
var has_sign = false;
// 记录打卡内容
function sign_in_write_diary() {
	if (logined != 'Y') {
		openPopup(".wxloginPopup");
		return;
	}
	if (!has_sign) {
		// 未打卡
		// sign_in();
		// 写日记
		$("#sign_remark").val("");
		openPopup(".popup-sign-in-write-remark");
	} else {
		openJpur();
		// openPopup(".popup-showJour");
	}
}

// 打卡
function sign_in() {
	$.showIndicator();
	$.ajax({
		type : "POST",
		url : "fit-app-action-sign-in",
		data : {
			cust_name : cust_name,
			gym : gym,
			user_id : id
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				// $("#sign_in_flag").parent().unbind("click")
				$("#sign_in_flag").text("今日已打");
				$("#sign_in_count")
						.text(Number($("#sign_in_count").text()) + 1);
				has_sign = true;
				closePopup(".popup-sign-in-write-remark");
			} else {
				$.toast(data.rs);
			}
		},
		error : function(xhr, type) {
			$.hideIndicator();
			$.toast("您的网速不给力啊，再来一次吧");
		}
	});
}
function openJpur() {
	if (logined != 'Y') {
		openPopup(".wxloginPopup");
		return;
	}
	openPopup(".popup-showJour");
	var day = new Date().Format("yyyy-MM-dd");
	showJour(5);
}
// 显示健身日记
function showJour(cur) {
	$.showIndicator();
	$.ajax({
		type : "POST",
		url : "fit-ws-app-showJour",
		data : {
			cust_name : cust_name,
			gym : gym,
			id : id,
			cur : cur
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				var tpl = document.getElementById("showJourTpl").innerHTML;
				var html = template(tpl, {
					list : data.list,
					state : data.state,
					cur : Number(cur),
					dates : data.dates

				});
				$("#jourDiv").html(html);
				if(data.list && data.list.length >0){
					$("#jourDiv").addClass("jour-list");
				}else{
					$("#jourDiv").removeClass("jour-list");
				}
			} else {
				$.toast(data.rs);
			}
		},
		error : function(xhr, type) {
			$.hideIndicator();
			$.toast("您的网速不给力啊，再来一次吧");
		}
	});

}
function showEditMsg(cust_name) {
	if (logined != 'Y') {
		openPopup(".wxloginPopup");
		return;
	}
	$("#imagesView").html("");
	$.showIndicator();
	$
			.ajax({
				type : "POST",
				url : "fit-ws-app-isEmp",
				data : {
					cust_name : cust_name,
					gym : gym,
					id : id,
					openId : wxOpenId
				},

				dataType : "json",
				success : function(data) {
					$.hideIndicator();
					if (data.rs == "Y") {
						if (data.isEmp == "Y") {
							// 进入修改员工信息页面
							var msgTpl = document.getElementById("msgTpl").innerHTML;
							var html = template(msgTpl, {
								list : data.list,
								openId : wxOpenId,
								isUpdate : data.isUpdate

							});
							$("#msgDiv").html(html);
							

						} else if (data.isEmp == "N") {
							// 进入修改会员信息页面
							var msgTpl = document.getElementById("memMsgTpl").innerHTML;
							var html = template(msgTpl, {
								list : data.list,
								openId : wxOpenId,
								isUpdate : data.isUpdate

							});
							$("#msgDiv").html(html);
						}
						//如果为空可以修改
						var mem_name = data.list[0].mem_name;
						var sex = data.list[0].sex;
						var birthday = data.list[0].birthday;
						var id_card = data.list[0].id_card;
						$("#cardDetialDiv").html(content);
						if(mem_name == undefined || mem_name.length<=0){
							$("#edit_mem_name").removeAttr("readonly");
						}
						if(birthday == undefined || birthday.length<=0){
							$("#birthday").removeAttr("readonly");
						}
						if(id_card == undefined || id_card.length<=0){
							$("#edit_id_card").removeAttr("readonly");
						}
						if(sex == undefined || sex.length<=0){
							$("#edit_mem_sex").removeAttr("disabled");
						}
						openPopup(".popup-editEmpMsg");
					} else {
						$.toast(data.rs);
					}
				},
				error : function(xhr, type) {
					$.hideIndicator();
					$.toast("您的网速不给力啊，再来一次吧");
				}
			});
}
// 确认修改信息
function isEditMsg(type) {
	$.confirm("确认修改?", function() {
		if (type == "mem") {
			editMemMsg(wxOpenId);

		} else {

			editMsg(wxOpenId);
		}
	});

}

// 修改信息
function editMsg() {
	var emp_name = $("#emp_name").val();
	var emp_labels = $("#emp_labels").val();
	var emp_content = $("#emp_content").val();
	var edit_mem_sex = $("#edit_mem_sex").val();
	var birthday = $("#birthday").val();
	var edit_mem_name = $("#edit_mem_name").val();
	var edit_id_card = $("#edit_id_card").val();
	if (edit_mem_sex == undefined || edit_mem_sex == "") {
		$.alert("请选择性别");
		return;
	}
	if (emp_name == undefined || emp_name == "") {
		$.alert("请填写姓名");
		return;
	}
	if (birthday == undefined || birthday == "") {
		$.alert("请填写生日");
		return;
	}
	var pics2 = $("#pics2").val();
	var pics1 = $("#pics").val();
	var pics = (pics2 + pics1);
	var localIds = pics.split(",");
	var serverId = "";
	// 微信
	if (pics != null && pics.length > 0) {
		wx.ready(function() {
			var i = 0;
			var length = localIds.length;
			var upload = function() {
				wx.uploadImage({
					localId : localIds[i],
					success : function(res) {
						serverId += res.serverId + ',';
						// 如果还有照片，继续上传
						i++;
						if (i < length) {
							upload();
						} else {
							$.showIndicator();
							$.ajax({
								type : "POST",
								url : "fit-ws-app-editMsg",
								dataType : "json",
								data : {
									serverId : serverId,
									cust_name : cust_name,
									gym : gym,
									id : id,
									emp_name : emp_name,
									emp_labels : emp_labels,
									emp_content : emp_content,
									birthday : birthday,
									edit_id_card : edit_id_card,
									edit_mem_name : edit_mem_name,
									edit_mem_sex : edit_mem_sex,
									pics2 : pics2,
									openId : wxOpenId
								},
								success : function(data) {
									$.hideIndicator();
									$.toast("修改成功");
									closePopup('.popup-editEmpMsg');
									showMemHead()
								},
								error : function(xhr, type) {
									$.hideIndicator();
									$.toast("您的网速不给力啊，再来一次吧");
								}
							});
						}
					}
				});
			};
			upload();

		});

	} else {
		$.showIndicator();
		$.ajax({
			type : "POST",
			url : "fit-ws-app-editMsg",
			data : {
				cust_name : cust_name,
				gym : gym,
				id : id,
				emp_name : emp_name,
				emp_labels : emp_labels,
				emp_content : emp_content,
				birthday : birthday,
				edit_id_card : edit_id_card,
				edit_mem_name : edit_mem_name,
				edit_mem_sex : edit_mem_sex,
				openId : wxOpenId
			},

			dataType : "json",
			success : function(data) {
				if (data.rs == "Y") {
					$.hideIndicator();
					$.toast("修改成功");
					closePopup('.popup-editEmpMsg');
					showMemHead()
				} else {
					$.toast(data.rs);
				}
			},
			error : function(xhr, type) {
				$.hideIndicator();
				$.toast("您的网速不给力啊，再来一次吧");
			}
		});
	}

}
// 修改信息
function editMemMsg(openId) {
	var mem_name = $("#mem_name").val();
	var mem_addr = $("#mem_addr").val();
	var birthday = $("#birthday").val();
	var edit_mem_name = $("#edit_mem_name").val();
	var edit_id_card = $("#edit_id_card").val();
	var edit_mem_sex = $("#edit_mem_sex").val();
	if (edit_mem_sex == undefined || edit_mem_sex == "") {
		$.alert("请选择性别");
		return;
	}
	if (mem_name == undefined || mem_name == "") {
		$.alert("请填写姓名");
		return;
	}
	if (birthday == undefined || birthday == "") {
		$.alert("请填写生日");
		return;
	}

	var pics = $("#pics2").val();
	var localIds = pics.split(",");
	var serverId = "";
	// 微信
	if (pics != null && pics.length > 0) {
		wx.ready(function() {
			var i = 0;
			var length = localIds.length;
			var upload = function() {
				wx.uploadImage({
					localId : localIds[i],
					success : function(res) {
						serverId += res.serverId + ',';
						// 如果还有照片，继续上传
						i++;
						if (i < length) {
							upload();
						} else {
							$.showIndicator();
							$.ajax({
								type : "POST",
								url : "fit-ws-app-editMemMsg",
								dataType : "json",
								data : {
									serverId : serverId,
									cust_name : cust_name,
									gym : gym,
									id : id,
									mem_name : mem_name,
									mem_addr : mem_addr,
									birthday : birthday,
									edit_id_card : edit_id_card,
									edit_mem_name : edit_mem_name,
									edit_mem_sex : edit_mem_sex,
									openId : wxOpenId
								},
								success : function(data) {
									$.hideIndicator();
									$.toast("修改成功");
									closePopup('.popup-editEmpMsg');
									showMemHead(openId)
								},
								error : function(xhr, type) {
									$.hideIndicator();
									$.toast("您的网速不给力啊，再来一次吧");
								}
							});
						}
					}
				});
			};
			upload();

		});

	} else {
		$.showIndicator();
		$.ajax({
			type : "POST",
			url : "fit-ws-app-editMemMsg",
			data : {
				cust_name : cust_name,
				gym : gym,
				id : id,
				mem_name : mem_name,
				birthday : birthday,
				mem_addr : mem_addr,
				edit_id_card : edit_id_card,
				edit_mem_name : edit_mem_name,
				edit_mem_sex : edit_mem_sex,
				openId : wxOpenId
			},
			dataType : "json",
			success : function(data) {
				$.hideIndicator();
				if (data.rs == "Y") {
					$.hideIndicator();
					$.toast("修改成功");
					closePopup('.popup-editEmpMsg');
					showMemHead(openId)
				} else {
					$.toast(data.rs);
				}
			},
			error : function(xhr, type) {
				$.hideIndicator();
				$.toast("您的网速不给力啊，再来一次吧");
			}
		});
	}

}
// 选择图片
function chooicePhoto() {
	$("#imagesView").html("");
	$("#pics").val("");
	$("#show_emp_pic").hide();
	var images = {
		localIds : []
	};
	wx
			.ready(function() {
				wx
						.chooseImage({
							count : 3,
							success : function(res) {
								images.localIds = res.localIds;
								$("#pics").val(res.localIds);
								var length = images.localIds.length;
								for (var i = 0; i < length; i++) {
									$("#imagesView")
											.prepend(
													'<div style="width: 107px;" class="col-25"><img src="'
															+ images.localIds[i]
															+ '" width="100%" height="88px" /></div>'
															+ '<span class="glyphicon glyphicon-remove" onclick="removeEmpImg(this)" style="z-index: 999">X</span>');
								}
							}
						});
			});
}
// 上传圈圈
function uploadQuan() {
	$("#image_quanquan_div").html("");
	$("#interact_pics").val("");
	var images = {
		localIds : []
	};
	wx
			.ready(function() {
				wx
						.chooseImage({
							count : 3,
							success : function(res) {
								images.localIds = res.localIds;
								$("#interact_pics").val(res.localIds);
								var length = images.localIds.length;
								for (var i = 0; i < length; i++) {
									$("#image_quanquan_div")
											.prepend(
													'<span style="position: relative;display: inline-block;"><img src="'
															+ images.localIds[i]
															+ '" style="vertical-align: middle;margin: 0 0.75rem 0.75rem 0;width:4rem;height:4rem;" />'
															+ '<span class="error-c" onclick="removeImg(this)" style="z-index: 999">×</span></span>');
								}
							}
						});
			});
}
// 移除教练展示图片
function removeEmpImg(th) {
	$(th).parent().remove();
	var divs = $("#imagesView img");
	var val = "";
	for (var i = 0; i < divs.length; i++) {
		if (i != divs.length - 1) {
			val += $(divs[i]).attr("src") + ",";
		} else {
			val += $(divs[i]).attr("src");
		}
	}
	$("#pics").val(val);

}
// 移除圈圈展示图片
function removeImg(th) {
	$(th).parent().remove();
	var divs = $("#image_quanquan_div img");
	var val = "";
	for (var i = 0; i < divs.length; i++) {
		if (i != divs.length - 1) {
			val += $(divs[i]).attr("src") + ",";
		} else {
			val += $(divs[i]).attr("src");
		}
	}
	$("#interact_pics").val(val);

}
// 修改头像
function choiceHead() {
	var images = {
		localIds : []
	};
	wx
			.ready(function() {
				wx
						.chooseImage({
							count : 1,
							success : function(res) {
								images.localIds = res.localIds;
								$("#pics2").val(res.localIds);
								var head_img = '<img src="'
										+ images.localIds[0]
										+ '" style="width: 1.8rem; height: 1.8rem; border-radius: 50%; margin-left: 16px;"/>';
								$("#mem_head_image").html(head_img);
							}
						});
			});
}

function choosePhoto(num) {
	var has_num = $("#sign_imgs_div div").length || 0;
	if (has_num == 9) {
		$.toast("最多只能选9张呢");
		return;
	}
	var images = {
		localIds : []
	};
	wx
			.ready(function() {
				wx
						.chooseImage({
							count : num - has_num,
							success : function(res) {
								images.localIds = res.localIds;
								var length = images.localIds.length;
								var has = $("#sign_imgs_div div").length;
								for (var i = 0; i < length; i++) {
									// $("#imagesView").prepend('<div
									// class="col-25"><img src="' +
									// images.localIds[i] + '" width="100%"
									// height="88px" /></div>');
									var text = ''
											+ '<span style="position: relative;display: inline-block;"><img style="vertical-align: middle;margin: 0 0.75rem 0.75rem 0;width:4rem;height:4rem;" data-id="'
											+ res.localIds[i]
											+ '" src="'
											+ images.localIds[i]
											+ '">'
											+ '<span class="error-c" onclick="removePhoto(this)" style="z-index: 999">×</span></span>';
									$("#sign_imgs_div").append(text);
									$("#sign_imgs").val(
											$("#sign_imgs").val()
													+ images.localIds[i] + ",");
								}
								var divs = $("#sign_imgs_div img");
								var val = "";
								for (var i = 0; i < divs.length; i++) {
									if (i != divs.length - 1) {
										val += $(divs[i]).attr("data-id") + ",";
									} else {
										val += $(divs[i]).attr("data-id");
									}
								}
								$("#sign_imgs").val(val);
							}
						});
			});

}
function removePhoto(t) {
	$(t).parent().remove();
	var divs = $("#sign_imgs_div img");
	var val = "";
	for (var i = 0; i < divs.length; i++) {
		if (i != divs.length - 1) {
			val += $(divs[i]).attr("data-id") + ",";
		} else {
			val += $(divs[i]).attr("data-id");
		}
	}
	$("#sign_imgs").val(val);
}
// 显示会员头像
function showMemHead() {
	$.ajax({
		type : "POST",
		url : "fit-ws-app-isEmp",
		data : {
			cust_name : cust_name,
			gym : gym,
			id : id,
			openId : wxOpenId
		},
		dataType : "json",
		success : function(data) {
			if (data.rs == "Y") {
				var headurl = data.list[0].wxHeadUrl;
				var nickname = data.list[0].nickname;
				$("#wx_head_img").attr('src', headurl);
				$("#wx_nice_name").html(nickname);
			} else {
				$.toast(data.rs);
			}
		},
		error : function() {
			$.alert("联网失败,请稍后再试");
		}
	});
}
function unbundledWechatAccount() {
	$.modal({
		title : '提醒',
		text : '确定要解绑微信',
		buttons : [ {
			text : '取消'
		}, {
			text : '确定',
			onClick : function() {
				$.showIndicator();
				$.ajax({
					type : "POST",
					url : "fit-app-action-unbundledWechatAccount",
					data : {
						gym : gym,
						cust_name : cust_name,
						id : id
					},
					dataType : "json",
					success : function(data) {
						$.hideIndicator();
						if (data.rs == "Y") {
							logined = "N";
							wx.closeWindow();
						} else {
							$.toast(data.rs);
						}
					},
		    		error : function(xhr, type) {
		    			$.hideIndicator();
		    			$.toast("您的网速不给力啊，再来一次吧");
		    		}
				});
			}
		} ]
	})

}

var myPhotoBrowserStandalone;
function showAllPics(index, obj) {
	var $this = $(obj);
    var _result = '';
    // 拼接swipeSlide字符串
    _result += '<div class="slide"><ul>';
    $this.parents('.row').find('img').each(function(i){
        var _src = $(this).attr('src');
        _src = _src.indexOf("?imageView2") > 0 ? _src.substring(0, _src.indexOf("?imageView2")) : _src;
        _result += '<li> <div style="width:'+ $(window).width()+'px;height: '+$(window).height()+'px;"><img src="data:image/gif;base64,R0lGODlhAQABAAD/ACwAAAAAAQABAAACADs=" data-src="' + _src + '"></div></li>';
    });
    _result += '</ul></div>';
    $('.slide_box').show();
    $('.slide_box').prepend(_result);
    
	$('.slide').swipeSlide({
		index : parseInt(index),
        autoSwipe : false,
        lazyLoad : true,
        firstCallback : function(i,sum){
            $('.num_box .num').text(i+1);
            $('.num_box .sum').text(sum);
        },
        callback : function(i,sum){
            $('.num_box .num').text(i+1);
            $('.num_box .sum').text(sum);
        }
    });
	openPopup(".popup-swipePhoto");
}

function showSetPage() {
	openPopup(".settingPopup");

};
//打开提成记录
function showPercentRecort() {
	openPopup(".PercentRecortPopup");
	
};
//打开朋友
function showFriend() {
	openPopup(".friend");
	
};

//我的订单
function showMyIndent(cur,search,type,emp){
	openPopup(".popup-myIndent");
	$("#allIndentDiv").html("");
	$("#noIndentDiv").html("");
	$("#okIndentDiv").html("");
	$("#"+type+"Tab").parent().find("a").removeClass("active");
	$("#"+type+"Tab").addClass("active");
	$.showIndicator();
	if(emp){
		$("#indent_emp").val(emp);
	}
	var indent_emp =  $("#indent_emp").val();
	$.ajax({
		type : "POST",
		url : "fit-ws-app-showMyIndent",
		data : {
			cust_name : cust_name,
			gym : gym,
			phone : phone,
			openId : wxOpenId,
			cur : cur,
			search :search,
			type : type,
			id : id,
			indent_emp :indent_emp 
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				//判断是否为员工，员工和会员显示订单内容有区别
				if(data.isEmp == "N" && indent_emp == "emp"){
					var allIndentTpl = document.getElementById("allIndentTpl").innerHTML;
					var allIndentHtml = template(allIndentTpl, {
						list : data.list,
						cur : Number(cur),
						page : data.page,
						type : type
					});
				}else{
					var empAllIndentTpl = document.getElementById("empAllIndentTpl").innerHTML;
					var allIndentHtml = template(empAllIndentTpl, {
						list : data.list,
						cur : Number(cur),
						page : data.page,
						type : type
					});
				}
				if(type == "allIndent"){
					$("#allIndentDiv").html(allIndentHtml);
				}
				if(type == "noIndent"){
					$("#noIndentDiv").html(allIndentHtml);
				}
				if(type == "okIndent"){
					$("#okIndentDiv").html(allIndentHtml);
				}
				$("#indent_type").val(type);
			} 
			else {
				$.toast(data.rs);
			}
		},
		error : function(xhr, type) {
			$.hideIndicator();
			$.toast("您的网速不给力啊，再来一次吧");
		}
	});
}
//未支付的订单进行支付
function indentPay(indentId){
	
	
}

function changeGym(spanId) {
	$.showIndicator();
	var type = "mem";
	if(spanId){
		type = "emp";
	}
	$.ajax({
		type : "POST",
		url : "fit-ws-app-getGymByCustname",
		data : {
			cust_name : cust_name,
			id:id,
			type:type
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				var gyms = data.gym;
				
				if (gyms && gyms.length > 0) {
					var buttons = new Array();
                 for(var i = 0;i<gyms.length;i++){
                	 var tmp = {};
                	 var  c_gymName = gyms[i].gym_name;
                	 var  c_gym = gyms[i].gym;
     				tmp["text"] = c_gymName;
     				tmp["onClick"] = function(modal, index){
     					
     					var xx = $(index.target).text();
     					$("#"+id).html(xx);
     					
     					for(var k = 0;k<gyms.length;k++){
     						var k_gymName = gyms[k].gym_name;
     						if(k_gymName == xx){
     							gym = gyms[k].gym;
     							gymName = xx;
     						}
     					}
     					$("#gym_name_span").text(gymName);
     					//$(".icon-homepage").parent().click();//刷新首页推荐活动
     					loadCommendActive();
     					if(type=="mem"){
     						//在首页切换门店,只需要检查切换之后是否是员工
     						checkIsEmp();
     					}else{
     						//在员工角色处切换门店,刷新popup
     						flushPopup();
     					}
     				};
     				
     					buttons[i] = tmp;
     			}
     			buttons[buttons.length] = {"text" : "关闭", "bold":true };

                 $.modal({
                	 title : "切换健身房",
                	 extraClass : "custom-modal",
                	 verticalButtons : true,
                	 buttons : buttons
                 })
				}
			} else {
				$.toast(data.rs);
			}
		},
		error : function(xhr, type) {
			$.hideIndicator();
			$.toast("您的网速不给力啊，再来一次吧");
		}
	});

}

function flushPopup(){
	var allPopups = popups;
	if(allPopups.length>0){
		var lastPopup = allPopups[allPopups.length-1];
		if(lastPopup == ".popup-manage-Index"){
			//教练主管
			showManage(false);
		}else if(lastPopup == ".popup-manage-Index-mc"){
			//会籍主管
			showMcManage(false);
		}else if(lastPopup == ".popup-pt-Index"){
			//教练
			showPts(false);
		}else if(lastPopup == ".popup-salesIndex"){
			//会籍
			showSales(false);
		}
	}
}

//检查会员是否是该会所的员工
function checkIsEmp(){
	$.showIndicator();
	$.ajax({
		type : "POST",
		url : "fit-ws-app-checkIsEmpAfterChangeGym",
		data : {
			cust_name : cust_name,
			gym : gym,
			id:id
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				var empRolesUl = $("#empRolesUl");
				$(empRolesUl).html("");
				var html = "";
				if(data.isEmp == "Y"){
					//是切换之后的会所的员工
					var emp = data.emp;
					var mc = emp.mc;
					var pt = emp.pt;
					var ex_mc = emp.ex_mc;
					var ex_pt = emp.ex_pt;
					var sm = emp.sm;
					if(sm == "Y"){
						html +='<li class="item-content item-link"><div class="item-media"><i class="icon icon-m12"></i></div><div class="item-inner" onclick="showBoss()"><div class="item-title">高级管理</div></div></li>';
					}
					if(ex_pt == "Y"){
						html +='<li class="item-content item-link">							<div class="item-media">						<i class="icon icon-m4"></i>					</div>					<div class="item-inner" onclick="showManage()">						<div class="item-title">教练管理</div>					</div>				</li>';
					}
					if(ex_mc == "Y"){
						html +='<li class="item-content item-link">							<div class="item-media">						<i class="icon icon-m13"></i>					</div>					<div class="item-inner" onclick="showMcManage()">						<div class="item-title">会籍管理</div>					</div>				</li>';
					}
					if(pt == "Y"){
						html +='<li class="item-content item-link">							<div class="item-media">						<i class="icon icon-m5"></i>					</div>					<div class="item-inner" onclick="showPts()">						<div class="item-title">我是教练</div>					</div>				</li>';
					}
					if(mc == "Y"){
						html +='<li class="item-content item-link">							<div class="item-media">						<i class="icon icon-m6"></i>					</div>					<div class="item-inner" onclick="showSales()">						<div class="item-title">我是会籍</div>					</div>				</li>';
					}
					$(empRolesUl).html(html);
					role = data.role;
				}else{
					role = "";
				}
			} else {
				$.toast(data.rs);
			}
		},
		error : function(xhr, type) {
			$.hideIndicator();
			$.toast("您的网速不给力啊，再来一次吧");
		}
	});
	
}

//打开体测数据
function showBodyData(mem_id,init) {
	if(!init){
		init = true;
	}
	if(!mem_id){
		mem_id = id;
	}
	$("#bodyDataMemId").val(mem_id);
	$.showIndicator();
	$.ajax({
		type : "POST",
		url : "fit-ws-app-queryBodyDataListByMemId",
		data : {
			cust_name : cust_name,
			gym : gym,
			mem_id:mem_id
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				var tpl = document.getElementById("bodyDataListTpl").innerHTML;
				var html = template(tpl,{list:data.list});
				$("#bodyDataListUl").html(html);
				if(data.list && data.list.length>0){
					var item = data.list[0];
					var content = JSON.parse(item.content);
					$("#bodyHeightLast").text(content.bodyHight);
					$("#bodyWeightLast").text(content.bodyWeight);
					$("#bodyBMILast").text(content.bodyBMI);
					$("#bodyFatLast").text(content.bodyFat);
				}else{
					$("#bodyHeightLast").text("0");
					$("#bodyWeightLast").text("0");
					$("#bodyBMILast").text("0");
					$("#bodyFatLast").text("0");
				}
				if(init){
					openPopup(".bodyData");
				}
			} else {
				$.toast(data.rs);
			}
		},
		error : function(xhr, type) {
			$.hideIndicator();
			$.toast("您的网速不给力啊，再来一次吧");
		}
	});
	
	
};

//体测数据详情
function openBodyDataDetail(data_id){
	$("#bodyDataId").val("");//清掉之前的数据
	$("#image_tice_div").html("");//清掉之前的数据
	var mem_id = $("#bodyDataMemId").val();
	//$("#bodyDataDetailMemId").val(mem_id);
	if(!data_id){
		//新建
		$("#deleteBodyDataButton").text("取消");
		openPopup(".bodyDataDetail");
	}else{
		$("#bodyDataId").val(data_id);
		//修改
		$("#deleteBodyDataButton").text("删除");
		$.showIndicator();
		$.ajax({
			type : "POST",
			url : "fit-ws-app-queryBodyDataById",
			data : {
				cust_name : cust_name,
				gym : gym,
				mem_id:mem_id,
				data_id:data_id
			},
			dataType : "json",
			success : function(data) {
				$.hideIndicator();
				if (data.rs == "Y") {
					var content = data.bodyData.content;
					content = JSON.parse(content);
					$("#bodyWeight").val(content.bodyWeight);
					$("#bodyHight").val(content.bodyHight);
					$("#bodyBMI").val(content.bodyBMI);
					$("#bodyFat").val(content.bodyFat);
					$("#bodyUpperArm").val(content.bodyUpperArm);
					$("#bodyLowerArm").val(content.bodyLowerArm);
					$("#bodyBust").val(content.bodyBust) ;
					$("#bodyWaist").val(content.bodyWaist);
					$("#bodyButtocks").val(content.bodyButtocks);
					$("#bodyLeftThigh").val(content.bodyLeftThigh);
					$("#bodyRightThigh").val(content.bodyRightThigh);
					$("#bodyLeftShank").val(content.bodyLeftShank);
					$("#bodyRightShank").val(content.bodyRightShank);
					$("#bodyDataDate").val(data.bodyData.create_time.substring(0,10));
					var tpl = document.getElementById("bodyDataImageTpl").innerHTML;
					var html = template(tpl,{list:content});
					$("#image_tice_div").html(html);
					var imgs = "";
					for(var k in content){
						if(k.indexOf("pic")>=0){
							imgs += content[k]+",";
						}
					}
					if(imgs!=""){
						imgs = imgs.substring(0,imgs.length-1);
					}
					$("#hasUploadImgs").val(imgs);
					
					openPopup(".bodyDataDetail");
				} else {
					$.toast(data.rs);
				}
			},
			error : function(xhr, type) {
				$.hideIndicator();
				$.toast("您的网速不给力啊，再来一次吧");
			}
		});
	}
}
//保存体测数据
function saveBodyData(){
	var data_id = $("#bodyDataId").val() || "";
	var mem_id = $("#bodyDataMemId").val();
	var content = {};
	var bodyHight = $("#bodyHight").val() || 0;
	content.bodyHight = bodyHight;
	var bodyWeight = $("#bodyWeight").val() || 0;
	content.bodyWeight = bodyWeight;
	var bodyBMI = $("#bodyBMI").val() || 0;
	content.bodyBMI = bodyBMI;
	var bodyFat = $("#bodyFat").val() || 0;
	content.bodyFat = bodyFat;
	var bodyUpperArm = $("#bodyUpperArm").val() || 0;
	content.bodyUpperArm = bodyUpperArm;
	var bodyLowerArm = $("#bodyLowerArm").val() || 0;
	content.bodyLowerArm = bodyLowerArm;
	var bodyBust = $("#bodyBust").val() || 0;
	content.bodyBust = bodyBust;
	var bodyWaist = $("#bodyWaist").val() || 0;
	content.bodyWaist = bodyWaist;
	var bodyButtocks = $("#bodyButtocks").val() || 0;
	content.bodyButtocks = bodyButtocks;
	var bodyLeftThigh = $("#bodyLeftThigh").val() || 0;
	content.bodyLeftThigh = bodyLeftThigh;
	var bodyRightThigh = $("#bodyRightThigh").val() || 0;
	content.bodyRightThigh = bodyRightThigh;
	var bodyLeftShank = $("#bodyLeftShank").val() || 0;
	content.bodyLeftShank = bodyLeftShank;
	var bodyRightShank = $("#bodyRightShank").val() || 0;
	content.bodyRightShank = bodyRightShank;
	
	content = JSON.stringify(content);
	var create_time = $("#bodyDataDate").val();
	var pics = $("#image_tice_div_hid").val();
	var localIds = pics.split(",");
	var serverId = "";
	var hasUploadImgs = $("#hasUploadImgs").val() || "";
	// 微信
	if (pics != null && pics.length > 0) {
		wx.ready(function() {
			var i = 0;
			var length = localIds.length;
			var upload = function() {
				wx.uploadImage({
					localId : localIds[i],
					success : function(res) {
						serverId += res.serverId + ',';
						// 如果还有照片，继续上传
						i++;
						if (i < length) {
							upload();
						} else {
							$.showIndicator();
							$.ajax({
								type : "POST",
								url  : "fit-ws-app-saveBodyData",
								data : {
									cust_name : cust_name,
									gym : gym,
									mem_id:mem_id,
									data_id:data_id,
									content:content,
									create_time:create_time,
									pt_id:id,
									serverId : serverId,
									hasUploadImgs:hasUploadImgs
									
								},
								dataType : "json",
								success : function(data) {
									$.hideIndicator();
									if (data.rs == "Y") {
										$.toast("保存成功");
										closePopup(".bodyDataDetail");
										//刷新
										showBodyData(mem_id,false);
										//清除数据
										$("#bodyWeight").val("0");
										$("#bodyHight").val("0");
										$("#bodyBMI").val("0");
										$("#bodyFat").val("0");
										$("#bodyUpperArm").val("0");
										$("#bodyLowerArm").val("0");
										$("#bodyBust").val("0") ;
										$("#bodyWaist").val("0");
										$("#bodyButtocks").val("0");
										$("#bodyLeftThigh").val("0");
										$("#bodyRightThigh").val("0");
										$("#bodyLeftShank").val("0");
										$("#bodyRightShank").val("0");
										$("#bodyDataDate").val("0");
									} else {
										$.toast(data.rs);
									}
								},
								error : function(xhr, type) {
									$.hideIndicator();
									$.toast("您的网速不给力啊，再来一次吧");
								}
							});
						}
					}
				});
			};
			upload();

		});

	} else {
		$.showIndicator();
		$.ajax({
			type : "POST",
			url  : "fit-ws-app-saveBodyData",
			data : {
				cust_name : cust_name,
				gym : gym,
				mem_id:mem_id,
				data_id:data_id,
				content:content,
				create_time:create_time,
				pt_id:id
				
			},
			dataType : "json",
			success : function(data) {
				$.hideIndicator();
				if (data.rs == "Y") {
					$.toast("保存成功");
					closePopup(".bodyDataDetail");
					//刷新
					showBodyData(mem_id,false);
					//清除数据
					$("#bodyWeight").val("0");
					$("#bodyHight").val("0");
					$("#bodyBMI").val("0");
					$("#bodyFat").val("0");
					$("#bodyUpperArm").val("0");
					$("#bodyLowerArm").val("0");
					$("#bodyBust").val("0") ;
					$("#bodyWaist").val("0");
					$("#bodyButtocks").val("0");
					$("#bodyLeftThigh").val("0");
					$("#bodyRightThigh").val("0");
					$("#bodyLeftShank").val("0");
					$("#bodyRightShank").val("0");
					$("#bodyDataDate").val("0");
				} else {
					$.toast(data.rs);
				}
			},
			error : function(xhr, type) {
				$.hideIndicator();
				$.toast("您的网速不给力啊，再来一次吧");
			}
		});
	}
}
//删除体测数据
function deleteBodyDataById(){
	var data_id = $("#bodyDataId").val();
	var mem_id = $("#bodyDataMemId").val();
	if(!data_id){
		closePopup(".bodyDataDetail");
	}else{
	  $.confirm('确认删除吗?', function () {
	    	  $.ajax({
	    			type : "POST",
	    			url  : "fit-ws-app-deleteBodyDataById",
	    			data : {
	    				cust_name : cust_name,
	    				gym : gym,
	    				mem_id:mem_id,
	    				data_id:data_id
	    			},
	    			dataType : "json",
	    			success : function(data) {
	    				$.hideIndicator();
	    				if (data.rs == "Y") {
	    					$.toast("删除成功");
	    					closePopup(".bodyDataDetail");
	    					//刷新
	    					showBodyData(mem_id,false);
	    				} else {
	    					$.toast(data.rs);
	    				}
	    			},
	    			error : function(xhr, type) {
	    				$.hideIndicator();
	    				$.toast("您的网速不给力啊，再来一次吧");
	    			}
	    		});
		 });
	}
}
//教练查看并操作体测设局
function showMemBodyData(){
	var mem_id = $('#mem_id_pt').val();
	showBodyData(mem_id);
}
//上传体测图片
function uploadTiCe() {
	/*$("#image_tice_div").html("");
	$("#image_tice_div_hid").val("");*/
	var hasNum = $("#image_tice_div img").length || 0;
	if(hasNum == 9){
		$.toast("最多只能选9张图片哒");
		return;
	}
	var images = {
		localIds : []
	};
	wx
			.ready(function() {
				wx
						.chooseImage({
							count : 9-hasNum,
							success : function(res) {
								images.localIds = res.localIds;
								var hasImgs = $("#image_tice_div_hid").val();
								if(hasImgs){
									$("#image_tice_div_hid").val(hasImgs+","+res.localIds);
								}else{
									$("#image_tice_div_hid").val(res.localIds);
								}
								var length = images.localIds.length;
								for (var i = 0; i < length; i++) {
									$("#image_tice_div")
											.prepend(
													'<span style="position: relative;display: inline-block;"><img src="'
															+ images.localIds[i]
															+ '" style="vertical-align: middle;margin: 0 0.75rem 0.75rem 0;width:4rem;height:4rem;" />'
															+ '<span class="error-c" onclick="removeTiCeImg(this)" style="z-index: 999">×</span></span>');
								}
							}
						});
			});
}
// 移除体测图片
function removeTiCeImg(th) {
	$(th).parent().remove();
	var divs = $("#image_tice_div img");
	var val = "";
	for (var i = 0; i < divs.length; i++) {
		if (i != divs.length - 1) {
			val += $(divs[i]).attr("src") + ",";
		} else {
			val += $(divs[i]).attr("src");
		}
	}
	$("#image_tice_div_hid").val(val);

}

//会员预约教练
function memPrivateOrder(pt_id,name,isExPt){
	if(isExPt){
		//管理点击查看的
		$("#privateOrderIsExPt").val("true");
	}
	if(!pt_id){
		pt_id = id;
		$("#privateOrderRole").val("pt");//教练
	}else{
		if(pt_id == id){
			$("#privateOrderRole").val("pt");
		}else{
			$("#privateOrderRole").val("mem");
		}
	}
	$("#privateOrderPtId").val(pt_id);
	if(name){
		$("#privateOrderPopupTitile").text("私练["+name+"]的预约");
	}else{
		$("#privateOrderPopupTitile").text("私教预约");
	}
	//初始化日期
	var now = new Date();
	var time = now.getTime();
	var index1 = now.getDay();
	var date1 =now.Format("yyyy-MM-dd");
	
	var day2 = new Date(time + 3600*24*1000); 
	var index2 = day2.getDay();
	var date2 =day2.Format("yyyy-MM-dd");
	var day3 = new Date(time + 3600*24*2*1000); 
	var index3 = day3.getDay();
	var date3 =day3.Format("yyyy-MM-dd");
	var hao3 = day3.getDate();
	var day4 = new Date(time + 3600*24*3*1000); 
	var index4 = day4.getDay();
	var date4 = day4.Format("yyyy-MM-dd");
	var hao4 = day4.getDate();
	var day5 = new Date(time + 3600*24*4*1000); 
	var index5 = day5.getDay();
	var date5 =day5.Format("yyyy-MM-dd");
	var hao5 = day5.getDate();
	var day6 = new Date(time + 3600*24*5*1000); 
	var index6 = day6.getDay();
	var date6 =day6.Format("yyyy-MM-dd");
	var hao6 = day6.getDate();
	var day7 = new Date(time + 3600*24*6*1000); 
	var index7 = day7.getDay();
	var date7 =day7.Format("yyyy-MM-dd");
	var hao7 = day7.getDate();

	
	openPopup(".popup-privateOrderPopup");
	
	var weeks = ["周日","周一","周二","周三","周四","周五","周六"];
	$(".upright-left div").eq(0).html('今天</br> <font size="0.5rem">'+weeks[index1]+'</font>');
	$(".upright-left div").eq(1).html('明天</br> <font size="0.5rem">'+weeks[index2]+'</font>');
	$(".upright-left div").eq(2).html(hao3+'日</br> <font size="0.5rem">'+weeks[index3]+'</font>');
	$(".upright-left div").eq(3).html(hao4+'日</br> <font size="0.5rem">'+weeks[index4]+'</font>');
	$(".upright-left div").eq(4).html(hao5+'日</br> <font size="0.5rem">'+weeks[index5]+'</font>');
	$(".upright-left div").eq(5).html(hao6+'日</br> <font size="0.5rem">'+weeks[index6]+'</font>');
	$(".upright-left div").eq(6).html(hao7+'日</br> <font size="0.5rem">'+weeks[index7]+'</font>');
	
	$(".upright-left div").eq(0).attr("data-orderdate",date1);
	$(".upright-left div").eq(1).attr("data-orderdate",date2);
	$(".upright-left div").eq(2).attr("data-orderdate",date3);
	$(".upright-left div").eq(3).attr("data-orderdate",date4);
	$(".upright-left div").eq(4).attr("data-orderdate",date5);
	$(".upright-left div").eq(5).attr("data-orderdate",date6);
	$(".upright-left div").eq(6).attr("data-orderdate",date7);
	
	//查询预约
	//queryPrivateOrderByDate();
	//$(".upright-left div").eq(0).click();
	changePrivateOrderDate($(".upright-left div:first-child"));
	
}