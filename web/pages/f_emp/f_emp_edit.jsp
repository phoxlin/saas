<%@page import="java.util.Map"%>
<%@page import="com.mingsokj.fitapp.m.MemInfo"%>
<%@page import="com.mingsokj.fitapp.utils.MemUtils"%>
<%@page import="com.mingsokj.fitapp.m.Gym"%>
<%@page import="com.jinhua.server.db.DBUtils"%>
<%@page import="com.jinhua.server.log.Logger"%>
<%@page import="com.jinhua.server.db.impl.EntityImpl"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.jinhua.server.db.impl.DBM"%>
<%@page import="com.jinhua.server.db.IDB"%>
<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.db.Entity"%>
<%@page import="com.jinhua.server.tools.UI"%>
<%@page import="com.jinhua.server.tools.UI_Op"%>
<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%

	FitUser user=(FitUser)SystemUtils.getSessionUser(request, response);
	if(user==null){ request.getRequestDispatcher("/").forward(request, response);}
	String cust_name = user.getCust_name();
	String gym = user.getViewGym();

	Entity f_emp=(Entity)request.getAttribute("f_emp");
	boolean hasF_emp=f_emp!=null&&f_emp.getResultCount()>0;
	
	String role = request.getParameter("role");
	
	IDB db = new DBM();
	List<String> powers = new ArrayList<String>();
	List<String> viewGyms = new ArrayList<String>();
	List<Gym> allGyms = new ArrayList<Gym>();
	
	Connection conn = null;
	Boolean hasEmp = false;
	Boolean hasBind = false;
	Entity emp = null;
	String mem_name = "";
	String nickname = "";
	String headurl = "";
	MemInfo mem = null;
	if(hasF_emp){
		mem = MemUtils.getMemInfo(f_emp.getStringValue("id"), f_emp.getStringValue("cust_name"));
	}
	List<Map<String,Object>> empsPt = new ArrayList<>();
	List<Map<String,Object>> empsMc = new ArrayList<>();
	List<String> subMcs = new ArrayList<>();
	List<String> subPts = new ArrayList<>();
	
	
	if(hasF_emp){
		try{
			conn = db.getConnection();
			allGyms = user.getMemInfo().getCust().viewGyms;
		}catch(Exception e){
			Entity g = new EntityImpl(conn);
			int s = g.executeQuery("select * from f_gym where cust_name = ?",new Object[]{user.getCust_name()});
			if(s>0){
				allGyms = new ArrayList<Gym>();
				for(int i=0;i<s;i++){
					Gym gg = new Gym();
					gg.gym = g.getStringValue("gym",i);
					gg.cust_name = g.getStringValue("cust_name",i);
					gg.gymName = g.getStringValue("gym_name",i);
					allGyms.add(gg);
				}
			}
		}
		//查询员工
		try{
			String emp_id = f_emp.getStringValue("id");
			Entity en = new EntityImpl(conn);
			int s = en.executeQuery("select * from f_emp_auth where cust_name = ? and gym = ? and emp_id = ?",new Object[]{cust_name,gym,emp_id});
			if(s >0){
				for(int i=0;i<s;i++){
					powers.add(en.getStringValue("auth",i));
				}
			}
			//查询头像 名称
			
			//可见会所
			s = en.executeQuery("select view_gym from f_emp_gym where fk_emp_id = ?",new Object[]{emp_id});
			if(s>0){
				for(int i=0;i<s;i++){
					viewGyms.add(en.getStringValue("view_gym",i));
				}
			}
			
			//查询员工下属
			if("Y".equals(f_emp.getStringValue("ex_mc")) || "Y".equals(f_emp.getStringValue("ex_pt"))){
				// 查询所有会籍 教练
				//String sql = "select emp.*,b.p_emp_id, b.type from ( SELECT a.* FROM f_emp a, f_emp_gym c WHERE a.id = c.fk_emp_id AND c.cust_name = '"+cust_name+"' AND c.view_gym = '"+gym+"' AND a.state = '002' AND a.mc = 'Y' AND a.ex_mc = 'N' AND a.sm = 'N' GROUP BY a.id )emp left join f_m_emp b ON emp.id = b.emp_id AND b.type ='MC' and b.gym = '"+gym+"'";
				String sql = "select emp.*,b.p_emp_id, b.type from ( SELECT a.* FROM f_emp a, f_emp_gym c WHERE a.id = c.fk_emp_id AND c.cust_name = '"+cust_name+"' AND c.view_gym = '"+gym+"' AND a.state = '002' AND a.mc = 'Y' GROUP BY a.id )emp left join f_m_emp b ON emp.id = b.emp_id AND b.type ='MC' and b.p_emp_id = '"+emp_id+"' and b.gym = '"+gym+"'";

				s = en.executeQuery(sql);
				if(s > 0){
					List<Map<String,Object>> list = en.getValues();
					int index = -1;
					for(int i=0;i<s;i++){
						if(f_emp.getStringValue("id").equals(en.getStringValue("id",i))){
							index = i;
						}
						MemInfo m = MemUtils.getMemInfo(en.getStringValue("id",i), cust_name);
						if(m!=null){
							list.get(i).put("name",m.getName());
						}
					}
					//除去自己
					if(index!= -1){
						list.remove(index);
					}
					empsMc.addAll(list);
				}
				//sql ="select emp.*,b.p_emp_id, b.type from ( SELECT a.* FROM f_emp a, f_emp_gym c WHERE a.id = c.fk_emp_id AND c.cust_name = '"+cust_name+"' AND c.view_gym = '"+gym+"' AND a.state = '002' AND a.pt = 'Y' AND a.ex_pt = 'N' AND a.sm = 'N' GROUP BY a.id )emp left join f_m_emp b ON emp.id = b.emp_id AND b.type ='PT' and b.gym = '"+gym+"'";
				sql ="select emp.*,b.p_emp_id, b.type from ( SELECT a.* FROM f_emp a, f_emp_gym c WHERE a.id = c.fk_emp_id AND c.cust_name = '"+cust_name+"' AND c.view_gym = '"+gym+"' AND a.state = '002' AND a.pt = 'Y' GROUP BY a.id )emp left join f_m_emp b ON emp.id = b.emp_id AND b.type ='PT' and  b.p_emp_id = '"+emp_id+"' and b.gym = '"+gym+"'";
				s = en.executeQuery(sql);
				if(s > 0){
					List<Map<String,Object>> list = en.getValues();
					int index = -1;
					for(int i=0;i<s;i++){
						if(f_emp.getStringValue("id").equals(en.getStringValue("id",i))){
							index = i;
						}
						MemInfo m = MemUtils.getMemInfo(en.getStringValue("id",i), cust_name);
						if(m!=null){
							list.get(i).put("name",m.getName());
						}
					}
					//除去自己
					if(index!= -1){
						list.remove(index);
					}
					empsPt.addAll(list);
				}
				
				//查询当前员工下属
				sql = "select emp_id,type from f_m_emp where cust_name = ? and gym = ? and p_emp_id = ?";
				s = en.executeQuery(sql, new Object[] { cust_name, gym, emp_id });
				if (s > 0) {
					for(int i=0;i<s;i++){
						String t = en.getStringValue("type",i);
						if("MC".equals(t)){
							subMcs.add(en.getStringValue("emp_id",i));
						}else{
							subPts.add(en.getStringValue("emp_id",i));
						}
					}
				}
			}
		}catch(Exception e){
			Logger.error(e);
		}finally{
			if(conn !=null){
				DBUtils.freeConnection(conn);
			}
		}
		
	}else{
		try{
			conn = db.getConnection();
			allGyms = user.getMemInfo().getCust().viewGyms;
		}catch(Exception e){
			Entity g = new EntityImpl(conn);
			int s = g.executeQuery("select * from f_gym where cust_name = ?",new Object[]{user.getCust_name()});
			if(s>0){
				allGyms = new ArrayList<Gym>();
				for(int i=0;i<s;i++){
					Gym gg = new Gym();
					gg.gym = g.getStringValue("gym",i);
					gg.cust_name = g.getStringValue("cust_name",i);
					gg.gymName = g.getStringValue("gym_name",i);
					allGyms.add(gg);
				}
			}
		}finally{
			if(conn !=null){
				DBUtils.freeConnection(conn);
			}
		}
	}
	
%>
<!DOCTYPE HTML>
<html>
 <head>
  <jsp:include page="/public/edit_base.jsp" />
  <script type="text/javascript">
    var entity = "f_emp";
    var form_id = "f_empFormObj";
    var lockId=new UUID();
    $(document).ready(function() {

    //insert js

    });
  </script>
<!--   <script type="text/javascript" charset="utf-8" src="pages/f_emp/f_emp.js"></script> -->
<script type="text/javascript" charset="utf-8" src="pages/f_emp/f_emp.js"></script>
 </head>
<body>
	<div style="width: 100%;height: 480px;overflow: auto">
	  <form class="l-form" id="f_empFormObj" method="post">
	    <input id="f_emp__id" name="f_emp__id" type="hidden" value='<%=hasF_emp?f_emp.getStringValue("id"):""%>'/>
	    <input id="f_emp__cust_name" name="f_emp__cust_name" type="hidden" value='<%=hasF_emp?f_emp.getStringValue("cust_name"):""%>'/>
	    <input id="f_emp__gym" name="f_emp__gym" type="hidden" value='<%=hasF_emp?f_emp.getStringValue("gym"):""%>'/>
	    <ul style="background-color: #f2f3f5;height: 50px">
	 		<li>
		 	   <h3>员工基本信息 </h3>
	 		</li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">姓名(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	         <%if(hasF_emp){ %>
	         	<%=mem.getName() %>
	         <%}else{ %>
	         	<input id="f_emp__mem_name" name="f_emp__mem_name" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:true,validType:'length[0,50]'" value=''/>
	         <%} %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      
	       <li style="width: 90px; text-align: left;">性别(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	         <%if(hasF_emp){ %>
	         	<%=mem.getSex() %>
	         <%}else{ %>
	            <%=UI.createSelect("f_emp__sex","PUB_C919",hasF_emp?mem.getSexCode():"",true,"{'style':'width:164px'}") %>
	         <%} %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	     <ul> 
	     <li style="width: 90px; text-align: left;">手机号(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	         <%if(hasF_emp){ %>
	         	<%=mem.getPhone() %>
	         <%}else{ %>
	          <input id="f_emp__phone" name="f_emp__phone" class="easyui-validatebox"  style="width: 164px;" type="number" data-options="required:true,validType:'length[0,50]'" value='<%=hasF_emp?mem.getPhone():""%>'/>
	         <%} %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	     <li style="width: 90px; text-align: left;">身份证(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	         <%if(hasF_emp){ %>
	         	<%=mem. getIdCard() %>
	         <%}else{ %>
	          <input id="f_emp__idCard" name="f_emp__idCard" class="easyui-validatebox"  style="width: 164px;" type="number" data-options="required:true,validType:'length[0,50]'" value='<%=hasF_emp?mem.getIdCard():""%>'/>
	         <%} %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	     </ul>
	    <ul> 
	    <li style="width: 90px; text-align: left;">登录名：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_emp__login_name" name="f_emp__login_name" class="easyui-validatebox"  style="width: 164px;" type="text" data-options="required:false,validType:'length[0,50]'" value='<%=hasF_emp?f_emp.getStringValue("login_name"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	       <li style="width: 90px; text-align: left;">状态(*)：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <%=UI.createSelect("f_emp__state","PUB_C201",hasF_emp?f_emp.getStringValue("state"):"002",true,"{'style':'width:164px'}") %>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	      <%-- <li style="width: 90px; text-align: left;">密码：</li>
       <li style="width: 170px; text-align: left;">
	        <div class="l-text" style="width: 168px;">
	          <input id="f_emp__pwd" name="f_emp__pwd" class="easyui-validatebox"  style="width: 164px;" type="password" data-options="required:true,validType:'length[0,50]'" value='<%=hasF_emp?f_emp.getStringValue("pwd"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li> --%>
	      
	    </ul>
	      <input id="f_emp__mc" name="f_emp__mc" type="hidden" value='<%=hasF_emp?f_emp.getStringValue("mc"):"N"%>'/>
	      <input id="f_emp__pt" name="f_emp__pt" type="hidden" value='<%=hasF_emp?f_emp.getStringValue("pt"):"N"%>'/>
	      <input id="f_emp__op" name="f_emp__op" type="hidden" value='<%=hasF_emp?f_emp.getStringValue("op"):"N"%>'/>
	      <input id="f_emp__ex_mc" name="f_emp__ex_mc" type="hidden" value='<%=hasF_emp?f_emp.getStringValue("ex_mc"):"N"%>'/>
	      <input id="f_emp__ex_pt" name="f_emp__ex_pt" type="hidden" value='<%=hasF_emp?f_emp.getStringValue("ex_pt"):"N"%>'/>
	    <ul>
	      <li style="width: 90px; text-align: left;">标签：</li>
       <li style="width: 470px; text-align: left;">
	        <div class="l-text" style="width: 468px;">
	          <input id="f_emp__labels" name="f_emp__labels" class="easyui-validatebox"  style="width: 464px;" type="text" data-options="required:false,validType:'length[0,100]'" value='<%=hasF_emp?f_emp.getStringValue("labels"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul style="background-color: #f2f3f5;height: 50px;display: none">
	 		<li>
		 	   <h3><%if("mc".equals(role)){ %>会籍<%}else if("pt".equals(role)){ %>教练<%}else if("ex".equals(role)){ %>主管<%} %>权限设置 </h3>
	 		</li>
	    </ul>
	    <input type="hidden" name="role" value="<%=role %>">
 		<%if("mc".equals(role)){ %>
 		<ul style="display: none">
	 		<li>
 				<label>
 					<input type="checkbox" name="power" <%if(powers.contains("mc_mem_maintain")){ %> checked="checked" <%} %> value="mc_mem_maintain">会员维护&nbsp;
 				</label>
	 		</li>
	 		<li>
 				<label>
 					<input type="checkbox" name="power"  <%if(powers.contains("mc_ready_mem_maintain")){ %> checked="checked" <%} %> value="mc_ready_mem_maintain">潜客维护
 				</label>
	 		</li>
	 		<li>
 				<label>
 					<input type="checkbox" name="power" <%if(powers.contains("mc_report") ){ %> checked="checked" <%} %> value="mc_report">我的报表
 				</label>
 			</li>
	 		<li>
 				<label>
 					<input type="checkbox" name="power" <%if(powers.contains("mc_salesRecord")){ %> checked="checked" <%} %> value="mc_salesRecord">销售记录
 				</label>
 			</li>
	 		<li>
 				<label>
 					<input type="checkbox" name="power" <%if(powers.contains("mc_mem_introduce")){ %> checked="checked" <%} %> value="mc_mem_introduce">会员转推荐
 				</label>
 			</li>
	 		<li>	
 				<label>
 					<input type="checkbox" name="power" <%if(powers.contains("mc_introduce_rank")){ %> checked="checked" <%} %> value="mc_introduce_rank">推荐排行
 				</label>
 			</li>
	 		<li>	
 				<label>
 					<input type="checkbox" name="power" <%if(powers.contains("mc_new_mem")){ %> checked="checked" <%} %> value="mc_new_mem">新入会
 				</label>
 			</li>
 			</ul>
	    <%}else if("pt".equals(role)){ %>
	    <ul style="display: none">
	    	<li>
 				<label>
 					<input type="checkbox" name="power" <%if(powers.contains("pt_mem_maintain")){ %> checked="checked" <%} %> value="pt_mem_maintain">学员维护
 				</label>
 			</li>
	 		<li>
 				<label>
 					<input type="checkbox" name="power"  <%if(powers.contains("pt_ready_mem_maintain")){ %> checked="checked" <%} %> value="pt_ready_mem_maintain">潜在学员
 				</label>
 			</li>
	 		<li>	
 				<label>
 					<input type="checkbox" name="power" <%if(powers.contains("pt_group_class")){ %> checked="checked" <%} %> value="pt_group_class">团操课
 				</label>
 			</li>
	 		<li>	
 				<label>
 					<input type="checkbox" name="power" <%if(powers.contains("pt_report")){ %> checked="checked" <%} %> value="pt_report">我的报表
 				</label>
 			</li>
	 		<li>	
 				<label>
 					<input type="checkbox" name="power" <%if(powers.contains("pt_new_mem")){ %> checked="checked" <%} %> value="pt_new_mem">新入会
 				</label>
 			</li>
 		</ul>
	    <%}else if("ex".equals(role)){ %>
	    	<%if(hasF_emp && "Y".equals(f_emp.getStringValue("ex_mc"))){ %>
				<ul style="display: none">
					 <li style="width: 90px; text-align: left;">会籍主管：</li>
					 <li>
		 				<label>
		 					<input type="checkbox" name="power"  <%if(powers.contains("ex_mc_manageMc")){ %> checked="checked" <%} %> value="ex_mc_manageMc">会员管理
		 				</label>
		 			</li>
			 		<li>
	 					<label>
	 						<input type="checkbox" name="power"  <%if(powers.contains("ex_mc_managePool")){ %> checked="checked" <%} %> value="ex_mc_managePool">潜客池管理
	 					</label>
	 				</li>
		 			<li>
		 				<label>
		 					<input type="checkbox" name="power" <%if(powers.contains("ex_mc_todaySales")){ %> checked="checked" <%} %> value="ex_mc_todaySales">今日售额
		 				</label>
		 			</li>
			 		<li>
		 				<label>
		 					<input type="checkbox" name="power"  <%if(powers.contains("ex_mc_salesReport")){ %> checked="checked" <%} %> value="ex_mc_salesReport">销售统计
		 				</label>
		 			</li>
 				</ul>
	    	<%}if(hasF_emp && "Y".equals(f_emp.getStringValue("ex_pt"))){ %>
	    		<ul style="display: none">
					 <li style="width: 90px; text-align: left;">教练主管：</li>
					 <li>
		 				<label>
		 					<input type="checkbox" name="power" <%if(powers.contains("ex_pt_managePt")){ %> checked="checked" <%} %> value="ex_pt_managePt">教练管理
		 				</label>
		 			</li>
			 		<li>
		 				<label>
		 					<input type="checkbox" name="power"  <%if(powers.contains("ex_pt_reduceClassRecord")){ %> checked="checked" <%} %> value="ex_pt_reduceClassRecord">消课记录
	 					</label>
 					</li>
			 		<li>
		 				<label>
		 					<input type="checkbox" name="power" <%if(powers.contains("ex_pt_managePool")){ %> checked="checked" <%} %> value="ex_pt_managePool">潜在学员池
		 				</label>
 					</li>
			 		<li>
		 				<label>
		 					<input type="checkbox" name="power" <%if(powers.contains("ex_pt_teamReport")){ %> checked="checked" <%} %> value="ex_pt_teamReport">团队业绩表
		 				</label>
 					</li>
				</ul>
	    	<%} %>
	    <%} %>
	    <%if(hasF_emp && ("Y".equals(f_emp.getStringValue("ex_mc")) || "Y".equals(f_emp.getStringValue("ex_pt"))) && ("all".equals(role) || "ex".equals(role))){ %>
	    <ul style="background-color: #f2f3f5;height: 50px">
	 		<li>
		 	   <h3>员工下属 </h3>
	 		</li>
	    </ul>
	    	<%if(hasF_emp && "Y".equals(f_emp.getStringValue("ex_mc"))){ %>
	      <ul>
	        <li style="width: 90px; text-align: left;">管理会籍：</li>
	        <%for(int i=0;i<empsMc.size();i++){
	        	/* if(!"Y".equals(Utils.getMapStringValue(empsMc.get(i), "mc"))){ */
	        	String p_emp_id = Utils.getMapStringValue(empsMc.get(i), "p_emp_id");
	        	if(!Utils.isNull(p_emp_id) && !p_emp_id.equals(f_emp.getStringValue("id"))){
	         		continue;
	         	}
	        %>
	        	<li><label>
 					<input type="checkbox" name="subMc" <%if(subMcs.contains(Utils.getMapStringValue(empsMc.get(i), "id"))){ %> checked="checked" <%} %> value="<%=Utils.getMapStringValue(empsMc.get(i), "id")%>"><%=Utils.getMapStringValue(empsMc.get(i), "name")%>
 				</label>
 				</li>
		    <%} %>
	      </ul>
	    
		    <%} %>
	    	<%if(hasF_emp && "Y".equals(f_emp.getStringValue("ex_pt"))){ %>
	      <ul>
	        <li style="width: 90px; text-align: left;">管理教练：</li>
	         <%for(int i=0;i<empsPt.size();i++){
	        	 String p_emp_id = Utils.getMapStringValue(empsPt.get(i), "p_emp_id");
	        	 if(!Utils.isNull(p_emp_id) && !p_emp_id.equals(f_emp.getStringValue("id"))){
	         		continue;
	         	}
	         %>
	        	<li><label>
 					<input type="checkbox" name="subPt" <%if(subPts.contains(Utils.getMapStringValue(empsPt.get(i), "id"))){ %> checked="checked" <%} %> value="<%=Utils.getMapStringValue(empsPt.get(i), "id")%>"><%=Utils.getMapStringValue(empsPt.get(i), "name")%>
 				</label>
 				</li>
		    <%} %>
	      </ul>
	    
		    <%} %>
	    <%} %>
	    <ul style="background-color: #f2f3f5;height: 50px">
	 		<li>
		 	   <h3>可见会所 </h3>
	 		</li>
	    </ul>
	    <ul>
			<%
				for(int i=0;i<allGyms.size();i++){ 			
					Gym g = allGyms.get(i);
 			%>
 				<li><label>
 					<input type="checkbox" name="viewGym" <%if(viewGyms.contains(g.gym)){ %> checked="checked" <%} %> value="<%=g.gym%>"><%=g.gymName%>
 				</label>
 				</li>
 			<%} %>
		</ul>
	    
	    <ul style="background-color: #f2f3f5;height: 50px">
	 		<li>
		 	   <h3>APP展示 </h3>
	 		</li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">简介：</li>
       <li style="width: 470px; text-align: left;">
	        <div class="l-text" style="width: 468px;">
	          <input id="f_emp__summary" name="f_emp__summary" class="easyui-validatebox"  style="width: 464px;" type="text" data-options="required:false,validType:'length[0,400]'" value='<%=hasF_emp?f_emp.getStringValue("summary"):""%>'/>
	          <div class="l-text-l"></div>
	          <div class="l-text-r"></div>
	        </div>
	      </li>
	      <li style="width: 40px;"></li>
	    </ul>
	    <ul>
	      <li style="width: 90px; text-align: left;">图文内容：</li>
       <li style="width: 470px;height: 260px; text-align: left;">
	        <div class="l-text" style="width: 468px;height: 260px;">
	          <%=UI.createEditor("f_emp__content",hasF_emp?f_emp.getStringValue("content"):"",false,new UI_Op("width:99%;height:250px;","")) %>
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