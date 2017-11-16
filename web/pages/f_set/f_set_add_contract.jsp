<%@page import="com.mingsokj.fitapp.m.FitUser"%>
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
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	FitUser user = (FitUser)SystemUtils.getSessionUser(request, response);
	if (user == null) {
		request.getRequestDispatcher("/").forward(request, response);
	}

	Entity f_store = (Entity) request.getAttribute("f_store");
	boolean hasF_store = f_store != null && f_store.getResultCount() > 0;
	String type = request.getParameter("type");
	if("".equals(type) || "undefined".equals(type)){
		type = "001";
	}
	String gym = user.getViewGym(); 
	String cust_name = user.getCust_name(); 
	 IDB db = new DBM();
	 Connection conn = null;
	 String content = "";
	 try{
		 conn = db.getConnection();
		 Entity en = new EntityImpl("f_contract",conn);
		 en.setValue("gym", gym);
		 en.setValue("cust_name", cust_name);
		 en.setValue("type", type);//默认合同文本
		 int s = en.search();
		 if(s > 0){
			 content = en.getStringValue("content");
		 }else{
			 Entity e = new EntityImpl("f_contract",conn);
			 e.setValue("type", "005");//默认合同文本
			 e.search();
			 content = e.getStringValue("content");
		 }
	 }catch(Exception e){
		 
	 }finally{
		 db.freeConnection(conn);
	 }
%>
<!DOCTYPE HTML>

<html>
<jsp:include page="/public/edit_base.jsp" />
<script type="text/javascript" charset="utf-8"
	src="public/ueditor/ueditor.config.js"></script>
<script type="text/javascript" charset="utf-8"
	src="public/ueditor/ueditor.all.min.js"> </script>
<!--建议手动加在语言，避免在ie下有时因为加载语言失败导致编辑器加载失败-->
<!--这里加载的语言文件会覆盖你在配置项目里添加的语言类型，比如你在配置项目里配置的是英文，这里加载的中文，那最后就是中文-->
<script type="text/javascript" charset="utf-8"
	src="public/ueditor/lang/zh-cn/zh-cn.js"></script>
<style>
.div1 {
	
}
</style>
<head>


<script type="text/javascript" charset="utf-8"
	src="pages/f_set/index.js"></script>
</head>
<body>
	<form class="l-form" id=f_set_add_contract method="post">
		<span>合同类型:</span>
		<%=UI.createSelect("f_contract__type", "CONTRACT_TYPE", type, true, "{'style':'width:100px'}")%>
		<p>选择该合同将要用于何种卡的充值</p>
		<!-- 加载编辑器的容器 -->
		<div id="container" name="content" type="text/plain"></div>
	</form>
	<!-- 实例化编辑器 -->
	<script type="text/javascript">
    <!-- 实例化编辑器 -->
      	 	var ue = UE.getEditor('container',{
      	 		initialFrameWidth :700,//设置编辑器宽度
      	 		initialFrameHeight:350,//设置编辑器高度
      	 		scaleEnabled:true
      	 		
      	 	});
        
           <%-- 	$("#container").text('<%=content%>'); --%>
            //判断ueditor 编辑器是否创建成功
            ue.addListener("ready", function () {
           	 ue.setContent('<%=content%>');

            });
      		/* uParse('#container', {
      		    rootPath: '${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/public/ueditor/'
      		}) */
      		
    </script>
</body>

</html>