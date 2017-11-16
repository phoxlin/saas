
function search_recommend(){
	var phone = $("#visitor_phoneNum").val();
	if(phone.length !=11){
		return;
	}
	 $.ajax({
	        type: "POST",
	        url: "fit-cashier-search_recommend",
	        dataType: "json",
	        data : {
	        	phone : phone
	        },
	        success: function(data) {
	            if (data.rs == "Y") {
	               var list = data.list;
	               if(list.length > 0){
	            	   $("#visitor_name").val(list[0].mem_name);
	            	   $("#f_mem__birthday").val(list[0].birthday);
	            	   $("#visitor_idNum").val(list[0].id_card);
	            	   var salesName = list[0].mc_name;
	                    var coachName = list[0].pt_name;
	            	  
	            	   if(salesName != undefined && salesName.length>0){
	                    	 $("#salesName").html(list[0].mc_name);
	                    }
	                    if(coachName != undefined && coachName.length>0){
	                    $("#coachName").html(list[0].pt_name);
	                  
	                    }
	            	   var mc_id = list[0].mc_id;
	            	   var pt_id = list[0].pt_names;
	            	   var refer_mem_phone = list[0].refer_mem_phone;
	            	   if(mc_id !=undefined){
	            		   $("#sales").val(mc_id);
	            	   }
	            	   if(pt_id !=undefined){
	            		   $("#coach").val(pt_id);
	            	   }
	            	   if(refer_mem_phone !=undefined){
	            		   $("#refer_phone").val(refer_mem_phone);
	            	   }
	               }
	                
	            } else {
	                alert(data.rs);
	            }
	            $("#remark").val("");
	        }
	    });
	
}



$(function() {
  
    // 归还手牌 回车事件
    $('#cashier_handNo').keyup(function(e) {
        if (e.keyCode == 13) {
            backHandNo();
        }
    });
});

function showView(word) {
    dialog({
        title: "查看备注",
        content: word,
        width: 520,
        height: 250,
        okValue: "确定",
        ok: function() {}
    }).showModal();
}

function serarchNOtBackHand() {
    $.ajax({
        type: "POST",
        url: "fit-cashier-notbackHand",
        dataType: "json",
        success: function(data) {
            if (data.rs == "Y") {
                var h = data.data;
                var html = "";
                var handNo = "";
                for (var i = 0; i < h.length; i++) {
                    handNo = h[i].hand_no;
                    if (handNo) {
                        html += "<div onclick='backHandNo(\"" + handNo + "\")'>" + handNo + "</div>";
                    }
                }
                $("#handOffDiv").html(html);
            } else {
                alert(data.rs);
            }
            $("#remark").val("");
        }
    });
}

// 归还手牌
function backHandNo(cashier_handNo) {
    if (!cashier_handNo) {
        cashier_handNo = $("#cashier_handNo").val();
    }
    var url = "partial/backHand.jsp?cashier_handNo=" + cashier_handNo;
    dialog({
        url: url,
        title: "归还" + cashier_handNo + "号手环",
        width: 820,
        height: 400,
        okValue: "确定",
        ok: function() {
            var iframe = $(window.parent.document).contents().find("[name=" + dialog.getCurrent().id + "]")[0].contentWindow;
            iframe.backHandNo(this, window);
            $("#cashier_handNo").val("");
            return false;
        },
        cancelValue: "取消",
        cancel: function() {
            return true;
        }
    }).showModal();
}
// 借出手环
function lendHandNo(memId, mem_gym) {
    var url = "partial/lendHand.jsp?memId=" + memId + "&mem_gym=" + mem_gym;
    dialog({
        url: url,
        title: "借出手环",
        width: 820,
        height: 400,
        okValue: "确定",
        ok: function() {
            var iframe = $(window.parent.document).contents().find("[name=" + dialog.getCurrent().id + "]")[0].contentWindow;
            iframe.lendHandNo(this, window);
            return false;
        },
        cancelValue: "取消",
        cancel: function() {
            return true;
        }
    }).showModal();
}
// 最近入场
function recentCheckin(cur) {
	var search = $("#cashierSearchMem").val() ||"";
    $.ajax({
        type: "POST",
        url: "fit-query-chekinMems",
        data: {
            cur: cur,
            search:search
        },
        dataType: "json",
        success: function(data) {
                var recentCheckinTpl = document.getElementById('recentCheckinTpl').innerHTML;
                var recentCheckinTplHtml = template(recentCheckinTpl, {
                    list: data
                });
                $('#recent_list').html(recentCheckinTplHtml);

        }
    });
}

$('*:not(#mem_info)').on("click", "",
function(e) {
    var x = e.target;
    if ("mem_info" != x.id && "mem_info_btn" != x.id) {
        $('#mem_info_list').hide();
        oldMemCashierQueryVal = "";
    }
});

// 散客购票
function buyOneCard() {
    var url = "partial/buyOneCard.jsp";
    dialog({
        url: url,
        title: "散客购票",
        width: 660,
        height: 340,
        okValue: "确定",
        ok: function() {
            var iframe = $(window.parent.document).contents().find("[name=" + $(this)[0].id + "]")[0].contentWindow;
            iframe.buyCard(this, document);
            return false;
        },
        cancelValue: "取消",
        cancel: function() {
            return true;
        }
    }).showModal();
}

// 散客确认购票
/*
 * function buyCard(win, doc) { var notmem_card_type =
 * $('input[name="notmem_card_type"]:checked'); var card_type =
 * notmem_card_type.attr('data-card_type'); var price =
 * parseFloat(notmem_card_type.attr('data-price')); var num =
 * parseInt($('#notmem_num').val()); var real_price = $('#notmem_price').val();
 * var type_id = notmem_card_type.attr("data-typeid"); var type_name =
 * notmem_card_type.attr("data-type_name"); $.ajax({ type : "POST", url :
 * "fit-ws-bg-Mem-buyOneCard", data : { card_type : card_type, price : price,
 * activate_type : "005", num : num, price : price, card_id : type_id, type_name :
 * type_name, real_amt : real_price }, dataType : "json", async : false, success :
 * function(data) { if (data.rs == "Y") { callback_info("购买成功", function() {
 * win.close(); }); } else { (data.rs); } } }); }
 */

// 添加单次卡
function addOneCard() {
    top.dialog({
        url: "partial/addOneCard.jsp",
        title: "添加单次卡",
        width: 800,
        height: 550,
        okValue: "确定",
        ok: function() {
            var iframe = $(window.parent.document).contents().find("[name=" + top.dialog.getCurrent().id + "]")[0].contentWindow;
            iframe.addCard(this, document, window);
            return false;
        }
    }).showModal();

}

var oldMemCashierQueryVal = "";
// 前台入场会员模糊查询
function cashierQueryMems() {
	  var val = $.trim($('#mem_info').val())
	  var valStart = val.substr(0, 1);
	  if(valStart !=":"){
		  setTimeout(function(){
			  var value = $.trim($('#mem_info').val())
		    if(!value)return
		    if(oldMemCashierQueryVal==value)return
		    oldMemCashierQueryVal = value
		    doCashierQuery()
		  },1000)
	  }else{
		  var keyCode = event.keyCode?event.keyCode:event.which?event.which:event.charCode;
		  if (keyCode ==13){
    		  // 单次入场券入场
           $.ajax({
               type: "POST",
               url: "fit-cashier-enter-singleCard",
               data: {
                   key: val
               },
               dataType: "json",
               async: false,
               success: function(data) {
                   if (data.rs == "Y") {
                	   alert("入场成功");
                	   location.reload();
                   } else {
                       alert(data.rs);
                   }
                   $('#mem_info').val("");
               }
           });
         }
	  }
}


function doCashierQuery(){
	var val = $.trim($('#mem_info').val())
    $.ajax({
        type: "POST",
        url: "fit-query-mems",
        data: {
            key: val
        },
        dataType: "json",
        async: false,
        success: function(data) {
            if (data.rs == "Y") {
            	var userInfo = data.data;
            	if(userInfo && userInfo.length>1){
	                var queryUserListTpl = document.getElementById('queryUserListTpl').innerHTML;
	                var queryUserListTplHtml = template(queryUserListTpl, {
	                    list: userInfo
	                });
	                $('#queryUserListDiv').html(queryUserListTplHtml);
	                $('#mem_info_list').show();
            	}else if(userInfo && userInfo.length==1){
            		if(data.autoCheckIn =="ok"){
            			 checkIn("",userInfo[0].id,userInfo[0].gym,userInfo[0].name,userInfo[0].gymName,userInfo[0].sex);
            		}else{
            			showMemInfo(userInfo[0].id,userInfo[0].name,userInfo[0].gym,userInfo[0].gymName,userInfo[0].sex);
            			$('#mem_info').val("");
            		}
            	}
            } else {
                alert(data.rs);
            }
        }
    });
}


// 前台入场会员精确查询
function showMemInfo(id, userName, gym, gymName, sex) {
	var title='会员[' + userName + '] - [' + gymName + ']';
	if(sex!=null&&sex.length>0){
		title='会员[' + userName + '] - [' + gymName + '] - ' + sex;
	}
    dialog({
        url: "partial/mem_info.jsp?fk_user_id=" + id + "&fk_user_gym=" + gym,
        title: title,
        width: 740,
        height: 700
    }).showModal();

}

// 访潜客户
function visitorRegister() {
    dialog({
        url: "partial/visitorRegister.jsp",
        title: '访潜客户',
        width: 450,
        height: 550,
        okValue: "确认",
        ok: function() {
            var iframe = $(window.parent.document).contents().find("[name=" + $(this)[0].id + "]")[0].contentWindow;
            iframe.addVisitor(this, document, window);
            return false;
        },
    }).showModal();

}
// 转卡中创建新会员
function show_create_mem() {
	var createGym = $("#gym").val();
    top.dialog({
        url: "partial/visitorRegister.jsp?gym="+createGym,
        title: '创建新会员',
        width: 450,
        height: 550,
        okValue: "确认",
        ok: function() {
        	var iframe = $(window.parent.document).contents().find("[name=" + $(this)[0].id + "]")[0].contentWindow;
            iframe.create_new_mem(this, document, window);
            return false;
        },
    }).showModal();

}

// 打开新入会窗口
function openAddMem() {
    var d = dialog({
        url: "partial/add_mem.jsp",
        title: '添加会员',
        width: 980,
        height: 720,
        okValue: "确定",
        ok: function() {
            var iframe = $(window.parent.document).contents().find("[name=" + $(this)[0].id + "]")[0].contentWindow;
            iframe.andMem(this);
            return false;
        },
        cancelValue: "取消",
        cancel: function() {
            return true;
        }
    }).showModal();
    d.title("添加会员<p class='sub-title'>请仔细填写以下信息，已是系统内潜在客户的自动选择潜在客户所属会籍，已有登记推荐会员的，自动记入所推荐会员</p>");
}
// 添加团课
function addPlan(win, doc) {
	$("#is_free").removeAttr("disabled");
	$("#recommendLesson").removeAttr("disabled");
	var plan_name = $("#f_plan__plan_name").val();
	if(plan_name == "" || plan_name == undefined){
		error("课程名不能为空");
		return;
	}
    // $.messager.progress();
    $('#f_planFormObj').form('submit', {
        url: "fit-action-lesson-addPlan",
        onSubmit: function(data) {
            var isValid = $(this).form('validate');
            if (!isValid) {
                $.messager.progress('close');
            }
            return isValid;
        },
        success: function(data) {
            $.messager.progress('close');
            var result = "当前系统繁忙";
            try {
                data = eval('(' + data + ')');
                result = data.rs;
            } catch(e) {
                try {
                    data = eval(data);
                    result = data.rs;
                } catch(e1) {}
            }
            if ("Y" == result) {
                callback_info("保存成功",
                function() {
                    doc.location.reload();
                });
            } else {
            	alert(result);
            }
        }
    });
}
// 添加排期
function addPaiQi(win, doc) {
    if ($("#f_plan__pt_id").val() == "") {
    	alert("请选择课程");
        return;
    }
    // 判断选择星期后是否填写课程时间
    var startPlan = Number($("#start").val().replace(/-/g, ""));
    var endPlan = Number($("#end").val().replace(/-/g, ""));
    if (startPlan > endPlan) {
    	alert("课程开始时间不能大于结束时间");
        return;
    }
    if ($("#startTime1").val() == "" && $("#endTime1").val() == "" && $("#startTime2").val() == "" && $("#endTime2").val() == "" && $("#startTime3").val() == "" && $("#endTime3").val() == "" && $("#startTime4").val() == "" && $("#endTime4").val() == "" && $("#startTime5").val() == "" && $("#endTime5").val() == "" && $("#startTime6").val() == "" && $("#endTime6").val() == "" && $("#startTime7").val() == "" && $("#endTime7").val() == "") {
    	alert("课程时间不能为空");
        return;
    }
    for (var i = 1; i <= 7; i++) {
        if ($(".sbs" + i).css("display") != 'none') {
            var start = Number($("#startTime" + i).val().replace(":", ""));
            var end = Number($("#endTime" + i).val().replace(":", ""));
            if ($("#startTime" + i).val() == "" && $("#endTime" + i).val() == "") {
            	alert("课程时间不能为空");
                return;
            } else if (start >= end) {
            	alert("课程开始时间不能大于结束时间");
                return;
            }
        }
    }
    $('#plan_list').form('submit', {
        url: "fit-action-lesson-addPaiQi",
        onSubmit: function(data) {
            var isValid = $(this).form('validate');
            if (!isValid) {
                $.messager.progress('close');
            }
            return isValid;
        },
        success: function(data) {
            $.messager.progress('close');
            var result = "当前系统繁忙";
            try {
                data = eval('(' + data + ')');
                result = data.rs;
            } catch(e) {
                try {
                    data = eval(data);
                    result = data.rs;
                } catch(e1) {}
            }
            if ("Y" == result) {
                callback_info("保存成功",
                function() {
                    win.close();
                });
            } else {
            	alert(result);
            }
        }
    });
}

// 切换时间
function serchTime(type) {
    if (type == 'next') {
        var nowTime = Number($("#searchStartTime").val());
        var now = new Date(nowTime);
        var day = now.getDay();
        var oneDayTime = 24 * 60 * 60 * 1000;

        // 显示周一
        var MondayTime = nowTime - (day - 1 - 7) * oneDayTime;
        var TuesdayTime = nowTime - (day - 2 - 7) * oneDayTime;
        var WednesdayTime = nowTime - (day - 3 - 7) * oneDayTime;
        var ThursdayTime = nowTime - (day - 4 - 7) * oneDayTime;
        var FridayTime = nowTime - (day - 5 - 7) * oneDayTime;
        var SaturdayTime = nowTime - (day - 6 - 7) * oneDayTime;
        // 显示周日
        var SundayTime = nowTime + (7 - day + 7) * oneDayTime;
        // 初始化日期时间
        var monday = new Date(MondayTime).format("MM月dd日");
        var sunday = new Date(SundayTime).format("MM月dd日");
        var searchMonday = new Date(MondayTime).format("yyyy-MM-dd");
        var searchTuesday = new Date(TuesdayTime).format("yyyy-MM-dd");
        var searchWednesday = new Date(WednesdayTime).format("yyyy-MM-dd");
        var searchThursday = new Date(ThursdayTime).format("yyyy-MM-dd");
        var searchFriday = new Date(FridayTime).format("yyyy-MM-dd");
        var searchSaturday = new Date(SaturdayTime).format("yyyy-MM-dd");
        var searchSunday = new Date(SundayTime).format("yyyy-MM-dd");
        var showDay = monday + "-" + sunday;
        $("#times").html(showDay);
        $("#searchStartTime").val(MondayTime);
        $("#searchEndTime").val(SundayTime);

        for (var i = 1; i <= 7; i++) {
            MondayTime = nowTime - (day - 7 - i) * oneDayTime;
            showWeek = new Date(MondayTime).format("MM-dd");
            $("#week" + i).html(showWeek);
        }
    }
    if (type == 'last') {
        var nowTime = Number($("#searchStartTime").val());
        var now = new Date(nowTime);
        var day = now.getDay();
        var oneDayTime = 24 * 60 * 60 * 1000;
        // 显示周一
        var MondayTime = nowTime - (day - 1 + 7) * oneDayTime;
        var TuesdayTime = nowTime - (day - 2 + 7) * oneDayTime;
        var WednesdayTime = nowTime - (day - 3 + 7) * oneDayTime;
        var ThursdayTime = nowTime - (day - 4 + 7) * oneDayTime;
        var FridayTime = nowTime - (day - 5 + 7) * oneDayTime;
        var SaturdayTime = nowTime - (day - 6 + 7) * oneDayTime;
        // 显示周日
        var SundayTime = nowTime + (7 - day - 7) * oneDayTime;
        // 初始化日期时间
        var monday = new Date(MondayTime).format("MM月dd日");
        var sunday = new Date(SundayTime).format("MM月dd日");
        var searchMonday = new Date(MondayTime).format("yyyy-MM-dd");
        var searchTuesday = new Date(TuesdayTime).format("yyyy-MM-dd");
        var searchWednesday = new Date(WednesdayTime).format("yyyy-MM-dd");
        var searchThursday = new Date(ThursdayTime).format("yyyy-MM-dd");
        var searchFriday = new Date(FridayTime).format("yyyy-MM-dd");
        var searchSaturday = new Date(SaturdayTime).format("yyyy-MM-dd");
        var searchSunday = new Date(SundayTime).format("yyyy-MM-dd");
        var showDay = monday + "-" + sunday;
        $("#times").html(showDay);
        $("#searchStartTime").val(MondayTime);
        $("#searchEndTime").val(SundayTime);
        for (var i = 1; i <= 7; i++) {
            MondayTime = nowTime - (day + 7 - i) * oneDayTime;
            var showWeek = new Date(MondayTime).format("MM-dd");
            $("#week" + i).html(showWeek);
        }
    }
    $.ajax({
        type: "POST",
        url: "fit-action-lesson-showPlan",
        data: {
            searchMonday: searchMonday,
            searchTuesday: searchTuesday,
            searchWednesday: searchWednesday,
            searchThursday: searchThursday,
            searchFriday: searchFriday,
            searchSaturday: searchSaturday,
            searchSunday: searchSunday
        },
        dataType: "json",
        async: false,
        success: function(data) {
            if (data.rs == "Y") {

                var listOne = data.listOne;
                var listTwo = data.listTwo;
                var listThree = data.listThree;
                var listFour = data.listFour;
                var listFive = data.listFive;
                var listSix = data.listSix;
                var listSeven = data.listSeven;
                var max = data.max;

                var showPlanHtml2 = getHtml(listOne, listTwo, listThree, listFour, listFive, listSix, listSeven, max);
                $('#planHtml').html(showPlanHtml2);
            } else {
            	alert(data.rs);
            }

        }
    });
}
// 显示团课拼接html，星期一到星期天分别输出出来
function getHtml(listOne, listTwo, listThree, listFour, listFive, listSix, listSeven, max) {
    if (max == 0) {
        var showPlanHtml2 = "<tr><td onclick='' class='align-center' colspan='7' style='height: 240px; background-position: center center; background-repeat: no-repeat;'><div class='none-info font-90'>暂无数据</div></td></tr>";
        $('#planHtml').html(showPlanHtml2);
        return;
    }
    var showPlanHtml = "";
    var showPlanHtml2 = "";
    for (var i = 0; i < max; i++) {
        if (listOne.length == max) {
            showPlanHtml += "<td onclick='showLesson(\"" + listOne[i].id + "\",\"" + listOne[i].plan_name + "\",\"" + listOne[i].plan_id + "\")' key='monday' class='align-center' style='width: 130px;'><div class='syllabusGroupWeekInfo'><p class='title'>" + listOne[i].plan_name + "</p><p class='time'>" + listOne[i].start_time + "-" + listOne[i].end_time + listOne[i].name + "</p><p class='subInfo'><img src='partial/lessionplan/files/group.png'><span>" + listOne[i].plan_state + "</span></p></div></td>"
        } else {
            if (listOne.length - 1 >= i) {
                showPlanHtml += "<td onclick='showLesson(\"" + listOne[i].id + "\",\"" + listOne[i].plan_name + "\",\"" + listOne[i].plan_id + "\")' key='monday' class='align-center' style='width: 130px;'><div class='syllabusGroupWeekInfo'><p class='title'>" + listOne[i].plan_name + "</p><p class='time'>" + listOne[i].start_time + "-" + listOne[i].end_time + listOne[i].name + "</p><p class='subInfo'><img src='partial/lessionplan/files/group.png'><span>" + listOne[i].plan_state + "</span></p></div></td>"
            } else {
                showPlanHtml += "<td key='monday' class='align-center' style='width: 130px;'><div class='syllabusGroupWeekInfo'><p class='title'></p><p class='time'></p><p class='subInfo'></p></div></td>"
            }
        }
        if (listTwo.length == max) {
            showPlanHtml += "<td onclick='showLesson(\"" + listTwo[i].id + "\",\"" + listTwo[i].plan_name + "\",\"" + listTwo[i].plan_id + "\")' key='monday' class='align-center' style='width: 130px;'><div class='syllabusGroupWeekInfo'><p class='title'>" + listTwo[i].plan_name + "</p><p class='time'>" + listTwo[i].start_time + "-" + listTwo[i].end_time + listTwo[i].name + "</p><p class='subInfo'><img src='partial/lessionplan/files/group.png'><span>" + listTwo[i].plan_state + "</span></p></div></td>"
        } else {
            if (listTwo.length - 1 >= i) {
                showPlanHtml += "<td onclick='showLesson(\"" + listTwo[i].id + "\",\"" + listTwo[i].plan_name + "\",\"" + listTwo[i].plan_id + "\")' key='monday' class='align-center' style='width: 130px;'><div class='syllabusGroupWeekInfo'><p class='title'>" + listTwo[i].plan_name + "</p><p class='time'>" + listTwo[i].start_time + "-" + listTwo[i].end_time + listTwo[i].name + "</p><p class='subInfo'><img src='partial/lessionplan/files/group.png'><span>" + listTwo[i].plan_state + "</span></p></div></td>"
            } else {
                showPlanHtml += "<td key='monday' class='align-center' style='width: 130px;'><div class='syllabusGroupWeekInfo'><p class='title'></p><p class='time'></p><p class='subInfo'></p></div></td>"
            }
        }
        if (listThree.length == max) {
            showPlanHtml += "<td onclick='showLesson(\"" + listThree[i].id + "\",\"" + listThree[i].plan_name + "\",\"" + listThree[i].plan_id + "\")' key='monday' class='align-center' style='width: 130px;'><div class='syllabusGroupWeekInfo'><p class='title'>" + listThree[i].plan_name + "</p><p class='time'>" + listThree[i].start_time + "-" + listThree[i].end_time + listThree[i].name + "</p><p class='subInfo'><img src='partial/lessionplan/files/group.png'><span>" + listThree[i].plan_state + "</span></p></div></td>"
        } else {
            if (listThree.length - 1 >= i) {
                showPlanHtml += "<td onclick='showLesson(\"" + listThree[i].id + "\",\"" + listThree[i].plan_name + "\",\"" + listThree[i].plan_id + "\")' key='monday' class='align-center' style='width: 130px;'><div class='syllabusGroupWeekInfo'><p class='title'>" + listThree[i].plan_name + "</p><p class='time'>" + listThree[i].start_time + "-" + listThree[i].end_time + listThree[i].name + "</p><p class='subInfo'><img src='partial/lessionplan/files/group.png'><span>" + listThree[i].plan_state + "</span></p></div></td>"
            } else {
                showPlanHtml += "<td key='monday' class='align-center' style='width: 130px;'><div class='syllabusGroupWeekInfo'><p class='title'></p><p class='time'></p><p class='subInfo'></p></div></td>"
            }
        }
        if (listFour.length == max) {
            showPlanHtml += "<td onclick='showLesson(\"" + listFour[i].id + "\",\"" + listFour[i].plan_name + "\",\"" + listFour[i].plan_id + "\")' key='monday' class='align-center' style='width: 130px;'><div class='syllabusGroupWeekInfo'><p class='title'>" + listFour[i].plan_name + "</p><p class='time'>" + listFour[i].start_time + "-" + listFour[i].end_time + listFour[i].name + "</p><p class='subInfo'><img src='partial/lessionplan/files/group.png'><span>" + listFour[i].plan_state + "</span></p></div></td>"
        } else {
            if (listFour.length - 1 >= i) {
                showPlanHtml += "<td onclick='showLesson(\"" + listFour[i].id + "\",\"" + listFour[i].plan_name + "\",\"" + listFour[i].plan_id + "\")' key='monday' class='align-center' style='width: 130px;'><div class='syllabusGroupWeekInfo'><p class='title'>" + listFour[i].plan_name + "</p><p class='time'>" + listFour[i].start_time + "-" + listFour[i].end_time + listFour[i].name + "</p><p class='subInfo'><img src='partial/lessionplan/files/group.png'><span>" + listFour[i].plan_state + "</span></p></div></td>"
            } else {
                showPlanHtml += "<td key='monday' class='align-center' style='width: 130px;'><div class='syllabusGroupWeekInfo'><p class='title'></p><p class='time'></p><p class='subInfo'></p></div></td>"
            }
        }
        if (listFive.length == max) {
            showPlanHtml += "<td onclick='showLesson(\"" + listFive[i].id + "\",\"" + listFive[i].plan_name + "\",\"" + listFive[i].plan_id + "\")' key='monday' class='align-center' style='width: 130px;'><div class='syllabusGroupWeekInfo'><p class='title'>" + listFive[i].plan_name + "</p><p class='time'>" + listFive[i].start_time + "-" + listFive[i].end_time + listFive[i].name + "</p><p class='subInfo'><img src='partial/lessionplan/files/group.png'><span>" + listFive[i].plan_state + "</span></p></div></td>"
        } else {
            if (listFive.length - 1 >= i) {
                showPlanHtml += "<td onclick='showLesson(\"" + listFive[i].id + "\",\"" + listFive[i].plan_name + "\",\"" + listFive[i].plan_id + "\")' key='monday' class='align-center' style='width: 130px;'><div class='syllabusGroupWeekInfo'><p class='title'>" + listFive[i].plan_name + "</p><p class='time'>" + listFive[i].start_time + "-" + listFive[i].end_time + listFive[i].name + "</p><p class='subInfo'><img src='partial/lessionplan/files/group.png'><span>" + listFive[i].plan_state + "</span></p></div></td>"
            } else {
                showPlanHtml += "<td key='monday' class='align-center' style='width: 130px;'><div class='syllabusGroupWeekInfo'><p class='title'></p><p class='time'></p><p class='subInfo'></p></div></td>"
            }
        }
        if (listSix.length == max) {
            showPlanHtml += "<td onclick='showLesson(\"" + listSix[i].id + "\",\"" + listSix[i].plan_name + "\",\"" + listSix[i].plan_id + "\")' key='monday' class='align-center' style='width: 130px;'><div class='syllabusGroupWeekInfo'><p class='title'>" + listSix[i].plan_name + "</p><p class='time'>" + listSix[i].start_time + "-" + listSix[i].end_time + listSix[i].name + "</p><p class='subInfo'><img src='partial/lessionplan/files/group.png'><span>" + listSix[i].plan_state + "</span></p></div></td>"
        } else {
            if (listSix.length - 1 >= i) {
                showPlanHtml += "<td onclick='showLesson(\"" + listSix[i].id + "\",\"" + listSix[i].plan_name + "\",\"" + listSix[i].plan_id + "\")' key='monday' class='align-center' style='width: 130px;'><div class='syllabusGroupWeekInfo'><p class='title'>" + listSix[i].plan_name + "</p><p class='time'>" + listSix[i].start_time + "-" + listSix[i].end_time + listSix[i].name + "</p><p class='subInfo'><img src='partial/lessionplan/files/group.png'><span>" + listSix[i].plan_state + "</span></p></div></td>"
            } else {
                showPlanHtml += "<td key='monday' class='align-center' style='width: 130px;'><div class='syllabusGroupWeekInfo'><p class='title'></p><p class='time'></p><p class='subInfo'></p></div></td>"
            }
        }
        if (listSeven.length == max) {
            showPlanHtml += "<td onclick='showLesson(\"" + listSeven[i].id + "\",\"" + listSeven[i].plan_name + "\",\"" + listSeven[i].plan_id + "\")' key='monday' class='align-center' style='width: 130px;'><div class='syllabusGroupWeekInfo'><p class='title'>" + listSeven[i].plan_name + "</p><p class='time'>" + listSeven[i].start_time + "-" + listSeven[i].end_time + listSeven[i].name + "</p><p class='subInfo'><img src='partial/lessionplan/files/group.png'><span>" + listSeven[i].plan_state + "</span></p></div></td>"
        } else {
            if (listSeven.length - 1 >= i) {
                showPlanHtml += "<td onclick='showLesson(\"" + listSeven[i].id + "\",\"" + listSeven[i].plan_name + "\",\"" + listSeven[i].plan_id + "\")' key='monday' class='align-center' style='width: 130px;'><div class='syllabusGroupWeekInfo'><p class='title'>" + listSeven[i].plan_name + "</p><p class='time'>" + listSeven[i].start_time + "-" + listSeven[i].end_time + listSeven[i].name + "</p><p class='subInfo'><img src='partial/lessionplan/files/group.png'><span>" + listSeven[i].plan_state + "</span></p></div></td>"
            } else {
                showPlanHtml += "<td key='monday' class='align-center' style='width: 130px;'><div class='syllabusGroupWeekInfo'><p class='title'></p><p class='time'></p><p class='subInfo'></p></div></td>"
            }
        }

        showPlanHtml2 += "<tr>" + showPlanHtml + "</tr>";
        showPlanHtml = "";
    }
    return showPlanHtml2;
}
// 查看排期
function showPaiQi(id) {
    dialog({
        url: "partial/lessionplan/showPaiQi.jsp?id=" + id,
        title: "查看排期",
        width: 500,
        height: 450,
        cancelValue: "取消",
        cancel: function() {
            return true;
        }
    }).showModal();
}
// 删除排期
function deletePlan(id) {
    var $ret = window.confirm("确定删除此条数据吗，如果删除将不可恢复?");
    if ($ret) {
        $.ajax({
            type: "POST",
            url: "fit-action-lesson-deletePlan",
            data: {
                id: id
            },
            dataType: "json",
            async: false,
            success: function(data) {
                if (data.rs == "Y") {
                    alert("删除成功");
                    location.reload();
                } else {
                	alert(data.rs);
                }

            }
        });
    }
}
// 编辑排期
function editPaiQi(id) {
    dialog({
        url: "partial/lessionplan/editPaiQi.jsp?id=" + id,
        title: "编辑排期",
        width: 900,
        height: 700,
        cancelValue: "取消",
        cancel: function() {
            return true;
        }
    }).showModal();
}
// 修改课程时间
function showEditTime(id) {
    top.dialog({
        url: "partial/lessionplan/editTime.jsp?id=" + id,
        title: "修改时间",
        width: 500,
        height: 200,
        okValue: "确定",
        ok: function() {
            var iframe = $(window.parent.document).contents().find("[name=" + top.dialog.getCurrent().id + "]")[0].contentWindow;
            iframe.editTime(this, document, window);
            return false;
        },
        cancelValue: "取消",
        cancel: function() {
            return true;
        }
    }).showModal();
}
// 取消课程
function cencelLesson(id) {
    top.dialog({
        title: '确认取消课程',
        content: '你确定要取消选择的课程吗?',
        okValue: "确定",
        ok: function() {
            var iframe = $(window.parent.document).contents().find("div[i=dialog]:first iframe")[0].contentWindow;
            iframe.isCancelLesson(this, document, window, id);
            return false;
        },
        cancelValue: "取消",
        cancel: function() {
            return true;
        }
    }).showModal();
}
// 确认取消课程
function isCancelLesson(win, doc, window, id) {
    $.ajax({
        type: "POST",
        url: "fit-action-lesson-cancelLesson",
        data: {
            id: id
        },
        dataType: "json",
        async: false,
        success: function(data) {
            if (data.rs == "Y") {

                window.location.reload();

            } else {
            	alert(data.rs);
            }

        }
    });
}
// 显示课程详情
function showLesson(id, name, plan_id) {
    dialog({
        url: "partial/lessionplan/showLesson.jsp?id=" + id + "&plan_id=" + plan_id+"&plan_name="+name,
        title: name,
        width: 900,
        height: 500,
        cancelValue: "取消",
        cancel: function() {
            return true;
        }
    }).showModal();

}
// 显示修改团课
function showEditPlan(id) {
    top.dialog({
        url: "fit-action-lesson-detailPlan?id=" + id + "&nextpage=partial/lessionplan/editLession.jsp",
        title: "修改团课信息",
        width: 1000,
        height: 540,
        okValue: "确定",
        ok: function() {
            var iframe = $(window.parent.document).contents().find("[name=" + $(this)[0].id + "]")[0].contentWindow;
            iframe.editPlan(this, document, window);
            return false;
        },
        cancelValue: "取消",
        cancel: function() {
            return true;
        }
    }).showModal();

}
// 修改团课
function editPlan(win, doc, window) {
    $('#f_planFormObj').form('submit', {
        url: "fit-action-lesson-editPlan",
        onSubmit: function(data) {
            var isValid = $(this).form('validate');
            if (!isValid) {
                $.messager.progress('close');
            }
            return isValid;
        },
        success: function(data) {
            $.messager.progress('close');
            var result = "当前系统繁忙";
            try {
                data = eval('(' + data + ')');
                result = data.rs;
            } catch(e) {
                try {
                    data = eval(data);
                    result = data.rs;
                } catch(e1) {}
            }
            if ("Y" == result) {
                callback_info("保存成功",
                function() {
                	doc.location.reload();
                });
            } else {
            	alert(result);
            }
        }
    });
}
// 搜索排期
function searchPaiQi() {
    // 获取搜索的内容
    var plan_name = $("#plan_name").val();
    var coach = $("#coach").val();
    var address = $("#address").val();
    $.ajax({
        type: "POST",
        url: "fit-action-lesson-showPaiQi",
        data: {
            plan_name: plan_name,
            coach: coach,
            address: address,
            type: 'search',
        },
        dataType: "json",
        async: false,
        success: function(data) {
            if (data.rs == "Y") {
                var list = data.list;
                var showPaiQiHtml = "";
                var showPaiQiHtml2 = "";
                for (var i = 0; i < list.length; i++) {
                    showPaiQiHtml += "<td key='plan_name' class='align-center' style='width: 200px;'>" + list[i].plan_name + "</td><td key='plan_name' class='align-center' style='width: 200px;'>" + list[i].name + "</td><td key='plan_name' class='align-center' style='width: 346px;'>" + list[i].start_time.substring(0, 10) + "至" + list[i].end_time.substring(0, 10) + "</td><td key='plan_name' class='align-center' style='width: 200px;'>" + "<button class='btn btn-sm' onclick='showPaiQi(\"" + list[i].id + "\")'>查看</button>" + "</td><td key='plan_name' class='align-center' style='width: 200px;'>" + list[i].num + "</td><td key='plan_name' class='align-center' style='width: 200px;'>" + list[i].emp_name + "</td><td key='plan_name' class='align-center' style='width: 200px;'>" + list[i].create_time.substring(0, 16) + "</td><td key='plan_name' class='align-center' style='width: 200px;'><button class='btn btn-sm' onclick='editPaiQi(\"" + list[i].plan_list_id + "\")'>编辑</button><button class='btn btn-sm' name='remove' onclick='deletePlan(\"" + list[i].plan_list_id + "\")'>删除</button>";
                    showPaiQiHtml2 += "<tr>" + showPaiQiHtml + "</tr>";
                    showPaiQiHtml = "";
                }
                $("#showPaiQi").html(showPaiQiHtml2);

            } else {
            	alert(data.rs);
            }

        }
    });
}
// 搜索排期状态
function searchPlan(id) {
    var dayTiem = $("#dayTime").val();
    var state = $("#state option:selected").val();
    $.ajax({
        type: "POST",
        url: "fit-action-lesson-showEditPlan",
        data: {
            id: id,
            type: 'search',
            dayTime: dayTiem,
            state: state
        },
        dataType: "json",
        async: false,
        success: function(data) {
            if (data.rs == "Y") {
                var planTpl = document.getElementById('planTpl').innerHTML;
                var planTplHtml = template(planTpl, {
                    list: data.list
                });
                $('#planDiv').html(planTplHtml);

            } else {
            	alert(data.rs);
            }

        }
    });

}
// 查询课程
function searchLesson(id) {
    var phone = $("#phone").val();
    var userName = $("#userName").val();

    $.ajax({
        type: "POST",
        url: "fit-action-lesson-showLessonDetail",
        data: {
            id: id,
            type: 'search',
            phone: phone,
            userName: userName
        },
        dataType: "json",
        async: false,
        success: function(data) {
            if (data.rs == "Y") {
                var list = data.list;
                var planTpl = document.getElementById('planTpl').innerHTML;
                var planTplHtml = template(planTpl, {
                    list: data.list
                });
                var week = "";
                if (list[0].week == 1) {
                    week = "星期天";
                }
                if (list[0].week == 2) {
                    week = "星期一";
                }
                if (list[0].week == 3) {
                    week = "星期二";
                }
                if (list[0].week == 4) {
                    week = "星期三";
                }
                if (list[0].week == 5) {
                    week = "星期四";
                }
                if (list[0].week == 6) {
                    week = "星期五";
                }
                if (list[0].week == 7) {
                    week = "星期六";
                }
                var startTime = list[0].start_time;
                var endTime = list[0].end_time;
                $("#lessonTime").html(week + startTime + "-" + endTime);
                if (list.length < 2) {
                    planTplHtml += "<tr><td class=align-center' colspan='7' style='text-align: center;vertical-align:middle;height: 240px; background-position: center center; background-repeat: no-repeat;'><div class='none-info font-90'>暂无数据</div></td></tr>";
                }
                $('#planDiv').html(planTplHtml);
            } else {
            	alert(data.rs);
            }

        }
    });
}
function cancelYuYue(id,detail_id) {
    top.dialog({
        title: '确认取消预约',
        content: '你确定要取消预约的课程吗?',
        okValue: "确定",
        ok: function() {
            var iframe = $(window.parent.document).contents().find("div[i=dialog]:first iframe")[0].contentWindow;
            iframe.isCancelYuYue(this, document, window, id,detail_id);
            return false;
        },
        cancelValue: "取消",
        cancel: function() {
            return true;
        }
    }).showModal();
}

function isCancelYuYue(win, doc, window, id,detail_id) {
    $.ajax({
        type: "POST",
        url: "fit-action-lesson-cancelYuYue",
        data: {
            id: id,
            detail_id : detail_id
        },
        dataType: "json",
        async: false,
        success: function(data) {
            if (data.rs == "Y") {

                window.location.reload();

            } else {
            	alert(data.rs);
            	window.location.reload();
            }

        }
    });
}

// 添加团课
function planLessionTuan() {
    var url = "partial/lessionplan/editLession.jsp";
    dialog({
        url: url,
        title: "添加团课",
        width: 1000,
        height: 540,
        okValue: "确定",
        ok: function() {
            var iframe = $(window.parent.document).contents().find("div[i=dialog]:first iframe")[0].contentWindow;
            iframe.addPlan(this, document);
            return false;
        },
        cancelValue: "取消",
        cancel: function() {
            return true;
        }
    }).showModal();
}
// 显示设置团课预约页面
function showSetPlanOrder() {
    dialog({
        url: "partial/lessionplan/setPlanOrder.jsp",
        title: "团课预约时限",
        width: 700,
        height: 240,
        okValue: "确定",
        ok: function() {
            var iframe = $(window.parent.document).contents().find("div[i=dialog]:first iframe")[0].contentWindow;
            iframe.setPlanOrder(this, document);
            return false;
        },
        cancelValue: "取消",
        cancel: function() {
            return true;
        }
    }).showModal();

}
// 获取当天的团课信息
function getPlan() {
    $.ajax({
        type: "POST",
        url: "fit-action-lesson-getNowPlan",
        dataType: "json",
        async: false,
        success: function(data) {
            if (data.rs == "Y") {
                var planTpl = document.getElementById('planTpl').innerHTML;
                var planTplHtml = template(planTpl, {
                    list: data.list
                });
                $('#planDiv').html(planTplHtml);
                
                $(".btn-sm").click(function(){
    				yuyin_bobao(data);
    			});
                
            } else {
            	alert(data.rs);
            }

        },
        error: function() {
            alert("链接失败");
        }
    });
}

function yuyin_bobao(data){
	var text = "";
	if(data.list && data.list.length>0){
		for(var i=0;i<data.list.length;i++){
			var cls = data.list[i];
			
			var start_time = new Date().Format("yyyy-MM-dd ") +cls.start_time+":00";
			start_time = new Date(start_time).getTime(); 
			var end_time = new Date().Format("yyyy-MM-dd ") +cls.end_time+":00";
			end_time = new Date(end_time).getTime(); 
			var now = new Date().getTime();
			if((start_time > new Date().getTime()) && (start_time - new Date().getTime() <= (1000*1800))){
				var id = cls.id;
				text += "各位小伙伴们请注意,课程"+cls.plan_name+"即将在"+cls.start_time+"开课,请做好准备。" 
			}else if(end_time >= now && start_time <= now){
				text += "各位小伙伴们请注意,课程"+cls.plan_name+"已经在"+cls.start_time+"开课,还没有去上课的小伙伴请抓紧时间。" 
			}
		}
	}
	playYuyin(text);
}
function playYuyin(text){
	if(text != ""){
		$("iframe[name=yuyin_iframe]").remove();
		var iframe = document.createElement("iframe");// IE可用
		iframe.name = 'yuyin_iframe'
			document.body.appendChild(iframe);
		$(iframe).hide();
		
		$(iframe).attr("src","http://tts.baidu.com/text2audio?lan=zh&pid=101&ie=UTF-8&text="+text+"&spd=5");
	}
}
// 查看会员是否有租柜
function getBox(id){
	$.ajax({
        type: "POST",
        url: "fit-box-getMemBox",
        dataType: "json",
        data: {
            id: id
        },
        async: false,
        success: function(data) {
            if (data.rs == "Y") {
               var list = data.list;
               var area_no = "";
               var box_no = "";
               var boxHtml = "";
               for(var i = 0;i<list.length;i++){
            	   area_no = list[i].area_no;
            	   box_no = list[i].box_no;
            	   boxHtml +=(area_no+"区"+box_no+"号;")
               }
               if(boxHtml.length>0){
            	   $('#boxSpan_li').show();
            	   $("#boxSpan").html(boxHtml);
               }else{
            	   $('#boxSpan_li').hide();
               }
            } else {
            	alert(data.rs);
            }

        },
        error: function() {
            alert("链接失败");
        }
    });
	
}
// 代约课
function showHelpOrderLesson(id){
	top.dialog({
        url: "partial/lessionplan/showHelpOrderLesson.jsp",
        title: "代约课",
        width: 360,
        height: 100,
        okValue: "确定",
        ok: function() {
            var iframe = $(window.parent.document).contents().find("[name=" + $(this)[0].id + "]")[0].contentWindow;
            iframe.order_lesson(this, document,id);
            return false;
        },
        cancelValue: "取消",
        cancel: function() {
            return true;
        }
    }).showModal();
	
}


// 约课
function order_lesson(mem_id,plan_list_id,plan_id){
	$.ajax({
        type: 'POST',
        url: 'fit-action-lesson-orderLesson',
        dataType: 'json',
        data:{
        	plan_list_id : plan_list_id,
        	mem_id : mem_id,
        	plan_id : plan_id
        },
        success: function(data) {
            if (data.rs == "Y") {
            	alert("约课成功");
            	window.location.reload();
            }else{
            	alert(data.rs);
            } 
        },
        error: function(xhr, type) {
            error("您的网速不给力啊，再来一次吧");
        }
    })
}
// App新入会审核
function showAppMemExamine(){
	dialog({
        url: "partial/newMemExamine.jsp",
        title: "购卡审核",
        width: 860,
        height: 500,
        cancelValue: "取消",
        cancel: function() {
            return true;
        }
    }).showModal();
}

// 私教状态
function showPtState(){
	dialog({
        url: "partial/ptState.jsp",
        title: "今日教练状态表",
        width: 960,
        height: 600,
        cancelValue: "关闭",
        cancel: function() {
            return true;
        }
    }).showModal();
}
// 解绑
function Unbundled(type) {
    if ("sales" == type) {
        $("#salesName").html("点击选择会籍");
        $("#sales").val("");
    }
    if ("coach" == type) {
        $("#coachName").html("点击选择教练");
        $("#coach").val("");
    }
    if ("mem" == type) {
        $("#memName").html("点击选择会员");
        $("#mem_id").val("");
    }
}
// 设置是否打印小票
function showSetPrint(){
	var url = "partial/f_set_print.jsp";
	dialog(
			{
				url : url,
				title : "入场系统设置",
				width : 400,
				height : 300,
				okValue : "确定",
				ok : function() {
				var iframe = $(window.parent.document).contents().find("[name=" + $(this)[0].id + "]")[0].contentWindow;
				iframe.setPrint(this, document);
				return false;
			},

				cancelValue : "取消",
				cancel : function() {
					return true;
				}
			}).showModal();
}
function checkIn(conf,fk_user_id,fk_user_gym,userName,gymName,sex) {
	var enterCardSelect = $("#enterCardSelect").val();
	var checkInNo = $("#checkInNo").val();
	var box = $("#boxSpan").html();
	$.ajax({
	    type: "POST",
	    url: "fit-userinfo-checkIn",
	    data: {
	        fk_user_id: fk_user_id,
	        checkin_user_card_id: enterCardSelect,
	        hand_no: checkInNo,
	        fk_user_gym: fk_user_gym,
	        conf: conf
	    },
	    dataType: "json",
	    async: false,
	    success: function(data) {
	    	console.log(data);
	        if (data.confirm == "Y") {
	            top.dialog({
	                title: '提示',
	                content: "本次入场需要扣费：￥" + data.fee,
	                okValue: '确定',
	                ok: function() {
	                    if (box != "" && box != undefined) {
	                        alert("用户已租柜" + box);
	                    }
	                    // 打印小票
	                    $.ajax({
	                        type: "POST",
	                        url: "fit-userinfo-checkIn",
	                        data: {
	                            fk_user_id: fk_user_id,
	                            checkin_user_card_id: enterCardSelect,
	                            hand_no: checkInNo,
	                            fk_user_gym: fk_user_gym,
	                            conf: "Y"
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
	                        	    box : box
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
	                        	setTimeout(function() {
	                        	    parent.location.reload();
	                        	},
	                        	1000);
	                        }
	                    });

	                },
	                cancelValue: '取消',
	                cancel: function() {}
	            }).showModal();
	        } else if (data.confirm == "N") {
	            if (box != "" && box != undefined) {
	                alert("用户已租柜" + box);
	            }
	            alert("入场成功");
	            
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
            	setTimeout(function() {
            	    parent.location.reload();
            	},
            	1000);
	        } else {
	        	if(sex!=""&& sex!=null&&sex!=undefined){
	        		showMemInfo(fk_user_id,userName,fk_user_gym,gymName,sex);
	        		$('#mem_info').val("");
	        	}else{
	        		alert(data.rs);
	        	}
	        }
	    }
	});
}
