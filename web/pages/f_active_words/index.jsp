<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	User user=SystemUtils.getSessionUser(request, response);
	if(user==null){ request.getRequestDispatcher("/").forward(request, response);}

	String taskcode = "f_active_words";
	String taskname = "活动评价";
	String sId = request.getParameter("sid");
	String act_id = request.getParameter("act_id");
	String sql = "select * from f_active_words" +(act_id ==null ?"": (" where act_id = '"+act_id+"'"));
%>
<!DOCTYPE html>
<html>
<head>
<title><%=taskname%></title>
<jsp:include page="/public/base.jsp" />
<script type="text/javascript">
var  f_active_words___f_active_words_params={sql:"<%=sql %>"};
//data-grid配置开始
///////////////////////////////////////////(1).f_active_words___f_active_words开始///////////////////////////////////////////
	//搜索配置
	var f_active_words___f_active_words_filter=[
{"rownum":2,"compare":">=","colnum":1,"label":"评论时间 从","type":"date","columnname":"create_time"},
{"rownum":2,"compare":"<=","colnum":2,"label":"到","type":"date","columnname":"create_time"}
				      	 ];
	//编辑页面弹框标题配置
	var f_active_words___f_active_words_dialog_title='活动评价';
	//编辑页面弹框宽度配置
	var f_active_words___f_active_words_dialog_width=700;
	//编辑页面弹框高度配置
	var f_active_words___f_active_words_dialog_height=500;
	//IndexGrid数据加载提示配置
	var f_active_words___f_active_words_loading=true;
	//编辑页面弹框宽度配置
	var f_active_words___f_active_words_entity="f_active_words";
	//编辑页面路径配置
	var f_active_words___f_active_words_nextpage="pages/f_active_words/f_active_words_edit.jsp";
///////////////////////////////////////////(1).f_active_words___f_active_words结束///////////////////////////////////////////

//data-grid配置结束

</script>
<script type="text/javascript" charset="utf-8" src="pages/f_active_words/index.js"></script>
<script type="text/javascript" charset="utf-8" src="pages/f_active_words/f_active_words.js"></script>

<script type="text/javascript">
	$(document).ready(function() {
		showTaskView('<%=taskcode%>','<%=sId%>','N');
	});
</script>
</head>
<body>
	<div class="">
		<div class="">
			<div class="main2">
				<div class="row">
					<div class="col-lg-12 col-md-12 col-xs-12">
						<div id="<%=taskcode%>_jh_process_page"> </div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>