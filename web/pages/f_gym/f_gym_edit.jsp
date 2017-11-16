<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.db.impl.EntityImpl"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.jinhua.server.db.DBUtils"%>
<%@page import="com.jinhua.server.db.impl.DBM"%>
<%@page import="com.jinhua.server.db.IDB"%>
<%@page import="com.jinhua.server.db.Entity"%>
<%@page import="com.jinhua.server.tools.UI"%>
<%@page import="com.jinhua.server.tools.UI_Op"%>
<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	FitUser user = (FitUser)SystemUtils.getSessionUser(request, response);
	if (user == null) {
		request.getRequestDispatcher("/").forward(request, response);
	}
	Entity f_gym = (Entity) request.getAttribute("f_gym");
	boolean hasF_gym = f_gym != null && f_gym.getResultCount() > 0;
	
	IDB db = new DBM();
	Connection conn = null;
	Entity emp = null;
	Entity en = null;
	try{
		conn = db.getConnection();
		if(hasF_gym){
			emp = new EntityImpl("f_emp",conn);
			emp.setValue("id", f_gym.getStringValue("id"));
			emp.search();
		}
		en = new EntityImpl("f_gym",conn);
		int s = en.executeQuery("select * from f_gym where cust_name =? and gym = ?",new Object[]{f_gym.getStringValue("cust_name"),f_gym.getStringValue("cust_name")});
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBUtils.freeConnection(conn);
	}
	
%>
<!DOCTYPE HTML>
<html style="height: 100%;">
<head>
<jsp:include page="/public/edit_base.jsp" />
<script type="text/javascript">
	var entity = "f_gym";
	var form_id = "f_gymFormObj";
	var lockId = new UUID();
	$(document).ready(function() {

		//insert js

	});
</script>
<script type="text/javascript" charset="utf-8" src="pages/f_gym/f_gym.js"></script>
</head>
<body style="height: 100%;">
	<div style="height: 100%; overflow-y: auto">
		<form class="l-form" id="f_gymFormObj" name="f_gymFormObj" method="post">
			<input id="f_gym__id" name="f_gym__id" type="hidden" value='<%=hasF_gym ? f_gym.getStringValue("id") : ""%>' /> <input id="f_gym__cust_name" name="f_gym__cust_name" type="hidden" value='<%=hasF_gym ? f_gym.getStringValue("cust_name") : ""%>' /> 
			<ul>
				<li style="width: 90px; text-align: left;">门店名(*)：</li>
				<li style="width: 170px; text-align: left;">
					<div class="l-text" style="width: 168px;">
						<input id="f_gym__gym_name" name="f_gym__gym_name" class="easyui-validatebox" style="width: 164px;" type="text" data-options="required:true,validType:'length[0,100]'" value='<%=hasF_gym ? f_gym.getStringValue("gym_name") : ""%>' />
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
				
				<%if(!"gym".equals(request.getParameter("addType"))){ %>
				
				<li style="width: 90px; text-align: left;">门店代码(*)：</li>
				<li style="width: 170px; text-align: left;">
					<div class="l-text" style="width: 168px;">
						<input id="f_gym__gym" name="f_gym__gym" class="easyui-validatebox" <%=(!"add".equals(request.getParameter("type")))?("readonly='readonly'"):"" %>  style="width: 164px;" type="text" data-options="required:true,validType:'length[0,100]'" value='<%=hasF_gym ? f_gym.getStringValue("gym") : ""%>' />
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<%} %>
			</ul>
			<%if(!"gym".equals(request.getParameter("addType")) && "sm".equals(user.getState())){ %>
			<ul>
				<li style="width: 90px; text-align: left;">管理员账号(*)：</li>
				<li style="width: 170px; text-align: left;">
					<div class="l-text" style="width: 168px;">
						<input id="f_gym__login_name" name="f_gym__login_name" class="easyui-validatebox" style="width: 164px;" type="text" data-options="required:true,validType:'length[0,100]'" value='<%=emp == null ?"":emp.getStringValue("login_name") %>' />
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
				
				<li style="width: 90px; text-align: left;">密码(*)：</li>
				<li style="width: 170px; text-align: left;">
					<div class="l-text" style="width: 168px;">
						<input type="hidden" name="addType" value="<%=request.getParameter("addType")%>">
						<input id="f_gym__pwd" name="f_gym__pwd" class="easyui-validatebox" style="width: 164px;" type="password" data-options="required:true,validType:'length[0,100]'" value='<%=emp == null ?"":emp.getStringValue("pwd") %>' />
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
			</ul>
			<%}else{ %>

			<%} %>
			<ul>
				<li style="width: 40px;"></li>
				<li style="width: 90px; text-align: left; margin-left: -39px;">图片：</li>
				<li style="width: 170px; text-align: left;">
					<div class="l-text" style="width: 168px;">
						<input id="f_gym__logo_url" name="f_gym__logo_url" type="hidden" value="<%=hasF_gym ? f_gym.getStringValue("logo_url") : ""%>"><a href="javascript:uploadFile('f_gym__logo_url','','');" class="btn btn-xs btn-default btn-block" style="width: 100px;">上传文件</a>
						<div id="_f_gym__logo_url" name="_f_gym__logo_url">
							<a href='' target='_blank'><img src='?imageView2/1/w/50/h/50'></a>
						</div>
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
				<li style="width: 90px; text-align: left;">背景图：</li>
				<li style="width: 170px; text-align: left;">
					<div class="l-text" style="width: 168px;">
						<input id="f_gym__background_url" name="f_gym__background_url" type="hidden" value="<%=hasF_gym ? f_gym.getStringValue("background_url") : ""%>"><a href="javascript:uploadFile('f_gym__background_url','','');" class="btn btn-xs btn-default btn-block" style="width: 100px;">上传文件</a>
						<div id="_f_gym__background_url" name="_f_gym__background_url">
							<a href='' target='_blank'><img src='?imageView2/1/w/50/h/50'></a>
						</div>
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>

			</ul>

			<ul>
				<li style="width: 90px; text-align: left;">俱乐部宣传语：</li>
				<li style="width: 470px; text-align: left;">
					<div class="l-text" style="width: 468px; height: 60px;">
						<textarea id="f_gym__awords" name="f_gym__awords" class="easyui-validatebox" style="width: 464px; height: 50px;" data-options="required:false,validType:'length[0,400]'" placeholder="填写介绍本俱乐部特色或宣传口号"><%=hasF_gym ? f_gym.getStringValue("awords") : ""%></textarea>
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
			</ul>
			<ul>
				<li style="width: 90px; text-align: left;">地址：</li>
				<li style="width: 470px; text-align: left;">
					<div class="l-text" style="width: 468px;">
						<input id="f_gym__addr" name="f_gym__addr" class="easyui-validatebox" style="width: 464px;" type="text" data-options="required:false,validType:'length[0,200]'" value='<%=hasF_gym ? f_gym.getStringValue("addr") : ""%>' />
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
			</ul>
			<ul>
				<li style="width: 90px; text-align: left;">电话：</li>
				<li style="width: 170px; text-align: left;">
					<div class="l-text" style="width: 168px;">
						<input id="f_gym__phone" name="f_gym__phone" class="easyui-validatebox" style="width: 164px;" type="text" data-options="required:false,validType:'length[0,20]'" value='<%=hasF_gym ? f_gym.getStringValue("phone") : ""%>' />
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
				<li style="width: 90px; text-align: left;">百度地图坐标：</li>
				<li style="width: 170px; text-align: left;">
					<div class="l-text" style="width: 168px;">
						<input id="f_gym__baidu_addr" name="f_gym__baidu_addr" class="easyui-validatebox" style="width: 164px;" type="text" data-options="required:false,validType:'length[0,50]'" value='<%=hasF_gym ? f_gym.getStringValue("baidu_addr") : ""%>' />
						<div class="l-text-l"></div>
						<div class="l-text-r"></div>
					</div>
				</li>
				<li style="width: 40px;"></li>
			</ul>
			<%if("sm".equals(user.getState())){ %>
				<ul>
					<li style="width: 90px; text-align: left;">累计短信条数：</li>
					<li style="width: 170px; text-align: left;">
						<div class="l-text" style="width: 168px;">
							<input id="f_gym__total_sms_num" name="f_gym__total_sms_num" class="easyui-numberbox" style="width: 164px;" type="text" data-options="precision:0,required:false" value='<%=hasF_gym ? en.getStringValue("total_sms_num") : ""%>' />
							<div class="l-text-l"></div>
							<div class="l-text-r"></div>
						</div>
					</li>
					<li style="width: 40px;"></li>
					<li style="width: 90px; text-align: left;">剩余短信条数：</li>
					<li style="width: 170px; text-align: left;">
						<div class="l-text" style="width: 168px;">
							<input id="f_gym__remain_sms_num" name="f_gym__remain_sms_num" class="easyui-numberbox" style="width: 164px;" type="text" data-options="precision:0,required:false" value='<%=hasF_gym ? en.getStringValue("remain_sms_num") : ""%>' />
							<div class="l-text-l"></div>
							<div class="l-text-r"></div>
						</div>
					</li>
					<li style="width: 40px;"></li>
				</ul>
					<ul>
					<li style="width: 90px; text-align: left;">截止时间：</li>
					<li style="width: 170px; text-align: left;">
						<div class="l-text" style="width: 168px;">
							<%=UI.createDateTimeBox("f_gym__deadline",hasF_gym?en.getStringValue("deadline"):"",true,"width:164px;")%>
							<div class="l-text-l"></div>
							<div class="l-text-r"></div>
						</div>
					</li>
					<li style="width: 40px;"></li>
					<li style="width: 90px; text-align: left;">上次续费时间：</li>
					<li style="width: 170px; text-align: left;">
						<div class="l-text" style="width: 168px;">
							<%=UI.createDateTimeBox("f_gym__renew_time",hasF_gym?en.getStringValue("renew_time"):"",true,"width:164px;")%>
							<div class="l-text-l"></div>
							<div class="l-text-r"></div>
						</div>
					</li>
					<li style="width: 40px;"></li>
				</ul>
				<ul>
				<li style="width: 90px; text-align: left;">销售员：</li>
					<li style="width: 170px; text-align: left;">
						<div class="l-text" style="width: 168px;">
							<input id="" name="f_gym__sales_name" class="" style="width: 164px;" type="text" data-options="precision:0,required:false" value='<%=hasF_gym ? en.getStringValue("sales_name"): ""%>' />
							<div class="l-text-l"></div>
							<div class="l-text-r"></div>
						</div>
					</li>
					<li style="width: 40px;"></li>
				</ul>
			<%}else{ %>
				<ul>
					<li style="width: 90px; text-align: left;">累计短信条数：</li>
					<li style="width: 170px; text-align: left;">
						<div class="l-text" style="width: 168px;">
							<input id="" name="" class="easyui-numberbox" style="width: 164px;" disabled="disabled" type="text" data-options="precision:0,required:false" value='<%=hasF_gym ? en.getStringValue("total_sms_num") : ""%>' />
							<div class="l-text-l"></div>
							<div class="l-text-r"></div>
						</div>
					</li>
					<li style="width: 40px;"></li>
					<li style="width: 90px; text-align: left;">剩余短信条数：</li>
					<li style="width: 170px; text-align: left;">
						<div class="l-text" style="width: 168px;">
							<input id="" name="" class="easyui-numberbox" style="width: 164px;" disabled="disabled" type="text" data-options="precision:0,required:false" value='<%=hasF_gym ? en.getStringValue("remain_sms_num") : ""%>' />
							<div class="l-text-l"></div>
							<div class="l-text-r"></div>
						</div>
					</li>
					<li style="width: 40px;"></li>
				</ul>
				<ul>
					<li style="width: 90px; text-align: left;">截止时间：</li>
					<li style="width: 170px; text-align: left;">
						<div class="l-text" style="width: 168px;">
							<input id="" name="" class="" style="width: 164px;" disabled="disabled" type="text" data-options="precision:0,required:false" value='<%=hasF_gym ? en.getStringValue("deadline").substring(0, 16) : ""%>' />
							<div class="l-text-l"></div>
							<div class="l-text-r"></div>
						</div>
					</li>
					<li style="width: 40px;"></li>
					<li style="width: 90px; text-align: left;">上次续费时间：</li>
					<li style="width: 170px; text-align: left;">
						<div class="l-text" style="width: 168px;">
							<input id="" name="" class="" style="width: 164px;" disabled="disabled" type="text" data-options="precision:0,required:false" value='<%=hasF_gym ? en.getStringValue("renew_time").substring(0, 16)  : ""%>' />
							<div class="l-text-l"></div>
							<div class="l-text-r"></div>
						</div>
					</li>
					<li style="width: 40px;"></li>
				</ul>
				<ul>
				<li style="width: 90px; text-align: left;">销售员：</li>
					<li style="width: 170px; text-align: left;">
						<div class="l-text" style="width: 168px;">
							<input id="" name="" class="" style="width: 164px;" disabled="disabled" type="text" data-options="precision:0,required:false" value='<%=hasF_gym ? en.getStringValue("sales_name"): ""%>' />
							<div class="l-text-l"></div>
							<div class="l-text-r"></div>
						</div>
					</li>
					<li style="width: 40px;"></li>
				</ul>
			<%} %>
			
		</form>
	</div>
</body>
</html>