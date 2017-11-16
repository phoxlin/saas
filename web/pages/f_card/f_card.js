function savaAddDialog(win, doc, entity, name) {
	
	
	$.messager.progress();
	$('#' + form_id).form('submit', {
		url : "fit-ws-bg-add-card-online?m=add" + "&e=" + entity + "&lockId=" + lockId,
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


function savaEditDialog(win, doc, entity, name) {
	$.messager.progress();
	$('#' + form_id).form('submit', {
		url : "fit-ws-bg-add-card-online?m=edit" + "&e=" + entity + "&lockId=" + lockId,
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