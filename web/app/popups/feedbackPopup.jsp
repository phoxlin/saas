<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-feedback">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-feedback');"></a>
		<h1 class="title">意见反馈</h1>
	</header>
	<nav class="bar bar-tab">
		<div class="row no-gutter">
			<div class="col-100 one-btn" onclick="saveFeedback()">提交</div>
		</div>
	</nav>
	<div class="content">
		<div class="list-block" style="margin-top: 0;">
			<ul style="margin-top: 0;">

				<li class="align-top">
					<div class="item-content">
						<div class="item-inner" style="margin-left: 0; padding: 0.75rem 0;">
							<div class="item-input">
								<textarea class="font-75 color-fff" id="content" style="height: 20rem; background: transparent;" placeholder="请输入您的反馈意见以便我们提供更好的帮助"></textarea>
							</div>
						</div>
					</div>
				</li>
				<li id="registerTel">
					<div class="item-content">
						<div class="item-inner" style="margin-left: 0; padding: 0.75rem 0;">
							<div class="item-input">
								<input id="mem_msg" type="text" class="font-75 color-fff" placeholder="手机号码或QQ号码(建议填写)" />
							</div>
						</div>
					</div>
				</li>
			</ul>
		</div>
	</div>
</div>
<script>
	
</script>