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
		width : myWidth,
		height : 150,
		cancelValue : "关闭",
		cancel : function() {
			return true;
		},
		okValue : "保存",
		ok : function() {
			var iframe = $(window.parent.document).contents().find("[name="+dialog.getCurrent().id+"]")[0].contentWindow;
			iframe.savaAddDialog(this, document, my_entity, name);
			return false;
		},
	}).show();

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
			width : myWidth,
			height : 150,
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
		}).show();
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
			width : myWidth,
			height : 150,
			cancelValue : "关闭",
			cancel : function() {
				return true;
			}
		}).show();
	} else {
		error("请选择一行信息进行编辑");
	}
}

function f_store___f_storeHook(){
	var td = $("td[id^=f_store___f_store__pid] div");
	td.each(function(){
		var text = $(this).text();
		if(text == "-1" || text ==""){
			$(this).text("主仓库");
		}
	});
	
}