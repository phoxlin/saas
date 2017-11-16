<%@page import="com.jinhua.server.log.Logger"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.HashSet"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@page import="com.jinhua.server.db.Entity"%>
<%@page import="com.jinhua.server.tools.UI"%>
<%@page import="com.jinhua.server.tools.UI_Op"%>
<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.server.db.IDB"%>
<%@page import="com.jinhua.server.db.impl.DBM"%>
<%@page import="com.jinhua.server.db.impl.EntityImpl"%>
<%@page import="com.jinhua.server.db.Entity"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.jinhua.User"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	User user = SystemUtils.getSessionUser(request, response);
	if (user == null) {
		request.getRequestDispatcher("/").forward(request, response);
	}

	String taskcode = "f_box";
	String taskname = "箱柜管理";
	String sId = request.getParameter("sid");
%>
<!DOCTYPE html>
<html>
<head>
<title><%=taskname%></title>
<jsp:include page="/public/base.jsp" />
<script type="text/javascript">
	//data-grid配置开始
	///////////////////////////////////////////(1).f_box___f_box开始///////////////////////////////////////////
	//搜索配置
	var f_box___f_box_filter = [];
	//编辑页面弹框标题配置
	var f_box___f_box_dialog_title = '箱柜管理';
	//编辑页面弹框宽度配置
	var f_box___f_box_dialog_width = 700;
	//编辑页面弹框高度配置
	var f_box___f_box_dialog_height = 500;
	//IndexGrid数据加载提示配置
	var f_box___f_box_loading = true;
	//编辑页面弹框宽度配置
	var f_box___f_box_entity = "f_box";
	//编辑页面路径配置
	var f_box___f_box_nextpage = "pages/f_box/f_box_edit.jsp";
	///////////////////////////////////////////(1).f_box___f_box结束///////////////////////////////////////////

	//data-grid配置结束
</script>
<script type="text/javascript" charset="utf-8" src="pages/f_box/index.js"></script>
<script type="text/javascript" charset="utf-8" src="pages/f_box/f_box.js"></script>
</head>
<%
	IDB db = new DBM();
	Connection conn = null;
	String content = "";
	try {
		conn = db.getConnection();
		Entity en = new EntityImpl(conn);
		en.executeQuery("SELECT DISTINCT AREA_NO FROM f_box ");

		/* 	 int size=en.executeQuery("SELECT * FROM f_box");
			 Set<String> area_nos=new HashSet<>();
			 for(int i=0;i<size;i++){
				 String area_no=en.getStringValue("area_no",i);
				 area_nos.add(area_no);
				Logger.info(area_no);
			 }
			 for(String area_no:area_nos){
			 }
			Logger.info(area_nos);
		 *//* 	 Set<String> area_nos=new HashSet<>();
			 
			 for(int i=0;i<size;i++){
				String area_no=en.getStringValue("area_no",i); 
				 area_nos.add(area_no);
				 
			 }
			 
			 
			*/
	} catch (Exception e) {

	} finally {
		db.freeConnection(conn);
	}
%>
<body>
	<div class="widget">
		<jsp:include page="/public/header.jsp">
			<jsp:param value="<%=taskname%>" name="view" />
		</jsp:include>
		<div class="container-fluid">
			<div class="main main2">
				<div class="row" style="background: #F0F0F0">
					<div class="col-md-1 ">
						<button type="button" onclick="adds()" class="btn btn-success">租还柜子</button>
					</div>
					<div class="col-md-1 ">
						<button type="button" onclick="adds()" class="btn btn-success">添加柜子</button>
					</div>
					<div class="col-md-1">
						<button type="button" onclick="adds()" class="btn btn-success">管理柜子</button>
					</div>
				</div>
				<div class="row" style="background: #F0F0F0">
					<div class="col-md-1 ">
						<button type="button" onclick="adds()" class="btn btn-success">租还柜子</button>
					</div>
					<div class="col-md-1 ">
						<button type="button" onclick="adds()" class="btn btn-success">添加柜子</button>
					</div>
					<div class="col-md-1">
						<button type="button" onclick="adds()" class="btn btn-success">管理柜子</button>
					</div>
				</div>
				<%-- 					
					<div class="col-lg-12 col-md-12 col-xs-12">
						<div id="<%=taskcode%>_jh_process_page"> </div>
					</div>
 --%>
			</div>
		</div>
	</div>

	</div>
</body>
</html>