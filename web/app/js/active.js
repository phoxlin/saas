//加载首页推荐活动
function loadCommendActive(){
	$.showIndicator();
	$.ajax({
		url:"fit-app-active-load-commend-active",
		type:"POST",
		dataType:"json",
		data:{
			cust_name:cust_name,
			gym:gym
		},
		success:function(data){
			$.hideIndicator();
			if(data.rs == "Y"){
				var index_commendTpl = document.getElementById("index_commendTpl").innerHTML;
				var html = template(index_commendTpl,{list:data.actives});
				$("#acitve_content").html(html);
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

//活动详情
function showActive(act_id){
	$.showIndicator();
	$.ajax({
		url:"fit-app-active-detail",
		type:"POST",
		dataType:"json",
		data:{active_id:act_id,cust_name:cust_name,id:id},
		success:function(data){
			$.hideIndicator();
			if(data.rs == "Y"){
				var tpl = document.getElementById("active-detail-tpl").innerHTML;
				var html = template(tpl,{detail:data.detail,list:data.items,words:data.words,mem:data.mem});
			 	html = html.replace(/&amp;/g,"&");
			    html = html.replace(/&lt;/g,"<");
			    html = html.replace(/&gt;/g,">");
			    html = html.replace(/&nbsp;/g," ");
			    html = html.replace(/&#39;/g,"\'");
			    html = html.replace(/&quot;/g,"\"");
				$("#popup-active-detail").html(html);
				openPopup(".popup-active-detail");
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
//添加活动项目购买
function addToCart(t,fee,id){
	var total = Number($("#active_total_fee").text());
	var flag = $(t).is(":checked");
	if(flag){
		total += Number(fee);
	}else{
		total -= Number(fee);
	}
	$("#active_total_fee").text(total);
}

//购买活动卡
function buy_active_card(){
	
	if (logined != 'Y') {
		openPopup(".wxloginPopup");
		return;
	}
	
	var edit_mem_name = $("#active_mem_name").val();
	var edit_id_card = $("#active_id_card").val();
	var birthday = $("#active_birthday").val();
	var sex = $("#active_mem_sex").val();
	if(sex == undefined || sex.length<=0){
		$.toast("请选择性别");
		return;
	}
	if(edit_mem_name == undefined || edit_mem_name.length<=0){
		$.toast("请填写姓名");
		return;
	}
	
	if(birthday == undefined || birthday.length<=0){
		$.toast("请填写生日");
		return;
	}
	if(edit_id_card == undefined || edit_id_card.length<=0){
		$.toast("请填写身份证号");
		return;
	}
	
	var r = $("#popup-active-detail input[type=checkbox]:checked");
	if(r.length == 0){
		$.toast("请选择一项活动产品");
		return;
	}
	var cards = "";
	for(var i=0;i<r.length;i++){
		var item = r[i];
		var item_id = $(item).attr("item-id");
		cards += item_id +",";
	}
	$.showIndicator();
	
	var active_total_fee = $("#active_total_fee").text();
	
	$.ajax({
		url:"fit-app-active-buy-cards",
		type:"POST",
		dataType:"json",
		data:{mem_id:id,cust_name:cust_name,gym:gym,cards:cards,edit_mem_name,edit_id_card,birthday,sex},
		success:function(data){
			$.hideIndicator();
			if(data.rs == "Y"){
				$.toast("购买成功");
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
//活动列表
function showActives(){
	$.showIndicator();
	$.ajax({
		url:"fit-app-active-list",
		type:"POST",
		dataType:"json",
		data:{cust_name:cust_name,gym:gym},
		success:function(data){
			$.hideIndicator();
			if(data.rs == "Y"){
				var tpl = document.getElementById("active-listTpl").innerHTML;
				var html = template(tpl,{list:data.actives});
				$("#acitve-list").html(html);
				openPopup(".popup-active-list");
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

//签到排行
function showSignInRank(){
	if (logined != 'Y') {
		openPopup(".wxloginPopup");
		return;
	}

	$.showIndicator();
	$.ajax({
		url:"fit-app-action-sign-rank",
		type:"POST",
		dataType:"json",
		data:{cust_name:cust_name,gym:gym,user_id:id},
		success:function(data){
			$.hideIndicator();
			if(data.rs == "Y"){
				var tpl = document.getElementById("sign-in-listTpl").innerHTML;
				var html = template(tpl,{list:data.list,m:{"id":id,"userGym":data.userGym,headUrl:data.headUrl}});
				$("#sign-in-list").html(html);
				openPopup(".popup-sign-in-rank");
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
//提交日记
function submit_sign_dairy(){
	var remark = $("#sign_remark").val();
	
	var flag = $("#andSendToQQ").is(":checked");
	if(remark == "" && flag){
		$.toast("亲,您什么都没有写不能发圈圈哒");
		return;
	}
	
	var sign_imgs = $("#sign_imgs").val() || "";
	//sign_in();
	$.showIndicator();
	
	var localIds = sign_imgs.split(",");
    var serverId = "";
    if(localIds == ""){
    	$.ajax({
    		url:"fit-app-action-sign-write-remark",
    		type:"POST",
    		dataType:"json",
    		data:{cust_name:cust_name,gym:gym,userGym:gym
    			,remark:remark
    			,user_id:id
    			,user_name:nickname
    			,sendToQQ:flag,
    			sign_imgs:serverId
    		},
    		success:function(data){
    			$.hideIndicator();
    			if(data.rs == "Y"){
    				$("#sign_imgs").val("");
    				var text = "";
    				if(flag){
    					text ="发表成功,可到圈圈查看";
    				}else{
    					text ="打卡日志已记录";
    				}
    				$.toast(text);
    				$("#sign_in_flag").text("今日已打");
    				$("#sign_in_count")
    						.text(Number($("#sign_in_count").text()) + 1);
    				has_sign = true;
    				closePopup('.popup-sign-in-write-remark');
    			}else{
    				$.toast(data.rs);
    			}
    		},
    		error : function(xhr, type) {
    			$.hideIndicator();
    			$.toast("您的网速不给力啊，再来一次吧");
    		}
    	});
    }else{
    	wx.ready(function() {
            var i = 0;
            var length = localIds.length;
            var upload = function() {
                wx.uploadImage({
                    localId: localIds[i],
                    success: function(res) {
                        serverId += res.serverId + ',';
                        // 如果还有照片，继续上传
                        i++;
                        if (i < length) {
                            upload();
                        } else {
                        	
                        	$.ajax({
                        		url:"fit-app-action-sign-write-remark",
                        		type:"POST",
                        		dataType:"json",
                        		data:{cust_name:cust_name,gym:gym,userGym:gym
                        			,remark:remark
                        			,user_id:id
                        			,user_name:nickname
                        			,sendToQQ:flag,
                        			sign_imgs:serverId
                        		},
                        		success:function(data){
                        			$.hideIndicator();
                        			if(data.rs == "Y"){
                        				$("#sign_imgs").val("");
                        				var text = "";
                        				if(flag){
                        					text ="发表成功,可到圈圈查看";
                        				}else{
                        					text ="打卡日志已记录";
                        				}
                        				$.toast(text);
                        				$("#sign_in_flag").text("今日已打");
                        				$("#sign_in_count")
                        						.text(Number($("#sign_in_count").text()) + 1);
                        				has_sign = true;
                        				closePopup('.popup-sign-in-write-remark');
                        			}else{
                        				$.hideIndicator();
                        				$.toast(data.rs);
                        			}
                        		},
                        		error : function(xhr, type) {
                        			$.hideIndicator();
                        			$.toast("您的网速不给力啊，再来一次吧");
                        		}
                        	});
                        }
                    }
                });
            };
            upload();
        });
    }
	
	
	
}
//打卡记录
function showMySignRecord(){
	if (logined != 'Y') {
		openPopup(".wxloginPopup");
		return;
	}
	$.showIndicator();
	$.ajax({
		url:"fit-app-action-sign-user-record",
		type:"POST",
		dataType:"json",
		data:{cust_name:cust_name,
			gym:gym,
			userGym:mem.userGym,
			user_id:mem.id,
			user_name:mem.mem_name
		},
		success:function(data){
			$.hideIndicator();
			if(data.rs == "Y"){
				var tpl = document.getElementById("sign_reocrd_listTpl").innerHTML;
				var html = template(tpl,{list:data.list});
				$("#sign_reocrd_list").html(html);
			}else{
				$.toast(data.rs);
			}
		},
		error : function(xhr, type) {
			$.hideIndicator();
			$.toast("您的网速不给力啊，再来一次吧");
		}
	});
	
	openPopup('.popup-sign-in-record')
}

//参加会员活动
function joinActive(act_id){
	var edit_mem_name = $("#active_mem_name").val();
	var edit_id_card = $("#active_id_card").val();
	var birthday = $("#active_birthday").val();
	var sex = $("#active_mem_sex").val();
	if(sex == undefined || sex.length<=0){
		$.toast("请选择性别");
		return;
	}
	if(edit_mem_name == undefined || edit_mem_name.length<=0){
		$.toast("请填写姓名");
		return;
	}
	
	if(birthday == undefined || birthday.length<=0){
		$.toast("请填写生日");
		return;
	}
	if(edit_id_card == undefined || edit_id_card.length<=0){
		$.toast("请填写身份证号");
		return;
	}
	
	$.showIndicator();
	$.ajax({
		url:"fit-app-active-joinActive",
		type:"POST",
		dataType:"json",
		data:{cust_name:cust_name,
			gym:gym,
			mem_id:id,
			act_id:act_id
			,edit_mem_name,edit_id_card,birthday,sex
		},
		success:function(data){
			$.hideIndicator();
			if(data.rs == "Y"){
				$.toast("报名成功");
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