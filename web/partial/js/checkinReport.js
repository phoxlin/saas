//入场报表
function showTodayReport(){
	dialog({
        url: "partial/report/showTodayReportCheckin.jsp",
        title: "入场报表",
        width: 1000,
        height: 480,
        cancelValue: "取消",
        cancel: function() {
            return true;
        }
    }).showModal();
	
}
//入场报表分页
function checkinReportSearch(cur,search) {
	//隐藏日期输入框
	$("#date_div").hide();
    $.ajax({
        type: "POST",
        url: "fit-query-chekinReport",
        data: {
            cur: cur,
            type : "",
            search : search,
            searchKey : $("#searchMem").val()
        },
        dataType: "json",
        success: function(data) {
            if (data.rs == "Y") {
            	var tpl = document.getElementById("todayCheckinReportTpl").innerHTML;
				content = template(tpl, {
					list : data,
					type : ""
				});
				$("#todayCheckinReport").html(content);
				$("#allNums").html(data.allNums)
                var btn = "<button onclick='checkinReportSearch(1,1)'>搜索</button>";
				$("#searchBtn").html(btn);
            } else {
            	error(data.rs);
            }

        }
    });
}
//报表里查看会员信息
function reportShowMemInfo(id, userName, gym, gymName, sex) {
    top.dialog({
        url: "partial/mem_info.jsp?fk_user_id=" + id + "&fk_user_gym=" + gym,
        title: '会员[' + userName + '] - [' + gymName + '] - ' + sex,
        width: 740,
        height: 700
    }).showModal();

}
//今日出入场
function inOutMem(cur,search) {
	//隐藏日期输入框
	$("#date_div").hide();
    $.ajax({
        type: "POST",
        url: "fit-query-chekinReport",
        data: {
            cur: cur,
            type : "inOut",
            search : search,
            searchKey : $("#searchMem").val()
        },
        dataType: "json",
        success: function(data) {
            if (data.rs == "Y") {
                var recentCheckinTpl = document.getElementById('todayCheckinReportTpl').innerHTML;
                var recentCheckinTplHtml = template(recentCheckinTpl, {
                    list: data,
                    type : "inOut"
                });
                $('#todayCheckinReport').html(recentCheckinTplHtml);
                $("#allNums").html(data.allNums)
                var btn = "<button onclick='inOutMem(1,1)'>搜索</button>";
				$("#searchBtn").html(btn);
            } else {
            	error(data.rs);
            }

        }
    });
}
//总出入场
function allInOutMem(cur,search) {
	
	var start_time = $("#start_time").val();
	var end_time = $("#end_time").val();
	$.ajax({
		type: "POST",
		url: "fit-query-chekinReport",
		data: {
			cur: cur,
			type : "allInOutMem",
			search : search,
			searchKey : $("#searchMem").val(),
			start_time : start_time,
			end_time : end_time
		},
		dataType: "json",
		success: function(data) {
			if (data.rs == "Y") {
				var recentCheckinTpl = document.getElementById('todayCheckinReportTpl').innerHTML;
				var recentCheckinTplHtml = template(recentCheckinTpl, {
					list: data,
					type : "allInOut"
				});
				$('#todayCheckinReport').html(recentCheckinTplHtml);
				$("#allNums").html(data.allNums)
				var btn = "<button onclick='allInOutMem(1,1)'>搜索</button>";
				$("#searchBtn").html(btn);
				var startTime = data.start_time;
				var endTime = data.end_time;
				if(startTime !=undefined && startTime.length >0){
					$("#start_time").val(startTime);
				}
				if(endTime !=undefined && endTime.length >0){
					$("#end_time").val(endTime);
				}
				//显示日期输入框
				$("#date_div").show();
			} else {
				error(data.rs);
			}
			
		}
	});
}