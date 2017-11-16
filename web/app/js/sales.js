//显示我是会籍页面
function showSales(open) {
	if(!open){
		open = true;
	}
	if(logined!='Y'){
		openPopup(".wxloginPopup");
		return;
	}
	$.showIndicator();
	$.ajax({
		type : "POST",
		url : "fit-app-action-showSalesInfo",
		data : {
			gym : gym,
			cust_name : cust_name,
			fk_user_id : id,
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				$("#cSize").html(data.cSize);
				$("#pcSize").html(data.pcSize);
				$("#mSize").html(data.mSize);
				$("#sales_gym_name_span").html(gymName);
				if(open){
					openPopup(".popup-salesIndex");
				}
			} else {
				$.toast(data.rs);
			}
		},
        error: function(xhr, type) {
            $.hideIndicator();
            $.toast("您的网速不给力啊，再来一次吧");
        }
	});

}
// 会籍销售记录
function showMcSalesRecord(emp_id) {

	if (!emp_id) {
		emp_id = id;
	}

	var now = new Date();
	var m = now.getMonth();
	var y = now.getFullYear();
	var month = [];
	month.push("所有月份");
	for (var i = 0; i < 2; i++) {
		if (i == 0) {
			for (var j = m; j >= 0; j--) {
				var xx = new Date(y, j, 1).Format("yyyy-MM");
				month.push(xx);
			}
		} else {
			y--;
			for (var j = 11; j >= 0; j--) {
				var xx = new Date(y, j, 1).Format("yyyy-MM");
				month.push(xx);
			}
		}
	}

	$("#mcSalesMonthPicker")
			.picker(
					{
						toolbarTemplate : '<header class="bar bar-nav">\
		  <button class="button button-link pull-right close-picker">确定</button>\
		  <h1 class="title">请选择月份</h1>\
		  </header>',
						cols : [ {
							textAlign : 'center',
							values : month
						} ],
						onClose : function() {
							queryMcSalesRecord(emp_id, "month", $(
									"#mcSalesMonthPicker").val(), false);
						}
					});
	$("#mcSalesMonthPicker").val(new Date().Format("yyyy-MM"));
	$("#mcSalesMonthPicker").picker("setValue",
			[ new Date().Format("yyyy-MM") ]);

	queryMcSalesRecord(emp_id, "month", new Date().Format("yyyy-MM"), true);
}

// 查询会籍销售
function queryMcSalesRecord(emp_id, condition, conditionData, init) {
	$.showIndicator();
	$.ajax({
				type : "POST",
				url : "fit-app-action-empSalesRecord",
				data : {
					gym : gym,
					cust_name : cust_name,
					emp_id : emp_id,
					condition : condition,
					conditionData : conditionData,
					type : "MC"
				},
				dataType : "json",
				success : function(data) {
					$.hideIndicator();
					if (data.rs == "Y") {
						var tpl = document.getElementById("mcSalesRecordTpl").innerHTML;
						var content = template(tpl, {
							list : data.list
						});
						$("#mcSlaseRecordUl").html(content);
						if (init) {
							openPopup('.popup-mcSlaseRecord');
						}
					} else {
						$.toast(data.rs);
					}
				},
		        error: function(xhr, type) {
		            $.hideIndicator();
		            $.toast("您的网速不给力啊，再来一次吧");
		        }
			});
}

function showMcOp(emp_id, emp_name) {
	$.modal({
		title : emp_name,
		extraClass : "custom-modal",
		verticalButtons : true,
		buttons : [ {
			text : '会籍资料',
			onClick : function() {
				shwoMcDetial(emp_id);
			}
		}, {
			text : '销售记录',
			onClick : function() {
				show_one_emp_salesRecord(emp_id, emp_name);
			}
		}, {
			text : '会员维护',
			onClick : function() {
				showCustomers(emp_id, 'false');
			}
		}, {
			text : '潜在客户',
			onClick : function() {
				showPotentialCustomers(emp_id, 'false');
			}
		}, {
			text : '所有会员',
			onClick : function() {
				showMcMemsById(emp_id, "MC");
			}
		}, {
			text : '销售报表',
			onClick : function() {
				showMcReport(emp_id, emp_name);
			}
		}, {
			text : '关闭',
			bold : true
		},

		]
	})
}

// 显示会籍详情
function shwoMcDetial(fk_emp_id) {
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
								.getElementById("mcDetialTpl").innerHTML;
						content = template(EmpDetialTpl, {
							data : data.list,
						});
						content = content.replace(/&amp;/g, "&");
						content = content.replace(/&lt;/g, "<");
						content = content.replace(/&gt;/g, ">");
						content = content.replace(/&nbsp;/g, " ");
						content = content.replace(/&#39;/g, "\'");
						content = content.replace(/&quot;/g, "\"");
						$("#mcDetialtDiv").html(content);
						openPopup(".popup-mcDetial");
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

function show_one_emp_salesRecord(id, name) {
	var now = new Date().Format("yyyy-MM-dd");
	$("#empsMcSalesDay").val(now);
	$("#empsMcSalesDay").unbind("change");
	$("#empsMcSalesDay").change(function() {
		queryOneEmpMcSales(id, "day", $(this).val(), false);
	});
	$("#mepsMcHeaderTitle").text("会籍[" + name + "]的销售记录");
	queryOneEmpMcSales(id, "day", $("#empsMcSalesDay").val(), true);
}

function queryOneEmpMcSales(emp_id, condition, conditionData, init) {
	$.showIndicator();
	$.ajax({
				type : "POST",
				url : "fit-app-action-empSalesRecord",
				data : {
					gym : gym,
					cust_name : cust_name,
					emp_id : emp_id,
					condition : condition,
					conditionData : conditionData,
					type : "MC"
				},
				dataType : "json",
				success : function(data) {
					$.hideIndicator();
					if (data.rs == "Y") {
						var tpl = document.getElementById("mcSalesRecordTpl").innerHTML;
						var content = template(tpl, {
							list : data.list
						});
						$("#empsMcSalesUl").html(content);
						if (init) {
							openPopup('.popup-empsMcSalesRecord');
						}
					} else {
						$.toast(data.rs);
					}
				},
		        error: function(xhr, type) {
		            $.hideIndicator();
		            $.toast("您的网速不给力啊，再来一次吧");
		        }
			});

}

// ---------------------------------会员管理----------------------------------------------------------------
function showCustomers(id, show) {
	$("#manage_mc_hid").val("");
	$("#manage_mc_id").val("");
	$("#manage_mc_hid").val(show);
	$("#manage_mc_id").val(id);
	openPopup(".popup-customers");
	searchcustomers("最近维护", id, show);
}
function showCustomers2(emp_id) {
	if(!emp_id){
		emp_id = id;
	}
	$("#queryMcAddMemId").val(emp_id);
	queryMcAddMem(true);
}

function queryMcAddMem(init){
	var emp_id = $("#queryMcAddMemId").val();
	var month = $("#mcAddMemPicker").val();
	$.ajax({
		type : "POST",
		url : "fit-app-action-queryMcAddNewAddMem",
		data : {
			gym : gym,
			cust_name : cust_name,
			id : emp_id,
			month:month
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				var tpl = document.getElementById("todayAdd_newAddMemTpl").innerHTML;
                content = template(tpl, {
                    data: data.data
                });

				$("#queryMcAddMemDiv").html(content);
				if(init){
					openPopup(".popup-mc-mcAddMem");
				}
			} else {
				$.toast(data.rs);
			}
		},
        error: function(xhr, type) {
            $.hideIndicator();
            $.toast("您的网速不给力啊，再来一次吧");
        }
	});
}


// 筛选会员
function searchcustomers(type, fk_user_id, show) {
	if (fk_user_id == undefined || fk_user_id == "") {
		fk_user_id = id;
	}
	$("#manage_mc_hid").val(show);
	$("#manage_mc_id").val(fk_user_id);
	$.showIndicator();
	$.ajax({
		type : "POST",
		url : "fit-app-action-searchCustomers",
		data : {
			gym : gym,
			cust_name : cust_name,
			type : type,
			fk_user_id : fk_user_id,
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				var tpl = document.getElementById("customersTpl").innerHTML;
				content = template(tpl, {
					data : data.mems,
					show : show
				});
				$("#Tab1_customerscontent").html(content);
			} else {
				$.toast(data.rs);
			}
		},
        error: function(xhr, type) {
            $.hideIndicator();
            $.toast("您的网速不给力啊，再来一次吧");
        }
	});
}
// 查看会员详情
function showCustomerDetial(fk_user_id, type) {
	$("#mem_recordText").val("");
	$.showIndicator();
	$.ajax({
				type : "POST",
				url : "fit-app-action-getPotentialCustomerById",
				data : {
					gym : gym,
					cust_name : cust_name,
					fk_user_id : fk_user_id,
					type : 'mc'
				},
				dataType : "json",
				success : function(data) {
					$.hideIndicator();
					if (data.rs == "Y") {
						var mem = data.map.xx;
						if (mem) {
							$("#mem_id").val(fk_user_id);
							$("#mem_name").html(mem.name);
							$("#mem_phone").html(mem.phone);
							$("#mem_birthday").html(mem.birthday);
							$("#mem_create_time").html(mem.create_time);
							$("#mem_mc_name").html(mem.mcName);

							$("#mem_remark").html(mem.remark);
							$("#op_time").html(mem.op_time);
							$("#mem_imp_level").html(mem.imp_level);
							var headurl = mem.headurl;
							 if(!headurl || headurl.length <= 0){
						        	headurl = "app/images/head/default.png";
						        }
							$("#mem_headurl").attr("src",headurl);
						}
						if ("false" == type) {
							$("#mem_record_div").hide();
							$("#mem_record_div_btn").hide();
						} else {
							$("#mem_record_div").show();
							$("#mem_record_div_btn").show();
							var tpl = document.getElementById("mem_reocrdTpl").innerHTML;
							content = template(tpl, {
								data : data.record
							});
							$("#mem_reocrd").html(content);
						}

						openPopup(".popup-customerDetial");
					} else {
						$.toast(data.rs);
					}
				},
		        error: function(xhr, type) {
		            $.hideIndicator();
		            $.toast("您的网速不给力啊，再来一次吧");
		        }
			});
}
function changeFoucs(inputId, fk_user_input_id, type) {
	var fk_user_id = $("#" + fk_user_input_id).val();
	var buttons1 = [ {
		text : '请选择',
		label : true
	}, {
		text : '高关注',
		onClick : function() {
			$("#" + inputId).html('高关注');
			dochangeFoucs(fk_user_id, "高关注", type);
		}
	}, {
		text : '普通',
		onClick : function() {
			$("#" + inputId).html('普通');
			dochangeFoucs(fk_user_id, "普通", type);
		}
	}, {
		text : '不维护',
		onClick : function() {
			$("#" + inputId).html('不维护');
			dochangeFoucs(fk_user_id, "不维护", type);
		}
	} ];
	var buttons2 = [ {
		text : '取消',
	} ];
	var groups = [ buttons1, buttons2 ];
	$.actions(groups);

}
function dochangeFoucs(fk_user_id, imp_level, type) {
	$.showIndicator();
	$.ajax({
		type : "POST",
		url : "fit-app-action-changeFoucs",
		data : {
			gym : gym,
			cust_name : cust_name,
			fk_user_id : fk_user_id,
			imp_level : imp_level
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
			} else {
				$.toast(data.rs);
			}
		},
        error: function(xhr, type) {
            $.hideIndicator();
            $.toast("您的网速不给力啊，再来一次吧");
        }
	});
}
// 添加跟单记录
function mem_addMaintian(type) {

	var fk_user_id = $("#mem_id").val();
	var recordText = $("#mem_recordText").val();
	var upcoming = $("#mem_upcoming").val();
	var upcomingTime = $("#mem_upcomingTime").val();
	if (recordText.length <= 0) {
		$.toast("请填写记录内容");
		return;
	}
	$.showIndicator();
	$.ajax({
		type : "POST",
		url : "fit-app-action-addMaintian",
		data : {
			gym : gym,
			cust_name : cust_name,
			fk_user_id : fk_user_id,
			recordText : recordText,
			upcoming : upcoming,
			upcomingTime : upcomingTime,
			op_id : id,
			// op_id : '596581f5e8bbca1654e1faab',
			type : 'mc'
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				showCustomerDetial(fk_user_id, type);
			} else {
				$.toast(data.rs);
			}
		},
        error: function(xhr, type) {
            $.hideIndicator();
            $.toast("您的网速不给力啊，再来一次吧");
        }
	});
}
// 打开会员维护-会员卡页面
function showMemCards(type) {
	var mem_id ="";
	if(type=='mc'){
		 mem_id = $("#mem_id").val();
	}
	if (type == 'pt' ) {
		mem_id = $("#mem_id_pt").val();
	}
     console
	$.showIndicator();
	$
			.ajax({
				type : "POST",
				url : "yp-ws-app-getMyCards",
				data : {
					id : mem_id,
					gym : gym,
					cust_name : cust_name
				},
				dataType : "json",
				async : false,
				success : function(data) {
					$.hideIndicator();
					if (data.rs == "Y") {
						var tpl = document.getElementById("customerCardsTpl").innerHTML;
						content = template(tpl, {
							data : data.cards
						});
						$("#customerCards").html(content);
						openPopup(".popup-customerCards");
					} else {
						alert(data.rs);
					}
				},
		        error: function(xhr, type) {
		            $.hideIndicator();
		            $.toast("您的网速不给力啊，再来一次吧");
		        }
			});
}
// 打开会员维护-充值记录
function showRechargeRecord() {
	var mem_id = $("#mem_id").val();
	if (mem_id.length == 0) {
		mem_id = $("#mem_id_pt").val();
	}
	$.showIndicator();
	$
			.ajax({
				type : "POST",
				url : "fit-app-action-rechargeRecord",
				data : {
					id : mem_id,
					gym : gym
				},
				dataType : "json",
				async : false,
				success : function(data) {
					$.hideIndicator();
					if (data.rs == "Y") {
						var tpl = document
								.getElementById("customerRechargeRecordTpl").innerHTML;
						content = template(tpl, {
							data : data.consumelist
						});
						$("#customerRechargeRecord").html(content);
						openPopup(".popup-customerRechargeRecord");
					} else {
						alert(data.rs);
					}
				},
		        error: function(xhr, type) {
		            $.hideIndicator();
		            $.toast("您的网速不给力啊，再来一次吧");
		        }
			});
}
// 打开会员维护-签到记录
function showCheckInRecord() {
	var mem_id = $("#mem_id").val();
	if (mem_id.length == 0) {
		mem_id = $("#mem_id_pt").val();
	}
	$.showIndicator();
	$
			.ajax({
				type : "POST",
				url : "fit-app-action-checkInRecord",
				data : {
					id : mem_id,
					gym : gym
				},
				dataType : "json",
				async : false,
				success : function(data) {
					$.hideIndicator();
					if (data.rs == "Y") {
						var tpl = document
								.getElementById("customerCheckInRecordTpl").innerHTML;
						content = template(tpl, {
							data : data.checkinList,
							checkinsize : data.checkinsize
						});
						$("#customerCheckInRecord").html(content);
						openPopup(".popup-customerCheckInRecord");
					} else {
						alert(data.rs);
					}
				},
		        error: function(xhr, type) {
		            $.hideIndicator();
		            $.toast("您的网速不给力啊，再来一次吧");
		        }
			});

}
// 会员的待办事项
function shwoCustomersToBeDone(fk_user_id,from) {
	$("#Tab1_customerscontent").html("");
	var user = store.get("fitUser");
	$.showIndicator();
	$.ajax({
				type : "POST",
				url : "fit-app-action-showCustomersToBeDone",
				data : {
					gym : gym,
					cust_name : cust_name,
					state : '001',
					fk_user_id : fk_user_id,
					from : from
				},
				dataType : "json",
				success : function(data) {
					$.hideIndicator();
					if (data.rs == "Y") {
						var tpl = document
								.getElementById("CustomersToBeDoneTpl").innerHTML;
						content = template(tpl, {
							data : data.data
						});
						$("#Tab1_customerscontent").html(content);
					} else {
						$.toast(data.rs);
					}
				},
		        error: function(xhr, type) {
		            $.hideIndicator();
		            $.toast("您的网速不给力啊，再来一次吧");
		        }
			});

}
// 完成待办事项
function customersToBeDone(fk_user_id) {
	var flag = $('#' + fk_user_id).is(':checked');
	if (flag) {
		$.modal({
			title : '提醒',
			text : '确定完成此事项',
			buttons : [ {
				text : '取消'
			}, {
				text : '确定',
				onClick : function() {
					$.showIndicator();
					$.ajax({
						type : "POST",
						url : "fit-app-action-customersToBeDone",
						data : {
							gym : gym,
							cust_name : cust_name,
							id : fk_user_id
						},
						dataType : "json",
						success : function(data) {
							$.hideIndicator();
							if (data.rs == "Y") {
								shwoCustomersToBeDone();
							} else {
								$.toast(data.rs);
							}
						},
				        error: function(xhr, type) {
				            $.hideIndicator();
				            $.toast("您的网速不给力啊，再来一次吧");
				        }
					});

				}
			}, ]
		})
	}
}
// ---------------------------------潜在客户----------------------------------------------------------------
// 打开潜在客户页面
function showPotentialCustomers(fk_emp_id, show) {
	$("#manage_mc_id2").val("");
	$("#manage_mc_hid2").val("");
	$("#manage_mc_id2").val(id);
	$("#manage_mc_hid2").val(show);
	openPopup(".popup-potentialCustomers");
	searchPotentialCustomers("最近维护", fk_emp_id, show);
}
function showPotentialCustomers2(emp_id) {
	if(!emp_id){
		emp_id = id;
	}
	$("#queryMcAddQMemId").val(emp_id);
	queryMcAddQMem(true);
}

function queryMcAddQMem(init){
	var emp_id = $("#queryMcAddQMemId").val();
	var month = $("#mcAddQMemPicker").val();
	$.ajax({
		type : "POST",
		url : "fit-app-action-queryMcAddNewAddQMem",
		data : {
			gym : gym,
			cust_name : cust_name,
			id : emp_id,
			month:month
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
			   var tpl = document.getElementById("todayAdd_PotentialCustomersTpl").innerHTML;
                content = template(tpl, {
                    data: data.data
                });
				$("#queryMcAddQMemDiv").html(content);
				if(init){
					openPopup(".popup-mc-mcAddQMem");
				}
			} else {
				$.toast(data.rs);
			}
		},
        error: function(xhr, type) {
            $.hideIndicator();
            $.toast("您的网速不给力啊，再来一次吧");
        }
	});
}

// 搜索潜在会员
function searchPotentialCustomers(type, fk_user_id, show) {
	if (fk_user_id == undefined || fk_user_id == "") {
		fk_user_id = id;
	}
	$("#manage_mc_id2").val(fk_user_id);
	$("#manage_mc_hid2").val(show);
	$.showIndicator();
	$
			.ajax({
				type : "POST",
				url : "fit-app-action-searchPotentialCustomers",
				data : {
					gym : gym,
					cust_name : cust_name,
					type : type,
					fk_user_id : fk_user_id
				},
				dataType : "json",
				success : function(data) {
					$.hideIndicator();
					if (data.rs == "Y") {
						var tpl = document
								.getElementById("PotentialCustomersTpl").innerHTML;
						content = template(tpl, {
							data : data.mems,
							show : show
						});
						$("#Tab1_content").html(content);
					} else {
						$.toast(data.rs);
					}
				},
		        error: function(xhr, type) {
		            $.hideIndicator();
		            $.toast("您的网速不给力啊，再来一次吧");
		        }
			});

}
// 打开添加潜在客户页面
function addPotentialCustomers(type) {
	if (type == "manger") {
		$("#add_mem_from").val("true");
	} else {
		$("#add_mem_from").val("false");
	}
	openPopup(".popup-potentialCustomersAdd");
}
// 添加潜在客户
function savePotentialCustomer() {
	var mem_name = $("#add_mem_name").val();
	var phone = $("#add_phone").val();
	var sex = $("#add_sex").val();
	var birthday = $("#add_birthday").val();
	var imp_level = $("#add_imp_level").val();
	var source = $("#add_source").val();
	var remark = $("#add_remark").val();
	var from = $("#add_mem_from").val();
	if (mem_name.length <= 0) {
		$.toast("请填写姓名");
		return;
	}
	if (sex.length <= 0) {
		$.toast("请选择性别");
		return;
	}
	if (birthday.length <= 0) {
		$.toast("请选择生日");
		return;
	}
	if (phone.length <= 0) {
		$.toast("请填写电话号码");
		return;
	}
	$.showIndicator();
	$.ajax({
		type : "POST",
		url : "fit-app-action-savePotentialCustomer",
		data : {
			gym : gym,
			cust_name : cust_name,
			fk_user_id : id,
			mem_name : mem_name,
			sex : sex,
			birthday : birthday,
			phone : phone,
			source : source,
			remark : remark,
			imp_level : imp_level,
			from : from
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				$.toast("添加成功");
				$("#add_mem_name").val('');
				$("#add_phone").val('');
				$("#add_remark").val('');
				closePopup('.popup-potentialCustomersAdd');
				if ("true" == from) {
					showMCPool();
				} else {
					searchPotentialCustomers("最近维护");
				}
			} else {
				$.toast(data.rs);
			}
		},
        error: function(xhr, type) {
            $.hideIndicator();
            $.toast("您的网速不给力啊，再来一次吧");
        }
	});
}
// 查看潜在客户详情
function showPotentialCustomerDetial(fk_user_id, type) {
	$("#recordText").val("");
	$.showIndicator();
	$.ajax({
		type : "POST",
		url : "fit-app-action-getPotentialCustomerById",
		data : {
			gym : gym,
			cust_name : cust_name,
			fk_user_id : fk_user_id,
			type : 'qmc'
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
					var mem = data.map.xx;
					if (mem) {
					$("#pc_id").val(fk_user_id);
					$("#pc_name").html(mem.name);
					$("#pc_phone").html(mem.phone);
					$("#pc_birthday").html(mem.birthday);
					$("#pc_create_time").html(mem.create_time);
					var mc_name = mem.mcName
					if (mc_name.length > 1) {
						console.log(mc_name);
						$("#mc_name_bundled").show();
					} else {
						console.log(mc_name.length);
						$("#mc_name_bundled").hide();
					}
					$("#mc_name").html(mc_name);
					$("#pc_remark").html(mem.remark);
					$("#op_time").html(mem.op_time);
					$("#pc_imp_level").html(mem.imp_level);
					var headurl = mem.headurl;
					 if(!headurl || headurl.length <= 0){
				        	headurl = "app/images/head/default.png";
				        }
					$("#pc_mem_headurl").attr("src",headurl);
				}
				openPopup(".popup-PotentialCustomerDetial");
				//closePopup('.popup-PotentialCustomerDetial');
				if (type == "false") {
					$("#p_recordDiv").hide();
					$("#p_recordDiv_btn").hide();
					$("#mc_name_bundled").hide();
					
				} else {
					// changeFoucs("pc_imp_level_div",'pc_imp_level',fk_user_id);
					$("#p_recordDiv").show();
					$("#p_recordDiv_btn").show();
					$("#mc_name_bundled").show();
				}
				var tpl = document.getElementById("pc_reocrdTpl").innerHTML;
				content = template(tpl, {
					data : data.record
				});
				$("#pc_reocrd").html(content);
			} else {
				$.toast(data.rs);
			}
		},
        error: function(xhr, type) {
            $.hideIndicator();
            $.toast("您的网速不给力啊，再来一次吧");
        }
	});
}
function addMaintian(type) {

	var fk_user_id = $("#pc_id").val();
	var recordText = $("#recordText").val();
	var upcoming = $("#upcoming").val();
	var upcomingTime = $("#upcomingTime").val();
	if (recordText.length <= 0) {
		$.toast("请填写记录内容");
		return;
	}
	$.showIndicator();
	$.ajax({
		type : "POST",
		url : "fit-app-action-addMaintian",
		data : {
			gym : gym,
			cust_name : cust_name,
			fk_user_id : fk_user_id,
			recordText : recordText,
			upcoming : upcoming,
			upcomingTime : upcomingTime,
			op_id : id,
			// op_id : '596581f5e8bbca1654e1faab',
			type : 'qmc'
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				if (type == "manage") {
					showPotentialCustomerDetial(fk_user_id);
				} else {
					showPotentialCustomerDetial(fk_user_id);
				}
				
			} else {
				$.toast(data.rs);
			}
		},
        error: function(xhr, type) {
            $.hideIndicator();
            $.toast("您的网速不给力啊，再来一次吧");
        }
	});
}
// 打开修改潜客页面
function showUpdateMem() {
	var pc_id = $("#pc_id").val();
	$.showIndicator();
	$.ajax({
		type : "POST",
		url : "fit-app-action-getPotentialCustomerById",
		data : {
			gym : gym,
			cust_name : cust_name,
			fk_user_id : pc_id
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				var mem = data.map.xx;
				if (mem) {
					$("#pc_id_detial").val('');
					$("#pc_id_detial").val(pc_id);
					$("#pc_name_detial").val(mem.name);
					$("#pc_phone_detial").val(mem.phone);
					$("#pc_remark_detial").val(mem.remark);
					$("#pc_imp_level_detial").val(mem.imp_level);
				}
				openPopup(".popup-updatePotentialCustormer");
			} else {
				$.toast(data.rs);
			}
		},
        error: function(xhr, type) {
            $.hideIndicator();
            $.toast("您的网速不给力啊，再来一次吧");
        }
	});
}
// 修改潜客
function updatePotentialCustoremer() {
	var pc_id_detial = $("#pc_id_detial").val();
	var mem_name = $("#pc_name_detial").val();
	var phone = $("#pc_phone_detial").val();
	var remark = $("#pc_remark_detial").val();
	var imp_level = $("#pc_imp_level_detial").val();
	$.showIndicator();
	$.ajax({
		type : "POST",
		url : "fit-app-action-updatePotentialCustoremer",
		data : {
			gym : gym,
			cust_name : cust_name,
			fk_user_id : pc_id_detial,
			mem_name : mem_name,
			phone : phone,
			remark : remark,
			imp_level : imp_level
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				$.toast("修改成功");
				closePopup(".popup-updatePotentialCustormer");
				showPotentialCustomerDetial(pc_id_detial);
			} else {
				$.toast(data.rs);
			}
		},
        error: function(xhr, type) {
            $.hideIndicator();
            $.toast("您的网速不给力啊，再来一次吧");
        }
	});
}// 潜客的待办事项
function shwoPcCustomersToBeDone(from, divId, fk_user_id) {
	$("#Tab1_content").html("");
	$.showIndicator();
	$.ajax({
				type : "POST",
				url : "fit-app-action-showCustomersToBeDone",
				data : {
					gym : gym,
					cust_name : cust_name,
					fk_user_id : fk_user_id,
					from : from
				},
				dataType : "json",
				success : function(data) {
					$.hideIndicator();
					if (data.rs == "Y") {
						var tpl = document
								.getElementById("pcCustomersToBeDoneTpl").innerHTML;
						content = template(tpl, {
							data : data.data,
							from : from,
							divId : divId,
						});
						$("#" + divId).html(content);
					} else {
						$.toast(data.rs);
					}
				},
		        error: function(xhr, type) {
		            $.hideIndicator();
		            $.toast("您的网速不给力啊，再来一次吧");
		        }
			});
}
// 完成待办事项
function pccustomersToBeDone(fk_user_id, from, divId) {
	var flag = $('#' + fk_user_id).is(':checked');
	if (flag) {
		$.modal({
			title : '提醒',
			text : '确定完成此事项',
			buttons : [ {
				text : '取消'
			}, {
				text : '确定',
				onClick : function() {
					$.showIndicator();
					$.ajax({
						type : "POST",
						url : "fit-app-action-customersToBeDone",
						data : {
							gym : gym,
							cust_name : cust_name,
							id : fk_user_id
						},
						dataType : "json",
						success : function(data) {
							$.hideIndicator();
							if (data.rs == "Y") {
								shwoPcCustomersToBeDone(from, divId);
							} else {
								$.toast(data.rs);
							}
						},
				        error: function(xhr, type) {
				            $.hideIndicator();
				            $.toast("您的网速不给力啊，再来一次吧");
				        }
					});

				}
			}, ]
		})
	}
}
// 解绑会籍
function UnbundledSales() {
	var pc_id = $("#pc_id").val();
	$.modal({
		title : '提醒',
		text : '确定要解绑此会员',
		buttons : [ {
			text : '取消'
		}, {
			text : '确定',
			onClick : function() {
				$.showIndicator();
				$.ajax({
					type : "POST",
					url : "fit-app-action-UnbundledSales",
					data : {
						gym : gym,
						cust_name : cust_name,
						fk_user_id : pc_id
					},
					dataType : "json",
					success : function(data) {
						$.hideIndicator();
						if (data.rs == "Y") {
							$.toast("解绑成功");
							
							closePopup('.popup-PotentialCustomerDetial');
							searchPotentialCustomers("最近维护");
						} else {
							$.toast(data.rs);
						}
					},
			        error: function(xhr, type) {
			            $.hideIndicator();
			            $.toast("您的网速不给力啊，再来一次吧");
			        }
				});
			}
		}, ]
	})
}
// ----------------------------------------潜客池----------------------------------------------
function showPotentialPool(searchValue, start,type) {
	if("more" !=  type){
		$('#potentialPool').html("");
	}
	$.showIndicator();
	$.ajax({
				type : "POST",
				url : "fit-app-action-showPotentialPool",
				data : {
					gym : gym,
					cust_name : cust_name,
					start : $("#pageStart").val(),
					searchValue : searchValue
				},
				dataType : "json",
				success : function(data) {
					$.hideIndicator();
					if (data.rs == "Y") {
						openPopup(".popup-potentialPool");
						if (start == undefined) {
						var tpl = document.getElementById("potentialPoolTpl").innerHTML;
						content = template(tpl, {
							data : data.mems
						});
						$("#potentialPool").html(content);
						} 
						tpl = document.getElementById("potentialPoolTpl2").innerHTML;
						content = template(tpl, {
							data : data.mems,
							start : data.end,
							xx:start
						});
						if (start == undefined) {
							$("#potentialPoolUl").html(content);
						}else{
							$("#poolUIMore").before(content)
						}
                       if(data.mems && data.mems.length<10){
                    	   $("#poolUIMore").hide();
                       }else{
                    	   $("#poolUIMore").show();
                       }
					} else {
						$.toast(data.rs);
					}
				},
		        error: function(xhr, type) {
		            $.hideIndicator();
		            $.toast("您的网速不给力啊，再来一次吧");
		        }
			});
}
// 绑定会籍
function bundledSales(fk_user_id) {
	$.modal({
		title : '确认添加',
		text : '确认添加他(她)为您的潜客吗？',
		buttons : [ {
			text : '取消'
		}, {
			text : '确定',
			onClick : function() {
				$.showIndicator();
				$.ajax({
					type : "POST",
					url : "fit-app-action-bundledSales",
					data : {
						gym : gym,
						cust_name : cust_name,
						// fk_sales_id : '596581f5e8bbca1654e1faab',
						fk_sales_id : id,
						fk_user_id : fk_user_id
					},
					dataType : "json",
					success : function(data) {
						$.hideIndicator();
						if (data.rs == "Y") {
							
							showPotentialPool();
						} else {
							$.toast(data.rs);
						}
					},
			        error: function(xhr, type) {
			            $.hideIndicator();
			            $.toast("您的网速不给力啊，再来一次吧");
			        }
				});

			}
		}, ]
	})
}
// 显示下属员工
function showExMcEmps() {
	searchExEmps();
}

// 查询教练手下员工业绩
function searchExEmps() {
	var date = $("#empReportDate").val() || "";
	var name = $("#empReportName").val() || "";

	var emp_id = id;
	var type = "MC";
	$.showIndicator();
	$.ajax({
		type : "POST",
		url : "fit-app-action-searchEmpsByEx",
		data : {
			gym : gym,
			cust_name : cust_name,
			emp_id : emp_id,
			type : type,
			name : name,
			date : date
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				var tpl = document.getElementById("ex-pt-empsTpl").innerHTML;
				var content = template(tpl, {
					list : data.list
				});
				$("#ex-pt-empsList").html(content);
				openPopup('.popup-ex-pt-emps');
			} else {
				$.toast(data.rs);
			}
		},
        error: function(xhr, type) {
            $.hideIndicator();
            $.toast("您的网速不给力啊，再来一次吧");
        }
	});
}

// 会籍报表
function showMcReport(emp_id, emp_name) {

	var now = new Date().Format("yyyy-MM-dd");
	$("#reportDate").val(now);
	if (!emp_id) {
		emp_id = id;
	}
	$("#reportDate").unbind("change");
	$("#reportDate").change(function() {
		queryMcSalesReport(emp_id, $(this).val(), false);
	});
	if (typeof emp_name != "undefined") {
		$("#mcSalesReportTitle").text("会籍[" + emp_name + "]的个人报表");
	} else {
		$("#mcSalesReportTitle").text("我的报表");
	}
	queryMcSalesReport(emp_id, now, true);
}

function queryMcSalesReport(emp_id, date, init) {
	var curGym = gym;
	$.showIndicator();
	$
			.ajax({
				type : "POST",
				url : "fit-app-action-mcSalesReport",
				data : {
					cust_name : cust_name,
					curGym : curGym,
					emp_id : emp_id,
					date : date
				},
				dataType : "json",
				success : function(data) {
					$.hideIndicator();
					if (data.rs == "Y") {
						var tpl = document.getElementById("mcSalesReportTpl").innerHTML;
						var content = template(tpl, {
							date : date,
							dayInfos : data.dayInfo,
							monthInfos : data.monthInfo,
							allInfos : data.allInfo,
							memInfos : data.memInfo,
							maintainInfos : data.maintainInfo
						});
						$("#mcSalesReportDiv").html(content);

						if (init) {
							openPopup(".popup-mcSalesReport");
						}
					} else {
						$.hideIndicator();
						$.toast(data.rs);
					}
				},
		        error: function(xhr, type) {
		            $.hideIndicator();
		            $.toast("您的网速不给力啊，再来一次吧");
		        }
			});
}

function getSalesNum(data, cardType) {
	var num = 0;
	if (data && data.length > 0) {
		for (var i = 0; i < data.length; i++) {
			var info = data[i];
			if (info.card_type == cardType) {
				num = Number(info.sales_num);
				break;
			}
		}
	}
	return num;
}
function getSalesTimes(data, cardType) {
	var times = 0;
	if (data && data.length > 0) {
		for (var i = 0; i < data.length; i++) {
			var info = data[i];
			if (info.card_type == cardType) {
				times = Number(info.total_times);
				break;
			}
		}
	}
	return times;
}
function getSalesAmt(data, cardType) {
	var amt = 0;
	if (data && data.length > 0) {
		for (var i = 0; i < data.length; i++) {
			var info = data[i];
			if (info.card_type == cardType) {
				amt = Number(info.total_amt || 0);
				break;
			}
		}
	}
	return Math.floor(amt / 100);
}

function getMemNumber(data, type, state) {
	var num = 0;
	if (data && data.length > 0) {
		for (var i = 0; i < data.length; i++) {
			var info = data[i];
			if (info.type == type && info.state == state) {
				num = Number(info.num);
				break;
			}
		}
	}
	return num;
}
function getSalesAmt2(data, type, time) {
	var amt = 0;
	if (data && data.length > 0) {
		for (var i = 0; i < data.length; i++) {
			var info = data[i];
			if (info.time == time && info.type == type) {
				amt = Number(info.total_amt);
				break;
			}
		}
	}
	return Math.floor(amt / 100);
}
//会员转介绍
function salasShowRecommend(mc_name,mc_id){
	if(mc_name !=undefined && mc_name !=""){
		$("#sa_choice_pt_name").val(mc_name);
	}
	if(mc_id !=undefined && mc_id !=""){
		$("#sa_choice_pt_id").val(mc_id);
	}
	//清空input的内容
	$("#zhuan_mem input").val("");
	openPopup(".popup-saAddMemRecommend");
}
//选择教练
function sa_choice_mc(type,search){
	$.showIndicator();
	$.ajax({
        type: 'POST',
        url: 'fit-app-action-choice_emp',
        dataType: 'json',
        data: {
            search: search,
            gym : gym,
            type: "PT",
            cust_name:cust_name
        },
        success: function(data) {
            $.hideIndicator();
            if (data.rs == "Y") {
                var ptListTpl = document.getElementById("emp-public-ListTpl").innerHTML;
                content = template(ptListTpl, {
                    data: data.list,
                });
                $("#emp-public-ListDiv").html(content);
                $("#recommend_reach").val(type);
                openPopup(".popup-public-empList");
                $("#emp-public-ListDiv .select-user ").on("click",
                function() {
                    var mc_id = $(this).attr("data-id");
                    var mc_name = $(this).attr("data-name");
                    $("#sa_choice_pt_name").val(mc_name);
                    $("#sa_choice_pt_id").val(mc_id);
                    closePopup(".popup-public-empList");
                });
            } else {
                $.toast(data.rs);
            }
        },
        error: function(xhr, type) {
            $.hideIndicator();
            $.toast("您的网速不给力啊，再来一次吧");
        }
    })
}
function sa_add_recommend(){
	if(logined!='Y'){
		openPopup(".wxloginPopup");
		return;
	}
	var phoneRegex = /^1[3|4|5|7|8]\d{9}$/;
	var choice_pt_id = $("#sa_choice_pt_id").val();
	var choice_pt_name = $("#sa_choice_pt_name").val();
	var id_card = $("#sa_id_card").val();
	var phone_recommend = $("#sa_phone_recommend").val();
	var mem_name_recommend = $("#sa_mem_name_recommend").val();
	var content_recommed = $("#sa_content_recommed").val();
	var recommend_mem_id = $("#sales_new_mem_choice_mem_id").val();
	var sa_sex_recommend = $("#sa_sex_recommend").val();
	var sa_phone = $("#sa_phone").val();
	if(mem_name_recommend == undefined ||  mem_name_recommend.length <=0){
		$.toast("请输入姓名");
		return ;
	}
	if(recommend_mem_id == undefined ||  recommend_mem_id.length <=0){
		$.toast("请选择推荐人");
		return ;
	}
	if(phone_recommend == undefined || phone_recommend.length ==0){
		$.toast("手机号码不能为空");
		return false;
	}else if(!phoneRegex.test(phone_recommend)) {
		$.toast("请检查电话号码是否正确!");
		return false;
    }
	$.showIndicator();
	$.ajax({
		type : "POST",
		url : "fit-ws-bg-mem-salesAddMemRecommend",
		data : {
			cust_name : cust_name,
			gym : gym,
			sa_phone : sa_phone,
			id : id,
			choice_pt_id : choice_pt_id,
			id_card : id_card,
			phone_recommend : phone_recommend,
			mem_name_recommend : mem_name_recommend,
			recommend_mem_id : recommend_mem_id,
			content_recommed : content_recommed,
			sa_sex_recommend : sa_sex_recommend
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				$.toast("添加成功");
				closePopup(".popup-saAddMemRecommend");
				
			} else {
				$.toast(data.rs);
			}
			
		},
        error: function(xhr, type) {
            $.hideIndicator();
            $.toast("您的网速不给力啊，再来一次吧");
        }
	});
}
function saCancelEmp(type){
	if(type == "mc"){
		
		$("#sa_choice_pt_id").val("");
		$("#sa_choice_pt_name").val("");
	}else{
		$("#new_mem_choice_mem_id").val("");
		$("#sales_new_mem_choice_mem_name").val("");
	}
}

//新入会
function addNewMem(type){
	//清空input的内容
	$("#add_mem_form input").val("");
	var now = new Date().Format("yyyy-MM-dd");
	$("#new_mem_birthday").val(now);
	$("#new_mem_active_time_div").css("display", "none");
	var cancel = "<div class='col-50'><a class='button button-big button-fill button-default' onclick="+"closePopup('"+".popup-addNewMem')"+">取消</a></div>";
	if(type == "MC"){
		$("#new_mem_mc_div").hide();
		$("#new_mem_pt_div").show();
		var sub = "<div class='col-50'><a class='button button-big button-fill custom-btn-primary' onclick="+"is_add_new_mem('MC"+"')"+">提交</a></div>";
		$("#new_mem_btn").html();
	}else if(type == "PT"){
		var sub = "<div class='col-50'><a class='button button-big button-fill custom-btn-primary' onclick="+"is_add_new_mem('PT"+"')"+">提交</a></div>";
		$("#new_mem_mc_div").show();
		$("#new_mem_pt_div").hide();
		
	}
	var fina = (cancel+sub);
	$("#new_mem_btn").html(fina);
	getCardByType('001');
	openPopup(".popup-addNewMem");
}

function getCardByType(type) {
    if (type == "002") {
        $("#giveTitle").html("赠送金额");
        $("#amtDiv").css("display", "block");
        $("#hideen_card_type").val("002");
       
    } else {
        $("#amtDiv").css("display", "none")
    }
    if (type == "003" || type == "006") {
        $("#giveTitle").html("赠送次数");
        $("#timesDiv").css("display", "block")
        $("#hideen_card_type").val("003");
    } else {
        $("#timesDiv").css("display", "none")
    }
    if (type == "001") {
        $("#giveTitle").html("赠送天数");
        $("#hideen_card_type").val("001");
        
    }
    if (type == "006") {
    	$("#hideen_card_type").val("006");
    }
    
    Cardtype = type;
    $.showIndicator();
    $.ajax({
        type: "POST",
        url: "fit-ws-bg-Mem-getCard",
        data: {
            card_type: type,
            gym : gym,
            cust_name : cust_name
        },
        dataType: "json",
        async: false,
        success: function(data) {
        	$.hideIndicator();
            if (data.rs == "Y") {
                var BuyCard_CardTpl = document.getElementById('BuyCard_CardTpl').innerHTML;
                var partialBuyCard_CardTplHtml = template(BuyCard_CardTpl, {
                    list: data.data
                });
                $('#new_mem_show_card').html(partialBuyCard_CardTplHtml);
                getsendCardMsg();
            } else {
                alert(data.rs);
            }
        },
        error: function(xhr, type) {
            $.hideIndicator();
            $.toast("您的网速不给力啊，再来一次吧");
        }
    });
}
//拿到私教卡
function getsendCardMsg() {
	$.showIndicator();
    $.ajax({
        type: "POST",
        url: "fit-ws-bg-Mem-getCard",
        data: {
            card_type: '006',
            gym : gym,
            cust_name : cust_name
        },
        dataType: "json",
        async: false,
        success: function(data) {
        	$.hideIndicator();
            if (data.rs == "Y") {
                var card = data.data;
                var option = "<option value='0'>--请选择--</option>";
                for (var i = 0; i < card.length; i++) {
                    option += "<option value='" + card[i].id + "'>" + card[i].card_name + "</option>";
                }
                $("#new_mem_send_card").html(option);
            } else {
            	alert(data.rs);
            }
        },
        error: function(xhr, type) {
            $.hideIndicator();
            $.toast("您的网速不给力啊，再来一次吧");
        }
    });
}

//勾选卡，显示卡信息
function showCardDetial(id,type) {
	if(type == "Y"){
		//清空input框内容
		//$("#add_mem_div input").val("");
		$.toast("家庭卡请在前台购买");
		return;
	}
	$.showIndicator();
	$.ajax({
		type : "POST",
		url : "fit-ws-bg-Mem-getCardDetial",
		data : {
			card_id : id,
			 gym : gym,
            cust_name : cust_name
		},
		dataType : "json",
		async : false,
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				var price = data.data.fee;
				var days = data.data.days;
				var times = data.data.times;
				var card_name = data.data.card_name;
				var amt = data.data.amt;
				$("#new_mem_price").val(price);
				$("#new_mem_discount_price").val(price);
				$("#new_mem_card_name").val(card_name);
				$("#real_amt").val(price);
				if (days == undefined) {
					days = "永久有效";
				}
				$("#new_mem_day").val(days);
				$("#new_mem_times").val(times);
				$("#new_mem_amt").val(amt);
			} else {
				error(data.rs);
			}

		},
        error: function(xhr, type) {
            $.hideIndicator();
            $.toast("您的网速不给力啊，再来一次吧");
        }
	});
}
//随即获取合同号
function createCardNo(id) {
	$.showIndicator();
    $.ajax({
        type: "POST",
        url: "fit-cashier-createCardNo",
        data: {},
        dataType: "json",
        async: false,
        success: function(data) {
        	$.hideIndicator();
            if (data.rs == "Y") {
                $("#" + id).val(data.code);
            } else {
            	$.alert(data.rs);
            }
        },
        error: function(xhr, type) {
            $.hideIndicator();
            $.toast("您的网速不给力啊，再来一次吧");
        }
    });
}

//选择教练
function add_mem_choice_mc(type,search){
	$.showIndicator();
	$.ajax({
        type: 'POST',
        url: 'fit-app-action-choice_emp',
        dataType: 'json',
        data: {
            search: search,
            gym : gym,
            type: type,
            cust_name:cust_name
        },
        success: function(data) {
            $.hideIndicator();
            if (data.rs == "Y") {
                var ptListTpl = document.getElementById("emp-public-ListTpl").innerHTML;
                content = template(ptListTpl, {
                    data: data.list,
                });
                $("#emp-public-ListDiv").html(content);
                $("#recommend_reach").val(type);
                if(type == "MC"){
                	$("#choice_emp_title").html("选择会籍");
                }else{
                	$("#choice_emp_title").html("选择教练");
                }
                openPopup(".popup-public-empList");
                $("#emp-public-ListDiv .select-user ").on("click",
                function() {
                    var mc_id = $(this).attr("data-id");
                    var mc_name = $(this).attr("data-name");
                    closePopup(".popup-public-empList");
                    if(type == "MC"){
                    	$("#new_mem_choice_mc_id").val(mc_id);
                    	$("#new_mem_choice_mc_name").val(mc_name);
                    }else if(type == "PT"){
                    	$("#new_mem_choice_pt_id").val(mc_id);
                    	$("#new_mem_choice_pt_name").val(mc_name);
                    }
                });
            } else {
                $.toast(data.rs);
            }
        },
        error: function(xhr, type) {
            $.hideIndicator();
            $.toast("您的网速不给力啊，再来一次吧");
        }
    })
}
//关闭选择会员
function closeChoseMemPopup(select){
	var pt_id = $("#add_mem_choice_mem_pt_id").val();
	if(pt_id){
		$(".modal-in").last().show();
		$(".modal-overlay-visible").last().show();
		$("#add_mem_choice_mem_pt_id").val("");
	}
	closePopup(select)
}
//选择会员
function add_mem_choice_mem(cur,search,pt_id){
	$.showIndicator();
	if(!pt_id){
		pt_id = $("#add_mem_choice_mem_pt_id").val() || "";
	}
	if(!search){
		search = $("#mem-public_search").val() || "";
	}
	$.ajax({
		type: 'POST',
		url: 'fit-app-action-choice_mem',
		dataType: 'json',
		data: {
			search: search,
			gym : gym,
			cust_name : cust_name,
			cur : cur,
			type : "",
			pt_id :pt_id
		},
		success: function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				var ptListTpl = document.getElementById("mem-public-ListTpl").innerHTML;
				content = template(ptListTpl, {
					data: data.list,
					state : data.state,
					cur : Number(cur)
				});
				$("#mem-public-ListDiv").html(content);
				openPopup(".popup-public-memList");
				$("#searchMemType").val("add_mem_choice_mem");
				//如果有教练ID
				if(pt_id){
					$("#add_mem_choice_mem_pt_id").val(pt_id);
				}else{
					$("#add_mem_choice_mem_pt_id").val("");
				}
				$("#mem-public-ListDiv .select-user ").on("click",
						function() {
					var mem_id = $(this).attr("data-id");
					var mem_name = $(this).attr("data-name");
					closePopup(".popup-public-memList");
					$("#new_mem_choice_mem_id").val(mem_id);
					$("#new_mem_choice_mem_name").val(mem_name);
					if(pt_id){
						$(".modal-in").last().show();
						$(".modal-overlay-visible").last().show();
						$("#privateOrderMemName").val(mem_name);
						$("#privateOrderMemId").val(mem_id);
						$("#add_mem_choice_mem_pt_id").val("");
					}
				});
			} else {
				$.toast(data.rs);
			}
		},
		error: function(xhr, type) {
			$.hideIndicator();
			$.toast("您的网速不给力啊，再来一次吧");
		}
	})
}
//选择会员
function sales_add_mem_choice_mem(cur,search){
	$.showIndicator();
	$.ajax({
		type: 'POST',
		url: 'fit-app-action-choice_mem',
		dataType: 'json',
		data: {
			search: search,
			gym : gym,
			cust_name : cust_name,
			cur : cur
		},
		success: function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				var ptListTpl = document.getElementById("mem-public-ListTpl").innerHTML;
				content = template(ptListTpl, {
					data: data.list,
					state : data.state,
					cur : Number(cur),
					type : "sales"
				});
				$("#mem-public-ListDiv").html(content);
				openPopup(".popup-public-memList");
				$("#searchMemType").val("sales_add_mem_choice_mem");
				$("#mem-public-ListDiv .select-user ").on("click",
						function() {
					var mem_id = $(this).attr("data-id");
					var mem_name = $(this).attr("data-name");
					closePopup(".popup-public-memList");
					$("#sales_new_mem_choice_mem_id").val(mem_id);
					$("#sales_new_mem_choice_mem_name").val(mem_name);
				});
			} else {
				$.toast(data.rs);
			}
		},
		error: function(xhr, type) {
			$.hideIndicator();
			$.toast("您的网速不给力啊，再来一次吧");
		}
	})
}
function is_add_new_mem(type){
	 $.confirm('确认添加?', function () {
		 add_new_mem(type);
     });
}

function add_new_mem(type){
	var mem_name = $("#new_mem_name").val();
    if (mem_name.length <= 0) {
    	$.toast("会员名字不能为空");
        return;
    }
    var card_type = $("#hideen_card_type").val();
    var birthday = $("#new_mem_birthday").val();
    var id_card = $("#new_mem_card").val();
    var phone = $("#new_mem_phone").val();
    var new_mem_contract_no = $("#new_mem_contract_no").val();
    var new_mem_choice_mc_id = $("#new_mem_choice_mc_id").val();
    if (new_mem_contract_no.length <= 0) {
    	$.toast("合同编号不能为空");
        return;
    }
    
    //选择了私教卡必须选择教练
    if(card_type == "006"){
    	if (new_mem_choice_mc_id.length <= 0) {
    		$.toast("请选择教练");
    		return;
    	}
    }
    var phoneRegex = /^1[3|4|5|7|8]\d{9}$/;
    if ( phone.length <= 0) {
    	$.toast("会员电话不能为空");
        return;
    }else if(!phoneRegex.test(phone)) {
    	$.toast("请检查电话号码是否正确!");
		return false;
    }
    
    $.showIndicator();
	$.ajax({
        type: 'POST',
        url: 'fit-app-action-add_new_mem?id='+id+"&gym="+gym+"&cust_name="+cust_name+"&type="+type,
        dataType: 'json',
        data:$('#add_mem_form').serialize(),
        success: function(data) {
            $.hideIndicator();
            if (data.rs == "Y") {
            	$.toast("添加成功");
            	closePopup(".popup-addNewMem");
            } else {
                $.toast(data.rs);
            }
        },
        error: function(xhr, type) {
            $.hideIndicator();
            $.toast("您的网速不给力啊，再来一次吧");
        }
    })
}

function showActiveTime() {
	var activate_type = $("#new_mem_activate_type").val();
	if ("003" == activate_type) {
		$("#new_mem_active_time_div").css("display", "block");
	} else {
		$("#new_mem_active_time_div").css("display", "none");

	}
}
//查找会员的推荐人
function search_recommend(){
	var phone = $("#new_mem_phone").val();
	if(phone.length !=11){
		return;
	}
	$.showIndicator();
	 $.ajax({
	        type: "POST",
	        url: "fit-cashier-search_recommend",
	        dataType: "json",
	        data : {
	        	phone : phone,
	        	gym : gym,
	        	cust_name : cust_name,
	        	type : "app"
	        },
	        success: function(data) {
	        	$.hideIndicator();
	            if (data.rs == "Y") {
	               var list = data.list;
	               if(list.length > 0){
	            	   
	            	   $("#new_mem_choice_mc_name").val(list[0].mc_name);
	            	   $("#new_mem_choice_pt_name").val(list[0].pt_name);
	            	   $("#new_mem_name").val(list[0].mem_name);
	            	   $("#new_mem_birthday").val(list[0].birthday);
	            	   $("#new_mem_card").val(list[0].id_card);
	            	   var sex = list[0].sex
	            	   if(sex != undefined && sex != "" && sex.length>0){
	            		   $("#new_mem_sex").val(sex);
	            	   }
	            	   var mc_id = list[0].mc_id;
	            	   var pt_id = list[0].pt_names;
	            	   var refer_mem_id = list[0].refer_mem_id;
	            	   if(mc_id !=undefined){
	            		   $("#new_mem_choice_mc_id").val(mc_id);
	            	   }
	            	   if(pt_id !=undefined){
	            		   $("#new_mem_choice_pt_id").val(pt_id);
	            	   }
	            	   if(refer_mem_id !=undefined){
	            		   $("#new_mem_choice_mem_id").val(refer_mem_id);
	            		   $("#new_mem_choice_mem_name").val(list[0].refer_mem_name);
	            	   }
	               }
	                
	            } else {
	                alert(data.rs);
	            }
	            $("#remark").val("");
	        },
	        error: function(xhr, type) {
	            $.hideIndicator();
	            $.toast("您的网速不给力啊，再来一次吧");
	        }
	    });
	
}
//会籍销售订单
function showMcSalesIndentRecord(){
	openPopup(".popup-myIndent");
	$.showIndicator();
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
			id : id
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				//判断是否为员工，员工和会员显示订单内容有区别
				if(data.isEmp == "N"){
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