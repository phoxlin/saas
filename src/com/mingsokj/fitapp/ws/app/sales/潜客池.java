package com.mingsokj.fitapp.ws.app.sales;

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

public class 潜客池 extends BasicAction {

	@Route(value = "/fit-app-action-showPotentialPool", slave = true, conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void showPotentialPool() throws Exception {
		String startStr = this.getParameter("start");
		String gym = this.getParameter("gym");
		String cust_name = this.getParameter("cust_name");
		String searchValue = this.getParameter("searchValue");

		int pageSize = 10;
		if ("".equals(startStr)) {
			startStr = "1";
		}
		int start = Integer.parseInt(startStr);
		int end = start + pageSize - 1;

		Entity en = new EntityImpl(this);
		String sql = "SELECT a.id,a.mem_name,a.phone,a.create_time,a.imp_level FROM f_mem_" + cust_name
				+ " a WHERE   a.gym=? and a.id NOT IN ( SELECT mem_id FROM f_user_card_" + gym
				+ " GROUP BY mem_id ) AND (MC_ID = '' OR MC_ID IS NULL)";
		if (searchValue != null && !"".equals(searchValue)) {
			sql += "  and (mem_name like '%" + searchValue + "%' or phone like '%" + searchValue + "%' )";
		}
		sql += " group by a.id order by create_time desc";

		int size = en.executeQuery(sql, new String[] { gym }, start, end);

		if (size == 0) {
			throw new Exception("沒有更多了");
		}

		List<Map<String, Object>> memList = en.getValues();
		for (int i = 0; i < size; i++) {
			Map<String, Object> xx = memList.get(i);
			String id = xx.get("id") + "";
			MemInfo mem = MemUtils.getMemInfo(id, cust_name);
			xx.put("headurl", mem.getWxHeadUrl());
			xx.put("mem_name", mem.getName());
		}
		this.obj.put("mems", memList);
		this.obj.put("end", end + 1);
	}

}
