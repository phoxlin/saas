<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html style="height: 95%">
<%
	String gym = request.getParameter("gym");
	String isEmp = request.getParameter("isEmp");
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<script src="public/sb_admin2/bower_components/jquery/dist/jquery.min.js"></script>
<script src="public/js/store.js"></script>
<link href="public/fit/css/font-awesome.min.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="public/sb_admin2/bower_components/bootstrap/dist/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="partial/css/choiceEmp.css">
<link rel="stylesheet" type="text/css" href="public/fit/css/btn.css">
<link rel="stylesheet" type="text/css" href="public/fit/css/pager.css">
<script type="text/javascript" charset="utf-8" src="public/js/template.js"></script>
<style type="text/css">

.table>tbody>tr>td, .table>tbody>tr>th, .table>tfoot>tr>td, .table>tfoot>tr>th, .table>thead>tr>td, .table>thead>tr>th{
    padding: 5px;
}
.pager>div{
    padding:0;
}
.table{
    margin-bottom: 0px;
    }
</style>
<title>选择员工</title>

<script type="text/javascript">
<!--
template.config({sTag: '<#', eTag: '#>'});
//-->

	$(function() {
		searchMem();
		});
	
	function choiceRadio(){
		$(".choiceTr").click(function(){
			$(this).children().children().prop("checked", "checked");;
		});
		
	}
	function saveId(win){
		var fk_emp_id = $(".checked").attr("attr-id");
		var fk_emp_name = $(".checked").text();
		var data = {};
		data["id"]= fk_emp_id;
		data["name"]= fk_emp_name;
	    store.set('<%=gym%>',data);
	    win.close();
	}
	function searchMem(cur){
		var mem_name = $("#mem_name").val();
		var mem_phone = $("#mem_phone").val();
		var mem_no = $("#mem_no").val();
		var par={"mem_name":mem_name,"phone":mem_phone,mem_no:mem_no};
		 $.ajax({
	 	        type: "POST",
	 	        url: "fit-ws-bg-mem-searchMemByGym",
	 	        data: {
					isEmp:'<%=isEmp == null ?"":isEmp%>',	 	        	
		        	gym:'<%=gym%>',
						par : JSON.stringify(par),
						cur : cur
					},
					dataType : "json",
					async : false,
					success : function(data) {
						if (data.rs == "Y") {
							var partialBuyCard_empsTpl = document
									.getElementById('partialBuyCard_empsTpl').innerHTML;
							var partialBuyCard_empsTplHtml = template(
									partialBuyCard_empsTpl, {
										list : data.mem,
										curPage:data.curPage,
										curSize:data.curSize,
										totalPage:data.totalPage,
										total:data.total
									});
							$('#empsDiv').html(partialBuyCard_empsTplHtml);

							$('#empsDiv li').each(function() {
								$(this).click(function() {
									$('#empsDiv li').removeClass("checked");
									$(this).addClass('checked');
								});
							});
						} else {
							alert(data.rs);
						}

					}
				});
	}
	function saveId(win){
	var xx = $(" input[type='radio']:checked ").val();
	var data = {};
	data["id"]= xx.split("_")[0];
	data["name"]=  xx.split("_")[1];
    store.set('mem',data);
    win.close();
	}
	
</script>
</head>
<body style="height: 550px; padding: 5px;">
	<div style="height: 95%;">
		<div class="row">
			<div class="col-xs-3">
				<input type="text" id="mem_name" class="form-control" style="display: inline-block; width: 70%; padding: 4px 10px; vertical-align: middle;" placeholder="会员姓名" />
			</div>
			<div class="col-xs-3">
				<input type="text" id="mem_phone" class="form-control" style="display: inline-block; width: 70%; padding: 4px 10px; vertical-align: middle;" placeholder="会员手机号" />
			</div>
			<div class="col-xs-3">
				<input type="text" id="mem_no" class="form-control" style="display: inline-block; width: 70%; padding: 4px 10px; vertical-align: middle;" placeholder="会员卡号" />
			</div>
			<div class="col-xs-3">
				<button class="btn btn-green" type="button" onclick="searchMem()">搜索</button>
			</div>
		</div>
		<div>
			<div id="empsDiv"></div>
			<script type="text/html" id="partialBuyCard_empsTpl">
			<table class="table table-list">
				<thead>
					<tr>
						<th style="    padding: 5px;"></th>
						<th style="    padding: 5px;">姓名</th>
						<th style="    padding: 5px;">手机号</th>
						<th style="    padding: 5px;">会员卡号</th>
					</tr>
				</thead>
				<tbody >
                  <# if(list){
                      for(var i = 0;i<list.length;i++){
                  #>
                       <tr class="choiceTr" onclick="choiceRadio()">
						<td ><input type="radio" name="mem" id="<#=list[i].id#>radio" value="<#=list[i].id+"_"+list[i].name#>" /></td>
						<td><span  onclick="$('#<#=list[i].id#>radio').click();"><#=list[i].name#></span></td>
						<td><span  onclick="$('#<#=list[i].id#>radio').click();"><#=list[i].phone#></span></td>
						<td><span  onclick="$('#<#=list[i].id#>radio').click();"><#=list[i].mem_no || ""#></span></td>
					</tr>
                  <# }}#>
	</tbody>
			</table>
                  <div class="pager">
		<div>总数<#=total#>&nbsp;当前页条数<#=curSize#></div>
		<div>
			<#
				var cur = curPage;
				if(parseInt(cur) > parseInt(totalPage)){
					cur = totalPage
				}					
				if(curPage > 1){
					var pre = curPage - 1;
			#>
				<a href="javascript: void(0);" onclick="searchMem(1);"> 
					<i style="margin-right: -4px;">|</i> 
					<span class="fa fa-angle-left"></span>
				</a> 

				<a href="javascript: void(0);" onclick="searchMem(<#=pre#>);"> 
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
			<input onkeyup="searchMem(this.value)" value="<#=cur#>" type="number" style="max-width: 55px; padding: 0 5px; height: 23px; margin: 0 5px 0 10px;">/<#=totalPage#>&nbsp;&nbsp; 
			
			<#
				if(parseInt(cur) < totalPage){
					var next = curPage + 1;						
			#>
				<a href="javascript: void(0)" onclick="searchMem(<#=next#>)"> 
					<span class="fa fa-angle-right"></span>
				</a> 
				<a href="javascript: void(0)" onclick="searchMem(<#=totalPage#>)"> 
					<span class="fa fa-angle-right"></span> <i style="margin-left: -4px;">|</i>
				</a>
			<#
				} else {
			#>
				<a class="disabled"> 
					<span class="fa fa-angle-right"></span>
				</a> 
				<a class="disabled"> 
					<span class="fa fa-angle-right"></span> <i style="margin-left: -4px;">|</i>
				</a>
			<#		
				}
			#>
		</div>
	</div>
            </script>
		</div>
	</div>
</body>
</html>