<%@page import="com.jinhua.server.db.Entity"%>
<%@page import="com.jinhua.server.tools.UI"%>
<%@page import="com.jinhua.server.tools.UI_Op"%>
<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	User user = SystemUtils.getSessionUser(request, response);
	if (user == null) {
		request.getRequestDispatcher("/").forward(request, response);
	}
%>
<!DOCTYPE HTML>
<html>
<head>
<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<script src="public/sb_admin2/bower_components/jquery/dist/jquery.min.js"></script>
<link type="text/css" href="partial/lessionplan/files/bootstrap.css" rel="stylesheet" media="screen">
<link type="text/css" href="partial/lessionplan/files/panel.css" rel="stylesheet" media="screen">
<link type="text/css" href="partial/lessionplan/files/font-awesome.min.css" rel="stylesheet" media="screen">
<link type="text/css" href="partial/lessionplan/files/Base.css" rel="stylesheet" media="screen">
<link rel="stylesheet" type="text/css" href="public/sb_admin2/bower_components/artDialog7/css/dialog.css">
<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/artDialog7/dialog.js"></script>
<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/artDialog7/dialog-plus.js"></script>
<script type="text/javascript" charset="utf-8" src="public/js/template.js"></script>
<link
	href="public/sb_admin2/bower_components/bootstrap/dist/css/bootstrap.min.css"
	rel="stylesheet" />
<script type="text/javascript" charset="utf-8"
	src="pages/f_box/f_box.js"></script>
	
</head>
<script type="text/javascript">
<!--
template.config({sTag: '<#', eTag: '#>'});
//-->
	$(function(){
		$.ajax({
	        type: 'POST',
	        url: 'fit-action-showBox',
	        dataType: 'json',
	        success: function(data) {
	            if (data.rs == "Y") {
	            	var boxTpl = document.getElementById('boxTpl').innerHTML;
	                var boxHtml = template(boxTpl, {
	                    list: data.list
	                });
	                $('#boxTable').html(boxHtml);
	            } else {
	                error(data.rs);

	            }
	        },
	        error: function(xhr, type) {
	            error("您的网速不给力啊，再来一次吧");
	        }
	    })
		
		
	});
</script>
<body>
	<div class="manageRent">
		<div class="head">
			<button class="btn btn-primary search-btn right-button" name="submit" onclick="adds()">添加柜子</button>
		</div>
		<div style="width: 500px;height: 275px;overflow: auto;margin-top: 10px;">
		<div class="body ctrl table-basic">
			<div class="table-header clearfix" style="display: none;">
				<div class="message"></div>
				<div
					class="pager-outer pager-head clearfix ctrl table-pager pull-right table-pager-input">
					<button class="btn btn-sm btn-first" disabled="disabled">
						<i class="fa fa-arrow-left"></i>
					</button>
					<button class="btn btn-sm btn-prev" disabled="disabled">
						<i class="fa fa-chevron-left"></i>
					</button>
					<span class="current"> <input class="page-index"
						type="number" value="0"> / <strong class="page-count">1</strong>
					</span>
					<button class="btn btn-sm btn-next" disabled="disabled">
						<i class="fa fa-chevron-right"></i>
					</button>
					<button class="btn btn-sm btn-last" disabled="disabled">
						<i class="fa fa-arrow-right"></i>
					</button>
				</div>
			</div>
			<table class="table table-list">
				<thead>
					<tr>
						<th col-key="areaNum"><strong>区域编号</strong></th>
						<th col-key="cabinetCount"><strong>柜子数量</strong></th>
						<th col-key="recordCount"><strong>已出租</strong></th>
						<th col-key="lendCount"><strong>已逾期</strong></th>
						<th col-key="expireTime"><strong>操作</strong></th>
					</tr>
				</thead>
				<tbody id="boxTable">
					
				</tbody>
			</table>
			<div class="table-footer clearfix">
				<div
					class="pager-outer pager-tail clearfix ctrl table-pager pull-right table-pager-input">
					
				</div>
			</div>
		</div>
		</div>
	</div>
<%-- 						<button class="btn btn-sm" name="edit" onclick="showEditBox('<#=list[i].area_no#>')">编辑</button> --%>
	<script type="text/html" id="boxTpl">
                  <# if(list){
                      for(var i = 0;i<list.length;i++){
                  #>
                       <tr item-id="1">
						<td key="areaNum" class="align-center" style="width: 100px;"><#=list[i].area_no#></td>
						<td key="cabinetCount" class="align-center" style="width: 100px;"><#=list[i].box_nums#></td>
						<td key="recordCount" class="align-center" style="width: 100px;"><#=list[i].rent#></td>
						<td key="lendCount" class="align-center" style="width: 100px;"><#=list[i].except#></td>
						<td key="expireTime" class="align-center" style="width: 150px;">
						<button class="btn btn-sm" style="margin-left: 5px;" name="del" onclick="delBox('<#=list[i].area_no#>')">删除</button></td>
					</tr>
                  <# }}#>
            </script>
</body>
</html>