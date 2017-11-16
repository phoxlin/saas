<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="com.jinhua.server.log.JhLog"%>
<%@page import="com.mingsokj.fitapp.ws.dx.YepaoDX"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.jinhua.server.log.Logger"%>
<%@page import="com.jinhua.server.db.impl.EntityImpl"%>
<%@page import="com.jinhua.server.db.Entity"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.jinhua.enuts.DBType"%>
<%@page import="com.jinhua.server.db.impl.DBM"%>
<%@page import="com.jinhua.server.db.IDB"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//从也跑系统导出健身房所有基本信息
	//1.门店信息，2.员工信息，3，卡种信息 4.会员信息。5.会员卡信息
	String cust_name = request.getParameter("c");
	IDB yepaoDB = null;
	Connection yepaoConn = null;
	IDB db = new DBM();
	Connection conn = null;
	JhLog L = new JhLog();
	boolean ok = false;
	try {
		//yepaoDB = new DBM(DBType.Mysql, "139.129.97.193", 3306, "yepao", "yepao", "123456", 1, 5);
		yepaoDB = new DBM(DBType.Mysql, "192.168.2.210", 3306, "goodfeeling_new", "root", "root", 1, 5);
		yepaoConn = yepaoDB.getConnection();
		conn = db.getConnection();

		YepaoDX dx = new YepaoDX(cust_name, conn, yepaoConn, L);
		dx.process();
		conn.commit();
		ok = true;
	} catch (Exception e) {
		L.error(e);
	} finally {
		if (yepaoDB != null) {
			yepaoDB.freeConnection(yepaoConn);
		}
		db.freeConnection(conn);
	}
%>
<body>
	<%=ok ? "转换成功" : "转换失败"%>
	<br />
	<%=Utils.getListString(L.getLogs(), "<br/>")%>
</body>