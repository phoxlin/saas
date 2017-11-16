package com.mingsokj.fitapp.ws.app.ptmanage;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.utils.MemUtils;

public class 下级员工今日销售 extends BasicAction {

	@Route(value = "/fit-app-action-todayPrivateClassSales", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void todayPrivateClassSales() throws Exception {
		String cust_name = request.getParameter("cust_name");
		String gym = request.getParameter("gym");
		String emp_id = request.getParameter("emp_id");
		String search = request.getParameter("search");

		Entity en = new EntityImpl("f_m_emp", this);
		en.setValue("p_emp_id", emp_id);
		en.setValue("type", "PT");
		en.setValue("cust_name", cust_name);
		en.setValue("gym", gym);
		int s = en.search();

		List<String> ids = new ArrayList<String>();
		if (s > 0) {
			for (int i = 0; i < s; i++) {
				ids.add(en.getStringValue("emp_id", i));
			}
		}
		ids.add(emp_id);
		// String sql = "select a.id
		// buy_id,a.pay_time,a.real_amt,b.times,b.card_name,c.name from
		// f_user_card_" + gym + " a,f_card b,f_emp c where a.card_id = b.id
		// and a.pt_id = c.id and TO_DAYS(a.pay_time) = TO_DAYS(now()) and
		// b.card_type='006' and a.pt_id in (" + Utils.getListString("?",
		// ids.size()) + ")";
		String sql = "select a.mem_id,a.id buy_id,a.pt_id,a.pay_time,a.real_amt,a.buy_times as times,b.card_name,d.mem_name,d.pic1 from f_user_card_" + gym + " a left join f_card b on a.card_id = b.id left join f_emp c on a.mc_id = c.id left join f_mem_" + cust_name + " d on a.mem_id = d.id where  TO_DAYS(a.pay_time) = TO_DAYS(now()) and b.card_type='006' and a.pt_id in (" + Utils.getListString("?", ids.size()) + ")";

		sql += " order by a.pay_time desc";
		s = en.executeQuery(sql, ids.toArray());
		if (s > 0) {
			// 查询员工的姓名
			List<Map<String, Object>> list = en.getValues();
			for (int i = 0; i < en.getValues().size(); i++) {
				String pt_id = en.getStringValue("pt_id", i);
				String mem_id = en.getStringValue("mem_id", i);
				// 会员姓名
				MemInfo memInfo = MemUtils.getMemInfo(mem_id, cust_name);
				if (memInfo != null) {
					list.get(i).put("mem_name", memInfo.getName());
				}
				//教练姓名
				MemInfo empInfo = MemUtils.getMemInfo(pt_id, cust_name);
				list.get(i).put("emp_name", empInfo.getName());
			}
			
			if (search != null && !"".equals(search)) {
				//sql += " and c.name like '%" + search + "%'";
				List<Map<String, Object>> l = new ArrayList<>();
				for(int i=0;i<list.size();i++){
					if(Utils.getMapStringValue(list.get(i), "mem_name").contains(search)){
						l.add(list.get(i));
					}
				}
				this.obj.put("list", l);
			}else{
				this.obj.put("list", list);
			}
			
		}
	}

	@Route(value = "/fit-app-action-todaySaleCards", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void todaySaleCards() throws Exception {
		String cust_name = request.getParameter("cust_name");
		String gym = request.getParameter("gym");
		String emp_id = request.getParameter("emp_id");
		String search = request.getParameter("search");

		Entity en = new EntityImpl("f_m_emp", this);
		en.setValue("p_emp_id", emp_id);
		en.setValue("type", "MC");
		en.setValue("cust_name", cust_name);
		en.setValue("gym", gym);
		int s = en.search();
		// 需要算上自己
		List<String> ids = new ArrayList<String>();
		if (s > 0) {
			for (int i = 0; i < s; i++) {
				ids.add(en.getStringValue("emp_id", i));
			}
		}
		ids.add(emp_id);
		// String sql = "select a.id
		// buy_id,a.pay_time,a.real_amt,b.times,b.card_name,c.name from
		// f_user_card_" + gym + " a,f_card b,f_emp c where a.card_id = b.id
		// and a.mc_id = c.id and TO_DAYS(a.pay_time) = TO_DAYS(now()) and
		// a.mc_id in (" + Utils.getListString("?", ids.size()) + ")";
		String sql = "select a.id buy_id,a.mc_id,a.pay_time,a.real_amt,b.times,b.card_name,a.mem_id from f_user_card_" + gym + " a left join f_card b on a.card_id = b.id left join f_emp c on a.mc_id = c.id left join f_mem_" + cust_name + " d on a.mem_id = d.id  where  TO_DAYS(a.pay_time) = TO_DAYS(now()) and a.mc_id in (" + Utils.getListString("?", ids.size()) + ")";
		if (search != null && !"".equals(search)) {
			sql += " and (d.mem_name like '%" + search + "%' or d.mem_name like '%" + search + "%')";
		}
		sql += " order by a.pay_time desc";
		s = en.executeQuery(sql, ids.toArray());
		if (s > 0) {
			// 查询员工的姓名
			List<Map<String, Object>> list = en.getValues();
			Object mcs[] = new Object[s];
			for (int i = 0; i < s; i++) {
				mcs[i] = en.getStringValue("mc_id", i);
			}
			for (int i = 0; i < en.getValues().size(); i++) {
				String id1 = en.getStringValue("mc_id", i);
				String mem_id = en.getStringValue("mem_id", i);
				MemInfo info = MemUtils.getMemInfo(id1, cust_name);
				MemInfo mem = MemUtils.getMemInfo(mem_id, cust_name);
				if (info != null) {
					list.get(i).put("emp_name", info.getName());
					list.get(i).put("headurl", info.getWxHeadUrl());

				}
				if (mem != null) {
					list.get(i).put("mem_name", mem.getName());
					list.get(i).put("memHeadurl", mem.getWxHeadUrl());
				}
			}
			this.obj.put("list", list);
		}

	}
}
