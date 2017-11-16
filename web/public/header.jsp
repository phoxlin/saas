<%@page import="com.mingsokj.fitapp.m.MemInfo"%>
<%@page import="com.mingsokj.fitapp.utils.GymUtils"%>
<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="java.io.File"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" type="text/css" href="public/fit/css/pager.css">
<link href="public/fit/css/font-awesome.min.css" rel="stylesheet">
<!-- 消息样式 -->
<link rel="stylesheet" type="text/css" href="public/message/css/messenger.css">
<link rel="stylesheet" type="text/css" href="public/message/css/messenger-theme-future.css">
<link rel="stylesheet" type="text/css" href="public/message/css/messenger-theme-ice.css">
<!-- 消息js -->
<script src="public/message/js/messenger.min.js"></script>
<script src="public/message/js/messenger-theme-future.js"></script>

<%
	String view = request.getParameter("view");

	FitUser user=(FitUser)SystemUtils.getSessionUser(request, response);
	if(user==null){ request.getRequestDispatcher("/").forward(request, response);}
	MemInfo info=user.getMemInfo();
	String logoUrl= "public/fit/images/logo.png";
	if(info==null){
		info=new MemInfo();
	}else{
		logoUrl=info.getViewGym(user.getViewGym()).logoUrl+"?imageView2/1/w/64/h/64";
	}
	String user_name = user.getMemInfo()==null ?"":user.getMemInfo().getName();
	String cust_name = user.getCust_name();
	String gym = user.getViewGym();
	String gname = GymUtils.getGymName(user.getViewGym());
	String baseUrl = Utils.getWebRootPath();
	String wxHeadUrl="public/fit/images/cashier/default_head.png";
	try{wxHeadUrl=user.getMemInfo().getWxHeadUrl();}catch(Exception e){}
	String logo_url = "public/images/main/logo.png";
	if(cust_name != null && cust_name.length() > 0){
		logo_url = "public/images/"+cust_name+"/logo_main.png";
		File file = new File(baseUrl + logo_url);
		if(!file.exists()){
			logo_url = "public/images/fit/logo_main.png";
		}
	}
	String main = request.getParameter("isMain"); //是否是主页头部
	String _class = "nav-bg";
	if(main != null && main.length() > 0 && "true".equals(main)){
		_class = "";
	}
%>
<script type="text/javascript">
   <!--
	template.config({
		sTag : '<#', eTag: '#>'
	});
//-->
</script>

<div class="nav nav1 <%=_class%>">
	<div class="navbar-header" style="cursor: pointer;" onclick="javascript:location.href='main.jsp'">
		<img src="<%=logoUrl%>" style="max-height: 80px;margin-left: 30px;">
	</div>
	<ul class="navbar-right">
		<li class="icon-msg" onclick="showMsg()">
			消息
			<span class="msg">0</span>
			<dl class="hover-menu msg-hover-menu" style="left: -80px;width: 400px;">
				<i class="menu-arrow" style="left: 150px;"></i>
				<dd class="desc-box"  id="myMsgDiv" >
					<ul class="desc-link">
					</ul>
				</dd>
			</dl>
		</li>
		<li class="icon-setting" onclick="javascript: location.href='setting.jsp'">设置</li>
		<li class="me-info" onclick="showMe()">
			<img src="<%=wxHeadUrl %>" style="width: 40px; margin-right: 10px;">
			<span><%=user_name %> <span style="font-size: 13px;">(<%=GymUtils.getGymName(user.getViewGym())%>)</span> </span>
			<a class="icon-more"></a>
			
			<dl class="hover-menu">
				<dt class="menu-info">
					<i class="menu-arrow"></i>
					<i class="menu-layer"></i>
					<span class="menu-header">
						<span class="user-photo-box">
							<i class="user-photo" style="background-image:url('<%=wxHeadUrl %>');filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(src='<%=wxHeadUrl %>', sizingMethod='scale');"></i>
						</span>
						<span class="user-info">
							<span class="username"><%=user_name %></span>
						</span>
					</span>
				</dt>
				<dd class="desc-box">
					<ul class="desc-link">
						<li class="link-item">
							<a href="javascript:exchangeGym();">切换门店</a>
						</li>
						<li class="link-item">
							<a href="javascript:alert('功能开发中，敬请期待');">个人资料</a>
						</li>
						<li class="link-item">
							<a href="javascript:alert('功能开发中，敬请期待');">帮助中心</a>
						</li>
						<li class="link-item">
							<a href="javascript:changePwd();">修改密码</a>
						</li>
						<li class="link-item">
							<a href="javascript:exit();">退出</a>
						</li>
					</ul>
				</dd>
			</dl>
		</li>
	</ul>
</div>


<script type="text/javascript">
	function changePwd() {
		dialog(
				{
					url : "partial/changePWD.jsp",
					title : '修改密码',
					width : 500,
					height : 350,
					lock : true,
					cancelValue : "关闭",
					cancel : function() {
						return true;
					},
					okValue : "保存",
					ok : function() {
						var iframe = $(window.parent.document).contents().find(
								"[name=" + dialog.getCurrent().id + "]")[0].contentWindow;
						iframe.updatePassword(this, document);
						return false;
					},
				}).showModal();
	}

	function exchangeGym() {
		dialog(
				{
					url : "fit-ws-emp-viewgym-list?nextPage=partial/exchangeGym.jsp",
					title : '可见门店切换',
					width : 500,
					height : 350,
					lock : true,
					cancelValue : "取消",
					cancel : function() {
						return true;
					},
					okValue : "确定",
					ok : function() {
						var iframe = $(window.parent.document).contents().find(
								"[name=" + dialog.getCurrent().id + "]")[0].contentWindow;
						iframe.changeGym();
						return false;
					},
				}).showModal();

	}

	function exit() {
		dialog({
			title : '确认',
			content : '您确定要退出系统吗？',
			okValue : "确定",
			ok : function() {
				location.href = "exit.jsp?c=<%=cust_name%>";
			},
			cancelValue : "取消",
			cancel : function() {
				return true;
			}
		}).showModal();
	}
	function showMe(){
		$(".me-hover-menu").toggle();
		$(".msg-hover-menu").hide();
	}
	
	function showMsg(){
		$(".msg-hover-menu").toggle();
	}
	$(document).on("click", function(e){
		if(!$(e.target).hasClass("mine-info") && 
		   !$(e.target).parent().hasClass("mine-info-span") && 
		   !$(e.target).parent().hasClass("mine-info")){
			$(".me-hover-menu").hide();
		}
		/*  if(!$(e.target).hasClass("msg-btn") && 
		   !$(e.target).parent().hasClass("msg-btn")){
			$(".msg-hover-menu").hide();
		} */
	});
	
	$(function (){
		queryMsg(1);
	})
	
	function queryMsg(cur){
		$.ajax({
			type : 'POST',
			url : 'yp-ws-bg-getMyMsg',
			data : {
				cur : cur
			},
			dataType : 'json',
			success : function(data) {
				if (data.rs == "Y") {
					var tpl = document.getElementById("msgTpl").innerHTML;
					var list = data.list;
						var x = 0;
					if(list){
						for(var i=0;i<list.length;i++){
							if(list[i].state != 'READ'){
								x ++;
							}
						}
					}
					if(x == 0){
						$(".new").hide();
					}else{
						$(".new").text(x == 10 ?"10+":x);
						$(".new").show();
					}
					var html = template(tpl,{data:data});
					$("#myMsgDiv").html(html);
				} else {
					error(data.rs);
				}
			}
		})
	}
	
	function confirmReduceClass(msg_content,table,id,msg_id){
		top.dialog({
			title:"操作提醒",
			content:msg_content,
			okValue:"确定",
			ok :function(){
				reduceClass(msg_content,table,id,msg_id);
				return true;
			},cancelValue : "关闭",
			cancel : function() {
				return true;
			}
		}).showModal();
	}
	
	function reduceClass(msg_content,table,id,msg_id){
		
		
		 $.ajax({
				type : 'POST',
				url  : 'fit-ws-bg-reduceClassConfirm',
				data : {
					data_table_name:table,
					data_id:id,
					msg_id:msg_id
				},
				dataType : 'json',
				success : function(data) {
					if (data.rs == "Y") {
						flag = true;
						Messenger().post("消课成功啦");
						queryMsg(1);
					} else {
						//alert(data.rs);
						Messenger().post({
						  message: "消课失败,原因:"+data.rs,
						  type: 'error',
						  showCloseButton: true
						});
					}
				}
			}); 
		function successMsg(msg){
			Messenger().post(msg);
		};
		function errorMsg(msg){
			Messenger().post({
				  message: msg,
				  type: 'error',
				  showCloseButton: true
				});
		};
		
		/* Messenger().run({
			  action: $.ajax,
			  type:"POST",
			  successMessage: '消课成功,才怪嘞',
			  errorMessage: '操作失败,请重试',
			  progressMessage: '消课ing...'
			}, {
			   These options are provided to $.ajax, with success and error wrapped 
			  url: 'fit-ws-bg-reduceClassConfirm',
			  type:"POST",
			  data: {
					data_table_name:table,
					data_id:id,
					msg_id:msg_id
				},
			  success:function(data){
				  if(data.rs =="Y"){
					  //$(this).hide(); 不得行
				  }else{
					   var msg;
					  msg = Messenger().post({
					    message: "消课失败了,需要重新尝试吗?",
					    actions: {
					      retry: {
					        label: '立马重试',
					        phrase: 'Retrying TIME',
					        auto: true,
					        delay: 10,
					        action: function() {
					        	reduceClass(msg_content,table,id,msg_id);
					        }
					      },
					      cancel: {
					        action: function() {
					          return msg.cancel();
					        }
					      }
					    }
					  }); 
				  }
			  },
			  error: function(data){
				alert(data.rs);
			  }
			});
		 */
		/**/
	}
</script>

<script type="text/html" id="msgTpl">
<ul class="desc-link">
	<#
		if(data.list && data.list.length>0){
		for(var i=0;i<data.list.length;i++){
			var msg = data.list[i];
	#>

	<#if(msg.msg_type == "mem_reduce_lesson" && msg.receiver_id =="OP"){#>
		<li class="link-item" onclick="confirmReduceClass('<#=msg.msg_content#>','<#=msg.data_table_name#>','<#=msg.data_id#>','<#=msg.id#>')">
			<a>
			<#if(msg.state=="READ"){#>(已读)<#}else{#>(未读)<#}#>
			<#=msg.msg_content#><#if(msg.receiver_id =="OP"){#>(可操作)<#}#></a>
		</li>
	<#}else{#>
		<li>
			<a><#if(msg.state=="READ"){#>(已读)<#}else{#>(未读)<#}#><#=msg.msg_content#></a>
		</li>
	<#}#>
	<#}}else{#>
	<#}
	#>
</ul>
	<div class="pager">
		<div>总数<#=data.total#>&nbsp;当前页条数<#=data.curSize#></div>
		<div>
			<#
				var cur = data.curPage;
				if(parseInt(cur) > parseInt(data.totalPage)){
					cur = data.totalPage
				}					
				if(data.curPage > 1){
					var pre = data.curPage - 1;
			#>
				<a href="javascript: void(0);" onclick="queryMsg(1);"> 
					<i style="margin-right: -4px;">|</i> 
					<span class="fa fa-angle-left"></span>
				</a> 

				<a href="javascript: void(0);" onclick="queryMsg(<#=pre#>);"> 
					<span class="fa fa-angle-left"></span>
				</a> 
			<#		
				} else {
			#>
				<a class="disabled" href="javascript: void(0);"> 
					<i style="margin-right: -4px;">|</i> 
					<span class="fa fa-angle-left"></span>
				</a>
				<a class="disabled" href="javascript: void(0);"> 
					<span class="fa fa-angle-left"></span>
				</a> 
			<#		
				}
			#>
			<input onkeyup="queryMsg(this.value)" value="<#=cur#>" type="number" style="max-width: 55px; padding: 0 5px; height: 23px; margin: 0 5px 0 10px;">/<#=data.totalPage#>&nbsp;&nbsp; 
			
			<#
				if(parseInt(cur) < data.totalPage){
					var next = data.curPage + 1;						
			#>
				<a href="javascript: void(0)" onclick="queryMsg(<#=next#>)"> 
					<span class="fa fa-angle-right"></span>
				</a> 
				<a href="javascript: void(0)" onclick="queryMsg(<#=data.totalPage#>)"> 
					<span class="fa fa-angle-right"></span> <i style="margin-left: -4px;">|</i>
				</a>
			<#
				} else {
			#>
				<a class="disabled"> 
					<span class="fa fa-angle-right"></span>
				</a> 
				<a class="disabled"> 
					<span class="fa fa-angle-right"></span> <i style="margin-left: -4px;">|</i>
				</a>
			<#		
				}
			#>
		</div>
	</div>
</script>