

//消费记录 (购卡)
function consume_list(user_id, cur){
	$.ajax({
		type : "POST",
		url : "yp-ws-app-consume" ,
		data : {
			fk_user_id : user_id ,
		    cur : cur
		},
		dataType : "json",
		async : false,
		success : function(data){
			if( data.rs = "Y"){
					var consumeRecordTpl = document.getElementById('consumeRecordTpl').innerHTML;
	                var consumeRecordTplHtml = template(consumeRecordTpl, {
	                    list2 : data.consumelist,
	                    list : data
	                    
	                });
	                $('#pay_info').html(consumeRecordTplHtml);
			}else{
				alert(data.rs);
			}
		},
	})
}

//失效会员卡
function old_card_list(user_id, cur){
	$.ajax({
		type : "POST",
		url : "yp-ws-app-old_card" ,
		data : {
			fk_user_id : user_id ,
		    cur : cur
		},
		dataType : "json",
		async : false,
		success : function(data){
			if( data.rs = "Y"){
					var oldCardTpl = document.getElementById('oldCardTpl').innerHTML;
	                var oldCardTplHtml = template(oldCardTpl, {
	                    list2 : data.oldCard,
	                    list : data
	                });
	                $('#old_card_info').html(oldCardTplHtml);
			}else{
				alert(data.rs);
			}
		},
	})
}

//会员出入场记录
function checkin_list(user_id, cur){
	$.ajax({
		type : "POST",
		url : "fit-query-mem-checkin",
		data : {
			fk_user_id : user_id,
			cur : cur
		},
		dataType : "json",
		async : false,
		success : function(data) {
			if (data.rs == "Y") {
				var memCheckinTpl = document.getElementById('memCheckinTpl').innerHTML;
                var memCheckinTplHtml = template(memCheckinTpl, {
                    list : data
                });
                $('#inout_info').html(memCheckinTplHtml);
			} else {
				alert(data.rs);
			}
		}
	});
}
//请假信息
function leaveinfo_list(user_id, cur){
	$.ajax({
		type : "POST",
		url : "fit-query-mem-leaveinfo",
		data : {
			fk_user_id : user_id,
			cur : cur
		},
		dataType : "json",
		async : false,
		success : function(data) {
			if (data.rs == "Y") {
				var memLeavelTpl = document.getElementById('memLeavelTpl').innerHTML;
                var memLeavelTplHtml = template(memLeavelTpl, {
                    list : data
                });
                $('#leave_info').html(memLeavelTplHtml);
			} else {
				alert(data.rs);
			}
		}
	});
}
