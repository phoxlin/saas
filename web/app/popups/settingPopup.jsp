<%@page language="java" pageEncoding="UTF-8"%>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);
%>

<div class="popup settingPopup">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left"  onclick="closePopup('.settingPopup');"></a>
		<h1 class="title">设置</h1>
	</header>

	<div class="content" id="popup-sets-scroll">
		<div class="content-inner">
			<div class="list-block" style="margin-top: 0;">
			    <ul>
			      <li class="item-content item-link open-popup"  data-popup=".popup-feedback">
			        <div class="item-inner">
			          <div class="item-title font-80">意见反馈</div>
			          <div class="item-after"></div>
			        </div>
			      </li>
			      <li class="item-content item-link open-popup" data-popup=".popup-about">
			        <div class="item-inner">
			          <div class="item-title font-80">关于我们</div>
			          <div class="item-after"></div>
			        </div>
			      </li>
				</ul>
			</div>
		  <div class="content-block-title" style="margin: 0;padding: 0;height: 0.2rem;"></div>
		  <div class="list-block" style="margin-top: 0;">
		    <ul>
		      <li class="item-content item-link"  onclick="unbundledWechatAccount();">
		        <div class="item-inner" style="margin-left: 6rem;background-image: none;">
		          <div class="item-title" style="color: red;">解绑并退出微信</div>
		        </div>
		      </li>
		    </ul>
		  </div>
		</div>
	</div>
</div>