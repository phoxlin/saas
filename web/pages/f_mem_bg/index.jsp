<%@page import="com.mingsokj.fitapp.utils.GymUtils"%>
<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.ms.QmToolbar"%>
<%@page import="com.sun.javafx.scene.control.skin.ToolBarSkin"%>
<%@page import="com.jinhua.server.db.Column"%>
<%@page import="com.jinhua.server.task.TaskGridLegend"%>
<%@page import="com.jinhua.server.task.TaskInfo"%>
<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
	if (user == null) {
	//	request.getRequestDispatcher("/").forward(request, response);
	}
	String cust_name = user.getCust_name();
	String taskcode = "f_mem";
	String taskname = "会员管理";
	String sId = request.getParameter("sid");
	String gym = user.getViewGym();
	
	TaskInfo task=new TaskInfo("f_mem",user);
	TaskGridLegend grid=task.getGridLegend("f_mem");
	
%>
<!DOCTYPE html>
<html>
<head>
<title><%=taskname%></title>
<jsp:include page="/public/base.jsp" />
<link rel="stylesheet" media="all" href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/public/css/bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="public/css/user.css">
<style type="text/css">
.data-container{margin-top: -13px;}
.pager a:hover{
	text-decoration: none !important;color: #666;
}
</style>

<script type="text/javascript" src="pages/f_mem_bg/index.js"></script>
<script type="text/javascript" src="pages/f_mem_bg/yp_mem.js"></script>
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
</script>

</head>
<body>
	<div class="widget">
		<jsp:include page="/public/header.jsp"></jsp:include>	
		<div class="container-fluid">
			<div class="main main2" style="margin-top: 115px;">
				<div class="mem-filter">
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
										<i class="fa fa-map-marker"></i><span>会员管理</span>
									</p>
								</a>
							</li>
						</ul>
					</div>
					<ul class="nav nav-tabs nav-tabs-custom" role="tablist">
						<li role="presentation" class="active"><a href="#tab1" aria-controls="tab1" role="tab" data-toggle="tab"> <span class="nav-tabs-left"></span> <span class="nav-tabs-text">会员维护</span> <span class="nav-tabs-right"></span>
						</a></li>
						<li role="presentation"><a href="#tab2" aria-controls="tab2" role="tab" data-toggle="tab"> <span class="nav-tabs-left"></span> <span class="nav-tabs-text">会员分析</span> <span class="nav-tabs-right"></span>
	
						</a></li>
						<li role="presentation"><a href="#tab3" aria-controls="tab3" role="tab" data-toggle="tab"> <span class="nav-tabs-left"></span> <span class="nav-tabs-text">潜在客户</span> <span class="nav-tabs-right"></span>
						</a></li>
					</ul>
				</div>

				<div class="tab-content" style="height: 130px;">
					<div role="tabpanel" class="tab-pane fade in active" id="tab1">
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
									 <div ><span data-flag="value">3</span>天内</div>
									<span class="selected"></span><span class="icon-calendar new-mem"></span>
								</div>
							</div>
							<div data-name="show-model-type1" class="col-md-2" data-type="即将到期">
								<div class="s3">
									<div>即将到期</div>
								       <div ><span data-flag="value">20</span>天内</div>
									<span class="selected"></span> <span class="icon-calendar deadline"></span>
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
									<div ><span data-flag="value">7</span>天内</div>
									<span class="selected"></span> <span class="icon-calendar birthday-popover"></span>
								</div>
							</div>
						</div>
					</div>
					<div role="tabpanel" class="tab-pane fade in" id="tab2">
						<div class="row state-blocks" style="border-bottom: 0px;">
							<div data-name="show-model-type2" class="col-md-2 active" data-type="消费能力分析">
								<div class="s1">
									<div>消费能力分析</div>
									<div >满<span data-flag="value">5000</span>元以上</div>
									<span class="selected"></span><span class="icon-calendar usedMoney"></span>
								</div>
							</div>
							<div data-name="show-model-type2" class="col-md-2" data-type="未前来消费">
								<div class="s2">
									<div>未前来消费</div>
									<div ><span data-flag="value">7</span>天以上</div>
									<span class="selected"></span><span class="icon-calendar notcheckin"></span>
								</div>
							</div>
							<div data-name="show-model-type2" class="col-md-2" data-type="请假">
								<div class="s3">
									<div>请假</div>
									<div ><span data-flag="value">30</span>天以上</div>
									<span class="selected"></span><span class="icon-calendar yp_leave"></span>
								</div>
							</div>
							<div data-name="show-model-type2" class="col-md-2" data-type="累计推荐入会">
								<div class="s4">
									<div>累计推荐入会</div>
									<div ><span data-flag="value">7</span>个人</div>
									<span class="selected"></span><span class="icon-calendar refer_phone"></span>
								</div>
							</div>
							<div data-name="show-model-type1" class="col-md-2 " data-type="未绑定会籍">
								<div class="s5">
									<div>未绑定会籍</div>
									<div data-flag="value" style="height: 30px"></div>
									<span class="selected"></span>
								</div>
							</div>
							<div data-name="show-model-type1" class="col-md-2 " data-type="未绑定教练">
								<div class="s6">
									<div>未绑定教练</div>
									<div data-flag="value" style="height: 30px"></div>
									<span class="selected"></span>
								</div>
							</div>
						</div>
					</div>
					<div role="tabpanel" class="tab-pane fade in" id="tab3">
						<div class="row state-blocks" style="border-bottom: 0px;">
							<div data-name="show-model-type3" class="col-md-2 active" data-type="最近添加">
								<div class="s1">
									<div>最近添加</div>
									<div data-flag="value" style="height: 30px"></div>
									<span class="selected"></span><span class="icon-calendar contact_content"></span>
								</div>
							</div>
							<div data-name="show-model-type3" class="col-md-2" data-type="无人跟进">
								<div class="s6">
									<div>无人跟进</div>
									<div class="icon icon-3-2" data-flag="value" style="padding-left: 40px;"></div>
									<span class="selected"></span>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="row" style="height: auto;">
					<div class="col-lg-12 col-md-12 col-xs-12">
						<div id="<%=taskcode%>_jh_process_page"></div>
					</div>
				</div>
				
			</div>
		</div>
	</div>
	
	<script type="text/javascript">
	
		function setValue(val){
			var setVal=$(val).parent().find("input").val();
			var flag=$(val).parent().find("input").attr('name');
			$("."+flag).parent().find('[data-flag="value"]').html(setVal);
			$("."+flag).popover('hide');
		}
	
		$(function() {
			//datebox placeholder
			$(".easyui-datebox").each(function(){
				var placeholder = $(this).attr("placeholder");
				$(this).next(".datebox").children(".textbox-text").attr("placeholder",placeholder);
			});
			
			$(document).on( "click", ".state-blocks .col-md-2", function(e) {
				var tag = e.target;
				if (tag.className.indexOf("icon-calendar") < 0) {
					$(this).parent(".state-blocks").children(
							".state-blocks .col-md-2").removeClass(
							"active");
					$(this).addClass("active");
				}
				var dataType = $(this).attr("data-type");
				
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
			            	aliase:'a',
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
			        if ("未绑定会籍" == dataType) {
			        	f_mem___f_mem_params = {
			                sql: "SELECT a.* FROM f_mem_<%=cust_name%> a LEFT JOIN f_user_card_<%=gym%> b ON b.mem_id = a.id where (a.mc_id='' or ISNULL(a.mc_id)) GROUP BY a.id",
			                sqlPs: []
			            };
			            window.localStorage.setItem("leftParams", JSON.stringify(f_mem___f_mem_params));
			            cq('f_mem___f_mem', 'task', f_mem___f_mem_params);
			        }
			        if ("未绑定教练" == dataType) {
			        	f_mem___f_mem_params = {
			                sql: "SELECT a.* FROM f_mem_<%=cust_name%> a LEFT JOIN f_user_card_<%=gym%> b ON b.mem_id = a.id where (a.pt_names='' or ISNULL(a.pt_names)) GROUP BY a.id",
			                sqlPs: []
			            };
			            window.localStorage.setItem("leftParams", JSON.stringify(f_mem___f_mem_params));
			            cq('f_mem___f_mem', 'task', f_mem___f_mem_params);
			        }
			        if ("累计推荐入会" == dataType) {
			        	var val=$("div[data-type='累计推荐入会']").find("[data-flag='value']").html();
			        	val=parseInt(val)+"";
			        	f_mem___f_mem_params = {
			                sql: "SELECT a.* FROM f_mem_<%=cust_name%> a where a.state='001' and a.gym=? and a.id IN ( select a.refer_mem_id from f_mem_<%=cust_name%> group by refer_mem_id having count(refer_mem_id)> ? )",
			                sqlPs: ['<%=user.getViewGym()%>',val]
			            };
			            window.localStorage.setItem("leftParams", JSON.stringify(f_mem___f_mem_params));
			            cq('f_mem___f_mem', 'task', f_mem___f_mem_params);
			        }
			        if ("无人跟进" == dataType) {
			        	f_mem___f_mem_params = {
			                sql: "SELECT a.* FROM f_mem_<%=cust_name%> a   where (a.state='004' or a.state='003') and a.gym=? and  (ISNULL(a.mc_id) or a.mc_id='')   GROUP BY a.id ",
			                sqlPs: ['<%=user.getViewGym()%>']
			            };
			            window.localStorage.setItem("leftParams", JSON.stringify(f_mem___f_mem_params));
			            cq('f_mem___f_mem', 'task', f_mem___f_mem_params);
			        }
			        if ("最近添加" == dataType) {
			        	f_mem___f_mem_params = {
			        			sql: "SELECT a.* FROM f_mem_<%=cust_name%> a   where (a.state='004' or a.state='003') and a.gym=? and  (ISNULL(a.mc_id) or a.mc_id='')   GROUP BY a.id order by create_time desc ",
				                sqlPs: ['<%=user.getViewGym()%>']
			            };
			            window.localStorage.setItem("leftParams", JSON.stringify(f_mem___f_mem_params));
			            cq('f_mem___f_mem', 'task', f_mem___f_mem_params);
			        }
				
			});
			//新增的会员popover
			$(".new-mem").popover({
				trigger : 'click',
				html : true,
				content : "<div style='width: 150px;'>查找最近 <input type='number' name='new-mem' class='filter-input' style='width: 50px;' value='3'/> 天内新增的会员</div><button onclick='setValue(this)' class='btn btn-primary custom-btn-primary' style='width: auto;float:right;'>确定</button>",
				placement : "bottom"
			});
			//即将到期popover
			$(".deadline").popover({
				trigger : 'click',
				html : true,
				content : "<div style='width: 150px;'>查找最近 <input type='number' name='deadline' class='filter-input' style='width: 50px;' value='20'/> 天内会员卡即将到期</div><button onclick='setValue(this)' class='btn btn-primary custom-btn-primary' style='width: auto;float:right;'>确定</button>",
				placement : "bottom"
			});
			//即将生日popover
			$(".birthday-popover").popover({
				trigger : 'click',
				html : true,
				content : "<div style='width: 150px;'>查找最近 <input type='number' name='birthday-popover' class='filter-input' style='width: 50px;' value='7'/> 天内即将生日的会员</div><button onclick='setValue(this)' class='btn btn-primary custom-btn-primary' style='width: auto;float:right;'>确定</button>",
				placement : "bottom"
			});
			//消费能力popover
			$(".usedMoney").popover({
				trigger : 'click',
				html : true,
				content : "<div style='width: 150px;'>查找共消费 <input type='number' name='usedMoney' class='filter-input' style='width: 50px;' value='5000'/> 元以上的会员</div><button onclick='setValue(this)' class='btn btn-primary custom-btn-primary' style='width: auto;float:right;'>确定</button>",
				placement : "bottom"
			});
			//未来消费popover
			$(".notcheckin").popover({
				trigger : 'click',
				html : true,
				content : "<div style='width: 150px;'>查找最近 <input type='number' name='notcheckin' class='filter-input' style='width: 50px;' value='7'/> 天内未来会所消费的会员</div><button onclick='setValue(this)' class='btn btn-primary custom-btn-primary' style='width: auto;float:right;'>确定</button>",
				placement : "bottom"
			});
			//请假popover
			$(".yp_leave").popover({
				trigger : 'click',
				html : true,
				content : "<div style='width: 150px;'>查找已经请假 <input type='number' name='yp_leave' class='filter-input' style='width: 50px;' value='30'/> 天以上的会员</div><button onclick='setValue(this)' class='btn btn-primary custom-btn-primary' style='width: auto;float:right;'>确定</button>",
				placement : "bottom"
			});
			//累计推荐入会popover
			$(".refer_phone").popover({
				trigger : 'click',
				html : true,
				content : "<div style='width: 150px;'>查找累计介绍 <input type='number' name='refer_phone' class='filter-input' style='width: 50px;' value='3'/> 位会员入会的会员</div><button onclick='setValue(this)' class='btn btn-primary custom-btn-primary' style='width: auto;float:right;'>确定</button>",
				placement : "bottom"
			});
			//会员兴趣popover
			$(".mem_like").popover({
				trigger : 'click',
				html : true,
				content : "<div style='width: 150px;'>查找喜欢 <input type='text' name='mem_like' class='filter-input' style='width: 100px;' value=''/> 的会员</div><button onclick='setValue(this)' class='btn btn-primary custom-btn-primary' style='width: auto;float:right;'>确定</button>",
				placement : "bottom"
			});
			//跟单内容popover
			$(".contact_content").popover({
				trigger : 'click',
				html : true,
				content : "<div style='width: 150px;'>查找之前沟通过 <input type='text' name='contact_content' class='filter-input' style='width: 100px;' value=''/> 的会员</div><button onclick='setValue(this)' class='btn btn-primary custom-btn-primary' style='width: auto;float:right;'>确定</button>",
				placement : "bottom"
			});

			//点击其他区域，隐藏popover
			$(document).on('click',function(event) {
				var target = $(event.target);
				if (!target.hasClass('popover')
						&& !target.hasClass('filter-input')
						&& target.parent('.popover-content').length === 0
						&& target.parent('.popover-title').length === 0
						&& target.parent('.popover').length === 0
						&& (target.attr("class") == undefined || target.attr("class").indexOf("icon-calendar") < 0)) {
					$('.icon-calendar').popover('hide');
				}
			});
			showTaskView('<%=taskcode%>', '<%=sId%>', 'N');
		});

	</script>
</body>
</html>