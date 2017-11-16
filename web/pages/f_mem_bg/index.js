
function openExpert(){
	var url = "pages/f_mem_bg/export/index.jsp";
	var id="id_"+new Date().getTime();
	dialog(
			{
				url : url,
				title : "会员数据导入",
				width : 500,
				height : 400,
				okValue : "保存上传数据",
				id: id,
				ok : function() {
					var iframe = $(window.parent.document).contents().find(
							"[name=" + id + "]")[0].contentWindow;
					iframe.savaAddDialog(this, document, "f_mem");
					return false;
				},
				cancelValue : "取消",
				cancel : function() {
					return true;
				}
			}).show();
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
			cancelValue : "取消",
			cancel : function() {
				return true;
			}
		}).showModal();
	} else {
		error("请选择一条数据进行操作");
	}
}
function change_sales(name){
	var selected = getSelectedCount(name);
	if (selected >0) {
		var id = getValuesByName('id', name);
		 top.dialog({
		        url: "partial/chioceEmp.jsp?userType=sales",
		        title: "选择会籍",
		        width: 820,
		        height: 700,
		        okValue: "确定",
		        ok: function() {
		        	var iframe = $(window.parent.document).contents().find("[name=" + top.dialog.getCurrent().id + "]")[0].contentWindow;
		            iframe.saveId(this);
		        	var salesId = "";
		            var sales = store.getJson("sales");
		            if(sales){
		         	   salesId = sales.id;
		            }
		            store.set('sales',{});
		            doChangeSales(id,salesId);
		            return false;
		        },
		        cancelValue:"取消",
		        cancel:function(){
		        	return true;
		        }
		    }).showModal();
	} else {
		error("请选择一条数据进行操作");
	}
}

function doChangeSales(fk_user_id,fk_sales_id){
	 $.ajax({
	        type: "POST",
	        url: "fit-ws-bg-Mem-changeSales",
	        data: {
	        	fk_user_id : fk_user_id+"",
	        	fk_sales_id : fk_sales_id
	        },
	        dataType: "json",
	        async: false,
	        success: function(data) {
	            if (data.rs == "Y") {
	            	 location.reload();
	            } else {
	                error(data.rs);
	            }
	        }
	    });
}
function change_coach(name){
	var selected = getSelectedCount(name);
	if (selected >0) {
		var id = getValuesByName('id', name);
		 top.dialog({
		        url: "partial/chioceEmp.jsp?userType=coach",
		        title: "选择教练",
		        width: 820,
		        height: 700,
		        okValue: "确定",
		        ok: function() {
		        	var iframe = $(window.parent.document).contents().find("[name=" + top.dialog.getCurrent().id + "]")[0].contentWindow;
		            iframe.saveId(this);
		        	var coachId = "";
		            var coach = store.getJson("coach");
		            if(coach){
		            	coachId = coach.id;
		            }
		            store.set('coach',{});
		            doChangeCaoch(id,coachId);
		            return false;
		        },
		        cancelValue:"取消",
		        cancel:function(){
		        	return true;
		        }
		    }).showModal();
	} else {
		error("请选择一条数据进行操作");
	}
}
function doChangeCaoch(fk_user_id,fk_coach_id){
	 $.ajax({
	        type: "POST",
	        url: "fit-ws-bg-Mem-changeCoach",
	        data: {
	        	fk_user_id : fk_user_id+"",
	        	fk_coach_id : fk_coach_id
	        },
	        dataType: "json",
	        async: false,
	        success: function(data) {
	            if (data.rs == "Y") {
	                location.reload();
	            } else {
	                error(data.rs);
	            }
	        }
	    });
}
