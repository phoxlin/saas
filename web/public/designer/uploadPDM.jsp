<%@page import="com.jinhua.server.tools.UI"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
%>

<!DOCTYPE HTML>
<html>
<head>
<jsp:include page="/public/base.jsp" />
<script type="text/javascript">
	var form_id = "uploadFormObj";
	function importPDMFile(obj,doc){
		$('#' + form_id).form('submit',	{
					url : "db-importPDMFile",
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
							if(confirm('导入成功，关闭窗口')){
								obj.close();
							}
						} else {
							error(result);
						}
					}
				});
	}
	
</script>
</head>
<body>
	  <form class="l-form" id="uploadFormObj" method="post">
	    <ul style="margin-top: 40px;">
	      <li style="width: 150px; text-align: left;display: inline-block;">数据库建模文件(*)：</li>
	      <li style="width: 190px; text-align: left;display: inline-block;">
	        <div class="l-text" style="width: 188px;">
	          <%=UI.createUploadQiNiuFile("upload_pdm", "", true, "pdm", 1,false,request.getParameter("type")) %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	  </form>
  	</body>
  </html>