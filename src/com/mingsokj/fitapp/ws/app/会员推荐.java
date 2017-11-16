package com.mingsokj.fitapp.ws.app;

import java.util.ArrayList;
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
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.utils.MemUtils;
import com.mingsokj.fitapp.ws.bg.set.SysSet;

/**
 * @author liul 2017年8月14日上午11:46:35
 */
public class 会员推荐 extends BasicAction {

	@Route(value = "/fit-ws-bg-mem-showMemRecommend", conn = true, type = ContentType.JSON, m = HttpMethod.POST)
	public void showMemRecommend() throws Exception {
		String id = this.getParameter("id");
//		String gym = this.getParameter("gym");
		String cust_name = this.getParameter("cust_name");
		Entity en = new EntityImpl(this);
		String cur = this.getParameter("cur");
		if ("".equals(cur) || cur == null) {
			cur = "8";
		}
		// 获取该会员的积分
		int size = en.executeQuery("select * from f_mem_" + cust_name + " where id=?", new String[] { id });
		String total_cent = "0";
		if (size > 0) {
			total_cent = en.getStringValue("total_cent");
		}
		if (total_cent == null || total_cent.length() <= 0) {
			total_cent = "0";
		}
		List<MemInfo> list = new ArrayList<>();
		List<MemInfo> listFina = new ArrayList<>();
		size = en.executeQuery("select id from f_mem_" + cust_name + " where REFER_MEM_ID=?", new String[] { id });
		// 推荐给其他店的用户也要拿到
		size = en.executeQuery("select id from f_mem_" + cust_name + " where REFER_MEM_ID=?", new String[] { id });
		if (size > 0) {
			for (int i = 0; i < size; i++) {
				// 拿到该会员推荐的潜在客户id
				String mem_id = en.getStringValue("id", i);
				MemInfo mem = new MemInfo();
				mem = MemUtils.getMemInfo(mem_id, cust_name);
				if (mem != null) {
					list.add(mem);
				}
			}
		}
		int curInt = Integer.parseInt(cur);
		String state = "";
		if (list.size() >= curInt) {
			state = "Y";
			for (int i = 0; i < curInt; i++) {
				listFina.add(list.get(i));
			}
		} else {
			state = "N";
			for (int i = 0; i < list.size(); i++) {
				listFina.add(list.get(i));
			}
		}
		this.obj.put("list", listFina);
		this.obj.put("total_cent", total_cent);
		this.obj.put("state", state);
	}

	/**
	 * 添加推荐用户
	 * 
	 * @Title: addMemRecommend
	 * @author: liul
	 * @date: 2017年8月14日下午4:32:55
	 * @throws Exception
	 */
	@Route(value = "/fit-ws-bg-mem-addMemRecommend", conn = true, type = ContentType.JSON, m = HttpMethod.POST)
	public void addMemRecommend() throws Exception {
		String cust_name = this.getParameter("cust_name");
		String gym = this.getParameter("gym");
		String id = this.getParameter("id");
		String choice_pt_id = this.getParameter("choice_pt_id");
		String choice_mc_id = this.getParameter("choice_mc_id");
		String id_card = this.getParameter("id_card");
		String phone_recommend = this.getParameter("phone_recommend");
		String sex_recommend = this.getParameter("sex_recommend");
		String mem_name_recommend = this.getParameter("mem_name_recommend");
//		String recommend_mem_id = this.getParameter("recommend_mem_id");
		String content_recommed = this.getParameter("content_recommed");
		Entity mem = new EntityImpl("f_mem", this);
		if (id.length() == 11) {
			int sizeMem = mem.executeQuery("select * from f_mem_" + cust_name + " where phone=?", new String[] { id });
			if (sizeMem > 0) {
				id = mem.getStringValue("id");
			} else {
				throw new Exception("推荐人不是本会所会员");
			}
		}
		Entity mem_recommend = new EntityImpl("f_mem_recommend", this);
		mem.setTablename("f_mem_" + cust_name);

		// 本店有无重复
		Entity en = new EntityImpl("f_mem", this);
		en.setTablename("f_mem_" + cust_name);
		String phone = phone_recommend;
//		boolean flag = true;
//		if (phone == null || "".equals(phone)) {
//			flag = false;
//		}
		int s = en.executeQuery("select * from f_mem_" + cust_name + " where phone = ?", new Object[] { phone });
		if (s > 0) {
			throw new Exception(phone_recommend + "已经是本店会员了");
		}

		String mc = choice_mc_id;
		String pt_name = choice_pt_id;
		if (pt_name != null && !"".equals(pt_name)) {
			mem.setValue("pt_names", pt_name);
		}
		if (mc == null || "".equals(mc)) {
			// 公共池
			mem.setValue("state", "004");
		} else {
			// 会籍跟踪
			mem.setValue("state", "003");
			mem.setValue("MC_ID", mc);
		}
		Entity en2 = new EntityImpl(this);
		// 如果会员推荐，给推荐人添加相应积分
		if (!Utils.isNull(id)) {
			// 获取会所的积分设置
			int recommend_points = 0;
			try {
				recommend_points = Integer.parseInt(
						SysSet.getValues(cust_name, gym, "set_points", "recommend_points", this.getConnection()));
			} catch (Exception e) {
			}
			en2.executeUpdate("update f_mem_" + cust_name + " set total_cent=ifnull(total_cent,0)+? where id=?",
					new Object[] { recommend_points, id });
		}

		mem.setValue("cust_name", cust_name);
		mem.setValue("gym", gym);
		mem.setValue("create_time", new Date());
		mem.setValue("mem_name", mem_name_recommend);
		mem.setValue("id_card", id_card);
		mem.setValue("remark", content_recommed);
		mem.setValue("phone", phone);
		mem.setValue("sex", sex_recommend);
		mem.setValue("refer_mem_id", id);
		mem.create();
		en.executeQuery("select * from f_mem_" + cust_name + " where phone=?", new String[] { phone });

		mem_recommend.setTablename("f_mem_recommend_" + gym);
		mem_recommend.setValue("recommend_mem_id", id);
		mem_recommend.setValue("be_recommend_mem_id", en.getStringValue("id"));
		mem_recommend.setValue("op_time", new Date());
		mem_recommend.create();
	}

	@Route(value = "/fit-ws-bg-mem-salesAddMemRecommend", conn = true, type = ContentType.JSON, m = HttpMethod.POST)
	public void salesAddMemRecommend() throws Exception {
		String cust_name = this.getParameter("cust_name");
		String gym = this.getParameter("gym");
		String choice_mc_id = this.getParameter("id");
		String choice_pt_id = this.getParameter("choice_pt_id");
		String id_card = this.getParameter("id_card");
		String phone_recommend = this.getParameter("phone_recommend");
		String mem_name_recommend = this.getParameter("mem_name_recommend");
		String recommend_mem_id = this.getParameter("recommend_mem_id");
		String content_recommed = this.getParameter("content_recommed");
		String sa_sex_recommend = this.getParameter("sa_sex_recommend");
		Entity mem = new EntityImpl("f_mem", this);
		Entity mem_recommend = new EntityImpl("f_mem_recommend", this);
		mem.setTablename("f_mem_" + cust_name);

		// 本店有无重复
		Entity en = new EntityImpl("f_mem", this);
		en.setTablename("f_mem_" + cust_name);
		String phone = phone_recommend;
//		boolean flag = true;
//		if (phone == null || "".equals(phone)) {
//			flag = false;
//		}
		int s = en.executeQuery("select * from f_mem_" + cust_name + " where phone = ?", new Object[] { phone });
		if (s > 0) {
			throw new Exception(phone_recommend + "已经是本店会员了");
		}

		String mc = choice_mc_id;
		String pt_name = choice_pt_id;
		if (pt_name != null && !"".equals(pt_name)) {
			mem.setValue("pt_names", pt_name);
		}
		if (mc == null || "".equals(mc)) {
			// 公共池
			mem.setValue("state", "004");
		} else {
			// 会籍跟踪
			mem.setValue("state", "003");
			mem.setValue("MC_ID", mc);
		}
		mem.setValue("cust_name", cust_name);
		mem.setValue("gym", gym);
		mem.setValue("create_time", new Date());
		mem.setValue("mem_name", mem_name_recommend);
		mem.setValue("id_card", id_card);
		mem.setValue("remark", content_recommed);
		mem.setValue("refer_mem_id", recommend_mem_id);
		mem.setValue("phone", phone);
		mem.setValue("sex", sa_sex_recommend);
		mem.create();
		en.executeQuery("select * from f_mem_" + cust_name + " where phone=?", new String[] { phone });

		mem_recommend.setTablename("f_mem_recommend_" + gym);
		mem_recommend.setValue("recommend_mem_id", recommend_mem_id);
		mem_recommend.setValue("be_recommend_mem_id", en.getStringValue("id"));
		mem_recommend.setValue("op_time", new Date());
		mem_recommend.create();
	}

	/**
	 * 推荐排行
	 * 
	 * @Title: show_recommend_raking
	 * @author: liul
	 * @date: 2017年8月15日上午11:38:31
	 * @throws Exception
	 */
	@Route(value = "/fit-ws-bg-mem-show_recommend_raking", conn = true, type = ContentType.JSON, m = HttpMethod.POST)
	public void show_recommend_raking() throws Exception {
		String cust_name = this.getParameter("cust_name");
		String id = this.getParameter("id");
		String start = this.getParameter("start");
		String end = this.getParameter("end");
		String cur = this.getParameter("cur");
		String type = this.getParameter("type");
		if ("".equals(cur) || cur == null) {
			cur = "5";
		}
		Entity en = new EntityImpl(this);
		List<Map<String, Object>> list = new ArrayList<>();
		List<Map<String, Object>> listFina = new ArrayList<>();
		String sql = "select count(REFER_MEM_ID) num, REFER_MEM_ID mem_id from f_mem_" + cust_name
				+ " where REFER_MEM_ID IS NOT NULL ";
		if (!Utils.isNull(start) && !Utils.isNull(end)) {
			sql += " and  create_time between '" +start.replace(" ", "") + "' and '" + end.replace(" ", "") + "' ";
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

		int k = 1;
		int raking = 0;
		int curInt = Integer.parseInt(cur);
		String state = "";
		if ("".equals(type) || type == null) {
			for (Map<String, Object> map : list) {
				if (id.equals(map.get("mem_id"))) {
					raking = k;
					break;
				}
				k++;
			}
		}
		if (list.size() >= curInt) {
			state = "Y";
			for (int i = 0; i < curInt; i++) {
				listFina.add(list.get(i));
			}
		} else {
			state = "N";
			for (int i = 0; i < list.size(); i++) {
				listFina.add(list.get(i));
			}
		}
		this.obj.put("raking", raking);
		this.obj.put("state", state);
		this.obj.put("list", listFina);
	}
}
