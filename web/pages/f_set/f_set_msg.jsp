<%@page import="com.jinhua.server.db.Entity"%>
<%@page import="com.jinhua.server.tools.UI"%>
<%@page import="com.jinhua.server.tools.UI_Op"%>
<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%

	User user=SystemUtils.getSessionUser(request, response);
	if(user==null){ request.getRequestDispatcher("/").forward(request, response);}

	Entity f_store=(Entity)request.getAttribute("f_store");
	boolean hasF_store=f_store!=null&&f_store.getResultCount()>0;
%>
<!DOCTYPE HTML>

<html>
<link rel="stylesheet" media="all"
	href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/public/css/bootstrap.min.css" />

<style>
.div1{
float: left;
    width: 130px;
    height: 130px;
    border: solid 1px;
    margin-left: 10px;
    margin-top: 10px;
}

</style>
 <head>
  <jsp:include page="/public/edit_base.jsp" />
<script type="text/javascript">
$(function(){
	$(".div1").click(function(){
		var check = $(this).find("input").is(":checked");
		if(check){
			 $(this).find("input").prop("checked",false);
		}else{
			 $(this).find("input").prop("checked",true);
		}
	});
});

</script>

  <script type="text/javascript" charset="utf-8" src="pages/f_set/index.js"></script>
 </head>
<body>
	  <form class="l-form" id="f_set" method="post">
	   <div class="main">
			<div class="menu-container">
			<p>通过开关下方的短信模板，即可控制该类短信提醒的开启或关闭</p>
				<div class="menus">
				<div class="div1">
					<a> <i class="icon icon-op14"></i>
						<span>授课预约提醒</span>
						<input type="checkbox" value="classRemind" id="classRemind" name="msg"/>
					</a> 
					<p>会员{小健}预约了你的私课,联系电话:{138****0818},请打开应用-排课管理进行确认</p>
				</div>	
				<div class="div1">
					<a> <i class="icon icon-op14"></i>
						<span>用户上课提醒</span>
						<input type="checkbox" value="userClassRemind" id="userClassRemind" name="msg"/>
					</a> 
					<p>你预约的教练{小健}的私课将于{30}分钟后上课,记得准时参加哦！教练电话:{138****0818}</p>
				</div>	
				<div class="div1">
					<a> <i class="icon icon-op14"></i>
						<span>教练上课提醒</span>
						<input type="checkbox" value="coachClassRemind" id="coachClassRemind" name="msg"/>
					</a> 
					<p>你定于给会员{小健}的私教课程还有{30}分钟开始，请及时联系会员，会员电话:{138****0818}</p>
				</div>	
				<div class="div1">
					<a> <i class="icon icon-op14"></i>
						<span>确认预约通知</span>
						<input type="checkbox" value="sureNotice" id="sureNotice" name="msg"/>
					</a> 
					<p>教练{小健}已经确认了你的私课，记得准时上课哦，教练电话:{138****0818}</p>
				</div>	
				<div class="div1">
					<a> <i class="icon icon-op14"></i>
						<span>用户预约提醒</span>
						<input type="checkbox" value="userRemind" name="msg"/>
					</a> 
					<p>会员{小健}预约了你的私课,联系电话:{138****0818},请打开应用-{智再健身}进行确认</p>
				</div>	
				<div class="div1">
					<a> <i class="icon icon-op14"></i>
						<span>会员认证通过</span>
						<input type="checkbox" value="memberAdpot" name="msg"/>
					</a> 
					<p>您在{试用账号3}提交的会员认证申请已通过审核，打开APP进入会员卡即可查看。</p>
				</div>	
				<div class="div1">
					<a> <i class="icon icon-op14"></i>
						<span>会员认证驳回</span>
						<input type="checkbox" value="memberReject" name="msg"/>
					</a> 
					<p>您在{试用账号3}提交的会员认证申请被驳回，原因为：{}。打开APP进入会员卡即可查看。</p>
				</div>	
				<div class="div1">
					<a> <i class="icon icon-op14"></i>
						<span>时间卡充值</span>
						<input type="checkbox" value="rechargTimeCard" name="msg"/>
					</a> 
					<p>您在{试用账号3}的“健身年卡”获得充值{365天}，新的到期时间为{2017-06-23}，打开APP进入会员卡即可查看。</p>
				</div>	
				<div class="div1">
					<a> <i class="icon icon-op14"></i>
						<span>时间卡即将到期</span>
						<input type="checkbox" value="rechargTimeCard" name="msg"/>
					</a> 
					<p>您在试用账号3}的“健身年卡”到期时间为{2017-06-23}，该卡即将到期，请及时续费。</p>
				</div>	
				<div class="div1">
					<a> <i class="icon icon-op14"></i>
						<span>私教卡充值</span>
						<input type="checkbox" name="msg"/>
					</a> 
					<p>您在试用账号3}获得一张“私教卡”,剩余次数为{xxx次}，到期时间为{xxx-xx-xx}，打开APP进入次卡即可查看</p>
				</div>	
				<div class="div1">
					<a> <i class="icon icon-op14"></i>
						<span>私教消课</span>
						<input type="checkbox" value="personCardSpend" name="msg"/>
					</a> 
					<p>您在试用账号3}的私教卡，由完成消课{1次}，剩余次数为{XXX次}。</p>
				</div>	
				<div class="div1">
					<a> <i class="icon icon-op14"></i>
						<span>代约课通知</span>
						<input type="checkbox" value="personCardHelpSub" name="msg"/>
					</a> 
					<p>你的教练名字在俱乐部名字为你代约了一节时间的私教课程，请准时上课</p>
				</div>	
				<div class="div1">
					<a> <i class="icon icon-op14"></i>
						<span>新增次卡</span>
						<input type="checkbox" value="addOnceCard" name="msg"/>
					</a> 
					<p>您在{试用账号4}获得一张“增肌私教次卡”，剩余次数为{xxx次}，到期时间为{xxx-xx-xx}，打开APP进入次卡即可查看。</p>
				</div>	
				<div class="div1">
					<a> <i class="icon icon-op14"></i>
						<span>次卡代消</span>
						<input type="checkbox" value="rechargOnceCard" name="msg"/>
					</a> 
					<p>您在{试用账号4}的“增肌私教次卡”由俱乐部代为消次{1次}，剩余次数为{XXX次}。</p>
				</div>	
				<div class="div1">
					<a> <i class="icon icon-op14"></i>
						<span>次卡即将到期</span>
						<input type="checkbox" value="OnceCardOnceOut" name="msg"/>
					</a> 
					<p>您在{试用账号4}的“增肌私教次卡”剩余次数为{xxx次}，到期时间为{xxxx-xx-xx}，剩余时间不到一个月，请及时使用。</p>
				</div>	
				<div class="div1">
					<a> <i class="icon icon-op14"></i>
						<span>新增储值卡</span>
						<input type="checkbox" value="rechargValueCard" name="msg"/>
					</a> 
					<p>您在{试用账号4}获得一张储值卡，金额为￥1000，到期时间为{2016-06-23}，打开APP进入储值卡即可查看</p>
				</div>	
				<div class="div1">
					<a> <i class="icon icon-op14"></i>
						<span>储值卡消费</span>
						<input type="checkbox" value="spendValueCard" name="msg"/>
					</a> 
					<p>的储值卡消费￥100，消费项目：{购物}；剩余金额为￥2300。</p>
				</div>	
				<div class="div1">
					<a> <i class="icon icon-op14"></i>
						<span>团操课上课通知</span>
						<input type="checkbox" value="syllabusGroupClassBegin" name="msg"/>
					</a> 
					<p>您的课程名称即将于12:00开始上课，上课位置为课程位置，请准时参加</p>
				</div>	
				<div class="div1">
					<a> <i class="icon icon-op14"></i>
						<span>用户预约团操课</span>
						<input type="checkbox" value="syllabusGroupSub" name="msg"/>
					</a> 
					<p>会员姓名预约了您2016年11月23日的课程-课程名称，该课程目前已有23人预约，已满足开课下限(未满足开课下限，已达到预约上限)。</p>
				</div>	
				<div class="div1">
					<a> <i class="icon icon-op14"></i>
						<span>团操课预约取消通知</span>
						<input type="checkbox" value="syllabusGroupCancel" name="msg"/>
					</a> 
					<p>团操课预约取消的时候用户和教练都发送通知</p>
				</div>	
				<div class="div1">
					<a> <i class="icon icon-op14"></i>
						<span>团操课变动通知</span>
						<input type="checkbox" value="syllabusGroupChange" name="msg"/>
					</a> 
					<p>团操课修改编辑的课程变动给教练和会员发送通知</p>
				</div>	
				<div class="div1">
					<a> <i class="icon icon-op14"></i>
						<span>会员生日</span>
						<input type="checkbox" value="vipBirthday" name="msg"/>
					</a> 
					<p>【智再健身】收到来自{俱乐部名称}的生日祝福，祝您生日快乐！别忘了常来锻炼哦~</p>
				</div>	
				<div class="div1">
					<a> <i class="icon icon-op14"></i>
						<span>会员-最近未签到</span>
						<input type="checkbox" value="vipCheckIn" name="msg"/>
					</a> 
					<p>【智再健身】很长时间没有来锻炼了，什么时候来看看？来自{俱乐部名称}的问候</p>
				</div>	
					
				</div>
			</div>
		</div>
	  </form>
 </body>
 
</html>