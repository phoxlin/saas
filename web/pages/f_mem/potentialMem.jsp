<%@page import="com.mingsokj.fitapp.utils.GymUtils"%>
<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
	if (user == null) {
		request.getRequestDispatcher("/").forward(request, response);
	}

	String taskcode = "f_mem_potential";
	String taskname = "会员管理";
	String sId = request.getParameter("sid");
	String cust_name = user.getCust_name();
	String gym = user.getViewGym();
	String f_mem_potential_sql = "SELECT a.* FROM f_mem_"+cust_name+" a LEFT JOIN f_user_card_"+gym+" b ON b.mem_id = a.id  where (a.state='004' or a.state='003')  GROUP BY a.id ";

%>
<!DOCTYPE html>
<html>
<head>
<title><%=taskname%></title>
<script type="text/javascript">
var f_mem_potential___f_mem_params={sql:"<%=f_mem_potential_sql%>"};
//搜索配置
var f_mem_potential___f_mem_filter=[
{"rownum":2,"compare":"like","colnum":1,"label":"会员姓名","type":"text","columnname":"mem_name"},
{"rownum":2,"compare":"like","colnum":2,"label":"手机号码","type":"text","columnname":"phone"},
{"rownum":2,"compare":"like","colnum":2,"label":"会员卡号","type":"text","columnname":"mem_no"},
{"rownum":2,"compare":"=","colnum":3,"bindType":"codetable","label":"性别","type":"text","columnname":"sex","bindData":"PUB_C919"},
{"rownum":2,"compare":"=","colnum":3,"bindType":"codetable","label":"状态","type":"text","columnname":"state","bindData":"user_state"}
];

//data-grid配置开始
///////////////////////////////////////////(1).f_mem_potential___f_mem_potential开始///////////////////////////////////////////
	//搜索配置
	//编辑页面弹框标题配置
	var f_mem_potential___f_mem_dialog_title='会员管理';
	//编辑页面弹框宽度配置
	var f_mem_potential___f_mem_dialog_width=700;
	//编辑页面弹框高度配置
	var f_mem_potential___f_mem_dialog_height=500;
	//IndexGrid数据加载提示配置
	var f_mem_potential___f_mem_loading=true;
	//编辑页面弹框宽度配置
	var f_mem_potential___f_mem_entity="f_mem";
	//编辑页面路径配置
	var f_mem_potential___f_mem_nextpage="pages/f_mem/f_mem_edit.jsp";
///////////////////////////////////////////(1).f_mem_potential___f_mem_potential结束///////////////////////////////////////////

//data-grid配置结束

</script>
<script type="text/javascript" charset="utf-8" src="pages/f_mem/index.js"></script>
<script type="text/javascript" charset="utf-8" src="pages/f_mem/f_mem.js"></script>

<script type="text/javascript">
	$(document).ready(function() {
		showTaskView('<%=taskcode%>','<%=sId%>','N');
		 $(document).on("click", ".state-blocks .col-md-2",
				    function(e) {
				        var dataType = ""
				        var tag = e.target;
				        if (tag.className.indexOf("icon-calendar") < 0) {
				            $(this).parent(".state-blocks").children(".state-blocks .col-md-2").removeClass("active");
				            $(this).addClass("active");
				            dataType = $(this).attr("data-type");
				        }
				        if ("无人跟进" == dataType) {
				        	f_mem_potential___f_mem_params = {
				                sql: "SELECT a.* FROM f_mem_<%=cust_name%> a   where (a.state='004' or a.state='003') and a.gym=? and  (ISNULL(a.mc_id) or a.mc_id='')   GROUP BY a.id ",
				                sqlPs: ['<%=user.getViewGym()%>']
				            };
				            window.localStorage.setItem("leftParams", JSON.stringify(f_mem_potential___f_mem_params));
				            cq('f_mem_potential___f_mem', 'task', f_mem_potential___f_mem_params);
				        }
				        if ("最近添加" == dataType) {
				        	f_mem_potential___f_mem_params = {
				        			sql: "SELECT a.* FROM f_mem_<%=cust_name%> a   where (a.state='004' or a.state='003') and a.gym=? and  (ISNULL(a.mc_id) or a.mc_id='')   GROUP BY a.id order by create_time desc ",
					                sqlPs: ['<%=user.getViewGym()%>']
				            };
				            window.localStorage.setItem("leftParams", JSON.stringify(f_mem_potential___f_mem_params));
				            cq('f_mem_potential___f_mem', 'task', f_mem_potential___f_mem_params);
				        }
				    });
	});
	function detail(name){
		var id = getValuesByName('id', name);
		var userName = getValuesByName('mem_name', name);
		var sex = getValuesByName('sex', name);
		var gymName = '<%=GymUtils.getGymName(user.getViewGym())%>';
			dialog({
				url : "partial/mem_info.jsp?fk_user_id=" + id + "&fk_user_gym=<%=gym%>",
					title : '会员[' + userName + '] - [' + gymName + '] - ' + sex,
					width : 740,
					height : 700
				}).showModal();
	    }
	
</script>
<head>
<body>
	<div class="row state-blocks" style="border-bottom: 0px;">
		<div data-name="show-model-type1" class="col-md-2" data-type="无人跟进">
			<div class="s2">
				<div>无人跟进</div>
				<div class="icon icon-3-2" data-flag="value" style="padding-left: 40px;"></div>
				<span class="selected"></span>
			</div>
		</div>
		<div data-name="show-model-type1" class="col-md-2" data-type="最近添加">
			<div class="s4">
				<div>最近添加</div>
				<div data-flag="value" style="height: 30px"></div>
				<span class="selected"></span>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-lg-12 col-md-12 col-xs-12">
			<div id="<%=taskcode%>_jh_process_page"></div>
		</div>
	</div>
</body>
</html>