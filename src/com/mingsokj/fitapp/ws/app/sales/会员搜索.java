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

public class 会员搜索 extends BasicAction {

	@Route(value = "/fit-app-action-searchCustomers", slave = true, conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void searchCustomers() throws Exception {
		String cust_name = this.getParameter("cust_name");
		String gym = this.getParameter("gym");
		String fk_sales_id = this.getParameter("fk_user_id");
		String type = this.getParameter("type");
		List<Map<String, Object>> memList = null;
		if ("最近维护".equals(type)) {
			memList = recentlyMaintained(cust_name, gym, fk_sales_id);
		} else if ("最近签到".equals(type)) {
			memList = recentlyCheckIn(cust_name, gym, fk_sales_id);
		} else if ("本月未维护".equals(type)) {
			memList = notMaintainedOfMonth(cust_name, gym, fk_sales_id);
		} else if ("即将到期".equals(type)) {
			memList = expiring(cust_name, gym, fk_sales_id);
		} else if ("最近已过期".equals(type)) {
			memList = recentlyEnd(cust_name, gym, fk_sales_id);
		} else if ("最近生日".equals(type)) {
			memList = recentlyBirthday(cust_name, gym, fk_sales_id);
		} else if ("本月新增".equals(type)) {
			memList = newAddofMonth(cust_name, gym, fk_sales_id);
		} else if ("高关注".equals(type) || "普通".equals(type) || "不维护".equals(type)) {
			memList = concern(cust_name, gym, fk_sales_id, type);
		}

		this.obj.put("mems", memList);
	}

	/**
	 * 即将到期
	 * 
	 * @param cust_name
	 * @param gym
	 * @param fk_sales_id
	 * @return
	 * @throws Exception
	 */
	private List<Map<String, Object>> expiring(String cust_name, String gym, String fk_sales_id) throws Exception {
		Entity en = new EntityImpl(this);
		int size = en.executeQuery(
				"SELECT a.id,a.mem_name,a.phone,a.create_time,a.imp_level FROM f_mem_" + cust_name + " a,f_user_card_"
						+ gym + " b WHERE "
						+ "a.id = b.MEM_ID  and a.gym=? AND a.state = '001' AND a.mc_id = ? AND DATEDIFF(b.DEADLINE, NOW()) BETWEEN 0 AND 30 GROUP BY b.MEM_ID",
				new Object[] { gym, fk_sales_id });
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
	 * 最近已过期
	 * 
	 * @param cust_name
	 * @param gym
	 * @param fk_sales_id
	 * @return
	 * @throws Exception
	 */
	private List<Map<String, Object>> recentlyEnd(String cust_name, String gym, String fk_sales_id) throws Exception {
		Entity en = new EntityImpl(this);
		int size = en.executeQuery(
				"SELECT a.id,a.mem_name,a.phone,a.create_time,a.imp_level FROM f_mem_" + cust_name + " a,f_user_card_"
						+ gym + " b WHERE "
						+ "a.id = b.MEM_ID  and a.gym=? AND a.state = '001' AND a.mc_id = ? AND DATEDIFF(NOW(), b.DEADLINE)  BETWEEN 0 AND 30 GROUP BY b.MEM_ID",
				new Object[] { gym, fk_sales_id });
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
	private List<Map<String, Object>> recentlyMaintained(String cust_name, String gym, String fk_sales_id)
			throws Exception {
		// headurl
		Entity en = new EntityImpl(this);
		int size = en.executeQuery(
				"SELECT a.id,a.mem_name,a.phone,a.imp_level,a.CREATE_TIME,h.op_time FROM f_mem_" + cust_name + " a "
						+ " LEFT JOIN ( SELECT b.mem_id,b.mc_id FROM f_user_card_" + gym
						+ " b, f_card c WHERE b.CARD_ID = c.id AND c.card_type = '006'  GROUP BY b.MEM_ID ) f ON f.mem_id = a.ID"
						+ "  LEFT JOIN ( SELECT mem_id,MAX(op_time) op_time FROM f_mem_maintain_" + gym
						+ "  GROUP  BY   mem_id ) h ON h.mem_id = a.ID   WHERE a.state = '001'  and a.gym=? and a.mc_id=? ORDER BY h.op_time desc",
				new Object[] { gym, fk_sales_id });
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
	 * 最近签到
	 * 
	 * @param cust_name
	 * @param gym
	 * @param fk_sales_id
	 * @return
	 */
	private List<Map<String, Object>> recentlyCheckIn(String cust_name, String gym, String fk_sales_id)
			throws Exception {
		Entity en = new EntityImpl(this);
		int size = en.executeQuery(
				"SELECT a.id,a.mem_name,a.phone,a.imp_level,h.op_time FROM f_mem_" + cust_name + " a "
						+ " LEFT JOIN ( SELECT b.mem_id FROM f_user_card_" + gym
						+ " b, f_card c WHERE b.CARD_ID = c.id AND c.card_type = '006' GROUP BY b.MEM_ID ) f ON f.mem_id = a.ID"
						+ "  LEFT JOIN ( select MEM_ID,MAX(CHECKIN_TIME) op_time from f_checkin_" + gym
						+ " GROUP BY MEM_ID ) h ON h.mem_id = a.ID   WHERE a.state = '001'  and a.gym=?  and a.mc_id=? ORDER BY h.op_time desc",
				new Object[] { gym, fk_sales_id });
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
	 * @param type
	 * @return
	 * @throws Exception
	 */
	private List<Map<String, Object>> notMaintainedOfMonth(String cust_name, String gym, String fk_sales_id)
			throws Exception {
		Entity en = new EntityImpl(this);
		int size = en.executeQuery(
				"SELECT a.id,a.mem_name,a.phone,a.create_time,a.imp_level FROM f_mem_" + cust_name
						+ " a   where   a.state = '001' AND a.mc_id=? AND "
						+ "a.id NOT IN ( SELECT b.mem_id FROM f_mem_maintain_" + gym
						+ " b WHERE DATE_FORMAT(b.op_time, '%Y%m') = DATE_FORMAT(CURDATE(), '%Y%m') and b.type='mc'  and a.gym=?)",
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
	 * 最近生日
	 * 
	 * @param cust_name
	 * @param gym
	 * @param fk_sales_id
	 * @param type
	 * @return
	 * @throws Exception
	 */
	private List<Map<String, Object>> recentlyBirthday(String cust_name, String gym, String fk_sales_id)
			throws Exception {
		Entity en = new EntityImpl(this);
		int size = en.executeQuery(
				"SELECT a.id,a.mem_name,a.phone,a.create_time,a.imp_level FROM f_mem_" + cust_name + " a,f_user_card_"
						+ gym + " b "
						+ "WHERE a.id=b.MEM_ID AND a.state = '001' AND b.mc_id =?  and a.gym=? AND   DATEDIFF(a.birthday, NOW()) BETWEEN 0 and 30 GROUP BY a.id",
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
				"SELECT a.id,a.mem_name,a.phone,a.create_time,a.imp_level FROM f_mem_" + cust_name + " a,f_user_card_"
						+ gym + " b WHERE a.id=b.MEM_ID"
						+ " AND a.state = '001'  and a.gym=? AND DATE_FORMAT(b.ACTIVE_TIME, '%Y%m') = DATE_FORMAT(CURDATE(), '%Y%m')  AND b.mc_id =? GROUP BY a.id",
				new Object[] { gym, fk_sales_id });
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
				"select a.id,a.mem_name,a.phone,a.create_time,a.imp_level from f_mem_" + cust_name
						+ " a  where  state='001' and imp_level=?  and a.gym=? and mc_id=?",
				new Object[] { type, gym, fk_sales_id });
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
