function showBoss(){
	if(logined!='Y'){
		openPopup(".wxloginPopup");
		return;
	}
	openPopup('.popup-manage-Index-boss');
}



function salesFromReport(){
	$.showIndicator();
	$.ajax({
		type : "POST",
		url : "fit-app-action-salesFromRankReport",
		data : {
			cust_name : cust_name,
			gym : gym ,
		},
		dataType : "json",
		success : function(data) {
			if (data.rs == "Y") {
				//$("#contacts-block").highcharts({
				
				var hData = [];
				/**
				 *  {name:'Firefox',   y: 45.0, },
			                ['IE',       26.8],
			                {
			                    name: 'Chrome',
			                    y: 12.8,
			                    sliced: true,
			                    selected: true,
			                },
			                ['Safari',    8.5],
			                ['Opera',     6.2],
			                ['其他',   0.7]
				 */
				
				var total = 0;
				for(var i=0;i<data.list.length;i++){
					var item = data.list[i];
					total += Number(item.total_amt);
				}
				
				for(var i=0;i<data.list.length;i++){
					var item = data.list[i];
					var total_amt = Number(item.total_amt);
					var percent = Math.round(total_amt / total * 10000) / 100;
					if(i==0){
						var first =  {
			                    name: item.name,
			                    y: percent,
			                    sliced: true,
			                    selected: true,
			                };
						hData.push(first);
					}else{
						var other = [item.name,percent];
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
				
				
				
				var tpl = document.getElementById("salesFromReportTpl").innerHTML;
				var content = template(tpl, {
					list:data.list
				});
				$("#salesFromReportDiv2").html(content);
				
				
				openPopup('.popup-salesFromReport');
				
				
				
			} else {
				$.toast(data.rs);
			}
			$.hideIndicator();
		},
		error : function(xhr, type) {
			$.hideIndicator();
			$.toast("您的网速不给力啊，再来一次吧");
		}
	});
}

