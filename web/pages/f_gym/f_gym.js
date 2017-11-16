//添加门店，需要先选中会所
function addGym(name) {
	var instance_id = $("#instance_id").val();
	var my_title = "";
	try {
		my_title = eval(name + '_dialog_title');
	} catch (e) {
	}
	var nextpage = "edit.jsp";
	try {
		nextpage = eval(name + '_nextpage');
	} catch (e) {
	}
	var myWidth = 800;
	try {
		myWidth = eval(name + '_dialog_width');
	} catch (e) {
	}
	var myHeight = 600;
	try {
		myHeight = eval(name + '_dialog_height');
	} catch (e) {
	}
	var my_entity = "";
	try {
		my_entity = eval(name + '_entity');
	} catch (e) {
	}
	
	var count = getSelectedCount(name);
	if (count == 1) {
		var cust_name = getValuesByName("cust_name", name);
		dialog({
			url : nextpage + "?type=add&addType=gym&instance_id=" + instance_id,
			title : '添加' + my_title,
			width : myWidth,
			height : myHeight,
			cancelVal : "取消",
			cancel : function() {
				return true;
			},
			okVal : "确定",
			ok : function() {
				var iframe = $(window.parent.document).contents().find("[name=" + $(this)[0].id + "]")[0].contentWindow;
				iframe.add_gym(this, document, my_entity, name,cust_name);
				return false;
			},
		}).show();
	} else {
		error("请先选择会所");
	}
}
//在显示所有门店页面上添加门店，不需要提前选择会所
function addGym2(name) {
	var instance_id = $("#instance_id").val();
	var my_title = "";
	try {
		my_title = eval(name + '_dialog_title');
	} catch (e) {
	}
	var nextpage = "edit.jsp";
	try {
		nextpage = eval(name + '_nextpage');
	} catch (e) {
	}
	var myWidth = 800;
	try {
		myWidth = eval(name + '_dialog_width');
	} catch (e) {
	}
	var myHeight = 600;
	try {
		myHeight = eval(name + '_dialog_height');
	} catch (e) {
	}
	var my_entity = "";
	try {
		my_entity = eval(name + '_entity');
	} catch (e) {
	}
		var cust_name = $("#my_cust_name").val();
		if(cust_name == undefined || cust_name.length<=0){
			alert("未拿到cust_name");
			return;
		}
		dialog({
			url : nextpage + "?type=add&addType=gym&instance_id=" + instance_id,
			title : '添加' + my_title,
			width : myWidth,
			height : myHeight,
			cancelVal : "取消",
			cancel : function() {
				return true;
			},
			okVal : "确定",
			ok : function() {
				var iframe = $(window.parent.document).contents().find("[name=" + $(this)[0].id + "]")[0].contentWindow;
				iframe.add_gym(this, document, my_entity, name,cust_name);
				return false;
			},
		}).show();
}
//添加客户
function savaAddDialog(win, doc, entity, name){
	top.$.messager.progress();
	$('#' + form_id).form('submit', {
		url : "f_gym_add_cust?m=add" + "&e=" + entity + "&lockId=" + lockId,
		onSubmit : function(data) {
			var isValid = $(this).form('validate');
			if (!isValid) {
				top.$.messager.progress('close');
			}
			return isValid;
		},
		success : function(data) {
			top.$.messager.progress('close');
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
					if(doc.getElementById(name + '_refresh_toolbar')){
						doc.getElementById(name + '_refresh_toolbar').click();
					}
				});
			} else {
				error(result);
			}
		}
	});
}
//添加门店
function add_gym(win, doc, entity, name,cust_name){
	top.$.messager.progress();
	$('#' + form_id).form('submit', {
		url : "f_gym_add_gym?m=add" + "&e=" + entity + "&lockId=" + lockId +"&cust_name="+cust_name,
		onSubmit : function(data) {
			var isValid = $(this).form('validate');
			if (!isValid) {
				top.$.messager.progress('close');
			}
			return isValid;
		},
		success : function(data) {
			top.$.messager.progress('close');
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
					if(doc.getElementById(name + '_refresh_toolbar')){
						doc.getElementById(name + '_refresh_toolbar').click();
					}
				});
			} else {
				error(result);
			}
		}
	});
}

function edit(name) {
	var instance_id = $("#instance_id").val();
	var my_title = "";
	var my_title = "";
	try {
		my_title = eval(name + '_dialog_title');
	} catch (e) {
	}
	var nextpage = "edit.jsp";
	try {
		nextpage = eval(name + '_nextpage');
	} catch (e) {
	}
	var myWidth = 800;
	try {
		myWidth = eval(name + '_dialog_width');
	} catch (e) {
	}
	var myHeight = 600;
	try {
		myHeight = eval(name + '_dialog_height');
	} catch (e) {
	}
	var my_entity = "";
	try {
		my_entity = eval(name + '_entity');
	} catch (e) {
	}
	var count = getSelectedCount(name);
	if (count == 1) {
		var id = getValuesByName("id", name);
		var cust_name = getValuesByName("cust_name", name);
		var gym = getValuesByName("gym", name);
		var addType = cust_name == gym ?"cust_name":"gym";
		var dialogId=new Date().getTime();
		dialog({url:"task-cq-detail?entity=" + my_entity + "&id=" + id
				+ "&nextpage=" + nextpage + "&type=edit&instance_id="
				+ instance_id+"&addType="+addType,
			title : '修改' + my_title,
			width : myWidth,
			height : myHeight,
			okValue : "修改",
			id:dialogId,
			ok : function() {
				var iframe = $(window.parent.document).contents().find("[name="+dialogId+"]")[0].contentWindow;
				iframe.savaEditDialog(this, document, my_entity, name);
				return false;
			},
			cancelValue : "关闭",
			cancel : function() {
				return true;
			}
		}).showModal();
	} else {
		error("请选择一行信息进行编辑");
	}

}

//修改
function savaEditDialog(win, doc, entity, name) {
	//$.messager.progress();
	$('#' + form_id).form('submit', {
		url : "f_gym_update?m=edit" + "&e=" + entity + "&lockId=" + lockId,
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
					if(doc.getElementById(name + '_refresh_toolbar')){
						doc.getElementById(name + '_refresh_toolbar').click();
					}
				});
			} else {
				error(result);
			}
		}
	});
}
//显示所有门店信息
function f_gym_show(name) {
	var instance_id = $("#instance_id").val();
	var my_title = "";
	var my_title = "";
	try {
		my_title = eval(name + '_dialog_title');
	} catch (e) {
	}
	var nextpage = "edit.jsp";
	try {
		nextpage = eval(name + '_nextpage');
	} catch (e) {
	}
	var myWidth = 800;
	try {
		myWidth = eval(name + '_dialog_width');
	} catch (e) {
	}
	var myHeight = 600;
	try {
		myHeight = eval(name + '_dialog_height');
	} catch (e) {
	}
	var my_entity = "";
	try {
		my_entity = eval(name + '_entity');
	} catch (e) {
	}
	var count = getSelectedCount(name);
	if (count == 1) {
		var id = getValuesByName("id", name);
		var cust_name = getValuesByName("cust_name", name);
		var gym = getValuesByName("gym", name);
		var addType = cust_name == gym ?"cust_name":"gym";
		var dialogId=new Date().getTime();
		window.open("pages/f_gym/index2.jsp?cust_name="+cust_name);
	} else {
		error("请先选择会所");
	}
}


