<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="popup popup-addNewMem dark" id="popup-addNewMem">
<script type="text/javascript">
//解绑
function cancelEmp(type){
	if(type == "mc"){
		$("#new_mem_choice_mc_name").val("");
		$("#new_mem_choice_mc_id").val("");
	}else if(type == "pt"){
		
		$("#new_mem_choice_pt_name").val("");
		$("#new_mem_choice_pt_id").val("");
	}else{
		$("#new_mem_choice_mem_name").val("");
		$("#new_mem_choice_mem_id").val("");
		
	}
	
}
</script>
	<header class="bar bar-nav">
			<a class="icon icon-left pull-left" onclick="closePopup('.popup-addNewMem')"></a>
			<h1 class="title">新入会</h1>
	</header>
	<div class="content">
	<form method="post" id="add_mem_form">
  <div class="list-block font-75" style="margin-top: 0;">
    <ul>
      <!-- Text inputs -->
     <li>
        <div class="item-content">
          <div class="item-inner">
          <div class="item-media color-warn" style="width: 0.5rem;">*</div>
            <div class="item-title label color-999">联系电话</div>
            <div class="item-input">
              <input type="text" class="font-75 color-fff" id="new_mem_phone" name="new_mem_phone" placeholder="电话" onkeyup="search_recommend()">
            </div>
          </div>
        </div>
      </li>
      
      <li>
        <div class="item-content">
          <div class="item-inner">
          <div class="item-media color-warn" style="width: 0.5rem;">*</div>
            <div class="item-title label color-999">姓名</div>
            <div class="item-input">
              <input class="font-75 color-fff" type="text" id="new_mem_name" name="new_mem_name" placeholder="姓名">
            </div>
          </div>
        </div>
      </li>
      <li>
        <div class="item-content">
          <div class="item-inner">
          <div class="item-media color-warn" style="width: 0.5rem;">*</div>
            <div class="item-title label color-999">性别</div>
            <div class="item-input">
              <select class="font-75 color-fff" id="new_mem_sex" name="new_mem_sex">
                <option value="Male">男</option>
                <option value="Female">女</option>
              </select>
            </div>
          </div>
        </div>
      </li>
        <li>
        <div class="item-content">
          <div class="item-inner">
          <div class="item-media color-warn" style="width: 0.5rem;"></div>
            <div class="item-title label color-999">生日</div>
            <div class="item-input">
              <input type="text" class="font-75 color-fff" id="" name="new_mem_birthday" readonly="readonly">
            </div>
          </div>
        </div>
      </li>
      <li>
        <div class="item-content">
          <div class="item-inner">
          <div class="item-media color-warn" style="width: 0.5rem;"></div>
            <div class="item-title label color-999">推荐人</div>
            <div class="item-input">
            	<div onclick="add_mem_choice_mem(10)">
              		<input type="text" class="font-75 color-fff" placeholder="点击选择推荐会员" id="new_mem_choice_mem_name"  disabled="disabled" style="width:130px;">
              	</div>
              	<input type="hidden"  id="new_mem_choice_mem_id" name="new_mem_choice_mem_id" style="width:130px;">
            </div>
            <div class="item-after">
              	<span  class="button button-fill custom-btn-primary" style="width: 2.5rem;" onclick="cancelEmp('mem')">解绑 </span>
            </div>
          </div>
        </div>
      </li>
      <li>
        <div class="item-content">
          <div class="item-inner">
          <div class="item-media color-warn" style="width: 0.5rem;"></div>
            <div class="item-title label color-999">身份证</div>
            <div class="item-input">
              <input type="text" class="font-75 color-fff" id="new_mem_card" name="new_mem_card" placeholder="身份证">
            </div>
          </div>
        </div>
      </li>
      <li>
        <div class="item-content">
          <div class="item-inner">
          <div class="item-media color-warn" style="width: 0.5rem;"></div>
            <div class="item-title label color-999">健身目的</div>
            <div class="item-input">
              <input type="text" class="font-75 color-fff" id="new_mem_fit" name="new_mem_fit" placeholder="健身目的">
            </div>
          </div>
        </div>
      </li>
      <li>
         <div class="buttons-tab">
    <a href="#" class="tab-link active button" onclick="getCardByType('001')">时间卡</a>
    <a href="#" class="tab-link button" onclick="getCardByType('003')">次卡</a>
    <a href="#" class="tab-link button" onclick="getCardByType('006')">私教卡</a>
    <a href="#" class="tab-link button" onclick="getCardByType('002')">储值卡</a>
    <input type="hidden" id="hideen_card_type"/>
  </div>
      </li>
      <li id = "add_mem_div">
      <li class="align-top">
        <div class="item-content">
          <div class="item-inner">
            <div class="item-input" id="new_mem_show_card" style="line-height: 1.8;padding: 0.3rem 0;">
              
            </div>
          </div>
        </div>
      </li>
      
       <li>
        <div class="item-content">
          <div class="item-inner">
          <div class="item-media color-warn" style="width: 0.5rem;">*</div>
            <div class="item-title label color-999">卡种名称</div>
            <div class="item-input">
              <input type="text" class="font-75 color-fff" id="new_mem_card_name" name="new_mem_card_name" readonly="readonly">
            </div>
          </div>
        </div>
      </li>
       <li>
        <div class="item-content">
          <div class="item-inner">
          <div class="item-media color-warn" style="width: 0.5rem;">*</div>
            <div class="item-title label color-999">金额</div>
            <div class="item-input">
              <input type="text" class="font-75 color-fff" id="new_mem_price" name="new_mem_price" readonly="readonly">
            </div>
          </div>
        </div>
      </li>
       <li>
        <div class="item-content">
          <div class="item-inner">
          <div class="item-media color-warn" style="width: 0.5rem;">*</div>
            <div class="item-title label color-999">优惠价</div>
            <div class="item-input">
              <input type="text" class="font-75 color-fff" id="new_mem_discount_price" name="new_mem_discount_price">
            </div>
          </div>
        </div>
      </li>
       <li>
        <div class="item-content">
          <div class="item-inner">
          <div class="item-media color-warn" style="width: 0.5rem;"></div>
            <div class="item-title label color-999">天数</div>
            <div class="item-input">
              <input type="text" class="font-75 color-fff" id="new_mem_day" name="new_mem_day" readonly="readonly">
            </div>
          </div>
        </div>
      </li>
       <li id="timesDiv">
        <div class="item-content">
          <div class="item-inner">
          <div class="item-media color-warn" style="width: 0.5rem;">*</div>
            <div class="item-title label color-999">次数</div>
            <div class="item-input">
              <input type="text" class="font-75 color-fff" id="new_mem_times" name="new_mem_times" readonly="readonly">
            </div>
          </div>
        </div>
      </li>
       <li id="amtDiv">
        <div class="item-content" >
          <div class="item-inner">
          <div class="item-media color-warn" style="width: 0.5rem;">*</div>
            <div class="item-title label color-999">储值金额</div>
            <div class="item-input">
              <input type="text" class="font-75 color-fff" id="new_mem_amt" name="new_mem_amt" readonly="readonly">
            </div>
          </div>
        </div>
      </li>
       <li>
        <div class="item-content">
          <div class="item-inner">
          <div class="item-media color-warn" style="width: 0.5rem;">*</div>
            <div class="item-title label color-999">激活类型</div>
            <div class="item-input">
              <select class="font-75 color-fff" id="new_mem_activate_type" name="new_mem_activate_type" onchange="showActiveTime()">
                <option value="001">立即激活</option>
                <option value="002">首次刷卡开卡</option>
                <option value="003">指定日期开卡</option>
                <option value="004">同意开卡</option>
              </select>
            </div>
          </div>
        </div>
      </li>
       <li>
        <div class="item-content" id="new_mem_active_time_div">
          <div class="item-inner">
          <div class="item-media color-warn" style="width: 0.5rem;">*</div>
            <div class="item-title label color-999">激活时间</div>
            <div class="item-input">
              <input type="text" class="font-75 color-fff" id="new_mem_active_time" name="new_mem_active_time">
            </div>
          </div>
        </div>
      </li>
      <li>
        <div class="item-content">
          <div class="item-inner">
          <div class="item-media color-warn" style="width: 0.5rem;">*</div>
            <div class="item-title label color-999">合同编号</div>
            <div class="item-input">
              <input type="text" class="font-75 color-fff" id="new_mem_contract_no" name="new_mem_contract_no">
            </div>
            <div class="item-after">
              <a href="#" style="width: 2.5rem;" class="button button-fill custom-btn-primary" onclick="createCardNo('new_mem_contract_no')">生成</a>
            </div>
          </div>
        </div>
      </li>
      
      <li id="new_mem_pt_div">
        <div class="item-content">
          <div class="item-inner">
          <div class="item-media color-warn" style="width: 0.5rem;"></div>
            <div class="item-title label color-999">所属教练</div>
            <div class="item-input">
            <div onclick="add_mem_choice_mc('PT')">
              <input type="text" class="font-75 color-fff" placeholder="点击选择教练" id="new_mem_choice_pt_name"  disabled="disabled" style="width:130px;">
              </div>
              <input type="hidden"  id="new_mem_choice_pt_id" name="new_mem_choice_pt_id" style="width:130px;">
            </div>
            
            <div class="item-after">
              	<span  class="button button-fill custom-btn-primary" style="width: 2.5rem;" onclick="cancelEmp('pt')">解绑 </span>
            </div>
          </div>
        </div>
      </li>
      <li id="new_mem_mc_div">
        <div class="item-content">
          <div class="item-inner">
          <div class="item-media color-warn" style="width: 0.5rem;">*</div>
            <div class="item-title label color-999">所属会籍</div>
            <div class="item-input">
            <div onclick="add_mem_choice_mc('MC')">
              <input type="text" class="font-75 color-fff" placeholder="点击选择会籍" id="new_mem_choice_mc_name"  disabled="disabled" style="width:130px;">
              </div>
              <input type="hidden"  id="new_mem_choice_mc_id" name="new_mem_choice_mc_id" style="width:130px;">
            </div>
            
            <div class="item-after">
              	<span  class="button button-fill custom-btn-primary" style="width: 2.5rem;" onclick="cancelEmp('mc')">解绑 </span>
            </div>
          </div>
        </div>
      </li>
      <li>
        <div class="item-content">
          <div class="item-inner">
          <div class="item-media color-warn" style="width: 0.5rem;"></div>
            <div class="item-title label color-999">业务来源</div>
            <div class="item-input">
              <select id="new_mem_source" class="font-75 color-fff" name="new_mem_source" onchange="showActiveTime()">
					<option value="1">WI-到访</option>
					<option value="2">APPT-电话邀约</option>
					<option value="3">BR-转介绍</option>
					<option value="4">TI-电话咨询</option>
					<option value="5">DI-拉访</option>
					<option value="6">POS</option>
					<option value="7">场开</option>
					<option value="8">体测</option>
					<option value="9">续费</option>
				
              </select>
            </div>
          </div>
        </div>
      </li>
      <li>
        <div class="item-content">
          <div class="item-inner">
          <div class="item-media color-warn" style="width: 0.5rem;"></div>
          <span class="color-warn">注:如果选择的是时间卡 则赠送时间 ,如果选择的是次卡或者私教卡则赠送次数,如果选择的是储值卡则赠送月余额</span>
          </div>
        </div>
      </li>
      <li>
        <div class="item-content">
          <div class="item-inner">
          <div class="item-media color-warn" style="width: 0.5rem;"></div>
            <div class="item-title label color-999" id="giveTitle">赠送天数</div>
            <div class="item-input">
              <input type="text" class="font-75 color-fff" id="new_mem_give_days" name="new_mem_give_days">
            </div>
          </div>
        </div>
      </li>
      <li>
        <div class="item-content">
          <div class="item-inner">
          <div class="item-media color-warn" style="width: 0.5rem;"></div>
            <div class="item-title label color-999">赠送私课</div>
            <div class="item-input">
              <select id="new_mem_send_card" class="font-75 color-fff" name="new_mem_send_card">
                <option value="001">大大大</option>
                <option value="002">大师傅</option>
              </select>
            </div>
          </div>
        </div>
      </li>
       <li>
        <div class="item-content">
          <div class="item-inner">
          <div class="item-media color-warn" style="width: 0.5rem;"></div>
            <div class="item-title label color-999">赠私课数</div>
            <div class="item-input">
              <input type="text" class="font-75 color-fff" id="new_mem_give_times" name="new_mem_give_times">
            </div>
          </div>
        </div>
      </li>
      <li class="align-top">
        <div class="item-content">
          <div class="item-inner">
          <div class="item-media color-warn" style="width: 0.5rem;"></div>
            <div class="item-title label color-999">备注</div>
            <div class="item-input">
              <textarea name="new_mem_remark" class="font-75 color-fff"></textarea>
            </div>
          </div>
        </div>
      </li>
    </ul>
  </div>
  </form>
  <div class="content-block">
    <div class="row" id="new_mem_btn">
    
    </div>
  </div>
</div>
</div>   
<script type="text/javascript">
var now = new Date().Format("yyyy-MM-dd");
$("#new_mem_birthday").calendar({
    value: [now]
});
</script>
<script type="text/html" id="BuyCard_CardTpl">
   <# if(list){
	#>
	<div class="row">
	<#
       for(var i = 0;i<list.length;i++){
		var state = "";
		if(list[i].is_fanmily == "Y"){
			state = "disabled";
		}
   #>
		
       <div class="col-33 line-one" style="line-height: 2.2;">
			<#if(state == "disabled"){#>
			<label for="<#=list[i].id#>" onclick="showCardDetial('<#=list[i].id#>','<#=list[i].is_fanmily#>')" >
       			<#=list[i].card_name#>
			</label>
			<#}else{#>
			&nbsp;<input style="vertical-align: middle;" type="radio" onclick="showCardDetial('<#=list[i].id#>','<#=list[i].is_fanmily#>')" name="new_mem_card_id" value="<#=list[i].id#>" id="<#=list[i].id#>" <#=state#>/>
			<label for="<#=list[i].id#>">
       			<#=list[i].card_name#>
			</label>
			<#}#>
		</div>
   <# }#>
	</div>
	<#}#>
</script>