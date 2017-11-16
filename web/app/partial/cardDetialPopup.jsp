<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-cardDetial">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-cardDetial')"></a>
		<h1 class="title">会员卡详情</h1>
	</header>

	<nav class="bar bar-tab">
		<div class="row no-gutter">
			<div class="col-50 left-btn">总计￥<span id="card_price">0</span></div>
			<div class="col-50 right-btn" onclick="buyCards()">立即购买</div>
		</div>
	</nav>
	
	<div style="position: fixed;bottom: 3rem;left: 0; right: 0;">
		<div class="list-block c-con-div" style="margin: 0;font-size: 0.75rem;">
			<ul>
				<li>
					<div>
						<div >
							<div class="item-input c-con">
								<label class="label-checkbox item-content color-fff">
				 					<input type="checkbox"  id="card_Protocol" >
											<div class="item-media">
											<i class="icon icon-form-checkbox" style="width: 0.8rem; height: 0.8rem;"></i>&nbsp;&nbsp;阅读并同意&nbsp;
											<a href="javascript:openProtocol('buy_card')" class="color-basic">《会员卡购买协议》</a></div>
								</label>
							</div>
						</div>
					</div>
				</li>
				
			</ul>
		</div>
	</div>
	<input type="hidden" id="card_id"/>
	<div class="content" id="cardDetialDiv" style="bottom: 5rem;"></div>
</div>

<script type="text/javascript">
function addPriTimes(){
	$("#buyPrivateNumber").val(Number($("#buyPrivateNumber").val()) +1);
	var onePrice = $("#sign_price").text();
	var times = $("#buyPrivateNumber").val();
	if(times < 1){
		$("#buyPrivateNumber").val(1);
		$("#card_price").text(Number(onePrice));
	}else{
		$("#card_price").text(Math.floor(Number(onePrice)*Number(times)));
	}
}
function reducePriTimes(){
	$("#buyPrivateNumber").val(Number($("#buyPrivateNumber").val()) -1);
	var onePrice = $("#sign_price").text();
	var times = $("#buyPrivateNumber").val();
	if(times < 1){
		$("#buyPrivateNumber").val(1);
		$("#card_price").text(Number(onePrice));
	}else{
		$("#card_price").text(Math.floor(Number(onePrice)*Number(times)));
	}
}
</script>

<script type="text/html" id="cardDetialTpl">
<# 
	if(list){
		var card_type = list.card_type;
		var cardClass = "default-card";
		if("001" == card_type){
			cardClass = "card1";
		} else if("002" == card_type){
			cardClass = "card2";
		} else if("003" == card_type){
			cardClass = "card3";
		}		
#>
	<#  
			var d = list;
			var mem = mem[0];
			
			var logo_url = "app/images/card_logo.png";
		
	#>
		<div class="card mine-card <#=cardClass#>">
			<div class="card-content">
				<div class="card-content-inner" style="height: 100%;">
					<div>
						<#
                               var isT = d.isT;
						#>
						<img src="<#=logo_url#>"/>
					</div>
					<div class="item-subtitle font-80 card-name">
						<span class="line"></span>
						<#=d.card_name#>
						<span class="line"></span>
                    </div>
					<div class="item-title font-80">
						<span class="price"><#=d.app_amt ? d.app_amt : d.fee#>RMB</span>
					</div>
				</div>
			</div>
		</div>
		
		<div class="content-block" style="padding: 0;">
			<div class="font-75 font-666">
				<#if(card_type=="006"){#>
					<div class="font-80 color-333">有效课数:<span id="buyPrivateCardTimes"><#=list.times#></span>,单价:<span id="sign_price"><#=Math.round(Number(list.app_amt ? list.app_amt : list.fee)/Number(list.times))#></span>RMB</div>
					<p class="content-bg" style="padding: 0.5rem 0.75rem;margin: 0.2rem 0;">
						课程数量调整:<button style="width:2rem" onclick="reducePriTimes()">-</button>
						<input style="width:5rem;text-align: center;border:0" type="number" min="1" id="buyPrivateNumber" placeholder="课程数" value="<#=list.times#>">
						<button style="width:2rem" onclick="addPriTimes()">+</button>
					</p>
				<#}#>

				<div class="font-80 color-fff">卡片简介</div>
				<#
					if(d.summary){
				#>
					<p class="content-bg color-ccc" style="padding: 0.5rem 0.75rem;margin: 0.2rem 0;"><#=d.summary#></p>
				<#		
					} else {
				#>
					<p class="content-bg color-ccc" style="padding: 0.5rem 0.75rem;margin: 0.2rem 0;">无</p>
				<#
					}
				#>
				<div class="font-80 color-fff article-content" style="margin-top: 0.75rem;">卡片介绍</div>
				<#
					if(d.content){
				#>
					<p class="content-bg color-ccc" style="padding: 0.5rem 0.75rem;margin: 0.2rem 0;"><#=d.content#></p>
				<#		
					} else {
				#>
					<p class="content-bg color-ccc" style="padding: 0.5rem 0.75rem;margin: 0.2rem 0;">无</p>
				<#
					}
				#>
				
			</div>
	<#if(mem!=undefined){
		
		var isUpdateState = "";
		var isSexUpdateState = "";
		var update_time = mem.update_time;
		
		if(update_time !=undefined && update_time !=""){
			isUpdateState = "readonly";
		}
		if(update_time !=undefined && update_time !=""){
			isSexUpdateState = "disabled";
		}
			
	#>
<span style="font-size: 15px;">&nbsp;&nbsp;以下信息未填写的可修改，修改后十分钟内可再次修改</span>
<div class="list-block" style="margin-top: 0;">
			<ul>
				<li>
					<div class="item-content">
						<div class="item-inner">
							<div class="item-title label font-70 color-ccc" style="width: 15%;">姓名</div>
							<div class="item-input">
								<input type="text" class="font-75 color-fff" id="new_edit_mem_name" name="edit_mem_name" placeholder="姓名" value="<#=mem.mem_name || ''#>" <#=isUpdateState#>>
							</div>
						</div>
					</div>
				</li>
				<li>
					<div class="item-content">
						<div class="item-inner">
							<div class="item-title label font-70 color-ccc" style="width: 15%;">性别</div>
							<div class="item-input">
								<select class="font-75 color-fff" id="new_edit_mem_sex" name="new_mem_sex" disabled="<#=isSexUpdateState#>">
								<#if(mem.sexCode == "male"){#>
                				<option value="male">男</option>
                				<option value="female">女</option>
								<#}else{#>
                				<option value="female">女</option>
								<option value="male">男</option>
								<#}#>
              </select>
							</div>
						</div>
					</div>
				</li>
				
				<li>
					<div class="item-content">
						<div class="item-inner">
							<div class="item-title label font-70 color-ccc" style="width: 15%;">生日</div>
							<div class="item-input">
								<input type="date" id="new_birthday" name=birthday"" class="font-75 color-fff"
									 value="<#=mem.birthday || ''#>" <#=isUpdateState#>>
							</div>
						</div>
					</div>
				</li>
				<li>
					<div class="item-content">
						<div class="item-inner">
							<div class="item-title label font-70 color-ccc" style="width: 20%;">身份证号</div>
							<div class="item-input">
								<input type="text" class="font-75 color-fff" id="new_edit_id_card" name="edit_id_card" placeholder="身份证号" value="<#=mem.idCard || ''#>" <#=isUpdateState#>>
							</div>
						</div>
					</div>
				</li>
			</ul>
		</div>
		</div>
	<#
		}}
	#>
</script>