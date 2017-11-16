function f_active_words___f_active_wordsHook(){
	
	
	var td = $("td[id^=f_active_words___f_active_words__content] div");
	td.each(function(){
		var text = $(this).text();
		text = text.replace(/&/g,"&amp;");
		text = text.replace(/</g,"&lt;");
		text = text.replace(/>/g,"&gt;");
		text = text.replace(/ /g,"&nbsp;");
		text = text.replace(/\'/g,"&#39;");
		text = text.replace(/\"/g,"&quot;");
		var html = "<a onclick=showMsg('"+text+"')>查看</a>"
		$(this).html(html);
	});
	
}

function showMsg(text){
	
	text = text.replace(/&amp;/g,"&");
	text = text.replace(/&lt;/g,"<");
	text = text.replace(/&gt;/g,">");
	text = text.replace(/&nbsp;/g," ");
	text = text.replace(/&#39;/g,"\'");
	text = text.replace(/&quot;/g,"\"");
	
	dialog({
		title:"用户评论",
		content:text,
		okValue:"关闭",
		ok:function(){
			return true;
		}
	}).show();
}


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
		url : nextpage + "?type=add&instance_id=" + instance_id,
		title : '添加' + my_title,
		width : myWidth,
		height : myHeight,
		cancelValue : "关闭",
		cancel : function() {
			return true;
		},
		okValue : "保存",
		ok : function() {
			var iframe = $(window.parent.document).contents().find("[name="+$(this)[0].id+"]")[0].contentWindow;
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
			width : myWidth,
			height : myHeight,
			okValue : "修改",
			ok : function() {
				var iframe = $(window.parent.document).contents().find("[name="+$(this)[0].id+"]")[0].contentWindow;
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
