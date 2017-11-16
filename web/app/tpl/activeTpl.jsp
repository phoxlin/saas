<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 签到排行TPL -->
<script type="text/html" id="sign-in-listTpl">
<#
if(list){
#>
	<div class="row content-bg" style="text-align: center;line-height: 1.3;padding-top: 1.8rem;padding-bottom: 0.75rem;">
		<div class="col-33" style="position: relative;">
			<#
				if(list.length >= 2 ){
					var mem = list[1];					
			#>
				<i class="icon icon-2th"></i>
				<img src='<#=mem.pic_url || "app/images/head/default.png"#>' class="head" style="width: 2.5rem;height: 2.5rem;"/>
				<div class="font-75 color-fff"><#=mem.mem_name#></div>
				<div class="font-65 color-basic" style="font-weight: 700;"><#=mem.count#>次</div>
			<#
				} else {
			#>
				<span class="color-fff">2</span>
			<#
				}
			#>
		</div>
		<div class="col-33" style="position: relative;">
			<#
				if(list.length >= 1 ){
					var mem = list[0];	
			#>
				<i class="icon icon-1th"></i>
				<img src='<#=mem.pic_url || "app/images/head/default.png"#>' class="head" style="width: 3.2rem;height: 3.2rem;"/>
				<div class="font-75 color-fff"><#=mem.mem_name#></div>
				<div class="font-65 color-basic" style="font-weight: 700;"><#=mem.count#>次</div>
			<#
				} else {
			#>
				<span class="color-fff">1</span>
			<#
				}
			#>
		</div>
		<div class="col-33" style="position: relative;">
			<#
				if(list.length >= 3 ){
					var mem = list[2];	
			#>
				<i class="icon icon-3th"></i>
				<img src='<#=mem.pic_url || "app/images/head/default.png"#>' class="head" style="width: 2.5rem;height: 2.5rem;"/>
				<div class="font-75 color-fff"><#=mem.mem_name#></div>
				<div class="font-65 color-basic" style="font-weight: 700;"><#=mem.count#>次</div>
			<#
				} else {
			#>
				<span class="color-fff">1</span>
			<#
				}
			#>
		</div>
	</div>
<#
}
#>

<#if(list){
	var flag = false;
	var my_rank = 0;
	var my_count = 0;
	var pic_url = "app/images/head/default.png";
	for(var i=0;i<list.length;i++){
		var mem = list[i];
		if(m.id == mem.id){
			my_rank = i+1;
			flag = true;
			my_count = mem.count;
			if(mem.pic_url){
				pic_url = mem.pic_url
			}
		}
	}
#>
	<ul>
		<li class="item-content" style="padding-right: 0.75rem;">
			<div class="item-media">
				<img src='<#=m.headUrl#>' class="head" style="width: 2.5rem;height: 2.5rem;"/>
			</div>
			<div class="item-inner">
				<div class="item-title-row">
					<div class="item-title font-70 color-999">
						我的排名
					</div>
				</div>
				<div class="item-subtitle font-80 color-fff">
					<#if(flag){#>打卡<#=my_count#>次<#}#>
				</div>
			</div>
			<div class="item-after color-basic">
				<#if(flag){#>
					第<#=my_rank#>名
				<#}else{#>
					您不是本会所的注册会员
				<#}#>
			</div>
		</li>
	</ul>
<#}#>

<#if(list){
#>
	<ul style="margin-top: 0.5rem;">
<#	
	for(var i=0;i<list.length;i++){
	var mem = list[i];
#>
			<li class="item-content" style="padding-right: 0.75rem;">
				<div class="item-media">
					<img src="<#=mem.pic_url || "app/images/head/default.png"#>" style="width: 2rem;height: 2rem;" class="head">
				</div>
				<div class="item-inner">
					<div class="item-title font-65 color-999">
						<#=mem.mem_name#> 
					</div>
					<div class="item-subtitle font-85 font-333">
						<#=mem.count#>次
					</div>
				</div>
				<div class="item-after color-fff font-80">
					<#
						if(i == 0){
					#>
						<span class="bg-1th"><#=i+1#></span>
					<#
						} else if(i == 1){
					#>
						<span class="bg-2th"><#=i+1#></span>
					<#
					<#
						} else if(i == 2){
					#>
						<span class="bg-3th"><#=i+1#></span>
					<#
						} else {
					#>
						<#=i+1#><span class="font-65 color-666" style="line-height: 2;">th</span>
					<#
						}
					#>
				</div>
			</li>
<#
	}
#>
	</ul>
<#
}else{
#>
	<div class="none-info font-90">还没有会员签到</div>
<#}#>
</script>

<!-- 打卡 文字记录popup -->
<div class="popup popup-sign-in-write-remark dark" id="popup-sign-in-write-remark">
	<header class="bar bar-nav">
			<a class="icon icon-left pull-left"  onclick="$('#sign_imgs').val('');closePopup('.popup-sign-in-write-remark');"></a>
			<h1 class="title">打卡</h1>
	</header>
	<div class="content">
	 <div class="list-block font-75" style="margin-top: 0;">
	 	<ul>
	 		<li>
	 			<div class="item-content">
		          <div class="item-inner" style="padding-right: 0;">
		            <div class="item-title label" style="width: 60%"></div>
		            <div class="item-input color-999">
		            	<label class="label-checkbox item-content" style="float: right;margin-right: 0.5rem;">
		 					<input type="checkbox" id="andSendToQQ" checked="checked">
							<div class="item-media">
								<i class="icon icon-form-checkbox" style="width: 0.8rem; height: 0.8rem;"></i>&nbsp;同步到圈圈
							</div>
						</label>
		            </div>
		          </div>
		        </div>
	 		</li>
	 		<li>
	 			<div class="item-content">
		          <div class="item-inner">
		           	<textarea rows="" cols="" id="sign_remark">我打卡,我骄傲。</textarea>
		          </div>
		        </div>
	 		</li>
	 		<li>
	 			<!-- 图片展示区域 -->
	 			<input type='hidden' id="sign_imgs">
	 			<div id="sign_imgs_div" style="padding: 0.5rem;">
	 			</div>
	 		</li>
	 		<li>
	 			<div class="item-content">
		          <div class="item-inner">
		           	<div class="item-title label" style="width: 60%" onclick="choosePhoto(9)">添加图片+</div>
		            <div class="item-input" style="text-align: right;">
		               <button style="display: inline-block;" onclick="submit_sign_dairy()" class="button button-fill custom-btn-primary">提交记录</button>
		            </div>
		          </div>
		        </div>
	 		</li>
	 	</ul>
		
		
	 </div>		
	</div>
</div>

<!-- 打卡记录popup -->

<div class="popup popup-sign-in-record" id="popup-sign-in-record">
	<header class="bar bar-nav">
			<a class="icon icon-left pull-left"  onclick="closePopup('.popup-sign-in-record');"></a>
			<h1 class="title">我的打卡</h1>
	</header>
	
	<div class="content" id="sign_reocrd_list">
		 <div class="content-block-title">我的第一次打卡</div>
		 <div class="card demo-card-header-pic">
		   <div valign="bottom" class="card-header color-white no-border no-padding">
		     <img class='card-cover' src="//gqianniu.alicdn.com/bao/uploaded/i4//tfscom/i3/TB10LfcHFXXXXXKXpXXXXXXXXXX_!!0-item_pic.jpg_250x250q60.jpg" alt="">
		   </div>
		   <div class="card-content">
		     <div class="card-content-inner">
		       <p class="color-gray">发表于 2015/01/15</p>
		       <p>此处是内容...</p>
		     </div>
		   </div>
  </div>
	
	</div>
</div>

<!-- 打卡记录TPL -->
<script type="text/html" id="sign_reocrd_listTpl">
<#if(list){#>
	<#for(var i=list.length-1;i>=0;i--){
		var sign = list[i];
	#>
		<div class="content-block-title">我的第<#=i+1#>次打卡</div>
		 <div class="card demo-card-header-pic">
		   <div valign="bottom" class="card-header color-white no-border no-padding">
		     <img class='card-cover' src="//gqianniu.alicdn.com/bao/uploaded/i4//tfscom/i3/TB10LfcHFXXXXXKXpXXXXXXXXXX_!!0-item_pic.jpg_250x250q60.jpg" alt="">
		   </div>
		   <div class="card-content">
		     <div class="card-content-inner">
		       <p class="color-gray">发表于 <#=sign.sign_time.substring(0,16)#></p>
		       <p><#=sign.remark || ""#></p>
		     </div>
		   </div>
		</div>
	<#}#>
<#}else{#>
	我还没有打过卡。。
<#}#>
</script>




<!-- popup -->
<div class="popup popup-sign-in-rank" id="popup-sign-in-rank">
<header class="bar bar-nav">
		<a class="icon icon-left pull-left"  onclick="closePopup('.popup-sign-in-rank');"></a>
		<h1 class="title">本月签到排行(前50)</h1>
</header>
<div class="content">
	<div class="list-block media-list border-list" id="sign-in-list" style="margin-top: 0;">
	</div>
</div>
</div>
<!-- 活动列表popup -->
<div class="popup popup-active-list" id="popup-active-list">
<header class="bar bar-nav">
		<a class="icon icon-left pull-left"  onclick="closePopup('.popup-active-list');"></a>
		<h1 class="title">会员活动</h1>
</header>
<div class="content">
  <div class="list-block media-list no-border" style="margin-top: 2px" id="acitve-list">
    <ul>
      <li>
        <a href="#" class="item-link item-content">
          <div class="item-inner">
            <div class="item-title-row">
              <div class="item-title">时间卡半折啦</div>
              <div class="item-after">2017-8-1</div>
            </div>
            <div class="item-subtitle">好消息好消息,所有的时间卡打折一半</div>
          </div>
        </a>
      </li>
    </ul>
  </div>
</div>
</div>

<!-- 活动详情popup -->
<div class="popup popup-active-detail" id="popup-active-detail">
 
</div>
<!-- 活动列表TPL -->
<script type="text/html" id="active-listTpl">
<#if(list){#>
<ul>
	<#for(var i=0;i<list.length;i++){
		var active = list[i];
	#>
	<li>
		<li onclick="showActive('<#=active.id#>')" class="item-content" style="margin-top: 1px;border-bottom: 1px solid #242537;">
				<div class="item-media">
					<img src="<#=active.pic_url?(active.pic_url+'?imageView2/1/w/500/h/276'):'app/images/temp/1.jpg'#>" style='width: 5rem;'>
				</div>
				<div class="item-inner">
					<div class="item-title-row" style="height: 2rem;">
						<div class="item-title font-85 color-fff">
							<#=active.title#>
						</div>
					</div>
					<div class="item-subtitle font-70 color-ccc">
							<#=active.summary || "暂无简介,请看图文介绍"#>
					</div>
					<div class="item-subtitle font-70 color-999">
						活动时间 <#=active.start_time.substring(0,16) || "--"#>&nbsp;&nbsp;到<#=active.end_time.substring(0,16) || "--"#>
					</div>
				</div>
		</li>
	<#}#>
</ul>
<#}else{#>
	<div class="none-info font-90">暂无活动</div>
<#}#>	
</script>
<!-- 首页推荐活动列表TPL -->
<script type="text/html" id="index_commendTpl">
	<#if(list && list.length > 0){#>
		<p class="font-80 color-ccc" style="padding: 0.3rem 0.75rem; margin: 0;">为你推荐</p>
	<#	for(var i=0;i<list.length;i++){
			var active = list[i];
	#>
		<div class="font-85 color-fff top-active">
			<img src=<#=active.pic_url?(active.pic_url+'?imageView2/1/w/500/h/276'):"app/images/temp/activity.jpg"#> onclick="showActive('<#=active.id#>')"/> <span onclick="showActive('<#=active.id#>')"><#=active.title#></span>
		</div>
	<#}
	#>
	<div class="font-70 color-ccc" style="padding: 0.5rem 0;text-align: center;">已经没有了</div>
	<#
	}else{#>
		<p class="font-80 color-fff" style="padding: 0.3rem 0.75rem; margin: 0;">暂无活动推荐</p>
	<#}#>
</script>

<!-- 活动详情TPL -->
<script type="text/html" id="active-detail-tpl">
<header class="bar bar-nav">
		<a class="icon icon-left pull-left"  onclick="closePopup('.popup-active-detail');"></a>
		<a href="#" class="icon pull-right icon-share2"></a>
		<h1 class="title"><#=detail.title || "活动详情"#></h1>
</header>
<#if(detail){#>
<div class="content content-block" style="padding: 0;margin-top: 0;">
	<div style="padding: 0.5rem 0.75rem;">
	<h3 class="color-fff" style="margin-top: 0;margin-bottom: 0.2rem;"><#=detail.title#></h3>
	<div style="margin-bottom: 0.5rem;" class="color-ccc font-70">活动截止时间:<#=detail.end_time.substring(0,16)#></div>
	<div style="margin-bottom: 0.5rem;" class="color-ccc font-70">共<#=detail.num#>个名额,已有<#=detail.activeNums||0#>人参加了活动</div>
	<div class="font-75 color-999"><#=detail.summary || ""#></div>
	<div class="font-75 color-fff" style="margin-top: 0.3rem;"><#=detail.content?detail.content:"无内容详情"#></div>
 	
	<#if(words && words.length>0){#>
	<div class="content-block-title">参加了活动的小伙伴们都这么说:</div>
  	 	<div class="list-block media-list">
      	 	<ul>
				<#for(var i=0;i<words.length;i++){
					var word = words[i];
					var text = word.content;
				text = text.replace(/&amp;/g,"&");
			    text = text.replace(/&lt;/g,"<");
			    text = text.replace(/&gt;/g,">");
			    text = text.replace(/&nbsp;/g," ");
			    text = text.replace(/&#39;/g,"\'");
			    text = text.replace(/&quot;/g,"\"");
				#>
         		<li>
					<div class="item-content">
	         	       <a href="#" style="width:100%" onclick="alert('<#=text#>')"  class="item-link item-content">
	         		<div class="item-media"><img src="<#=word.headurl || "app/images/head/default.png"#>" style="width: 2.2rem;"></div>
	         		<div class="item-inner">
	         	           <div class="item-title-row">
	         	             <div class="item-title"><#=word.mem_name || "匿名会员"#></div>
	         	             <div class="item-after">打分:<#=word.cent#></div>
	         	           </div>
	         	           <div class="item-subtitle"><#=word.content#></div>
	         	         </div>
	         	       </a>
	         		</div>
       	 		  </li>
				<#}#>
      		</ul>
     	</div>
	<#}else{#>
		
	<#}#>


	<div style="margin-bottom: 0.5rem;" class="color-999 font-70"></div>
	<#if(list && list.length >0){#>
	活动项目
		<div class="list-block media-list">
		<ul>
	<#for(var i=0;i<list.length;i++){
		var item = list[i];
	#>
  <li >
    <label class="label-checkbox item-content" >
      <input type="checkbox" item-id="<#=item.id#>" name="my-checkbox" onchange="addToCart(this,'<#=item.act_price/100#>','<#=item.id#>')">
      <div class="item-media"><i class="icon icon-form-checkbox"></i></div>
      <div class="item-inner">
        <div class="item-title-row">
          <div class="item-title"><#=item.prj_name#></div>
          <div class="item-after color-ccc">活动价:<font color='red'>￥<#=item.act_price/100#></font></div>
        </div>
        <div class="item-subtitle">原价<#=item.fee#>元</div>
        <div class=""><#=item.remark || ""#></div>
      </div>
    </label>
  </li>

	<#}#>
</ul>
</div>
	<#}#>
		<%--<div class="row no-gutter">
			<div class="col-50 left-btn">总计￥<span id="total_fee">0</span></div>
			<div class="col-50 right-btn" onclick="buy_active_card()">立即购买</div>
		</div>
		--%>
<#if(mem!=undefined){
		mem = mem[0];
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
<div class="list-block" style="margin-top: 0;margin-bottom:0">
			<ul>
				<li>
					<div class="item-content">
						<div class="item-inner">
							<div class="item-title label font-70 color-999" style="width: 15%;">姓名</div>
							<div class="item-input">
								<input type="text" class="font-75 color-fff" id="active_mem_name" name="active_mem_name" placeholder="姓名" value="<#=mem.mem_name || ''#>" <#=isUpdateState#>>
							</div>
						</div>
					</div>
				</li>
				<li>
					<div class="item-content">
						<div class="item-inner">
							<div class="item-title label font-70 color-999" style="width: 15%;">性别</div>
							<div class="item-input">
								<select class="font-75 color-fff" id="active_mem_sex" name="active_mem_sex" disabled="<#=isSexUpdateState#>">
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
							<div class="item-title label font-70 color-999" style="width: 15%;">生日</div>
							<div class="item-input">
								<input type="date" id="active_birthday" name="active_birthday" class="font-75 color-fff"
									 value="<#=mem.birthday || ''#>" <#=isUpdateState#>>
							</div>
						</div>
					</div>
				</li>
				<li>
					<div class="item-content">
						<div class="item-inner">
							<div class="item-title label font-70 color-999" style="width: 20%;">身份证号</div>
							<div class="item-input">
								<input type="text" class="font-75 color-fff" id="active_id_card" name="active_id_card" placeholder="身份证号" value="<#=mem.idCard || ''#>" <#=isUpdateState#>>
							</div>
						</div>
					</div>
				</li>
			</ul>
		</div>

	<#}#>
	<#if(detail.for_mem == "N"){#>
 	<div class="buttons-row" style="margin-bottom: 1rem;margin-top: 0.5rem;">
		<div href="#" class="left-btn" style="color: #fff !important;text-align:center;width:50%;height:2rem;background:#2c2e47 !important;font-size: 1rem;line-height: 2.0rem;"><font color="#fff">总计￥<span id="active_total_fee">0</span></font></div>
		<div href="#" class="right-btn active" style="color: #333 !important;text-align:center;width:50%;height:2rem;background-color: #fcf428 !important;font-size: 1rem;line-height: 2.0rem;" onclick="buy_active_card()">立即购买</div>
	</div>
	<#}else{#>
		<a href="#" class="button button-fill button-success" style="height:2rem;font-size: 1rem;line-height: 2.0rem;margin-top: 0.5rem;" onclick="joinActive('<#=detail.id#>')">我要参加</a>
	<#}#>
	</div>
</div>

<#}else{#>
<h3 class="color-fff" style="margin-bottom: 0.2rem;">活动已经消失不见了T.T</h3>
<#}#>
</div>
</script>