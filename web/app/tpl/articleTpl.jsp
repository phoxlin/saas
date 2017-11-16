<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!-- 样式1    文章初始化 -->
<script type="text/html" id="special_articles">
<#if(list){
var flag = true;
for(var i=0;i<list.length;i++){
	var art = list[i];
	if("s1"== art.style){
		flag = false;
	}
}
if(!flag){
#>
<p class="font-80 color-fff" style="padding: 0.3rem 0.75rem; margin: 0;">健身专题</p>
<div class="club-special-content font-60 color-fff" >
<#for(var i=0;i<list.length;i++){
		var art = list[i];
		if("s1"!= art.style){
			continue;
		}#>
	<#	for(var j=0;j<art.arts.length;j++){
			var item = art.arts[j];
#>	
	<div class="top-active" onclick="article_detail('<#=item.id#>')">
		<img src="<#=item.pic_url || "app/images/temp/club2.jpg"#>" /> 
	<span> <span class="font-80"><#=item.title#></span> <span><#=item.summary#></span>
		</span>
	</div>
<#}#>
</div>
<#}}#>
<#} #>
</script>

<!-- 样式2  文章初始化 -->
<script type="text/html" id="special_articles_s2">

<#if(list){
	for(var i=0;i<list.length;i++){
		var art = list[i];
		if("s2"!= art.style){
			continue;
		}#>

		<p class="font-80 color-fff" style="padding: 0.6rem 0.75rem 0.3rem; margin: 0;"><#=art.type_name#></p>

		<#for(var j=0;j<art.arts.length;j++){
			var item = art.arts[j];
#>	
	<div class="club-hot" onclick="article_detail('<#=item.id#>')">
		<img src="<#=item.pic_url?(item.pic_url+'?imageView2/1/w/500/h/276'):"app/images/temp/club_hot.jpg"#>" style="width: 100%; height: 7.5rem;" />
		<p class="font-80 color-fff" style="padding: 0 0.5rem; margin: 0.3rem 0 0.1rem;"><#=item.title#></p>
		<p class="font-70 color-ccc line-one" style="padding: 0 0.5rem; margin: 0;"><#=item.summary#></p>
		<p class="font-60 color-999" style="padding: 0 0.5rem 0.5rem;">
			<#=item.release_time#>&nbsp;&nbsp; <i class="icon icon-heart"></i>&nbsp;<#=item.num#>
		</p>
	</div>
<#}#>
<#if(art.arts.length==3){#>
			<div class="item-inner" id="<#=art.type_id#>" onclick="loadMoreArticle('<#=art.type_id#>','<#=art.style#>')">
					<div class="item-text font-70 color-ccc" style="height: 1.1rem;text-align: center;">
							加载更多&nbsp;&nbsp;+
					</div>
				</div>
<#}#>
<#}#>
<#}#>

</script>

<!-- 样式3  文章初始化 -->    
<script type="text/html" id="articleListTpl">
<#if(list){
	for(var i=0;i<list.length;i++){
		var art = list[i];
		if("s3"!= art.style){
			continue;
		}
		var style="margin: 0.5rem 0 0;";
#>
	<p class="font-80 color-fff content-bg" style="padding: 0.3rem 0.75rem;margin: 0;margin-top: 0.5rem;">
		<#=art.type_name#>
	</p>
	<#if(art.arts){#>
	<div class="list-block media-list border-list" style="margin-top: 0;margin-bottom: 0;">
	<ul>
		<#for(var j=0;j<art.arts.length;j++){
			var item = art.arts[j];
		#>
		<li onclick="article_detail('<#=item.id#>')" class="item-content">
				<div class="item-media">
					<img src="<#=item.pic_url?(item.pic_url+'?imageView2/1/w/500/h/276'):'app/images/temp/1.jpg'#>" style='width: 5rem;'>
				</div>
				<div class="item-inner">
					<div class="item-title-row" style="height: 2rem;">
						<div class="item-title font-85 color-fff">
							<#=item.title#>
						</div>
					</div>
					<div class="item-subtitle font-70 color-ccc">
							<#=item.summary ||""#>
					</div>
					<div class="item-subtitle font-70 color-999">
						<#=item.release_time#>&nbsp;&nbsp;<i class="icon icon-heart"></i>&nbsp;<#=item.num#>
					</div>
				</div>
		</li>
		<#}#>
		<li id="<#=art.type_id#>" <#if(art.arts.length ==3){#>  onclick="loadMoreArticle('<#=art.type_id#>','s3')" <#}#> class="item-content">
				<div class="item-inner">
					<div class="item-text font-70 color-999" style="height: 1.1rem;text-align: center;">
						<#if(art.arts.length < 3 && art.arts.length !=0){#>
							已经没有了
						<#}else{#>
							加载更多&nbsp;&nbsp;+
						<#}#>	
					</div>
				</div>
		</li>
	</ul>	
	<#}#>
	</div>
<#}}#>
</script> 

<!-- 样式3  所有文章列表 -->    
<script type="text/html" id="articleListStyle3Tpl">
<# 
  if(list && list.length>0){
	for(var i=0;i<list.length;i++){
		var art = list[i];
		var style="margin: 0.5rem 0 0;";
#>
	<p class="font-80 color-fff content-bg" style="padding: 0.3rem 0.75rem;margin: 0;margin-top: 0.5rem;">
		<#=art.type_name#>
	</p>
	<#if(art.arts){#>
	<div class="list-block media-list border-list" style="margin-top: 0;margin-bottom: 0;">
	<ul>
		<#for(var j=0;j<art.arts.length;j++){
			var item = art.arts[j];
		#>
		<li onclick="article_detail('<#=item.id#>')" class="item-content">
				<div class="item-media">
					<img src="<#=item.pic_url?item.pic_url:'app/images/temp/1.jpg'#>" style='width: 5rem;'>
				</div>
				<div class="item-inner">
					<div class="item-title-row" style="height: 2rem;">
						<div class="item-title font-85 color-fff">
							<#=item.title#>
						</div>
					</div>
					<div class="item-subtitle font-70 color-ccc">
							<#=item.summary || ""#>
					</div>
					<div class="item-subtitle font-70 color-999">
						<#=item.release_time#>&nbsp;&nbsp;<i class="icon icon-heart"></i>&nbsp;<#=item.num || 0#>
					</div>
				</div>
		</li>
		<#}#>
		<li id="<#=art.type_id#>_s3" <#if(art.arts.length ==3){#>  onclick="loadMoreArticleStyle3('<#=art.type_id#>','s3')" <#}#> class="item-content">
				<div class="item-inner">
					<div class="item-text font-70 color-999" style="height: 1.1rem;text-align: center;">
						<#if(art.arts.length < 3 && art.arts.length !=0){#>
							已经没有了
						<#}else{#>
							加载更多&nbsp;&nbsp;+
						<#}#>	
					</div>
				</div>
		</li>
	</ul>	
	<#}#>
	</div>
<#}}else{#>
<div class="none-info font-90">暂无动态</div>
<#}#>
</script> 

<!-- 更多文章加载 样式2-->   
<script type="text/html" id="moreArticleListTpl-2">
<#if(list){
	for(var i=0;i<list.length;i++){
	var item = list[i];
#>
	<div class="club-hot" onclick="article_detail('<#=item.id#>')">
		<img src="<#=item.pic_url || "app/images/temp/club_hot.jpg"#>" style="width: 100%; height: 7.5rem;" />
		<p class="font-80 color-fff" style="padding: 0 0.5rem; margin: 0.3rem 0 0.1rem;"><#=item.title#></p>
		<p class="font-70 color-ccc" style="padding: 0 0.5rem; margin: 0;"><#=item.summary#></p>
		<p class="font-60 color-999" style="padding: 0 0.5rem 0.5rem;">
			<#=item.release_time#>&nbsp;&nbsp; <i class="icon icon-heart"></i>&nbsp;<#=item.num#>
		</p>
	</div>
<#}}#>
</script>
<!-- 更多文章加载 样式3-->   
<script type="text/html" id="moreArticleListTpl-3">
<#if(list){
	for(var i=0;i<list.length;i++){
	var item = list[i];
#>
	<li onclick="article_detail('<#=item.id#>')" class="item-content">
				<div class="item-media">
					<img src="<#=item.pic_url?item.pic_url:'app/images/temp/1.jpg'#>" style='width: 5rem;'>
				</div>
				<div class="item-inner">
					<div class="item-title-row" style="height: 2rem;">
						<div class="item-title font-85 color-fff">
							<#=item.title#>
						</div>
					</div>
					<div class="item-subtitle font-70 color-ccc">
							<#=item.summary#>
					</div>
					<div class="item-subtitle font-70 color-999">
						<#=item.release_time#>&nbsp;&nbsp;<i class="icon icon-heart"></i>&nbsp;85
					</div>
				</div>
	</li>
<#}}#>
</script>
<!-- 文章详情 -->
<script type="text/html" id="articleDetailTpl">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-article');"></a>
		<h1 class="title"><#=art.title || "详情"#></h1>
	</header>
	<div class="content content-block content-bg article-content" style="padding: 0;">
		<div style="padding: 0.5rem 0.75rem;">
		<#if(art){#>
			<h3 class="color-fff" style="margin-bottom: 0.2rem;"><#=art.title#></h3>
			<#
				var release_time = art.release_time;
				if(release_time && release_time.length > 0){
					var tmp = release_time.split(" ");
					if(tmp != null && tmp.length > 0){
						release_time = tmp[0];
					}
				}
			#>
			<div style="margin-bottom: 0.5rem;" class="color-ccc font-70"><#=release_time#></div>
			<div style="margin-bottom: 0.5rem;" class="color-999 font-70">作者:<#=art.author || '佚名'#></div>
			<div class="font-75 color-ccc"><#=art.summary||"暂无简介"#></div>
			<div class="font-75 color-fff" style="margin-top: 0.3rem;"><#=art.content?art.content:"内容不存在"#></div>
		<#}else{#>
			<p><h3>sorry,文章已经不存在了</h3></p>
		<#}#>
		</div>
	</div>
</script>

<!-- 文章列表TPL -->
<script type="text/html" id="article-listTpl">
<#if(list){#>
	<#for(var i=0;i<list.length;i++){
		var article = list[i];
	#>
	<li>
	<div class="item-content">
        <a href="#" style="width:100%" onclick="article_detail('<#=article.id#>')"  class="item-link item-content">
		<div class="item-media"><img src="http://gqianniu.alicdn.com/bao/uploaded/i4//tfscom/i3/TB10LfcHFXXXXXKXpXXXXXXXXXX_!!0-item_pic.jpg_250x250q60.jpg" style="width: 2.2rem;"></div>
		<div class="item-inner">
            <div class="item-title-row">
              <div class="item-title"><#=article.title#></div>
              <div class="item-after"><#=article.release_time.substring(0,16)#></div>
            </div>
            <div class="item-subtitle"><#=article.summary||"暂无简介,请看图文介绍"#></div>
          </div>
        </a>
	</div>
      </li>
	<#}#>
<#}else{#>
	暂无文章
<#}#>	
</script>

<!-- 文章列表popup -->
<div class="popup popup-article-list" id="popup-article-list">
<header class="bar bar-nav">
		<a class="icon icon-left pull-left"  onclick="closePopup('.popup-article-list');"></a>
		<h1 class="title">俱乐部动态</h1>
</header>
<div class="content" id="article-list">

</div>
</div>

<!-- 文章详情popup -->
<div class="popup popup-article" id="article_popup">

</div>
