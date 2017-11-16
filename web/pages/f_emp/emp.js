function f_emp_add_mc_fromMem(name){
	
	var emp_id = "";
	var emp_name ="";
	var count = getSelectedCount(name);
	if (count == 1) {
		emp_id = getValuesByName("id", name);
		emp_name = getValuesByName("name", name);
	}
	
	dialog({
		url:"pages/f_emp/mem/f_emp_bind_mc.jsp?role=mc&emp_id="+emp_id+"&emp_name="+emp_name,
		title : '绑定—会籍',
		width : 500,
		height : 300,
		okValue : "确定",
		ok : function() {
			//var iframe = $(window.parent.document).contents().find("[name="+$(this)[0].id+"]")[0].contentWindow;
			var iframe = $(window.parent.document).contents().find("div[i=dialog]:first iframe")[0].contentWindow;
			//var iframe = $(window.parent.document).contents().find("[name=" + top.dialog.getCurrent().id + "]")[0].contentWindow;
			iframe.bindRole(this,name,"MC");
			return false;
		},
		cancelValue : "关闭",
		cancel : function() {
			return true;
		}
	}).showModal();
	
}
function f_emp_add_pt_FromMem(name){
	var emp_id = "";
	var emp_name ="";
	var count = getSelectedCount(name);
	if (count == 1) {
		emp_id = getValuesByName("id", name);
		emp_name = getValuesByName("name", name);
	}
	dialog({
		url:"pages/f_emp/mem/f_emp_bind_mc.jsp?role=pt&emp_id="+emp_id+"&emp_name="+emp_name,
		title : '绑定-教练',
		width : 500,
		height : 300,
		okValue : "确定",
		ok : function() {
			//var iframe = $(window.parent.document).contents().find("[name="+$(this)[0].id+"]")[0].contentWindow;
			var iframe = $(window.parent.document).contents().find("div[i=dialog]:first iframe")[0].contentWindow;
			//var iframe = $(window.parent.document).contents().find("[name=" + top.dialog.getCurrent().id + "]")[0].contentWindow;
			iframe.bindRole(this,name,"PT");
			return false;
		},
		cancelValue : "关闭",
		cancel : function() {
			return true;
		}
	}).showModal();
	
}

function f_emp_add_mc_exFromMem(name){
	
	var emp_id = "";
	var emp_name ="";
	var count = getSelectedCount(name);
	if (count == 1) {
		emp_id = getValuesByName("id", name);
		emp_name = getValuesByName("name", name);
	}
	
	dialog({
		url:"pages/f_emp/mem/f_emp_bind_ex.jsp?role=ex_mc&emp_id="+emp_id+"&emp_name="+emp_name,
		title : '绑定-会籍管理',
		width : 600,
		height : 300,
		okValue : "确定",
		ok : function() {
			//var iframe = $(window.parent.document).contents().find("[name="+$(this)[0].id+"]")[0].contentWindow;
			var iframe = $(window.parent.document).contents().find("div[i=dialog]:first iframe")[0].contentWindow;
			//var iframe = $(window.parent.document).contents().find("[name=" + top.dialog.getCurrent().id + "]")[0].contentWindow;
			iframe.bindRole(this,name,"mc");
			return false;
		},
		cancelValue : "关闭",
		cancel : function() {
			return true;
		}
	}).showModal();
	
}
function f_emp_add_pt_exFromMem(name){
	
	var emp_id = "";
	var emp_name ="";
	var count = getSelectedCount(name);
	if (count == 1) {
		emp_id = getValuesByName("id", name);
		emp_name = getValuesByName("name", name);
	}
	dialog({
		url:"pages/f_emp/mem/f_emp_bind_ex.jsp?role=ex_pt&emp_id="+emp_id+"&emp_name="+emp_name,
		title : '绑定-教练管理',
		width : 600,
		height : 300,
		okValue : "确定",
		ok : function() {
			//var iframe = $(window.parent.document).contents().find("[name="+$(this)[0].id+"]")[0].contentWindow;
			var iframe = $(window.parent.document).contents().find("div[i=dialog]:first iframe")[0].contentWindow;
			//var iframe = $(window.parent.document).contents().find("[name=" + top.dialog.getCurrent().id + "]")[0].contentWindow;
			iframe.bindRole(this,name,"pt");
			return false;
		},
		cancelValue : "关闭",
		cancel : function() {
			return true;
		}
	}).showModal();
	
}

function f_emp_add_smFromMem(name){
	
	var emp_id = "";
	var emp_name ="";
	var count = getSelectedCount(name);
	if (count == 1) {
		emp_id = getValuesByName("id", name);
		emp_name = getValuesByName("name", name);
	}
	dialog({
		url:"pages/f_emp/mem/f_emp_bind_sm.jsp?role=sm&emp_id="+emp_id+"&emp_name="+emp_name,
		title : '绑定-后台管理员',
		width : 700,
		height : 400,
		okValue : "确定",
		ok : function() {
			//var iframe = $(window.parent.document).contents().find("[name="+$(this)[0].id+"]")[0].contentWindow;
			var iframe = $(window.parent.document).contents().find("div[i=dialog]:first iframe")[0].contentWindow;
			//var iframe = $(window.parent.document).contents().find("[name=" + top.dialog.getCurrent().id + "]")[0].contentWindow;
			iframe.bindRole(this,name,"sm");
			return false;
		},
		cancelValue : "关闭",
		cancel : function() {
			return true;
		}
	}).showModal();
	
}
