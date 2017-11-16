//根据当前登录用户id 进行初始化会员管理选项
function initFliter(userId) {

}

function openExpert(){
	var url = "pages/f_mem/export/index.jsp";
	var id="id_"+new Date().getTime();
	dialog(
			{
				url : url,
				title : "会员数据导入",
				width : 500,
				height : 400,
				okValue : "保存上传数据",
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


function addMem() {
	var url = "pages/f_mem/f_mem_edit.jsp";
	dialog(
			{
				url : url,
				title : "添加会员",
				width : 960,
				height : 640,
				okValue : "确定",
				ok : function() {
					var iframe = $(window.parent.document).contents().find(
							"[name=" + dialog.getCurrent().id + "]")[0].contentWindow;
					iframe.savaAddDialog(this, document, "f_mem");
					return false;
				},
				cancelValue : "取消",
				cancel : function() {
					return true;
				}
			}).show();
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

// function update(name) {
// var count = getSelectedCount("f_mem___f_mem");
// if (count == 1) {
// var id = getValuesByName("id",name);
// art.dialog.open("yp_mem-detail?entity=yp_mem&id=" +
// id+"&nextpage=pages/yp_mem_bg/yp_mem_detail_all_edit.jsp&type=detail",
// {
// title : '查看会员资料',
// width : 1000,
// height : 700,
// lock : true,
// okVal: '提交',
// ok : function() {
// var iframe = this.iframe.contentWindow;
// //iframe.saveUserInfo(this, document, id, gym);
// //var form = $(document).find("#yp_mem_detailFormObj");
// //var form1 = $(document).find("form[name=yp_mem_detailFormObj]");
// iframe.save_all_mem(this, document);
// return false;
// },
// cancelVal : "关闭",
// cancel : function() {
// return true;
// }
// });
// } else {
// error("请选择一行信息进行编辑");
// }
// }
function taskCqDel2(name) {
	var $ret = window.confirm("确认删除？");
	if ($ret) {

		var count = getSelectedCount("f_mem___f_mem");
		if (count == 1) {
			var id = getValuesByName("id", name);
			var gym = getValuesByName("gym__qm_code", name);
			$.ajax({
				type : 'POST',
				url : "yp_mem-del",
				dataType : 'json',
				data : {
					id : id + "",
					gym : gym + ""
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
		} else {
			error("请选择一行信息进行编辑");
		}
	}

}

function getQueryType() {
	var ids = $("[role='tabpanel']");
	var tabName = "tab1";
	for (var i = 0; i < ids.length; i++) {
		var div = ids[i];
		if ($(div).hasClass('active')) {
			tabName = $(div).attr('id');
			break;
		}
	}
	var type = "all";
	var val = "";
	var types = null;
	if ('tab2' == tabName) {
		types = $("[data-name='show-model-type2']");
	} else if ('tab3' == tabName) {
		types = $("[data-name='show-model-type3']");
	} else {
		types = $("[data-name='show-model-type1']");
	}

	if (types != null && types.length > 0) {
		for (var ii = 0; ii < types.length; ii++) {
			var div = types[ii];
			if ($(div).hasClass('active')) {
				type = $(div).attr('data-type');
				val = $(div).find("[data-flag='value']").html();
				break;
			}
		}
	}
	return type + "__" + val;
}

function getFilter() {
	var gym_level = $('#gym_level').val();
	var area_code = $('#area_code').val();
	var gym_code = $('#gym_code').val();
	var mem_name = $('#mem_name').val();
	var sex = $('#sex').val();
	var type_code = $('#type_code').val();
	var mem_no = $('#mem_no').val();
	var phone = $('#phone').val();
	var start_time = $('#start_time').val();
	var end_time = $('#end_time').val();
	var dept = $('#dept').val();
	var sales_id = $('#sales_id').val();
	var coach_id = $('#coach_id').val();
	var state = $('#state').val();

	var filter = {};
	filter.gym_level = gym_level;
	filter.area_code = area_code;
	filter.gym_code = gym_code;
	filter.mem_name = mem_name;
	filter.sex = sex;
	filter.type_code = type_code;
	filter.mem_no = mem_no;
	filter.phone = phone;
	filter.start_time = start_time;
	filter.end_time = end_time;
	filter.dept = dept;
	filter.sales_id = sales_id;
	filter.coach_id = coach_id;
	filter.state = state;

	// 获取排序信息
	// filter.sortColumn='';
	// filter.sortType='desc/asc'
	return filter;
}

function doQuery(curPage) {
	var queryType = getQueryType();
	var type = "all";
	var val = "";
	try {
		var types = queryType.split('__');
		type = types[0];
		if (types[1] == undefined || types[1] == 'undefined') {
			val = "";
		} else {
			val = types[1];
		}
	} catch (e) {
	}
	var filter = getFilter();
	filter.type = type;
	filter.typeVal = val;
	if (!curPage) {
		curPage = 1;
	}
	$.messager.progress();
	$
			.ajax({
				type : 'POST',
				// url : 'yp-ws-bg-mem',
				url : 'fit-ws-bg-mem',
				dataType : 'json',
				data : {
					filter : JSON.stringify(filter),
					curPage : curPage
				},
				success : function(data) {
					$.messager.progress('close');
					var result = "当前系统繁忙";
					result = data.rs;
					if (result == 'Y') {
						data.name = "f_mem___f_mem";

						var common_query_Index_dataOnlyTpl = document
								.getElementById('common_query_dataOnlyTpl').innerHTML;
						var common_query_Index_dataOnlyTplHtml = template(
								common_query_Index_dataOnlyTpl, {
									list : data,
									filter : filter,
									name : data.name,
									params : params,
									type : type,
									dialog_title : "会员管理",
									cds : data.cds

								});
						console.log(common_query_Index_dataOnlyTplHtml);
						$('#f_mem___f_mem_responsive_tableAndpaging').html(
								common_query_Index_dataOnlyTplHtml);
						var common_query_Index_pagerTpl = document
								.getElementById('common_query_Index_pagerTpl_mem').innerHTML;
						var common_query_Index_pagerTplHtml = template(
								common_query_Index_pagerTpl, {
									list : data,
									filter : filter,
									name : data.name,
									params : params,
									type : type,
									dialog_title : "会员管理",
									cds : data.cds

								});
						$('#f_mem___f_mem_pager').html(
								common_query_Index_pagerTplHtml);

						$('#' + data.name + "_responsive_tableAndpaging").find(
								".data").find("tr").each(
								function(index, element) {
									element.addEventListener('click',
											function() {
												row_click(data.name, index)
											}, true);
								});
					} else {
						error(result);
					}
				},
				error : function(xhr, type) {
					$.messager.progress('close');
				}
			});
}

// 翻页
function pager(obj, event) {
	event.stopPropagation();
	if (event.keyCode == "13") {
		var page = $(obj).val();
		var totalpage = $(obj).attr("data-totalpage");
		if (page) {
			if (page <= 0) {
				page = 1;
			} else if (parseInt(page) > parseInt(totalpage)) {
				page = totalpage
			}
			doQuery(page);
		}
	}
}
// onchange
function toPage(page, totalpage) {
	if (page <= 0) {
		page = 1;
	} else if (parseInt(page) > parseInt(totalpage)) {
		page = totalpage
	}
	doQuery(page);
}

// 查看会员详细信息
// function detail(name) {
// var count = getSelectedCount("f_mem___f_mem");
// if (count == 1) {
// var id = getValuesByName("id",name);
// art.dialog.open("yp_mem-detail?entity=yp_mem&id=" +
// id+"&nextpage=pages/yp_mem_bg/yp_mem_detail.jsp&type=detail",
// {
// title : '查看会员资料',
// width : 1000,
// height : 700,
// lock : true,
//					
// cancelVal : "关闭",
// cancel : function() {
// return true;
// }
// });
// } else {
// error("请选择一行信息进行编辑");
// }
// }
function cExpert(export_type) {
	var queryType = getQueryType();
	var type = "all";
	var val = "";
	try {
		var types = queryType.split('__');
		type = types[0];
		if (types[1] == undefined || types[1] == 'undefined') {
			val = "";
		} else {
			val = types[1];
		}
	} catch (e) {
	}
	var filter = getFilter();
	filter.type = type;
	filter.typeVal = val;
	var curPage = $(".pager input[type='number']").val();
	if (!curPage) {
		curPage = 1;
	}
	if ("all" == export_type) {
		curPage = -1;
	}

	var exportIframe = document.createElement("iframe");
	exportIframe.width = 0;
	exportIframe.height = 0;
	exportIframe.style.display = "none";
	document.body.appendChild(exportIframe);

	var postForm = document.createElement("form");
	postForm.method = "post";
	postForm.target = exportIframe;

	var nameInput = document.createElement("input");
	nameInput.name = "name";
	nameInput.value = name;
	postForm.appendChild(nameInput);

	var startpageInput = document.createElement("input");
	startpageInput.name = "curPage";
	startpageInput.value = curPage;
	postForm.appendChild(startpageInput);

	var pagesizeInput = document.createElement("input");
	pagesizeInput.name = "pagesize";
	pagesizeInput.value = 20;
	postForm.appendChild(pagesizeInput);

	var descInput = document.createElement("input");
	descInput.name = "desc";
	descInput.value = "desc";
	postForm.appendChild(descInput);

	var filterInput = document.createElement("input");
	filterInput.name = "filter";
	filterInput.value = JSON.stringify(filter);
	postForm.appendChild(filterInput);

	postForm.action = 'yp-ws-bg-mem-expertExcel';
	document.body.appendChild(postForm);
	postForm.submit();
	document.body.removeChild(postForm);
	document.body.removeChild(exportIframe);
}
