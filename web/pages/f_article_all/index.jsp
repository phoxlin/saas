<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	FitUser user=(FitUser)SystemUtils.getSessionUser(request, response);
	if(user==null ||!user.hasPower("sm_artice")){ request.getRequestDispatcher("/").forward(request, response);}

	String cust_name = user.getCust_name();
	String gym = user.getViewGym();
	String taskcode = "f_article";
	String taskname = "俱乐部动态";
	String sId = request.getParameter("sid");

	String sql = "select * from f_article where cust_name = '-1' and gym = '-1'";
%>
<!DOCTYPE html>
<html>
<head>
<title><%=taskname%></title>
<jsp:include page="/public/base.jsp" />

<script type="text/javascript">
	var f_article___f_article_params={sql:"<%=sql %>"};

//data-grid配置开始
///////////////////////////////////////////(1).f_article___f_article开始///////////////////////////////////////////
	//搜索配置
	<%-- var f_article___f_article_filter=[
	{"rownum":1,"compare":"like","colnum":1,"label":"标题","type":"text","columnname":"title"},
	{"rownum":1,"compare":"=","colnum":1,"label":"类型","type":"text","columnname":"art_type","bindType":"sql","bindData":"select id code,type note from f_generic_type where cust_name ='<%=cust_name%>' and gym = '<%=gym%>' and table_name = 'f_article'"},
	{"rownum":1,"compare":">=","colnum":2,"label":"发布起始(包含)","type":"datetime","columnname":"release_time"},
	{"rownum":1,"compare":"<","colnum":3,"label":"结束时间(不含)","type":"datetime","columnname":"release_time"}
				      	 ]; --%>
	//编辑页面弹框标题配置
	var f_article___f_article_dialog_title='俱乐部动态';
	//编辑页面弹框宽度配置
	var f_article___f_article_dialog_width=700;
	//编辑页面弹框高度配置
	var f_article___f_article_dialog_height=500;
	//IndexGrid数据加载提示配置
	var f_article___f_article_loading=true;
	//编辑页面弹框宽度配置
	var f_article___f_article_entity="f_article";
	//编辑页面路径配置
	var f_article___f_article_nextpage="pages/f_article_all/f_article_edit.jsp";
///////////////////////////////////////////(1).f_article___f_article结束///////////////////////////////////////////
//data-grid配置结束
</script>


<script type="text/javascript" charset="utf-8" src="pages/f_article/index.js"></script>
<script type="text/javascript" charset="utf-8" src="pages/f_article/f_article.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		showTaskView('<%=taskcode%>','<%=sId%>','N');
	});
</script>
</head>
<body>
	<div class="widget">
		<jsp:include page="/public/header.jsp">
			<jsp:param value="<%=taskname %>" name="view"/>
		</jsp:include> 
		<div class="container-fluid">
			<div class="main main2">
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