<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.db.Entity"%>
<%@page import="com.jinhua.server.tools.UI"%>
<%@page import="com.jinhua.server.tools.UI_Op"%>
<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	FitUser user = (FitUser)SystemUtils.getSessionUser(request, response);
	if (user == null|| !user.hasPower("sm_classTable")){
		request.getRequestDispatcher("/").forward(request, response);
	}
	String cust_name = user.getCust_name();
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>课程管理 </title>
<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<script src="public/sb_admin2/bower_components/jquery/dist/jquery.min.js"></script>
<link type="text/css" href="partial/lessionplan/files/bootstrap.css" rel="stylesheet" media="screen">
<link type="text/css" href="partial/lessionplan/files/panel.css" rel="stylesheet" media="screen">
<link type="text/css" href="public/sb_admin2/bower_components/font-awesome/css/font-awesome.min.css" rel="stylesheet" media="screen">
<link type="text/css" href="public/fit/css/Base.css" rel="stylesheet" media="screen">
<link rel="stylesheet" type="text/css" href="public/sb_admin2/bower_components/artDialog7/css/dialog.css">
<link rel="stylesheet" type="text/css" href="public/css/header.css">
<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/artDialog7/dialog.js"></script>
<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/artDialog7/dialog-plus.js"></script>
<script type="text/javascript" src="partial/js/cashier.js"></script>
<script type="text/javascript" charset="utf-8" src="public/js/template.js"></script>
<script type="text/javascript">
//添加排期
function planLession(){
    var url = "partial/lessionplan/addPaiQi.jsp";
    dialog({
        url: url,
        title: "添加排期",
        width: 800,
        height: 540,
        okValue: "确定",
        ok: function() {
            var iframe = $(window.parent.document).contents().find("div[i=dialog]:first iframe")[0].contentWindow;
            iframe.addPaiQi(this, document);
            return false;
        },
        cancelValue: "取消",
        cancel: function() {
            return true;
        }
    }).showModal();
}
	$(function(){
		show_plan();
	});
	
	Date.prototype.format = function(fmt) { 
	     var o = { 
	        "M+" : this.getMonth()+1,                 //月份 
	        "d+" : this.getDate(),                    //日 
	        "h+" : this.getHours(),                   //小时 
	        "m+" : this.getMinutes(),                 //分 
	        "s+" : this.getSeconds(),                 //秒 
	        "q+" : Math.floor((this.getMonth()+3)/3), //季度 
	        "S"  : this.getMilliseconds()             //毫秒 
	    }; 
	    if(/(y+)/.test(fmt)) {
	            fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length)); 
	    }
	     for(var k in o) {
	        if(new RegExp("("+ k +")").test(fmt)){
	             fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));
	         }
	     }
	    return fmt; 
	}        
	
function show_plan(){
	var now = new Date(); 
	var nowTime = now.getTime() ; 
	var day = now.getDay();
	var oneDayTime = 24*60*60*1000 ; 

	//显示周一
	var MondayTime = nowTime - (day-1)*oneDayTime ; 
	var TuesdayTime = nowTime - (day-2)*oneDayTime ; 
	var WednesdayTime = nowTime - (day-3)*oneDayTime ; 
	var ThursdayTime = nowTime - (day-4)*oneDayTime ; 
	var FridayTime = nowTime - (day-5)*oneDayTime ; 
	var SaturdayTime = nowTime - (day-6)*oneDayTime ; 
	//显示周日
	var SundayTime =  nowTime + (7-day)*oneDayTime ; 
	//初始化日期时间
	var monday = new Date(MondayTime).format("MM月dd日");
	var sunday = new Date(SundayTime).format("MM月dd日");
	var searchMonday = new Date(MondayTime).format("yyyy-MM-dd");
	var searchTuesday = new Date(TuesdayTime).format("yyyy-MM-dd");
	var searchWednesday = new Date(WednesdayTime).format("yyyy-MM-dd");
	var searchThursday = new Date(ThursdayTime).format("yyyy-MM-dd");
	var searchFriday = new Date(FridayTime).format("yyyy-MM-dd");
	var searchSaturday = new Date(SaturdayTime).format("yyyy-MM-dd");
	var searchSunday = new Date(SundayTime).format("yyyy-MM-dd");
	var showDay = monday+"-"+sunday;
	$("#times").html(showDay);
	$("#searchStartTime").val(MondayTime);
	$("#searchEndTime").val(SundayTime);
	for (var i = 1; i <= 7; i++) {
		MondayTime = nowTime - (day - i) * oneDayTime;
		var showWeek = new Date(MondayTime).format("MM-dd");
		$("#week" + i).html(showWeek);
	}
	$.ajax({
        type: "POST",
        url: "fit-action-lesson-showPlan",
        data: {
        	searchMonday : searchMonday,
        	searchTuesday : searchTuesday,
        	searchWednesday : searchWednesday,
        	searchThursday : searchThursday,
        	searchFriday : searchFriday,
        	searchSaturday : searchSaturday,
        	searchSunday : searchSunday
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
            	
            	var showPlanHtml2 = getHtml(listOne,listTwo,listThree,listFour,listFive,listSix,listSeven,max)
                $('#planHtml').html(showPlanHtml2);
            } else {
                error(data.rs);
            }

        }
    });
}

</script>
</head>
<body class="panel">
	<div class="page-wrapper">
		<jsp:include page="../../public/header.jsp"></jsp:include>
		<div class="page-main page-main-cashier" style="width: 1200px;">
			<div class="nav-bar">
				<a href="main.jsp" class="back">
					<p>
						<i class="fa fa-arrow-left"></i> 
						<span>返回主页</span>
					</p>
				</a>
				<ul>
					<li>
					
						<a class="cur">
							<p>
								<i class="fa fa-map-marker"></i><span>课程管理</span>
							</p>
						</a>
						<a href="javascript:;" class="subscribeTimeLimit" onclick="showSetPlanOrder()">
							<p>
								<i class="fa fa-cog"></i><span>团课预约时限</span>
							</p>
					</a> 
					<a href="javascript:;" onclick="javascript:planLessionTuan();" class="addGroup"><p>
						<i class="fa fa-plus"></i> <span>添加团课</span></p>
                    </a>
                    <a href="javascript:;" onclick="javascript:planLession();" class="addGroup"><p>
                    	<i class="fa fa-plus"></i> <span>添加排期</span></p>
                    </a>
					<a href="javascript:;" class="help">
							<p>
								<i class="fa fa-question-circle"></i> <span>帮助</span>
							</p>
					</a></li>
				</ul>
			</div>
			<div class="container-tab">
				<ul class="tabs">
					<li  class="active" name="syllabusGroupWeekTable"><a href="partial/lessionplan/index.jsp">周课表</a></li>
					<li name="syllabusOrder"><a href="partial/lessionplan/index2.jsp">团课排期</a></li>
				</ul>
			</div>
			<div class="container-btn searchbar" style="display: block; padding-top: 10px; height: 70px; text-align: center;">
				<div style="float: none; clear: both; margin-bottom: 14px;"></div>
				<button class="btn btn-primary search-btn addGroup" name="addSyllabusGroup" onclick="javascript:planLessionTuan();" style="margin-top: 0; float: left;">添加团课</button>
				<div style="margin-left: -200px; display: inline">
					<button class="btn btn-primary search-btn search-btn-special" onclick="serchTime('last')">&lt;</button>
					<div class="startEndTime" id="times"></div>
					<input type="hidden" id="searchStartTime" name="searchStartTime" />
					<input type="hidden" id="searchEndTime" name="searchEndTime" />
					<button class="btn btn-primary search-btn search-btn-special" onclick="serchTime('next')">&gt;</button>
				</div>
			</div>
			<div id="table" class="ctrl table-basic main-table">
				<div class="table-header clearfix" style="display: none;">
					<div class="message"></div>
					<div class="pager-outer pager-head clearfix ctrl table-pager pull-right table-pager-input">
						<button class="btn btn-sm btn-first" disabled="disabled">
							<i class="fa fa-arrow-left"></i>
						</button>
						<button class="btn btn-sm btn-prev" disabled="disabled">
							<i class="fa fa-chevron-left"></i>
						</button>
						<span class="current"> <input class="page-index" type="number" value="0"> / <strong class="page-count">0</strong>
						</span>
						<button class="btn btn-sm btn-next" disabled="disabled">
							<i class="fa fa-chevron-right"></i>
						</button>
						<button class="btn btn-sm btn-last" disabled="disabled">
							<i class="fa fa-arrow-right"></i>
						</button>
					</div>
				</div>
				<table class="table table-list">
					<thead>
						<tr>
							<th col-key="monday"><strong>星期一</strong><span class="weekTime" id="week1"></span></th>
							<th col-key="tuesday"><strong>星期二</strong><span class="weekTime" id="week2"></span></th>
							<th col-key="wednesday"><strong>星期三</strong><span class="weekTime" id="week3"></span></th>
							<th col-key="thursday"><strong>星期四</strong><span class="weekTime" id="week4"></span></th>
							<th col-key="friday"><strong>星期五</strong><span class="weekTime" id="week5"></span></th>
							<th col-key="saturday"><strong>星期六</strong><span class="weekTime" id="week6"></span></th>
							<th col-key="sunday"><strong>星期日</strong><span class="weekTime" id="week7"></span></th>
						</tr>
					</thead>
					<tbody id="planHtml">
						
						
					</tbody>
				</table>
				<div class="table-footer clearfix" style="display: none">
					<div class="pager-outer pager-tail clearfix ctrl table-pager pull-right table-pager-input">
						<button class="btn btn-sm btn-first" disabled="disabled">
							<i class="fa fa-arrow-left"></i>
						</button>
						<button class="btn btn-sm btn-prev" disabled="disabled">
							<i class="fa fa-chevron-left"></i>
						</button>
						<span class="current"> <input class="page-index" type="number" value="0"> / <strong class="page-count">0</strong>
						</span>
						<button class="btn btn-sm btn-next" disabled="disabled">
							<i class="fa fa-chevron-right"></i>
						</button>
						<button class="btn btn-sm btn-last" disabled="disabled">
							<i class="fa fa-arrow-right"></i>
						</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>

</html>