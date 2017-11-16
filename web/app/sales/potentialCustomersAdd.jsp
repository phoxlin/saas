<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-potentialCustomersAdd dark">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-potentialCustomersAdd');"></a>
		<h1 class="title">添加潜客</h1>
	</header>
	<nav class="bar bar-tab">
		<div class="row no-gutter">
			<div class="col-50 left-btn" onclick="closePopup('.popup-potentialCustomersAdd');">取消</div>
			<div class="col-50 right-btn" onclick="savePotentialCustomer()">保存</div>
		</div>
	</nav>
	<div class="content">
		<div class="list-block font-75 color-333" style="margin: 0;">
			<ul>
				<li>
					<div class="item-content">
						<div class="item-inner">
						<div class="item-media color-warn" style="width: 0.5rem;">*</div>
							<div class="item-title label color-999" style="width: 15%;">姓名</div>
							<div class="item-input">
								<input class="font-75" type="hidden" id="add_mem_from">
								<input class="font-75 color-fff" placeholder="请填写姓名" type="text" id="add_mem_name">
							</div>
						</div>
					</div>
				</li>
				<li>
					<div class="item-content">
						<div class="item-inner">
						<div class="item-media color-warn" style="width: 0.5rem;">*</div>
							<div class="item-title label color-999" style="width: 15%;">手机</div>
							<div class="item-input">
								<input class="font-75 color-fff" placeholder="请填写手机号码" type="text" id="add_phone">
							</div>
						</div>
					</div>
				</li>
				<li>
					<div class="item-content">
						<div class="item-inner">
						<div class="item-media color-warn" style="width: 0.5rem;">*</div>
							<div class="item-title label color-999" style="width: 15%;">性別</div>
							<div class="item-input">
								<select class="font-75 color-fff" id="add_sex" name="add_sex">
					                <option value="Male">男</option>
					                <option value="Female">女</option>
					              </select>
							</div>
						</div>
					</div>
				</li>
				     <li>
			        <div class="item-content">
			          <div class="item-inner">
			          <div class="item-media color-warn" style="width: 0.5rem;"></div>
			            <div class="item-title label color-999" style="width: 15%;">生日</div>
			            <div class="item-input">
			              <input type="text" placeholder="请选择生日" class="font-75 color-fff" id="add_birthday" name="add_birthday" readonly="readonly">
			            </div>
			          </div>
			        </div>
			      </li>
				<li>
					<div class="item-content item-link">
						<div class="item-inner">
						<div class="item-media color-warn" style="width: 0.5rem;"></div>
							<div class="item-title label color-999" style="width: 15%;">关注</div>
							<div class="item-input">
								<input class="font-75 color-fff" placeholder="请填写关注度" type="text" id="add_imp_level">
							</div>
						</div>
					</div>
				</li>
				<li>
					<div class="item-content item-link">
						<div class="item-inner">
						<div class="item-media color-warn" style="width: 0.5rem;"></div>
							<div class="item-title label color-999" style="width: 20%;">客户来源</div>
							<div class="item-input">
								<input class="font-75 color-fff" placeholder="请填写客户来源" type="text" id="add_source">
							</div>
						</div>
					</div>
				</li>
				<li class="align-top">
					<div class="item-content">
						<div class="item-inner">
						<div class="item-media color-warn" style="width: 0.5rem;"></div>
							<div class="item-title label color-999" style="width: 15%;">备注</div>
							<div class="item-input">
								<textarea id="add_remark" placeholder="请填写备注" class="font-75 color-fff"></textarea>
							</div>
						</div>
					</div>
				</li>
			</ul>
		</div>
	</div>
</div>
<script type="text/javascript">
var now = new Date().Format("yyyy-MM-dd");
$("#add_birthday").calendar({
    value: [now]
});
</script>
<script type="text/javascript">
	$("#add_imp_level").val('普通');
	$("#add_source").val('未选择');
	$(document).on('click', '#add_imp_level', function() {
		var buttons1 = [ {
			text : '请选择',
			label : true
		}, {
			text : '高关注',
			onClick : function() {
				$("#add_imp_level").val('高关注');
			}
		}, {
			text : '普通',
			onClick : function() {
				$("#add_imp_level").val('普通');
			}
		}, {
			text : '不维护',
			onClick : function() {
				$("#add_imp_level").val('不维护');
			}
		} ];
		var buttons2 = [ {
			text : '取消',
		} ];
		var groups = [ buttons1, buttons2 ];
		$.actions(groups);
	});
	$(document).on('click', '#add_source', function() {
		var buttons1 = [ {
			text : '请选择',
			label : true
		}, {
			text : 'WI-到访',
			onClick : function() {
				$("#add_source").val('WI-到访');
			}
		}, {
			text : 'APPT-电话邀约',
			onClick : function() {
				$("#add_source").val('WI-到访');
			}
		}, {
			text : 'BR-转介绍',
			onClick : function() {
				$("#add_source").val('WI-到访');
			}
		}, {
			text : 'TI-电话咨询',
			onClick : function() {
				$("#add_source").val('WI-到访');
			}
		}, {
			text : 'DI-拉访',
			onClick : function() {
				$("#add_source").val('DI-拉访');
			}
		}, {
			text : 'POS',
			onClick : function() {
				$("#add_source").val('POS');
			}
		}, {
			text : '场开',
			onClick : function() {
				$("#add_source").val('场开');
			}
		}, {
			text : '体测',
			onClick : function() {
				$("#add_source").val('体测');
			}
		}, {
			text : '续费',
			onClick : function() {
				$("#add_source").val('续费');
			}
		}, {
			text : '未选择',
			onClick : function() {
				$("#add_source").val('未选择');
			}
		} ];
		var buttons2 = [ {
			text : '取消',
		} ];
		var groups = [ buttons1, buttons2 ];
		$.actions(groups);
	});
</script>