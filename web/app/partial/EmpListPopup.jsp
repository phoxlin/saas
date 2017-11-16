<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-empList" >
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left"  onclick="closePopup('.popup-empList');"></a>
		<h1 class="title">私人教练</h1>
	</header>
	<div class="content" id="empListDiv">
	</div>
</div>
<script type="text/html" id="empListTpl">
	<# 
		if(data){
       for(var i = 0;i<data.length;i++){
        var emp = data[i];
        var pic_url = emp.wxHeadUrl;
		var summary = emp.summary;
        if(!pic_url || pic_url.length <= 0){
        	pic_url = "app/images/head/default.png";
        }
    #>
			<div class="card facebook-card quanquan-card" style="margin-top: 0;" onclick="shwoEmpDetial('<#=emp.id#>')">
				<div class="card-header no-border" style="padding-bottom: 0;">
					<div class="facebook-avatar" style="margin-right: 0.5rem;">
						<img src="<#=pic_url#>" style="width: 1.8rem;height: 1.8rem;border-radius: 50%;">
					</div>
					<div style="width: 2.5rem;float: right;" class="font-70">
						<button class="custom-btn custom-btn-primary" style="padding: 0.25rem 0.55rem;" onclick="memPrivateOrder('<#=emp.id#>')">预约</button>
					</div>
					<div class="facebook-name color-fff font-85" style="margin-right: 2.5rem;">
						<#=emp.name#>
						<div style="display: inline-block;margin-left: 0.5rem;">
							<i class="icon-star2"></i>
							<i class="icon-star2"></i>
							<i class="icon-star2"></i>
							<i class="icon-star2"></i>
							<i class="icon-star2"></i>
	            		</div>
					</div>
					<div class="facebook-date" style="margin-right: 2.5rem;">
						<# 
		               		var labels = emp.labels == undefined ? "":emp.labels;
		                  	var label=  labels.split(",");
		                  	if(label && label.length > 0 && label[0].length > 0){
		                  		for(var j = 0;j<label.length;j++){
		               #>
									<span class="tag"><#=label[j]#></span>
		               <# 
		                  		}
		                  	} else {
		                #>
		                	<span class="font-70 color-999">暂无标签</span>
		                <#
		                  	}    
		               #>
					</div>
				</div>
				<div class="card-content" style="padding: 0 2% 2rem;">
					<div class="row" style="margin-left: 0;">
					<#
						if(emp.pic1){
					#>
						<div class="col-33" style="width: 31.333333333333332%;margin-left: 2%;"><img src="<#=emp.pic1#>?imageView2/1/w/200/h/180" style="width: 100%;height: 5.62rem;"/></div>
					<#		
						} if(emp.pic2){
					#>
						<div class="col-33" style="width: 31.333333333333332%;margin-left: 2%;"><img src="<#=emp.pic2#>?imageView2/1/w/200/h/180" style="width: 100%;height: 5.62rem;"/></div>
					<#		
						} if(emp.pic3){
					#>
						<div class="col-33" style="width: 31.333333333333332%;margin-left: 2%;"><img src="<#=emp.pic3#>?imageView2/1/w/200/h/180" style="width: 100%;height: 5.62rem;"/></div>
					<#		
						} if(summary && summary.length > 0){
					#>
						<%--
						<div class="col-100 font-80 color-666" style="margin-left: 0;padding-left: 3%;"><#=summary#></div>
						--%>
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