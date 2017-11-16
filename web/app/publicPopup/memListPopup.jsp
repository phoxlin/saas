<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-public-memList" >
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left"  onclick="closeChoseMemPopup('.popup-public-memList');"></a>
		<h1 class="title">选择会员</h1>
	</header>
	<div class="bar bar-header-secondary">
		<div class="searchbar">
			<div class="search-input">
				<input type="hidden" id="add_mem_choice_mem_pt_id">
				<input type="hidden" id="searchMemType">
				<label class="icon icon-search" for="search"></label> <input type="search" id='mem-public_search' placeholder='搜索' />
			</div>
		</div>
<!-- 		<div class="alert alert-warning alert-dismissible fade in" role="alert"> -->
<!-- 			以下是您还未绑定的潜客 -->
<!-- 		</div> -->
	</div>
	<div class="content" id="mem-public-ListDiv">
	</div>
</div>
<script type="text/javascript">
$('#mem-public_search').on('input propertychange', function() {
     var search = $("#mem-public_search").val();
     var pt_id = $("#add_mem_choice_mem_pt_id").val();
     var type = $("#searchMemType").val();
     if(type == "sales_add_mem_choice_mem"){
    	 sales_add_mem_choice_mem(10,search,pt_id);
     }else if(type == "add_mem_choice_mem"){
    	 add_mem_choice_mem(10,search,pt_id);
     }
});

</script>
<script type="text/html" id="mem-public-ListTpl"> 

	<# 
		if(data){
       for(var i = 0;i<data.length;i++){
        var mem = data[i];
        var pic_url = mem.wx_head;
        if(!pic_url || pic_url.length <= 0){
        	pic_url = "app/images/head/default.png";
        }
    #>
			<div class="card facebook-card quanquan-card select-user " style="margin-top: 0;padding: 0.1rem 0.2rem 0.2rem;border-bottom: 1px solid #242537;" data-id="<#=mem.id#>"  data-name="<#=mem.mem_name#>">
				<div class="card-header no-border " style="padding-bottom: 0;">
					<div class="facebook-avatar" style="margin-right: 0.5rem;">
						<img src="<#=pic_url#>" style="width: 1.8rem;height: 1.8rem;border-radius: 50%;">
					</div>
					<div class="facebook-name color-fff font-85">
						<#=mem.mem_name#>
					</div>
					<div class="facebook-date"><#=mem.phone#></div>
					
				</div>
				
			</div>
    <#
    	}
	}#>
<#if(state=="Y"){
	if(type == "sales"){
#>
		<div class="item-inner" onclick="sales_add_mem_choice_mem('<#=cur+10#>'),''">
<#}else{#>
		<div class="item-inner" onclick="add_mem_choice_mem('<#=cur+10#>'),''">
<#}#>
			<div class="item-text font-70 color-999"
				style="height: 2rem;line-height: 2rem; text-align: center;">加载更多&nbsp;&nbsp;+</div>
		</div>
	<#}#>
</script>