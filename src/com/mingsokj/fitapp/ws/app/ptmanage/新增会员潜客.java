package com.mingsokj.fitapp.ws.app.ptmanage;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.utils.MemUtils;

public class 新增会员潜客 extends BasicAction {
	private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

	@Route(value = "/fit-app-action-queryMcAddNewAddMem", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void todayAddNewAddMem() throws Exception {

		String id = request.getParameter("id");
		String gym = request.getParameter("gym");
		String cust_name = request.getParameter("cust_name");
		String month = request.getParameter("month");

		Entity en = new EntityImpl(this);
		String sql = "select a.id,a.mem_name,a.phone,a.create_time,a.imp_level from f_mem_" + cust_name + " a where a.gym = ? and a.state='001' and a.mc_id = ? ";
		if (!"所有月份".equals(month)) {
			sql += " and   DATE_FORMAT(a.create_time, '%Y%m') = DATE_FORMAT('" + month + "-01', '%Y%m') ";
		}
		int size = en.executeQuery(sql, new Object[] { gym,id });
		if (size > 0) {
			List<Map<String, Object>> memList = en.getValues();
			for (int i = 0; i < size; i++) {
				Map<String, Object> xx = memList.get(i);
				if (xx.get("create_time") != null) {
					xx.put("create_time", sdf.format(xx.get("create_time")));
				}
				MemInfo m = MemUtils.getMemInfo(en.getStringValue("id", i), cust_name);
				if (m != null) {
					xx.put("mem_name", m.getName());
					xx.put("headurl", m.getWxHeadUrl());
				}
			}

			this.obj.put("data", memList);

		}

	}

	@Route(value = "/fit-app-action-queryMcAddNewAddQMem", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void todayAddPotentialCustomer() throws Exception {
		String id = request.getParameter("id");
		String gym = request.getParameter("gym");
		String cust_name = request.getParameter("cust_name");
		String month = request.getParameter("month");
		Entity en = new EntityImpl(this);

		String sql = "select a.id,a.mem_name,a.phone,a.create_time,a.imp_level from f_mem_" + cust_name + " a where a.gym = ? and a.state='003' and a.mc_id = ?";
		if (!"所有月份".equals(month)) {
			String start = month + "-01 00:00:00";
			Calendar cal = Calendar.getInstance();
			cal.setTime(sdf.parse(start));
			cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
			String end = sdf.format(cal.getTime()) + " 23:59:59";

			sql += " and a.create_time between '" + start + "' and '" + end + "'";
		}

		int size = en.executeQuery(sql, new Object[] {gym, id });
		List<Map<String, Object>> memList = en.getValues();
		for (int i = 0; i < size; i++) {
			Map<String, Object> xx = memList.get(i);
			if (xx.get("create_time") != null) {
				xx.put("create_time", sdf.format(xx.get("create_time")));
			}
			MemInfo m = MemUtils.getMemInfo(en.getStringValue("id", i), cust_name);
			if (m != null) {
				xx.put("mem_name", m.getName());
				xx.put("headurl", m.getWxHeadUrl());
			}
		}
		this.obj.put("data", memList);
	}
}
