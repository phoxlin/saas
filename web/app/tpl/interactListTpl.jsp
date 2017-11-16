<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/html" id="interactListTpl">
<#
	if(list){
		for(var i=0; i<list.length; i++){
			var item = list[i];
			var pic_count = item.pic_count;
			var pics = item.pics;
			var pic_url = item.pic_url;
			if(!pic_url ||pic_url == null || pic_url.length <= 0){
				pic_url = "app/images/head/default.png";
			}
#>
		<div class="card facebook-card quanquan-card">
			<div class="card-header no-border">
			  <div class="facebook-avatar">
			  	<img style="border-radius: 50%;width: 1.8rem;height: 1.8rem;" src="<#=pic_url#>">
			  </div>
			  <div class="facebook-name font-80 color-fff"><#=item.nickName#></div>
			  <div class="facebook-date"><#if(item.content){#><#=item.content#><#}#></div>
			</div>
			<div class="card-content color-666" style="margin-left: 2.5rem;">
				<#
					if(pic_count == 1){
				#>
					<div class="row">
						<div class="col-100">
							<img style="max-height: 10rem;max-width: 96%;" src="<#=pics[0]#>" onclick="showAllPics('<#=0#>', this)" >
						</div>
					</div>
				<#	
					} else {
				#>
					<div class="row" style="padding-right: 4%;">
				<#					
						for(var j=0; j<pics.length; j++){
				#>
						<div class="col-33">
							<img style="margin-bottom: 0.5rem;" src="<#=pics[j]+'?imageView2/1/w/160/h/160'#>" onclick="showAllPics('<#=j#>', this)" width="100%"/>
						</div>
				<#						
						}
				#>
					</div>
				<#
					}
				#>
			</div>
			<div class="card-footer no-border color-999" style="margin-left: 2rem;">
				<div class="row" style="width: 100%;">
					<div class="col-70"><#=item.release_time#></div>
					<div class="col-30" style="text-align: right;">
						<#
							if(item.zan){
						#>
							<i class="icon icon-zan2" onclick="zan('<#=item.id#>', this)"></i>&nbsp;
						<#		
							} else {
						#>
							<i class="icon icon-zan" onclick="zan('<#=item.id#>', this)"></i>&nbsp;
						<#		
							}
						#>
						<label class="font-75" style="vertical-align: text-top;"><#=item.g_num#></label>
					</div>
				</div>
			</div>
		</div>
<#		
		}
	if("Y" == flag && 2 == next){
#>
	<div class="font-70 color-999" style="padding: 0.5rem 0;text-align: center;">已经没有了</div>
<#
	} else if("N" == flag && 2 == next){
#>
	<div onclick="showInteract('<#=next#>', this)" class="font-70 color-999" style="padding: 0.5rem 0;text-align: center;">加载更多 +</div>
<#
	}		
	} else {
#>
	<div class="font9 none-info">还没有达人发布圈圈哦</div>
<#		
	}
#>
</script>
<script type="text/javascript">
	function zan(interact_id, obj){
		$.ajax({
			type : "POST",
			url : "fit-app-action-interactZan",
			data : {
				cust_name : cust_name,
				gym : gym,
				user_id : id,
				interact_id : interact_id
			},
			dataType : "json",
			success : function(data) {
				$.hideIndicator();
				if (data.rs == "Y") {
					if($(obj).hasClass("icon-zan2")){
						$(obj).removeClass("icon-zan2");
						$(obj).addClass("icon-zan");
						var x = $(obj).siblings("label").text();
						$(obj).siblings("label").text(parseInt(x)-1);
					} else {
						$(obj).addClass("icon-zan2");
						var x = $(obj).siblings("label").text();
						$(obj).siblings("label").text(parseInt(x)+1);
					}
				} else {
					$.toast(data.rs);
				}
			},
			error : function(){
				$.alert("啊哦，网络繁忙，请稍后再试");
			}
		});
	}
</script>