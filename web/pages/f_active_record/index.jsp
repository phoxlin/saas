<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	FitUser user=(FitUser)SystemUtils.getSessionUser(request, response);
	if(user==null){ request.getRequestDispatcher("/").forward(request, response);}
	String cust_name = user.getCust_name();
	String gym = user.getViewGym();

	String taskcode = "f_active_record";
	String taskname = "活动参与记录";
	String sId = request.getParameter("sid");
	String sql = "select a.* from f_active_record_"+cust_name+" a,f_active b where a.act_id = b.id and a.gym = '"+gym+"'";

%>
<!DOCTYPE html>
<html>
<head>
<title><%=taskname%></title>
<jsp:include page="/public/base.jsp" />
<script type="text/javascript">
var  f_active_record___f_active_record_params={sql:"<%=sql %>"};

//data-grid配置开始
///////////////////////////////////////////(1).f_active_record___f_active_record开始///////////////////////////////////////////
	//搜索配置
	var f_active_record___f_active_record_filter=[
		{"rownum":2,"compare":"like","colnum":1,"label":"活动名称","type":"text","columnname":"title"},
		{"rownum":2,"compare":"=","colnum":1,"bindType":"codetable","bindData":"ACTIVE_TYPE_YN","label":"活动分类","type":"text","columnname":"for_mem"},
{"rownum":2,"compare":"=","colnum":1,"bindType":"sql","label":"请选择活动","type":"text","columnname":"act_id","bindData":"select id code,title note from f_active where cust_name = '<%=cust_name%>' and gym ='<%=gym%>'"}
				      	 ];
	//编辑页面弹框标题配置
	var f_active_record___f_active_record_dialog_title='活动参与记录';
	//编辑页面弹框宽度配置
	var f_active_record___f_active_record_dialog_width=700;
	//编辑页面弹框高度配置
	var f_active_record___f_active_record_dialog_height=500;
	//IndexGrid数据加载提示配置
	var f_active_record___f_active_record_loading=true;
	//编辑页面弹框宽度配置
	var f_active_record___f_active_record_entity="f_active_record";
	//编辑页面路径配置
	var f_active_record___f_active_record_nextpage="pages/f_active_record/f_active_record_edit.jsp";
///////////////////////////////////////////(1).f_active_record___f_active_record结束///////////////////////////////////////////

//data-grid配置结束

</script>
<script type="text/javascript" charset="utf-8" src="pages/f_active_record/index.js"></script>
<script type="text/javascript" charset="utf-8" src="pages/f_active_record/f_active_record.js"></script>

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