<%@page language="java" pageEncoding="UTF-8"%>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);
%>

<div class="popup friend">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.friend');"></a>
		<h1 class="title">朋友</h1>
	</header>
	<div class="content" id="popup-sets-scroll" style="">
		<div class="content-inner">
			<div class="list-block" style="margin-top: 0;">
				<ul>
					<li class="item-content " data-popup=".popup-about">
						<div class="item-inner">
							<div class="item-title">功能开发中，敬请期待！</div>
							<div class="item-after"></div>
						</div>
					</li>
				</ul>
			</div>
		</div>
	</div>
</div>