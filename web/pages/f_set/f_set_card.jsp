<%@page import="com.jinhua.server.db.Entity"%>
<%@page import="com.jinhua.server.tools.UI"%>
<%@page import="com.jinhua.server.tools.UI_Op"%>
<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	User user = SystemUtils.getSessionUser(request, response);
	if (user == null) {
		request.getRequestDispatcher("/").forward(request, response);
	}

	Entity f_store = (Entity) request.getAttribute("f_store");
	boolean hasF_store = f_store != null && f_store.getResultCount() > 0;
%>
<!DOCTYPE HTML>

<html>
<jsp:include page="/public/base.jsp" />
<link rel="stylesheet" media="all"
	href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/public/css/bootstrap.min.css" />

<head>


<script type="text/javascript" charset="utf-8"
	src="pages/f_set/index.js"></script>
<style>
.setting-header{
	margin-top: 16px;
}
.setting-header label {
    display: block;
    width: 180px;
    line-height: 30px;
    text-align: center;
    font-weight: lighter;
    font-size: 20px;
    color: #737373;
}
.setting-header .setting-line {
    border-bottom: 1px solid #e6e6e6;
    display: block;
    width: 91%;
    margin: 0 auto;
    margin-bottom: 17px;
}
.horizontal-form .form-group, .horizontal-form .form-item {
    clear: both;
    width: 100%;
    margin-bottom: 15px;
}
div {
    display: block;
}
* {
    box-sizing: border-box;
}
.horizontal-form .form-group .input, .horizontal-form .form-item .input {
    font-size: 12px;
    margin-left: 183px;
    margin-right: 15px;
}
.horizontal-form .form-group label, .horizontal-form .form-item label {
    display: block;
    float: left;
    width: 160px;
    line-height: 30px;
    text-align: right;
    font-weight: normal;
}
forms.less:242
label {
    display: inline-block;
    max-width: 100%;
    margin-bottom: 5px;
    font-weight: bold;
}
.webkit-oneline input[name="leaveDays"] {
    width: 150px;
    float: left;
}
panel.css:1
.input-text {
    width: 230px;
    height: 30px;
    padding: 4px;
    font-size: 12px;
    vertical-align: top;
    border: 1px solid #ccc;
    border-radius: 3px;
}
type.less:24
input, button, select, textarea {
    font-family: inherit;
    font-size: inherit;
    line-height: inherit;
}
.webkit-oneline {
    margin: 0;
    padding: 0;
    display: inline-block;
}
p {
    display: block;
    -webkit-margin-before: 1em;
    -webkit-margin-after: 1em;
    -webkit-margin-start: 0px;
    -webkit-margin-end: 0px;
}
.horizontal-form .form-group p, .horizontal-form .form-item p {
    margin-bottom: 0;
}
.webkit-oneline .help-block {
    float: left;
    margin-left: 10px;
}

Index.css?v=1.0:1
.webkit-oneline .help-block {
    float: left;
    margin-left: 10px;
}
Index.css?v=1.0:1
.webkit-oneline .help-block {
    float: left;
    margin-left: 10px;
}
buttons.less:11
.help-block {
    display: block;
    margin-top: 5px;
    margin-bottom: 10px;
    color: #737373;
}
bootstrap.css:1231
p {
    margin: 0 0 10px;
}
.webkit-oneline input[name="lessLeaveDays"] {
    width: 150px;
    float: left;
}
.webkit-oneline input[name="deadline"] {
    width: 150px;
    float: left;
}
</style>
</head>
<body>
	<div class="popup-cont">
		<form action="" class="horizontal-form">
			<div class="setting-header">
				<label>时间卡设置</label>
				<div class="setting-line"></div>
			</div>
			<div class="form-group">
				<label>最长请假天数</label>
				<div class="input">
					<div class="webkit-oneline">
						<input type="number" name="leaveDays" class="input-text"
							style="width: 150px;" placeholder="" value="0">
						<p class="help-block">天</p>
					</div>
					<p class="help-block">拥有时间卡的会员，在其有效时间内可请假总天数的上限。</p>
				</div>
			</div>
			<div class="form-group">
				<label>最短请假天数</label>
				<div class="input">
					<div class="webkit-oneline">
						<input type="number" name="lessLeaveDays" class="input-text"
							style="width: 150px;" placeholder="" value="1">
						<p class="help-block">天</p>
					</div>
					<p class="help-block">拥有时间卡的会员，在其有效时间内一次请假的最少天数。</p>
				</div>
			</div>
			<div class="form-group">
				<label>最晚开卡期限</label>
				<div class="input">
					<div class="webkit-oneline">
						<input type="number" name="deadline" class="input-text"
							placeholder="" value="0">
						<p class="help-block">天</p>
						<div class="webkit-active" style="display: none;">
							<span class="webkit-active-span"> <select name="aci"
								class="select width-80">
									<option value="0">自动开卡</option>
									<option value="1">签到手动开卡</option>
							</select>
							</span>
						</div>
						<!--<div class="webkit-active"><span class="webkit-active-span"><input type="checkbox" name="aci" class="webkit-active-input"/><p class="webkit-active-p">前台可根据具体情况选择最晚期限或操作当天</p></span></div>-->
					</div>
					<div class="webkit-twoline">
						<p class="help-block">拥有时间卡的会员，必须在该期限内开卡</p>
						<p class="help-block">0则为不限制，如果超过设置的期限未开卡，开卡时会提示是否将开卡时间设置为最晚期限的时间</p>
					</div>
				</div>
			</div>
			<div class="form-group" style="display: none;">
				<label>用户自助请假</label>
				<div class="input">
					<input type="radio" name="selfleave" value="0" id="index0"
						checked="checked">关闭 <input type="radio" name="selfleave"
						value="1" id="index1" style="margin-left: 30px;">开启
					<p class="help-block">关闭自助请假，可以应用于俱乐部的请假需要线下提交材料审核的情况，工作人员可以在后台给用户请假；</p>
					<p class="help-block">打开自助请假，则会员可以在手机上进行请假操作，不需要工作人员审核。</p>
				</div>
				<br>
			</div>
			<div class="form-group" style="display: none;" name="cardType">
				<label>时间卡模式</label>
				<div class="input">
					<input type="radio" name="timeCardType" value="single" id="index0"
						checked="checked">单时间卡 <input type="radio"
						name="timeCardType" value="multi" id="index1"
						style="margin-left: 30px;" checked="checked">多时间卡
					<p class="help-block">单时间卡 为每个vip用户只有一张时间卡</p>
					<p class="help-block">多时间卡 为每个vip用户可以有多张时间卡</p>
				</div>
			</div>
			<div class="form-group clearMultiCards" style="display: none;">
				<label>清空时间卡</label>
				<div class="input">
					<input type="button" name="clearMultiCards" class="input-text"
						style="width: 150px;" value="清空时间卡和充值记录">
					<p class="help-block"></p>
					<p class="help-block">
						<span style="color: red">将清空时间卡和充值记录，请谨慎操作</span>
					</p>
				</div>
			</div>
			<div class="form-group photograph" style="display: none;">
				<label>拍照选择</label>
				<div class="input" style="line-height: 30px;">
					<input type="radio" name="picture" value="1" id="index0"
						style="position: relative; top: 2px;">HTML5 <input
						type="radio" name="picture" value="0" id="index1"
						checked="checked"
						style="margin-left: 30px; position: relative; top: 2px;">Flash
				</div>
			</div>
			<div class="form-group photograph">
				<label>会员自助查询</label>
				<div class="input">
					<input type="radio" name="record" value="0" id="index0"
						checked="checked"
						style="position: relative; top: -1px; margin-right: 4px;">开启
					<input type="radio" name="record" value="1" id="index1"
						style="margin-left: 30px; position: relative; top: -1px; margin-right: 4px;">关闭
					<p class="help-block">关闭此功能，会员将不能在APP和微信中查看自己的充值记录和消费记录</p>
				</div>
			</div>
			<div class="setting-header">
				<label>次卡设置</label>
				<div class="setting-line"></div>
			</div>
			<div class="form-group">
				<label>次卡消次密码</label>
				<div class="input">
					<input type="text" name="onceCardUsedPass" class="input-text"
						value="1234">
					<p class="help-block">用于俱乐部前台或工作人员对会员次卡进行消次的密码，最大长度不超过4位</p>
					<!--p class="help-block">次卡必须在俱乐部工作人员输入密码确认后才可以消次，无密码无法消次。</p>		        		<p class="help-block">密码最大长度不能超过4位。</p-->
				</div>
			</div>
			<div class="form-group">
				<label>卡片开始使用时间</label>
				<div class="input">
					<input type="radio" name="cardStartTime" value="1" id="index0"
						style="position: relative; top: -1px; margin-right: 4px;">开启
					<input type="radio" name="cardStartTime" value="0" id="index1"
						checked="checked"
						style="margin-left: 30px; position: relative; top: -1px; margin-right: 4px;">关闭
					<p class="help-block">若开启此功能，在给会员充值次卡，私教卡，储值卡将需要选填卡片开始使用时间。</p>
				</div>
			</div>
			<div class="form-group">
				<label>会员支付密码</label>
				<div class="input">
					<input type="radio" name="vipPasswd" value="1" id="index0"
						style="position: relative; top: -1px; margin-right: 4px;">开启
					<input type="radio" name="vipPasswd" value="0" id="index1"
						checked="checked"
						style="margin-left: 30px; position: relative; top: -1px; margin-right: 4px;">关闭
					<p class="help-block">若开启此功能，在录入会员时需要输入会员密码，前台代消时需要会员输入密码才可代消。</p>
				</div>
			</div>
		</form>
	</div>
</body>
<script type="text/javascript">
	
</script>

</html>
