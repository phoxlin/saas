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
	$.messager.progress();
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
		url : "emp-save?m=edit" + "&e=" + entity + "&lockId=" + lockId,
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
				callback_info("修改成功", function() {
					//win.close();
					var docm = window.parent.document;
					$(docm).find("button[title=关闭]").last().click(); 
					doc.getElementById(name + '_refresh_toolbar').click();
					var d = $(docm).find("div[tabindex='-1']");
					$(d).remove();
				});
			} else {
				error(result);
			}
		}
	});
}


function f_emp_add_mc(name){
		dialog({
			url:"pages/f_emp/f_emp_bind_mc.jsp",
			title : '绑定-会籍',
			width : 500,
			height : 300,
			okVal : "确定",
			ok : function() {
				//var iframe = $(window.parent.document).contents().find("[name="+dialog.getCurrent().id+"]")[0].contentWindow;
				var iframe = $(window.parent.document).contents().find("div[i=dialog]:first iframe")[0].contentWindow;
				iframe.bindRole(this,name,"MC");
				return false;
			},
			cancelVal : "关闭",
			cancel : function() {
				return true;
			}
		}).showModal();
}
function f_emp_edit_mc(name){
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
				+ "&nextpage=" + nextpage + "?role=mc&type=edit&instance_id="
				+ instance_id,
			title : '修改' + my_title,
			width : myWidth,
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
function f_emp_add_sm(name){
	dialog({
		url:"pages/f_emp/f_emp_bind_sm.jsp",
		title : '电脑端工作人员',
		width : 900,
		height : 500,
		okValue : "确定",
		ok : function() {
			//var iframe = $(window.parent.document).contents().find("[name="+dialog.getCurrent().id+"]")[0].contentWindow;
			var iframe = $(window.parent.document).contents().find("div[i=dialog]:first iframe")[0].contentWindow;
			iframe.bindRole(this,name,"SM");
			return false;
		},
		cancelValue : "关闭",
		cancel : function() {
			return true;
		}
	}).showModal();
}
function f_emp_edit_sm(name){
	var count = getSelectedCount(name);
	if (count == 1) {
		var emp_id = getValuesByName("id", name);
		dialog({
			url:"pages/f_emp/f_emp_bind_sm.jsp?emp_id="+emp_id+"&role=sm",
			title : '电脑端工作人员',
			width : 900,
			height : 500,
			okValue : "确定",
			ok : function() {
				//var iframe = $(window.parent.document).contents().find("[name="+dialog.getCurrent().id+"]")[0].contentWindow;
				var iframe = $(window.parent.document).contents().find("div[i=dialog]:first iframe")[0].contentWindow;
				iframe.bindRole(this,name,"SM");
				return false;
			},
			cancelValue : "关闭",
			cancel : function() {
				return true;
			}
		}).showModal();
	}else{
		error('请选择一位人员操作');
	}
}

function f_emp_add_pt(name){
		dialog({
			url:"pages/f_emp/f_emp_bind_pt.jsp",
			title : '绑定-教练',
			width : 500,
			height : 300,
			okVal : "确定",
			ok : function() {
				//var iframe = $(window.parent.document).contents().find("[name="+dialog.getCurrent().id+"]")[0].contentWindow;
				var iframe = $(window.parent.document).contents().find("div[i=dialog]:first iframe")[0].contentWindow;
				iframe.bindRole(this,name,"PT");
				return false;
			},
			cancelVal : "关闭",
			cancel : function() {
				return true;
			}
		}).show();
}
function f_emp_edit_pt(name){
	var instance_id = $("#instance_id").val();
	var my_title = "";
	var my_title = "";
	try {
		my_title = eval(name + '_dialog_title');
	} catch (e) {
	}
	var nextpage = "edit.jsp?role=pt";
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
				+ "&nextpage=" + nextpage + "?role=pt&type=edit&instance_id="
				+ instance_id,
			title : '修改' + my_title,
			width : myWidth,
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
function f_emp_add_mc_ex(name){
	dialog({
		url:"pages/f_emp/f_emp_bind_ex.jsp?role=mc",
		title : '绑定-会籍管理',
		width : 600,
		height : 500,
		okVal : "确定",
		ok : function() {
			var iframe = $(window.parent.document).contents().find("div[i=dialog]:first iframe")[0].contentWindow;
			iframe.bindRole(this,name,"EX");
			return false;
		},
		cancelVal : "关闭",
		cancel : function() {
			return true;
		}
	}).show();
}
function f_emp_add_pt_ex(name){
		dialog({
			url:"pages/f_emp/f_emp_bind_ex.jsp?role=pt",
			title : '绑定-教练管理',
			width : 600,
			height : 500,
			okVal : "确定",
			ok : function() {
				//var iframe = $(window.parent.document).contents().find("[name="+dialog.getCurrent().id+"]")[0].contentWindow;
				var iframe = $(window.parent.document).contents().find("div[i=dialog]:first iframe")[0].contentWindow;
				iframe.bindRole(this,name,"EX");
				return false;
			},
			cancelVal : "关闭",
			cancel : function() {
				return true;
			}
		}).show();
}
function f_emp_edit_ex(name){
	var instance_id = $("#instance_id").val();
	var my_title = "";
	var my_title = "";
	try {
		my_title = eval(name + '_dialog_title');
	} catch (e) {
	}
	var nextpage = "edit.jsp?role=ex";
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
				+ "&nextpage=" + nextpage + "?role=ex&type=edit&instance_id="
				+ instance_id,
			title : '修改' + my_title,
			width : myWidth,
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
function f_emp_edit_all(name){
	var instance_id = $("#instance_id").val();
	var my_title = "";
	var my_title = "";
	try {
		my_title = eval(name + '_dialog_title');
	} catch (e) {
	}
	var nextpage = "edit.jsp?role=all";
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
			+ "&nextpage=" + nextpage + "?role=all&type=edit&instance_id="
			+ instance_id,
			title : '修改员工信息',
			width : myWidth,
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

function f_emp_del_ex(name){
	var count = getSelectedCount(name);
	if (count == 1) {
		var emp_id = getValuesByName("id", name);
		f_emp_del("ex",emp_id);
	}else{
		error('请选择一位人员操作');
	}
}
//删除员工角色
function f_emp_del(emp_id){
	
}

function f_emp_mc___f_emp_mcHook(){
	dealHook("mc");
}
function f_emp_pt___f_emp_ptHook(){
	dealHook("pt");
}
function f_emp_ex___f_emp_exHook(){
	dealHook("ex");
}
function f_emp_sm___f_emp_smHook(){
	dealHook("sm");
}
function f_emp_all___f_emp_allHook(){
	dealHook("all");
}

//hook处理显示图片
function dealHook(role){
	/*var tr = $(".data tr");
	tr.each(function() {
		var td = $(this).find("td:last div");
		$(td).html("<button onclick='bind()'>绑定</button>");
	});*/
	var td = $("td[id^=f_emp_"+role+"___f_emp_"+role+"__pic_url] div");
	td.each(function(){
		var html = "<img width='50px' hegiht='50px' style='margin-top:-10px' src='"+$(this).text()+"'></img>";
		$(this).html(html);
	});
}

function f_emp_del_mc(name){
	del(name,"mc");
}

function f_emp_del_pt(name){
	del(name,"pt");
}

function f_emp_del_ex(name){
	del(name,"ex");
}

function f_emp_del_sm(name){
	del(name,"sm");
}

function del(name,role){
	var count = getSelectedCount(name);
	if (count == 1) {
		var emp_id = getValuesByName("id", name);
		var roleName = "该角色";
		if(role=="mc"){
			roleName="会籍";
		}else if(role=="pt"){
			roleName="教练";
		}else if(role=="ex"){
			roleName="主管";
		}else if(role=="sm"){
			roleName="管理员";
		}
		dialog({
			title : '操作提醒',
			content :"删除之后该员工将不再在本会所担任"+roleName+",请确认.",
			width : 200,
			height : 100,
			lock: true,
			okValue : "确定",
			ok : function() {
				//var iframe = $(window.parent.document).contents().find("[name="+dialog.getCurrent().id+"]")[0].contentWindow;
				$.ajax({
					url:"ws-bg-emp-generic-role-unbind",
					type:"POST",
					data:{
						emp_id:emp_id,
						role:role
					},
					dataType:"JSON",
					success:function(data){
						
					}
				});
				window.parent.document.getElementById(name + '_refresh_toolbar').click();
				
				 var doc = window.parent.document;
					$(doc).find("button[title=取消]").first().click(); 
				return false;
			},
			cancelValue : "取消",
			cancel : function() {
				return true;
			}
		}).showModal();
		
	}else{
		error('请选择一位人员操作');
	}
}

function f_emp_edit_pt_app(name){
	var instance_id = $("#instance_id").val();
	var my_title = "";
	var my_title = "";
	try {
		my_title = eval(name + '_dialog_title');
	} catch (e) {
	}
	var nextpage = "pages/f_emp/f_emp_edit_pt.jsp";
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
			height : myHeight,
			okValue : "修改",
			ok : function() {
				var iframe = $(window.parent.document).contents().find("[name="+dialog.getCurrent().id+"]")[0].contentWindow;
				iframe.save_pt_edit(this, document, my_entity, name);
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

function save_pt_edit(win, doc, entity, name) {
	$.messager.progress();
	$('#' + form_id).form('submit', {
		url : "fit-bg-emp-save-edit-pt?m=edit" + "&e=" + entity + "&lockId=" + lockId,
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

function f_emp_edit_passoword(name){
	var count = getSelectedCount(name);
	if (count == 1) {
		var id = getValuesByName("id", name);
		var name = getValuesByName("name", name);
		dialog({
			url:"pages/f_emp/mem/changePWD.jsp?emp_id="+id,
			title : '修改员工['+name+"]的账号",
			width : 400,
			height : 300,
			okValue : "修改",
			ok : function() {
				var iframe = $(window.parent.document).contents().find("[name="+dialog.getCurrent().id+"]")[0].contentWindow;
				iframe.updatePassword(this, document, name);
				return false;
			},
			cancelValue : "关闭",
			cancel : function() {
				return true;
			}
		}).showModal();
	} else {
		error("请选择员工");
	}
	
}

function f_emp_add_mc_bysm(name){
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
		url : nextpage + "?type=add&instance_id=" + instance_id+"&role=mc",
		title : '添加会籍',
		width : myWidth,
		height : myHeight,
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
	}).showModal();

}
function f_emp_add_pt_bysm(name){
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
		url : nextpage + "?type=add&instance_id=" + instance_id+"&role=pt",
		title : '添加教练',
		width : myWidth,
		height : myHeight,
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
	}).showModal();
	
}