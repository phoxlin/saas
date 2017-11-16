<%@page import="com.mingsokj.fitapp.utils.GymUtils"%>
<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	FitUser user=(FitUser)SystemUtils.getSessionUser(request, response);
	if(user==null || !user.hasPower("sm_wxManager")){ request.getRequestDispatcher("/").forward(request, response);}

	String taskcode = "f_mem";
	String taskname = "微信管理";
	String sId = request.getParameter("sid");
	String cust_name = user.getCust_name();
	String gym = user.getViewGym();
	String sql = "select * from f_mem_"+cust_name+" where wx_open_id is not null and gym='"+user.getViewGym()+"'";
	
%>
<!DOCTYPE html>
<html>
<head>
<title><%=taskname%></title>
<script type="text/javascript">
var  f_mem___f_mem_params={sql:"<%=sql %>"};

//data-grid配置开始
///////////////////////////////////////////(1).f_mem___f_mem开始///////////////////////////////////////////
	//搜索配置
	var f_mem___f_mem_filter=[
{"rownum":2,"compare":"like","colnum":1,"label":"姓名","type":"text","columnname":"mem_name"},
{"rownum":2,"compare":"like","colnum":2,"label":"手机号码","type":"text","columnname":"phone"},
{"rownum":2,"compare":"=","colnum":3,"bindType":"codetable","label":"状态","type":"text","columnname":"state","bindData":"PUB_C201"}
				      	 ];
	//编辑页面弹框标题配置
	var f_mem___f_mem_dialog_title='微信管理';
	//编辑页面弹框宽度配置
	var f_mem___f_mem_dialog_width=700;
	//编辑页面弹框高度配置
	var f_mem___f_mem_dialog_height=500;
	//IndexGrid数据加载提示配置
	var f_mem___f_mem_loading=true;
	//编辑页面弹框宽度配置
	var f_mem___f_mem_entity="f_mem";
	//编辑页面路径配置
	var f_mem___f_mem_nextpage="pages/f_mem/f_mem_edit.jsp";
///////////////////////////////////////////(1).f_mem___f_mem结束///////////////////////////////////////////

//data-grid配置结束

</script>
<jsp:include page="/public/base.jsp" />
<script type="text/javascript" charset="utf-8" src="pages/f_mem/index.js"></script>
<script type="text/javascript" charset="utf-8" src="pages/f_mem/f_mem.js"></script>

<script type="text/javascript">
	$(document).ready(function() {
		showTaskView('<%=taskcode%>','<%=sId%>','N');
	});
	function detail(name){
		var id = getValuesByName('id', name);
		var userName = getValuesByName('mem_name', name);
		var sex = getValuesByName('sex', name);
		var gymName = '<%=GymUtils.getGymName(user.getViewGym())%>';
		
// 		function showMemInfo(id, userName, gym, gymName, sex) {
			dialog({
				url : "partial/mem_info.jsp?fk_user_id=" + id + "&fk_user_gym=<%=gym%>" ,
				title : '会员[' + userName + '] - [' + gymName + '] - ' + sex,
				width : 740,
				height : 700
			}).showModal();

// 		}
		
	}
</script>
</head>
<body>
<div class="widget">
		<jsp:include page="/public/header.jsp">
			<jsp:param value="<%=taskname %>" name="view"/>
		</jsp:include> 
		<div class="container-fluid">
			<div class="main main2">
				
				<div class="nav-bar">
					<a href="main.jsp" class="back">
						<p>
							<i class="fa fa-arrow-left"></i> 
							<span>返回主页</span>
						</p>
					</a>
			
					<ul>
						<li>
						
							<a class="cur">
								<p>
									<i class="fa fa-map-marker"></i><span>微信管理</span>
								</p>
							</a>
						</li>
					</ul>
				</div>
			
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