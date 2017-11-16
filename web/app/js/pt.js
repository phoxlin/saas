function showPts(open){
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
        url: 'fit-ws-app-pt-showInit-data',
        dataType: 'json',
        data:{
        	cust_name : cust_name,
        	gym : gym,
        	emp_id :id
        },
        success: function(data) {
            $.hideIndicator();
            if (data.rs == "Y") {
            	var count1 = data.today_reduce_class;
            	$("#today_reduce_class").text(count1);
            	var count2 = data.today_sales_private_class;
            	$("#today_sales_private_class").text(count2);
            	var mSize = data.mSize;
            	$("#today_sales_wh").text(mSize);
            	$("#pt_gym_name_span").html(gymName);
            	if(open){
            		openPopup(".popup-pt-Index");
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
//显示该教练的课程
function show_pts_lesson(id){
	$(".plans-tab-pt .day-btn").removeClass("active");
	$("#pt_time_one").addClass("active");
	 openPopup(".popop-ptLessonPlan");
	    var now = new Date().Format("yyyy-MM-dd");
	    getDayLessonPt(now,id);
	
}
//根据日期查询课程表
function getDayLessonPt(day,id){
	var type = "manage";
	var flag = false;
	if(id==undefined || id == ""){
		var id = user.id;
		type="";
		flag = true;
	}
	$.showIndicator();
	$.ajax({
        type: 'POST',
        url: 'fit-ws-app-pt-showPtLesson',
        dataType: 'json',
        data:{
        	cust_name : cust_name,
        	gym : gym,
        	day : day,
        	id : id,
        	type : type
        },
        success: function(data) {
            $.hideIndicator();
            if (data.rs == "Y") {
                var ptLessonTpl = document.getElementById("ptLessonTpl").innerHTML;
                content = template(ptLessonTpl, {
                    list: data.list,
                });
                $("#ptLessonTplUl").html(content);
                openPopup(".popop-ptLessonPlan");
                
                if(flag){
                	$("#pt_type").val("");
                }else{
                	$("#pt_type").val(id);
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
//显示约课详情
function showPtLessonDeatil(id,type){
	
	
	$.showIndicator();
	$.ajax({
        type: 'POST',
        url: 'fit-ws-app-showLessonDetail',
        dataType: 'json',
        data:{
        	cust_name : cust_name,
        	gym : gym,
        	id : id,
        	type : type
        },
        success: function(data) {
            $.hideIndicator();
            if (data.rs == "Y") {
                var ptLessonDetailTpl = document.getElementById("ptLessonDetailTpl").innerHTML;
                var ptLessonDetailBtnTpl = document.getElementById("ptLessonDetailBtnTpl").innerHTML;
                content = template(ptLessonDetailTpl, {
                    list: data.list,
                    mem_list : data.mem_list
                });
                contentBtn = template(ptLessonDetailBtnTpl, {
                	list: data.list,
                    type : type
                });
                $("#ptLessonDetailDiv").html(content);
                $("#ptButtonOrder").html(contentBtn);
                openPopup(".popop-ptLessonPlanDetail");
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
	

//模拟消次
function reduce_class(str){
	//var j = JSON.parse(str);
	var info = str.split(",");
	var buy_id = info[1];//buy_id
	var mem_gym = info[2];//mem_gym
	var card_type = info[3];//card_type
	
	if(card_type != "006"){
		$.toast("私教只能给私教卡消课哦");
		return;
	}
	
	var emp_id = id;
	
	var emp_gym = gym;
	$.showIndicator();
	$.ajax({
		url:"fit-app-action-pt-reduce-class-query",
		type:"POST",
		dataType:"json",
		data:{
			mem_gym:mem_gym,
			buy_id:buy_id,
			cust_name:cust_name,
			emp_gym:emp_gym,
			emp_id:emp_id
		},
		success:function(data){
			$.hideIndicator();
			if(data.rs == "Y"){
				var state = data.state;
				if(state == "start"){
					 $.confirm('确认下课吗?',
						function () {
							confirmPrivateRecord("end",data.record_id,cust_name,mem_gym,buy_id);
					 	}
					 );
				}else{
					 $.confirm('开始上课?',
						function () {
							confirmPrivateRecord("start","",cust_name,mem_gym,buy_id);
					 	}
					 );
				}
			}else{
				$.toast(data.rs);
			}
		},
        error: function(xhr, type) {
            $.hideIndicator();
            $.toast("您的网速不给力啊，再来一次吧");
        }
	});
}

//更改上课状态
function confirmPrivateRecord(type,record_id,cust_name,mem_gym,buy_id){
	var emp_id = id ;
	$.showIndicator();
	$.ajax({
		url:"fit-app-action-pt-reduce-class",
		type:"POST",
		dataType:"json",
		data:{
			cust_name:cust_name,
			mem_gym:mem_gym,
			empGym:gym,
			emp_id:emp_id,
			type:type,
			private_record_id:record_id || "",
			buy_id:buy_id
		},
		success:function(data){
			$.hideIndicator();
			if(data.rs == "Y"){
				if(type =="end"){
					if(data.wait == "Y"){
						$.alert("已发送您的下课确认消息,请耐心等待");
					}else{
						$.alert("下课啦");
					}
				}else if(type="start"){
					$.alert("可以开始上课了");
				}else if(type="delete"){
					$.alert("取消成功");//无此功能
				}
				
			}else{
				$.toast(data.rs);
			}
		},
        error: function(xhr, type) {
            $.hideIndicator();
            $.toast("您的网速不给力啊，再来一次吧");
        }
	});
}
//团操课上课
function attend_class(id,plan_id,state){
	$.showIndicator();
	$.ajax({
        type: 'POST',
        url: 'fit-ws-app-pt-attendClass',
        dataType: 'json',
        data:{
        	cust_name : cust_name,
        	gym : gym,
        	id : id,
        	state : state,
        	plan_id : plan_id
        },
        success: function(data) {
            $.hideIndicator();
            if (data.rs == "Y") {
               var mem_list = data.mem_list;
               if(mem_list != undefined){
            	   //提示私教卡次数不足的会员
            	  for(var i = 0;i < mem_list.length;i++){
            		  mem_list[i].mem_name
            		  $.alert(mem_list[i].mem_name+"私教卡剩余次数不足");
            	  }
               }
               if(state == "001"){
            	   $.toast("开始上课");
            	   showPtLessonDeatil(id)
               }else{
            	   $.toast("下课成功");
            	   showPtLessonDeatil(id)
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

function showReduceClassRecord(){
	//当前员工
	var emp_id = id;
	reduceClassInit(emp_id);
}

//按会员名称查询
function showReduceClassRecordByName(emp_id){
	var mem_name = $("#reduceClassMemName").val() || "";
	queryReduceClassRecord("end","mem_name",mem_name,"",emp_id);
}

//弹出popup时
function reduceClassInit(emp_id,emp_name){
	
	var tpl = document.getElementById("popup-reduceClassRecordTpl").innerHTML;
	var html = template(tpl,{emp_id:emp_id,emp_name:emp_name});
	$("#popup-reduceClassRecord").html(html);
	
	var typePlan = $("#type_plan").val();
	var now = new Date();
	var m = now.getMonth();
	var y = now.getFullYear();
	var month = [];
	month.push("所有月份");
	for(var i=0;i<2;i++){
		if(i == 0){
			for(var j=m;j>=0;j--){
				var xx = new Date(y,j,1).Format("yyyy-MM");
				month.push(xx);
			}
		}else{
			y--;
			for(var j=11;j>=0;j--){
				var xx = new Date(y,j,1).Format("yyyy-MM");
				month.push(xx);
			}
		}
	}
	
	$("#monthPicker").picker({
		  value: new Date().Format("yyyy-MM-dd"),
		  toolbarTemplate: '<header class="bar bar-nav">\
			  <button class="button button-link pull-right close-picker">确定</button>\
			  <h1 class="title">请选择月份</h1>\
			  </header>',
			  cols: [
			    {
			      textAlign: 'center',
			      values: month
			    }
			  ],onClose:function(v){
				  queryReduceClassRecord("end","month",$("#monthPicker").val(),$("#type_plan").val(),emp_id);
			  }
			});
	
	$("#monthPicker").val(new Date().Format("yyyy-MM"));
	$.showIndicator();
	$.ajax({
        type: 'POST',
        url: 'fit-ws-app-pt-getReduceClassRecord',
        dataType: 'json',
        data:{
        	cust_name : cust_name,
        	emp_gym : gym,
        	emp_id : emp_id,
        	type: "end",
        	condition : "month",
			conditionData : $("#monthPicker").val(),
			init : "Y",
			typePlan : typePlan
        },
        success: function(data) {
        	$.hideIndicator();
        	if(data.rs == "Y"){
            		var tpl = document.getElementById("reduceClassListTpl").innerHTML;
            		var html = template(tpl,{list:data.list});
            		$("#reduceClassRecordByMonth").html(html);
            		if(data.list && data.list.length >0){
            			$("#reduceClassTimes").text(data.list.length);
            		}else{
            			$("#reduceClassTimes").text(0);
            		}
            		//绑定按卡种查询
            		if(data.cards){
            			var cs = [];
            			var cv = [];
            			cs.push("所有");
            			cv.push("all");
            			$("#cardSelect").html('<option value="all">所有</option>');
            			for(var i=0;i<data.cards.length;i++){
            				cs.push(data.cards[i].card_name);
            				cv.push(data.cards[i].id);
            				var t = "<option value='"+data.cards[i].id+"'>"+data.cards[i].card_name+"</option>";
            				$("#cardSelect").append(t);
            			}
            			
            			$("#cardPicker").picker({
            				  toolbarTemplate: '<header class="bar bar-nav">\
            					  <button class="button button-link pull-right close-picker">确定</button>\
            					  <h1 class="title">请选择卡种</h1>\
            					  </header>',
            					  cols: [
            					    {
            					      textAlign: 'center',
            					      values: cs
            					    }
            					  ],formatValue: function (picker, value, displayValue){
            						  return "heh";
            					  },
            					  onClose:function(v){
            						  queryReduceClassRecord("end","card",$("#cardPicker").val(),"",emp_id);
            					  }
            			});
            			$("#cardPicker").val("all");
            		}
            		openPopup(".popup-reduceClassRecord");
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

function queryReduceClassRecord(type,condition,conditionData,typePlan,emp_id){
	//假设这是员工
	
	if("month" == condition){
		conditionData = $("#monthPicker").val();
	}
	$.showIndicator();
	$.ajax({
        type: 'POST',
        url: 'fit-ws-app-pt-getReduceClassRecord',
        dataType: 'json',
        data:{
        	cust_name : cust_name,
        	emp_gym : gym,
        	emp_id : emp_id,
        	type: type,
        	condition : condition,
			conditionData : conditionData,
			typePlan : typePlan
        },
        success: function(data) {
            $.hideIndicator();
            if (data.rs == "Y") {
            	if("month" == condition){
            		var tpl = document.getElementById("reduceClassListTpl").innerHTML;
            		var html = template(tpl,{list:data.list});
            		$("#reduceClassRecordByMonth").html(html);
            		openPopup(".pupup-reduceClassRecord");
            		if(data.list && data.list.length>0){
            			$("#reduceClassTimes").text(data.list.length);
            		}else{
            			$("#reduceClassTimes").text(0);
            		}
            	}
            	if("mem_name" == condition){
            		var tpl = document.getElementById("reduceClassListTpl").innerHTML;
            		var html = template(tpl,{list:data.list});
            		$("#reduceClassRecordByMemName").html(html);
            	}
            	if("card" == condition){
            		var tpl = document.getElementById("reduceClassListTpl").innerHTML;
            		var html = template(tpl,{list:data.list});
            		$("#reduceClassRecordByCard").html(html);
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
//私教销售记录
function showPtSalesRecord(){
	var now = new Date();
	var m = now.getMonth();
	var y = now.getFullYear();
	var month = [];
	month.push("所有月份");
	for(var i=0;i<2;i++){
		if(i == 0){
			for(var j=m;j>=0;j--){
				var xx = new Date(y,j,1).Format("yyyy-MM");
				month.push(xx);
			}
		}else{
			y--;
			for(var j=11;j>=0;j--){
				var xx = new Date(y,j,1).Format("yyyy-MM");
				month.push(xx);
			}
		}
	}
	
	$("#privateSalesMonthPicker").picker({
		  toolbarTemplate: '<header class="bar bar-nav">\
		  <button class="button button-link pull-right close-picker">确定</button>\
		  <h1 class="title">请选择月份</h1>\
		  </header>',
		  cols: [
		    {
		      textAlign: 'center',
		      values: month
		    }
		  ],onClose:function(){
			  queryPrivateClassSales("","month",$("#privateSalesMonthPicker").val(),false);
		  } 
		});
	$("#privateSalesMonthPicker").val(new Date().Format("yyyy-MM"));
	$("#privateSalesMonthPicker").picker("setValue", [new Date().Format("yyyy-MM")]);
	queryPrivateClassSales("","month",$("#privateSalesMonthPicker").val(),true);
}
//今日消课
function todayReduceClass(){
	//假设这是员工
	$.showIndicator();
	$.ajax({
        type: 'POST',
        url: 'fit-ws-app-pt-getReduceClassRecord',
        dataType: 'json',
        data:{
        	cust_name : cust_name,
        	emp_gym : gym,
        	emp_id : id,
        	type: "end",
        	condition : "day",
			conditionData : new Date().Format("yyyy-MM-dd")
        },
        success: function(data) {
            $.hideIndicator();
            if (data.rs == "Y") {
        		var tpl = document.getElementById("reduceClassListTpl").innerHTML;
        		var html = template(tpl,{list:data.list});
        		$("#reduceClassRecordByToday").html(html);
        		openPopup(".popup-reduceClassRecordToday");
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

//查询私教销售
function queryPrivateClassSales(emp_id,condition,conditionData,init){
	var month = $("#privateSalesMonthPicker").val();
	//假设这是员工
	var user = store.get("fitUser");
	if(!emp_id){
		//如果没有传入emp_id 就查询自己的员工ID
		emp_id = id;
	}
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
				$("#classPrivateUl").html(content);
				if(init){
					openPopup(".popup-privateSalesRecord");
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
//销售详情
function showSalesDetail(buy_id,headurl){
	
	$.showIndicator();
	$.ajax({
		type : "POST",
		url : "fit-app-action-user-card-detail",
		data : {
			gym : gym,
			cust_name : cust_name,
			buy_id:buy_id
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				var tpl = document.getElementById("privateSalesRecord-detailTpl").innerHTML;
				var content = template(tpl, {
					mem : data.card,
					give_card : data.give_card
				});
				$("#salesRecord-detail").html(content);
				
				openPopup('.popup-privateSalesRecord-detail');
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

//是否确认上课
function is_attend_class(id,plan_id,state,name){
	$.confirm("确认是否"+name+"?", function () {
		attend_class(id,plan_id,state);
    });
}

//是否确认上课
//function is_attend_class(id,plan_id,state,name){
//	$.confirm("确认是否"+name+"?", function () {
//		attend_class(id,plan_id,state);
//  });
//}
//---------------------------------------学员列表---------------------------------------
//学员列表
//学员列表
function showMemListByPT(type,fk_pt_id,show){
	$("#manage_hid2").val("");
	$("#manage_id2").val("");
	$("#manage_hid2").val(show);
	$("#manage_id2").val(id);
	if(fk_pt_id == undefined){
		fk_pt_id = id;
	}
	$.showIndicator();
	$.ajax({
		type : "POST",
		url : "fit-app-action-searchCustomersByPT",
		data : {
			gym : gym,
			cust_name : cust_name,
			type : type,
			fk_pt_id : fk_pt_id,
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				var tpl = document.getElementById("coach_customersTpl").innerHTML;
				content = template(tpl, {
					data : data.mems,
					show : show
				});
				$("#Tab1_coach_customerscontent").html(content);
				openPopup(".popup-coach-customers");
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
function mem_coach_addMaintian() {

	var fk_user_id = $("#mem_id").val();
	var recordText = $("#mem_coach_recordText").val();
	var upcoming = $("#mem_coach_upcoming").val();
	var upcomingTime = $("#mem_coach_upcomingTime").val();
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
//			op_id : '596581f5e8bbca1654e1faab',
			type : 'pt'
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				$("#mem_coach_recordText").val();
				$.toast("提交成功");
				showCustomerDetial(fk_user_id);
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
//---------------------------------------学员列表---------------------------------------
//---------------------------------------学员池---------------------------------------
function showMemPool(searchValue) {
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
								.getElementById("potentialMemPoolTpl").innerHTML;
						content = template(tpl, {
							data : data.mems
						});
						$("#potentialMemPool").html(content);
						openPopup(".popup-potentialMemPool");
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
//绑定PT
function bundledPT(fk_user_id) {
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
					url : "fit-app-action-bundledPt",
					data : {
						gym : gym,
						cust_name : cust_name,
//						fk_pt_id : '596581f5e8bbca1654e1faab',
						fk_pt_id : id,
						fk_user_id : fk_user_id
					},
					dataType : "json",
					success : function(data) {
						$.hideIndicator();
						if (data.rs == "Y") {
							showMemPool();
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
//---------------------------------------学员池---------------------------------------
//---------------------------------------潜在会员---------------------------------------
function showpotentialMem(fk_emp_id,show) {
	$("#isShow").val("");
	$("#showId").val("");
	$("#isShow").val(show);
	$("#showId").val(fk_emp_id);
	openPopup(".popup-potentialMem");
	searchpotentialMem('最近维护',fk_emp_id,show);
}
function searchpotentialMem(type,fk_pt_id,show){

	if( fk_pt_id ==undefined ){
		fk_pt_id = id;
	}
	$("#isShow").val(show);
	$("#showId").val(fk_pt_id);
	$.showIndicator();
	$.ajax({
		type : "POST",
		url : "fit-app-action-showpotentialMem",
		data : {
			gym : gym,
			cust_name : cust_name,
			type : type,
			fk_pt_id : fk_pt_id,
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				var tpl = document.getElementById("potentialMemTpl").innerHTML;
				content = template(tpl, {
					data : data.mems,
					show : show
				});
				$("#Tab1_potentialMemcontent").html(content);
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
//查看会员详情
function showCustomerDetialbyPT(fk_user_id,show,from) {
	$("#mem_addMaintian_from").val(from);
	$("#mem_recordText").val("");
	$.showIndicator();
	$.ajax({
		type : "POST",
		url : "fit-app-action-getPotentialCustomerById",
		data : {
			gym : gym,
			cust_name : cust_name,
			fk_user_id : fk_user_id,
			type : from
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				var mem = data.map.xx;
				if (mem) {
					$("#mem_id_pt").val(mem.id);
					$("#mem_name_pt").html(mem.name);
					$("#mem_phone_pt").html(mem.phone);
					$("#mem_birthday_pt").html(mem.birthday);
					$("#mem_create_time_pt").html(mem.create_time);
					var mc_name = mem.mcName;
					$("#mem_mc_name_pt").html(mc_name);
					$("#mem_remark_pt").html(mem.remark);
					$("#op_time_pt").html(mem.op_time);
					$("#mem_imp_level_pt").html(mem.imp_level);
					var headurl = mem.headurl;
					 if(!headurl || headurl.length <= 0){
				        	headurl = "app/images/head/default.png";
				        }
					$("#mem_headurl_pt").attr("src",headurl);
				}
				if(show=="false"){
					$("#mem_reocrd_pt").html("");
					$("#pt-record-div").hide();
					$("#pt-record-div-btn").hide();
				}else{
					$("#pt-record-div").show();
					$("#pt-record-div-btn").show();
				}
				var tpl = document.getElementById("mem_reocrdTpl_pt").innerHTML;
				content = template(tpl, {
					data : data.record
				});
				$("#mem_reocrd_pt").html(content);
				
				openPopup(".popup-customerDetial-pt");
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
function mem_addMaintian_pt(){
	var fk_user_id = $("#mem_id_pt").val();
	var recordText = $("#mem_recordText_pt").val();
	var upcoming = $("#mem_upcoming_pt").val();
	var upcomingTime = $("#mem_upcomingTime_pt").val();
	var from = $("#mem_addMaintian_from").val();
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
//			op_id : '596581f5e8bbca1654e1faab',
			type : from
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				$("#mem_recordText_pt").val('');
				$.toast("提交成功");
				showCustomerDetialbyPT(fk_user_id,"",from);
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
//---------------------------------------潜在会员---------------------------------------

//教练报表
function showPtSalseReport(emp_id,emp_name){
	var now = new Date().Format("yyyy-MM-dd");
	$("#ptRreportDate").val(now);
	if(!emp_id){
		emp_id = id;
	}
	$("#ptReportDate").unbind("change");
	$("#ptReportDate").change(function(){
		queryPtSalesReport(emp_id,$(this).val(),false);
	});
	if(typeof emp_name !="undefined"){
		$("#ptSalesReportTitle").text("教练["+emp_name+"]的个人报表");
	}else{
		$("#ptSalesReportTitle").text("我的报表");
	}
	queryPtSalesReport(emp_id,now,true);
}

function queryPtSalesReport(emp_id,date,init){
	$.showIndicator();
	
	$.ajax({
		type : "POST",
		url : "fit-app-action-ptSalesReport",
		data : {
			cust_name : cust_name,
			curGym : gym,
			emp_id : emp_id,
			date : date
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				var tpl = document.getElementById("ptSalesReportTpl").innerHTML;
				var content = template(tpl, {
					date:date,
					dayInfos:data.dayInfo,
					monthInfos:data.monthInfo,
					allInfos:data.allInfo,
					reduceClass:data.reduceClass,
					maintainInfos:data.maintainInfo,
					reduceGClass:data.reduceGClass,
					
				});
				$("#ptSalesReportDiv").html(content);
				
				if(init){
					openPopup(".popup-ptSalesReport");
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

function getPtReportNumber(data,type){
	var num = 0;
	if(data && data.length >0){
		for(var i=0;i<data.length;i++){
			var info = data[i];
			if(info.type == type){
				num = Number(info.num || 0);
				break;
			}
		}
	}
	return num;
}

function scanner(){
	wx.ready(function() {
        wx.scanQRCode({
            needResult: 1,
            // 默认为0，扫描结果由微信处理，1则直接返回扫描结果，
            scanType: ["qrCode", "barCode"],
            success: function(res) {
            	var result = res.resultStr;
                reduce_class(result);
            }
        });
    });
}

//健身计划
function showPtFitPlan(emp_id){
	if (logined != 'Y') {
		openPopup(".wxloginPopup");
		return;
	}
	if(!emp_id){
		emp_id = id;
	}
	$("#fit_plan_pt_id").val(emp_id);
	//查询买了该教练私教卡的会员
	queryPtMems(true);
}
function queryPtMems(init){
	var emp_id = $("#fit_plan_pt_id").val();
	var search = $("#fit_plan_ptsMem_search").val()  || "";
	$.showIndicator();
	$.ajax({
		type : "POST",
		url : "fit-app-action-getMemWhoBuyCardWithPt",
		data : {
			search : search,
			cust_name : cust_name,
			gym : gym,
			pt_id : emp_id
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				var tpl = document.getElementById("fit_plan_pt_mems").innerHTML;
				var content = template(tpl, {list:data.list,pt_id:emp_id
				});
				$("#fit_plan_ptsMem").html(content);
				if(init){
					openPopup(".popup-fit-plan");
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

//为会员制定健身计划
function makeFitPlan(mem_id,headurl,mem_name,mem_gym,pt_id){
	$("#fitPlanMemHead").attr("src",headurl);
	$("#fitPlanMemName").text(mem_name);
	$("#fit_plan_mem_id").val(mem_id);
	$("#fit_plan_mem_gym").val(mem_gym);
	$("#fit_plan_pt_id").val(pt_id);
	$("#readFitPlanList ul").html("");
	$.showIndicator();
	//查询已有计划
	var start_time = $("#fit_plan_start_time").val();
	var end_time = $("#fit_plan_end_time").val();
	
	queryHasPlan();
}

//查询已有计划  教练自己的待规划计划
function queryHasPlan(){
	var start_time = $("#fit_plan_start_time").val();
	var end_time = $("#fit_plan_end_time").val();
	
	var month = $("#fit_plan_month").val();
	var mem_id = $("#fit_plan_mem_id").val();
	var mem_gym = $("#fit_plan_mem_gym").val();
	var pt_id = $("#fit_plan_pt_id").val();
	var type ="mem";
	if(role.indexOf("我是教练")!=-1){
		type = "pt";
	}
	var onShowMyPlan = $("#onShowMyPlan").is(":checked");
	$.showIndicator();
	$.ajax({
		type : "POST",
		url : "fit-app-action-queryMemFitPlan",
		data : {
			month : month,
			cust_name : cust_name,
			gym : gym,
			mem_id : mem_id,
			mem_gym :mem_gym,
			start_time :start_time,
			end_time: end_time,
			type:type,
			pt_id:pt_id,
			isPt:onShowMyPlan
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				var tpl = document.getElementById("fit_plan_pt_readyPlanTpl").innerHTML;
				var content = template(tpl, {list:data.list,userType:type
				});
				$("#memHasFitPlan").html(content);
				
				openPopup(".popup-fit-plan-mem");
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

function readyPlan(){
	var fitPlanNumber = $("#fitPlanNumber").val();
	if(!fitPlanNumber || fitPlanNumber == 0){
		$("#readFitPlanList ul").html("");
	}else{
		var html = "";
		for(var i=0;i<fitPlanNumber;i++){
			var text = document.getElementById("readyPlanLiTpl").innerHTML;
			html += template(text,{i:i});
		}
		$("#readFitPlanList ul").html(html);
	}
}

function createPlan(){
	var fitPlanNumber = $("#fitPlanNumber").val();
	var fitPlanTitle = $("#fitPlanTitle").val();
	var fitPlanStartTime = $("#fitPlanStartTime").val();
	var fitPlanEndTime = $("#fitPlanEndTime").val();
	if(fitPlanNumber == "" || fitPlanTitle== "" || fitPlanStartTime=="" ||fitPlanEndTime==""){
		$.toast("请完善计划内容");
		return;
	}
	
	var mem_id = $("#fit_plan_mem_id").val();
	var mem_gym = $("#fit_plan_mem_gym").val();
	var pt_id = $("#fit_plan_pt_id").val();
	$.showIndicator();
	$.ajax({
		type : "POST",
		url : "fit-app-action-createFitPlan",
		data : {
			cust_name : cust_name,
			gym : gym,
			mem_gym :mem_gym,
			mem_id : mem_id,
			pt_id :pt_id,
			fitPlanNumber:fitPlanNumber,
			fitPlanTitle:fitPlanTitle,
			fitPlanStartTime:fitPlanStartTime,
			fitPlanEndTime:fitPlanEndTime
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				$.toast("添加成功");
				closePopup('.popup-fit-plan-add-new');
				queryHasPlan();
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

//会员查看计划
function showMemFitPlan(){
	if (logined != 'Y') {
		openPopup(".wxloginPopup");
		return;
	}
	if(role.indexOf("我是教练")!=-1){
		showPtFitPlan();
		return;
	}
	
	var start_time = $("#my_fit_plan_start_time").val();
	var end_time = $("#my_fit_plan_end_time").val();
	var month = $("#my_fit_plan_month").val();
	
	$.showIndicator();
	$.ajax({
		type : "POST",
		url : "fit-app-action-queryMemFitPlan",
		data : {
			month :month,
			cust_name : cust_name,
			gym : gym,
			mem_id : id,
			start_time : start_time,
			end_time:end_time
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				var tpl = document.getElementById("fit_plan_pt_readyPlanTpl").innerHTML;
				var html = template(tpl,{list:data.list,userType:'mem'});
				$("#myFitPlanlist").html(html);
				openPopup(".popup-fit-plan-mem-my");
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

function showFitPlanDetail(fit_plan_id,detail_id,type,mem_gym){
	
	$("#fit_plan_type").val(type);
	$("#fit_plan_detail_id").val(detail_id);
	$("#fit_plan_detail_mem_gym").val(mem_gym);
	$.showIndicator();
	$.ajax({
		type : "POST",
		url : "fit-app-action-queryFitPlanDetail",
		data : {
			cust_name : cust_name,
			gym : gym,
			mem_gym : mem_gym,
			fit_plan_id : fit_plan_id,
			detail_id:detail_id,
			type :type
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				var tpl = document.getElementById("fitPlanDetailTpl").innerHTML;
				var html = template(tpl,{fit_plan:data.fit_plan,type:type,detail:data.detail});
				$("#fit_plan_detail_div").html(html);
				openPopup(".popup-fit-plan-mem-detial");
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

function showEditFitPlanDetail(detailStr,memGym){
	var detail = JSON.parse(detailStr);
	$("#detail_gym").val(memGym);
	$("#edit_fit_detail_id").val(detail.id);
	
	/*$("#edit_fit_plan_start_time").val(detail.start || "");
	$("#edit_fit_plan_end_time").val(detail.end || "");
	*/
	$("#edit_fit_plan_content").val(detail.plan_content || "");

	/*var s = getTimePicker(detail.start);
	var e = getTimePicker(detail.end);
	var now = getTimePicker();
	
	
	if(!detail.start){
		$("#edit_fit_plan_start_time").datetimePicker({
			 value: s
		});
	}else{
		$("#edit_fit_plan_start_time").datetimePicker({
			 value: now
		});
		$("#edit_fit_plan_start_time").val("");
	}
	if(!detail.end){
		$("#edit_fit_plan_end_time").datetimePicker({
			 value: e
		});
	}else{
		$("#edit_fit_plan_end_time").datetimePicker({
			 value: now
		});
		$("#edit_fit_plan_end_time").val("");
	}*/
	var hours = [];
	var mins = [];
	for(var i=0;i<60;i++){
		mins.push(i < 10 ?"0"+(i+""):i);
	}
	for(var i=6;i<24;i++){
		hours.push(i < 10 ?"0"+(i+""):i);
	}
	var start_default =  ["06",":","00"];
	if(detail.start){
		start_default = [detail.start.substring(11,13),":",detail.start.substring(14,16)];
	}
	var end_default = ["23",":","00"]; 
	if(detail.end){
		end_default =  [detail.end.substring(11,13),":",detail.end.substring(14,16)];
	}
	$("#edit_fit_plan_start").picker({
		  toolbarTemplate: '<header class="bar bar-nav">\
		  <button class="button button-link pull-right close-picker">确定</button>\
		  <h1 class="title">请选择开始时间</h1>\
		  </header>',
		  cols: [
		    {
		      textAlign: 'center',
		      values: hours
		      //如果你希望显示文案和实际值不同，可以在这里加一个displayValues: [.....]
		    },
		    {
		    	textAlign: 'center',
			      values: [":"]
		    },
		    {
		      textAlign: 'center',
		      values: mins
		    }
		  ],value: start_default
		});
	$("#edit_fit_plan_end").picker({
		  toolbarTemplate: '<header class="bar bar-nav">\
		  <button class="button button-link pull-right close-picker">确定</button>\
		  <h1 class="title">请选择结束时间</h1>\
		  </header>',
		  cols: [
		    {
		      textAlign: 'center',
		      values: hours
		      //如果你希望显示文案和实际值不同，可以在这里加一个displayValues: [.....]
		    },
		    {
		    	textAlign: 'center',
			      values: [":"]
		    },
		    {
		      textAlign: 'center',
		      values: mins
		    }
		  ],value: end_default
		});
	//第二种
	if(detail.start){
		$("#edit_fit_plan_date").calendar({
			value: [detail.start.substring(0,10)]
		});
		$("#edit_fit_plan_date").val(detail.start.substring(0,10));
	}else if(detail.end){
		$("#edit_fit_plan_date").calendar({
			value: [detail.end.substring(0,10)]
		});
		$("#edit_fit_plan_date").val(detail.end.substring(0,10));
	}else{
		$("#edit_fit_plan_date").calendar({
			value: [new Date().Format("yyyy-MM-dd")]
		});
		//$("#edit_fit_plan_date").val(new Date().Format("yyyy-MM-dd"));
	}
	
	if(detail.start){
		$("#edit_fit_plan_start").val(detail.start.substring(11,13) +" : " +detail.start.substring(14,16));
		$("#edit_fit_plan_start").picker("setValue", [detail.start.substring(11,13),":",detail.start.substring(14,16)]);
	}else{
		$("#edit_fit_plan_start").val("");
		$("#edit_fit_plan_start").picker("setValue", start_default);
	}
	if(detail.end){
		$("#edit_fit_plan_end").val(detail.end.substring(11,13) +" : " +detail.end.substring(14,16));
		$("#edit_fit_plan_end").picker("setValue", [detail.end.substring(11,13),":",detail.end.substring(14,16)]);
	}else{
		$("#edit_fit_plan_end").val("");
		$("#edit_fit_plan_end").picker("setValue", end_default);
	}
	
	console.log($("#edit_fit_plan_start").val() +"  "+$("#edit_fit_plan_end").val());
	openPopup(".popup-fit-plan-edit");
}

function saveFitPlanDetail(){
	var detail_id = $("#edit_fit_detail_id").val();
	var detail_date = $("#edit_fit_plan_date").val();
	var start = $("#edit_fit_plan_start").val();
	var end = $("#edit_fit_plan_end").val();
	
	//var detail_start = $("#edit_fit_plan_start_time").val();
	//var detail_end = $("#edit_fit_plan_end_time").val();
	var detail_start = "";
	var detail_end = "";
	if(detail_date != null){
		if(start =="" && end == ""){
			$.alert("请选择具体时间");
			return;
		}
		if(start){
			detail_start = detail_date + " " + start.replace(/\s/g,"");
		}
		if(end){
			detail_end = detail_date + " " + end.replace(/\s/g,"");
		}
		if(start && end){
			if(new Date(detail_start+":00").getTime()>new Date(detail_end+":00").getTime()){
				$.alert("开始时间不能大于结束时间噢");
				return;
			}
		}	
	}
	
	
	var detail_plan_content = $("#edit_fit_plan_content").val();
	var memGym = $("#detail_gym").val();
	
	$.showIndicator();
	$.ajax({
		type : "POST",
		url : "fit-app-action-saveFitPlanDetail",
		data : {
			cust_name : cust_name,
			gym : gym,
			memGym : memGym,
			detail_id : detail_id,
			detail_start :detail_start,
			detail_end :detail_end,
			detail_plan_content:detail_plan_content
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				$.alert("保存成功");
				closePopup(".popup-fit-plan-edit");
				queryHasPlan();
			} else {
				$.toast(data.rs);
			}
		},
		error : function() {
			$.hideIndicator();
			$.alert("啊哦，网络繁忙，请稍后再试");
		}
	});
}

function getTimePicker(time){
	var now = new Date();
	var arr = [];
	if(time){
		now = new Date(time);
	}
	var year =String(now.getFullYear()+'');
	var month = String(now.getMonth() + 1+'');
	if(month <10){
		month = "0"+month;
	}
	var day = String(now.getDate()+'');
	var hh = String(now.getHours()+'');
    var mm =String(now.getMinutes()+'');
	arr.push(year);
	arr.push(month);
	arr.push(day);
	arr.push(hh);
	arr.push(mm);
	return arr;
}


function submitMySay(detail_id,mem_gym,type){
	var text =	$("#fit_plan_my_speak").val();
	if(text ==""){
		var msg ="什么都还没有写呢T.T";
		if("mem" == type){
			msg = "您的评价对我们的教练很重要呢T.T";
		}
		$.alert(msg);
		return;
	}
	var mem_confirm = $("#mem_confirm_checkbox").is(":checked")?"Y":"N";
	var pt_confirm = $("#pt_confirm_checkbox").is(":checked")?"Y":"N";
	
	
	$.showIndicator();
	$.ajax({
		type : "POST",
		url : "fit-app-action-FitPlanSpeak",
		data : {
			cust_name : cust_name,
			mem_gym : mem_gym,
			detail_id : detail_id,
			type :type,
			text :text,
			mem_confirm:mem_confirm,
			pt_confirm:pt_confirm
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				$.alert("评价成功");
				closePopup(".popup-fit-plan-mem-detial");
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

function editFitPlan(fit_plan_id,title){
	$("#edit_fit_plan_id").val(fit_plan_id);
	$("#edit_fit_plan_title").val(title);
	
	$.showIndicator();
	$.ajax({
		type : "POST",
		url : "fit-app-action-queryFitPlanDetailById",
		data : {
			cust_name : cust_name,
			gym : gym,
			fit_plan_id : fit_plan_id
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				var tpl = document.getElementById("popup-fit-plan-detail-listTpl").innerHTML;
				var html = template(tpl,{mem:data.mem,list:data.list});
				$(".popup-fit-plan-detail-list").html(html);
				openPopup(".popup-fit-plan-detail-list");
			} else {
				$.toast(data.rs);
			}
		},
		error : function() {
			$.hideIndicator();
			$.alert("啊哦，网络繁忙，请稍后再试");
		}
	});
	
	
}

function addNewFitPlan(){
	$("#fitPlanNumber").val("");
	$("#fitPlanTitle").val("");
	$("#fitPlanStartTime").val("");
	$("#fitPlanEndTime").val("");
	openPopup(".popup-fit-plan-add-new");
}

//直接确认 不发表评论
function plan_detail_confirm(t,detail_id,mem_gym,type){
	var flag = $(t).is(":checked");
	if(!flag){
		return ;
	}
	
	 $.confirm('请确认计划已经完成?', function () {
			$.showIndicator();
			$.ajax({
				type : "POST",
				url : "fit-app-action-FitPlanDetailConfirm",
				data : {
					cust_name : cust_name,
					mem_gym : mem_gym,
					detail_id : detail_id,
					type :type
				},
				dataType : "json",
				success : function(data) {
					$.hideIndicator();
					if (data.rs == "Y") {
						var time = new Date(Number(data.now)).Format("yyyy-MM-dd hh:mm");
						$(t).attr("disabled","disabled");
						$(t).removeAttr("onchange");
						$(t).after("&nbsp;" + time);
					} else {
						$.toast(data.rs);
					}
				},
		        error: function(xhr, type) {
		            $.hideIndicator();
		            $.toast("您的网速不给力啊，再来一次吧");
		        }
			});
	 });
}
function deleteFitPlan(plan_id,mem_gym){
   $.confirm('确定要删除该计划吗?', function () {
	   $.showIndicator();
	   $.ajax({
			type : "POST",
			url : "fit-app-action-deleteFitPlan",
			data : {
				cust_name : cust_name,
				mem_gym : mem_gym,
				gym : gym,
				plan_id : plan_id
			},
			dataType : "json",
			success : function(data) {
				$.hideIndicator();
				if (data.rs == "Y") {
					$.toast("删除成功");
					queryHasPlan();
				} else {
					$.toast(data.rs);
				}
			},
	        error: function(xhr, type) {
	            $.hideIndicator();
	            $.toast("您的网速不给力啊，再来一次吧");
	        }
		});
   });
}
function ptEditFitPlan(plan_id,t){
	var text = $(t).text();
	if("编辑"==text){
		$(t).text("取消");
		$("#"+plan_id+"start_time").calendar({
		    value: [$("#"+plan_id+"start_time").val()]
		});
		$("#"+plan_id+"end_time").calendar({
			value: [$("#"+plan_id+"end_time").val()]
		});
		$("#"+plan_id+"title").css("border","");
		$("#"+plan_id+"title").removeAttr("readonly");
		
		$("#"+plan_id+"edit").show();
	}else{
		$(t).text("编辑");
		$("#"+plan_id+"title").css("border","0");
		$("#"+plan_id+"title").attr("readonly","readonly");
		$("#"+plan_id+"edit").hide();
	}
}

function saveEditFitPlan(plan_id){
	var start_time = $("#"+plan_id+"start_time").val();
	var end_time = $("#"+plan_id+"end_time").val();
	var title = $("#"+plan_id+"title").val();
	if(title == ""){
		$.alert("标题不能是空的噢");
		return;
	}
	if(start_time == ""){
		$.alert("开始时间不能是空的噢");
		return;
	}
	if(end_time == ""){
		$.alert("结束时间不能是空的噢");
		return;
	}
	$.showIndicator();
	$.ajax({
		type : "POST",
		url : "fit-app-action-saveEditFitPlan",
		data : {
			cust_name : cust_name,
			gym : gym,
			plan_id : plan_id,
			start_time : start_time,
			end_time : end_time,
			title : title
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				$.toast("修改成功");
				queryHasPlan();
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

function getPickerMonths(num){
	var now = new Date();
	var m = now.getMonth();
	var y = now.getFullYear();
	var month = [];
	for(var i=0;i<num;i++){
		if(i == 0){
			for(var j=m;j>=0;j--){
				var xx = new Date(y,j,1).Format("yyyy-MM");
				month.push(xx);
			}
		}else{
			y--;
			for(var j=11;j>=0;j--){
				var xx = new Date(y,j,1).Format("yyyy-MM");
				month.push(xx);
			}
		}
	}
	return month;
}

//私教预约点击日期
function changePrivateOrderDate(t){
	$(t).parent().find("div").css("background-color","#2c2e47");
	$(t).parent().find("div").attr("data-checked","N");
	$(t).css("background-color","#242537");
	$(t).attr("data-checked","Y");
	//查询当天数据
	var date = $(t).attr("data-orderDate");
	queryPrivateOrderByDate(date);
	$(".upright-right").scrollTop(0);
}

//查询某天私教预约记录
function queryPrivateOrderByDate(date){
	if(!date){
		date = new Date().Format("yyyy-MM-dd");
	}
	var start_time = date +" 08:00:00";
	var end_time = date +" 22:00:00";
	var pt_id = $("#privateOrderPtId").val();
	$.showIndicator();
	 $.ajax({
			type : "POST",
			url  : "fit-ws-app-queryPrivateOrder",
			data : {
				cust_name : cust_name,
				gym : gym,
				start_time : start_time,
				end_time : end_time,
				pt_id : pt_id
			},
			dataType : "json",
			success : function(data) {
				$.hideIndicator();
				if (data.rs == "Y") {
					var tpl = document.getElementById("privateOrderPopupTpl").innerHTML;
					var html = template(tpl,{list:data.list});
					$(".upright-right-times").html(html);
					
					//教练信息更新
					$("#privateOrderPtHeader").attr("src",data.pt.headurl);
					$("#privateOrderPtName").text("教练 "+data.pt.name);
					var ptInfo = "电话&nbsp;"+data.pt.phone +"&nbsp;<a href='tel:"+data.pt.phone+"'><span class='icon icon-phone'></span></a>";
					$("#privateOrderPtInfo").html(ptInfo);
				} else {
					$.toast(data.rs);
				}
			},
			error : function(xhr, type) {
				$.hideIndicator();
				$.toast("您的网速不给力啊，再来一次吧");
			}
		});
	/*var tpl = document.getElementById("privateOrderPopupTpl").innerHTML;
	var html = template(tpl,{});
	$(".upright-right-times").html(html);
	$(".upright-right").scrollTop(0);*/
}