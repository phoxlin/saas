<%@page import="java.util.Calendar"%>
<%@page import="org.apache.poi.ss.formula.functions.Today"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
	if (user == null || !user.hasPower("sm_monthReport")) {
		request.getRequestDispatcher("/").forward(request, response);
	}

	String cust_name = user.getCust_name();
	String gym = user.getViewGym();
	
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	String today = sdf.format(new Date());
	Calendar cal = Calendar.getInstance();
	cal.setTime(new Date());
	cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH)); 
    String lastDay = sdf.format(cal.getTime());
%>
<!DOCTYPE html>
<html>
<head>
<title>月总报表</title>
<jsp:include page="/public/base.jsp" />
<script type="text/javascript" src="public/js/highcharts.src.js"></script>

<script type="text/javascript">
$(function() {
	query('<%=today%>');
});
function toDecimal(x) { 
    var f = parseFloat(x); 
    if (isNaN(f)) { 
      return; 
    } 
    f= parseFloat(f.toFixed(2));
    return f; 
  } 
function query(day){
	var endDay="<%=lastDay%>";
	if(day == undefined){
		day = $('#serarchDay').val()+"-01";
		endDay= $('#serarchDay').val()+"-31";
	}
	$.ajax({
		type : "POST",
		url : "fit-bg-action-moneyReport",
		data : {
			cust_name : '<%=cust_name%>',
			curGym : '<%=gym%>',
			dateFrom : day,
			dateTo :endDay 
		},
		dataType : "json",
		success : function(data) {
			if (data.rs == "Y") {
				 x1(data, day);
			} else {
				alert(data.rs);
			}
		},
		error : function() {
			alert("啊哦，网络繁忙，请稍后再试");
		}
	});
	 $.ajax({
	        type: "POST",
	        url: "fit-app-action-exAndEmpsRecord",
	        data: {
	            cust_name: '<%=cust_name%>',
	            curGym: '<%=gym%>',
	            emp_id: "596581f5e8bbca1654e1faab",
	            date: day,
	            boss: 'boss',
	            type: 'boss'
	        },
	        dataType: "json",
	        success: function(data) {
	            if (data.rs == "Y") {
	                x2(data, day);
	                x3(data, day);
	            } else {
	                alert(data.rs);
	            }
	        },
	        error: function() {
	            alert("啊哦，网络繁忙，请稍后再试");
	        }
	    });
}

function x1(data, day) {
    var timeSales = 0;
    var amtSales = 0;
    var timesSales = 0;
    var classSales = 0;
    var goodsSales = 0;
    var boxSales = 0;
    var leaveSales = 0;
    var tcardSales = 0;
    var fitSales = 0;
    var rechargeSales = 0;
    var otherSales = 0;
    if(data){
    	 var list = data.list;
    for (var i = 0; i < list.length; i++) {
        var card_type = list[i].card_type || "";
        var type = list[i].type || "";
        if ("001" == card_type) {
        	timeSales = list[i].total_real_amt; 
        } else if ("002" == card_type) {
        	amtSales = list[i].total_real_amt; 
        } else if ("003" == card_type) {
        	timesSales = list[i].total_real_amt; 
        } else if ("006" == card_type) {
        	classSales = list[i].total_real_amt; 
        }
        if("leave" == type){
        	leaveSales = list[i].total_real_amt; 
        } else if ("充值" == type) {
        	rechargeSales = list[i].total_real_amt; 
        } else if ("租柜费用" == type) {
        	boxSales = list[i].total_real_amt; 
        } else if ("转卡手续费" == type) {
        	tcardSales = list[i].total_real_amt; 
        } else if ("goods" == type) {
        	goodsSales = list[i].total_real_amt; 
        } else if ("fit" == type) {
        	fitSales = list[i].total_real_amt; 
        } else if ("other" == type) {
        	otherSales = list[i].total_real_amt; 
        }

    }
    }
    
    

    var totalAmt = Number(timeSales) + Number(amtSales) + Number(timesSales) + Number(classSales) + Number(goodsSales) +Number( boxSales) + Number(leaveSales) 
                  + Number(tcardSales) + Number(fitSales) + Number(rechargeSales) + Number(otherSales);
    console.log(totalAmt);
    $('#sells-div').highcharts({
        chart: {
            plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false
        },
        title: {
            text:'销售额<br /> 总销售额:￥' + toDecimal(totalAmt)
        },
        tooltip: {
            pointFormat: '销售{point.y}元'
        },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                dataLabels: {
                    enabled: true,
                    format: '<b>{point.name}</b>: {point.y}元',
                    style: {
                        color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                    }
                }
            }
        },
        series: [{
            type: 'pie',
            name: 'Browser share',
            data: [['时间售额', toDecimal(timeSales)], ['储值售额', toDecimal(amtSales)],['次卡售额', toDecimal(timesSales)],
                   ['私教售额', toDecimal(classSales)],['散客售额', toDecimal(fitSales)],['请假售额', toDecimal(leaveSales)],
                   ['租柜售额', toDecimal(boxSales)],['转卡售额', toDecimal(tcardSales)], ['商品售额', toDecimal(goodsSales)],
                   ['充值售额', toDecimal(rechargeSales)],['其它', toDecimal(otherSales)]]
        }],
        exporting: {
            enabled: false
        },
        //隐藏导出图片  
        credits: {
            enabled: false
        }
        //隐藏highcharts的站点标志  
    });
}

function x2(data, day) {
    var checkNums = 0;
    var checkinInfo = data.checkinInfo;
    for (var i = 0; i < checkinInfo.length; i++) {
        var type = checkinInfo[i].type;
        if ("month" == type) {
            checkNums = checkinInfo[i].num || 0;
        }
    }
    var classNums = 0;
    var reduceClass = data.reduceClass;
    for (var i = 0; i < reduceClass.length; i++) {
        var type = reduceClass[i].type;
        if ("month" == type) {
            classNums = reduceClass[i].num || 0;
        }
    }
    var timesNums = 0;
    var reduceTimesCard = data.reduceTimesCard;
    for (var i = 0; i < reduceTimesCard.length; i++) {
        var type = reduceTimesCard[i].type;
        if ("month" == type) {
            timesNums = reduceTimesCard[i].num || 0;
        }
    }

    $('#times-div').highcharts({
        chart: {
            plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false,
            spacing: [0, 0, 0, 0]
        },
        title: {
            floating: true,
            text: '消课(费)统计'
        },
        tooltip: {
            pointFormat: ' {name}: <b>{point.y}次</b>'
        },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                dataLabels: {
                    enabled: true,
                    format: '<b>{point.name}</b>: {point.y} 次',
                    style: {
                        color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                    }
                },
                point: {
                    events: {
                        mouseOver: function(e) {
                            chart.setTitle({
                                text: e.target.name + '\t' + e.target.y + ' 次'
                            });
                        }
                    }
                },
            }
        },
        series: [{
            type: 'pie',
            innerSize: '70%',
            name: '',
            data: [['出入场数', checkNums], ['私教消课', classNums], ['次卡消次', timesNums], ]
        }],
        exporting: {
            enabled: false
        },
        //隐藏导出图片  
        credits: {
            enabled: false
        }
        //隐藏highcharts的站点标志  
    },
    function(c) {
        // 环形图圆心
        var centerY = c.series[0].center[1],
        titleHeight = parseInt(c.title.styles.fontSize);
        c.setTitle({
            y: centerY + titleHeight / 2
        });
        chart = c;
    });
}
function x3(data, day) {
    var memInfo = data.memInfo;
    var memNums = 0;
    var qmemNums = 0;
    for (var i = 0; i < memInfo.length; i++) {
        var type = memInfo[i].type;
        var state = memInfo[i].state;
        if ("month" == type) {
            if ("001" == state) {
                memNums = memInfo[i].num || 0;
            } else if ("004" == state || "003" == state) {
                qmemNums += memInfo[i].num || 0;
            }

        }
    }
    var maintainInfo = data.maintainInfo;
    var memwhNums = 0;
    var qmemwhNums = 0;
    for (var i = 0; i < maintainInfo.length; i++) {
        var type = maintainInfo[i].type;
        var state = maintainInfo[i].state;
        if ("month" == type) {
            if ("001" == state) {
                memwhNums = maintainInfo[i].num || 0;
            } else if ("004" == state) {
                qmemwhNums = maintainInfo[i].num || 0;
            }

        }
    }

    $('#mems-div').highcharts({
        chart: {
            type: 'column'
        },
        title: {
            text: '会员统计'
        },
        xAxis: {
            type: 'category',
            labels: {
                rotation: -45,
                style: {
                    fontSize: '13px',
                    fontFamily: 'Verdana, sans-serif'
                }
            }
        },
        legend: {
            enabled: false
        },
        tooltip: {
            pointFormat: '{point.y}'
        },
        series: [{
            name: '总人口',
            data: [['新增会员', memNums], ['会员维护', memwhNums], ['新增潜客', qmemNums], ['潜客维护', qmemwhNums]],
            dataLabels: {
                enabled: true,
                rotation: -90,
                color: '#FFFFFF',
                align: 'right',
                format: '{point.y}',
                // one decimal
                y: 10,
                // 10 pixels down from the top
                style: {
                    fontSize: '13px',
                    fontFamily: 'Verdana, sans-serif'
                }
            }
        }],
        exporting: {
            enabled: false
        },
        //隐藏导出图片  
        credits: {
            enabled: false
        }
        //隐藏highcharts的站点标志  
    });
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
									<i class="fa fa-map-marker"></i><span>月总报表</span>
								</p></a></li>
					</ul>
				</div>
				<div class="row">
					<div class="col-lg-12 col-md-12 col-xs-12">
						<form class="form-inline">
							<div class="form-group">
								<label >时间</label> 
								<input type="month" class="form-control" id="serarchDay"  value="<%=today %>">
							</div>
							  <button type="button" class="btn btn-primary-plain" onclick="query()">查询</button>
						</form>

					</div>
					</div>

				<div class="row">
					<div class="col-lg-12 col-md-12 col-xs-12">
						<div class="col-md-6 col-xs-12">
							<div id="sells-div"></div>
						</div>
						<div class="col-md-6 col-xs-12">
							<div id="times-div"></div>
						</div>
					</div>
					<div class="col-lg-12 col-md-12 col-xs-12">
						<div class="col-md-6 col-xs-12">
							<div id="mems-div"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>