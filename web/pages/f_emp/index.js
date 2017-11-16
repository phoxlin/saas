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
	dialog({
		url : nextpage + "?type=add&instance_id=" + instance_id,
		title : '添加' + my_title,
		width : myWidth,
		height : myHeight,
		cancelVal : "关闭",
		cancel : function() {
			return true;
		},
		okVal : "保存",
		ok : function() {
			var iframe = $(window.parent.document).contents().find("[name="+dialog.getCurrent().id+"]")[0].contentWindow;
			iframe.savaAddDialog(this, document, my_entity, name);
			return false;
		},
	}).show();
}

function savaAddDialog(win, doc, entity, name) {
	//$.messager.progress();
	$('#' + form_id).form('submit', {
		url : "emp-save?m=add" + "&e=" + entity + "&lockId=" + lockId,
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
					doc.getElementById(name + '_refresh_toolbar').click();
				});
			} else {
				error(result);
			}
		}
	});
}



