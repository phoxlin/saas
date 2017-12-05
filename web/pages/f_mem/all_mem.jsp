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

	String taskcode = "f_mem";
	String taskname = "会员管理";
	String sId = request.getParameter("sid");
	String cust_name = user.getCust_name();
	String gym = user.getViewGym();
%>
<!DOCTYPE html>
<html>
<head>
<title><%=taskname%></title>
<script type="text/javascript">
var  f_mem___f_mem_params = {
        sql: "select * from f_mem_<%=cust_name%> where id in (select id from f_mem_<%=cust_name%> a where a.gym=? union all select a.id from f_mem_<%=cust_name%> a,f_user_card_<%=gym%> b where a.id=b.mem_id)",
        sqlPs: ['<%=gym%>']
    };
//搜索配置
var f_mem___f_mem_filter=[
{"rownum":2,"compare":"like","colnum":1,"label":"会员姓名","type":"text","columnname":"mem_name"},
{"rownum":2,"compare":"like","colnum":2,"label":"手机号码","type":"text","columnname":"phone"},
{"rownum":2,"compare":"like","colnum":2,"label":"会员卡号","type":"text","columnname":"mem_no"},
{"rownum":2,"compare":"=","colnum":3,"bindType":"codetable","label":"性别","type":"text","columnname":"sex","bindData":"PUB_C919"},
{"rownum":2,"compare":"=","colnum":3,"bindType":"codetable","label":"状态","type":"text","columnname":"state","bindData":"user_state"}
];

//data-grid配置开始
///////////////////////////////////////////(1).f_mem___f_mem开始///////////////////////////////////////////
	//搜索配置
	//编辑页面弹框标题配置
	var f_mem___f_mem_dialog_title='会员管理';
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
<script type="text/javascript" charset="utf-8" src="pages/f_mem/index.js"></script>
<script type="text/javascript" charset="utf-8" src="pages/f_mem/f_mem.js"></script>

<script type="text/javascript">
$(document).ready(function() {
    showTaskView('<%=taskcode%>', '<%=sId%>', 'N');

    $(document).on("click", ".state-blocks .col-md-2",
    function(e) {
        var dataType = ""
        var tag = e.target;
        if (tag.className.indexOf("icon-calendar") < 0) {
            $(this).parent(".state-blocks").children(".state-blocks .col-md-2").removeClass("active");
            $(this).addClass("active");
            dataType = $(this).attr("data-type");
        }
        if ("全部会员" == dataType) {
            f_mem___f_mem_params = {
            		sql: "select * from f_mem_<%=cust_name%> where id in (select id from f_mem_<%=cust_name%> a where a.gym=? union all select a.id from f_mem_<%=cust_name%> a,f_user_card_<%=gym%> b where a.id=b.mem_id)",
                    sqlPs: ['<%=gym%>']
            };
            window.localStorage.setItem("leftParams", JSON.stringify(f_mem___f_mem_params));
            cq('f_mem___f_mem', 'task', f_mem___f_mem_params);
        }
        if ("新增会员" == dataType) {
            f_mem___f_mem_params = {
            	//aliase:'a',
            	sql: "select * from f_mem_<%=cust_name%> where id in (select id from f_mem_<%=cust_name%> a where a.gym=? union all select a.id from f_mem_<%=cust_name%> a,f_user_card_<%=gym%> b where a.id=b.mem_id ) and datediff(now(), create_time) <3",
                sqlPs: ['<%=gym%>']
            };
            window.localStorage.setItem("leftParams", JSON.stringify(f_mem___f_mem_params));
            cq('f_mem___f_mem', 'task', f_mem___f_mem_params);
        }
        if ("私教会员" == dataType) {
            f_mem___f_mem_params = {
            	aliase:'a',
                sql: "select a.* from f_mem_zjs a,f_user_card_zjs b,f_card c where a.id=b.mem_id and b.card_id=c.id and c.CARD_TYPE=?",
                sqlPs:  ['006']
            };
            window.localStorage.setItem("leftParams", JSON.stringify(f_mem___f_mem_params));
            cq('f_mem___f_mem', 'task', f_mem___f_mem_params);
        }
        if ("即将到期" == dataType) {
        	var val=$("div[data-type='即将到期']").find("[data-flag='value']").html();
        	val=parseInt(val)+"";
            f_mem___f_mem_params = {
            	aliase:'a',
                sql: "select DISTINCT a.* from f_mem_zjs a,f_user_card_zjs b where a.id=b.mem_id and datediff(b.deadline, now()) < ?",
                sqlPs:  [val]
            };
            window.localStorage.setItem("leftParams", JSON.stringify(f_mem___f_mem_params));
            cq('f_mem___f_mem', 'task', f_mem___f_mem_params);
        }
        if ("已过期" == dataType) {
            f_mem___f_mem_params = {
            	aliase:'a',
                sql: "select DISTINCT a.* from f_mem_zjs a,f_user_card_zjs b where a.id=b.mem_id and to_days(deadline)<to_days(now())",
                sqlPs:  []
            };
            window.localStorage.setItem("leftParams", JSON.stringify(f_mem___f_mem_params));
            cq('f_mem___f_mem', 'task', f_mem___f_mem_params);
        }
        if ("即将生日" == dataType) {
        	var val=$("div[data-type='即将生日']").find("[data-flag='value']").html();
        	val=parseInt(val)+"";
            f_mem___f_mem_params = {
            	aliase:'a',
                sql: "select DISTINCT a.* from f_mem_<%=cust_name%> a,f_user_card_<%=gym%> b where a.id=b.mem_id and to_days(a.birthday)-to_days(now()) <=? and to_days(a.birthday)-to_days(now()) >=?",
                sqlPs: [val,'0']
            };
            window.localStorage.setItem("leftParams", JSON.stringify(f_mem___f_mem_params));
            cq('f_mem___f_mem', 'task', f_mem___f_mem_params);
        }
    });
});
function detail(name) {
    var id = getValuesByName('id', name);
    var userName = getValuesByName('mem_name', name);
    var sex = getValuesByName('sex', name);
    var gymName = '<%=GymUtils.getGymName(user.getViewGym())%>';
    dialog({
        url: "pages/f_mem/update_mem_info.jsp?fk_user_id=" + id + "&fk_user_gym=<%=gym%>",
					title : '会员[' + userName + '] - [' + gymName + '] - ' + sex,
					width : 740,
					height : 700
		}).showModal();
	}
	function showUpdateRecords(name){
		var id = getValuesByName('id', name);
	    var userName = getValuesByName('mem_name', name);
	    var sex = getValuesByName('sex', name);
	    var gymName = '<%=GymUtils.getGymName(user.getViewGym())%>';
	    dialog({
	        url: "pages/f_mem/update_record_mem_info.jsp?fk_user_id=" + id + "&fk_user_gym=<%=gym%>",
						title : '会员[' + userName + '] - [' + gymName + '] - ' + sex,
						width : 740,
						height : 700
			}).showModal();
	}
</script>
<head>
<body>
	<div class="row state-blocks" style="border-bottom: 0px;">
		<div data-name="show-model-type1" class="col-md-2 active" data-type="全部会员">
			<div class="s1">
				<div>全部会员</div>
				<div data-flag="value" style="height: 30px"></div>
				<span class="selected"></span>
			</div>
		</div>
		<div data-name="show-model-type1" class="col-md-2" data-type="新增会员">
			<div class="s2">
				<div>新增会员</div>
				<div data-flag="value" data-type="新增会员" style="height: 30px">3天内</div>
				<span class="selected"></span>
				<span class="icon-calendar newMem" data-original-title="" title=""></span>
			</div>
		</div>
		<div data-name="show-model-type1" class="col-md-2" data-type="私教会员">
			<div class="s7">
				<div>私教会员</div>
				<div data-flag="value" style="height: 30px"></div>
				<span class="selected"></span>
			</div>
		</div>
		<div data-name="show-model-type1" class="col-md-2" data-type="即将到期">
			<div class="s3">
				<div>即将到期</div>
				<div data-flag="value" data-type="即将到期" style="height: 30px">30天内</div>
				<span class="selected"></span>
				<span class="icon-calendar deadline" data-original-title="" title=""></span>
			</div>
		</div>
		<div data-name="show-model-type1" class="col-md-2" data-type="已过期">
			<div class="s4">
				<div>已过期</div>
				<div data-flag="value" style="height: 30px"></div>
				<span class="selected"></span>
			</div>
		</div>
		<div data-name="show-model-type1" class="col-md-2" data-type="即将生日">
			<div class="s6">
				<div>即将生日</div>
				<div data-flag="value" data-type="即将生日" style="height: 30px">7天内</div>
				<span class="selected"></span>
				<span class="icon-calendar deadline" data-original-title="" title=""></span>
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