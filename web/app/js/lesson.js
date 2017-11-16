//显示当天课程列表
function showLesson(){
	$.showIndicator();
	$.ajax({
		url:"fit-ws-app-showThisDayLesson",
		type:"POST",
		dataType:"json",
		data:{
			cust_name:cust_name,
			gym:gym
		},
		success:function(data){
			$.hideIndicator();
			if(data.rs == "Y"){
				var tpl = document.getElementById("lessonListTpl").innerHTML;
				var html = template(tpl,{list:data.list});
				$("#thisDayLessonDiv").html(html);
			}else{
				$.toast(data.rs);
			}
		},
		error : function(xhr, type) {
			$.hideIndicator();
			$.toast("您的网速不给力啊，再来一次吧");
		}
	});
}
//显示课程表
function showLessonPlan(type){
	$(".plans-tab-mem .day-btn").removeClass("active");
	$("#time_one").addClass("active");
    openPopup(".popop-lessonPlan");
    var now = new Date().Format("yyyy-MM-dd");
    getDayLesson(now,type);
}

//根据日期查询课程表
function getDayLesson(day,type){
	var user = store.get("fitUser");
	$.showIndicator();
	$.ajax({
        type: 'POST',
        url: 'fit-ws-app-searchLessonForTime',
        dataType: 'json',
        data:{
        	cust_name : cust_name,
        	gym : gym,
        	day : day,
        	type : type,
        	id : id
        },
        success: function(data) {
            $.hideIndicator();
            if (data.rs == "Y") {
                var lessonTpl = document.getElementById("lessonTpl").innerHTML;
                content = template(lessonTpl, {
                    list: data.list,
                });
                $("#lessonTplUl").html(content);
                	$("#type").val(type);
                	if("tiYan" == type){
                		$("#lessonTitle").html("体验课程");
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

function getTiYanLesson(type){
	var now = new Date().Format("yyyy-MM-dd");
	$.showIndicator();
	$.ajax({
		type: 'POST',
		url: 'fit-ws-app-searchLessonForTime',
		dataType: 'json',
		data:{
			cust_name : cust_name,
			gym : gym,
			day : now,
			type : type
		},
		success: function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				var showLessonTpl = document.getElementById("showLessonTpl2").innerHTML;
				content = template(showLessonTpl, {
					list: data.list,
				});
				
				$("#lessonTplUl2").html(content);
				if("tiYan" == type){
					$("#lessonTitle2").html("体验课程");
					
				}		
				openPopup(".popop-lessonPlan-recommend");
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
//显示课程详情
function showThisLessonDetail(plan_detail_id){
	$.showIndicator();
	$.ajax({
        type: 'POST',
        url: 'fit-ws-app-showLessonDetail',
        dataType: 'json',
        data:{
        	cust_name : cust_name,
        	gym : gym,
        	id : plan_detail_id,
        	mem_id : id
        },
        success: function(data) {
            $.hideIndicator();
            if (data.rs == "Y") {
                var lessonTpl = document.getElementById("lessonDetailTpl").innerHTML;
                var buttonOrderTpl = document.getElementById("buttonOrderTpl").innerHTML;
                content = template(lessonTpl, {
                    list: data.list,
                    mem_list : data.mem_list
                });
                buttonOrderHtml = template(buttonOrderTpl, {
                	list: data.list,
                	order_state : data.order_state
                });
                content = content.replace(/&amp;/g,"&");
                content = content.replace(/&lt;/g,"<");
                content = content.replace(/&gt;/g,">");
                content = content.replace(/&nbsp;/g," ");
                content = content.replace(/&#39;/g,"\'");
                content = content.replace(/&quot;/g,"\"");
                $("#lessonDetailDiv").html(content);
                $("#buttonOrder").html(buttonOrderHtml);
                popups.push(".popop-lessonPlanDetail");
            	$.popup(".popop-lessonPlanDetail");
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
//显示体验课程详情
function showRecommendLessonDetail(plan_detail_id){
	$.showIndicator();
	$.ajax({
		type: 'POST',
		url: 'fit-ws-app-showLessonDetail',
		dataType: 'json',
		data:{
			cust_name : cust_name,
			gym : gym,
			id : plan_detail_id,
			mem_id : id
		},
		success: function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				var lessonTpl = document.getElementById("lessonDetailTpl2").innerHTML;
				var buttonOrderTpl = document.getElementById("buttonOrderTpl2").innerHTML;
				content = template(lessonTpl, {
					list: data.list,
				});
				buttonOrderHtml = template(buttonOrderTpl, {
					list: data.list,
					order_state : data.order_state
				});
				content = content.replace(/&amp;/g,"&");
                content = content.replace(/&lt;/g,"<");
                content = content.replace(/&gt;/g,">");
                content = content.replace(/&nbsp;/g," ");
                content = content.replace(/&#39;/g,"\'");
                content = content.replace(/&quot;/g,"\"");
				$("#lessonDetailDiv2").html(content);
				$("#buttonOrder2").html(buttonOrderHtml);
				popups.push(".popop-lessonPlanDetail2");
				$.popup(".popop-lessonPlanDetail2");
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
//显示推荐课程具体课程排期
function showRecommendPaiQi(id){
	var now = new Date().Format("yyyy-MM-dd");
	$.showIndicator();
	$.ajax({
		type: 'POST',
		url: 'fit-ws-app-showRecommendLesson',
		dataType: 'json',
		data:{
			cust_name : cust_name,
			gym : gym,
			id : id
		},
		success: function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				var showLessonTpl = document.getElementById("showLessonTpl3").innerHTML;
				content = template(showLessonTpl, {
					list: data.list,
				});
				$("#lessonTplUl2").html(content);
				var plan_name = data.list[0].plan_name;
				$("#lessonTitle2").html(plan_name);
				openPopup(".popop-lessonPlan-recommend");
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
//显示为你推荐课程
function showLessonRecommendTop(){
	$.showIndicator();
	$.ajax({
        type: 'POST',
        url: 'fit-ws-app-showThisDayLesson',
        dataType: 'json',
        data:{
        	cust_name : cust_name,
        	gym : gym,
        	type : "recommend"
        },
        success: function(data) {
            $.hideIndicator();
            if (data.rs == "Y") {
                var lessonTpl = document.getElementById("recommendLessonTpl").innerHTML;
                content = template(lessonTpl, {
                    list: data.list,
                });
                $("#recommendDiv").html(content);
                openPopup(".popup-showLessonTop");
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
//预约课程
function order_lesson(plan_detail_id,plan_id){
	$.showIndicator();
	var state = $("#nums").val();
	var Timestate = $("#Timestate").val();
	var order_state = $("#order_state").val();
	if(order_state == 'Y'){
		$.toast("已预约");
		$.hideIndicator();
		return;
	}
	if(state == 'N'){
		$.toast("人数已达上限");
		$.hideIndicator();
		return;
	}
	if(Timestate == 'Y'){
		$.toast("已停止预约");
		$.hideIndicator();
		return;
	}
	$.ajax({
        type: 'POST',
        url: 'fit-ws-app-orderLesson',
        dataType: 'json',
        data:{
        	cust_name : cust_name,
        	gym : gym,
        	id : id,
        	plan_id : plan_id,
        	plan_detail_id : plan_detail_id
        },
        success: function(data) {
            $.hideIndicator();
            if (data.rs == "Y") {
            	var temp = data.temp;
            	if(temp == "N"){
            		var card = data.card;
                	var card_name = card[0].card_name;
                	var id = card[0].id;
                	var fee = card[0].fee;
            		 $.confirm('预约该课程需要'+card_name+"卡，是否前往购买?", function () {
            	          getCardMsg(id,fee);
            	      });
            	}else{
            		$.toast("恭喜你预约成功");
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
//体验课程预约
function order_experience_lesson(plan_detail_id,plan_id){
	var order_state = $("#order_state").val();
	if(order_state == 'Y'){
		$.toast("已预约");
		$.hideIndicator();
		return;
	}
	$.showIndicator();
	$.ajax({
        type: 'POST',
        url: 'fit-ws-app-orderExperienceLesson',
        dataType: 'json',
        data:{
        	cust_name : cust_name,
        	gym : gym,
        	id : id,
        	plan_id : plan_id,
        	plan_detail_id : plan_detail_id
        },
        success: function(data) {
            $.hideIndicator();
            if (data.rs == "Y") {
            		$.toast("恭喜你预约成功");
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
//确认约课
function is_order(plan_detail_id,plan_id,name){
	if(name=="tiYan"){
		$.confirm("确认是否体验?", function () {
			order_experience_lesson(plan_detail_id,plan_id);
		});
	}else{
		
		$.confirm("确认是否预约?", function () {
			order_lesson(plan_detail_id,plan_id);
		});
	}
}