//会籍主管首页
function showMcManage(open) {
	if(!open){
		open = true;
	}
	if(logined!='Y'){
		openPopup(".wxloginPopup");
		return;
	}
	$.showIndicator();
    $.ajax({
        type: 'POST',
        url: 'fit-ws-app-mcManager',
        dataType: 'json',
        data: {
            cust_name: cust_name,
            gym: gym,
            id: id
        },
        success: function(data) {
            $.hideIndicator();
            if (data.rs == "Y") {
                var checkinNums = data.checkinNums;
                /*$("#mc_today_checkin").html(checkinNums);*/
                $("#mc_newAdd").text(data.newAdd || 0);
                $("#mc_today_salesCard").text(data.salseCards || 0);
                $("#mc_today_wh").html(data.wh);
                $("#M_mc_gym_name_span").html(gymName);
                if(open){
                	openPopup(".popup-manage-Index-mc");
                }
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

//会籍公共池
function showMCPool(searchValue,start) {
	$.showIndicator();
	$.ajax({
				type : "POST",
				url : "fit-app-action-showPotentialPool",
				data : {
					gym : gym,
					cust_name : cust_name,
					start : start,
					searchValue : searchValue
				},
				dataType : "json",
				success : function(data) {
					$.hideIndicator();
					if (data.rs == "Y") {
						if (start == undefined) {
						var tpl = document.getElementById("mc-potentialPoolTpl").innerHTML;
						content = template(tpl, {
							data : data.mems
						});
						$("#mc-potentialPool").html(content);
						}
						var tpl = document.getElementById("mc-potentialPoolTpl2").innerHTML;
						content = template(tpl, {
							data : data.mems,
							start : data.end,
							xx : start
						});
						if (start == undefined) {
						$("#mc-potentialPoolUI").html(content);
						}else{
						$("#mcpoolUIMore").before(content)	
						}
						if(data.mems.length <= 0 || data.mems.length <= 10){
							$("#mcpoolUIMore").removeAttr("onclick");	
							$("#mcpoolUIMore").children().children(".item-text").text("已经没有了");	
						}
						openPopup(".popup-mc-potentialPool");
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
function distributionpotentialMem(search) {
    var str = document.getElementsByName("select_MC");
    var objarray = str.length;
    var ids = "";
    for (i = 0; i < objarray; i++) {
        if (str[i].checked == true) {
            ids += str[i].value + ",";
        }
    }
    if (ids.length == 0) {
        $.toast("请选择一个潜客");
        return;
    }
    $.showIndicator();
    $.ajax({
        type: 'POST',
        url: 'fit-app-action-searchEmpsByEx',
        dataType: 'json',
        data: {
            gym: gym,
            cust_name: cust_name,
            emp_id: id,
            search: search,
            type: "MC"
        },
        success: function(data) {
            $.hideIndicator();
            if (data.rs == "Y") {
                var ptListTpl = document.getElementById("mc-public-ListTpl").innerHTML;
                content = template(ptListTpl, {
                    data: data.list,
                });
                $("#mc-public-ListDiv").html(content);
                openPopup(".popup-public-mcList");
                $("#mc-public-ListDiv .select-user ").on("click",
                function() {
                    var mc_id = $(this).attr("data-id");
                    var mc_name = $(this).attr("data-name");
                    closePopup(".popup-public-mcList");
                    doDistributionpotentialMem(ids, mc_id, mc_name);
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
function doDistributionpotentialMem(ids, mc_id, mc_name) {
    $.modal({
        title: '提醒',
        text: '确定要把这些潜客分配给【' + mc_name + '】会籍',
        buttons: [{
            text: '取消'
        },
        {
            text: '确定',
            onClick: function() {
                $.showIndicator();
                $.ajax({
                    type: "POST",
                    url: "fit-app-action-doDistributionpotentialMem",
                    data: {
                        gym: gym,
                        cust_name: cust_name,
                        ids: ids,
                        mc_id: mc_id,
                        type:"MC"
                    },
                    dataType: "json",
                    success: function(data) {
                        $.hideIndicator();
                        if (data.rs == "Y") {
                            showMCPool();
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
        }]
    })
}
//今日售额
function todayMoney() {
    $.showIndicator();
    $.ajax({
        type: "POST",
        url: "fit-app-action-todayGetMoney",
        data: {
            gym: gym,
            cust_name: cust_name,
            id: id
        },
        dataType: "json",
        success: function(data) {
            $.hideIndicator();
            if (data.rs == "Y") {
                var tpl = document.getElementById("mcTodayPriceTpl").innerHTML;
                content = template(tpl, {
                    list: data.list,
                    allPrice: data.allPrice
                });
                $("#mcPriceUl").html(content);
                openPopup(".popup-mcTodayPrice");
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

//今日售卡
function todaySaleCards(search) {
    $.showIndicator();
    $.ajax({
        type: "POST",
        url: "fit-app-action-todaySaleCards",
        data: {
            gym: gym,
            cust_name: cust_name,
            emp_id: id,
            search: search || ""
        },
        dataType: "json",
        success: function(data) {
            $.hideIndicator();
            if (data.rs == "Y") {
                var tpl = document.getElementById("todaySalseCardTpl").innerHTML;
                content = template(tpl, {
                    list: data.list
                });
                $("#todaySalseCardDiv").html(content);
                openPopup(".popup-todaySalseCard");
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
//今日新增
function todayAdd() {
    openPopup(".popup-mc-todayAdd");
    todayAdd_newAddMem();
}

//本日新增会员
function todayAdd_newAddMem() {
    $.showIndicator();
    $.ajax({
        type: "POST",
        url: "fit-app-action-todayAddNewAddMem",
        data: {
            gym: gym,
            cust_name: cust_name,
            id: id
        },
        dataType: "json",
        success: function(data) {
            $.hideIndicator();
            if (data.rs == "Y") {
                var tpl = document.getElementById("todayAdd_newAddMemTpl").innerHTML;
                content = template(tpl, {
                    data: data.data
                });
                $("#todayAdd_newAddMem").html(content);
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
//本日新增潜客
function todayAdd_newAddPotentialCustomer() {
	 $.showIndicator();
	    $.ajax({
	        type: "POST",
	        url: "fit-app-action-todayAddPotentialCustomer",
	        data: {
	            gym: gym,
	            cust_name: cust_name,
	            id: id
	        },
	        dataType: "json",
	        success: function(data) {
	            $.hideIndicator();
	            if (data.rs == "Y") {
	                var tpl = document.getElementById("todayAdd_PotentialCustomersTpl").innerHTML;
	                content = template(tpl, {
	                    data: data.data
	                });
	                $("#todayAdd-newAddPotentialCustomer").html(content);
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
//查询会籍主管下的会籍
//查询会籍管理的会员
function showMcMemsById(fk_user_id,type,search){
	$.showIndicator();
		$.ajax({
			type : "POST",
			url : "fit-app-action-searchMemsByEmp",
			data : {
				gym : gym,
				cust_name : cust_name,
				emp_id : fk_user_id,
				type : type,
				search :search
			},
			dataType : "json",
			success : function(data) {
				$.hideIndicator();
				if (data.rs == "Y") {
					var tpl = document.getElementById("mc-showMcMemsByIdTpl").innerHTML;
					var content = template(tpl, {
						data : data.mems
					});
					$("#showMcMemsById_mcId").val(fk_user_id);
					$("#showMcMemsById_type").val(type);
					$("#mc-showMcMemsById").html(content);
					openPopup('.popup-mc-showMcMemsById');
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
function distributionMCMems(){
	var type = $("#showMcMemsById_type").val();
	  
	   var str = document.getElementsByName("select_mems");
	    var objarray = str.length;
	    var ids = "";
	    for (i = 0; i < objarray; i++) {
	        if (str[i].checked == true) {
	            ids += str[i].value + ",";
	        }
	    }
	    $.showIndicator();
	    $.ajax({
	        type: 'POST',
	        url: 'fit-app-action-searchEmpsByEx',
	        dataType: 'json',
	        data: {
	            gym: gym,
	            cust_name: cust_name,
	            emp_id: id,
	            type: type
	        },
	        success: function(data) {
	            $.hideIndicator();
	            if (data.rs == "Y") {
	                var ptListTpl = document.getElementById("mc-public-ListTpl").innerHTML;
	                content = template(ptListTpl, {
	                    data: data.list,
	                });
	                $("#mc-public-ListDiv").html(content);
	                openPopup(".popup-public-mcList");
	                $("#mc-public-ListDiv .select-user ").on("click",
	                function() {
	                    var mc_id = $(this).attr("data-id");
	                    var mc_name = $(this).attr("data-name");
	                    closePopup(".popup-public-mcList");
	                    doDistributionMems(ids, mc_id, mc_name,type);
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
function doDistributionMems(ids, mc_id, mc_name,type) {
	var  text =  "确定要把这些用户分配给【" + mc_name + "】";
	   if (ids.length == 0) {
	        text ="确定要把全部用户分配给【" + mc_name + "】";
	    }
    $.modal({
        title: '提醒',
        text: text,
        buttons: [{
            text: '取消'
        },
        {
            text: '确定',
            onClick: function() {
                $.showIndicator();
                $.ajax({
                    type: "POST",
                    url: "fit-app-action-doDistributionpotentialMem",
                    data: {
                        gym: gym,
                        cust_name: cust_name,
                        ids: ids,
                        b_mc_id : $("#showMcMemsById_mcId").val(),
                        mc_id: mc_id,
                        type : type
                    },
                    dataType: "json",
                    success: function(data) {
                        $.hideIndicator();
                        if (data.rs == "Y") {
                        	closePopup('.popup-mc-showMcMemsById');
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
        }]
    })
}
function UnbundledSalesbyMCMems(){
	var type = $("#showMcMemsById_type").val();
	var  fk_mc_id = $("#showMcMemsById_mcId").val();
	
	var str = document.getElementsByName("select_mems");
    var objarray = str.length;
    var ids = "";
    for (i = 0; i < objarray; i++) {
        if (str[i].checked == true) {
            ids += str[i].value + ",";
        }
    }
    var  text =  "确定要解绑所有会员";
	 if (ids.length > 0) {
	        text ="确定要解绑会员";
	 }
	 
	$.modal({
		title : '提醒',
		text : text,
		buttons : [ {
			text : '取消'
		}, {
			text : '确定',
			onClick : function() {
				$.showIndicator();
				$.ajax({
					type : "POST",
					url : "fit-app-action-UnbundledSalesALL",
					data : {
						gym : gym,
						cust_name : cust_name,
						fk_user_id : fk_mc_id,
						type : type,
						ids : ids
					},
					dataType : "json",
					success : function(data) {
						$.hideIndicator();
						if (data.rs == "Y") {
							$.toast("解绑成功");
							closePopup('.popup-mc-showMcMemsById');
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