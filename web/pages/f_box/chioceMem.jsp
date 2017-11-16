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
<script type="text/javascript" src="public/sb_admin2/bower_components/bootstrap/dist/js/bootstrap.min.js"></script>
<link rel="stylesheet" type="text/css" href="partial/css/choiceEmp.css">
<link rel="stylesheet" type="text/css" href="public/fit/css/btn.css">
<link rel="stylesheet" media="all" href="partial/css/cashier.css" />
<link rel="stylesheet" media="all" href="public/fit/css/btn.css" />
<link rel="stylesheet" type="text/css" href="public/fit/css/pager.css">
<link href="public/fit/css/font-awesome.min.css" rel="stylesheet">
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
	                    list2: data.emps,
	                    list : data
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
	function searchMem(){
		var mem_name = $("#mem_name").val();
		var phone = $("#phone").val();
		var mem_no = $("#mem_no").val();
		$.ajax({
			type: "POST",
			url: "fit-ws-bg-emp-searchMem",
			data:{
				mem_name : mem_name,
				phone : phone,
				mem_no : mem_no
				
			},
			dataType: "json",
			success: function(data) {
				if (data.rs == "Y") {
	                var partialBuyCard_empsTpl = document.getElementById('partialBuyCard_empsTpl').innerHTML;
	                var partialBuyCard_empsTplHtml = template(partialBuyCard_empsTpl, {
	                    list2: data.emps,
	                    list : data
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
	//分页查询
	function searchJpage (cur){
		$.ajax({
	        type: "POST",
	        url: "fit-ws-bg-emp-searchEmpByType",
	        data: {
	        	type:'<%=userType%>',
	        	cur : cur
	        },
	        dataType: "json",
	        async: false,
	        success: function(data) {
	            if (data.rs == "Y") {
	                var partialBuyCard_empsTpl = document.getElementById('partialBuyCard_empsTpl').innerHTML;
	                var partialBuyCard_empsTplHtml = template(partialBuyCard_empsTpl, {
	                    list2: data.emps,
	                    list : data
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
		<p class="help-block">由于会员过多，请选择搜索添加会员</p>
			<div class="col-xs-3">
				<input type="text" id="mem_name" name="mem_name" class="form-control" style="display: inline-block;width: 70%;padding: 4px 10px;vertical-align: middle;" placeholder="姓名"/> 
			</div>
			<div class="col-xs-3">
				<input type="text" id="phone" name="phone" class="form-control" style="display: inline-block;width: 70%;padding: 4px 10px;vertical-align: middle;" placeholder="手机号"/> 
			</div>
			<div class="col-xs-3">
				<input type="text" id="mem_no" name="mem_no" class="form-control" style="display: inline-block;width: 70%;padding: 4px 10px;vertical-align: middle;" placeholder="会员卡"/> 
			</div>
			<div class="col-xs-3">
				<button class="btn btn-green" type="button" onclick="searchMem()">搜索</button> 
			</div>
				
		</div>
		<div style="width: 788px;height: 700px;overflow: auto;">
			
			<ul class="emp-list" id="empsDiv">
			
			</ul>
			<script type="text/html" id="partialBuyCard_empsTpl">
                  <# if(list2){
                      for(var i = 0;i<list2.length;i++){
                  #>
                        <li attr-id="<#=list2[i].id#>">
							<i></i>
							<span><#=list2[i].name#></span>
						</li>
                  <# }}#>

<#if(list.total !=undefined){#>
<div class="pager">
		<div>总数<#=list.total#>&nbsp;当前页条数<#=list.curSize#></div>
		<div>
			<#
				var cur = list.curPage;
				if(parseInt(cur) > parseInt(list.totalPage)){
					cur = list.totalPage
				}					
				if(list.curPage > 1){
					var pre = list.curPage - 1;
			#>
				<a href="javascript: void(0);" onclick="searchJpage(1);"> 
					<i style="margin-right: -4px;">|</i> 
					<span class="fa fa-angle-left"></span>
				</a> 

				<a href="javascript: void(0);" onclick="searchJpage(<#=pre#>);"> 
					<span class="fa fa-angle-left"></span>
				</a> 
			<#		
				} else {
			#>
				<a class="disabled" href="javascript: void(0);"> 
					<i style="margin-right: -4px;">|</i> 
					<span class="fa fa-angle-left"></span>
				</a>
				<a class="disabled" href="javascript: void(0);"> 
					<span class="fa fa-angle-left"></span>
				</a> 
			<#		
				}
			#>
			<input onkeyup="searchJpage(this.value)" value="<#=cur#>" type="number" style="max-width: 55px; padding: 0 5px; height: 23px; margin: 0 5px 0 10px;">/<#=list.totalPage#>&nbsp;&nbsp; 
			
			<#
				if(parseInt(cur) < list.totalPage){
					var next = list.curPage + 1;						
			#>
				<a href="javascript: void(0)" onclick="searchJpage(<#=next#>)"> 
					<span class="fa fa-angle-right"></span>
				</a> 
				<a href="javascript: void(0)" onclick="searchJpage(<#=list.totalPage#>)"> 
					<span class="fa fa-angle-right"></span> <i style="margin-left: -4px;">|</i>
				</a>
			<#
				} else {
			#>
				<a class=""> 
					<span class="fa fa-angle-right"></span>
				</a> 
				<a class=""> 
					<span class="fa fa-angle-right"></span> <i style="margin-left: -4px;">|</i>
				</a>
			<#		
				}
			#>
		</div>
	</div>
<#}#>
            </script>
		</div>
	</div>
	<div id="holder">
    					</div>
</body>
</html>