<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%
   String fk_user_id = request.getParameter("id");
%>
<style type="text/css">
.main.main2 {
	margin: 0 !important;
}
.main.main2 {
	margin: 0 !important;
}

.multi-card {
    background-color: #f2f2f2;
    margin: 0 18px 18px 0;
    height: 160px;
}
</style>
<jsp:include page="/public/base.jsp" />
<link rel="stylesheet" media="all" href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/public/css/bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="public/css/user.css">
</head>
<script type="text/javascript">
 function showBuyCard(){
		top.dialog({
			url : "pages/f_mem/buyCard/buyCard.jsp?cardType=003",
			title : "购买次卡",
			width : 1000,
			height : 750,
			okValue : "确定",
			ok : function() {
				var iframe = $(window.parent.document).contents().find(
						"[name=" + top.dialog.getCurrent().id + "]")[0].contentWindow;
				iframe.buyCard(this, document,window,'<%=fk_user_id%>');
				return false;
			}
		}).showModal();
 }
 $(function() {
		$.ajax({
			type : "POST",
			url : "fit-ws-bg-Mem-getMineCard",
			data : {
				fk_user_id:'<%=fk_user_id%>',
				fk_card_type:"003"
			},
			dataType : "json",
			async : false,
			success : function(data) {
				if (data.rs == "Y") {
					var mineCardTpl = document.getElementById('mineCardTpl').innerHTML;
			        var cmineCardTplHtml = template(mineCardTpl, {
						list : data.data
					});
			       $('#mineCard').html(cmineCardTplHtml);
				} else {
					error(data.rs);
				}

			}
		});
	});
</script>
</head>
<body>

<script type="text/html" id="mineCardTpl">
    <#
      if(list){  
      for(var i = 0;i<list.length;i++){#>
			<div class="col-xs-2 col-md-2 multi-card ">
               <#=list[i].card_name#>
			</div>
    <#}}#>
		<div class="col-xs-2 col-md-2 multi-card " onclick="showBuyCard()">添加新卡
		</div>
  </script>
	<div class="row" id="mineCard">
		
	</div>
	<ul class="nav nav-tabs nav-tabs-custom" role="tablist">
		<li role="presentation" class="active"><a href="#tab1" aria-controls="tab1" role="tab" data-toggle="tab"> <span class="nav-tabs-left"></span> <span class="nav-tabs-text">充值记录</span> <span class="nav-tabs-right"></span>
		</a></li>
	</ul>

	<div class="tab-content" style="height: 400px;">
		<div role="tabpanel" class="tab-pane fade in active" id="tab1">
			<jsp:include page="/pages/f_user_card/index.jsp">
				<jsp:param value="<%=fk_user_id%>" name="fk_user_id" />
				<jsp:param value="003" name="fk_card_type" />
			</jsp:include>
		</div>
	</div>
</body>
</html>