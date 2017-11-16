function showManage(open){
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
        url: 'fit-ws-app-ptmanange-isManage',
        dataType: 'json',
        data:{
        	cust_name : cust_name,
        	gym : gym,
        	id : id
        },
        success: function(data) {
        	$.hideIndicator();
            if (data.rs == "Y") {
            	var checkinNums = data.checkinNums;
        		$("#today_checkin").html(checkinNums);
        		$("#today_private_class_sales_times").text(data.privateClassSalseTimes || 0);
        		$("#ptM_gym_name_span").html(gymName);
        		$("#wh").text(data.wh || 0);
        		if(open){
        			openPopup(".popup-manage-Index");
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
//教练管理
function manageCoach(search){
	var emp_id = id;
	var type = "PT";
	$.showIndicator();
	$.ajax({
        type: 'POST',
        //url: 'fit-ws-app-ptmanange-showCoach',
        url: 'fit-app-action-searchEmpsByEx',
        dataType: 'json',
        data:{
        /*	id : id,
        	search : search*/
        	gym : gym,
			cust_name : cust_name,
			emp_id : emp_id,
			type : type,
			name : search || ""
        },
        success: function(data) {
            $.hideIndicator();
            if (data.rs == "Y") {
            		var ptListTpl = document.getElementById("ptListTpl").innerHTML;
				content = template(ptListTpl, {
					data : data.list,
				});
				$("#ptListDiv").html(content);
				openPopup(".popup-ptList");
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

//显示教练消课记录
function empsPtSalesRecord(pt_id,pt_name){
	var now = new Date().Format("yyyy-MM-dd");
	$("#empsPtPrivateSalesDay").val(now);
	$("#empsPtPrivateSalesDay").unbind("change");
	$("#empsPtPrivateSalesDay").change(function(){
		queryEmpsPtPrivateClassSales(pt_id,"day",$(this).val(),false);
	});
	//$("#empsPtPrivateSalesMonthPicker").change();
	$("#mepsPtHeaderTitle").text(pt_name+"的私教销售记录");
	queryEmpsPtPrivateClassSales(pt_id,"day",$("#empsPtPrivateSalesDay").val(),true);
}

//查询私教销售
function queryEmpsPtPrivateClassSales(emp_id,condition,conditionData,init){
	$.showIndicator();
	$.ajax({
		type : "POST",
		url : "fit-app-action-empSalesRecord",
		data : {
			gym : gym,
			cust_name : cust_name,
			emp_id : emp_id,
			condition :condition,
			conditionData: conditionData,
			card_type:'006',
			type:"PT"
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				var tpl = document.getElementById("privateSalesRecordTpl").innerHTML;
				var content = template(tpl, {
					list : data.list
				});
				$("#empsPtPrivateSalesUl").html(content);
				if(init){
					openPopup(".popup-empsPtPrivateSalesRecord");
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

//显示教练详情
function shwoPtDetial(fk_emp_id,name){
	 $.modal({
		  title:name,
		  extraClass: "custom-modal",
	      verticalButtons: true,
	      buttons: [
	        {
	          text: '团操课管理',
	          onClick: function() {
	        	  show_pts_lesson(id);
	          }
	        },
	        {
	        	text: '教练资料',
	        	onClick: function() {
	        		shwoEmpDetial(fk_emp_id);
	        	}
	        },
	        {
	        	text: '消课记录',
	        	onClick: function() {
	        		reduceClassInit(fk_emp_id,name);
	        	}
	        },
	        {
	        	text: '私教销售记录',
	        	onClick: function() {
	        		empsPtSalesRecord(fk_emp_id,name);
	        	}
	        },
	        {
	        	text: '学员维护',
	        	onClick: function() {
	        		showMemListByPT('最近维护',fk_emp_id,'false');
	        	}
	        },
	        {
	        	text: '潜在学员维护',
	        	onClick: function() {
	        		showpotentialMem(fk_emp_id,'false');
	        	}
	        },
	        {
	        	text: '业绩报表',
	        	onClick: function() {
	        		showPtSalseReport(fk_emp_id,name);
	        	}
	        },{
	        	text: '所有会员',
	        	onClick: function() {
	        		showMcMemsById(fk_emp_id,"PT");
	        	}
	        },{
	        	text: '私教预约',
	        	onClick: function() {
	        		memPrivateOrder(fk_emp_id,name,true);
	        	}
	        },
	        {
	            text: '关闭',
	            bold: true
	          },
	        
	      ]
	    })
}
//今日入场
function todayCheckin(search){
	$.showIndicator();
	$.ajax({
        type: 'POST',
        url: 'fit-ws-app-ptmanange-todayCheckin',
        dataType: 'json',
        data:{
        	cust_name:cust_name,
        	gym : gym,
        	search : search
        },
        success: function(data) {
            $.hideIndicator();
            if (data.rs == "Y") {
            	var checkinMemTpl = document.getElementById("checkinMemTpl").innerHTML;
				content = template(checkinMemTpl, {
					data : data.list,
				});
				$("#checkinMemPool").html(content);
				openPopup(".popup-checkinMem");
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
//今日售课
function todaySalesPrivateClass(search){
//	var emp_id = "596581f5e8bbca1654e1faab";
	$.showIndicator();
	$.ajax({
				type : "POST",
				url : "fit-app-action-todayPrivateClassSales",
				data : {
					gym : gym,
					cust_name : cust_name,
					emp_id : id,
					search:search || ""
				},
				dataType : "json",
				success : function(data) {
					$.hideIndicator();
					if (data.rs == "Y") {
						var tpl = document
								.getElementById("todayPrivateClassSalesTpl").innerHTML;
						content = template(tpl, {
							list : data.list
						});
						$("#todayPrivateClassSalesDiv").html(content);
						openPopup(".popup-todayPrivateClassSales");
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
//潜在会员
 function showMemPoolbyPtManage(searchValue) {
	$.showIndicator();
	$.ajax({
				type : "POST",
				url : "fit-app-action-showPotentialMemPool",
				data : {
					gym : gym,
					cust_name : cust_name,
					searchValue : searchValue
				},
				dataType : "json",
				success : function(data) {
					$.hideIndicator();
					if (data.rs == "Y") {
						var tpl = document
								.getElementById("potentialMemPoolTplbyPTManage").innerHTML;
						content = template(tpl, {
							data : data.mems
						});
						$("#potentialMemPoolbyPTManage").html(content);
						openPopup(".popup-potentialMemPoolbyPTManage");
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
//分配会员
 function distributionMem(search) {
     	 var str=document.getElementsByName("select_pt");
     	 var objarray=str.length;
     	 var ids="";
     	 for (i=0;i<objarray;i++){
     	  if(str[i].checked == true) {
     		 ids+=str[i].value+",";
     	   }
     	 }
     	 if(ids.length == 0){
     		$.toast("请选择一个潜客");
 			return;
 	}
     $.showIndicator();
     $.ajax({
         type: 'POST',
         url: 'fit-ws-app-ptmanange-showCoach',
         dataType: 'json',
         data: {
             id: id,
             search: search,
             cust_name :cust_name,
             gym:gym
         },
         success: function(data) {
             $.hideIndicator();
             if (data.rs == "Y") {
                 var ptListTpl = document.getElementById("pt-public-ListTpl").innerHTML;
                 content = template(ptListTpl, {
                     data: data.list,
                 });
                 $("#pt-public-ListDiv").html(content);
                 openPopup(".popup-public-ptList");
                 $("#pt-public-ListDiv .select-user ").on("click",function() {
                     var pt_id = $(this).attr("data-id");
                     var pt_name = $(this).attr("data-name");
                     closePopup(".popup-public-ptList");
                     doDistributionMem(ids,pt_id,pt_name);
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
 function doDistributionMem(ids,pt_id,pt_name){
			$.modal({
				title : '提醒',
				text : '确定要把这些会员分配给【'+pt_name+'】教练',
				buttons : [ {
					text : '取消'
				}, {
					text : '确定',
					onClick : function() {
						$.showIndicator();
						$.ajax({
							type : "POST",
							url : "fit-app-action-doDistributionMem",
							data : {
								gym : gym,
								cust_name : cust_name,
								ids : ids,
								pt_id : pt_id
							},
							dataType : "json",
							success : function(data) {
								$.hideIndicator();
								if (data.rs == "Y") {
									showMemPoolbyPtManage();
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
 
//管理和员工的业绩    
function showExAndEmpsRecord(emp_id,emp_name,role){
	var now = new Date().Format("yyyy-MM-dd");
	$("#exAndEmpsRecordDay").val(now);
	if(!emp_id){
		//如果不是选择的员工就是自己啦
		emp_id = id;
	}
	$("#exAndEmpsRecordDay").unbind("change");
	$("#exAndEmpsRecordDay").change(function(){
		queryExAndEmpsRecord(emp_id,$(this).val(),role,false);
	});
	if(emp_name){
		$("#exAndEmpsRecordTitile").text(emp_name+"和员工报表");
	}else{
		$("#exAndEmpsRecordTitile").text("团队业绩");
	}
	if(role == 'boss'){
		$("#exAndEmpsRecordTitile").text(gymName+"销售统计");
	}
	queryExAndEmpsRecord(emp_id,now,role,true);
} 
 
function queryExAndEmpsRecord(emp_id,date,role,init){
	var curGym = gym;
	var boss = role;
	if(role != 'mc' && role!='pt' && role !='boss'){
		$.alert("抱歉,您不能使用此功能!");
		return;
	}
	
	$.showIndicator();
	$.ajax({
		type : "POST",
		url : "fit-app-action-exAndEmpsRecord",
		data : {
			cust_name : cust_name,
			curGym : curGym,
			emp_id : emp_id,
			date : date,
			boss:boss,
			type:role
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				var tpl = document.getElementById("exAndEmpsRecordTpl").innerHTML;
				var content = template(tpl, {
					role:role,
					date:date,
					dayInfos:data.dayInfo,
					monthInfos:data.monthInfo,
					allInfos:data.allInfo,
					memInfos:data.memInfo,
					maintainInfos:data.maintainInfo,
					weekInfos:data.weekInfo,
					otherInfos:data.otherInfo,
					leaveInfos:data.leaveInfo,
					goodsInfos:data.goodsInfo,
					reduceClass:data.reduceClass,
					reduceGClass:data.reduceGClass,
					reduceTimesCard:data.reduceTimesCard,
					memInfos:data.memInfo,
					maintainInfos:data.maintainInfo,
					checkinInfos:data.checkinInfo,
					fitInfos:data.fitInfo,
					
				});
				$("#exAndEmpsRecordDiv").html(content);
				
				if(init){
					openPopup(".popup-exAndEmpsRecord");
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

function queryRankReporyByType(type){
	$("#tabClickFlag").val(type);
	querySalesRankReport(false);
}

//销售排行
 function showSalesRank(){
	 $("#tabClickFlag").val("mc");
	 $("#salesRankReport a").removeClass("active");
	 $("#mcSalesRankReport").addClass("active");
	//初始化日期
		var months = initMonths();
		$("#salesRankReportMonth").picker({
							toolbarTemplate : '<header class="bar bar-nav">\
			  <button class="button button-link pull-right close-picker">确定</button>\
			  <h1 class="title">请选择月份</h1>\
			  </header>',
							cols : [ {
								textAlign : 'center',
								values : months
							} ],
							onClose : function() {
								var m = $("#salesRankReportMonth").val();
									initWeeks();
								querySalesRankReport(false);
								//queryMcSalesRecord(emp_id, "month", $("#mcSalesMonthPicker").val(), false);
							}
						});
		$("#salesRankReportMonth").val(new Date().Format("yyyy-MM"));
		$("#salesRankReportMonth").picker("setValue",[ new Date().Format("yyyy-MM") ]);
		
		initWeeks();	
		querySalesRankReport(true);
		
 }
 
 function querySalesRankReport(showPopup){
	 var type = $("#tabClickFlag").val();
	 var month = $("#salesRankReportMonth").val();
	 var week = $("#salesRankReportWeek").val();
	 empsSalesRankReport(type,month,week,showPopup);
 }
 
 function empsSalesRankReport(type,month,week,showPopup){
	 var url = "fit-app-action-salesRankReport";
	 if(type == "class"){
		 url = "fit-app-action-reduceClassRankReport";
	 }
	 $.showIndicator();
		$.ajax({
			type : "POST",
			url : url,
			data : {
				cust_name : cust_name,
				gym : gym ,
				role : type,
				month : month,
				week :week || ""
			},
			dataType : "json",
			success : function(data) {
				$.hideIndicator();
				if (data.rs == "Y") {
					var tpl = document.getElementById("salesRankReportTpl").innerHTML;
					var content = template(tpl, {
						list:data.list
					});
					$("#salesRankReportDiv").html(content);
					if(showPopup){
						openPopup(".popup-salesRankReport");
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
 
//月选择
 function changeShowSalesReport(){
 	//var flag = $(t).parent().is(":hidden");
 	var flag = $("#changeShowSalesReport").css("display");
 	var xx = $("#changeShowSalesReport");
 	if(flag == "block"){
 		$(xx).hide();
 		$(xx).next().show();
 		$(xx).next().next().show();
 		//设置周
 		initWeeks($("#salesRankReportMonth").val());	
 	}else{
 		$(xx).show();
 		$(xx).next().hide();
 		$(xx).next().next().hide();
 		$("#salesRankReportWeek").val("");
 		querySalesRankReport(false);
 	}
 }
 function initMonths(){
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
		return month;
 }
 
 function initWeeks(){
	$("#salesRankReportWeek").val("");
	 
	var month = $("#salesRankReportMonth").val()
	var html = "<option selected value=''>选择周</option>";
	if(month == '所有月份'){
		
	}else{
		var weeks = getWeeksOfMonth(month);
		for(var i =0;i<weeks.length;i++){
			html+="<option>"+weeks[i]+"</option>"
		}
		
	}
	
	$("#salesRankReportWeek").html(html);	
	
	//$("#salesRankReportWeek").val(weeks[0]);
	
	/*$("#salesRankReportWeek").click(function(){
		$("#salesRankReportWeek").picker(
				{
					toolbarTemplate : '<header class="bar bar-nav">\
						<button class="button button-link pull-right close-picker">确定</button>\
						<h1 class="title">请选择周</h1>\
						</header>',
						cols : [ {
							textAlign : 'center',
							values : weeks
						} ],
						onClose : function() {
							querySalesRankReport(false);
						}
				}); 
	});*/
		
 }
 
 function getWeeksOfMonth(month){
	var weeks = [];
	var first_day = month + "-01 00:00:00";
 	var thatDay = new Date(first_day);
 	//debugger;
 	//var days = new Date(thatDay.getFullYear(),thatDay.getMonth()+1,0).getDate();
 	
 	while(thatDay.Format("MM") == month.substring(5,7)){
 		var day = thatDay.getDay();
 		var nowTime = thatDay.getTime();
 		var oneDayLong = 24*60*60*1000;
 		var MondayTime = nowTime - (day-1)*oneDayLong; 
 		var SundayTime =  nowTime + (7-day)*oneDayLong;
 		
 		var monday = new Date(MondayTime).Format("MM-dd");
 		var sunday = new Date(SundayTime).Format("MM-dd");
 		
 		weeks.push(monday +"~" + sunday);
 		
 		thatDay = new Date(SundayTime);
 	}
 	return weeks;
 }
 
 
 
 
 
 