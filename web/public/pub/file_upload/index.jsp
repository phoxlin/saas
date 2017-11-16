<%@page import="com.jinhua.server.log.Logger"%>
<%@page import="java.util.UUID"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	User user=SystemUtils.getSessionUser(request, response);
	if(user==null){ request.getRequestDispatcher("/").forward(request, response);}

	String taskcode = "file_upload";
	String taskname = "文件上传";
	String sId=UUID.randomUUID().toString();

%>
<!DOCTYPE html>
<html>
<head>
<title><%=taskname%></title>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">


<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">

<script type="text/javascript" src="public/jQuery/jquery-1.10.2.js" charset="utf-8"></script>
<link rel="stylesheet" type="text/css" href="public/sb_admin2/bower_components/bootstrap/dist/css/bootstrap.min.css">
<!-- MetisMenu CSS -->
<link rel="stylesheet" type="text/css" href="public/sb_admin2/bower_components/metisMenu/dist/metisMenu.min.css">
<!-- Custom CSS -->
<link rel="stylesheet" type="text/css" href="public/sb_admin2/dist/css/sb-admin-2.css">
<!-- Custom Fonts -->
<link rel="stylesheet" type="text/css" href="public/sb_admin2/bower_components/font-awesome/css/font-awesome.min.css">

<link rel="stylesheet" type="text/css" href="public/sb_admin2/bower_components/easyui-1.4.4/themes/bootstrap/easyui.css">
<link rel="stylesheet" type="text/css" href="public/sb_admin2/bower_components/easyui-1.4.4/themes/icon.css">

<link rel="stylesheet" type="text/css" href="public/css/page.css">


<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/easyui-1.4.4/jquery.easyui.min.js"></script>
<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/easyui-1.4.4/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/easyui-1.4.4/myValidate.js"></script>

<script type="text/javascript" charset="utf-8" src="public/js/artDialog.js?skin=default"></script>
<script type="text/javascript" charset="utf-8" src="public/js/iframeTools.js"></script>
<script type="text/javascript" charset="utf-8" src="public/js/artDialog.notice.source.js"></script>

<script type="text/javascript" charset="utf-8" src="public/js/json2.js"></script>
<script type="text/javascript" charset="utf-8" src="public/js/template.js"></script>

<script type="text/javascript" charset="utf-8" src="public/js/jinhua-yun-1.0.0.js"></script>
<script type="text/javascript" charset="utf-8" src="public/ms/common_query.js"></script>
<script type="text/javascript" charset="utf-8" src="public/designer/common_query.task.op.js"></script>

<link href="public/jQuery/swfupload/default.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="public/jQuery/uuid.js"></script>
<script type="text/javascript" src="public/jQuery/swfupload/swfupload.js"></script>
<script type="text/javascript" src="public/jQuery/swfupload/swfupload.queue.js"></script>
<script type="text/javascript" src="public/jQuery/swfupload/fileprogress.js"></script>
<script type="text/javascript" src="public/jQuery/swfupload/handlers.js"></script>
<script type="text/javascript">
<!--
template.config({sTag: '<#', eTag: '#>'});
//-->
</script>
<jsp:include page="/public/designer/tpl/taskTpl-Content.jsp"></jsp:include>
<jsp:include page="/public/ms/tpl/default/common_query_index.jsp"></jsp:include>
<script type="text/javascript">
 

//data-grid配置开始
///////////////////////////////////////////(1).file_upload___sys_file开始///////////////////////////////////////////
	//搜索配置
	var file_upload___sys_file_filter=[
				      	 ];
	//编辑页面弹框标题配置
	var file_upload___sys_file_dialog_title='文件上传';
	//编辑页面弹框宽度配置
	var file_upload___sys_file_dialog_width=700;
	//编辑页面弹框高度配置
	var file_upload___sys_file_dialog_height=500;
	//IndexGrid数据加载提示配置
	var file_upload___sys_file_loading=true;
	//编辑页面弹框宽度配置
	var file_upload___sys_file_entity="sys_file";
	//编辑页面路径配置
	var file_upload___sys_file_nextpage="public/pub/file_upload/sys_file_edit.jsp";
	
	var file_upload___sys_file_params={
			sql:"select * from sys_file a where a.session_id=?",
			sqlPs:['<%=sId%>']
		};
	
///////////////////////////////////////////(1).file_upload___sys_file结束///////////////////////////////////////////

//data-grid配置结束



</script>

<script type="text/javascript">
	$(document).ready(function() {
		showTaskView('<%=taskcode%>','<%=sId%>','N');
	});
</script>
<script type="text/javascript">
var fileNumber="<%=request.getParameter("number")%>";
fileNumber=parseInt(fileNumber);
var buttonImg="upload.png";
var id="<%=request.getParameter("id")%>";
var extDesc=new Array();
var exts="<%=request.getParameter("ext")%>";
if(exts!=null&&exts!='null'&&exts.length>0){
	var extList=exts.split(",");
	for(var i=0;i<extList.length;i++){
		var temp=extList[i];
		extDesc.push("*."+temp);
	}
}else{
	extDesc.push("*.*");
}

var upload1;
window.onload = function() {
	upload1 = new SWFUpload({
		// Backend Settings
		upload_url: "upload.jsp",
		post_params: {"sId" : "<%=sId%>","number":fileNumber},

		// File Upload Settings
		file_size_limit : "10240000",	// 100MB
		file_types : extDesc.join(";"),
		file_types_description : extDesc.join(";"),
		file_upload_limit : "1000",
		file_queue_limit : "0",

		// Event Handler Settings (all my handlers are in the Handler.js file)
		file_dialog_start_handler : fileDialogStart,
		file_queued_handler : fileQueued,
		file_queue_error_handler : fileQueueError,
		file_dialog_complete_handler : fileDialogComplete,
		upload_start_handler : uploadStart,
		upload_progress_handler : uploadProgress,
		upload_error_handler : uploadError,
		upload_success_handler : uploadSuccess,
		upload_complete_handler : uploadComplete,

		// Button Settings
		button_image_url : buttonImg,
		button_placeholder_id : "spanButtonPlaceholder1",
		button_width: 61,
		button_height: 22,
		
		// Flash Settings
		flash_url : "public/jQuery/swfupload/swfupload.swf",
		

		custom_settings : {
			progressTarget : "fsUploadProgress1",
			cancelButtonId : "btnCancel1"
		},
		
		// Debug Settings
		debug: false
	});
 }

function addFile(obj,doc){
	
	var inp=doc.getElementById(id);
	
	var ids=getAllValuesByName("id","file_upload___sys_file");
	if(ids.length>0){
		var names=getAllValuesByName("re_name","file_upload___sys_file");
		
		var inpVal=inp.value;
		
		//检查是否上传文件数量超过了。
		var vals=inpVal.split(',');
		if(inpVal==null||inpVal.length<=0){
			vals=new Array();
		}
		
		var tempLength=vals.length+ids.length;
		if(tempLength>fileNumber){
			//超过了
			var aTags=doc.getElementsByName(id+"_a_tag");
			var imgTags=doc.getElementsByName(id+"_img_tag");
			var indexI=0;
			for(var m=0;m<(tempLength-fileNumber);m++){
				indexI=m;
				var tempA=aTags[0];
				var tempImg=imgTags[0];
				try{
					tempA.parentNode.removeChild(tempA);
					tempImg.parentNode.removeChild(tempImg);
				}catch(e){
				}
			}
			var tempVals=new Array();
			for(indexI=indexI+1;indexI<vals.length;indexI++){
				tempVals.push(vals[indexI]);
			}
			inpVal=tempVals.join(',');
		}
		
		//设置新上传的文件信息
		var desc=doc.getElementById("desc_"+id);
		var html=desc.innerHTML;
		
		for(var i=0;i<ids.length;i++){
			if(i!=0){
				html+=" ";
				
			}
			if(inpVal.length>0){
				inpVal+=",";
			}
			inpVal+=ids[i];
			html+=" <a id='"+ids[i]+"_1' name='"+id+"_a_tag' href='public/pub/file_upload/down.jsp?id="+ids[i]+"'>"+names[i]+"</a> <img name='"+id+"_img_tag'   id='"+ids[i]+"_2' style='cursor:pointer' src='public/jQuery/easyui/css/images/tabs_close.gif' onclick=\"deleteFile('" + ids[i] + "','"+id+"')\" >";
			if((i+1)>=fileNumber){
				break;
			}
		}
		desc.innerHTML=html;
		inp.value=inpVal;
	}
	obj.close();
}

</script>
<style type="text/css">

.data-container {
    height: 200px;
    width: 100%;
    overflow-y: hidden;
}

</style>
</head>
<body>

	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-12">
				<div id="content">
				<form id="form1" method="post" enctype="multipart/form-data">
					<table>
						<tr valign="top">
							<td>
								<div>
									<div class="fieldset flash" id="fsUploadProgress1" style="height: 100px;z-index: 0;">
										<span class="legend">请选择需要上传的文件</span>
									</div>
									<div style="padding-left: 5px;">
										<span id="spanButtonPlaceholder1"></span>
										<input id="btnCancel1" type="button" value="取消上传" onclick="cancelQueue(upload1);" disabled="disabled" style="margin-left: 2px; height: 22px; font-size: 8pt;" />
										<br />
									</div>
								</div>
							</td>
						</tr>
					</table>
				</form>
			</div>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-12">
				<div id="<%=taskcode%>_jh_process_page"> </div>
			</div>
		</div>
	</div>
</body>
</html>