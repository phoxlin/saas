<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<link rel="stylesheet" type="text/css" href="public/sb_admin2/bower_components/bootstrap/dist/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="partial/css/addMem.css">
<link rel="stylesheet" type="text/css" href="public/fit/css/btn.css">
<link rel="stylesheet" media="all" href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/public/sb_admin2/bower_components/bootstrap/dist/css/bootstrap.min.css" />
<link rel="stylesheet" media="all" href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/public/css/print.css" />
<script src="public/js/store.js"></script>
<script src="public/sb_admin2/bower_components/jquery/dist/jquery.min.js"></script>
<script type="text/javascript" charset="utf-8" src="public/js/template.js"></script>
<script type="text/javascript" charset="utf-8" src="partial/js/fingerPrint.js"></script>
<script type="text/javascript" src="public/js/jquery.PrintArea.js"></script>
<!-- 消息样式 -->
<link rel="stylesheet" type="text/css" href="public/message/css/messenger.css">
<link rel="stylesheet" type="text/css" href="public/message/css/messenger-theme-future.css">
<link rel="stylesheet" type="text/css" href="public/message/css/messenger-theme-ice.css">
<!-- 消息js -->
<script src="public/message/js/messenger.min.js"></script>
<script src="public/message/js/messenger-theme-future.js"></script>
<title>消次</title>
<script type="text/javascript">
<!--
	template.config({
		sTag : '<#', eTag: '#>'
	});
	//-->
	function getemps() {
		top.dialog(
						{
							url : "partial/chioceEmp.jsp?userType=coach",
							title : "选择教练",
							width : 820,
							height : 550,
							okValue : "确定",
							ok : function() {
								var iframe = $(window.parent.document)
										.contents()
										.find(
												"[name="
														+ top.dialog
																.getCurrent().id
														+ "]")[0].contentWindow;
								iframe.saveId(this);
								var coach = store.getJson("coach");
								var coachid = coach.id;
								if (coachid) {
									$("#coachName").html(coach.name);
									$("#coach").val(coach.id);
								}
								store.set('coach', {});
								return false;
							},
							cancelValue : "取消",
							cancel : function() {
								return true;
							}
						}).showModal();
	}
	
	var _win = null;
	var _window= null;
	var _fk_user_id = null;
	var _fk_card_id = null;
	var _fk_user_gym = null;
	var _type = null;
	var _times = null ;
	var _coach = null;
	var _remark = null;
	function reduceTimes(win, windowXX, fk_user_id, fk_card_id, fk_user_gym, type) {
		
		console.log(location.href);
		console.log(location.port);
		_win = win;
		_window = windowXX;
		_fk_user_id = fk_user_id;
		_fk_card_id = fk_card_id;
		_fk_user_gym = fk_user_gym;
		_type = type;
		
		var times = $("#times").val();
		var coach = $("#coach").val();
		if(!coach && type=="消课"){
			alert("请选择教练消课");
			return;
		}
		var remark = $("#remark").val();
		_times = times;
		_coach = coach;
		_remark = remark || "";
		$.ajax({
			type : "POST",
			url : "fit-cashier-query-gymSetByKey",
			data : {
				code:"private_class",
				key:"needFingerPrint"
			},
			dataType : "json",
			async : false,
			success : function(data) {
				if(data.rs == "Y"){
					var needFingerPrint = data.value;
					if(!needFingerPrint){
						needFingerPrint = "N";
					}
					//消课
					if(needFingerPrint=="Y"){
						validateFinger(fk_user_id,"needFingerPrint");
					}else{
						doReduceClass(win, _window, fk_user_id, fk_card_id, fk_user_gym, type);
					}
					
				}else{
					alert(data.rs);
				}
			}
		});

		
		

	}
	function needFingerPrint(code){
		if(code == "Y"){
			doReduceClass(_win, _window, _fk_user_id, _fk_card_id, _fk_user_gym, _type);
		}
	}
	
	function doReduceClass(win, windowX, fk_user_id, fk_card_id, fk_user_gym, type) {
		$.ajax({
			type : "POST",
			url : "fit-cashier-reduceTimes",
			data : {
				times : _times,
				coach : _coach,
				remark : _remark,
				fk_user_card_id : fk_card_id,
				fk_user_gym : fk_user_gym,
				fk_user_id : fk_user_id,
				type : type
			},
			dataType : "json",
			async : false,
			success : function(data) {
				if (data.rs == "Y") {

					var html = template($("#timesCardInPaper").html(), {flow : data.obj});
					$("#paper-print-div").html(html);
					var headElements = '<meta charset="utf-8" />,<meta http-equiv="X-UA-Compatible" content="IE=edge"/>';
					var options = {
						mode : "iframe",
						popClose : true,
						extraCss : "",
						retainAttr : [ "class", "style" ],
						extraHead : headElements
					};
					$("#paper-print-div").printArea(options);
					 setTimeout(function (){
							 windowX.location.reload();
					 		}, 2000 );
				} else {
					alert(data.rs);
				}
			}
		});
	}
</script>
</head>
<body>
	<div class="user-basic-info">
		<div class="container">
			<div class="col-xs-12">
				<div class="input-panel">
					<label>消费次数</label> <input type="number" id="times" value="1" />
				</div>
			</div>
			<div class="col-xs-12">
				<div class="input-panel">
					<label>所属教练</label>
					<div class="bind">
						<div class="col-xs-10" onclick="getemps()">
							<span class="sub-title" id="coachName">点击选择教练</span> <input type="hidden" id="coach" />
						</div>
					</div>
				</div>
			</div>
			<div class="col-xs-12">
				<p>备注信息</p>
				<div class="input-panel">
					<textarea placeholder="备注信息" id="remark"></textarea>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="/partial/piaoTpl.jsp"></jsp:include>
</body>
</html>