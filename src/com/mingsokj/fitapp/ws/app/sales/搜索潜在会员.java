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

public class 搜索潜在会员 extends BasicAction {

	@Route(value = "/fit-app-action-searchPotentialCustomers", slave = true, conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void searchPotentialCustomers() throws Exception {
		String cust_name = this.getParameter("cust_name");
		String gym = this.getParameter("gym");
		String fk_sales_id = this.getParameter("fk_user_id");
		String type = this.getParameter("type");
		List<Map<String, Object>> memList = null;
		if ("最近维护".equals(type)) {
			memList = recentlyMaintained(cust_name, gym, fk_sales_id);
		} else if ("最远维护".equals(type)) {
			memList = farthestMaintained(cust_name, gym, fk_sales_id);
		} else if ("高关注".equals(type) || "普通".equals(type) || "不维护".equals(type)) {
			memList = concern(cust_name, gym, fk_sales_id, type);
		} else if ("本月新增".equals(type)) {
			memList = newAddofMonth(cust_name, gym, fk_sales_id);
		} else if ("本月未维护".equals(type)) {
			memList = notMaintainedOfMonth(cust_name, gym, fk_sales_id);
		}

		this.obj.put("mems", memList);
	}

	/**
	 * 最远维护
	 * 
	 * @param cust_name
	 * @param gym
	 * @param fk_sales_id
	 * @return
	 * @throws Exception
	 */
	private List<Map<String, Object>> farthestMaintained(String cust_name, String gym, String fk_sales_id)
			throws Exception {
		Entity en = new EntityImpl(this);
		int size = en.executeQuery("SELECT a.id,a.mem_name,a.phone,a.create_time,a.imp_level,m.op_time FROM f_mem_"
				+ cust_name + " a" + " LEFT JOIN ( SELECT MAX(op_time) op_time,mem_id FROM f_mem_maintain_" + gym
				+ " GROUP BY mem_id ) m ON m.mem_id = a.id  WHERE a.MC_ID = ? and a.gym=?  and a.id NOT IN ( SELECT mem_id FROM f_user_card_"
				+ gym + " GROUP BY mem_id )  ORDER BY m.op_time asc", new Object[] { fk_sales_id, gym });
		List<Map<String, Object>> memList = en.getValues();
		for (int i = 0; i < size; i++) {
			Map<String, Object> xx = memList.get(i);
			String id = xx.get("id") + "";
			MemInfo mem = MemUtils.getMemInfo(id, cust_name);
			xx.put("headurl", mem.getWxHeadUrl());
			xx.put("mem_name", mem.getName());
		}
		return memList;
	}

	/**
	 * 本月未维护
	 * 
	 * @param cust_name
	 * @param gym
	 * @param fk_sales_id
	 * @return
	 * @throws Exception
	 *             查询既不是本月添加的 然后 本月的跟单记录又没有的
	 */
	private List<Map<String, Object>> notMaintainedOfMonth(String cust_name, String gym, String fk_sales_id)
			throws Exception {
		Entity en = new EntityImpl(this);
		int size = en.executeQuery("SELECT a.id,a.mem_name,a.phone,a.create_time,a.imp_level FROM f_mem_" + cust_name
				+ " a WHERE a.MC_ID = ? and a.gym=? AND a.id NOT IN (" + " SELECT mem_id FROM f_user_card_" + gym
				+ " GROUP BY mem_id ) AND a.id NOT IN ( SELECT m.mem_id FROM ( SELECT MAX(op_time) op_time,mem_id"
				+ " FROM f_mem_maintain_" + gym
				+ " WHERE DATE_FORMAT(op_time, '%Y%m') = DATE_FORMAT(CURDATE(), '%Y%m') and op_id=? GROUP BY mem_id ) m )",
				new Object[] { fk_sales_id, gym, fk_sales_id });

		List<Map<String, Object>> memList = en.getValues();
		for (int i = 0; i < size; i++) {
			Map<String, Object> xx = memList.get(i);
			String id = xx.get("id") + "";
			MemInfo mem = MemUtils.getMemInfo(id, cust_name);
			xx.put("headurl", mem.getWxHeadUrl());
			xx.put("mem_name", mem.getName());
		}
		return memList;
	}

	/**
	 * 本月新增
	 * 
	 * @param cust_name
	 * @param gym
	 * @param fk_sales_id
	 * @param type
	 * @return
	 * @throws Exception
	 */
	private List<Map<String, Object>> newAddofMonth(String cust_name, String gym, String fk_sales_id) throws Exception {
		Entity en = new EntityImpl(this);
		int size = en.executeQuery(
				"SELECT a.id,a.mem_name,a.phone,a.create_time,a.imp_level FROM f_mem_" + cust_name + " a"
						+ "  WHERE a.MC_ID = ? and a.gym=?  and  a.id NOT IN ( SELECT mem_id FROM f_user_card_" + gym
						+ " GROUP BY mem_id"
						+ " ) and DATE_FORMAT( a.create_time, '%Y%m' ) = DATE_FORMAT( CURDATE( ) , '%Y%m' ) ORDER BY a.CREATE_TIME DESC",
				new Object[] { fk_sales_id, gym });
		List<Map<String, Object>> memList = en.getValues();
		for (int i = 0; i < size; i++) {
			Map<String, Object> xx = memList.get(i);
			String id = xx.get("id") + "";
			MemInfo mem = MemUtils.getMemInfo(id, cust_name);
			xx.put("headurl", mem.getWxHeadUrl());
			xx.put("mem_name", mem.getName());
		}
		return memList;
	}

	/**
	 * 高关注 普通 不维护
	 * 
	 * @param cust_name
	 * @param gym
	 * @param fk_sales_id
	 * @param type
	 * @return
	 * @throws Exception
	 */
	private List<Map<String, Object>> concern(String cust_name, String gym, String fk_sales_id, String type)
			throws Exception {
		Entity en = new EntityImpl(this);
		int size = en.executeQuery(
				"SELECT a.id,a.mem_name,a.phone,a.create_time,a.imp_level FROM f_mem_" + cust_name + " a "
						+ " WHERE a.MC_ID = ?  and  a.id NOT IN ( SELECT mem_id FROM f_user_card_" + gym
						+ " GROUP BY mem_id" + " )  and imp_level=? and a.gym=? ",
				new Object[] { fk_sales_id, type, gym });
		List<Map<String, Object>> memList = en.getValues();
		for (int i = 0; i < size; i++) {
			Map<String, Object> xx = memList.get(i);
			String id = xx.get("id") + "";
			MemInfo mem = MemUtils.getMemInfo(id, cust_name);
			xx.put("headurl", mem.getWxHeadUrl());
			xx.put("mem_name", mem.getName());
		}
		return memList;
	}

	/**
	 * 最近维护
	 * 
	 * @param cust_name
	 * @param gym
	 * @param fk_sales_id
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> recentlyMaintained(String cust_name, String gym, String fk_sales_id)
			throws Exception {
		Entity en = new EntityImpl(this);
		int size = en.executeQuery("SELECT a.id,a.mem_name,a.phone,a.create_time,a.imp_level,m.op_time FROM f_mem_"
				+ cust_name + " a" + " LEFT JOIN ( SELECT MAX(op_time) op_time,mem_id FROM f_mem_maintain_" + gym
				+ " GROUP BY mem_id ) m ON m.mem_id = a.id  WHERE a.MC_ID = ? and a.gym=? and a.id NOT IN ( SELECT mem_id FROM f_user_card_"
				+ gym + " GROUP BY mem_id ) ORDER BY m.op_time DESC", new Object[] { fk_sales_id, gym });
		List<Map<String, Object>> memList = en.getValues();
		for (int i = 0; i < size; i++) {
			Map<String, Object> xx = memList.get(i);
			String id = xx.get("id") + "";
			MemInfo mem = MemUtils.getMemInfo(id, cust_name);
			xx.put("headurl", mem.getWxHeadUrl());
			xx.put("mem_name", mem.getName());
		}
		return memList;
	}
}
