
function sys_task_finish___sys_task_finish_legendHook(){
	var rows = document.getElementsByName("sys_task_finish___sys_task_finish_legend_row");
	for (var i = 0; i < rows.length; i++) {
		var taskcode=$('#sys_task_finish___sys_task_finish_legend__taskcode_'+i).val();
		/*  获取第一个sid  instance_id +1*/
		var id=$('#sys_task_finish___sys_task_finish_legend__id_'+i).val();
		var html='<a onclick="processTask(\''+path+'\',\''+id+'\',\''+taskcode+'\');">查看</a>';
		$('#sys_task_finish___sys_task_finish_legend__op_html_'+i).find('div').html(html);
		var thisDiv = $('#sys_task_finish___sys_task_finish_legend__errata_html_'+i).find('div');
		
		var html = "";
		var text = "勘误";
		var instance_id=$('#sys_task_finish___sys_task_finish_legend__instance_id_'+i).val();
		var content = thisDiv.html();
		var name = $("#sys_task_finish___sys_task_finish_legend__instance_name_html_"+i).find('div').html();
		if(content&&content != ""){
			if(name!="信用恢复"&&name!=""){
				if (content == "yes"){
					html='<a  style="cursor:pointer" onclick="processTask(\''+path+'\',\''+id+'\',\''+taskcode+'\',\'change\');">勘误</a>';		
				}else{
					html='';
				}
			
			}
			$('#sys_task_finish___sys_task_finish_legend__errata_html_'+i).find('div').html(html);
		}
	}
}

function changeErrata(instance_id,i,type){
	var thisDiv = $("#sys_task_finish___sys_task_finish_legend__errata_html_"+i).find('div');
	$.ajax({
		url:"changeErrata",
		type:"post",
		data:{
			'instance_id':instance_id,
			'type':type
			},
		dataType:"json",
		success:function(data){
			if(data.rs == "Y"){
				var result = data.result;
				if("success" == result){
					info("勘误状态改变成功");
					if("open" == type){
						thisDiv.html('<a style="cursor:pointer;" onclick="changeErrata(\''+instance_id+'\',\''+i+'\',\'shutdown\');">关闭</a>');
					}else{
						thisDiv.html('<a style="cursor:pointer;" onclick="changeErrata(\''+instance_id+'\',\''+i+'\',\'open\');">勘误</a>');
					}
				}else{
					error("勘误状态改变失败");
				}
			}else{
				error(data.rs);
			}
		}
	})
}
function processTask(path, sid/* sys_task_step表的id */, state,type) {
	// ie 10 有问题所以加了一个path
	var url = path + '/pages/' + state + '/index.jsp?sid=' + sid;
	if(type&&type!=''){
		url = url+'&_='+type;
	}
	window.open(url);
	// 如果可以进行页面跳转。
}

function addNewTask(){
	art.dialog.open("public/pub/sys_task_finish/addNewTask.jsp",{
		title : '新建任务',
		width : 400,
		height : 200,
		cancelVal : "关闭",
		cancel : function() {
			return true;
		},
		okVal : "启动",
		ok : function() {
			var iframe = this.iframe.contentWindow;
			iframe.lanuchTask(this, document,'sys_task_finish___sys_task_finish_legend');
			return false;
		},
	});
}

function lanuchTask(win,doc,name){
	$.messager.progress();
	$('#sys_task_finish_legendFormObj').form('submit',	{
		url : "task-start-up?lockId="+lockId,
		onSubmit : function(data) {
			var isValid = $(this).form('validate');
			if (!isValid) {
				$.messager.progress('close');
			}
			return isValid;
		},
		success : function(data) {
			$.messager.progress('close');
			var result="当前系统繁忙";try{data = eval('(' + data + ')');	result=data.rs;}catch(e){try{data = eval(data);result=data.rs;}catch(e1){}}
			if ("Y" == result) {
				callback_info( "成功", function (){
					win.close();
					doc.getElementById(name+'_refresh_toolbar').click();
				});
			} else {
				error(result);
			}
		}
	});
}