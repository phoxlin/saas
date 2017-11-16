<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="popup popup-interact">
	<header class="bar bar-nav">
        <i class="pull-left icon icon-left"  onclick="closePopup('.popup-interact');"></i>
		<h1 class="title">健身圈</h1>
		<i class="pull-right icon icon-edit color-basic" onclick="showQUanQUan();"></i>
	</header>
	<div class="content" id="interact_content">
	</div>
</div>
<script type="text/javascript">
	function showQUanQUan(){
		$("#image_quanquan_div").html("");
		openPopup(".popup-addInteract");
		
	}
</script>
