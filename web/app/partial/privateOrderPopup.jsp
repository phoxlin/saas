<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<style>
<!--
#privateOrderPopupDiv:first-child .col-25:first-child {
	
}

#privateOrderPopupDiv .row {
	text-align: center;
	padding-top: 0.3rem;
	padding-bottom: 0.3rem;
}

.upright-left {
	width: 20%;
	float: left;
	height: 84%;
	border-top: 1px solid gray;
}

.upright-left div {
	display: block;
	text-align: center;
	padding: 0.5rem 0;
	height: 14.3%;
}

.upright-right {
	width: 80%;
	float: right;
	height: 84%;
	overflow: auto;
	font-size: 0.5rem;
	border-top: 1px solid gray;
	padding-top: 0.5rem
}

.upright-right-div {
	height: 100%;
	width: 15%;
	float: left;
}

.upright-right-times{
	height: 100%;
	width: 85%;
	float: right;
	margin-top: 3%;
}

.right-time {
	width: 100%;
	height: 10%;
	text-align: right;
	padding-right: 0.2rem;
	padding-top: -0.5rem;
}
.right-line{
	width: 100%;
	height: 10%;
}

.right-line-1{
	height: 5%;
}
hr{
    -webkit-margin-before: 0;
    -webkit-margin-after: 0;
    border: 0;
    background: #eeeeee;height: 1px
}
.priOrder-content{
	width: 100%;
	height: 200%;
	background: #fcf428;color: #333;
	text-align: center;
}

</style>
<div class="popup popup-privateOrderPopup" id="popup-privateOrderPopup">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left"
			onclick="closePopup('.popup-privateOrderPopup')"></a>
		<h1 class="title" id="privateOrderPopupTitile">私教预约</h1>
	</header>
	<div class="content">
		<div class="upright-top" style="background: white;">
			<input type="hidden" id="privateOrderRole" value="mem">
			<input type="hidden" id="privateOrderPtId" value="">
			<input type="hidden" id="privateOrderIsExPt" value="">
			<div class="list-block media-list" style="margin: 0">
		    <ul>
		      <li>
		        <div class="item-content">
		          <div class="item-media"><img id="privateOrderPtHeader" src="" style='width: 3rem;border-radius: 50%'></div>
		          <div class="item-inner">
		            <div class="item-title-row">
		              <div class="item-title" id="privateOrderPtName"></div>
		            </div>
		            <div class="item-subtitle" id="privateOrderPtInfo"></div>
		          </div>
		        </div>
		      </li>
		    </ul>
		  </div>
		</div>
		<div class="upright-left content-bg">
			<div onclick="changePrivateOrderDate(this)" data-orderDate="2017-09-20" data-checked="Y">
				今天</br> <font size="0.5rem">周三</font>
			</div>
			<div onclick="changePrivateOrderDate(this)" data-orderDate="2017-09-21">
				明天</br> <font size="0.5rem">周四</font>
			</div>
			<div onclick="changePrivateOrderDate(this)" data-orderDate="2017-09-22">
				21日</br> <font size="0.5rem">周五</font>
			</div>
			<div onclick="changePrivateOrderDate(this)" data-orderDate="2017-09-23">
				22日</br> <font size="0.5rem">周六</font>
			</div>
			<div onclick="changePrivateOrderDate(this)" data-orderDate="2017-09-24">
				23日</br><font size="0.5rem">周日</font>
			</div>
			<div onclick="changePrivateOrderDate(this)" data-orderDate="2017-09-25">
				24日</br><font size="0.5rem">周一</font>
			</div>
			<div onclick="changePrivateOrderDate(this)" data-orderDate="2017-09-26">
				25日</br><font size="0.5rem">周二</font>
			</div>
		</div>
		<div class="upright-right" style="background-color: #242537;">
			<div class="upright-right-div">
				<div class="right-time">08:00</div>
				<div class="right-time">09:00</div>
				<div class="right-time">10:00</div>
				<div class="right-time">11:00</div>
				<div class="right-time">12:00</div>
				<div class="right-time">13:00</div>
				<div class="right-time">14:00</div>
				<div class="right-time">15:00</div>
				<div class="right-time">16:00</div>
				<div class="right-time">17:00</div>
				<div class="right-time">18:00</div>
				<div class="right-time">19:00</div>
				<div class="right-time">20:00</div>
				<div class="right-time">21:00</div>
				<div class="right-time">22:00</div>
			</div>
			<div class="upright-right-times">
				<div class="right-line-1" data-orderTime="08:00" onclick="privateOrderClick(this)"><hr></div>
				<div class="right-line-1" data-orderTime="08:30" onclick="privateOrderClick(this)"><hr></div>
				<div class="right-line-1" data-orderTime="09:00" onclick="privateOrderClick(this)"><hr></div>
				<div class="right-line-1" data-orderTime="09:30" onclick="privateOrderClick(this)">
					<hr>
				</div>
				<div class="right-line-1" data-orderTime="10:00" onclick="privateOrderClick(this)"><hr></div>
				<div class="right-line-1" data-orderTime="10:30" onclick="privateOrderClick(this)"><hr></div>
				<div class="right-line-1" data-orderTime="11:00" onclick="privateOrderClick(this)"><hr></div>
				<div class="right-line-1" data-orderTime="11:30" onclick="privateOrderClick(this)"><hr></div>
				<div class="right-line-1" data-orderTime="12:00" onclick="privateOrderClick(this)"><hr style="background: red;height: 1px;border: 0"></div>
				<div class="right-line-1" data-orderTime="12:30" onclick="privateOrderClick(this)"><hr></div>
				<div class="right-line-1" data-orderTime="13:00" onclick="privateOrderClick(this)"><hr></div>
				<div class="right-line-1" data-orderTime="13:30" onclick="privateOrderClick(this)"><hr></div>
				<div class="right-line-1" data-orderTime="14:00" onclick="privateOrderClick(this)"><hr></div>
				<div class="right-line-1" data-orderTime="14:30" onclick="privateOrderClick(this)"><hr></div>
				<div class="right-line-1" data-orderTime="15:00" onclick="privateOrderClick(this)"><hr></div>
				<div class="right-line-1" data-orderTime="15:30" onclick="privateOrderClick(this)"><hr></div>
				<div class="right-line-1" data-orderTime="16:00" onclick="privateOrderClick(this)"><hr></div>
				<div class="right-line-1" data-orderTime="16:30" onclick="privateOrderClick(this)"><hr></div>
				<div class="right-line-1" data-orderTime="17:00" onclick="privateOrderClick(this)"><hr></div>
				<div class="right-line-1" data-orderTime="17:30" onclick="privateOrderClick(this)"><hr></div>
				<div class="right-line-1" data-orderTime="18:00" onclick="privateOrderClick(this)"><hr></div>
				<div class="right-line-1" data-orderTime="18:30" onclick="privateOrderClick(this)"><hr></div>
				<div class="right-line-1" data-orderTime="19:00" onclick="privateOrderClick(this)"><hr></div>
				<div class="right-line-1" data-orderTime="19:30" onclick="privateOrderClick(this)"><hr></div>
				<div class="right-line-1" data-orderTime="20:00" onclick="privateOrderClick(this)"><hr></div>
				<div class="right-line-1" data-orderTime="20:30" onclick="privateOrderClick(this)"><hr></div>
				<div class="right-line-1" data-orderTime="21:00" onclick="privateOrderClick(this)"><hr></div>
				<div class="right-line-1" data-orderTime="21:30" onclick="privateOrderClick(this)"><hr></div>
				<div class="right-line-1" data-orderTime="22:00" onclick="privateOrderClick(this)"><hr></div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	var now = new Date().Format("yyyy-MM-dd");
	$("#privateOrderPopupDay").calendar({
		value : [ now ]
	});
/* 	$(".right-line-1").unbind("click");
	$(".right-line-1").click(function(){ */
	function privateOrderClick(t){
		
		var isExPt = $("#privateOrderIsExPt").val();
		if("true" == isExPt){
			return;
		}
		var html = $(t).html();
		var role = $("#privateOrderRole").val();
		if(html.indexOf("<hr") >= 0){
			//预约
			var text ='<div style="width:100%;height:5rem;">'
	      		+'<div style="width:50%;height:50%;float:left;">开始时间</div> '
	      		+'<div style="width:50%;height:50%;float:left;overflow:auto;text-align: left">'
	      		+'<select id="privateOrderTimeSelect" style="background: #eeeeee;border: 0;width: 80%;"> <option>08:00</option> <option>08:30</option> <option>09:00</option> <option>09:30</option> <option>10:00</option> <option>10:30</option> <option>11:00</option> <option>11:30</option> <option>12:00</option> <option>12:30</option> <option>13:00</option> <option>13:30</option> <option>14:00</option> <option>14:30</option> <option>15:00</option> <option>15:30</option> <option>16:00</option> <option>16:30</option> <option>17:00</option> <option>17:30</option> <option>18:00</option> <option>18:30</option> <option>19:00</option> <option>19:30</option> <option>20:00</option> <option>20:30</option> <option>21:00</option> </select></div>'
	      		+'<div style="width:50%;height:50%;float:left;">结束时间</div>'
	      		+'<div style="width:50%;height:50%;float:left;text-align: left;padding-left: 0.2rem;"><span id="endOrderTimeDiv"></span></div></div>';
			var title = '预约教练';
			if("pt" == role){
				title = '教练代约';
				text ='<div style="width:100%;height:5rem;">'
		      		+'<div style="width:50%;height:35%;float:left;">开始时间</div> '
		      		+'<div style="width:50%;height:35%;float:left;overflow:auto;text-align: left">'
		      		+'<select id="privateOrderTimeSelect" style="background: #eeeeee;border: 0;width: 80%;"> <option>08:00</option> <option>08:30</option> <option>09:00</option> <option>09:30</option> <option>10:00</option> <option>10:30</option> <option>11:00</option> <option>11:30</option> <option>12:00</option> <option>12:30</option> <option>13:00</option> <option>13:30</option> <option>14:00</option> <option>14:30</option> <option>15:00</option> <option>15:30</option> <option>16:00</option> <option>16:30</option> <option>17:00</option> <option>17:30</option> <option>18:00</option> <option>18:30</option> <option>19:00</option> <option>19:30</option> <option>20:00</option> <option>20:30</option> <option>21:00</option> </select></div>'
		      		+'<div style="width:50%;height:35%;float:left;">结束时间</div>'
		      		+'<div style="width:50%;height:35%;float:left;text-align: left;padding-left: 0.2rem;"><span id="endOrderTimeDiv"></span></div>'
		      		+'<div style="width:50%;height:30%;float:left;">选择学员</div>'
					+'<div style="width:50%;height:30%;float:left;text-align: left;padding-left: 0.2rem">'
					+'<input type="text" style="background: #eeeeee;border: 0;width:80%" id="privateOrderMemName" placeholder="请选择" readonly onclick="chooseOrderMem()">'
					+'<input type="hidden" id="privateOrderMemId"></div></div>';
			}
	      	 $.modal({
			      title:  title,
			      text: text,
			      buttons: [
			        {
			          text: '取消',
			          bold: true
			        },
			        {
			            text: '确定',
			            onClick: function() {
							var mem_id = id;
							if("mem"==role){
								//会员约
							}else{
								//教练约
								mem_id = $("#privateOrderMemId").val();
								if(!mem_id){
									$.alert("请选择会员");
									return;
								}
							}
							var pt_id = $("#privateOrderPtId").val();
							var day = $(".upright-left div[data-checked='Y']").attr("data-orderDate") + " ";
							var start_time = day + $("#privateOrderTimeSelect").val()+":00";
							var end_time =day + $("#endOrderTimeDiv").text()+":00";
							 $.ajax({
									type : "POST",
									url  : "fit-ws-app-memPrivateOrder",
									data : {
										cust_name : cust_name,
										gym : gym,
										mem_id:mem_id,
										start_time : start_time,
										end_time : end_time,
										pt_id : pt_id,
										role : role,
										date:day
									},
									dataType : "json",
									success : function(data) {
										$.hideIndicator();
										if (data.rs == "Y") {
											$.alert("预约成功");
											//刷新界面
											var date = $('.upright-left div[data-checked="Y"]').attr("data-orderdate");
											queryPrivateOrderByDate(date);
										} else {
											$.toast(data.rs);
										}
									},
									error : function(xhr, type) {
										$.hideIndicator();
										$.toast("您的网速不给力啊，再来一次吧");
									}
								});
			            }
			          }
			      ]
			 });
			executeSelectChange(t);
		}else{
			//预约后的操作
			var mem_id = $(t).attr("data-memId");
			var state = $(t).attr("data-state");
			var data_id = $(t).attr("data-id");
			var mem_name = $(t).attr("data-mem_name");
			var start_time = $(t).attr("data-start_time");
			var end_time = $(t).attr("data-end_time");
			if("mem" == role){
				if(mem_id == id){
					//会员本人
					$.modal({
					      title: '预约操作',
					      text: '',
					      verticalButtons: true,
					      buttons: [
					        {
					          text: '取消预约',
					          onClick: function() {
					            cancelPrivateOrder(data_id);
					          }
					        },
					        {
					          text: '关闭'
					        }
					      ]
					    });
				}
			}else{
				$.modal({
				      title: '预约操作',
				      text: '',
				      verticalButtons: true,
				      buttons: [
				    	  {
					          text: '确认预约',
					          onClick: function() {
					        	  isOkPrivateOrder(data_id);
					          }
					        }, {
				          text: '取消预约',
					          onClick: function() {
					        	  cancelPrivateOrder(data_id);
					          }
					        },
					        {
					          text: '修改时间',
					          onClick: function() {
					        	  updateTimePrivateOrder(t,data_id,mem_id,mem_name,start_time,end_time);
					          }
					        },
					        {
					          text: '关闭'
					        }
				   	   ]
				    });
			}
			
		}
		
	}
	function executeSelectChange(t){
		$("#privateOrderTimeSelect").unbind("change");
		$("#privateOrderTimeSelect").change(function(){
			//修改结束时间
			var time = $(this).val();
			var end = $("div[data-orderTime='"+time+"']").next().next().attr("data-orderTime");
			if(end){
				$("#endOrderTimeDiv").text(end);
			}
		});
		var orderTime = $(t).attr("data-orderTime");
		if(orderTime!="22:00" && orderTime!="21:30"){
			$("#privateOrderTimeSelect").val(orderTime);
			$("#privateOrderTimeSelect").change();
		}else{
			$("#privateOrderTimeSelect").val("21:00");
			$("#privateOrderTimeSelect").change();
		}
	}
	function chooseOrderMem(){
		$(".modal-in").last().hide();
		$(".modal-overlay-visible").last().hide();
		add_mem_choice_mem(10,"",id);
	}
	//修改时间
	function updateTimePrivateOrder(t,data_id,mem_id,mem_name,start_time,end_time){
		var start = start_time.substring(12,17);
		var pt_id = $("#privateOrderPtId").val();
		var role = $("#privateOrderRole").val();
		var text ='<div style="width:100%;height:5rem;">'
      		+'<div style="width:50%;height:35%;float:left;">开始时间</div> '
      		+'<div style="width:50%;height:35%;float:left;overflow:auto;text-align: left">'
      		+'<select id="privateOrderTimeSelect" style="background: #eeeeee;border: 0;width: 80%;"> <option>08:00</option> <option>08:30</option> <option>09:00</option> <option>09:30</option> <option>10:00</option> <option>10:30</option> <option>11:00</option> <option>11:30</option> <option>12:00</option> <option>12:30</option> <option>13:00</option> <option>13:30</option> <option>14:00</option> <option>14:30</option> <option>15:00</option> <option>15:30</option> <option>16:00</option> <option>16:30</option> <option>17:00</option> <option>17:30</option> <option>18:00</option> <option>18:30</option> <option>19:00</option> <option>19:30</option> <option>20:00</option> <option>20:30</option> <option>21:00</option> </select></div>'
      		+'<div style="width:50%;height:35%;float:left;">结束时间</div>'
      		+'<div style="width:50%;height:35%;float:left;text-align: left;padding-left: 0.2rem;"><span id="endOrderTimeDiv"></span></div>'
      		+'<div style="width:50%;height:30%;float:left;">选择学员</div>'
			+'<div style="width:50%;height:30%;float:left;text-align: left;padding-left: 0.2rem">'
			+'<input type="text" style="background: #eeeeee;border: 0;width:80%" id="" placeholder="'+mem_name+'" readonly>'
			+'<input type="hidden" id="hasPrivateOrderMemId" value="'+mem_id+'"><input type="hidden" id="hasOrderId" value="'+data_id+'"></div></div>';
		 $.modal({
		      title:  "修改预约时间",
		      text: text,
		      buttons: [
		        {
		          text: '取消',
		          bold: true
		        },
		        {
		            text: '确定',
		            onClick: function() {
						var mem_id = $("#hasPrivateOrderMemId").val();
						var day = $(".upright-left div[data-checked='Y']").attr("data-orderDate") + " ";
						var _start_time = day + $("#privateOrderTimeSelect").val()+":00";
						var _end_time =day + $("#endOrderTimeDiv").text()+":00";
						 $.ajax({
								type : "POST",
								url  : "fit-ws-app-updatePrivateOrder",
								data : {
									cust_name : cust_name,
									gym : gym,
									mem_id:mem_id,
									pt_id :pt_id,
									start_time : _start_time,
									end_time : _end_time,
									order_id:data_id,
									date:day
								},
								dataType : "json",
								success : function(data) {
									$.hideIndicator();
									if (data.rs == "Y") {
										$.alert("修改成功");
										//刷新界面
										var date = $('.upright-left div[data-checked="Y"]').attr("data-orderdate");
										queryPrivateOrderByDate(date);
									} else {
										$.toast(data.rs);
									}
								},
								error : function(xhr, type) {
									$.hideIndicator();
									$.toast("您的网速不给力啊，再来一次吧");
								}
							});
		            }
		          }
		      ]
		 });
		 executeSelectChange(t);
	}
	//确认预约
	function isOkPrivateOrder(data_id){
		$.showIndicator();
		 $.ajax({
				type : "POST",
				url  : "fit-ws-app-isOkPrivateOrder",
				data : {
					cust_name : cust_name,
					gym : gym,
					order_id:data_id
				},
				dataType : "json",
				success : function(data) {
					$.hideIndicator();
					if (data.rs == "Y") {
						$.alert("已确认");
						//刷新界面
						var date = $('.upright-left div[data-checked="Y"]').attr("data-orderdate");
						queryPrivateOrderByDate(date);
					} else {
						$.toast(data.rs);
					}
				},
				error : function(xhr, type) {
					$.hideIndicator();
					$.toast("您的网速不给力啊，再来一次吧");
				}
			});
	}
	//取消预约
	function cancelPrivateOrder(data_id){
		$.showIndicator();
		 $.ajax({
				type : "POST",
				url  : "fit-ws-app-memCancelPrivateOrder",
				data : {
					cust_name : cust_name,
					gym : gym,
					order_id:data_id
				},
				dataType : "json",
				success : function(data) {
					$.hideIndicator();
					if (data.rs == "Y") {
						$.alert("取消成功");
						//刷新界面
						var date = $('.upright-left div[data-checked="Y"]').attr("data-orderdate");
						queryPrivateOrderByDate(date);
					} else {
						$.toast(data.rs);
					}
				},
				error : function(xhr, type) {
					$.hideIndicator();
					$.toast("您的网速不给力啊，再来一次吧");
				}
			});
	}
</script>
<!-- 
<#for(var i=8;i<=22;i++){
		if(i!=22){
	#>	
		<div class="right-line-1" data-orderTime="<#=i<10?("0"+i):i#>:00"  onclick="privateOrderClick(this)"><hr <#if(i==12){#>style="background: red;height: 1px;border: 0"<#}#>></div>
		<div class="right-line-1" data-orderTime="<#=i<10?("0"+i):i#>:30"  onclick="privateOrderClick(this)"><hr></div>
	<#}else{#>
		<div class="right-line-1" data-orderTime="22:00"  onclick="privateOrderClick(this)"><hr></div>
	<#}}#>
 -->
<script type="text/html" id="privateOrderPopupTpl">
<#if(list && list.length>0){#>

	<#
	var hour = 8;
	for(var i=0;i<29;i++){
		
		var time = "";
		var nextTime = "";
		if(i%2==0){
			if(i!=0){
				hour++;
			}
			time = (hour<10?"0"+hour:hour)+":00";
			nextTime = (hour<10?"0"+hour:hour)+":30";
		}else{
			time = (hour<10?"0"+hour:hour)+":30";
			nextTime = ((hour+1)<10?"0"+(hour+1):(hour+1))+":00";
		}

		var flag = false;
		var order = {};
		for(var j=0;j<list.length;j++){
			order = list[j];
			var start_time = order.start_time;
			if(start_time.indexOf(time) >=0){
				flag = true;
				i++;
				if(i!=0 && i%2==0){
					hour++;
				}
				break;
			}
		}
	#>	
		<#if(flag){#>	
			<div class="right-line-1" data-start_time="<#=order.start_time#>" data-end_time="<#=order.end_time#>" data-mem_name="<#=order.mem_name#>" data-id="<#=order.id#>" data-memId="<#=order.mem_id#>" data-state="<#=order.state#>" data-orderTime="<#=time#>" onclick="privateOrderClick(this)">
				<div class="priOrder-content">
					<div style="width: 30%;height: 100%;float: left">
						<img alt="" src="<#=order.headurl#>" style="width: 1.8rem;height: 1.8rem;margin-top: 0.5rem">
					</div>
					<div style="width: 70%;height: 100%;float: right;padding-top: 1rem">
						<span class="line-one" style="float: left;width: 60%; text-align: left;"><#=order.mem_name#></span>
						<span style="float: right;width: 40%;"><#=order.state=="001"?"待教练确认":"已确认"#></span>
					</div>						
				</div>
			</div>
			<div class="right-line-1" data-orderTime="<#=nextTime#>" onclick="privateOrderClick(this)" style="visibility: hidden;"><hr <#if(nextTime=="12:00"){#>style="background: red;height: 1px;border: 0"<#}#>></div>
		<#}else{#>
			<div class="right-line-1" data-orderTime="<#=time#>" onclick="privateOrderClick(this)"><hr <#if(time=="12:00"){#>style="background: red;height: 1px;border: 0"<#}#>></div>
		<#}#>

	<#
	}#>
<#}else{#>
	<#for(var i=8;i<=22;i++){#>
		<#if(i!=22){#>
			<div class="right-line-1" data-orderTime="<#=i<10?("0"+i):i#>:00"  onclick="privateOrderClick(this)"><hr <#if(i==12){#>style="background: red;height: 1px;border: 0"<#}#>></div>
			<div class="right-line-1" data-orderTime="<#=i<10?("0"+i):i#>:30"  onclick="privateOrderClick(this)"><hr></div>
		<#}else{#>
			<div class="right-line-1" data-orderTime="22:00"  onclick="privateOrderClick(this)"><hr></div>
		<#}#>
	<#}#>
<#}#>
	
</script>