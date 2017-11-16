<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-updatePotentialCustormer dark">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-updatePotentialCustormer');"></a>
		<h1 class="title">修改潜在客户</h1>
	</header>
	<div class="content">
		<div class="list-block font-75 color-333" style="margin: 0;">
			<input type="hidden" id="pc_id_detial">
			<ul>
				<li>
					<div class="item-content">
						<div class="item-inner">
							<div class="item-title label color-ccc">姓名</div>
							<div class="item-input">
								<input class="font-75 color-fff" type="text" id="pc_name_detial">
							</div>
						</div>
					</div>
				</li>
				<li>
					<div class="item-content">
						<div class="item-inner">
							<div class="item-title label color-ccc">手机</div>
							<div class="item-input">
								<input class="font-75 color-fff" type="text" id="pc_phone_detial">
							</div>
						</div>
					</div>
				</li>
				<li>
					<div class="item-content item-link">
						<div class="item-inner">
							<div class="item-title label color-ccc">关注</div>
							<div class="item-input">
								<input class="font-75 color-fff" type="text" id="pc_imp_level_detial" readonly="readonly">
							</div>
						</div>
					</div>
				</li>
				<li>
					<div class="item-content">
						<div class="item-inner">
							<div class="item-title label color-ccc">备注</div>
							<div class="item-input">
								<textarea class="font-75 color-fff" id="pc_remark_detial"></textarea>
							</div>
						</div>
					</div>
				</li>
			</ul>
		</div>
		<div class="content-block">
			<div class="row">
				<div class="col-50">
					<a href="#" class="button button-big button-fill button-default" onclick="closePopup('.popup-updatePotentialCustormer');">取消</a>
				</div>
				<div class="col-50">
					<a href="#" class="custom-btn custom-btn-primary button-fill color-333 font-90" onclick="updatePotentialCustoremer();">保存</a>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	$(document).on('click', '#pc_imp_level_detial', function() {
		var buttons1 = [ {
			text : '请选择',
			label : true
		}, {
			text : '高关注',
			onClick : function() {
				$("#pc_imp_level_detial").val('高关注');
			}
		}, {
			text : '普通',
			onClick : function() {
				$("#pc_imp_level_detial").val('普通');
			}
		}, {
			text : '不维护',
			onClick : function() {
				$("#pc_imp_level_detial").val('不维护');
			}
		} ];
		var buttons2 = [ {
			text : '取消',
		} ];
		var groups = [ buttons1, buttons2 ];
		$.actions(groups);
	});
	
</script>