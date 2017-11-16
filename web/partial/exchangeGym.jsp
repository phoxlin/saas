<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.jinhua.server.db.Entity"%>
<%@page import="com.jinhua.server.tools.UI"%>
<%@page import="com.jinhua.server.tools.UI_Op"%>
<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	User user = SystemUtils.getSessionUser(request, response);
	if (user == null) {
		request.getRequestDispatcher("/").forward(request, response);
	}
	List<Map<String,Object>> list = (List<Map<String,Object>>)request.getAttribute("gyms");
%>
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<script src="public/sb_admin2/bower_components/jquery/dist/jquery.min.js"></script>
<link rel="stylesheet" type="text/css" href="public/sb_admin2/bower_components/bootstrap/dist/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="partial/css/choiceEmp.css">
<link rel="stylesheet" type="text/css" href="public/fit/css/btn.css">
<script type="text/javascript" charset="utf-8" src="public/js/template.js"></script>
<jsp:include page="/public/edit_base.jsp" />
</head>
<body>
<body style="height: 95%;padding: 20px;">
	<div style="height: 95%;">
		<!-- <div class="row">
			<div class="col-xs-6">
				<input type="text" class="form-control" style="display: inline-block;width: 70%;padding: 4px 10px;vertical-align: middle;" placeholder="姓名"/> 
				<button class="btn btn-green" type="button">搜索</button>
			</div>
		</div> -->
		<div>
			<ul class="emp-list" id="gymDiv">
				<%for(int i=0;i<list.size();i++){
					Map<String,Object> gym = list.get(i);
				%>
				 	<li gym="<%=gym.get("gym") %>">
						<i></i>
						<span><%=gym.get("gym_name") %></span>
					</li>
				<%} %>
			</ul>
		</div>
	</div>
</body>
<script type="text/javascript">
$('#gymDiv li').each(function() {
    $(this).click(function() {
        $('#gymDiv li').removeClass("checked");
        $(this).addClass('checked');
    });
});
function changeGym(){
	var gym = $('#gymDiv li.checked').attr("gym");
	if(!gym || gym =='undefined'){
		error("请先选择俱乐部");
		return;
	}
	$.ajax({
		url:"fit-exchange-gym",
		type:"POST",
		dataType:"JSON",
		async:false,
		data:{gym:gym},
		success:function(data){
			if(data.rs == "Y"){
				window.parent.location.reload();
			}else{
				error(data.rs);
			}
		}
	});
}
</script>
</html>