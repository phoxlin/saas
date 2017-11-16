<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html style="height: 95%">
<%
	String userType = request.getParameter("userType");
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<script src="public/sb_admin2/bower_components/jquery/dist/jquery.min.js"></script>
<script src="public/js/store.js"></script>
<link rel="stylesheet" type="text/css" href="public/sb_admin2/bower_components/bootstrap/dist/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="partial/css/choiceEmp.css">
<link rel="stylesheet" type="text/css" href="public/fit/css/btn.css">
<script type="text/javascript" src="partial/js/cashier.js"></script>
<script type="text/javascript" charset="utf-8" src="public/js/template.js"></script>
<title>选择员工</title>
<script type="text/javascript">
<!--
template.config({sTag: '<#', eTag: '#>'});
//-->

	$(function() {
		 $.ajax({
	        type: "POST",
	        url: "fit-ws-bg-emp-searchEmpByType",
	        data: {
	        	type:'<%=userType%>'
	        },
	        dataType: "json",
	        async: false,
	        success: function(data) {
	            if (data.rs == "Y") {
	                var partialBuyCard_empsTpl = document.getElementById('partialBuyCard_empsTpl').innerHTML;
	                var partialBuyCard_empsTplHtml = template(partialBuyCard_empsTpl, {
	                    list: data.emps
	                });
	                $('#empsDiv').html(partialBuyCard_empsTplHtml);
	                
	                $('#empsDiv li').each(function() {
	                    $(this).click(function() {
                            $('#empsDiv li').removeClass("checked");
                            $(this).addClass('checked');
	                    });
	                });
	            } else {
	                error(data.rs);
	            }

	        }
	    });
	});
	function saveId(win){
		var fk_emp_id = $(".checked").attr("attr-id");
		var fk_emp_name = $(".checked").text();
		var data = {};
		data["id"]= fk_emp_id;
		data["name"]= fk_emp_name;
	    store.set('<%=userType%>',data);
	    win.close();
	}
	function searchEmp(){
		var search = $("#searchVal").val();
		$.ajax({
	        type: "POST",
	        url: "fit-ws-bg-emp-searchEmpByType",
	        data: {
	        	type:'<%=userType%>',
	        	search : search
	        },
	        dataType: "json",
	        async: false,
	        success: function(data) {
	            if (data.rs == "Y") {
	                var partialBuyCard_empsTpl = document.getElementById('partialBuyCard_empsTpl').innerHTML;
	                var partialBuyCard_empsTplHtml = template(partialBuyCard_empsTpl, {
	                    list: data.emps
	                });
	                $('#empsDiv').html(partialBuyCard_empsTplHtml);
	                
	                $('#empsDiv li').each(function() {
	                    $(this).click(function() {
                            $('#empsDiv li').removeClass("checked");
                            $(this).addClass('checked');
	                    });
	                });
	            } else {
	                error(data.rs);
	            }

	        }
	    });
	}
</script>
</head>
<body style="height: 550px;padding: 20px;">
	<div style="height: 95%;">
		<div class="row">
			<div class="col-xs-6">
				<input type="text" id="searchVal" class="form-control" style="display: inline-block;width: 70%;padding: 4px 10px;vertical-align: middle;" placeholder="搜索员工姓名/手机"/> 
				<button class="btn btn-green" type="button" onclick="searchEmp()">搜索</button>
			</div>
		</div>
		<div style="width: 788px;height: 500px;overflow: auto;">
			<ul class="emp-list" id="empsDiv">
			</ul>
			<script type="text/html" id="partialBuyCard_empsTpl">
                  <# if(list){
                      for(var i = 0;i<list.length;i++){
                  #>
                        <li attr-id="<#=list[i].id#>">
							<i></i>
							<span><#=list[i].name#></span>
						</li>
                  <# }}#>
            </script>
		</div>
	</div>
</body>
</html>