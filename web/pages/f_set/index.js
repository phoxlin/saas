//短信设置
function savaAddDialog(win, doc, entity, name) {
	// $.messager.progress();
	$('#f_set').form('submit', {
		url : "f_set_messgae",
		onSubmit : function(data) {
			var isValid = $(this).form('validate');
			if (!isValid) {
				$.messager.progress('close');
			}
			return isValid;
		},
		success : function(data) {
			$.messager.progress('close');
			var result = "当前系统繁忙";
			try {
				data = eval('(' + data + ')');
				result = data.rs;
			} catch (e) {
				try {
					data = eval(data);
					result = data.rs;
				} catch (e1) {
				}
			}
			if ("Y" == result) {
				callback_info("保存成功", function() {
					win.close();
				});
			} else {
				error(result);
			}
		}
	});
}
//私教课程设置
function setPrivate(win, doc) {
	// $.messager.progress();
	$('#f_set_private').form('submit', {
		url : "f_set_private",
		onSubmit : function(data) {
			var isValid = $(this).form('validate');
			if (!isValid) {
				$.messager.progress('close');
			}
			return isValid;
		},
		success : function(data) {
			$.messager.progress('close');
			var result = "当前系统繁忙";
			try {
				data = eval('(' + data + ')');
				result = data.rs;
			} catch (e) {
				try {
					data = eval(data);
					result = data.rs;
				} catch (e1) {
				}
			}
			if ("Y" == result) {
				callback_info("保存成功", function() {
					win.close();
				});
			} else {
				error(result);
			}
		}
	});
}
//保存合同
function savaContract(win, doc,name) {
	// $.messager.progress();
	$('#f_set_add_contract').form('submit', {
		url : "f_set_contract",
		onSubmit : function(data) {
			var isValid = $(this).form('validate');
			if (!isValid) {
				$.messager.progress('close');
			}
			return isValid;
		},
		success : function(data) {
			$.messager.progress('close');
			var result = "当前系统繁忙";
			try {
				data = eval('(' + data + ')');
				result = data.rs;
			} catch (e) {
				try {
					data = eval(data);
					result = data.rs;
				} catch (e1) {
				}
			}
			if ("Y" == result) {
				callback_info("保存成功", function() {
					win.close();
				});
			} else {
				error(result);
			}
		}
	});
}
//打印设置
function setPrint(win, doc,name,type) {
	// $.messager.progress();
	$('#f_set_print'+type).form('submit', {
		url : "fit-action-gym-f_set_print?type="+type,
		onSubmit : function(data) {
			var isValid = $(this).form('validate');
			if (!isValid) {
				$.messager.progress('close');
			}
			return isValid;
		},
		success : function(data) {
			$.messager.progress('close');
			var result = "当前系统繁忙";
			try {
				data = eval('(' + data + ')');
				result = data.rs;
			} catch (e) {
				try {
					data = eval(data);
					result = data.rs;
				} catch (e1) {
				}
			}
			if ("Y" == result) {
				callback_info("保存成功", function() {
					win.close();
				});
			} else {
				error(result);
			}
		}
	});
}
//时间卡设置
function savaTimeCard(win, doc, entity, name) {
	// $.messager.progress();
	$('#f_set_time_card').form('submit', {
		url : "f_set_messgae",
		onSubmit : function(data) {
			var isValid = $(this).form('validate');
			if (!isValid) {
				$.messager.progress('close');
			}
			return isValid;
		},
		success : function(data) {
			$.messager.progress('close');
			var result = "当前系统繁忙";
			try {
				data = eval('(' + data + ')');
				result = data.rs;
			} catch (e) {
				try {
					data = eval(data);
					result = data.rs;
				} catch (e1) {
				}
			}
			if ("Y" == result) {
				callback_info("保存成功", function() {
					win.close();
				});
			} else {
				error(result);
			}
		}
	});
}

$(function() {
	// 获取短信设置详情
	//getMsg();
	getPrivate();
	
});

//获取短信设置详情
function getMsg(){
	$.ajax({
		url:"getMsg",
		type:"post",
		dataType:"json",
		success: function(data){
			if(data.rs=="Y"){
				
				
			}else{
				error(data.rs);
			}
		},
		error:function(){
			error("服务器异常,请稍后再试")
		}
	});
}
//获取私教设置详情
function getPrivate(){
	$.ajax({
		url:"getPrivateSet",
		type:"post",
		dataType:"json",
		success: function(data){
			if(data.rs=="Y"){
				var startTime = data.startTime;
				var endTime = data.endTime;
				var delay = data.delay;
				if(!(startTime == "") && !(startTime=="undefined")){
					$("#start-time").val(startTime);
				}else if(!(endTime == "") && !(endTime=="undefined")){
					$("#end-time").val(endTime);
				}else if(!(delay == "") && !(delay=="undefined")){
					$("#delay").val(delay);
				}
				var checkType = data.checkType;
				var coachType = data.coachType;
				var needFingerPrint = data.needFingerPrint;
				if("3"==checkType){
					$("#index0").attr("checked","checked");
					$("#index1").attr("checked",true);
				}
				if("1"==coachType){
					$("#coachOne").attr("checked","checked");
					$("#coachMany").attr("checked",true);
				}
				if(needFingerPrint == "Y"){
					$("#needFingerPrint1").attr("checked","checked");
					$("#needFingerPrint1").attr("checked",true);
				}else{
					$("#needFingerPrint2").attr("checked","checked");
					$("#needFingerPrint2").attr("checked",true);
				}
				
			}else{
				error(data.rs);
			}
		},
		error:function(){
			error("服务器异常,请稍后再试")
		}
	});
}
