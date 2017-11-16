function add(name) {
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
	top.dialog({
		url : nextpage + "?type=add&table_name=" + table_name,
		title : '添加' + my_title,
		width : myWidth,
		height : 300,
		cancelValue : "关闭",
		cancel : function() {
			return true;
		},
		okValue : "保存",
		ok : function() {
			var iframe = $(window.parent.document).contents().find("[name=" + $(this)[0].id + "]")[0].contentWindow;
			//var iframe = $(window.parent.document).contents().find("div[i=dialog]:last iframe")[0].contentWindow;
			//var form = $(iframe).find('#f_generic_typeFormObj').serializeObject();
			
			iframe.savaAddDialog(this, document, my_entity, name);
			return false;
		},
	}).showModal();

}

function savaAddDialog(win, doc, entity, name) {
	$.messager.progress();
	
	$("#f_generic_typeFormObj").form('submit', {
		url : "task-cq-save?m=add" + "&e=" + entity + "&lockId=" + new Date().getTime(),
		onSubmit : function(data) {
			var isValid = $(this).form('validate');
			if (!isValid) {
				$.messager.progress('close');
			}
			var style = $("input[name=f_generic_type__other]:Checked").length;
			if(style == 0){
				$.messager.progress('close');
				error("请选择一种文章展示的样式");
				isValid = false;
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
					doc.getElementById(name + '_refresh_toolbar').click();
				});
			} else {
				error(result);
			}
		}
	});
}


$.fn.serializeObject = function() {  
    var o = {};  
    var a = this.serializeArray();  
    $.each(a, function() {  
        if (o[this.name]) {  
            if (!o[this.name].push) {  
                o[this.name] = [ o[this.name] ];  
            }  
            o[this.name].push(this.value || '');  
        } else {  
            o[this.name] = this.value || '';  
        }  
    });  
    return o;  
}  

function detail(name) {
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
		dialog({
			url:"task-cq-detail?entity=" + my_entity + "&id=" + id
				+ "&nextpage=" + nextpage + "&type=detail", 
			title : '查看' + my_title,
			width : myWidth,
			height : 300,
			cancelValue : "关闭",
			cancel : function() {
				return true;
			}
		}).show();
	} else {
		error("请选择一行信息进行编辑");
	}
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
		top.dialog({url:"task-cq-detail?entity=" + my_entity + "&id=" + id
				+ "&nextpage=" + nextpage + "&type=edit&table_name=" + table_name,
			title : '修改' + my_title,
			width : myWidth,
			height : 300,
			okValue : "修改",
			ok : function() {
				var iframe = $(window.parent.document).contents().find("[name=" + $(this)[0].id + "]")[0].contentWindow;
				iframe.savaEditDialog(this, document, my_entity, name);
				return false;
			},
			cancelValue : "关闭",
			cancel : function() {
				return true;
			}
		}).show();
	} else {
		error("请选择一行信息进行编辑");
	}

}