package com.mingsokj.fitapp.ws.app.pt;

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

public class 学员搜索 extends BasicAction {

	@Route(value = "/fit-app-action-searchCustomersByPT", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void searchCustomers() throws Exception {
		String cust_name = this.getParameter("cust_name");
		String gym = this.getParameter("gym");
		String fk_pt_id = this.getParameter("fk_pt_id");
		String type = this.getParameter("type");
		List<Map<String, Object>> memList = null;
		if ("最近维护".equals(type)) {
			memList = recentlyMaintained(cust_name, gym, fk_pt_id);
		} else if ("最近签到".equals(type)) {
			memList = recentlyCheckIn(cust_name, gym, fk_pt_id);
		} else if ("本月未维护".equals(type)) {
			memList = notMaintainedOfMonth(cust_name, gym, fk_pt_id);
		} else if ("即将到期".equals(type)) {
			memList = expiring(cust_name, gym, fk_pt_id);
		} else if ("最近已过期".equals(type)) {
			memList = recentlyEnd(cust_name, gym, fk_pt_id);
		} else if ("最近生日".equals(type)) {
			memList = recentlyBirthday(cust_name, gym, fk_pt_id);
		} else if ("本月新增".equals(type)) {
			memList = newAddofMonth(cust_name, gym, fk_pt_id);
		} else if ("高关注".equals(type) || "普通".equals(type) || "不维护".equals(type)) {
			memList = concern(cust_name, gym, fk_pt_id, type);
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
	private List<Map<String, Object>> expiring(String cust_name, String gym, String fk_pt_id) throws Exception {
		Entity en = new EntityImpl(this);
		int size = en.executeQuery("SELECT a.id,a.mem_name,a.phone,a.imp_level,a.create_time FROM f_mem_" + cust_name
				+ " a WHERE a.state = '001' and a.gym=? AND a.id IN ( SELECT b.mem_id FROM " + " f_user_card_" + gym
				+ " b,f_card c WHERE b.card_id = c.id AND b.pt_id = ? AND c.card_type = '006' AND b.remain_times < 3 ) GROUP BY a.id",
				new Object[] { gym, fk_pt_id });
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
		int size = en.executeQuery("SELECT a.id,a.mem_name,a.phone,a.imp_level,a.create_time FROM f_mem_" + cust_name
				+ " a WHERE a.state = '001'  and a.gym=? AND a.id IN ( SELECT b.mem_id FROM " + " f_user_card_" + gym
				+ " b,f_card c WHERE b.card_id = c.id AND b.pt_id = ? AND c.card_type = '006' AND b.remain_times = 0 ) GROUP BY a.id",
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
	private List<Map<String, Object>> recentlyMaintained(String cust_name, String gym, String fk_pt_id)
			throws Exception {
		Entity en = new EntityImpl(this);
		int size = en.executeQuery(
				"SELECT x.*, m.op_time FROM ( SELECT a.id,a.mem_name,a.phone,a.imp_level,a.create_time FROM f_mem_"
						+ cust_name + " a WHERE a.state = '001'  and a.gym=? AND a.id IN ("
						+ " SELECT b.mem_id FROM f_user_card_" + gym
						+ " b,f_card c WHERE b.card_id = c.id AND b.pt_id = ? AND c.card_type = '006' GROUP BY a.id ) ) x "
						+ "LEFT JOIN ( SELECT mem_id,MAX(op_time) op_time FROM f_mem_maintain_" + gym
						+ " GROUP BY mem_id ) m ON x.ID = m.mem_id ORDER BY m.op_time desc",
				new Object[] { gym, fk_pt_id });
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
	private List<Map<String, Object>> recentlyCheckIn(String cust_name, String gym, String fk_pt_id) throws Exception {
		Entity en = new EntityImpl(this);
		int size = en.executeQuery(
				"SELECT x.*, m.op_time FROM ( SELECT a.id,a.mem_name,a.phone,a.imp_level,a.create_time FROM f_mem_"
						+ cust_name + " a WHERE a.state = '001'  and a.gym=? AND a.id IN ("
						+ " SELECT b.mem_id FROM f_user_card_" + gym
						+ " b,f_card c WHERE b.card_id = c.id AND b.pt_id = ? AND c.card_type = '006' GROUP BY a.id ) ) x "
						+ "LEFT JOIN ( SELECT mem_id,MAX(checkin_time) op_time FROM f_checkin_" + gym
						+ " GROUP BY mem_id ) m ON x.ID = m.mem_id WHERE DATE_FORMAT(m.op_time, '%Y%m') != DATE_FORMAT(CURDATE(), '%Y%m')",
				new Object[] { gym, fk_pt_id });
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
	private List<Map<String, Object>> notMaintainedOfMonth(String cust_name, String gym, String fk_pt_id)
			throws Exception {
		Entity en = new EntityImpl(this);
		int size = en.executeQuery(
				"SELECT x.*, m.op_time FROM ( SELECT a.id,a.mem_name,a.phone,a.imp_level,a.create_time FROM f_mem_"
						+ cust_name + " a WHERE a.state = '001'  and a.gym=? AND a.id IN ("
						+ " SELECT b.mem_id FROM f_user_card_" + gym
						+ " b,f_card c WHERE b.card_id = c.id AND b.pt_id = ? AND c.card_type = '006' GROUP BY a.id ) ) x "
						+ "LEFT JOIN ( SELECT mem_id,MAX(op_time) op_time FROM f_mem_maintain_" + gym
						+ " GROUP BY mem_id ) m ON x.ID = m.mem_id WHERE DATE_FORMAT(m.op_time, '%Y%m') != DATE_FORMAT(CURDATE(), '%Y%m')",
				new Object[] { gym, fk_pt_id });
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
	private List<Map<String, Object>> recentlyBirthday(String cust_name, String gym, String fk_pt_id) throws Exception {
		Entity en = new EntityImpl(this);
		int size = en.executeQuery(
				"SELECT a.id,a.mem_name,a.phone,a.imp_level,a.create_time FROM f_mem_" + cust_name
						+ " a WHERE a.state = '001'  and a.gym=? AND a.id IN ( SELECT b.mem_id FROM" + " f_user_card_" + gym
						+ " b,f_card c WHERE b.card_id = c.id AND b.pt_id = ? AND c.card_type = '006' GROUP BY a.id ) AND datediff(a.birthday, now()) BETWEEN 0 AND 30",
				new Object[] {gym, fk_pt_id });
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
				"SELECT a.id,a.mem_name,a.phone,a.imp_level,a.create_time FROM f_mem_" + cust_name
						+ " a WHERE a.state = '001'  and a.gym=? AND a.id IN ( SELECT b.mem_id FROM f_user_card_" + gym
						+ " b,f_card c WHERE b.card_id = c.id AND b.pt_id = ? "
						+ "AND c.card_type = '006' AND DATE_FORMAT(b.ACTIVE_TIME, '%Y%m') = DATE_FORMAT(CURDATE(), '%Y%m') GROUP BY a.id )",
				new Object[] { gym,fk_sales_id });
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
	private List<Map<String, Object>> concern(String cust_name, String gym, String fk_pt_id, String type)
			throws Exception {
		Entity en = new EntityImpl(this);
		int size = en.executeQuery("SELECT a.id,a.mem_name,a.phone,a.imp_level,a.create_time FROM f_mem_" + cust_name
				+ " a WHERE a.state = '001'  and a.gym=? and a.imp_level=? AND a.id IN (" + "SELECT b.mem_id FROM f_user_card_" + gym
				+ " b,f_card c WHERE b.card_id = c.id AND b.pt_id = ? AND c.card_type = '006' GROUP BY a.id )",
				new Object[] {gym, type, fk_pt_id });
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
