<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.db.Entity"%>
<%@page import="com.jinhua.server.tools.UI"%>
<%@page import="com.jinhua.server.tools.UI_Op"%>
<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@page import="java.util.Date"%>
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
	FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
	if (user == null) {
		request.getRequestDispatcher("/").forward(request, response);
	}
	String give_card = request.getParameter("give_card");
	String type = request.getParameter("type");
	String buy_id = request.getParameter("buy_id");
	String mem_gym = request.getParameter("mem_gym");
	String test = (String) request.getAttribute("msg");
	String searchType = request.getParameter("type");
	if ("001".equals(type)) {
		type = "时间卡";
	} else if ("002".equals(type)) {
		type = "储值卡";
	} else if ("003".equals(type)) {
		type = "次卡";
	} else if ("006".equals(type)) {
		type = "私教卡";
	}
	String gym = user.getViewGym();
	String cust_name = user.getCust_name();
	IDB db = new DBM();
	Connection conn = null;
	String content = "";
	try {
		conn = db.getConnection();
		Entity en = new EntityImpl("f_contract", conn);
		en.setValue("gym", gym);
		en.setValue("cust_name", cust_name);
		en.setValue("type", searchType);//默认合同文本
		int s = en.search();
		if (s > 0) {
			content = en.getStringValue("content");
		}
	} catch (Exception e) {

	} finally {
		db.freeConnection(conn);
	}
%>
<!DOCTYPE HTML>
<html>
<title><%=type+"合同打印"%></title>
<jsp:include page="/public/base.jsp" />
<link rel="stylesheet" media="all"
	href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/public/css/bootstrap.min.css" />
<style>
.div1{
	width: 100%;
    background-color: #F6F6F6;
    border: solid 1px #BEBEBE;
    margin-top: 20px;
    font-size: 20px;
}
.div1 div{
	margin-top: 20px;
}
h3{
	margin-left: 6px;
}
.qianzi{
	width: 100%;
    margin-top: 40px;
    font-size: 20px;
}
.qianzi div{
	margin-top: 20px;
}

</style>
<head>
<jsp:include page="/public/edit_base.jsp" />

<script type="text/javascript" charset="utf-8"
	src="pages/f_set/index.js"></script>
</head>
<body>
	<button class="btn btn-success" onclick="printContract()" id="btn1">打印</button>
	<div class="text-wb" style="line-height: 1; margin-left: 20px;"
		id="okPrint">
		<%
			if ("".equals(content)) {
		%>
		<h1>未设置合同</h1>
		<%
			} else {
		%><%=content%>
		<%
			}
		%>
		<div class="usermsg">
			<h3>会员信息</h3>
				<div id="memMsg" class="div1 row">
				
				</div>
			
			<h3>购卡信息</h3>
				<div id="cardMsg" class="div1 row" style="background-size:cover;">
				
				</div>

			<h3>合同信息</h3>
			<div class="div1 row" style="height: 60px;">
			<div class='col-xs-6' >合同号:<span id="contract_no"></span></div>
			<div class='col-xs-6' >制作人:<span id="user_name"></span></div>

			</div>
		</div>
		<div class="qianzi row">
			<div class='col-xs-6' >公司盖章:</div>
			<div class='col-xs-6' >会员签署:</div>
			<div class='col-xs-6' >签署日期:</div>
			<div class='col-xs-6' >签署日期:</div>
		</div>
	</div>
</body>
<script type="text/javascript">
	//用于获取打印合同需要的参数
	$(function() {
		$.ajax({
			type : "POST",
			url : "fit-action-gym-getPrintMsg-2",
			data : {
				buy_id : "<%=buy_id%>",
				mem_gym : "<%=mem_gym%>",
				type : '<%=searchType%>',
				give_card : '<%=give_card%>'
			},
			dataType : "json",
			async : false,
			success : function(data) {
				if (data.rs == "Y") {
					var printCardMsg = data.sbCard;
					var printMemMsg = data.sbMem;
					$("#cardMsg").html(printCardMsg);
					$("#memMsg").html(printMemMsg);
					$("#contract_no").html(data.contractNo);
					$("#user_name").html(data.userName);
				} else {
					error(data.rs);
				}

			}

		});

	});

	function printContract() {
		var head = "<html><head><title></title></head><body>";//先生成头部
		var foot = "</body></html>";//生成尾部
		var newstr = document.all.item("okPrint").innerHTML;//获取指定打印区域
		var oldstr = document.body.innerHTML;//获得原本页面的代码
		document.body.innerHTML = head + newstr + foot;//购建新的网页
		window.print();//打印刚才新建的网页
		document.body.innerHTML = oldstr;//将网页还原
		return false;
	}
	//日期格式修改
	function changeDate(str){
		var date = str.substring(0,4)+"年";
		date +=str.substring(5,7)+"月";
		date +=str.substring(8,10)+"日";
		return date;
		
	}
</script>
</html>
