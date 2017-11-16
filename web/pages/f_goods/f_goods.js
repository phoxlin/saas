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
	var myHeight = 300;
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
		width : 1050,
		height : myHeight,
		cancelValue : "关闭",
		cancel : function() {
			return true;
		},
		okValue : "保存",
		ok : function() {
			//var iframe = $(window.parent.document).contents().find("[name="+dialog.getCurrent().id+"]")[0].contentWindow;
			var iframe = $(window.parent.document).contents().find("div[i=dialog]:first iframe")[0].contentWindow;
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
		top.dialog({url:"task-cq-detail?entity=" + my_entity + "&id=" + id
				+ "&nextpage=" + nextpage + "&type=edit&instance_id="
				+ instance_id,
			title : '修改' + my_title,
			width : 1050,
			height : myHeight,
			okValue : "修改",
			ok : function() {
				//var iframe = $(window.parent.document).contents().find("[name="+dialog.getCurrent().id+"]")[0].contentWindow;
				var iframe = $(window.parent.document).contents().find("div[i=dialog]:first iframe")[0].contentWindow;
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
			width : 1050,
			height : myHeight,
			cancelValue : "关闭",
			cancel : function() {
				return true;
			}
		}).showModal();
	} else {
		error("请选择一行信息进行查看");
	}
}

function savaAddDialog(win, doc, entity, name) {
	$('#' + form_id).form('submit', {
		url : "fit-goods-save?m=add" + "&e=" + entity + "&lockId=" + lockId,
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
					//win.close();
					//doc.getElementById(name + '_refresh_toolbar').click();
					
					$(doc).find("button[title=关闭]").last().click(); 
					doc.getElementById(name + '_refresh_toolbar').click();
					var d = $(doc).find("div[tabindex='-1']");
					$(d).remove();
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
		url : "fit-goods-edit?m=edit" + "&e=" + entity + "&lockId=" + lockId,
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
					//win.close();
					//doc.getElementById(name + '_refresh_toolbar').click();
					//$(doc).find("button[title=关闭]").last().click(); 
					var doc = window.parent.document;
					$(doc).find("button[title=关闭]").first().click(); 
					doc.getElementById(name + '_refresh_toolbar').click();
					var d = $(doc).find("div[tabindex='-1']");
					$(d).remove();
				});
			} else {
				error(result);
			}
		}
	});
}



function f_goods___f_goodsHook(){
	var td = $("td[id^=f_goods___f_goods__pic_url] div");
	td.each(function(){
		if($(this).text() ==""){
			var html = "<img width='50px' hegiht='50px' style='margin-top:-10px' src='partial/goods/images/default_goods.jpg'></img>";
		}else{
			var html = "<img width='50px' hegiht='50px' style='margin-top:-10px' src='"+$(this).text()+"'></img>";
		}
		$(this).html(html);
	});
	
	var tds = $("td[id^=f_goods___f_goods__state] div");
	tds.each(function(){
		var state = $(this).text();
		var goods_id = $(this).parent().parent().find("td:first input[id^=f_goods___f_goods__id]").val();
		var html = "<label style='font-weight:normal'><input " + (state =="在售"?"checked='checked'":"")+ " type='checkbox' onclick='putUporDown(this,\""+goods_id+"\")'/>收银台上架</label>";
		$(this).html(html);
	});
}

function putUporDown(t,id){
	var flag = $(t).is(":checked");
	var state ="close";
	if(flag){
		state ="sale";
	}
	$.ajax({
		url:"fit-ws-bg-goods-put-upOrDown",
		type:"POST",
		dataType:"JSON",
		data:{goods_id:id,state:state},
		success:function(data){
			if(data.rs == "Y"){
				if(data.mem){
					$("#mem_id").val(data.mem.id);
					$("#mem_gym").val(data.mem.gym);
					$("#mem_name").text(data.mem.name);
					$("#mem_remain_amt").text(data.mem.remain_amt);
				}
			}else{
				error("操作失败,请稍后重试");
			}
		}
	});
}

//库存管理
function store_inOrout(name){
	var count = getSelectedCount(name);
	if (count == 1) {
		var id = getValuesByName("id", name);
		top.dialog({
			url:"pages/f_goods/f_goods_store_manager.jsp?goods_id="+id,
			title : '商品出入库管理',
			width : 800,
			height : 500,
			okValue : "保存",
			ok : function() {
				var iframe = $(window.parent.document).contents().find("[name="+dialog.getCurrent().id+"]")[0].contentWindow;
				iframe.save(name,this);
				return false;
			},
			cancelValue : "取消",
			cancel : function() {
				return true;
			}
		}).showModal();
	}else{
		error("请先选则一款商品");
	}
}

//盘点
function goods_check(name){
	var count = getSelectedCount(name);
	if (count == 1) {
		var id = getValuesByName("id", name);
		top.dialog({
			url:"pages/f_goods/f_goods_check.jsp?goods_id="+id,
			title : '商品数量盘点',
			width : 800,
			height : 500,
			okValue : "保存",
			ok : function() {
				var iframe = $(window.parent.document).contents().find("[name="+dialog.getCurrent().id+"]")[0].contentWindow;
				iframe.check(name,this);
				return false;
			},
			cancelValue : "取消",
			cancel : function() {
				return true;
			}
		}).showModal();
	}else{
		error("请先选则一款商品");
	}
}
