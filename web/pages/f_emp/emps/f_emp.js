function cq(name, type, params, startpage, pagesize, orderby, desc) {
	
	var leftParams = window.localStorage.getItem("leftParams");
	if(leftParams!=null&&leftParams.length>0){
		try{
			params=JSON.parse(leftParams);
		}catch(e){}
	}
	
	
	if (typeof (name) == "undefined") {
		name = ms_name;
	}
	
	if (typeof (type) == "undefined") {
		type = 'ms';
	}
	
	var my_title="";
	if(type!='task'){
		try{
			if (typeof (dialog_title) == "undefined") {
				my_title=eval(name+'_dialog_title');
			}else{
				my_title=dialog_title;
			}
		}catch(e){
		}
	}
	try {
		loading = eval(name + '_loading');
	} catch (e) {
		loading = false;
	}
	

	
	if (typeof (startpage) == "undefined") {
		startpage = 1;
	}
	if (typeof (pagesize) == "undefined") {
		pagesize = 20;
	}
	if (typeof (orderby) == "undefined") {
		orderby = '';
	}
	if (typeof (desc) == "undefined") {
		desc = 'n';
	}

	try {
		filter = eval(name + '_filter');
	} catch (e) {
		filter = [];
	}
	
	if (typeof (params) == "undefined") {
		try {
			params = eval(name + '_params');
			params = JSON.stringify(params);
		} catch (e) {
			params = '{}';
		}
	} else {
		if (isJson(params)) {
			params = JSON.stringify(params);
		}
	}
	for (var i = 0; i < filter.length; i++) {
		var f = filter[i];
		var fname = name + '_' + f.columnname + '_search_'+i;

		if ((f.format != null && f.format.length > 0) || 'date' == f.type
				|| 'datetime' == f.type) {
			try {
				var val = $('#' + fname).datebox('getValue');
				f.columnvalue = val
			} catch (e) {
				f.columnvalue = '';
			}
			;

		} else {
			var val2 = $('#' + fname).val();
			f.columnvalue = val2;
		}

	}
	if (loading) {
		$.messager.progress();
	}
	$.ajax({
				type : 'POST',
				url : 'common_query',
				dataType : 'json',
				data : {
					name : name,
					params : params,
					type : type,
					startpage : startpage,
					pagesize : pagesize,
					orderby : orderby,
					desc : desc,
					filter : JSON.stringify(filter)
				},
				success : function(data) {
					if (loading) {
						$.messager.progress('close');
					}
					var result = "当前系统繁忙";
					result = data.rs;
					if (result == 'Y') {
						
						if (document.getElementById(data.name+"_table") != undefined) {
							//说明不是第一次加载，所以只需要刷新数据就可以了
							var common_query_Index_dataOnlyTpl = document.getElementById('common_query_Index_dataOnlyTpl').innerHTML;
							var common_query_Index_dataOnlyTplHtml = template(common_query_Index_dataOnlyTpl, {
								list : data,
								filter : filter,
								name : data.name,
								params : params,
								type : type,
								dialog_title:my_title,
								cds:data.cds
							});
							$('#' + data.name+"_responsive_tableAndpaging").html(common_query_Index_dataOnlyTplHtml);
							
							var pagerTpl = document.getElementById('common_query_Index_pagerTpl').innerHTML;
							var pager = template(pagerTpl, {
								list : data,
								filter : filter,
								name : data.name,
								params : params,
								type : type,
								dialog_title:my_title,
								cds:data.cds
							});
							$('#' + data.name+"_responsive_tablepager").html(pager);
						}else{
							//查看下是否是收银台的url如果是 就不显示数据导出功能
							
							var tVal=getQueryString("tt");
							var cashier=false;
							if('yp_browser'==tVal){
								cashier=true;
							}
							var pageTpl = document.getElementById('common_query_IndexTpl').innerHTML;
							var html = template(pageTpl, {
								list : data,
								filter : filter,
								name : data.name,
								params : params,
								type : type,
								dialog_title:my_title,
								cashier:cashier,
								cds:data.cds
							});
							if (document.getElementById(data.name) != undefined) {
								$('#' + data.name).html(html);
								$.parser.parse('#' + data.name);
							} else if (document.getElementById(data.name + "Page") != undefined) {
								$('#' + data.name + 'Page').html(html);
								$.parser.parse('#' + data.name + 'Page');
							}
							for (var i = 0; i < filter.length; i++) {
								var f = filter[i];
								var fname = data.name + '_' + f.columnname + '_search';
								if ((f.format != null && f.format.length > 0) || 'date' == f.type || 'datetime' == f.type) {
									if (f.columnvalue == null || f.columnvalue.length <= 0) {
										$('#' + fname).datebox('setValue', "");
									} else {
										$('#' + fname).datebox('setValue', f.columnvalue);
									}
								} else {
									$('#' + fname).val(f.columnvalue);
								}
							}
						}
						//判断js hook是否存在，存在就调用
						try{eval(data.name+"Hook()"); }catch(e){}
						
						//datebox placeholder
						$(".filter-container").find(".easyui-datebox").each(function(){
							var placeholder = $(this).attr("data-attr");
							$(this).next(".datebox").children(".textbox-text").attr("placeholder", placeholder);
						});

						//计算数据区显示高度
						var h = $(".main2").height();
						var f = $(".filter-container").outerHeight(true);
						var t = $("thead").outerHeight(true);
						$(".data").height(h-f-t-18-h*0.05);
						
						//捕获tr事件
						$('#' + data.name+"_responsive_tableAndpaging").find(".data").find("tr").each(function(index, element){
							element.addEventListener('click',function(){row_click(data.name, index)},true);
						});
					} else {
						error(result);
					}
				},
				error : function(xhr, type) {
					if (loading) {
						$.messager.progress('close');
					}
				}
			});
}


function f_emp_choose___f_emp_chooseHook(){
	var tr = $(".data tr");
	tr.each(function() {
		var td = $(this).find("td:last div");
		$(td).html("<button onclick='bind()'>绑定</button>");
	});
	var td = $("td[id^=f_emp_choose___f_emp_choose__pic_url] div");
	td.each(function(){
		var html = "<img width='50px' hegiht='50px' style='margin-top:-10px' src='"+$(this).text()+"'></img>";
		$(this).html(html);
	});
}

function bind(){
	var name = "f_emp_choose___f_emp_choose";
	var count = getSelectedCount(name);
	if (count == 1) {
		var emp_id = getValuesByName("id", name);
		var pic_url = getValuesByName("pic_url", name);
		var name = getValuesByName("name", name);
		var row = {"id":emp_id,"pic_url":pic_url,"name":name};
		var iframe = $(window.parent.document).contents().find("div[i=dialog]:first iframe")[0].contentWindow;
		iframe.callbackFun(row);
		var doc = window.parent.document;
		$(doc).find("button[title=cancel]").last().click();
	}
}
