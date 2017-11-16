
//打开会员推荐页面
function showRecommend(cur){
	if(logined!='Y'){
		openPopup(".wxloginPopup");
		return;
	}
	showMemRecommend(cur);
}
//获取会员推荐的潜在客户
function showMemRecommend(cur){
	$.showIndicator();
	$.ajax({
		type : "POST",
		url : "fit-ws-bg-mem-showMemRecommend",
		data : {
			cust_name : cust_name,
			gym : gym,
			id : id,
			cur : cur
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				var mem_recommendTpl = document.getElementById("mem_recommendTpl").innerHTML;
				var html = template(mem_recommendTpl, {
					list : data.list,
					total_cent : data.total_cent,
					cur : Number(cur),
					state : data.state

				});
				$("#recommendDiv2").html(html);
				openPopup(".popup-memRecommend");
			} else {
				$.toast(data.rs);
			}
			
		},
        error: function(xhr, type) {
            $.hideIndicator();
            $.toast("您的网速不给力啊，再来一次吧");
        }
	});
	
}
//添加潜在客户
function show_add_recommend(mc_name,pt_name,mc_id,pt_id){
	if(mc_name !=undefined && mc_name !=""){
		$("#choice_mc_name").val(mc_name);
	}
	if(pt_name !=undefined && pt_name !=""){
		$("#choice_pt_name").val(pt_name);
	}
	if(mc_id !=undefined && mc_id !=""){
		$("#choice_mc_id").val(mc_id);
	}
	if(pt_id !=undefined && pt_id !=""){
		$("#choice_pt_id").val(pt_id);
	}
	//清空input的内容
	$("#add_recommend_div input").val("");
	openPopup(".popup-addMemRecommend");
}
//选择教练
function choice_mc(type,search){
	$.showIndicator();
	$.ajax({
        type: 'POST',
        url: 'fit-app-action-choice_emp',
        dataType: 'json',
        data: {
            search: search,
            gym : gym,
            type: type,
            cust_name:cust_name
        },
        success: function(data) {
            $.hideIndicator();
            if (data.rs == "Y") {
                var ptListTpl = document.getElementById("emp-public-ListTpl").innerHTML;
                content = template(ptListTpl, {
                    data: data.list,
                });
                $("#emp-public-ListDiv").html(content);
                $("#recommend_reach").val(type);
                openPopup(".popup-public-empList");
                $("#emp-public-ListDiv .select-user ").on("click",
                function() {
                    var mc_id = $(this).attr("data-id");
                    var mc_name = $(this).attr("data-name");
                    closePopup(".popup-public-empList");
                    if(type == "MC"){
                    	$("#choice_mc_name").val(mc_name);
                    	$("#choice_mc_id").val(mc_id);
                    }else if(type == "PT"){
                    	$("#choice_pt_name").val(mc_name);
                    	$("#choice_pt_id").val(mc_id);
                    }
                });
            } else {
                $.toast(data.rs);
            }
        },
        error: function(xhr, type) {
            $.hideIndicator();
            $.toast("您的网速不给力啊，再来一次吧");
        }
    })
}
//添加推荐会员
function add_recommend(){
	if(logined!='Y'){
		openPopup(".wxloginPopup");
		return;
	}
	var phoneRegex = /^1[3|4|5|7|8]\d{9}$/;
	var choice_pt_id = $("#choice_pt_id").val();
	var choice_pt_name = $("#choice_pt_name").val();
	var choice_mc_id = $("#choice_mc_id").val();
	var id_card = $("#id_card").val();
	var phone_recommend = $("#phone_recommend").val();
	var sex_recommend = $("#sex_recommend").val();
	var mem_name_recommend = $("#mem_name_recommend").val();
	var content_recommed = $("#content_recommed").val();
	if(phone_recommend == undefined || phone_recommend.length ==0){
		$.toast("手机号码不能为空");
		return false;
	}else if(!phoneRegex.test(phone_recommend)) {
		$.toast("请检查电话号码是否正确!");
		return false;
    }
	if(mem_name_recommend == undefined ||  mem_name_recommend.length <=0){
		$.toast("请输入姓名");
		return ;
	}
	$.showIndicator();
	$.ajax({
		type : "POST",
		url : "fit-ws-bg-mem-addMemRecommend",
		data : {
			cust_name : cust_name,
			gym : gym,
			id : id,
			choice_pt_id : choice_pt_id,
			choice_mc_id : choice_mc_id,
			id_card : id_card,
			phone_recommend : phone_recommend,
			mem_name_recommend : mem_name_recommend,
			content_recommed : content_recommed,
			sex_recommend:sex_recommend
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				$.toast("添加成功");
				closePopup(".popup-addMemRecommend");
				showMemRecommend('8');
			} else {
				$.toast(data.rs);
			}
			
		},
        error: function(xhr, type) {
            $.hideIndicator();
            $.toast("您的网速不给力啊，再来一次吧");
        }
	});
	
}
//解绑
function newMemCancelEmp(type){
	if(type == "mc"){
		$("#choice_mc_id").val("");
		$("#choice_mc_name").val("");
	}else{
		
		$("#choice_pt_id").val("");
		$("#choice_pt_name").val("");
	}
	
}
//显示推荐排行
function show_recommend_raking(cur,type){
	if(logined!='Y'){
		openPopup(".wxloginPopup");
		return;
	}
	var mem_id = id;
	$.showIndicator();
	$.ajax({
		type : "POST",
		url : "fit-ws-bg-mem-show_recommend_raking",
		data : {
			cust_name : cust_name,
			gym : gym,
			id : mem_id,
			cur : cur,
			wxOpenId : wxOpenId
		},
		dataType : "json",
		success : function(data) {
			$.hideIndicator();
			if (data.rs == "Y") {
				var recommendRakingTpl = document.getElementById("recommendRakingTpl").innerHTML;
				var html = template(recommendRakingTpl, {
					list : data.list,
					id : mem_id,
					raking : data.raking,
					state : data.state,
					cur : Number(cur),
					type : type

				});
			$("#recommendRakingDiv").html(html);
			openPopup(".popup-recommendRaking");
				
			} else {
				$.toast(data.rs);
			}
			
		},
        error: function(xhr, type) {
            $.hideIndicator();
            $.toast("您的网速不给力啊，再来一次吧");
        }
	});
	
}