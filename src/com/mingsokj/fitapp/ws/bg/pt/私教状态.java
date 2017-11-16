package com.mingsokj.fitapp.ws.bg.pt;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.m.FitUser;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.utils.MemUtils;

public class 私教状态 extends BasicAction {
	@Route(value = "/fit-ws-bg-pt-queryClassMems", conn = true, type = ContentType.JSON, m = HttpMethod.POST)
	public void queryClassMems() throws Exception {

		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String cust_name = user.getCust_name();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String now = sdf.format(new Date());

		String type = request.getParameter("type");
		String pt_id = request.getParameter("pt_id");
		String class_id = request.getParameter("class_id");
		String state =request.getParameter("state");
		
		Entity en = new EntityImpl(this);

		String sql = "";
		String db_state  = "";
	
		if ("s".equals(type)) {
			sql = "select a.start_time,a.end_time,a.state,a.mem_id from f_private_record_" + gym + " a where a.pt_id = ? and a.card_id = ? and a.state = ? and  TO_DAYS(a.op_time) = TO_DAYS(?)";
			if("start".equals(state)){
				db_state = "start";
			}else{
				db_state = "end";
			}
		} else {
			//sql = "select b.start_time,b.end_time,a.mem_id from f_order_" + gym + " a,f_class_record_"+gym+" b  where b.plan_detail_id = a.plan_list_id and a.emp_id = ? and a.plan_list_id = ? and a.state = ? and  TO_DAYS(a.start_time) = TO_DAYS(?)";
			sql = "select b.start_time,b.end_time,a.mem_id from f_order_" + gym + " a,f_class_record_"+gym+" b  where b.plan_detail_id = a.plan_list_id and a.emp_id = ? and a.plan_list_id = ? and a.state = ? and  TO_DAYS(a.start_time) = TO_DAYS(?)";
			
			if("start".equals(state)){
				db_state = "001";
			}else{
				db_state = "001";
			}
		}
		int s = en.executeQuery(sql, new Object[] { pt_id, class_id,db_state, now });
		if (s > 0) {
			 List<Map<String, Object>> list = en.getValues();
			for(int i=0;i<s;i++){
				String mem_id = en.getStringValue("mem_id",i); 
				String pic1 = en.getStringValue("pic1",i);
				MemInfo memInfo = MemUtils.getMemInfo(mem_id, cust_name, L);
				if(memInfo!=null){
					list.get(i).put("mem_name", memInfo.getName());
					list.get(i).put("sex", memInfo.getSex());
					list.get(i).put("gymName", memInfo.getGymName());
					if(Utils.isNull(pic1)){
						list.get(i).put("pic1", memInfo.getWxHeadUrl());
					}
				}
			}
			this.obj.put("list",list);
		}

	}

	@Route(value = "/fit-ws-bg-pt-state", conn = true, type = ContentType.JSON, m = HttpMethod.POST)
	public void pt_state() throws Exception {

		FitUser user = (FitUser) this.getSessionUser();
		String cust_name = user.getCust_name();
		String gym = user.getViewGym();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String now = sdf.format(new Date());
		String type = this.getParameter("type");

		Entity en = new EntityImpl(this);

		String cur = request.getParameter("cur");
		if (cur == null || cur.length() <= 0) {
			cur = "1";
		}

		int pageSize = 10;
		int curPage = Integer.parseInt(cur);
		int start = (curPage - 1) * pageSize + 1;
		int end = pageSize * curPage;

		// 第一步 查询所有教练
		String sql = "SELECT	a.* FROM	f_emp a,f_emp_gym b WHERE	a.id = b.fk_emp_id and b.cust_name = ? AND b.VIEW_GYM = ? and a.pt ='Y'";
		int s = en.executeQueryWithMaxResult(sql, new Object[] { cust_name, gym }, start, end);
		List<Map<String, Object>> list = en.getValues();
		for (int i = 0; i < list.size(); i++) {
			String id = list.get(i).get("id").toString();
			MemInfo emp = MemUtils.getMemInfo(id, cust_name);
			if(emp!=null){
				list.get(i).put("name", emp.getName());
			}
			
		}
		int total = en.getMaxResultCount();
		int totalpage = 0;
		int temp = total / pageSize;
		totalpage = total % pageSize > 0 ? temp + 1 : temp > 0 ? temp : 1;

		this.obj.put("list", list);

		this.obj.put("total", total);
		this.obj.put("totalPage", totalpage);
		this.obj.put("curPage", curPage);
		this.obj.put("curSize", list.size());

		if (s > 0) {
			this.obj.put("emps", en.getValues());
		}
		if("start".equals(type)){
			//查询正在上课的
			// 第二步 今天所有正在上私课的教练
			sql = " select a.pt_id,a.card_id,b.card_name from f_private_record_" + gym + " a,f_card b where a.card_id = b.id and a.state !='end' and TO_DAYS(a.op_time) = TO_DAYS(?) group by a.pt_id,a.card_id";
			s = en.executeQuery(sql, new Object[] { now });
			if (s > 0) {
				this.obj.put("privateEmps", en.getValues());
			} 
			// 第三步 今天所有正在上团课的教练
			sql = " select a.pt_id,a.plan_detail_id,b.plan_name from f_class_record_" + gym + " a,f_plan b where a.plan_id = b.id and a.state = '001'  and TO_DAYS(a.start_time) = TO_DAYS(?) ";
			s = en.executeQuery(sql, new Object[] { now });
			if (s > 0) {
				this.obj.put("groupEmps", en.getValues());
			}
		}else{
			//上完课了的
			// 第二步 今天所有正在上私课的教练
			sql = " select a.pt_id,a.card_id,b.card_name from f_private_record_" + gym + " a,f_card b where a.card_id = b.id and a.state ='end' and TO_DAYS(a.op_time) = TO_DAYS(?) group by a.pt_id,a.card_id";
			s = en.executeQuery(sql, new Object[] { now });
			if (s > 0) {
				this.obj.put("privateEmps", en.getValues());
			}
			// 第三步 今天所有正在上团课的教练
			sql = " select a.pt_id,a.plan_detail_id,b.plan_name,a.id from f_class_record_" + gym + " a,f_plan b where a.plan_id = b.id and a.state = '002' and TO_DAYS(a.start_time) = TO_DAYS(?)";
			s = en.executeQuery(sql, new Object[] { now });
			if (s > 0) {
				this.obj.put("groupEmps", en.getValues());
			}
		}
		
	}
}
