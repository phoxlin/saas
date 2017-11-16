//打开批量添加框
function adds() {
	var url = "pages/f_box/f_addbox.jsp";
	top.dialog(
			{
				url : url,
				title : "添加柜子",
				width : 500,
				height : 305,
				okValue : "确定",
				ok : function() {
				var iframe = $(window.parent.document).contents().find(
				"[name=" + top.dialog.getCurrent().id + "]")[0].contentWindow;
				iframe.doAddMore(this, document, "f_box");
				return false;
			},

				cancelValue : "取消",
				cancel : function() {
					return true;
				}
			}).showModal();
}

function sets(){
	var url = "pages/f_box/f_setbox.jsp";
	dialog(
			{
				url : url,
				title : "租柜押金",
				width : 400,
				height : 300,
				okValue : "确定",
				ok : function() {
				var iframe = $(window.parent.document).contents().find(
				"[name=" + dialog.getCurrent().id + "]")[0].contentWindow;
				iframe.doSetMore(this, document, "f_box");
				return false;
			},

				cancelValue : "取消",
				cancel : function() {
					return true;
				}
			}).show();

	
}

/*	function savaAddDialog(win, doc, entity, name) {
		$('#f_boxFormObj').form('submit', {
			url : "box_add?m=add" + "&e=" + entity + "&lockId=" + lockId,
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
					alert(result);
				}
			}
		});
	}*/
//箱柜管理
function manageBox(){
	var url = "pages/f_box/mangeBox.jsp";
	dialog(
			{
				url : url,
				title : "添加柜子",
				width : 500,
				height : 305,
				okValue : "确定",
				ok : function() {
					document.location.reload();
				return false;
			},

				cancelValue : "取消",
				cancel : function() {
					return true;
				}
			}).showModal();
	
}
//添加箱柜
function doAddMore(win,doc,name){
	var area_no=$('#area_no').val();
	 if(area_no == null || area_no.length <= 0){
		$("#area_no").focus();
		return false;
	}
	var box_nums = $("#box_nums").val();
	if(box_nums == null || box_nums.length <= 0){
		$("#box_nums").focus();
		return false;
	}
	
	$.ajax({
		type: "POST",
		url: "fit-action-box_add",
		data:{
			area_no:area_no,
			box_nums:box_nums
			
		},
		dataType: "json",
		success: function(data) {
			if(data.rs == "Y") {
				var count = data.count;
				callback_info("成功添加"+count+"个柜子",function(){
					doc.location.reload();
				});                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
			}else{ 
				alert(data.rs);
			}
		}
	}); 
}
//删除箱柜
function delBox(area_no){
	top.dialog({
        title: '确认删除箱柜',
        content: '你确定要删除箱柜吗?',
        okValue: "确定",
        ok: function() {
            var iframe = $(window.parent.document).contents().find("div[i=dialog]:first iframe")[0].contentWindow;
            iframe.isDelBox(this, document, window, area_no);
            return false;
        },
        cancelValue: "取消",
        cancel: function() {
            return true;
        }
    }).showModal();
	
}
//确认删除箱柜
function isDelBox(win, doc, window, area_no) {
    $.ajax({
        type: "POST",
        url: "fit-action-delBox",
        data: {
        	area_no: area_no
        },
        dataType: "json",
        async: false,
        success: function(data) {
            if (data.rs == "Y") {
            	alert("删除成功");
                window.location.reload();

            } else {
                alert(data.rs);
            }

        }
    });
}
//显示修改箱柜
function showEditBox(area_no) {
    top.dialog({
        url: "fit-action-showeditBox?area_no=" + area_no + "&nextpage=pages/f_box/f_addbox.jsp",
        title: "修改箱柜信息",
        width: 500,
        height: 305,
        okValue: "确定",
        ok: function() {
        	var iframe = $(window.parent.document).contents().find("[name=" + top.dialog.getCurrent().id + "]")[0].contentWindow;
            iframe.editBox(this, document, window,area_no);
            return false;
        },
        cancelValue: "取消",
        cancel: function() {
            return true;
        }
    }).showModal();
}
//修改箱柜
function editBox(win, doc, window,area_no_old) {
	var area_no=$('#area_no').val();
	 if(area_no == null || area_no.length <= 0){
		$("#area_no").focus();
		return false;
	}
	var box_nums = $("#box_nums").val();
	if(box_nums == null || box_nums.length <= 0){
		$("#box_nums").focus();
		return false;
	}
	$.ajax({
		type: "POST",
		url: "fit-action-editBox",
		data:{
			area_no:area_no,
			box_nums:box_nums,
			area_no_old : area_no_old
			
		},
		dataType: "json",
		success: function(data) {
			if(data.rs == "Y") {
				var count = data.count;
				callback_info("成功添加"+count+"个柜子",function(){
					doc.location.reload();
				});                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
			}else{ 
				alert(data.rs);
			}
		}
	});
}
//显示会员租柜页面
function showRentBox(box_id){
	dialog({
        url: "fit-action-showrentBox?box_id=" + box_id + "&nextpage=pages/f_box/rentBox.jsp",
        title: "租柜",
        width: 800,
        height: 450,
        okValue: "确定",
        ok: function() {
        	var iframe = $(window.parent.document).contents().find("div[i=dialog]:first iframe")[0].contentWindow;
            iframe.getPrice(this, document, window,box_id,"");
            return false;
        },
        cancelValue: "取消",
        cancel: function() {
            return true;
        }
    }).showModal();
}

//会员租柜
function getPrice(win, doc, window,box_id,type2) {
	var rentStartTime = $("#rentStartTime").val();
	var mem_id = $("#rent_mem_id").val();
	var rentEndTime = $("#rentEndTime").val();
	
    var type = $("#type").val();
    if(type == "disabled"){
    	win.close();
    	return;
    }
    if(rentStartTime == "" || rentEndTime ==""){
    	alert("时间不能为空");
    	return ;
    }
    if(mem_id ==""){
    	alert("请选择会员");
    	return ;
    }
	
	var mem_id = $("#mem_id").val();
	$.ajax({
		type: "POST",
		url: "fit-action-getPrice",
		data:{
			rentStartTime:rentStartTime,
			rentEndTime:rentEndTime,
			mem_id : mem_id,
			type : type2
			
		},
		dataType: "json",
		success: function(data) {
			if(data.rs == "Y") {
				var caPrice = data.caPrice;
				var cash = data.cash;
				rentBox(win, doc, window,box_id,caPrice,cash);
			}else{ 
				alert(data.rs);
			}
		}
	});
}
//解绑
function cancel(){
	$("#memName").html("点击选择会员");
	   $("#f_rent__box_id").val("");
	
}
//显示归还柜子页面
function guiHuan(id){
	top.dialog({
        url: "pages/f_box/backBox.jsp?id="+id,
        title: "归还柜子",
        width: 400,
        height: 200,
        okValue: "确定",
        ok: function() {
        	var iframe = $(window.parent.document).contents().find("[name=" + top.dialog.getCurrent().id + "]")[0].contentWindow;
            iframe.backBox(this, document, window,id);
            return false;
        },
        cancelValue: "取消",
        cancel: function() {
            return true;
        }
    }).showModal();
	
}
//归还柜子
function backBox(win, doc, window,id){
	var remark = $("#remark").val();
	$.ajax({
		type: "POST",
		url: "fit-action-backBox",
		data:{
			id:id,
			remark : remark
		},
		dataType: "json",
		success: function(data) {
			if(data.rs == "Y") {
//				debugger;
				backMoney(data.money,data.fk_user_id,id);
				                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
			}else{ 
				alert(data.rs);
			}
		}
	});
}
function backMoney(money,fk_user_id,rent_id){
	top.dialog({
	    title: '提示',
	    content: "您确定要退押金，退还押金：￥"+money,
	    okValue: '确定',
	    ok: function () {
	    	  $.ajax({
	    	      type: "POST",
	    	      url: "fit-action-backBoxMoney",
	    	      data: {
	    	          fk_user_id: fk_user_id,
	    	          rent_id: rent_id,
	    	          money: money,
	    	          rent_id: rent_id
	    	      },
	    	      dataType: "json",
	    	      async: false,
	    	      success: function(data) {
	    	           if (data.rs == "Y") {
	    	        	    alert("退押金成功");
	    	        	    window.parent.parent.location.href="pages/f_box/showBox.jsp" 
	    	          } else {
	    	              alert(data.rs);
	    	          }
	    	      }
	    	  });
	    },
	    cancelValue: '取消',
	    cancel: function () {
	    	return true;
	    	window.parent.parent.location.href="pages/f_box/showBox.jsp" 
	    }
	}).showModal();
	
}
//续费
function xuFei(box_id){
	top.dialog({
        url: "fit-action-showrentBox?box_id=" + box_id + "&nextpage=pages/f_box/xuFeiBox.jsp",
        title: "箱柜续费",
        width: 800,
        height: 450,
        okValue: "确定",	
        ok: function() {
        	var iframe = $(window.parent.document).contents().find("[name=" + $(this)[0].id + "]")[0].contentWindow;
        	iframe.getPrice(this, document, window,box_id,"xuFei");
            return false;
        },
        cancelValue: "取消",
        cancel: function() {
            return true;
        }
    }).showModal();
}
//显示备注
function showRecord(remark){
		dialog({
        url: "pages/f_box/showRemark.jsp?remark="+remark,
        title: "备注预览",
        width: 400,
        height: 200,
        cancelValue: "取消",
        cancel: function() {
            return true;
        }
    }).showModal();
}
//搜索租柜记录
function searchOrder(cur){
	var startTime = $("#startTime").val();
	var endTime = $("#endTime").val();
	var mem_no = $("#mem_no").val();
	var mem_name = $("#mem_name").val();
	var box_no = $("#box_no").val();
	var state = $("#state").val();
	var selectBox = $("#selectBox").val();
	var par = {"a.start_time" : startTime,"a.end_time" : endTime,"b.mem_no" : mem_no,"b.mem_name" : mem_name,"c.box_no" : box_no,"a.state" : state ,"c.AREA_NO" : selectBox};
	$.ajax({
		type: "POST",
		url: "fit-box-searchOrder",
		data:{
			par : JSON.stringify(par),
			cur : cur
		},
		dataType: "json",
		success: function(data) {
			if(data.rs == "Y") {
				var boxTpl = document.getElementById('boxTpl').innerHTML;
				var selectTpl = document.getElementById('selectTpl').innerHTML;
				var boxHtml = template(boxTpl, {
					list : data.list,
					curPage:data.curPage,
					curSize:data.curSize,
					totalPage:data.totalPage,
					total:data.total
				});
				var selectHtml = template(selectTpl, {
					area_no : data.area_no
				});
				$('#tableDiv').html(boxHtml);
				$('#selectBox').html(selectHtml);
			
			}else{ 
				alert(data.rs);
			}
		}
	});
}