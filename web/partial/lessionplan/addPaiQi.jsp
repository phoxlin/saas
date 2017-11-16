<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.db.Entity"%>
<%@page import="com.jinhua.server.tools.UI"%>
<%@page import="com.jinhua.server.tools.UI_Op"%>
<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
	if (user == null) {
		request.getRequestDispatcher("/").forward(request, response);
	}

	Entity f_plan = (Entity) request.getAttribute("f_plan");
	boolean hasF_plan = f_plan != null && f_plan.getResultCount() > 0;
	String content = "";
%>
<!DOCTYPE html style="height: 100%;">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<base
	href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<script
	src="public/sb_admin2/bower_components/jquery/dist/jquery.min.js"></script>
<jsp:include page="/public/edit_base.jsp" />
<script type="text/javascript" charset="utf-8"
	src="public/ueditor/ueditor.config.js"></script>
<script type="text/javascript" charset="utf-8"
	src="public/ueditor/ueditor.all.min.js">
	
</script>
<!--建议手动加在语言，避免在ie下有时因为加载语言失败导致编辑器加载失败-->
<!--这里加载的语言文件会覆盖你在配置项目里添加的语言类型，比如你在配置项目里配置的是英文，这里加载的中文，那最后就是中文-->
<script type="text/javascript" charset="utf-8"
	src="public/ueditor/lang/zh-cn/zh-cn.js"></script>
<script src="public/js/store.js"></script>
<link type="text/css" href="partial/lessionplan/files/bootstrap.css"
	rel="stylesheet" media="screen">
<link type="text/css" href="partial/lessionplan/files/panel.css"
	rel="stylesheet" media="screen">
<link type="text/css" href="public/sb_admin2/bower_components/font-awesome/css/font-awesome.min.css" rel="stylesheet" media="screen">
<link type="text/css" href="public/fit/css/Base.css" rel="stylesheet" media="screen">
<link type="text/css" href="public/css/main.css" rel="stylesheet" media="screen">
<link rel="stylesheet" type="text/css"
	href="public/sb_admin2/bower_components/artDialog7/css/dialog.css">
<script type="text/javascript" charset="utf-8"
	src="public/sb_admin2/bower_components/artDialog7/dialog.js"></script>
<script type="text/javascript" charset="utf-8"
	src="public/sb_admin2/bower_components/artDialog7/dialog-plus.js"></script>
<script type="text/javascript">
	
</script>
<script type="text/javascript" src="partial/js/cashier.js"></script>
</head>
<body style="height: 100%;">
	<form action="" class="horizontal-form"
      style="height: 100%; overflow-y: auto;" id="plan_list"
      method="post">
    <div class="form-group">
        <label> <span class="required-field">*</span> 选择课程
        </label>
        <div class="input select-coach ctrl user-selector"
             style="width: 300px; height: 60px;">
            <img src="">
            <div class="bind-container" onclick="getemps('plan')" id="choiceCoach" style="padding-top: 10px;padding-left: 8px;">
                <span class="bind-name" id="planName">点击绑定课程</span> 
                <input type="hidden"id="f_plan__pt_id" name="f_plan__pt_id" > 
                <span class="sub-title">课程</span>
                <button>解绑</button>
            </div>
        </div>
    </div>
    <div class="form-group">
        <label> <span class="required-field">*</span> 起止日期
        </label>
        <div class="input">
            <input type="date" min="2017-07-14" max="2999-12-01"
                   name="start" class="input-text width-150" id="start"> <span
                style="display: inline-block; margin-top: 6px;">至</span> <input
                type="date" min="2017-07-14" max="2999-12-01" name="end"
                class="input-text width-150" id="end">
            <p class="help-block">该课程会在起止日期内，每周自动重复</p>
        </div>
    </div>

    <div class="form-group">
        <label><span class="required-field">*</span>课程时间</label>
        <div class="input syllabusGoupWeek ctrl table-basic gmy" id="table"
             style="margin-top: -28px;">
            <style>
                .gmy {
                    float: left;
                    width: 72%;
                    margin-left: 24px;
                }

                .gmy thead>tr {
                    height: auto;
                }

                .gmy tbody>tr {
                    height: auto;
                }

                .gmy table.table-list {
                    margin-bottom: 6px;
                }

                .gmy thead>thead>tr>td, .gmy .table-list>thead>tr>th {
                    line-height: 30px;
                    font-size: 12px;
                }

                .gmy td {
                    vertical-align: middle;
                    height: 33px;
                    min-width: 80px;
                    max-width: 300px;
                }

                .gmy td.align-right {
                    text-align: right;
                }

                .gmy td.align-center {
                    text-align: center;
                }

                .gmy .btn-sm:nth-of-type(1) {
                    margin-right: 4px !important;
                }

                .tianjia {

                }

                .tianjia .btn-sm {

                }

                .list-margin {
                    margin-top: 30px;
                }

                table.table-list tbody tr td {
                    text-align: center
                }

                table.table-list tbody tr:first-child td a.but-ts {
                    background-color: #C1C1C1;
                    color: #000000
                }

            </style>
            <div class="list" list-margin="">
                <label class="labelWeek" style="width: 55px;" onclick="choiceWeek('2')">
                    <input class="week-checkbox" type="checkbox" name="week"
                           weekday="2" id="choice2" value="2"><span class="week-checkbox-label">星期一</span></label>
                <label class="labelWeek" style="width: 55px;" onclick="choiceWeek('3')"><input
                        class="week-checkbox" type="checkbox" name="week" weekday="3" id="choice3" value="3"><span
                        class="week-checkbox-label">星期二</span></label><label class="labelWeek" style="width: 55px;" onclick="choiceWeek('4')"> <input
                    class="week-checkbox" type="checkbox" name="week" weekday="4" id="choice4" value="4"><span
                    class="week-checkbox-label">星期三</span></label><label class="labelWeek" style="width: 55px;" onclick="choiceWeek('5')"> <input
                    class="week-checkbox" type="checkbox" name="week" weekday="5" id="choice5" value="5"><span
                    class="week-checkbox-label">星期四</span></label><label class="labelWeek" style="width: 55px;" onclick="choiceWeek('6')"> <input
                    class="week-checkbox" type="checkbox" name="week" weekday="6" id="choice6" value="6"><span
                    class="week-checkbox-label">星期五</span></label><label class="labelWeek" style="width: 55px;" onclick="choiceWeek('7')"> <input
                    class="week-checkbox" type="checkbox" name="week" weekday="7" id="choice7" value="7"><span
                    class="week-checkbox-label">星期六</span></label><label class="labelWeek" style="width: 55px;" onclick="choiceWeek('1')"> <input
                    class="week-checkbox" type="checkbox" name="week" weekday="1" id="choice1" value="1"><span
                    class="week-checkbox-label">星期日</span></label> <br>
                <br>
                <table class="table table-list">
                    <thead>
                    <tr>
                        <th><strong>星期</strong></th>
                        <th><strong>开始时间</strong></th>
                        <th style="width: 20px"><strong>至</strong></th>
                        <th><strong>结束时间</strong></th>
                        <th><strong>操作</strong></th>
                    </tr>
                    </thead>
                    <tbody id="list_hang" class="list_item" name="mange">
                    <tr class="sbs2" style="display: none;">
                        <td key="0" style="font-size: 13px">星期一课程时间</td>
                        <td key="0"><input key="0" id="startTime2" value=""
                                           type="time" name="startTime2" class="input-text width-150"
                                           style="width: 110px; text-indent: 8px; text-align: center; font-size: 12px; line-height: 13px; vertical-align: middle; padding-top: 9px;"></td>
                        <td  key="0" style="font-size: 13px">至</td>
                        <td key="0"><input key="0"  value=""
                                           type="time" name="endTime2" id="endTime2" class="input-text width-150"
                                           style="width: 110px; text-indent: 9px; text-align: center; font-size: 12px; line-height: 13px; vertical-align: middle; padding-top: 9px;"></td>
                        <td key="0"><a class="but-ts"
                                       style="float: none;" key="0" onclick="getTime(2,2)">同上</a></td>
                    </tr>
                    <tr class="sbs3" style="display: none;">
                        <td  key="1" style="font-size: 13px">星期二课程时间</td>
                        <td  key="1"><input key="1" value="" id="startTime3"
                                            type="time" name="startTime3" class="input-text width-150"
                                            style="width: 110px; text-indent: 8px; text-align: center; font-size: 12px; line-height: 13px; vertical-align: middle; padding-top: 9px;"></td>
                        <td  key="1" style="font-size: 13px">至</td>
                        <td  key="1"><input key="1" value=""
                                            type="time" name="endTime3" id="endTime3" class="input-text width-150" 
                                            style="width: 110px; text-indent: 9px; text-align: center; font-size: 12px; line-height: 13px; vertical-align: middle; padding-top: 9px;"></td>
                        <td  key="1"><a class="but-ts"
                                        style="float: none;" key="1" onclick="getTime(3,3)">同上</a></td>
                    </tr>
                    <tr class="sbs4" style="display: none;">
                        <td  key="2" style="font-size: 13px" style="font-size: 13px">星期三课程时间</td>
                        <td  key="2"><input key="2" value="" id="startTime4"
                                            type="time" name="startTime4" class="input-text width-150"
                                            style="width: 110px; text-indent: 8px; text-align: center; font-size: 12px; line-height: 13px; vertical-align: middle; padding-top: 9px;"></td>
                        <td  key="2" style="font-size: 13px">至</td>
                        <td  key="2"><input key="2" value=""
                                            type="time" name="endTime4" id="endTime4" class="input-text width-150" 
                                            style="width: 110px; text-indent: 9px; text-align: center; font-size: 12px; line-height: 13px; vertical-align: middle; padding-top: 9px;"></td>
                        <td  key="2"><a class="but-ts"
                                        style="float: none;" key="2" onclick="getTime(4,4)">同上</a></td>
                    </tr>
                    <tr class="sbs5" style="display: none;">
                        <td  key="3" style="font-size: 13px">星期四课程时间</td>
                        <td  key="3"><input key="3" value="" id="startTime5"
                                            type="time" name="startTime5" class="input-text width-150"
                                            style="width: 110px; text-indent: 8px; text-align: center; font-size: 12px; line-height: 13px; vertical-align: middle; padding-top: 9px;"></td>
                        <td  key="3" style="font-size: 13px">至</td>
                        <td  key="3"><input key="3" value=""
                                            type="time" name="endTime5" id="endTime5" class="input-text width-150" 
                                            style="width: 110px; text-indent: 9px; text-align: center; font-size: 12px; line-height: 13px; vertical-align: middle; padding-top: 9px;"></td>
                        <td  key="3"><a class="but-ts"
                                        style="float: none;" key="3" onclick="getTime(5,5)">同上</a></td>
                    </tr>
                    <tr class="sbs6" style="display: none;">
                        <td  key="4" style="font-size: 13px" >星期五课程时间</td>
                        <td  key="4"><input key="4" value="" id="startTime6"
                                            type="time" name="startTime6" class="input-text width-150"
                                            style="width: 110px; text-indent: 8px; text-align: center; font-size: 12px; line-height: 13px; vertical-align: middle; padding-top: 9px;"></td>
                        <td  key="4" style="font-size: 13px">至</td>
                        <td  key="4"><input key="4" value=""
                                            type="time" name="endTime6" id="endTime6" class="input-text width-150"                                             style="width: 110px; text-indent: 9px; text-align: center; font-size: 12px; line-height: 13px; vertical-align: middle; padding-top: 9px;"></td>
                        <td  key="4"><a class="but-ts"
                                        style="float: none;" key="4" onclick="getTime(6,6)">同上</a></td>
                    </tr>
                    <tr class="sbs7" style="display: none;">
                        <td  key="5" style="font-size: 13px">星期六课程时间</td>
                        <td  key="5"><input key="5" value="" id="startTime7"
                                            type="time" name="startTime7" class="input-text width-150"
                                            style="width: 110px; text-indent: 8px; text-align: center; font-size: 12px; line-height: 13px; vertical-align: middle; padding-top: 9px;"></td>
                        <td  key="5" style="font-size: 13px">至</td>
                        <td  key="5"><input key="5" value="" id="endTime7"
                                            type="time" name="endTime7"  class="input-text width-150"
                                            style="width: 110px; text-indent: 9px; text-align: center; font-size: 12px; line-height: 13px; vertical-align: middle; padding-top: 9px;"></td>
                        <td  key="5"><a class="but-ts"
                                        style="float: none;" key="5" onclick="getTime(7,7)">同上</a></td>
                    </tr>
                    <tr class="sbs1" style="display: none;">
                        <td  key="6" style="font-size: 13px">星期日课程时间</td>
                        <td  key="6"><input key="6" value="" id="startTime1"
                                            type="time" name="startTime1" class="input-text width-150"
                                            style="width: 110px; text-indent: 8px; text-align: center; font-size: 12px; line-height: 13px; vertical-align: middle; padding-top: 9px;"></td>
                        <td  key="6" style="font-size: 13px">至</td>
                        <td  key="6"><input key="6" value="" id="endTime1"
                                            type="time" name="endTime1" class="input-text width-150"
                                            style="width: 110px; text-indent: 9px; text-align: center; font-size: 12px; line-height: 13px; vertical-align: middle; padding-top: 9px;"></td>
                        <td  key="6"><a class="but-ts"
                                        style="float: none;" key="6" onclick="getTime(1,1)">同上</a></td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</form>
	<script type="text/javascript">
		function getemps(type) {
			var typeName = "员工";
			if ("sales" == type) {
				typeName = "会籍";
			} else if ("coach" == type) {
				typeName = "教练";
			} else if ("plan" == type) {
				typeName = "团课";
			}
			top
					.dialog(
							{
								url : "partial/chioceEmp.jsp?userType=" + type,
								title : "选择" + typeName,
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
									var plan = store.getJson("plan");
									$("#planName").html(plan.name);
									$("#f_plan__pt_id").val(plan.id);
									store.set('coach', {});
									return false;
								},
								cancelValue : "取消",
								cancel : function() {
									return true;
								}
							}).showModal();
		}
		
	
	//选择课程时间
	function choiceWeek(num){
		var flag = $("#choice"+num).is(':checked');
		if(flag){
			$(".sbs"+num).show();
		}else{
			$(".sbs"+num).hide();
		}
		
	}
	
	function getTime(num,num2){
        var item = Number(num)-1;
        var id = ".sbs"+(item);
        var startTime = "";
        var endTime = "";
        //如果未被隐藏说明已经选择
        if(num2 == "1"){
        	item = Number(num)+1;
        	id = ".sbs"+(item);
        	if($(id).css("display")!='none'){
                startTime = ($("#startTime"+item).val())
                endTime = ($("#endTime"+item).val())
                $("#startTime"+num2).val(startTime);
                $("#endTime"+num2).val(endTime);
                return;
            }
        }
        if($(id).css("display")!='none'){
        	
            startTime = ($("#startTime"+item).val())
            endTime = ($("#endTime"+item).val())
            $("#startTime"+num2).val(startTime);
            $("#endTime"+num2).val(endTime);
            return;
        }
        
        else if(item<=0){
           return;
        }else{
            getTime(item,num2);
        }
    }

	</script>

</body>
</html>