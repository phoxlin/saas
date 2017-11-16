package com.mingsokj.fitapp.ws.bg;

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

/**
 * @author liul 2017年8月14日上午11:46:35
 */
public class 会员推荐 extends BasicAction {

	/**
	 * 推荐排行
	 * 
	 * @Title: show_recommend_raking
	 * @author: liul
	 * @date: 2017年8月15日上午11:38:31
	 * @throws Exception
	 */
	@Route(value = "/fit-ws-cashier-mem-show_recommend_raking", conn = true, type = ContentType.JSON, m = HttpMethod.POST)
	public void show_recommend_raking() throws Exception {
		String cust_name = this.getParameter("cust_name");
		String start = this.getParameter("start");
		String end = this.getParameter("end");
		Entity en = new EntityImpl(this);
		List<Map<String, Object>> list = new ArrayList<>();
		String sql = "select count(REFER_MEM_ID) num, REFER_MEM_ID mem_id from f_mem_" + cust_name
				+ " where REFER_MEM_ID IS NOT NULL ";
		if (!Utils.isNull(start) && !Utils.isNull(end)) {
			if (start.equals(end)) {
				sql += " and  to_days( create_time) = to_days('" + start.replace(" ", "") + "') ";
			} else {
				sql += " and  create_time between '" + start.replace(" ", "") + "' and '" + end.replace(" ", "") + "' ";
			}
		}
		sql += " GROUP BY REFER_MEM_ID ORDER BY num desc";
		en.executeQuery(sql);

		list = en.getValues();

		for (int i = 0; i < list.size(); i++) {
			String mem_id = en.getStringValue("mem_id", i);
			MemInfo m = null;
			try {
				m = MemUtils.getMemInfo(mem_id, cust_name);
				if (m != null) {
					list.get(i).put("mem_name", m.getName());
					list.get(i).put("wx_head", m.getWxHeadUrl());
					list.get(i).put("phone", m.getPhone());
				}
			} catch (Exception e) {
			}
		}

		this.obj.put("list", list);
	}
}
