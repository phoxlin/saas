<%@page import="com.mingsokj.fitapp.m.MemInfo"%>
<%@page import="com.mingsokj.fitapp.m.Gym"%>
<%@page import="com.mingsokj.fitapp.m.Cust"%>
<%@page import="com.mingsokj.fitapp.utils.MemUtils"%>
<%@page import="com.jinhua.server.log.JhLog"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.mingsokj.fitapp.utils.GymUtils"%>
<%@page import="com.mingsokj.fitapp.m.Mem"%>
<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.db.impl.EntityImpl"%>
<%@page import="com.jinhua.server.db.Entity"%>
<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="com.jinhua.server.log.Logger"%>
<%@page import="com.jinhua.server.tools.Resources"%>
<%@page import="com.jinhua.server.wx.Wx"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.jinhua.server.db.impl.DBM"%>
<%@page import="com.jinhua.server.db.IDB"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);
	
 	String querystr=request.getQueryString();
 	String redirectURL = null;
 	if(querystr==null||querystr.equals("null")||querystr.length()<=0){
 		redirectURL = request.getScheme()+"://"+ request.getServerName()+request.getRequestURI();
 	}else{
 		redirectURL = request.getScheme()+"://"+ request.getServerName()+request.getRequestURI()+"?"+request.getQueryString();
 	}
	
	JhLog L=new JhLog();
	L.info("url:"+redirectURL);
	String code = request.getParameter("code");
	String cust_name = request.getParameter("cust_name");
	
	String appId = Resources.getProperty("wx." + cust_name + ".appId", "");
	String appSecret = Resources.getProperty("wx." + cust_name + ".appSecret", "");
	String configUrl = Resources.getProperty("wx."+cust_name+".url");
	
	String gym = cust_name;
	String id = "";
	String phone = "";
	String userName = "";
	String sex = "";
	String gymName = "";
	String userGym = "";
	String headUrl = "";
	String mem_name = "";

	boolean logined = false;

	Wx wx = new Wx(appId, appSecret,L);
	
	FitUser emp = null;
	MemInfo mem = null;
	boolean dev = Utils.isTrue(request.getParameter("dev"));
	try {
		if (!dev) {
			String webAccessToken = "";
			if (code != null && code.length() > 0) {
				try {
					webAccessToken = wx.getWebAccessToken();
				} catch (Exception e) {
					Logger.error(e);
					response.sendRedirect("https://open.weixin.qq.com/connect/oauth2/authorize?appid=" + appId + "&redirect_uri=" + redirectURL + "&response_type=code&scope=snsapi_userinfo&state=STATE#wechat_redirect");
				}
				wx.getOpenId(code, true);
			} else {
				if (Utils.isNull(wx.getOpenId())) {
					response.sendRedirect("https://open.weixin.qq.com/connect/oauth2/authorize?appid=" + appId + "&redirect_uri=" + redirectURL + "&response_type=code&scope=snsapi_userinfo&state=STATE#wechat_redirect");
					return;
				}
			}
			
			wx.config(configUrl+"?cust_name="+cust_name);

			//微信相关的信息处理完成，现在根据open_id进行业务判断

			//1.判断当前open_id是否登记到 F_WX_CUST 如果没有则进行登记，如果有则取出对应的gym

			IDB db = new DBM();
			Connection conn = null;
			try {
				conn = db.getConnection();
				conn.setAutoCommit(false);
				
				Entity f_wx_cust = new EntityImpl(conn);
				int size = f_wx_cust.executeQuery( "select a.GYM from f_wx_cust_" + cust_name + " a where a.WX_OPEN_ID=?", new String[]{wx.getOpenId()}, 1, 1);
				if (size > 0) {
					gym = f_wx_cust.getStringValue("gym");
				} else {
					f_wx_cust = new EntityImpl("f_wx_cust", conn);
					f_wx_cust.setTablename("f_wx_cust_" + cust_name);
					f_wx_cust.setValue("wx_open_id", wx.getOpenId());
					f_wx_cust.setValue("cust_name", cust_name);
					f_wx_cust.setValue("gym", cust_name);
					f_wx_cust.setValue("headUrl", wx.getHeadUrl());
					f_wx_cust.setValue("sex", wx.getSex());
					f_wx_cust.setValue("nickname", wx.getNickname());
					f_wx_cust.create();
				}
				//查询是否为会员
				try {
					mem = MemUtils.getMemInfoByWxOpenId(wx.getOpenId(), cust_name,L, conn);
					id = mem.getId();
					phone = mem.getPhone();
					sex = mem.getSex();
					gym = mem.getGym();
					gymName = mem.getGymName();
					headUrl = mem.getWxHeadUrl();
					userName=mem.getName();
					if (Utils.isNull(mem.getNickname())) {
						headUrl = wx.getHeadUrl();
						sex = wx.getSex();
						Mem.updateWx(wx,cust_name, conn,L);
					}
					//查询是否为员工,只有先为会员才能变成员工
					try {
						emp = new FitUser(mem.getId(),cust_name, conn);
					} catch (Exception e) {
						L.error(e);
					}
				} catch (Exception e1) {
					Mem.updateWx(wx,cust_name, conn,L);
					gym = cust_name;
					gymName = GymUtils.getGymName(gym);
					headUrl = wx.getHeadUrl();
					userName = wx.getNickname();
				}
				conn.commit();
			} catch (Exception e) {
				L.error(e);
			} finally {
				db.freeConnection(conn);
			}
		} else {
			id = "59ba4cc655040f3865e14b64";
			mem = MemUtils.getMemInfo(id, "zjs");
			
			wx.setOpenId(mem.getWxOpenId());
			wx.setNickname(mem.getNickname());
			emp = new FitUser();
			emp.setExMc(true);
			emp.setExPT(true);
			emp.setMC(true);
			emp.setPT(true);
			emp.setSM(true);
 			Cust cust = new Cust();
			cust.cust_name = "zjs";
			Gym g = new Gym();
			g.gym = "zjs";
			g.cust_name = "zjs";
			g.gymName = "古德菲力";
			g.logoUrl = "public/fit/images/logo.png";
			g.canView = true;
			g.curShow = true;
			g.belongTo = true;
			cust.viewGyms.add(g);
			
			mem.setCust(cust);
			gym = "zjs";
			
			phone = "13699058913";
			userName = "";
			sex = "";
			gymName = "";
			userGym = "";
		}
	} catch (Exception ee) {
		L.error(ee);
	}
	
	if (emp != null || mem != null) {
		logined = true;
	}
	
	L.info("#################################################################"+logined+cust_name);
	List<String> roles = new ArrayList<String>();
	if (emp != null) {
		if (emp.is会稽()) {
			roles.add("我是会籍");
		}
		if (emp.is教练()) {
			roles.add("我是教练");
		}
		if (emp.is会稽经理()) {
			roles.add("会籍管理");
		}
		if (emp.is教练经理()) {
			roles.add("教练管理");
		}
	}
	String role = Utils.getListString(roles);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="initial-scale=1, maximum-scale=1">
<meta name="format-detection" content="telephone=no, email=no">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<title><%=GymUtils.getGymName(cust_name)%></title>
<link rel="stylesheet" href="app/css/sm.css?<%=new Date().getTime()%>" />
<link rel="stylesheet" href="app/css/sm-extend.css?<%=new Date().getTime()%>" />
<link rel="stylesheet" href="app/css/public.css?<%=new Date().getTime()%>" />
<link rel="stylesheet" href="app/css/main.css?<%=new Date().getTime()%>" />
<link rel="stylesheet" href="app/css/icon.css?<%=new Date().getTime()%>" />
<link rel="stylesheet" href="app/css/tooltips.css?<%=new Date().getTime()%>" />
<link rel="stylesheet" href="app/css/card.css?<%=new Date().getTime()%>" />
<link rel="stylesheet" href="app/css/btn.css?<%=new Date().getTime()%>" />
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.1.0.js"></script>
<script type="text/javascript">
	var wxOpenId='<%=wx.getOpenId()%>';
	var appId='<%=appId%>';
	var redirectURL ="<%=redirectURL%>";
	var logined='<%=logined ? "Y" : "N"%>';
	var cust_name='<%=cust_name%>';
	var headUrl='<%=wx.getHeadUrl()%>';
	var nickname='<%=wx.getNickname()%>';
	var id='';
	var phone='';
	var mem_name='<%=mem_name%>';
	var sex='<%=wx.getSex()%>';
	var gym=cust_name;
	var gymName='<%=gymName%>';
	var userGym='';
	var user={};
	var role = '<%=role%>';
<%-- 	var cust_logoUrl ="<%=mem.getGym正在查看的门店信息().logoUrl%>"; --%>
	
	if('Y'==logined){
		id = '<%=id%>';
		phone = '<%=phone%>';
		gym = '<%=gym%>';
		gymName ='<%=gymName%>';
		user.id='<%=id%>';
		user.phone='<%=phone%>';
		user.mem_name='<%=userName%>';
		user.sex='<%=sex%>';
		user.gym='<%=gym%>';
		user.gymName='<%=gymName%>';		
		wx.config({
            debug: false,
            appId: '<%=wx.getAppid()%>',
            timestamp: '<%=wx.getTimestamp()%>',
            nonceStr: '<%=wx.getNonceStr()%>',
            signature: '<%=wx.getSignature()%>',
            jsApiList: ["closeWindow", "scanQRCode", "chooseImage", "previewImage", "uploadImage", "downloadImage"]
            // 必填，需要使用的JS接口列表，所有JS接口列表见附录2
        });
		
	}else{
		user.id='596581f5e8bbca1654e1faab'; //会籍
		user.phone='';
		user.mem_name='';
		user.sex='';
		user.gym='';
		user.gymName='';
		user.userGym='';
	}
	
	localStorage.setItem('user',JSON.stringify(user));
	localStorage.setItem('logined',logined);
	localStorage.setItem('wxOpenId',wxOpenId);
	localStorage.setItem('cust_name',cust_name);
	localStorage.setItem('gym',gym);
	localStorage.setItem('gymName',gymName);
	
</script>
</head>
<body>
	<div class="page-group">
		<div class="page page-current" id="mainPage">
			<header class="bar bar-nav main-header">
				<h1 class="title">
					<span class="tooltips-link" id="gym_name_span" onclick="changeGym()"><%=gymName%></span>
				</h1>
				<i class="pull-right icon icon-edit color-basic open-interact" style="display: none;" onclick="showQUanQUan();"></i>
			</header>
			<nav class="bar bar-tab home-bar-tab">
				<a class="tab-item tab-link active" href="#mainContent"> 
					<span class="icon icon-homepage"></span> 
					<span class="tab-label">主页</span>
				</a> 
				<a class="tab-item tab-link" href="#interactContent"> 
					<span class="icon icon-msg"></span> 
					<span class="tab-label">健身圈</span> 
					<!-- 				<span class="new font-65">5</span> -->
				</a> 
				<a class="tab-item tab-link" href="#clubContent"> 
					<span class="icon icon-club"></span> 
					<span class="tab-label">俱乐部</span>
				</a> 
				<a class="tab-item tab-link" href="#mineContent"> 
					<span class="icon icon-mine"></span> 
					<span class="tab-label">我的</span>
				</a>
			</nav>
			<div class="content" style="top: 0;">
				<div class="tabs">
					<div class="tab active" id="mainContent" style="margin-top: 2.3rem;">
						<img src="app/images/logo_mark.png" style="margin-top: 1.75rem; margin-left: 5%;width: 85%;">
						<div class="main-tool home-main-tool custom-icon font-75">
							<div class="row no-gutter font-70 color-ffff" style="padding: 1rem 0.75rem 1.2rem 0.75rem;margin: 0 5%;">
								<div class="col-50" onclick="showBuyCard()">
									<i class="icon icon-b1"></i>
									<div>在线购卡</div>
								</div>
								<div class="col-50" onclick="showMyCard()">
									<i class="icon icon-b2"></i>
									<div>我的会员卡</div>
								</div>
								<div class="col-50" onclick="showEmpList()">
									<i class="icon icon-b3"></i>
									<div>私人教练</div>
								</div>
								<div class="col-50" onclick="showLessonRecommendTop()">
									<i class="icon icon-b5"></i>
									<div>推荐课程</div>
								</div>
								<div class="col-50" onclick="showLessonPlan('')">
									<i class="icon icon-b4"></i>
									<div>课程表</div>
								</div>
							</div>
						</div>

					</div>
					<div class="tab" id="interactContent" style="margin-top: 2.3rem;">
					</div>
					<div class="tab" id="clubContent" style="margin-top: 2.3rem;">
						<div class="swiper-container club-swiper" data-space-between='10'>
							<div class="swiper-wrapper">
								<div class="swiper-slide">
									<img src="app/images/banner/banner1.jpg" alt="">
								</div>
								<div class="swiper-slide">
									<img src="app/images/banner/lesson_banner.jpg" alt="">
								</div>
								<div class="swiper-slide">
									<img src="app/images/banner/banner.jpg" alt="">
								</div>
							</div>
							<div class="swiper-pagination club-pagination"></div>
						</div>

						<div class="main-tool content-bg custom-icon font-75">
							<div class="row font-70 color-333" style="padding: 1rem 0.75rem 0.5rem 0.75rem;">
								<div class="col-50" style="text-align: center;" onclick="showActives()">
									<i class="icon icon-b8" style="width: 1.8rem;height: 1.8rem;"></i>
									<div class="color-fff">会员活动</div>
								</div>
								<div class="col-50" style="text-align: center;" onclick="showArticlesList()">
									<i class="icon icon-b9" style="width: 1.8rem;height: 1.8rem;"></i>
									<div class="color-fff">俱乐部动态</div>
								</div>
							</div>
						</div>
						<!-- 健身专题 -->
<!-- 						<div class="content-bg club-special" style="margin: 0; margin-top: 0.5rem;" id="art-special"> -->
<!-- 						</div> -->

						<!-- 火辣精选 -->
<!-- 						<div class="content-bg" id="art-content-style-2"> -->
<!-- 						</div> -->

						<div class="content-bg" style="margin: 0; margin-top: 0.5rem;" id="acitve_content">
							<p class="font-80 color-333" style="padding: 0.3rem 0.75rem; margin: 0;">为你推荐</p>
						</div>
<!-- 						<div id="art-content" style="margin-top: 0.5rem; clear: both;"></div> -->
					</div>
					<div class="tab" id="mineContent">
						<div class="mine-bg content-bg" id="image_head">
							<img onclick="showEditMsg('<%=cust_name %>')" id="wx_head_img" src="<%=headUrl%>" style="width: 3rem; height: 3rem; margin-top: 1.8rem;border-radius: 50%;border: 1px solid #fcf428;" class="head" />
							<div class="item-subtitle font-85 color-fff" style="font-weight: 700;" id="wx_nice_name"><%=userName%></div>
						</div>
						<div class="main-tool content-bg custom-icon font-75" style="padding-bottom: 0;margin-top: 0.5rem;">
							<div class="row font-70 color-fff" style="padding: 0.3rem 0.3rem 0.3rem 0;">
								<div class="col-50" onclick="openJpur()" style="text-align: center;">
									<i class="icon icon-b11" style="width: 1.8rem;height: 1.8rem;"></i> <div>健身历程</div>
								</div>
								<div class="col-50" onclick="showBodyData()" style="text-align: center;">
									<i class="icon icon-m16" style="width: 1.8rem;height: 1.8rem;"></i> <div>体测数据</div>
								</div>
							</div>
						</div>

						<div class="list-block mine-btns border-list no-border color-fff font-80" style="margin: 0; margin-top: 0.5rem;">
							<ul class="content-bg" style="margin-top: 0.5rem;">
								<li class="item-content item-link">
									<div class="item-media">
										<i class="icon icon-m3"></i>
									</div>
									<div class="item-inner" onclick="showMemFitPlan()">
										<div class="item-title">健身计划</div>
									</div>
								</li>
	
								<li class="item-content item-link">
									<div class="item-media">
										<i class="icon icon-m11"></i>
									</div>
									<div class="item-inner" onclick="showRecommend('8')">
										<div class="item-title">会员推荐</div>
									</div>
								</li>
								<li class="item-content item-link">
									<div class="item-media">
										<i class="icon icon-m15"></i>
									</div>
									<div class="item-inner" onclick="showMyIndent('5','','noIndent','mem')">
										<div class="item-title">我的订单</div>
									</div>
								</li>
							</ul>
							<ul class="content-bg" style="margin-top: 0.5rem;" id="empRolesUl">
								<%
									if (emp != null && emp.is系统管理员()) {
								%>
								<li class="item-content item-link">
									<div class="item-media">
										<i class="icon icon-m12"></i>
									</div>
									<div class="item-inner" onclick="showBoss()">
										<div class="item-title">高级管理</div>
									</div>
								</li>
								<%
									}
								%>
								<%
									if (emp != null && emp.is教练经理()) {
								%>
								<li class="item-content item-link">
									<div class="item-media">
										<i class="icon icon-m4"></i>
									</div>
									<div class="item-inner" onclick="showManage()">
										<div class="item-title">教练管理</div>
									</div>
								</li>
								<%
									}
								%>
								<%
									if (emp != null && emp.is会稽经理()) {
								%>
								<li class="item-content item-link">
									<div class="item-media">
										<i class="icon icon-m13"></i>
									</div>
									<div class="item-inner" onclick="showMcManage()">
										<div class="item-title">会籍管理</div>
									</div>
								</li>
								<%
									}
								%>
								<%
									if (emp != null && emp.is教练()) {
								%>
								<li class="item-content item-link" onclick="showPts()">
									<div class="item-media">
										<i class="icon icon-m5"></i>
									</div>
									<div class="item-inner">
										<div class="item-title">我是教练</div>
									</div>
								</li>
								<%
									}
								%>
								<%
									if (emp != null && emp.is会稽()) {
								%>
								<li class="item-content item-link" onclick="showSales()">
									<div class="item-media">
										<i class="icon icon-m6"></i>
									</div>
									<div class="item-inner">
										<div class="item-title">我是会籍</div>
									</div>
								</li>
								<%
									}
								%>
							</ul>
<!-- 							<ul class="content-bg" style="margin-top: 0.5rem; margin-bottom: 1.5rem;"> -->
<!-- 								<li class="item-content item-link"  >
									<div class="item-media">
										<i class="icon icon-m2"></i>
									</div>
									<div class="item-inner" onclick="showPercentRecort()">
										<div class="item-title">提成记录</div>
									</div>
								</li>  -->
<!--							</ul> -->

							<ul class="content-bg" style="margin-top: 0.75rem; margin-bottom: 1.5rem;">
								<li class="item-content item-link" onclick="showSetPage();">
									<div class="item-media">
										<i class="icon icon-m8"></i>
									</div>
									<div class="item-inner">
										<div class="item-title">设置</div>
									</div>
								</li>
							</ul>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script type="text/javascript" src="app/js/zepto.min.js"></script>
	<script type="text/javascript" src="app/js/touch.js"></script>
	<script type="text/javascript" src="app/js/sm.min.js"></script>
	<script type="text/javascript" src="app/js/sm-extend.js"></script>
	<script type="text/javascript" src="app/js/tooltips.js"></script>
	<script type="text/javascript" charset="utf-8" src="public/js/template.js"></script>
	<script type="text/javascript">
	<!--
		template.config({
			sTag : '<#', eTag: '#>'
		});
	//-->
		
	
	</script>
	<script type="text/javascript" src="public/js/store.js"></script>
	<script src="public/swipeSlide-gh-pages/js/swipeSlide.min.js"></script>
	<script type="text/javascript" src="app/js/date.js"></script>
	<script type="text/javascript" src="app/js/public.js"></script>
	<script type="text/javascript" src="app/js/app.js"></script>
	<script type="text/javascript" src="app/js/sales.js"></script>
	<script type="text/javascript" src="app/js/pt.js"></script>
	<!-- 	<script type="text/javascript">$.init()</script> -->
	<script type="text/javascript">
		$(function() {
			$(".club-swiper").swiper();
			
			$("#pt_cust_name").html('<%=GymUtils.getGymName(cust_name)%>');
			$("#sales_cust_name").html('<%=GymUtils.getGymName(cust_name)%>');
			$("#m_pt_cust_name").html('<%=GymUtils.getGymName(cust_name)%>');
			$("#m_mc_cust_name").html('<%=GymUtils.getGymName(cust_name)%>');
			$("#boss_cust_name").html('<%=GymUtils.getGymName(cust_name)%>');
			
			
			var lessonSwiper, clubSwiper;
			$(".home-bar-tab a").on("click", function() {
				$(".open-interact").hide();
				var href = $(this).attr("href");
				if ("#interactContent" == href) {
					$(".main-header").show();
					$(".open-interact").show();
					$(".main-header .title span").text("健身圈");
					$(".main-header .title span").removeClass("tooltips-link");
					$(".main-header .icon-f-msg2").show();
					$(".main-header .icon-f-msg").hide();
					//显示健身圈
					showInteract();
				} else if ("#mainContent" == href) {
					$(".main-header").show();
					if(gymName != null && gymName.length > 0){
						$(".main-header .title span").text(gymName);
					} else {
						$(".main-header .title span").text("古德菲力");
					}
					$(".main-header .title span").addClass("tooltips-link");
					$(".main-header .icon-f-msg2").hide();
					$(".main-header .icon-f-msg").show();
				} else if ("#clubContent" == href) {
					$(".main-header").show();
					$(".main-header .title span").text("俱乐部");
					$(".main-header .title span").removeClass("tooltips-link");
					$(".main-header .icon-f-msg2").show();
					$(".main-header .icon-f-msg").hide();
// 					showArticles();
					//推荐活动
					loadCommendActive();
				}else if("#mineContent" == href){
					$(".main-header").hide();
				}else {
					$(".main-header").hide();
				}
			});
			if(logined=='Y'){
				//打卡查询
				querySignIn();
				//检查是否是本店员工
				checkIsEmp();
			}
			//推荐活动
			loadCommendActive();
			pushHistory('mainPage');
			setTimeout(function () {  
				  window.addEventListener("popstate", function(e) {
				    	pushHistory('wx_bind_page');  
				    	closePopup();
				  }, false);  
				}, 300);  
				  
				 
		});

		function pushHistory(pageId) {
			var url="app/index.jsp?cust_name=<%=cust_name%>";
			var state = {
				title : "title",
				url : url
			};
			window.history.pushState(state, "title", url);
		}

	</script>
	<script type="text/javascript" src="app/js/boss.js"></script>
	<script type="text/javascript" src="app/js/lesson.js"></script>
	<script type="text/javascript" src="app/js/article.js"></script>
	<script type="text/javascript" src="app/js/active.js"></script>
	<script type="text/javascript" src="app/js/pt_manage.js"></script>
	<script type="text/javascript" src="app/js/mc_manage.js"></script>
	<script type="text/javascript" src="app/js/recommend.js"></script>
	<jsp:include page="partial/parital.jsp"></jsp:include>
	<script type="text/javascript" src="public/js/highcharts.src.js"></script>
</body>
</html>