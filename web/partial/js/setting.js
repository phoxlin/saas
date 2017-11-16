//短信设置
	function setMes() {
		var url = "pages/f_set/f_set_msg.jsp";
		dialog(
				{
					url : url,
					title : "短信提醒配置",
					width : 860,
					height : 600,
					okValue : "确定",
					ok : function() {
						var iframe = $(window.parent.document).contents().find(
								"[name=" + dialog.getCurrent().id + "]")[0].contentWindow;
						iframe.savaAddDialog(this, document, "f_mem");
						return false;
					},
					cancelValue : "取消",
					cancel : function() {
						return true;
					}
				}).showModal();
	}

	function doCashMore(win, doc, name) {
		var card_cash = $("#card_cash").val();
		var mend_card = $("#mend_card").val();
		var turn_card = $("#turn_card").val();
		var shift_card = $("#shift_card").val();
		$.ajax({
			url : "f_card_cash",
			type : "post",
			data : {
				card_cash : card_cash,
				mend_card : mend_card,
				turn_card : turn_card,
				shift_card : shift_card,
			},
			dataType : "json",
			success : function(data) {
				$.messager.progress('close');
				var result = "当前系统繁忙";
				if ("Y" == data.rs) {
					callback_info("保存成功", function() {
						win.close();
					});
				} else {
					error(result);
				}
			},
			error : function() {
				error("服务器异常，请稍后再试");
			}
		})

	}

	function setTimeCard() {
		var url = "pages/f_set/f_set_time_card.jsp";
		dialog(
				{
					url : url,
					title : "时间卡设置",
					width : 860,
					height : 540,
					okValue : "确定",
					ok : function() {
						var iframe = $(window.parent.document).contents().find(
								"[name=" + dialog.getCurrent().id + "]")[0].contentWindow;
						iframe.savaTimeCard(this, document, "f_mem");
						return false;
					},
					cancelValue : "取消",
					cancel : function() {
						return true;
					}
				}).showModal();
	}
	//合同管理
	function setContract() {
		var url = "pages/f_set/f_set_contract.jsp";
		dialog({
			url : url,
			title : "合同管理",
			width : 660,
			height : 350,
			okValue : "确定",
			ok : function() {
				return true;
			}
		}).showModal();
	}
	//私教课程设置
	function setPrivate() {
		var url = "pages/f_set/f_set_private_class.jsp";
		dialog(
				{
					url : url,
					title : "私教课程设置",
					width : 660,
					height : 350,
					okValue : "确定",
					ok : function() {
						var iframe = $(window.parent.document).contents().find(
								"[name=" + dialog.getCurrent().id + "]")[0].contentWindow;
						iframe.setPrivate(this, document);
						return false;
					}
				}).showModal();
	}
	//会员卡设置
	function setCard() {
		var url = "pages/f_set/f_set_card.jsp";
		dialog(
				{
					url : url,
					title : "会员卡设置",
					width : 850,
					height : 750,
					okValue : "确定",
					ok : function() {
						var iframe = $(window.parent.document).contents().find(
								"[name=" + dialog.getCurrent().id + "]")[0].contentWindow;
						iframe.setPrivate(this, document);
						return false;
					}
				}).showModal();
	}
	//押金设置
	function setCash() {
		var url = "pages/f_set/f_set_cash.jsp";
		dialog(
				{
					url : url,
					title : "押金设置",
					width : 660,
					height : 350,
					okValue : "确定",
					ok : function() {
						var iframe = $(window.parent.document).contents().find(
								"[name=" + dialog.getCurrent().id + "]")[0].contentWindow;
						iframe.doCashMore(this, document);
						return false;
					}
				}).showModal();
	}
	//积分设置
	function setPoints() {
		var url = "pages/f_set/f_set_points.jsp";
		dialog(
				{
					url : url,
					title : "积分设置",
					width : 660,
					height : 350,
					okValue : "确定",
					ok : function() {
						var iframe = $(window.parent.document).contents().find(
								"[name=" + dialog.getCurrent().id + "]")[0].contentWindow;
						iframe.savaSetPoints(this, document);
						return false;
					}
				}).showModal();
	}