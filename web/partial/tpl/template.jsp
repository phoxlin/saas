<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
%>


<script type="text/html" id="consumeRecordTpl">

<div style="height: 300px;">
	<table class="custom-table">
		<thead>
			<tr>
				<th>消费项目</th>
				<th>消费金额</th>
				<th>消费时间</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>
<#
		 if(list2 && list2.length > 0){
			for(var i = 0; i < list2.length; i++) {
				var item = list2[i];
		#>
			<tr>
                <td><#=item.consume_mold#></td>
			    <td><#=item.real_amt#></td>
			    <td><#=item.pay_time.substring(0,19)#></td>
				<td>
					<#if(item.card_type && item.buy_id){#>
						<a href='javascript:void(0)' onclick='window.open("pages/f_set/f_set_contract_print2.jsp?type=<#=item.card_type#>&buy_id=<#=item.buy_id#>&mem_gym=<#=item.mem_gym#>&give_card=<#=item.give_card#>");'>合同补打</a>
					<#}#>
					<#if(item.consume_mold =="入场"){#>
						<a href='javascript:void(0)' onclick="printPaper('<#=item.id#>')">小票补打</a>
					<#}#>
				</td>
            </tr>
		<#
			}
		 } else {
		#>
			<tr>
				<td colspan="6">没有消费记录</td>
			</tr>
		<#		 
		 }
		#>
		</tbody>
	</table>
</div>

	<!--<div class="pager">
		<div>总数<#=list.total#>&nbsp;当前页条数<#=list.curSize#></div>
		<div>
			<#
				var cur = list.curPage;
				if(parseInt(cur) > parseInt(list.totalPage)){
					cur = list.totalPage
				}					
				if(list.curPage > 1){
					var pre = list.curPage - 1;
			#>
				<a href="javascript: void(0);" onclick="consume_list('<#=list.user_id#>',1);"> 
					<i style="margin-right: -4px;">|</i> 
					<span class="fa fa-angle-left"></span>
				</a> 

				<a href="javascript: void(0);" onclick="consume_list('<#=list.user_id#>',<#=pre#>);"> 
					<span class="fa fa-angle-left"></span>
				</a> 
			<#		
				} else {
			#>
				<a class="disabled" href="javascript: void(0);"> 
					<i style="margin-right: -4px;">|</i> 
					<span class="fa fa-angle-left"></span>
				</a>
				<a class="disabled" href="javascript: void(0);"> 
					<span class="fa fa-angle-left"></span>
				</a> 
			<#		
				}
			#>
			<input onkeyup="consume_list('<#=list.user_id#>',this.value)" value="<#=cur#>" type="number" style="max-width: 55px; padding: 0 5px; height: 23px; margin: 0 5px 0 10px;">/<#=list.totalPage#>&nbsp;&nbsp; 
			
			<#
				if(parseInt(cur) < list.totalPage){
					var next = list.curPage + 1;						
			#>
				<a href="javascript: void(0)" onclick="consume_list('<#=list.user_id#>',<#=next#>)"> 
					<span class="fa fa-angle-right"></span>
				</a> 
				<a href="javascript: void(0)" onclick="consume_list('<#=list.user_id#>',<#=list.totalPage#>)"> 
					<span class="fa fa-angle-right"></span> <i style="margin-left: -4px;">|</i>
				</a>
			<#
				} else {
			#>
				<a class="disabled"> 
					<span class="fa fa-angle-right"></span>
				</a> 
				<a class="disabled"> 
					<span class="fa fa-angle-right"></span> <i style="margin-left: -4px;">|</i>
				</a>
			<#		
				}
			#>
		</div>
	</div>-->
	</script>

<script type="text/html" id="oldCardTpl">
 <#
		 if(list2 && list2.length> 0){
			for(var i = 0; i < list2.length; i++) {
			  var info = list2[i];
              var ct = info.card_type;
             var typeName="";
		  if(ct == "001"){
                  typeName="天数卡";
              }else if(ct == "002"){
                  typeName="储值卡";
              }else if(ct == "003"){
                  typeName="次数卡";
              }else if(ct == "006"){
                  typeName="私教课程";
              }
              var state=info.state;
              var state_str="";
             if(state == "001" || "009" == state){
                 state_str="过期";
              }else if(state == "006"){
                 state_str="挂失";
              }else if(state == "007"){
                  state_str="转卡";
              }else if(state == "008"){
                  state_str="退卡";
              }else if(state == "004"){
                  state_str="请假";
              }
		#>
		<div class="card">
			<div class="card-header">
				<div class="card-name" ><#=info.card_name#></div>
				<div class="card-type"><#=typeName#></div>
			</div>
			<div class="card-content">
				<ul style="margin-bottom: 0px">
					<li>开卡时间：<#=info.active_time#></li>
					<li>到期时间：<#=info.deadline#></li>
				</ul>
				<div class="seal"><span><#=state_str#></span></div>
			</div>
		</div>
      <#}}else{#>
		<div>没有失效会员卡</div>
	<#}#>
	</script>

<script type="text/html" id="consumeRecord">
		<#
			for(var i = 0; i < infos.length; i++) {
				var info = infos[i];
		#>
			<tr><td><#=info.gd_name#></td>
			<td><#=info.real_amt#></td>
			<td><#=info.pay_time#></td>
			<td><#=info.op_name#></td></tr>
		<#
			}
		#>
	</script>

<script type="text/html" id="leaveRecord">
		<#
			for(var i = 0; i < infos.length; i++) {
				var info = infos[i];
		#>
			<tr><td><#=info.leave_type#></td>
			<td><#=info.start_time#></td>
			<td><#=info.end_time#></td>
			<td><#=info.days#></td>
			<td><#=info.state#></td></tr>
		<#
			}
		#>
	</script>

<script type="text/html" id="checkinRecord">
		<#
			for(var i = 0; i < infos.length; i++) {
				var info = infos[i];
		#>
			<tr><td><#=info.checkin_type#></td>
			<td><#=info.checkin_time#></td>
			<td><#=info.checkout_time#></td>
			<td><#=info.emp_name#></td></tr>
		<#
			}
		#>
	</script>
<script type="text/html" id="cardTpl">
		<#
           if(list){
           for(var i = 0;i<list.length;i++){
              var info = list[i];
              var ct = info.card_type;
              var typeName="";
             if(ct == "001"){
                  typeName="天数卡";
              }else if(ct == "002"){
                  typeName="储值卡";
              }else if(ct == "003"){
                  typeName="次数卡";
              }else if(ct == "006"){
                  typeName="私教课程";
              }
              var state=info.state;
              var state_str="";
             if(state == "001"){
                 state_str="已激活";
              }else if(state == "002"){
                  state_str="未激活";
              }else if(state == "003"){
                  state_str="退费";
              }else if(state == "004"){
                  state_str="请假";
              }else if(state == "005"){
                  state_str="补卡";
              }else if(state == "006"){
                 state_str="挂失";
              }else if(state == "007"){
                  state_str="转卡";
              }else if(state == "008"){
                  state_str="退卡";
              }
		#>
		<div class="card card-<#=ct#>">
			<div class="card-header">
				<div class="card-name" ><#=info.card_name#></div>
				<div class="card-type"><#=typeName#></div>
			</div>
			<div class="card-content">
				<ul style="margin-bottom: 0px">
					<li>开卡时间：<#=info.active_time#></li>
					<li>到期时间：<#=info.deadline#></li>
                   <# if(ct == "001" || ct == "003" ){#>
					<li>会籍：<#=info.mc_name||""#></li>
                   <#}else if( ct == "006" ){#>
					<li>教练：<#=info.pt_name||""#></li>
                   <#}#>
                   <# if(state == "001" && (ct=="003" || ct=="006") ){#>
					<li>剩余次数：<#=info.remain_times#></li>
                   <#}else{#>
					<li>状态：<#=state_str#></li>
                   <#}#>
				</ul>
			</div>
			<div class="card-footer">
                <#  console.log(info);
                   if(pid=="" || pid == undefined ){
                   
                if(state=="001" ){#>
                    <button class="btn btn-custom" onclick="backCard('<#=fk_user_id#>','<#=info.id#>','<#=fk_user_gym#>')" >退卡</button>
                <# 
                   if(ct!="006" && ct !="002" && info.gym == fk_user_gym && info.is_fanmily !="Y"){#>
                    <button class="btn btn-custom"  onclick="updateCard('<#=fk_user_id#>','<#=info.id#>','<#=ct#>')">升级</button>
                <#}  #>
                <#if(ct !="002" && info.is_fanmily !="Y" ){#>
                    <button class="btn btn-custom" onclick="transferCard('<#=fk_user_id#>','<#=info.id#>','<#=info.gym#>')">转卡</button>
                <#}#>
                <#if(ct=="003" ){#>
                    <button class="btn btn-custom" onclick="reduceTimes('<#=fk_user_id#>','<#=info.id#>','<#=fk_user_gym#>','消次')">消次</button>
                    <button class="btn btn-custom" onclick="toLeave('<#=fk_user_id#>','<#=info.id#>','<#=fk_user_gym#>','<#=info.card_id#>')">请假</button>
                <#}#>
                <#if(ct=="001" ){#>
                   <button class="btn btn-custom" onclick="toLeave('<#=fk_user_id#>','<#=info.id#>','<#=fk_user_gym#>','<#=info.card_id#>')">请假</button>
                <#}#>
                <#if(ct=="002" ){#>
                   <button class="btn btn-custom" onclick="recharge('<#=fk_user_id#>','<#=fk_user_gym#>')">充值</button>
                <#}#>
                <#if( ct == "006"){#>
                    <button class="btn btn-custom"  onclick="reduceTimes('<#=fk_user_id#>','<#=info.id#>','<#=fk_user_gym#>','消课')">消课</button>
					<button class="btn btn-custom" onclick="toLeave('<#=fk_user_id#>','<#=info.id#>','<#=fk_user_gym#>','<#=info.card_id#>')">请假</button>
                <#}} else if(state=="002" && info.gym == fk_user_gym){#>
					<button class="btn btn-custom" onclick="activeCard('<#=fk_user_id#>','<#=info.id#>','<#=fk_user_gym#>')">激活</button>
                 <# }}#>
			</div>
		</div>
      <#}}#>
       <div class="card card-add" onclick="showBuyCardPage('<#=fk_user_id#>')" ><div>+</div><div>购卡</div></div>
         
	</script>
<script type="text/html" id="update_cardTpl">
		<#
           if(list){
           for(var i = 0;i<list.length;i++){
              var info = list[i];
console.log(info);
              var ct = info.card_type;
              var typeName="";
             if(ct == "001"){
                  typeName="天数卡";
              }else if(ct == "002"){
                  typeName="储值卡";
              }else if(ct == "003"){
                  typeName="次数卡";
              }else if(ct == "006"){
                  typeName="私教课程";
              }
              var state=info.state;
              var state_str="";
             if(state == "001"){
                 state_str="已激活";
              }else if(state == "002"){
                  state_str="未激活";
              }else if(state == "003"){
                  state_str="退费";
              }else if(state == "004"){
                  state_str="请假";
              }else if(state == "005"){
                  state_str="补卡";
              }else if(state == "006"){
                 state_str="挂失";
              }else if(state == "007"){
                  state_str="转卡";
              }else if(state == "008"){
                  state_str="退卡";
              }
		#>
		<div class="card card-<#=ct#>" style="margin-top: 20px;">
			<div class="card-header">
				<div class="card-name" ><#=info.card_name#></div>
				<div class="card-type"><#=typeName#></div>
			</div>
			<div class="card-content">
				<ul style="margin-bottom: 0px">
					<li>开卡时间：<#=info.active_time#></li>
					<li>到期时间：<#=info.deadline#></li>
                   <# if(ct == "001" || ct == "003" ){#>
					<li>会籍：<#=info.mc_name||""#></li>
                   <#}else if( ct == "006" ){#>
					<li>教练：<#=info.pt_name||""#></li>
                   <#}#>
                   <# if(state == "001" && (ct=="003" || ct=="006") ){#>
					<li>剩余次数：<#=info.remain_times#></li>
                   <#}else{#>
					<li>状态：<#=state_str#></li>
                   <#}#>
				</ul>
			</div>
			<div class="card-footer">
                <#if(pid==""  || pid== "null"){#>
                    <button class="btn btn-custom" onclick="updateCard('<#=info.id#>','<#=fk_user_gym#>')" >修改</button>
                <#}#>
			</div>
		</div>
      <#}}#>
	</script>
<script type="text/html" id="update_record_cardTpl">
		<#
           if(list){
           for(var i = 0;i<list.length;i++){
              var info = list[i];
console.log(info);
              var ct = info.card_type;
              var typeName="";
             if(ct == "001"){
                  typeName="天数卡";
              }else if(ct == "002"){
                  typeName="储值卡";
              }else if(ct == "003"){
                  typeName="次数卡";
              }else if(ct == "006"){
                  typeName="私教课程";
              }
              var state=info.state;
              var state_str="";
             if(state == "001"){
                 state_str="已激活";
              }else if(state == "002"){
                  state_str="未激活";
              }else if(state == "003"){
                  state_str="退费";
              }else if(state == "004"){
                  state_str="请假";
              }else if(state == "005"){
                  state_str="补卡";
              }else if(state == "006"){
                 state_str="挂失";
              }else if(state == "007"){
                  state_str="转卡";
              }else if(state == "008"){
                  state_str="退卡";
              }
		#>
		<div class="card card-<#=ct#>" style="margin-top: 20px;">
			<div class="card-header">
				<div class="card-name" ><#=info.card_name#></div>
				<div class="card-type"><#=typeName#></div>
			</div>
			<div class="card-content">
				<ul style="margin-bottom: 0px">
					<li>开卡时间：<#=info.active_time#></li>
					<li>到期时间：<#=info.deadline#></li>
                   <# if(ct == "001" || ct == "003" ){#>
					<li>会籍：<#=info.mc_name||""#></li>
                   <#}else if( ct == "006" ){#>
					<li>教练：<#=info.pt_name||""#></li>
                   <#}#>
                   <# if(state == "001" && (ct=="003" || ct=="006") ){#>
					<li>剩余次数：<#=info.remain_times#></li>
                   <#}else{#>
					<li>状态：<#=state_str#></li>
                   <#}#>
				</ul>
			</div>
			<div class="card-footer">
                <#if(pid==""  || pid== "null"){#>
                    <button class="btn btn-custom" onclick="updateRecordCard('<#=info.msg_id#>')" >查看</button>
                <#}#>
			</div>
		</div>
      <#}}#>
	</script>

<script type="text/html" id="reduceTimeTpl">
		<div class="container dialog-container form-container" style="width: 400px;">
			<form class="custom-form" method="post" style="height: 150px;">
				<div class="row">
					<div class="col-md-12 col-xs-12">
						<span style="width:auto;">次数<em>*</em>：</span> 
						<input style="width: 80%;" type="number" id="reduceTime" name="reduceTimes" required>
					</div>
				</div>
			</form>
			<div class="dialog-footer">
				<button class="btn btn-custom" onclick="doReduce('<#=cid#>');">确认消次</button>
			</div>
		</div>
	</script>
<script type="text/html" id="reduceClassTpl">
		<#
			if(coaches){
		#>
			<div class="container dialog-container" style="width: 450px;height:400px;overflow-y:scroll">
				<div class="row">
				<#
					for(var i=0; i<coaches.length; i++){
						var item = coaches[i];
						var id = item.id;
						var _class = "";
						if(id == coachId && coachId.length > 0){
							_class = "checked : checked;";
						}
				#>
					<div class="col-xs-3">
						
 				<div class="radio">
 					 <label>
   					 <input type="radio" <#=_class#> name="redeceClass_coachId" id="radioId<#=item.id#>" value="<#=item.id#>">
   					 <#=item.emp_name#>
 					 </label>
					</div>
				</div>					

				<#
					}
				#>		
				</div>
			</div>
		<#
			}
		#>
	</script>
<!-- 收银台搜索会员-->
<script type="text/html" id="queryUserListTpl">
 <# if(list){
   for(var i = 0;i<list.length;i++){
   var user = list[i];
#>
<li class="down-li" key="0"><a href="javascript:showMemInfo('<#=user.id#>','<#=user.name#>','<#=user.gym#>','<#=user.gymName#>','<#=user.sex#>');">
		<div class="user-one">
			<div class="user-image">
				<img class="images" src="<#=user.picUrl || "public/fit/images/cashier/default_head.png"#>">
			</div>
		</div>
		<div class="user-two">
			<div class="user-name-phone-card">
				<div class="usernamephone">
					<p class="username"><#=user.name || "-匿名-"#></p>
					<p class="userphone"><#=user.phone || ""#></p>
				</div>
				<div class="usercardnumber">
					<p class="usercard">会员卡号</p>
					<p class="usernumber"><#=user.mem_no || ""#></p>
				</div>
			</div>
		</div>
</a>
	<hr style="padding: 0px; margin: 0px; margin-top: 1px;" width="100%" color="#987cb9" size="1/"></li>
<#}}#>
	</script>
<!--  最近入场    -->
<script type="text/html" id="recentCheckinTpl">
	<div style="min-height: 252px;">
	<table style="table-layout: fixed;">
		<thead>
			<tr>
				<th>姓名</th>
				<th width="80">照片</th>
				<th width="200">会员信息</th>
				<th>购卡信息</th>
<%-- 
				<th>签到/签退时间</th>
				<th>入场状态</th>
--%>
				<th width="300">备注</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>
		<#
		var mems = list.mems;
		var cardMsg = list.cardMsg;	
		var cardRemarks = list.cardRemarks;
		 if(mems && mems.length > 0){
			 for(var i=0; i<mems.length; i++){
				var mem = mems[i];
				var mem_id = mem.id;
				var imgUrl=mem.picUrl?(mem.picUrl+"?imageView2/1/w/200/h/180"):"public/fit/images/cashier/default_head.png";
				var remark=mem.remark;
		#>
			<tr>
				<td><#=mem.name#></td>
				<td><img src="<#=imgUrl#>" name="mem_info_header<#=mem_id#>" width="66" onclick="showCamera('<#=mem_id#>','<#=mem.mem_gym#>')"/></td>
				<td style="white-space: unset;">
					<div>性别 : <#=mem.sex#></div>
					<div>电话 : <#=mem.phone#></div>
					<div>卡号 : <#=mem.mem_no#></div>
					<div>入场时间:<#=mem.checkin_time#></div>
					<%--
					<div>备注 : 
					<#if(remark!=null&&remark.length>0){#>
					<a href="javascript:showView('<#=remark#>');">查看</a>
					<#}#>
					</div>
					--%>
				</td>
				<td style="white-space: unset;">
					<# if(mem_id!="-1"){
					 if(mem.pid==""){
					for(var j = 0; j < cardMsg.length; j++){#>
							<#if(mem_id == cardMsg[j].mem_id){#>
							<#if(cardMsg[j].card_type == "001"){#>
							<div>时间卡 : <#=cardMsg[j].days#>天</div>
							<#}else if(cardMsg[j].card_type == "003"){#>
							<div>次&nbsp;&nbsp;&nbsp;卡 : 剩余<#=cardMsg[j].remain_times#>次</div>
							<#}else if(cardMsg[j].card_type == "006"){#>
							<div>私教卡 : 剩余<#=cardMsg[j].remain_times#>次</div>
							<#}}}#>
							<div>储值卡 : 余额￥<#=mem.remainAmt /100#>元</div>
                             <# }else{#>
							<div><家庭附属卡></div>
                       <#}}#>
				</td>

				<%--
				<td>
					<div>
						<i class="tag1">到</i> <#=mem.checkin_time#>
					</div>
					<div>
						<i class="tag2">退</i> <#=mem.checkout_time#>
					</div>
				</td>
				<td class="weight-font stress-font">
					<#=mem.state#>
				</td>
				--%>
				<td style="white-space: unset;">
					<div><#=mem.remark#></div>
					<#if(cardRemarks && cardRemarks.length>0){
						for(var x=0;x<cardRemarks.length;x++){
							if(cardRemarks[x].mem_id == mem_id){
					#>
						<div><#=cardRemarks[x].card_name#>:<#=cardRemarks[x].remark||"无"#></div>
					<#}}}#>
				</td>


				<td>
					<#   
						var hand_no = mem.hand_no;
						if(mem.is_backhand =="N"&& hand_no){
                        #>
						<button class="stress-btn" onclick="backHandNo('<#=hand_no#>')" style="line-height: 1.5;">归还<#=hand_no#>号手环</button>

                       <# if(mem_id!="-1"){#>
                         <br />
						<button onclick="showMemInfo('<#=mem_id#>','<#=mem.mem_name#>','<#=mem.gym#>','<#=mem.gymName#>','<#=mem.sex#>');" style="margin-top: 5px;line-height: 1.5;" class="default-btn">更多操作</button>
                       <# }#>
					<#		
						} else if("场内" == mem.state) {
                        if(mem_id!="-1"){
					#>
						<button class="stress-btn" onclick="lendHandNo('<#=mem_id#>','<#=mem.mem_gym#>')" style="line-height: 1.5;">借出手环</button>
						<br />
						<button onclick="showMemInfo('<#=mem_id#>','<#=mem.mem_name#>','<#=mem.gym#>','<#=mem.gymName#>','<#=mem.sex#>');" style="margin-top: 5px;line-height: 1.5;" class="default-btn">更多操作</button>
					<#
						}else{#>
						<button class="stress-btn" onclick="lendHandNo('<#=mem.checkin_id#>','<#=mem.mem_gym#>')" style="line-height: 1.5;">借出手环</button>
					<#	
						 }
					  }
					#>


				</td>
			</tr>
		<# 
			 } 
		 } else {
		#>
			<tr>
				<td colspan="7">今天暂无签到信息</td>
			</tr>
		<#		 
		 }
		#>
		</tbody>
	</table>
	</div>
	<div class="pager">
		<div>总数<#=list.total#>&nbsp;当前页条数<#=list.curSize#></div>
		<div>
			<#
				var cur = list.curPage;
				if(parseInt(cur) > parseInt(list.totalPage)){
					cur = list.totalPage
				}					
				if(list.curPage > 1){
					var pre = list.curPage - 1;
			#>
				<a href="javascript: void(0);" onclick="recentCheckin(1);"> 
					<i style="margin-right: -4px;">|</i> 
					<span class="fa fa-angle-left"></span>
				</a> 

				<a href="javascript: void(0);" onclick="recentCheckin(<#=pre#>);"> 
					<span class="fa fa-angle-left"></span>
				</a> 
			<#		
				} else {
			#>
				<a class="disabled" href="javascript: void(0);"> 
					<i style="margin-right: -4px;">|</i> 
					<span class="fa fa-angle-left"></span>
				</a>
				<a class="disabled" href="javascript: void(0);"> 
					<span class="fa fa-angle-left"></span>
				</a> 
			<#		
				}
			#>
			<input onkeyup="recentCheckin(this.value)" value="<#=cur#>" type="number" style="max-width: 55px; padding: 0 5px; height: 23px; margin: 0 5px 0 10px;">/<#=list.totalPage#>&nbsp;&nbsp; 
			
			<#
				if(parseInt(cur) < list.totalPage){
					var next = list.curPage + 1;						
			#>
				<a href="javascript: void(0)" onclick="recentCheckin(<#=next#>)"> 
					<span class="fa fa-angle-right"></span>
				</a> 
				<a href="javascript: void(0)" onclick="recentCheckin(<#=list.totalPage#>)"> 
					<span class="fa fa-angle-right"></span> <i style="margin-left: -4px;">|</i>
				</a>
			<#
				} else {
			#>
				<a class="disabled"> 
					<span class="fa fa-angle-right"></span>
				</a> 
				<a class="disabled"> 
					<span class="fa fa-angle-right"></span> <i style="margin-left: -4px;">|</i>
				</a>
			<#		
				}
			#>
		</div>
	</div>
</script>
<!--充值记录-->
<script type="text/html" id="memRechargeTpl">
<table class="custom-table">
	<thead>
		<tr>
			<th>充值时间</th>
			<th>充值金额</th>
			<th>实收金额</th>
			<th>操作人</th>
		</tr>
	</thead>
	<tbody>
	</tbody>
</table>
</script>
<!-- 请假记录 ---->
<script type="text/html" id="memLeavelTpl">
<div style="height: 300px;">
	<table class="custom-table">
		<thead>
			<tr>
				<th>开始时间</th>
				<th>结束时间</th>
				<th>销假时间</th>
				<th>请假天数</th>
				<th>请假状态</th>
			</tr>
		</thead>
		<tbody>
<#
		 var leaveList = list.leaveList;
		 if(leaveList && leaveList.length > 0){
			 for(var i=0; i<leaveList.length; i++){
				var item = leaveList[i];				 	
		#>
			<tr>
				<td><#=item.start_time#></td>
				<td><#=item.end_time#></td>
				<td><#=item.cancel_time#></td>
				<td><#=item.countDays#></td>
				<td><#=item.state#></td>
			</tr>
		<# 
			 }
		 } else {
		#>
			<tr>
				<td colspan="6">没有请假记录</td>
			</tr>
		<#		 
		 }
		#>
		</tbody>
	</table>
	</div>
	<div class="pager">
		<div>总数<#=list.total#>&nbsp;当前页条数<#=list.curSize#></div>
		<div>
			<#
				var cur = list.curPage;
				if(parseInt(cur) > parseInt(list.totalPage)){
					cur = list.totalPage
				}					
				if(list.curPage > 1){
					var pre = list.curPage - 1;
			#>
				<a href="javascript: void(0);" onclick="leaveinfo_list('<#=list.user_id#>',1);"> 
					<i style="margin-right: -4px;">|</i> 
					<span class="fa fa-angle-left"></span>
				</a> 

				<a href="javascript: void(0);" onclick="leaveinfo_list('<#=list.user_id#>',<#=pre#>);"> 
					<span class="fa fa-angle-left"></span>
				</a> 
			<#		
				} else {
			#>
				<a class="disabled" href="javascript: void(0);"> 
					<i style="margin-right: -4px;">|</i> 
					<span class="fa fa-angle-left"></span>
				</a>
				<a class="disabled" href="javascript: void(0);"> 
					<span class="fa fa-angle-left"></span>
				</a> 
			<#		
				}
			#>
			<input onkeyup="leaveinfo_list('<#=list.user_id#>',this.value)" value="<#=cur#>" type="number" style="max-width: 55px; padding: 0 5px; height: 23px; margin: 0 5px 0 10px;">/<#=list.totalPage#>&nbsp;&nbsp; 
			
			<#
				if(parseInt(cur) < list.totalPage){
					var next = list.curPage + 1;						
			#>
				<a href="javascript: void(0)" onclick="leaveinfo_list('<#=list.user_id#>',<#=next#>)"> 
					<span class="fa fa-angle-right"></span>
				</a> 
				<a href="javascript: void(0)" onclick="leaveinfo_list('<#=list.user_id#>',<#=list.totalPage#>)"> 
					<span class="fa fa-angle-right"></span> <i style="margin-left: -4px;">|</i>
				</a>
			<#
				} else {
			#>
				<a class="disabled"> 
					<span class="fa fa-angle-right"></span>
				</a> 
				<a class="disabled"> 
					<span class="fa fa-angle-right"></span> <i style="margin-left: -4px;">|</i>
				</a>
			<#		
				}
			#>
		</div>
	</div>
</script>

<!--  会员出入场记录    -->
<script type="text/html" id="memCheckinTpl">
	<div style="height: 300px;">
	<table class="custom-table">
		<thead>
			<tr>
				<th>入场类型</th>
				<th>入场时间</th>
				<th>出场时间</th>
				<th>手环号</th>
				<th>操作人</th>
				<th>备注</th>
			</tr>
		</thead>
		<tbody>
		<#
		 var checkinList = list.checkinList;
		 if(checkinList && checkinList.length > 0){
			 for(var i=0; i<checkinList.length; i++){
				var item = checkinList[i];				 	
		#>
			<tr>
				<td><#=item.checkin_type#></td>
				<td><#=item.checkin_time#></td>
				<td><#=item.checkout_time#></td>
				<#if(item.hand_no){
				#>
					<td><#=item.hand_no#></td>
				<#
				} else {
				#>
					<td>-</td>
				<#}#>
				<td><#=item.emp_name#></td>
				<#if(item.remark){
				#>
					<td><a href='javascript:showView("<#=item.remark#>");'>查看</a></td>
				<#
				} else {
				#>
					<td>无</td>
				<#}#>
			</tr>
		<# 
			 }
		 } else {
		#>
			<tr>
				<td colspan="6">没有出入场记录</td>
			</tr>
		<#		 
		 }
		#>
		</tbody>
	</table>
	</div>
	<div class="pager">
		<div>总数<#=list.total#>&nbsp;当前页条数<#=list.curSize#></div>
		<div>
			<#
				var cur = list.curPage;
				if(parseInt(cur) > parseInt(list.totalPage)){
					cur = list.totalPage
				}					
				if(list.curPage > 1){
					var pre = list.curPage - 1;
			#>
				<a href="javascript: void(0);" onclick="checkin_list('<#=list.user_id#>',1);"> 
					<i style="margin-right: -4px;">|</i> 
					<span class="fa fa-angle-left"></span>
				</a> 

				<a href="javascript: void(0);" onclick="checkin_list('<#=list.user_id#>',<#=pre#>);"> 
					<span class="fa fa-angle-left"></span>
				</a> 
			<#		
				} else {
			#>
				<a class="disabled" href="javascript: void(0);"> 
					<i style="margin-right: -4px;">|</i> 
					<span class="fa fa-angle-left"></span>
				</a>
				<a class="disabled" href="javascript: void(0);"> 
					<span class="fa fa-angle-left"></span>
				</a> 
			<#		
				}
			#>
			<input onkeyup="checkin_list('<#=list.user_id#>',this.value)" value="<#=cur#>" type="number" style="max-width: 55px; padding: 0 5px; height: 23px; margin: 0 5px 0 10px;">/<#=list.totalPage#>&nbsp;&nbsp; 
			
			<#
				if(parseInt(cur) < list.totalPage){
					var next = list.curPage + 1;						
			#>
				<a href="javascript: void(0)" onclick="checkin_list('<#=list.user_id#>',<#=next#>)"> 
					<span class="fa fa-angle-right"></span>
				</a> 
				<a href="javascript: void(0)" onclick="checkin_list('<#=list.user_id#>',<#=list.totalPage#>)"> 
					<span class="fa fa-angle-right"></span> <i style="margin-left: -4px;">|</i>
				</a>
			<#
				} else {
			#>
				<a class="disabled"> 
					<span class="fa fa-angle-right"></span>
				</a> 
				<a class="disabled"> 
					<span class="fa fa-angle-right"></span> <i style="margin-left: -4px;">|</i>
				</a>
			<#		
				}
			#>
		</div>
	</div>
</script>
