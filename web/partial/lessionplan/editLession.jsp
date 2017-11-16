<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.db.Entity"%>
<%@page import="com.jinhua.server.tools.UI"%>
<%@page import="com.jinhua.server.tools.UI_Op"%>
<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%

	FitUser user=(FitUser)SystemUtils.getSessionUser(request, response);
	if(user==null){ request.getRequestDispatcher("/").forward(request, response);}
	String gym = user.getViewGym();
	Entity f_plan=(Entity)request.getAttribute("f_plan");
	Entity f_emp=(Entity)request.getAttribute("f_emp");
	boolean hasF_plan=f_plan!=null&&f_plan.getResultCount()>0;
	boolean hasf_emp=f_emp!=null&&f_emp.getResultCount()>0;
	String content = "";
	String isFree1 = "";
	String isFree2 = "";
	String state1 = "";
	String state2 = "";
	String experience1 = "";
	String experience2 = "";
	String recommendLesson1= "";
	String recommendLesson2 = "";
	if(hasF_plan){
		content = f_plan.getStringValue("content");
	if("Y".equals(f_plan.getStringValue("is_free"))){
		isFree1 = "selected = 'selected'";
	}
	if("N".equals(f_plan.getStringValue("is_free"))){
		isFree2 = "selected = 'selected'";
	}
	if("001".equals(f_plan.getStringValue("state"))){
		state1 = "selected = 'selected'";
	}
	if("002".equals(f_plan.getStringValue("state"))){
		state2 = "selected = 'selected'";
	}
	if("Y".equals(f_plan.getStringValue("experience"))){
		experience1 = "selected = 'selected'";
	}
	if("N".equals(f_plan.getStringValue("experience"))){
		experience2 = "selected = 'selected'";
	}
	if("Y".equals(f_plan.getStringValue("recommend_lesson"))){
		recommendLesson1 = "selected = 'selected'";
	}
	if("N".equals(f_plan.getStringValue("recommend_lesson"))){
		recommendLesson2 = "selected = 'selected'";
	}
	}
%>

<!DOCTYPE html style="height: 100%;">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<script src="public/sb_admin2/bower_components/jquery/dist/jquery.min.js"></script>
<jsp:include page="/public/edit_base.jsp" />
<script type="text/javascript" charset="utf-8"
	src="public/ueditor/ueditor.config.js"></script>
<script type="text/javascript" charset="utf-8"
	src="public/ueditor/ueditor.all.min.js"> </script>
<!--建议手动加在语言，避免在ie下有时因为加载语言失败导致编辑器加载失败-->
<!--这里加载的语言文件会覆盖你在配置项目里添加的语言类型，比如你在配置项目里配置的是英文，这里加载的中文，那最后就是中文-->
<script type="text/javascript" charset="utf-8"
	src="public/ueditor/lang/zh-cn/zh-cn.js"></script>
<script src="public/js/store.js"></script>
<link type="text/css" href="partial/lessionplan/files/bootstrap.css" rel="stylesheet" media="screen">
<link type="text/css" href="partial/lessionplan/files/panel.css" rel="stylesheet" media="screen">
<link type="text/css" href="public/sb_admin2/bower_components/font-awesome/css/font-awesome.min.css" rel="stylesheet" media="screen">
<link type="text/css" href="public/fit/css/Base.css" rel="stylesheet" media="screen">
<link type="text/css" href="public/css/main.css" rel="stylesheet" media="screen">
<link rel="stylesheet" type="text/css" href="public/sb_admin2/bower_components/artDialog7/css/dialog.css">
<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/artDialog7/dialog.js"></script>
<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/artDialog7/dialog-plus.js"></script>
<script type="text/javascript">
</script>
<script type="text/javascript" src="partial/js/cashier.js"></script>
<script type="text/javascript">
	$(function(){
		//如果选择体验课程预约扣次，推荐课程，绑卡都可不选
		var tiYan = $("#experience").val();
		if(tiYan == "Y"){
			$("#is_free_div").hide();	
			$("#recommendLesson_div").hide();
			$("#card_names_div").hide();
			$("#is_free").prop('selectedIndex', 0);
			$("#recommendLesson").prop('selectedIndex', 0);
		}else {
			$("#is_free_div").show();
			$("#recommendLesson_div").show();
			$("#card_names_div").show();
		}
		//选择体验课，其他都无法选择
		$("#experience").change(function(){
			var tiYan = $("#experience").val();
			if(tiYan == "Y"){
				$("#is_free_div").hide();	
				$("#recommendLesson_div").hide();
				$("#card_names_div").hide();
				$("#is_free").prop('selectedIndex', 0);
				$("#recommendLesson").prop('selectedIndex', 0);
				$(":input[name='f_plan__card_names']").val("");
				
			}else {
				$("#is_free_div").show();
				$("#recommendLesson_div").show();
				$("#card_names_div").show();
			}
		});
		
	});
</script>

</head>
<body style="height: 100%;">
	<form action="" class="horizontal-form" style="height: 100%;overflow-y:auto;" id="f_planFormObj" method="post">
		<input type="hidden" id="f_plan__id" name="f_plan__id" value='<%=hasF_plan?f_plan.getStringValue("id"):""%>'/>
		<div class="form-group" style="font-weight: bold; border-bottom: 2px solid #eee; width: 800px; margin-left: 40px;">基本信息</div>
		<div class="form-group">
			<label><span class="required-field">*
			</span>课程名称</label>
			<div class="input">
				<input id="f_plan__plan_name" name="f_plan__plan_name" class="input-text"  style="width: 237px;" type="text" data-options="required:true,validType:'length[0,50]'" value='<%=hasF_plan?f_plan.getStringValue("plan_name"):""%>'/>
			</div>
		</div>
		<div class="form-group">
			<label>上课教练</label>
			<div class="input select-coach ctrl user-selector" style="width: 300px; height: 60px;">
				<img src="">
				<div onclick="getemps('coach')" id="choiceCoach" class="bind-container" style="padding-top: 10px;padding-left: 8px;">
							 <span class="bind-name" id="coachName"><%=hasf_emp?f_emp.getStringValue("name"):"点击选择教练"%></span>
							 <input type="hidden" id="f_plan__pt_id" name="f_plan__pt_id" value='<%=hasF_plan?f_plan.getStringValue("pt_id"):"1"%>'>
							  <span class="sub-title">教练</span>
							  <button>解绑</button>
						</div>
			</div>
			<div class="input">
				<p class="help-block">可不选，选择后教练可在手机上管理该课程的预约</p>
			</div>
		</div>
		<div class="form-group">
			<label>课程背景图片</label>
			<div class="input">
				<div class="image ctrl input-image">
					 <input id="f_plan__pic_url" name="f_plan__pic_url" type="hidden" value="<%=hasF_plan?f_plan.getStringValue("pic_url"):""%>"><a href="javascript:uploadFile('f_plan__pic_url','','');" class="btn btn-xs btn-default btn-block" style="width: 100px;">上传图片</a><div id="_f_plan__pic_url" name="_f_plan__pic_url"><a href='' target='_blank'><img src='?imageView2/1/w/50/h/50'></a></div>
					<div class="preview"></div>
				</div>
			</div>
		</div>
		<div class="form-group">
			<label>课程详情图片</label>
			<div class="input">
				<div class="image ctrl input-image">
					 <input id="f_plan__pic1" name="f_plan__pic1" type="hidden" value="<%=hasF_plan?f_plan.getStringValue("pic1"):""%>"><a href="javascript:uploadFile('f_plan__pic1','','');" class="btn btn-xs btn-default btn-block" style="width: 100px;">上传图片</a><div id="_f_plan__pic1" name="_f_plan__pic1"><a href='' target='_blank'><img src='?imageView2/1/w/50/h/50'></a></div>
					 <input id="f_plan__pic2" name="f_plan__pic2" type="hidden" value="<%=hasF_plan?f_plan.getStringValue("pic2"):""%>"><a href="javascript:uploadFile('f_plan__pic2','','');" class="btn btn-xs btn-default btn-block" style="width: 100px;">上传图片</a><div id="_f_plan__pic2" name="_f_plan__pic2"><a href='' target='_blank'><img src='?imageView2/1/w/50/h/50'></a></div>
					 <input id="f_plan__pic3" name="f_plan__pic3" type="hidden" value="<%=hasF_plan?f_plan.getStringValue("pic3"):""%>"><a href="javascript:uploadFile('f_plan__pic3','','');" class="btn btn-xs btn-default btn-block" style="width: 100px;">上传图片</a><div id="_f_plan__pic3" name="_f_plan__pic3"><a href='' target='_blank'><img src='?imageView2/1/w/50/h/50'></a></div>
					<div class="preview"></div>
				</div>
			</div>
		</div>
		<div class="form-group">
			<label>关键词</label>
			<div class="input">
				<input id="f_plan__labels" name="f_plan__labels" class="input-text"  style="width: 237px;" type="text" data-options="required:false,validType:'length[0,100]'" value='<%=hasF_plan?f_plan.getStringValue("labels"):""%>'/>
				<p class="help-block">如果存在多个关键字，请使用逗号隔开（关键字1，关键字2）</p>
			</div>
		</div>
		<div class="form-group">
			<label>上课地点</label>
			<div class="input">
			<input id="f_plan__addr_name" name="f_plan__addr_name" class="input-text"  style="width: 237px;" type="text" data-options="required:false,validType:'length[0,50]'" value='<%=hasF_plan?f_plan.getStringValue("addr_name"):""%>'/>
			</div>
		</div>
		<div class="form-group" style="font-weight: bold; border-bottom: 2px solid #eee; width: 800px; margin-left: 40px;">预约设置</div>
		<div class="form-group">
			<label>预约上限</label>
			<div class="input">
			<input id="f_plan__top_num" name="f_plan__top_num" class="input-text" style="width: 100px;" type="number" data-options="precision:0,required:false" value='<%=hasF_plan?f_plan.getStringValue("top_num"):""%>' maxlength="4"/>
			<span class="input-word">人</span>
				<p class="help-block">选填，若不填则表示不限制预约数量</p>
			</div>
		</div>
		<div class="form-group">
			<label>开课人数</label>
			<div class="input">
				<span class="input-word-before">预约人数大于等于</span>
				<input id="f_plan__start_num" name="f_plan__start_num" class="input-text" style="width: 110px;" type="number" data-options="precision:0,required:false" value='<%=hasF_plan?f_plan.getStringValue("start_num"):""%>' maxlength="4"/>
				<span class="input-word">人，则开课</span>
				<p class="help-block">
					选填，若不填则表示无论预约人数总是开课<br> 若填写，则会在课程开始时判断人数是否足够，如果不够则取消该课程并自动通知已预约会员
				</p>
			</div>
		</div>
		<div class="form-group" id="experience_div">
			<label>体验课程</label>
			<div class="input">
				<select name="experience" id="experience" class="select width-100">
					<option value="N" <%=experience2 %>>否</option>
					<option value="Y" <%=experience1 %>>是</option>
				</select>
				<p class="help-block">
					若选择是，则预约不扣次，且不能绑卡，仅作为体验课让会员免费体验<br> 若选择否，则预约可以绑卡扣次
				</p>

			</div>
		<div class="form-group" id="is_free_div">
			<label>推荐课程</label>
			<div class="input">
				<select name="recommendLesson" id="recommendLesson" class="select width-100">
					<option value="N" <%=recommendLesson2 %>>否</option>
					<option value="Y" <%=recommendLesson1 %>>是</option>
				</select>
				<p class="help-block">
					选择推荐则在APP上推荐此课程
				</p>
				
			</div>
		</div>
		</div>
		<div class="form-group" id="recommendLesson_div">
			<label>预约扣次</label>
			<div class="input">
				<select name="is_free" id="is_free" class="select width-100">
					<option value="N" <%=isFree2 %>>否</option>
					<option value="Y" <%=isFree1 %>>是</option>
				</select>
			</div>
		</div>
		<div class="form-group" id="card_names_div">

			<label>选择绑卡</label>
			<div class="input">
			<%=UI.createSelectBySql("f_plan__card_names", "SELECT id as code ,CARD_NAME as note FROM f_card WHERE GYM='"+gym+"' AND CARD_TYPE='006'", hasF_plan?f_plan.getStringValue("card_names"):"",false,"{'style':'width:164px'}") %>	
				<p class="help-block">
					若为空，则所有人可预约<br> 若选择卡，会在预约时要求必须持用此私教卡
				</p>
			</div>
		</div>
		<div class="form-group">
			<label>简介</label>
			<div class="input">
			<input id="f_plan__summary" name="f_plan__summary" class="easyui-validatebox"  style="width: 400px;" type="text" data-options="required:false,validType:'length[0,400]'" value='<%=hasF_plan?f_plan.getStringValue("summary"):""%>'/>
				<p class="help-block">
					对课程简单的介绍
				</p>
			</div>
		</div>
		<div class="form-group" style="display: none">
			<label>内容类型</label>
			<div class="input">
				<select name="content_type" class="select width-100">
					<option value="0">图文内容</option>
					<option value="1">站外链接</option>
				</select>
			</div>
		</div>
		<div class="form-group">
			<label>图文内容</label>
			<div style="margin-left: 172px;">
			<%=UI.createEditor("f_plan__content",hasF_plan?f_plan.getStringValue("content"):"",false,new UI_Op("width:99%;height:150px;","")) %>
			</div>
		</div>
		
	</form>
	<script type="text/javascript">
	function getemps(type){
		  var typeName="员工";
		  if("sales" == type){
			  typeName ="会籍";
		  }else if("coach" == type){
			  typeName ="教练";
		  }
		 top.dialog({
		        url: "partial/chioceEmp.jsp?userType="+type,
		        title: "选择"+typeName,
		        width: 820,
		        height: 550,
		        okValue: "确定",
		        ok: function() {
		        	var iframe = $(window.parent.document).contents().find("[name=" + top.dialog.getCurrent().id + "]")[0].contentWindow;
		            iframe.saveId(this);
		           var coach = store.getJson("coach");
		        	   $("#coachName").html(coach.name);
		        	   $("#f_plan__pt_id").val(coach.id);
		           store.set('coach',{});
		            return false;
		        },
		        cancelValue:"取消",
		        cancel:function(){
		        	return true;
		        }
		    }).showModal();
	}
	
	</script>
	
</body>
</html>