	$(document).ready(function() {
		$('#pre_treeid').tree({
			onSelect:function(e,node){
				var id=e.id;
				if(id!=null&&id.length>0){
					var ids=id.split("__");
					var menuId=ids[0];
					$.ajax({
						type : "POST",
						url : "fw?controller=com.framework.action.SysMenuAction",
						dataType : "json",
						data : {
							method : 'menu_detail',
							id:menuId
						},
						success : function(data) {
							var result="当前系统繁忙";try{data = eval('(' + data + ')');	result=data.result;}catch(e){try{data = eval(data);result=data.result;}catch(e1){}}
							if(result=='Y'){
								document.getElementById("sys_menu_info__id").value=data.detail.listData[0].id;
								document.getElementById("sys_menu_info__m_code").value=data.detail.listData[0].m_code;
								document.getElementById("sys_menu_info__m_code2").value=data.detail.listData[0].m_code;
								document.getElementById("sys_menu_info__m_note").value=data.detail.listData[0].m_note;
								document.getElementById("sys_menu_info__m_table_name").value=data.detail.listData[0].m_table_name;
								$('#sys_menu_info__sort').numberbox('setValue', data.detail.listData[0].sort);
								try{
									var short_cross=data.detail.listData[0].short_cross;
									if(short_cross==null||short_cross.length<=0){
										$('#sys_menu_info__short_cross').combobox('setValue', 'N');	
									}else{
										$('#sys_menu_info__short_cross').combobox('setValue', short_cross);
									}
								}catch(e){
									$('#sys_menu_info__short_cross').combobox('setValue', 'N');
								}
								var shortcut=data.detail.listData[0].shortcut;
								if(shortcut==null||shortcut.length<=0){
									shortcut='';
								}
								document.getElementById("sys_menu_info__shortcut").value=shortcut;

								var shortname=data.detail.listData[0].short_cross_name;
								if(shortname==null||shortname.length<=0){
									shortname='';
								}
								document.getElementById("sys_menu_info__short_cross_name").value=shortname;
								
								var iconClass=data.detail.listData[0].icon_class;
								if(iconClass==null||iconClass.length<=0){
									iconClass='';
								}
								document.getElementById("sys_menu_info__icon_class").value=iconClass;
								
								var url=data.detail.listData[0].url;
								if(url==null||url.length<=0){
									url='';
								}
								document.getElementById("sys_menu_info__url").value=url;
							}
						}
					});
				}
			}
		});
	});
	
	function addRoot(){
		$.messager.progress();
		$('#sys_menu_infoFormObj').form('submit', {
			url:"fw?controller=com.framework.action.SysMenuAction&method=addRoot",
			onSubmit: function(data){
				var isValid = $(this).form('validate');
				if (!isValid){
					$.messager.progress('close');
				}
				return isValid;
			},
			success: function(data){
				$.messager.progress('close');
				var result="当前系统繁忙";try{data = eval('(' + data + ')');	result=data.result;}catch(e){try{data = eval(data);result=data.result;}catch(e1){}}
		    	if("Y"==result){
		    		callback_info("你的信息保存成功啦。","reSetForm()");
		    	}else{
		    		error("保存失败",result);	
		    	}
			}
		});
	}
	
	function addNode(){
		$.messager.progress();
		$('#sys_menu_infoFormObj').form('submit', {
			url:"fw?controller=com.framework.action.SysMenuAction&method=addNode",
			onSubmit: function(data){
				var isValid = $(this).form('validate');
				if (!isValid){
					$.messager.progress('close');
				}
				return isValid;
			},
			success: function(data){
				$.messager.progress('close');
				var result="当前系统繁忙";try{data = eval('(' + data + ')');	result=data.result;}catch(e){try{data = eval(data);result=data.result;}catch(e1){}}
		    	if("Y"==result){
		    		callback_info("你的信息保存成功啦。","reSetForm()");
		    	}else{
		    		error("保存失败",result);	
		    	}
			}
		});
	}
	
	function del(){
		var id=document.getElementById("sys_menu_info__id").value;
		if(id!=null&&id.length>0){
			confirm2("你确定要删除选择的节点吗?","doDel()");
		}
	}
	function confirm2(msg, fun) {
		art.dialog.confirm(msg, function () {
			eval(fun);
		}, function () {
		});
		
		
	}

	function doDel(){
		var id=document.getElementById("sys_menu_info__id").value;
		$.ajax({
			type : "POST",
			url : "fw?controller=com.framework.action.SysMenuAction",
			dataType : "json",
			data : {
				method : 'menu_del',
				id:id
			},
			success : function(data) {
				var result="当前系统繁忙";try{data = eval('(' + data + ')');	result=data.result;}catch(e){try{data = eval(data);result=data.result;}catch(e1){}}
				if(result=='Y'){
					callback_info("提交成功","reSetForm()");
				}else{
					error("出错啦",data.result);
				}
			}
		});
	}
	
	function edit(){
		$.messager.progress();
		$('#sys_menu_infoFormObj').form('submit', {
			url:"fw?controller=com.framework.action.SysMenuAction&method=menu_edit",
			onSubmit: function(data){
				var isValid = $(this).form('validate');
				if (!isValid){
					$.messager.progress('close');
				}
				return isValid;
			},
			success: function(data){
				$.messager.progress('close');
				var result="当前系统繁忙";try{data = eval('(' + data + ')');	result=data.result;}catch(e){try{data = eval(data);result=data.result;}catch(e1){}}
		    	if("Y"==result){
		    		callback_info("你的信息保存成功啦。","reSetForm()");
		    	}else{
		    		error("保存失败",result);	
		    	}
			}
		});
	}
	
	function reSetForm(){
		$('#sys_menu_infoFormObj').form('clear');
		location.reload();
	}
	
	function set(){
		var m_code = document.getElementById("sys_menu_info__m_code").value;
		if(m_code==null||m_code.length<=0){
			error("出错啦", "请选择菜单添加工具栏.");
		}else{
			art.dialog.open('public/pub/menu/set.jsp?fk_menu_code=' + m_code, {
				title : '工具栏设置',
				width : 1000,
				height : 500
			});	
		}
	}
	
	function setpage(){
		var m_code = document.getElementById("sys_menu_info__m_code").value;
		var m_table = document.getElementById("sys_menu_info__m_table_name").value;
		if(m_code==null||m_code.length<=0){
			error("出错啦", "请选择菜单设计显示页面.");
		}else{
			art.dialog.open('public/pub/menu/page/index.jsp?fk_menu_code=' + m_code+"&table_name="+m_table, {
				title : '模块页面设计',
				width : 1000,
				height : 500,
				button: [
				         {
				             name: '预览',
				             callback: function () {
				            	 var iframe = this.iframe.contentWindow;
				     			 iframe.preShow(this, document);
				     			 return false;
				             },
				             focus: true
				         },
				         {
				             name: '页面生成',
				             callback: function () {
				            	 var iframe = this.iframe.contentWindow;
				     			 iframe.createEditPage(this, document);
				     			 return false;
				             }
				         },
				         {
				             name: '关闭',
				             callback: function () {
				                 return true;
				             }
				         }
				     ]
			});	
		}
	}
	
	function settable(){
		var m_code = document.getElementById("sys_menu_info__m_code").value;
		var m_table = document.getElementById("sys_menu_info__m_table_name").value;
		if(m_code==null||m_code.length<=0){
			error("出错啦", "请选择菜单设计显示页面.");
		}else{
			art.dialog.open('fw?controller=com.framework.action.SysMenuAction&method=queryPageTable&nextpage=public/pub/menu/table/index.jsp&fk_menu_code=' + m_code+"&table_name="+m_table, {
				title : '模块数据库设计',
				width : 1000,
				height : 500,
				button: [
				         {
				             name: '生成数据库表',
				             callback: function () {
				            	 var iframe = this.iframe.contentWindow;
				     			 iframe.createDBTable(this, document);
				     			 return false;
				             },
				             focus: true
				         },
				         {
				             name: '生成配置文件',
				             callback: function () {
				            	 var iframe = this.iframe.contentWindow;
				     			 iframe.createEntityXml(this, document);
				     			 return false;
				             }
				         },
				         {
				             name: '关闭',
				             callback: function () {
				                 return true;
				             }
				         }
				     ]
			});	
		}
	}
	
	function setcfg(){
		var m_code = document.getElementById("sys_menu_info__m_code").value;
		var m_table = document.getElementById("sys_menu_info__m_table_name").value;
		if(m_code==null||m_code.length<=0){
			error("出错啦", "请选择菜单设计显示页面.");
		}else{
			art.dialog.open('public/pub/menu/cfg/index.jsp?fk_menu_code=' + m_code+"&table_name="+m_table, {
				title : '模块列表设计',
				width : 1000,
				height : 500,
				button: [
				         {
				             name: '预览',
				             callback: function () {
				            	 var iframe = this.iframe.contentWindow;
				     			 iframe.preShow(this, document);
				     			 return false;
				             },
				             focus: true
				         },
				         {
				             name: '页面生成',
				             callback: function () {
				            	 var iframe = this.iframe.contentWindow;
				     			 iframe.createCfg(this, document);
				     			 return false;
				             }
				         },
				         {
				             name: '关闭',
				             callback: function () {
				                 return true;
				             }
				         }
				     ]
			});	
		}
	}

	function callback_info(msg, fun) {
		art.dialog(msg, function(){
			eval(fun);
		});
	}
	
	function info(msg) {
		art.dialog({
		    title: "消息",
		    content: msg,
		    icon: 'face-smile',
		    ok : function() {
				return true;
			}
		});
	}

	function error(title, msg) {
		art.dialog({
		    title: title,
		    content: msg,
		    icon: 'face-sad',
		    ok : function() {
				return true;
			}
		});
	}
