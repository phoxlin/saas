<%@page import="com.jinhua.server.db.Entity"%>
<%@page import="com.jinhua.server.tools.UI"%>
<%@page import="com.jinhua.server.tools.UI_Op"%>
<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	User user = SystemUtils.getSessionUser(request, response);
	if (user == null) {
		request.getRequestDispatcher("/").forward(request, response);
	}
	Entity f_mem = (Entity) request.getAttribute("f_mem");
	boolean hasF_mem = f_mem != null && f_mem.getResultCount() > 0;
	
%>
<!DOCTYPE HTML>
<html style="height: 100%;">
<head>
<jsp:include page="/public/edit_base.jsp" />
<script type="text/javascript">
	var entity = "f_mem";
	var form_id = "f_memFormObj";
	var lockId = new UUID();
	var nextpage="pages/f_mem/all_mem.jsp";
	$(document).ready(function() {

		//insert js

	});
	
</script>
<script type="text/javascript" charset="utf-8" src="pages/f_mem/f_mem.js"></script>
</head>
<body style="height: 100%;">
	<div style="height: 100%; overflow-y: auto;">
		<form class="l-form" id="f_memFormObj" method="post">
			<input id="f_mem__id" name="f_mem__id" style="display: none;" type="text" value='<%=hasF_mem ? f_mem.getStringValue("id") : ""%>' /> 
			<input id="f_mem__cust_name" name="f_mem__cust_name" type="text" style="display: none;" value='<%=hasF_mem ? f_mem.getStringValue("cust_name") : ""%>' /> 
			<input id="f_mem__gym" name="f_mem__gym" type="text" style="display: none;" value='<%=hasF_mem ? f_mem.getStringValue("gym") : ""%>' />
			<div class="page-header" style="border-bottom: 1px solid #eee; margin-bottom: 9px;">
				<h2>基本信息</h2>
			</div>
			<ul>
				<li style="width: 90px; text-align: left;">姓名(*)：</li>
				<li style="width: 470px; text-align: left;">
					<div class="l-text" style="width: 468px;">
						<input id="f_mem__mem_name" name="f_mem__mem_name" class="easyui-validatebox" style="width: 164px;" type="text" data-options="required:true,validType:'length[0,100]'" value='<%=hasF_mem ? f_mem.getStringValue("mem_name") : ""%>' />
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
			</ul>
			<ul>
				<li style="width: 90px; text-align: left;">手机号：</li>
				<li style="width: 470px; text-align: left;">
					<div class="l-text" style="width: 468px;">
						<input id="f_mem__phone" name="f_mem__phone" class="easyui-validatebox" style="width: 164px;" type="text" data-options="required:true,validType:'length[0,20]'" value='<%=hasF_mem ? f_mem.getStringValue("phone") : ""%>' />
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
			</ul>
			<ul>
				<li style="width: 90px; text-align: left;">性别：</li>
				<li style="width: 470px; text-align: left;">
					<div class="l-text" style="width: 468px;">
						<input id="f_mem__sex" name="f_mem__sex" class="easyui-validatebox" style="width: 164px;" type="text" data-options="required:true,validType:'length[0,20]'" value='<%=hasF_mem ? f_mem.getStringValue("sex") : ""%>' />
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
			</ul>
			<ul>
				<li style="width: 90px; text-align: left;">会员卡号：</li>
				<li style="width: 470px; text-align: left;">
					<div class="l-text" style="width: 468px;">
						<input id="f_mem__mem_no" name="f_mem__mem_no" class="easyui-validatebox" style="width: 164px;" type="text" data-options="required:true,validType:'length[0,100]'" value='<%=hasF_mem ? f_mem.getStringValue("mem_no") : ""%>' />
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
			</ul>
			<ul>
				<li style="width: 90px; text-align: left;">照片1：</li>
				<li style="width: 470px; text-align: left;">
					<div class="l-text" style="width: 468px;">
						<input id="f_mem__pic1" name="f_mem__pic1" class="easyui-validatebox" style="width: 164px;" type="text" data-options="required:true,validType:'length[0,200]'" value='<%=hasF_mem ? f_mem.getStringValue("pic1") : ""%>' />
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
			</ul>

			<div class="page-header" style="border-bottom: 1px solid #eee; clear: both; margin: 40px 0 20px 9px; text-align: left;">
				<h2>选填信息</h2>
			</div>

			<ul>
				<li style="width: 90px; text-align: left;">会员类型：</li>
				<li style="width: 470px; text-align: left;">
					<div class="l-text" style="width: 468px;">
						<input id="f_mem__user_type" name="f_mem__user_type" class="easyui-validatebox" style="width: 164px;" type="text" data-options="required:false,validType:'length[0,100]'" value='<%=hasF_mem ? f_mem.getStringValue("user_type") : ""%>' />
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
			</ul>
			<ul>
				<li style="width: 90px; text-align: left;">身份证号：</li>
				<li style="width: 470px; text-align: left;">
					<div class="l-text" style="width: 468px;">
						<input id="f_mem__id_card" name="f_mem__id_card" class="easyui-validatebox" style="width: 164px;" type="text" data-options="required:false,validType:'length[0,20]'" value='<%=hasF_mem ? f_mem.getStringValue("id_card") : ""%>' />
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
			</ul>
			<ul>
				<li style="width: 90px; text-align: left;">生日：</li>
				<li style="width: 470px; text-align: left;">
					<div class="l-text" style="width: 468px;">
						<input id="f_mem__birthday" name="f_mem__birthday" class="easyui-validatebox" style="width: 164px;" type="text" data-options="required:false,validType:'length[0,20]'" value='<%=hasF_mem ? f_mem.getStringValue("birthday") : ""%>' />
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
			</ul>
			<ul>
				<li style="width: 90px; text-align: left;">家庭住址：</li>
				<li style="width: 470px; text-align: left;">
					<div class="l-text" style="width: 468px;">
						<input id="f_mem__addr" name="f_mem__addr" class="easyui-validatebox" style="width: 164px;" type="text" data-options="required:false,validType:'length[0,200]'" value='<%=hasF_mem ? f_mem.getStringValue("addr") : ""%>' />
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
			</ul>
			<ul>
				<li style="width: 90px; text-align: left;">会籍：</li>
				<li style="width: 470px; text-align: left;">
					<div class="l-text" style="width: 468px;">
						<input id="f_mem__mc_id" name="f_mem__mc_id" class="easyui-validatebox" style="width: 164px;" type="text" data-options="required:false,validType:'length[0,24]'" value='<%=hasF_mem ? f_mem.getStringValue("mc_id") : ""%>' />
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
			</ul>
			<ul>
				<li style="width: 90px; text-align: left;">教练：</li>
				<li style="width: 470px; text-align: left;">
					<div class="l-text" style="width: 468px;">
						<input id="f_mem__pt_names" name="f_mem__pt_names" class="easyui-validatebox" style="width: 164px;" type="text" data-options="required:false,validType:'length[0,240]'" value='<%=hasF_mem ? f_mem.getStringValue("pt_names") : ""%>' />
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
			</ul>
			<ul>
				<li style="width: 90px; text-align: left;">备注：</li>
				<li style="width: 470px; text-align: left;">
					<div class="l-text" style="width: 468px; height: 60px;">
						<textarea id="f_mem__remark" name="f_mem__remark" class="easyui-validatebox" style="width: 99%; height: 50px;" data-options="required:false,validType:'length[0,65000]'"><%=hasF_mem ? f_mem.getStringValue("remark") : ""%></textarea>
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
			</ul>
			<ul>
				<li style="width: 90px; text-align: left;">会员登记时间：</li>
				<li style="width: 170px; text-align: left;">
					<div class="l-text" style="width: 168px;">
						<%=UI.createDateTimeBox("f_mem__create_time", hasF_mem ? f_mem.getStringValue("create_time") : "",
					false, "width:164px;")%>
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
				<li style="width: 90px; text-align: left;">状态(*)：</li>
				<li style="width: 170px; text-align: left;">
					<div class="l-text" style="width: 168px;">
						<input id="f_mem__state" name="f_mem__state" class="easyui-validatebox" style="width: 164px;" type="text" data-options="required:true,validType:'length[0,20]'" value='<%=hasF_mem ? f_mem.getStringValue("state") : ""%>' />
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
			</ul>
			<ul>
				<li style="width: 90px; text-align: left;">卡密码：</li>
				<li style="width: 470px; text-align: left;">
					<div class="l-text" style="width: 468px;">
						<input id="f_mem__ic_pwd" name="f_mem__ic_pwd" class="easyui-validatebox" style="width: 164px;" type="text" data-options="required:false,validType:'length[0,20]'" value='<%=hasF_mem ? f_mem.getStringValue("ic_pwd") : ""%>' />
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
			</ul>
			<ul>
				<li style="width: 90px; text-align: left;">介绍人：</li>
				<li style="width: 470px; text-align: left;">
					<div class="l-text" style="width: 468px;">
						<input id="f_mem__refer_mem_id" name="f_mem__refer_mem_id" class="easyui-validatebox" style="width: 164px;" type="text" data-options="required:false,validType:'length[0,24]'" value='<%=hasF_mem ? f_mem.getStringValue("refer_mem_id") : ""%>' />
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
			</ul>
			<ul>
				<li style="width: 90px; text-align: left;">重点会员：</li>
				<li style="width: 170px; text-align: left;">
					<div class="l-text" style="width: 168px;">
						<input id="f_mem__imp_level" name="f_mem__imp_level" class="easyui-numberbox" style="width: 164px;" type="text" data-options="precision:0,required:false" value='<%=hasF_mem ? f_mem.getStringValue("imp_level") : ""%>' />
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
				<li style="width: 90px; text-align: left;">健身频率：</li>
				<li style="width: 170px; text-align: left;">
					<div class="l-text" style="width: 168px;">
						<input id="f_mem__checkin_level" name="f_mem__checkin_level" class="easyui-validatebox" style="width: 164px;" type="text" data-options="required:false,validType:'length[0,20]'" value='<%=hasF_mem ? f_mem.getStringValue("checkin_level") : ""%>' />
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
			</ul>
			<ul>
				<li style="width: 90px; text-align: left;">健身时间：</li>
				<li style="width: 170px; text-align: left;">
					<div class="l-text" style="width: 168px;">
						<input id="f_mem__checkin_times" name="f_mem__checkin_times" class="easyui-validatebox" style="width: 164px;" type="text" data-options="required:false,validType:'length[0,20]'" value='<%=hasF_mem ? f_mem.getStringValue("checkin_times") : ""%>' />
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
				<li style="width: 90px; text-align: left;">是否需要停车：</li>
				<li style="width: 170px; text-align: left;">
					<div class="l-text" style="width: 168px;">
						<input id="f_mem__have_car" name="f_mem__have_car" class="easyui-validatebox" style="width: 164px;" type="text" data-options="required:false,validType:'length[0,20]'" value='<%=hasF_mem ? f_mem.getStringValue("have_car") : ""%>' />
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
			</ul>
			<ul>
				<li style="width: 90px; text-align: left;">主要需求：</li>
				<li style="width: 470px; text-align: left;">
					<div class="l-text" style="width: 468px; height: 55px;">
						<textarea id="f_mem__wants" name="f_mem__wants" class="easyui-validatebox" style="width: 99%; height: 50px;" data-options="required:false,validType:'length[0,400]'"><%=hasF_mem ? f_mem.getStringValue("wants") : ""%></textarea>
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
			</ul>
		</form>
	</div>
</body>
</html>