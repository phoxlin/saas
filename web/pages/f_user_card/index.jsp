<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	User user = SystemUtils.getSessionUser(request, response);
	if (user == null) {
		request.getRequestDispatcher("/").forward(request, response);
	}
	String fk_user_id = request.getParameter("fk_user_id");
	String fk_card_type = request.getParameter("fk_card_type");
	String taskcode = "f_user_card";
	String taskname = "买卡";
	String sId = request.getParameter("sid");
	
%>
<!DOCTYPE html>
<html>
<head>
<title><%=taskname%></title>
<jsp:include page="/public/base.jsp" />
<script type="text/javascript">

//data-grid配置开始
///////////////////////////////////////////(1).f_user_card___f_user_card开始///////////////////////////////////////////
	//搜索配置
	var f_user_card___f_user_card_filter=[
				      	 ];
	//编辑页面弹框标题配置
	var f_user_card___f_user_card_dialog_title='f_user_card';
	//编辑页面弹框宽度配置
	var f_user_card___f_user_card_dialog_width=700;
	//编辑页面弹框高度配置
	var f_user_card___f_user_card_dialog_height=500;
	//IndexGrid数据加载提示配置
	var f_user_card___f_user_card_loading=true;
	//编辑页面弹框宽度配置
	var f_user_card___f_user_card_entity="f_user_card";
	//编辑页面路径配置
	var f_user_card___f_user_card_nextpage="pages/f_user_card/f_user_card_edit.jsp";
///////////////////////////////////////////(1).f_user_card___f_user_card结束///////////////////////////////////////////
       <%String sql = "select a.buy_time,a.id,a.card_id,a.deadline,a.emp_id,a.source,a.emp_name,a.active_time,a.remain_times  from f_user_card a,f_card b where a.card_id = b.id and  a.mem_id=? and b.card_type=? order by a.buy_time desc";%>
    	
    var f_user_card___f_user_card_params={sql:"<%=sql%>",sqlPs:['<%=fk_user_id%>','<%=fk_card_type%>']};
//data-grid配置结束

</script>
<script type="text/javascript" charset="utf-8" src="pages/f_user_card/index.js"></script>
<script type="text/javascript" charset="utf-8" src="pages/f_user_card/f_user_card.js"></script>

<script type="text/javascript">
	$(document).ready(function() {
		showTaskView('<%=taskcode%>','<%=sId%>', 'N');
	});
</script>
</head>
<body>
	<div class="container-fluid">
		<div class="main main2">
			<div class="row">
				<div class="col-lg-12 col-md-12 col-xs-12">
					<div id="<%=taskcode%>_jh_process_page"></div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>