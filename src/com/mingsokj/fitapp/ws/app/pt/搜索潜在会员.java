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

public class 搜索潜在会员 extends BasicAction {

	@Route(value = "/fit-app-action-showpotentialMem", slave = true, conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void showpotentialMem() throws Exception {
		String cust_name = this.getParameter("cust_name");
		String gym = this.getParameter("gym");
		String fk_pt_id = this.getParameter("fk_pt_id");
		String type = this.getParameter("type");
		List<Map<String, Object>> memList = null;
		if ("最近维护".equals(type)) {
			memList = recentlyMaintained(cust_name, gym, fk_pt_id);
		} else if ("最近签到".equals(type)) {
			memList = recentlyCheckIn(cust_name, gym, fk_pt_id);
		} else if ("最近添加".equals(type)) {
			memList = newAdd(cust_name, gym, fk_pt_id);
		} else if ("本月未维护".equals(type)) {
			memList = notMaintainedOfMonth(cust_name, gym, fk_pt_id);
		} else if ("即将到期".equals(type)) {
			memList = expiring(cust_name, gym, fk_pt_id);
		} else if ("最近生日".equals(type)) {
			memList = recentlyBirthday(cust_name, gym, fk_pt_id);
		} else if ("高关注".equals(type) || "普通".equals(type) || "不维护".equals(type)) {
			memList = concern(cust_name, gym, fk_pt_id, type);
		}

		this.obj.put("mems", memList);
	}

	/**
	 * 最近要过期
	 * 
	 * @param cust_name
	 * @param gym
	 * @param fk_pt_id
	 * @return
	 * @throws Exception
	 */
	private List<Map<String, Object>> expiring(String cust_name, String gym, String fk_pt_id) throws Exception {
		Entity en = new EntityImpl(this);
		String sql = "SELECT\n" + "	aa.*\n" + "FROM\n" + "	(\n" + "		SELECT\n" + "			a.id,\n"
				+ "			a.mem_name,\n" + "			a.phone,\n" + "			a.create_time,\n"
				+ "			a.imp_level,\n" + "			a.BIRTHDAY,\n" + "			a.gym\n" + "		FROM\n"
				+ "			f_mem_" + cust_name + " a\n" + "		LEFT JOIN (\n" + "			SELECT\n"
				+ "				mem_id\n" + "			FROM\n" + "				f_user_card_" + gym + " x,\n"
				+ "				f_card y\n" + "			WHERE\n" + "				x.CARD_ID = y.id\n"
				+ "			AND y.CARD_TYPE = '006'\n" + "		) b ON a.id = b.mem_id\n" + "		WHERE\n"
				+ "			b.mem_id IS NULL\n" + "		AND a.STATE = '001'\n" + "	) aa\n" + "LEFT JOIN f_user_card_"
				+ gym + " bb ON aa.id = bb.MEM_ID\n" + "WHERE\n" + "	bb.pt_id = ? \n" + "AND aa.gym=? \n"
				+ "AND datediff(now(), bb.DEADLINE) BETWEEN 0\n" + "AND 30\n" + "GROUP BY\n" + "	aa.id";

		int size = en.executeQuery(sql, new Object[] { fk_pt_id, gym });
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
	 * @param fk_pt_id
	 * @return
	 * @throws Exception
	 */
	private List<Map<String, Object>> recentlyBirthday(String cust_name, String gym, String fk_pt_id) throws Exception {
		Entity en = new EntityImpl(this);
		String sql = "SELECT\n" + "	aa.*\n" + "FROM\n" + "	(\n" + "		SELECT\n" + "			a.id,\n"
				+ "			a.mem_name,\n" + "			a.phone,\n" + "			a.create_time,\n"
				+ "			a.imp_level,\n" + "			a.BIRTHDAY,\n" + "			a.gym\n" + "		FROM\n"
				+ "			f_mem_" + cust_name + " a\n" + "		LEFT JOIN (\n" + "			SELECT\n"
				+ "				mem_id\n" + "			FROM\n" + "				f_user_card_" + gym + " x,\n"
				+ "				f_card y\n" + "			WHERE\n" + "				x.CARD_ID = y.id\n"
				+ "			AND y.CARD_TYPE = '006'\n" + "		) b ON a.id = b.mem_id\n" + "		WHERE\n"
				+ "			b.mem_id IS NULL\n" + "		AND a.STATE = '001'\n" + "	) aa\n" + "LEFT JOIN f_user_card_"
				+ gym + " bb ON aa.id = bb.MEM_ID\n" + "WHERE\n" + "	bb.pt_id = ? \n" + "AND aa.gym=? \n"
				+ "AND datediff(aa.BIRTHDAY, now()) BETWEEN 0\n" + "AND 30\n" + "GROUP BY\n" + "	aa.id";

		int size = en.executeQuery(sql, new Object[] { fk_pt_id, gym });
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
	 * @param fk_pt_id
	 * @return
	 * @throws Exception
	 */
	private List<Map<String, Object>> notMaintainedOfMonth(String cust_name, String gym, String fk_pt_id)
			throws Exception {
		Entity en = new EntityImpl(this);
		String sql = "SELECT\n" + "	aa.*, cc.op_time\n" + "FROM\n" + "	(\n" + "		SELECT\n" + "			a.id,\n"
				+ "			a.mem_name,\n" + "			a.phone,\n" + "			a.create_time,\n"
				+ "			a.imp_level,\n" + "			a.birthday,\n" + "			a.gym\n" + "		FROM\n"
				+ "			f_mem_" + cust_name + " a\n" + "		LEFT JOIN (\n" + "			SELECT\n"
				+ "				mem_id\n" + "			FROM\n" + "				f_user_card_" + gym + " x,\n"
				+ "				f_card y\n" + "			WHERE\n" + "				x.CARD_ID = y.id\n"
				+ "			AND y.CARD_TYPE = '006'\n" + "		) b ON a.id = b.mem_id\n" + "		WHERE\n"
				+ "			b.mem_id IS NULL\n" + "		AND a.STATE = '001'\n" + "	) aa\n" + "LEFT JOIN f_user_card_"
				+ gym + " bb ON aa.id = bb.MEM_ID\n" + "LEFT JOIN (\n" + "	SELECT\n" + "		mem_id,\n"
				+ "		MAX(op_time) op_time\n" + "	FROM\n" + "		f_mem_maintain_" + gym + " \n" + "	WHERE\n"
				+ "		op_id =? \n" + "	AND date_format(now(), '%y-%m') != date_format(op_time, '%y-%m')\n"
				+ "	GROUP BY\n" + "		mem_id\n" + ") cc ON aa.id = cc.mem_id\n" + "WHERE\n" + "	bb.pt_id =? \n"
				+ "AND aa.gym=? \n" + "GROUP BY\n" + "	aa.id";

		int size = en.executeQuery(sql, new Object[] { fk_pt_id, fk_pt_id, gym });
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
	 * 关注度
	 * 
	 * @param cust_name
	 * @param gym
	 * @param fk_pt_id
	 * @param type
	 * @return
	 * @throws Exception
	 */
	private List<Map<String, Object>> concern(String cust_name, String gym, String fk_pt_id, String type)
			throws Exception {
		Entity en = new EntityImpl(this);

		String sql = "SELECT\n" + "	aa.*\n" + "FROM\n" + "	(\n" + "		SELECT\n"
				+ "			a.id,a.mem_name,a.phone,a.create_time,a.imp_level,a.gym\n" + "		FROM\n"
				+ "			f_mem_" + cust_name + " a\n" + "		LEFT JOIN (\n" + "			SELECT\n"
				+ "				mem_id\n" + "			FROM\n" + "				f_user_card_" + gym + " x,\n"
				+ "				f_card y\n" + "			WHERE\n" + "				x.CARD_ID = y.id\n"
				+ "			AND y.CARD_TYPE = '006'\n" + "		) b ON a.id = b.mem_id\n" + "		WHERE\n"
				+ "			b.mem_id IS NULL\n" + "		AND a.STATE = '001'\n" + "	) aa\n" + "LEFT JOIN f_user_card_"
				+ gym + " bb ON aa.id = bb.MEM_ID\n" + "WHERE\n"
				+ "	bb.pt_id =? and  aa.imp_level=? and aa.gym=? GROUP BY aa.id";

		int size = en.executeQuery(sql, new Object[] { fk_pt_id, type, gym });
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
	 * 最近新增
	 * 
	 * @param cust_name
	 * @param gym
	 * @param fk_pt_id
	 * @return
	 * @throws Exception
	 */
	private List<Map<String, Object>> newAdd(String cust_name, String gym, String fk_pt_id) throws Exception {
		Entity en = new EntityImpl(this);
		String sql = "SELECT\n" + "	aa.*\n" + "FROM\n" + "	(\n" + "		SELECT\n" + "			a.id,\n"
				+ "			a.mem_name,\n" + "			a.phone,\n" + "			a.create_time,\n"
				+ "			a.imp_level,\n" + "			a.gym\n" + "		FROM\n" + "			f_mem_" + cust_name
				+ " a\n" + "		LEFT JOIN (\n" + "			SELECT\n" + "				mem_id\n"
				+ "			FROM\n" + "				f_user_card_" + gym + " x,\n" + "				f_card y\n"
				+ "			WHERE\n" + "				x.CARD_ID = y.id\n" + "			AND y.CARD_TYPE = '006'\n"
				+ "		) b ON a.id = b.mem_id\n" + "		WHERE\n" + "			b.mem_id IS NULL\n"
				+ "		AND a.STATE = '001'\n" + "	) aa\n" + "LEFT JOIN f_user_card_" + gym
				+ " bb ON aa.id = bb.MEM_ID\n" + "WHERE\n" + "	bb.pt_id = ?\n" + "AND aa.gym=? \n"
				+ "AND datediff(now(), bb.ACTIVE_TIME) BETWEEN 0\n" + "AND 30\n" + "GROUP BY\n" + "	aa.id";

		int size = en.executeQuery(sql, new Object[] { fk_pt_id, gym });
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
	 * @param fk_pt_id
	 * @return
	 * @throws Exception
	 */
	private List<Map<String, Object>> recentlyCheckIn(String cust_name, String gym, String fk_pt_id) throws Exception {
		Entity en = new EntityImpl(this);

		String sql = "SELECT\n" + "	aa.*, cc.op_time\n" + "FROM\n" + "	(\n" + "		SELECT\n" + "			a.id,\n"
				+ "			a.mem_name,\n" + "			a.phone,\n" + "			a.create_time,\n"
				+ "			a.imp_level,\n" + "			a.gym\n" + "		FROM\n" + "			f_mem_" + cust_name
				+ " a\n" + "		LEFT JOIN (\n" + "			SELECT\n" + "				mem_id\n"
				+ "			FROM\n" + "				f_user_card_" + gym + " x,\n" + "				f_card y\n"
				+ "			WHERE\n" + "				x.CARD_ID = y.id\n" + "			AND y.CARD_TYPE = '006'\n"
				+ "		) b ON a.id = b.mem_id\n" + "		WHERE\n" + "			b.mem_id IS NULL\n"
				+ "		AND a.STATE = '001'\n" + "	) aa\n" + "LEFT JOIN f_user_card_" + gym
				+ " bb ON aa.id = bb.MEM_ID\n" + "LEFT JOIN (\n" + "	SELECT\n" + "		mem_id,\n"
				+ "		MAX(CHECKIN_TIME) op_time\n" + "	FROM\n" + "		f_checkin_" + gym + "\n" + "	GROUP BY\n"
				+ "		mem_id\n" + ") cc ON aa.id = cc.mem_id\n" + "WHERE\n" + "	bb.pt_id = ?\n" + "AND aa.gym=? \n"
				+ "AND datediff(now(), cc.op_time) BETWEEN 0\n" + "AND 30\n" + "GROUP BY\n" + "	aa.id";

		int size = en.executeQuery(sql, new Object[] { fk_pt_id, gym });
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
	 * @param fk_pt_id
	 * @return
	 * @throws Exception
	 */
	private List<Map<String, Object>> recentlyMaintained(String cust_name, String gym, String fk_pt_id)
			throws Exception {
		Entity en = new EntityImpl(this);
		String sql = "SELECT\n" + "	aa.*, cc.op_time\n" + "FROM\n" + "	(\n" + "		SELECT\n" + "			a.id,\n"
				+ "			a.mem_name,\n" + "			a.phone,\n" + "			a.create_time,\n"
				+ "			a.imp_level\n" + "		FROM\n" + "			f_mem_" + cust_name + " a\n"
				+ "		LEFT JOIN (\n" + "			SELECT\n" + "				mem_id\n" + "			FROM\n"
				+ "				f_user_card_" + gym + " x,\n" + "				f_card y\n" + "			WHERE\n"
				+ "				x.CARD_ID = y.id\n" + "			AND y.CARD_TYPE = '006'\n"
				+ "		) b ON a.id = b.mem_id\n" + "		WHERE\n" + "			b.mem_id IS NULL\n"
				+ "		AND a.STATE = '001'\n" + "	) aa\n" + "LEFT JOIN f_user_card_" + gym
				+ " bb ON aa.id = bb.MEM_ID\n" + "LEFT JOIN (\n" + "	SELECT\n" + "		mem_id,\n"
				+ "		MAX(op_time) op_time\n" + "	FROM\n" + "		f_mem_maintain_" + gym + "\n" + "	WHERE\n"
				+ "		op_id = ? \n" + "   AND datediff(  now(), op_time) BETWEEN 0 \n" + "    AND 30 \n"
				+ "	GROUP BY \n" + "		mem_id\n" + ") cc ON aa.id = cc.mem_id\n" + "WHERE\n" + "	bb.pt_id = ?\n"
				+ "GROUP BY\n" + "	aa.id";

		int size = en.executeQuery(sql, new Object[] { fk_pt_id, fk_pt_id });
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
