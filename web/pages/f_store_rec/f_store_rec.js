
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
			url:"fit-bg-store-rec-detail?entity=" + my_entity + "&id=" + id
				+ "&nextpage=" + nextpage + "&type=detail", 
			title : '查看' + my_title,
			width : myWidth,
			height : myHeight,
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
		dialog({url:"fit-bg-store-rec-detail?entity=" + my_entity + "&id=" + id
				+ "&nextpage=" + nextpage + "&type=edit&instance_id="
				+ instance_id,
			title : '修改' + my_title,
			width : myWidth,
			height : myHeight,
			okValue : "修改",
			ok : function() {
				var iframe = $(window.parent.document).contents().find("[name="+dialog.getCurrent().id+"]")[0].contentWindow;
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

function savaEditDialog(win, doc, entity, name) {
	$.messager.progress();
	$('#' + form_id).form('submit', {
		url : "fit-bg-store-rec-edit?m=edit" + "&e=" + entity + "&lockId=" + lockId,
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

//
//确认删除
function doDel(name) {
	var id = getValuesByName('id', name);
	var instance_id = getValuesByName('instance_id', name);
	var my_entity = "";
	try {
		my_entity = eval(name + '_entity');
	} catch (e) {
	}
	$.ajax({
		type : 'POST',
		url : "fit-bg-store-rec-del",
		dataType : 'json',
		data : {
			id : id + "",
			instance_id : instance_id +"",
			entity : my_entity + ""
		},
		success : function(data) {
			var result = "当前系统繁忙";
			result = data.rs;
			if (result == 'Y') {
				callback_info("删除成功啦", function() {
					$('#' + name + '_refresh_toolbar').click();
				});
			} else {
				error(result);
			}
		}
	});
}

function f_store_rec___f_store_recHook(){
	var td = $("td[id^=f_store_rec___f_store_rec__remark] div");
	td.each(function(){
		var html ="";
		if($(this).text() ==""){
			
		}else{
			html="<a href='javascript:void(0)' onclick='showRemark(\""+$(this).text()+"\")'>查看</a>";
		}
		$(this).html(html);
	});
}

function showRemark(remark){
	dialog({
		title:"备注说明",
		content:remark,
		okValue:"关闭",
		ok:function(){
			return true;
		}
	}).show();
}

