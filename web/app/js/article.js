//显示文章列表
function showArticles(){
	$.showIndicator();
	//普通文章列表
	$.ajax({
		url:"fit-app-article-init2",
		type:"POST",
		dataType:"json",
		data:{
			cust_name:cust_name,
			gym:gym
		},
		success:function(data){
			$.hideIndicator();
			if(data.rs == "Y"){
				//样式1
				var special_tpl = document.getElementById("special_articles").innerHTML;
				var special_html = template(special_tpl,{list:data.list});
				$("#art-special").html(special_html);
				//$("#art-content-style-2").before(special_html);
				//样式2
				var special_tpl_2 = document.getElementById("special_articles_s2").innerHTML;
				var special_html_2 = template(special_tpl_2,{list:data.list});
				$("#art-content-style-2").html(special_html_2);
				//样式3
				var tpl = document.getElementById("articleListTpl").innerHTML;
				var html = template(tpl,{list:data.list});
				$("#art-content").html(html);
				if(!data.list || data.list.length ==0){
					$("#art-special").html('<div class="none-info font-90">还没有文章噢</div>');
				}
			}else{
				$.toast(data.rs);
			}
		},
		error : function(xhr, type) {
			$.hideIndicator();
			$.toast("您的网速不给力啊，再来一次吧");
		}
	});
}

//添加更多文章 
function loadMoreArticle(type,style){
	var total = 0;
	if("s2" == style){
		total = $("#"+type).parent().find("div").length -2;
	}else if("s3" == style){
		total = $("#"+type).parent().find("li").length -1;
	}
	$.showIndicator();
	$.ajax({
		url:"fit-app-article-more",
		type:"POST",
		dataType:"json",
		async:false,
		data:{cust_name:cust_name,gym:gym,type:type,start:total},
		success:function(data){
			$.hideIndicator();
			if(data.rs == "Y"){
				if(data.list){
					var tpl = ""
					if("s2" == style){
						tpl = document.getElementById("moreArticleListTpl-2").innerHTML;
					}else if("s3" == style){
						tpl = document.getElementById("moreArticleListTpl-3").innerHTML;
					}
					var html = template(tpl,{list:data.list});
					$("#"+type).before(html);
					if(data.list.length < 3){
						$("#"+type).removeAttr('onclick');
						$("#"+type).find(".item-text").text("已经没有了");
					}
				}else{
					$("#"+type).removeAttr('onclick');
					$("#"+type).find(".item-text").text("已经没有了");
				}
			}else{
				$.toast(data.rs);
			}
		},
		error : function(xhr, type) {
			$.hideIndicator();
			$.toast("您的网速不给力啊，再来一次吧");
		}
	});
}
//文章详情
function article_detail(id){
	$.showIndicator();
	$.ajax({
		url:"fit-app-article-detail",
		type:"POST",
		dataType:"json",
		data:{cust_name:cust_name,gym:gym,art_id:id},
		success:function(data){
			$.hideIndicator();
			if(data.rs == "Y"){
				if(data.art){
					var tpl = document.getElementById("articleDetailTpl").innerHTML;
					var html = template(tpl,{art:data.art});
					 	html = html.replace(/&amp;/g,"&");
					    html = html.replace(/&lt;/g,"<");
					    html = html.replace(/&gt;/g,">");
					    html = html.replace(/&nbsp;/g," ");
					    html = html.replace(/&#39;/g,"\'");
					    html = html.replace(/&quot;/g,"\"");
					/*html = html.replace(/&lt;/g,"<");
					html = html.replace(/&gt;/g,">");
					html = html.replace(/&quot;/g,"\"");
					html = html.replace(/&nbsp;/g," ");*/
					$(".popup-article").html(html);
					openPopup('.popup-article');
				}else{
					$.toast('文章已不存在');
				}
			}else{
				$.toast(data.rs);
			}
		},
		error : function(xhr, type) {
			$.hideIndicator();
			$.toast("您的网速不给力啊，再来一次吧");
		}
	});
	/*console.log(item);
	//var art = JSON.parse(item);
	var tpl = document.getElementById("articleDetailTpl").innerHTML;
	var html = template(tpl,{art:item});
	$(".popup-article").html(html);
	$.popup('.popup-article');*/
}

function closeArt(popup){
	$.closeModal('.popup-article');
}
//样式3的文章所有列表
function showArticlesList(){
	//文章列表
	$.showIndicator();
	$.ajax({
		url:"fit-app-article-init3",
		type:"POST",
		dataType:"json",
		data:{cust_name:cust_name,gym:gym},
		success:function(data){
			$.hideIndicator();
			if(data.rs == "Y"){
				if(data.list){
					//样式3
					var tpl = document.getElementById("articleListStyle3Tpl").innerHTML;
					var html = template(tpl,{list:data.list});
					$("#article-list").html(html);
					openPopup(".popup-article-list");
				}
			}else{
				$.toast(data.rs);
			}
		},
		error : function(xhr, type) {
			$.hideIndicator();
			$.toast("您的网速不给力啊，再来一次吧");
		}
	});
	
}
//

//主页    样式3的更多
function loadMoreArticlesList(t){
	var start = $(t).prev().find("li").length -1;
	$.showIndicator();
	$.ajax({
		url:"fit-app-article-list",
		type:"POST",
		dataType:"json",
		data:{cust_name:cust_name,
			gym:gym,
			start:start
		},
		success:function(data){
			$.hideIndicator();
			if(data.rs == "Y"){
				if(data.list && data.list.length>0){
					var tpl = document.getElementById("article-listTpl").innerHTML;
					var html = template(tpl,{list:data.list});
					$(t).prev().append(html);
					if(data.list.length < 3){
						$(t).removeAttr("onclick");
						$(t).find(".item-text").text("已经没有了");
					}
				}else{
					$(t).removeAttr("onclick");
					$(t).find(".item-text").text("已经没有了");
				}
			}else{
				$.toast(data.rs);
			}
		},
		error : function(xhr, type) {
			$.hideIndicator();
			$.toast("您的网速不给力啊，再来一次吧");
		}
	});
}
//所有文章列表    样式3文章更多
function  loadMoreArticleStyle3(type,style){
	var total = 0;
	if("s2" == style){
		total = $("#"+type+"_s3").parent().find("div").length -2;
	}else if("s3" == style){
		total = $("#"+type+"_s3").parent().find("li").length -1;
	}
	$.showIndicator();
	$.ajax({
		url:"fit-app-article-more",
		type:"POST",
		dataType:"json",
		async:false,
		data:{cust_name:cust_name,gym:gym,type:type,start:total},
		success:function(data){
			$.hideIndicator();
			if(data.rs == "Y"){
				if(data.list){
					var tpl = ""
					if("s2" == style){
						tpl = document.getElementById("moreArticleListTpl-2").innerHTML;
					}else if("s3" == style){
						tpl = document.getElementById("moreArticleListTpl-3").innerHTML;
					}
					var html = template(tpl,{list:data.list});
					$("#"+type+"_s3").before(html);
					if(data.list.length < 3){
						$("#"+type+"_s3").removeAttr('onclick');
						$("#"+type+"_s3").find(".item-text").text("已经没有了");
					}
				}else{
					$("#"+type+"_s3").removeAttr('onclick');
					$("#"+type+"_s3").find(".item-text").text("已经没有了");
				}
			}else{
				$.toast(data.rs);
			}
		},
		error : function(xhr, type) {
			$.hideIndicator();
			$.toast("您的网速不给力啊，再来一次吧");
		}
	});
}