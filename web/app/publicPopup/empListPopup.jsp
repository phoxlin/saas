<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-public-empList" >
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left"  onclick="closePopup('.popup-public-empList');"></a>
		<h1 class="title" id="choice_emp_title">私人教练</h1>
	</header>
	<div class="bar bar-header-secondary">
	<input type="hidden" id="recommend_reach"/>
		<div class="searchbar" style="background: #2c2e47;">
			<div class="search-input">
				<label class="icon icon-search" for="search"></label> <input class="content-bg" type="search" id='emp-public_search' placeholder='搜索' />
			</div>
		</div>
<!-- 		<div class="alert alert-warning alert-dismissible fade in" role="alert"> -->
<!-- 			以下是您还未绑定的潜客 -->
<!-- 		</div> -->
	</div>
	<div class="content" id="emp-public-ListDiv">
	</div>
</div>
<script type="text/javascript">
$('#emp-public_search').on('input propertychange', function() {
     var search = $("#emp-public_search").val();
     choice_mc($("#recommend_reach").val(),search);
});

</script>
<script type="text/html" id="emp-public-ListTpl"> 

	<# 
		if(data){
       for(var i = 0;i<data.length;i++){
        var emp = data[i];
        var pic_url = emp.pic_url;
        if(!pic_url || pic_url.length <= 0){
        	pic_url = "app/images/head/default.png";
        }
    #>
			<div class="card facebook-card quanquan-card select-user " style="margin-top: 0;padding: 0.4rem 0.5rem 0.2rem;border-bottom: 1px solid #242537;" data-id="<#=emp.id#>"  data-name="<#=emp.name#>">
				<div class="card-header no-border " style="padding-bottom: 0;">
					<div class="facebook-avatar" style="margin-right: 0.5rem;">
						<img src="<#=pic_url#>" style="width: 1.8rem;height: 1.8rem;border-radius: 50%;">
					</div>
					<div class="facebook-name color-fff font-85">
						<#=emp.name#>
						<div style="display: inline-block;margin-left: 0.5rem;">
							<i class="icon-star2"></i>
							<i class="icon-star2"></i>
							<i class="icon-star2"></i>
							<i class="icon-star2"></i>
							<i class="icon-star2"></i>
	            		</div>
					</div>
					<div class="facebook-date">
						<# 
		               		var labels = emp.labels == undefined ? "":emp.labels;
		                  	var label=  labels.split(",");
		                  	if(label && label.length > 0 && label[0].length > 0){
		                  		for(var j = 0;j<label.length;j++){
		                  			var summary = emp.summary;
		               #>
									<span class="tag"><#=label[j]#></span>
		               <# 
		                  		}
		                  	} else {
		                #>
		                	<span class="font-70 color-ccc">暂无标签</span>
		                <#
		                  	}    
		               #>
					</div>
				</div>
				
			</div>
    <#
    	}
	}#>
</script>