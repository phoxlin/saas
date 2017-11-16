function savaAddDialog(win, doc, ms_name) {
	$.ajax({
		type : "POST",
		url : "fit-ws-bg-addMem",
		data : $("#f_memFormObj").serialize(),
		dataType : "json",
		beforeSend : function(xhr, settings) {
			var valid = $("#f_memFormObj").form('validate');
			flag = valid;
			return valid;
		},
		async : false,
		success : function(data) {
			if (data.rs == "Y") {
				callback_info("添加成功", function() {
					parent.location.reload();
				});
			} else {
				flag = false;
				error(data.rs);
			}

		}
	});
}
function saveUpdateDialog(win, doc, ms_name) {
	$.ajax({
		type : "POST",
		url : "fit-ws-bg-updateMem",
		data : $("#f_memFormObj").serialize(),
		dataType : "json",
		beforeSend : function(xhr, settings) {
			var valid = $("#f_memFormObj").form('validate');
			flag = valid;
			return valid;
		},
		async : false,
		success : function(data) {
			if (data.rs == "Y") {
				callback_info("修改成功", function() {
					parent.location.reload();
				});
			} else {
				error(data.rs);
			}

		}
	});
}
function showCard(type, obj, e) {
	e.preventDefault();
	e.stopPropagation();
	$(obj).off("click");
	var html = "";
	var title = "";
	if (type == "day") {
		html = "dayCard.jsp"
		title = "天数卡";
	} else if (type == "class") {
		html = "sclass.jsp"
		title = "私教卡";
	} else if (type == "times") {
		html = "timesCard.jsp"
		title = "次数卡";
	} else if (type == "money") {
		html = "moneyCard.jsp"
		title = "储值卡";
	}
	var id = getValuesByName('id', "f_mem___f_mem");
	dialog({
		url : "pages/f_mem/userCard/" + html + "?id=" + id,
		title : title,
		width : 1400,
		height : 700,
		okValue : "确定",
		ok : function() {
			return true;
		}
	}).showModal();

}
function del(name) {
	var selected = getSelectedCount(name);
	if (selected == 1) {
		var fk_user_id = getValuesByName('id', name);
		dialog({
			title : '确认删除',
			content : '你确定要删除选择的信息吗?',
			ok : function() {
				$.ajax({
					type : "POST",
					url : "fit-mem-del",
					data : {
						fk_user_id : fk_user_id
					},
					dataType : "json",
					async : false,
					success : function(data) {
						if (data.rs == "Y") {
							location.reload();
						}
					}
				});
			},
			okValue : "确定",
			cancel : function() {
				return true;
			},
			calcelValue : "取消"
		}).showModal();
	} else {
		error("请选择一条数据进行操作");
	}
}
function edit(name) {
	if (typeof (name) == "undefined") {
		name = ms_name;
	}
	var selected = getSelectedCount(name);
	if (selected == 1) {
		var id = getValuesByName('id', name);
		dialog(
				{
					url : "fit-ws-bg-detial?id=" + id,
					title : "修改会员",
					width : 960,
					height : 640,
					okValue : "修改",
					ok : function() {
						var iframe = $(window.parent.document).contents().find(
								"[name=" + dialog.getCurrent().id + "]")[0].contentWindow;
						iframe.saveUpdateDialog(this, document, "f_mem");
						return false;
					},
					cancelValue : "取消",
					cancel : function() {
						return true;
					}
				}).show();
	} else {
		error("请选择一条数据进行操作");
	}
}
