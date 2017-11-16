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
		width : 1000,
		height : 700,
		cancelValue : "关闭",
		cancel : function() {
			return true;
		},
		okValue : "保存",
		ok : function() {
			//var iframe = $(window.parent.document).contents().find("[name="+$(this)[0].id+"]")[0].contentWindow;
			var iframe = $(window.parent.document).contents().find("div[i=dialog]:last iframe")[0].contentWindow;
			iframe.savaAddDialog(this, document, my_entity, name);
			return false;
		},
	}).showModal();

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
		dialog({url:"task-cq-detail?entity=" + my_entity + "&id=" + id
				+ "&nextpage=" + nextpage + "&type=edit&instance_id="
				+ instance_id,
			title : '修改' + my_title,
			width : 1000,
			height : 700,
			okValue : "修改",
			ok : function() {
				//var iframe = $(window.parent.document).contents().find("[name="+$(this)[0].id+"]")[0].contentWindow;
				var iframe = $(window.parent.document).contents().find("div[i=dialog]:last iframe")[0].contentWindow;
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
			width : 1000,
			height : 700,
			cancelValue : "关闭",
			cancel : function() {
				return true;
			}
		}).showModal();
	} else {
		error("请选择一行信息进行编辑");
	}
}

function savaAddDialog(win, doc, entity, name) {
	$.messager.progress();
	$('#' + form_id).form('submit', {
		url : "fit-bg-active-save?m=add" + "&e=" + entity + "&lockId=" + lockId,
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
					var doc = window.parent.document;
					$(doc).find("button[title=关闭]").last().click(); 
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
		url : "fit-bg-active-save?m=edit" + "&e=" + entity + "&lockId=" + lockId,
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
					var doc = window.parent.document;
					$(doc).find("button[title=关闭]").last().click(); 
					
					doc.getElementById(name + '_refresh_toolbar').click();
					
				});
			} else {
				error(result);
			}
		}
	});
}
function showCards(card_type){
	//	url : "fit-ws-bg-Mem-getCard-list-detail",
	$.ajax({
		type : "POST",
		url : "fit-ws-bg-Mem-getCard",
		data : {
			card_type : card_type
		},
		dataType : "json",
		async : false,
		success : function(data) {
			if (data.rs == "Y") {
				if(data.data){
					var list = data.data;
					var html = "";
					for(var i=0;i<list.length;i++){
						var card = list[i];
						html += '<li><label><input type="checkbox" onclick="addItem(this,\''+card.id+'\')">'+card.card_name+'</label></li><li style="width: 10px;"></li>';
					}
					html = html.replace(/"\r\n"/g,"");
					$('#cardList').html(html);
				}
			} else {
				error(data.rs);
			}

		}
	});
}

function addItem(t,id){
	var check = $(t).is(":checked");
	var has = $("#"+id).length > 0;
	
	if(has){
		if(!check){
			if($("#"+id).attr("data-exists") =="Y"){
				//不能移除
			}else{
				$("#"+id).next().remove();
				$("#"+id).remove();
			}
		}
	}else{
		if(check){
			$.ajax({
				type : "POST",
				url : "fit-ws-bg-Mem-getCardDetial",
				data : {
					card_id : id
				},
				dataType : "json",
				async : false,
				success : function(data) {
					if (data.rs == "Y") {
						var price = data.data.fee;
						var days = data.data.days;
						var times = data.data.times;
						var card_name = data.data.card_name;
						var tpl = $("#itemTpl").html();
						var html = template(tpl,{item:data.data});
						$('#act_content').before(html);
						//给3个框框加验证
						$("input[name=f_active_item__prj_name]:last").validatebox({    
						    required: true,    
						});  

						$("input[name=f_active_item__price]:last").numberbox({    
						    min:0,    
						    precision:2,
						    required: true   
						});  

						$("input[name=f_active_item__act_price]:last").numberbox({    
						    min:0,    
						    precision:2,
						    required: true
						});  

					} else {
						error(data.rs);
					}
					
				}
			});
		}
	}
}

function removeItem(t,id){
	
	 dialog({
			title : '操作提醒',
			content :"确认要删除该活动项目吗?",
			okValue : "确认",
			ok : function() {
				var flag = false;
				$.ajax({
					type : "POST",
					url : "fit-bg-active-item-del",
					data : {
						item_id : id
					},
					dataType : "json",
					async : false,
					success : function(data) {
						if (data.rs == "Y") {
							$(t).parent().parent().next().remove();
							$(t).parent().parent().remove();
							flag = true;
						} else {
							error(data.rs);
						}
						
					}
				});
				return flag;
			},
			cancelValue : "取消",
			cancel : function() {
				return true;
			}
	 	}).showModal();
}

function remove(t){
	$(t).parent().parent().next().remove();
	$(t).parent().parent().remove();
}

//评价
function f_active_words(name){
	var count = getSelectedCount(name);
	if (count == 1) {
		var id = getValuesByName("id", name);
		top.dialog({
			url:"pages/f_active_words/index.jsp?act_id="+id, 
			title : '查看评论',
			width : 1050,
			height : 700,
			cancelValue : "关闭",
			cancel : function() {
				return true;
			}
		}).showModal();
	} else {
		error("请选择一项活动查看");
	}
}