<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
	if (user == null || !user.hasPower("sm_empsSalesRank")) {
		request.getRequestDispatcher("/").forward(request, response);
	}

	String taskcode = "f_card";
	String taskname = "会员卡信息";
	String sId = request.getParameter("sid");
	String cust_name = user.getCust_name();
	String gym = user.getViewGym();
%>
<!DOCTYPE html>
<html>
<head>
<title>员工业绩排行</title>
<jsp:include page="/public/base.jsp" />
<script type="text/javascript" src="public/js/highcharts.src.js"></script>
<script type="text/javascript" charset="utf-8"
	src="public/js/template.js"></script>
<script type="text/javascript" charset="utf-8" src="app/js/date.js"></script>
<style type="text/css">
#sells-div div.row {
	margin-top: 10px;
}

#other-div div.row {
	margin-top: 10px;
}
</style>
<script type="text/javascript">
<!--
	template.config({
		sTag : '<#', eTag: '#>'
	});
	//-->
</script>
<script type="text/javascript">
$(function(){
	searchRank(true);
})

function searchRank(init,month,week){
	if(!month){
		month = new Date().Format("yyyy-MM");
	}
	$.ajax({
		type : "POST",
		url : "fit-bg-action-salesRankReport",
		data : {
			month : month,
			week : week || ""
		},
		dataType : "json",
		success : function(data) {
			if (data.rs == "Y") {
				var tpl = document.getElementById("mcRankReportTpl").innerHTML;
				var content = template(tpl, {
					list:data.mcSalesRank
				});
				$("#mcRankReportUl").html(content);
				
				 tpl = document.getElementById("mcRankReportTpl").innerHTML;
				 content = template(tpl, {
					list:data.ptSsalesRank
				});
				$("#ptRankReportUl").html(content);
				
				 tpl = document.getElementById("reduceClassRankReportTpl").innerHTML;
				 content = template(tpl, {
					list:data.reduceClassRank
				});
				$("#reduceClassRankReportUl").html(content);
				
				 tpl = document.getElementById("checkinRankReportTpl").innerHTML;
				 content = template(tpl, {
					list:data.checkinRank
				});
				$("#checkinRankReportUl").html(content);
				if(init){
					var longlongago = data.longlongago;
					initSelect(longlongago);
				}
				//showFrom(data.fromList);
			} else {
				error(data.rs);
			}
		},
		error : function() {
			error("啊哦，网络繁忙，请稍后再试");
		}
	});
}

function showFrom(list){
	var hData = [];
	
	var total = 0;
	for(var i=0;i<list.length;i++){
		var item = list[i];
		total += Number(item.total_amt);
	}
	
	for(var i=0;i<list.length;i++){
		var item = list[i];
		var total_amt = Number(item.total_amt);
		var percent = Math.round(total_amt / total * 10000) / 100;
		
		var name = item.name + " ￥"+(total_amt / 100);
		
		if(i==0){
			var first =  {
                    name: name,
                    y: percent,
                    sliced: true,
                };
			hData.push(first);
		}else{
			var other = [name,percent];
			hData.push(other);
		}
	}
	
	new Highcharts.Chart({
        chart: {
        	renderTo:"salesFromReportDiv",
        	plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false,
            spacing : [100, 0 , 40, 0]
        },
        title: {
            floating:true,
            text: '全部员工'
        },
        tooltip: {
            pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
        },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                dataLabels: {
                    enabled: true,
                    format: '<b>{point.name}</b>: {point.percentage:.1f} %',
                    style: {
                        color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                    }
                },
                point: {
                    events: {
                        mouseOver: function(e) {  // 鼠标滑过时动态更新标题
                            // 标题更新函数，API 地址：https://api.hcharts.cn/highcharts#Chart.setTitle
                            chart.setTitle({
                                text: e.target.name+ '\t'+ e.target.y + ' %'
                            });
                        }
                        //, 
                        // click: function(e) { // 同样的可以在点击事件里处理
                        //     chart.setTitle({
                        //         text: e.point.name+ '\t'+ e.point.y + ' %'
                        //     });
                        // }
                    }
                },
            }
        },
        series: [{
            type: 'pie',
            innerSize: '80%',
            name: '市场份额',
            data: hData
        }],credits: { enabled: false }// 隐藏highcharts的站点标志
    }, function(c) {
        // 环形图圆心
        var centerY = c.series[0].center[1],
            titleHeight = parseInt(c.title.styles.fontSize);
        c.setTitle({
            y:centerY + titleHeight/2
        });
        chart = c;
    }
    );
}


function initSelect(longlongago){
	if(!longlongago){
		longlongago = new Date().getTime();
	}
	var month = initMonths(longlongago);
	var html = "";
	for(var i=0;i<month.length;i++){
		if(i == 1){
			html+="<option selected>"+month[i]+"</option>";
		}else{
			html+="<option>"+month[i]+"</option>";
		}
	}
	$("#month").html(html);
	initWeeks(new Date().Format("yyyy-MM"));
}	


function initMonths(longlongago){
	 	var now = new Date();
		var m = now.getMonth();
		var y = now.getFullYear();
		
		var before = new Date(Number(longlongago));
		var year =  y - before.getFullYear();
		var month= before.getMonth();
		
		var months = [];
		months.push("所有月份");
		for (var i = 0; i <= year; i++) {
			if (i == 0) {
				for (var j = m; j >= 0; j--) {
					var xx = new Date(y, j, 1).Format("yyyy-MM");
					months.push(xx);
				}
			} else if(i != year){
				
				for (var j = 11; j >= 0; j--) {
					var xx = new Date(y, j, 1).Format("yyyy-MM");
					months.push(xx);
				}
			}else{
				for (var j = 11; j >= month; j--) {
					var xx = new Date(y, j, 1).Format("yyyy-MM");
					months.push(xx);
				}
				
			}
			y--;
		}
		return months;
}

function initWeeks(m){
	var month = m;
	var weeks = getWeeksOfMonth(month);
	//$("#salesRankReportWeek").val(weeks[0]);
	var html = "";
	html = "<option value=''>全部</option>";
	if(m =="所有月份"){
		
	}else{
		for(var i=0;i<weeks.length;i++){
			html+="<option>"+weeks[i]+"</option>";
		}
		
	}
	$("#week").html(html);
	search();
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

function search(){
	var month = $("#month").val() || "";
	var week = $("#week").val() || "";
	searchRank(false,month,week);
}
</script>
</head>
<body>
	<div class="widget">
		<jsp:include page="/public/header.jsp" />
		<div class="container-fluid">
			<div class="main main2" style="margin-top: 120px;">
				<div class="nav-bar">
					<a href="main.jsp" class="back"><p>
							<i class="fa fa-arrow-left"></i> <span>返回主页</span>
						</p></a>
					<ul>
						<li><a class="cur"><p>
									<i class="fa fa-map-marker"></i><span>员工业绩排行</span>
								</p></a></li>
					</ul>
				</div>
				<div class="row" style="background-color: #FFF;">
					<div>
						<div class="col-md-2 col-xs-12" class="input-group">
							<div class="input-group">
								<span class="input-group-addon">选择月</span>
								<select id="month" class="form-control" onchange="initWeeks(this.value)">
								</select>
							</div>
						</div>
						<div class="col-md-2 col-xs-12">
							<div class="input-group">
								<span class="input-group-addon">选择周</span>
								<select id="week" onchange="search()" class="form-control">
								</select>
							</div>
						</div>
						<div class="col-md-2 col-xs-12">
							<div class="input-group">
								<input type="button" onclick="search()" class="form-control" value="搜索">
							</div>
						</div>
					</div>
					<div class="col-lg-12 col-md-12 col-xs-12" style="height: 400px">
						<div class="col-md-6 col-xs-12">
							<div id="sells-div" data-highcharts-chart="0">
								<div id="other-div" data-highcharts-chart="0">会籍销售排名<div style="float: right"></div></div>
								
								<ul class="list-group" id="mcRankReportUl">
								</ul>
							</div>
						</div>
						<div class="col-md-6 col-xs-12">
							<div id="other-div" data-highcharts-chart="0">教练销售排名<div style="float: right"></div></div>
							<ul class="list-group" id="ptRankReportUl">
							</ul>
						</div>
						<!-- <div class="col-md-6 col-xs-12">
							<div id="other-div" data-highcharts-chart="0">销售来源<div style="float: right"></div></div>
							<div id="salesFromReportDiv"></div>
						</div> -->
					</div>
					<div class="col-lg-12 col-md-12 col-xs-12" style="height: 400px">
						<div class="col-md-6 col-xs-12">
							<div id="sells-div" data-highcharts-chart="0">私教上课排名<div style="float: right"></div></div>
							<ul class="list-group" id="reduceClassRankReportUl">
							</ul>
						</div>
						<div class="col-md-6 col-xs-12">
							<div id="other-div" data-highcharts-chart="0">会员入场排名<div style="float: right"></div></div>
							<ul class="list-group" id="checkinRankReportUl">
							</ul>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
<script type="text/html" id="mcRankReportTpl">
<#if(list && list.length >0){#>
	
	<#for(var i=0;i<list.length;i++){
		var emp = list[i];
	#>
		<li class="list-group-item"><span class="badge">售额<#=emp.total_amt/100#>元</span><#=emp.name#>
									</li>
	<#}#>

<#}else{#>			
	<div class="none-info font-90">暂无数据</div>
<#}#>
</script>

<script type="text/html" id="ptRankReportTpl">
			
</script>

<script type="text/html" id="reduceClassRankReportTpl">
		<#if(list && list.length >0){#>
	
	<#for(var i=0;i<list.length;i++){
		var emp = list[i];
	#>
		<li class="list-group-item"><span class="badge">消课<#=emp.num#>次</span><#=emp.name#>
									</li>
	<#}#>

<#}else{#>			
	<div class="none-info font-90">暂无数据</div>
<#}#>	
</script>

<script type="text/html" id="checkinRankReportTpl">
		<#if(list && list.length >0){#>
	
	<#for(var i=0;i<list.length;i++){
		var mem = list[i];
	#>
		<li class="list-group-item"><span class="badge">签到<#=mem.num#>次</span><#=mem.mem_name#>
									</li>
	<#}#>

<#}else{#>			
	<div class="none-info font-90">暂无数据</div>
<#}#>	
</script>
