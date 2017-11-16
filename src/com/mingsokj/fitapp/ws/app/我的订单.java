package com.mingsokj.fitapp.ws.app;

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
 * @author liul 2017年8月24日下午3:46:04
 */
public class 我的订单 extends BasicAction {

	@Route(value = "/fit-ws-app-showMyIndent", conn = true, type = ContentType.JSON, m = HttpMethod.POST)
	public void showMyIndent() throws Exception {
		String id = this.getParameter("id");
		String phone = this.getParameter("phone");
		// String wxOpenId = this.getParameter("wxOpenId");
		String cust_name = this.getParameter("cust_name");
		String indent_emp = this.getParameter("indent_emp");
		String search = this.getParameter("search");
		String type = this.getParameter("type");
		String cur = this.getParameter("cur");
		String sql = "";
		if ("".equals(cur) || cur == null) {
			cur = "5";
		}
		String gym = this.getParameter("gym");
		List<Map<String, Object>> list = new ArrayList<>();
		String page = "Y";
		String isEmp = "N";
		// 查询是否为员工
		Entity entity = new EntityImpl(this);
		int empSize = entity.executeQuery("select * from f_emp where id=?", new String[] { id });
		if (empSize > 0 && "emp".equals(indent_emp)) {
			isEmp = "Y";
			// 判断显示订单状态
			if ("noIndent".equals(type)) {
				sql = "SELECT a.state,c.id as mem_id,a.id,c.MEM_NAME,c.PHONE,b.CARD_NAME,a.* FROM f_user_card_" + gym
						+ " a,f_card b,f_mem_" + cust_name
						+ " c,f_emp d WHERE a.CARD_ID=b.ID AND a.MEM_ID=c.id and a.mc_id=d.id AND d.id=? and a.state='010' ORDER BY create_time desc limit 0,"
						+ cur;
			} else if ("okIndent".equals(type)) {
				sql = "SELECT a.state,c.id as mem_id,a.id,c.MEM_NAME,c.PHONE,b.CARD_NAME,a.* FROM f_user_card_" + gym
						+ " a,f_card b,f_mem_" + cust_name
						+ " c ,f_emp d WHERE a.CARD_ID=b.ID AND a.MEM_ID=c.id and a.mc_id=d.id AND d.id=? AND (a.state !='010') ORDER BY create_time desc limit 0,"
						+ cur;
			} else if ("allIndent".equals(type)) {
				sql = "SELECT a.state,c.id as mem_id,a.id,c.MEM_NAME,c.PHONE,b.CARD_NAME,a.* FROM f_user_card_" + gym
						+ " a,f_card b,f_mem_" + cust_name
						+ " c,f_emp d WHERE a.CARD_ID=b.ID AND a.MEM_ID=c.id and a.mc_id=d.id AND d.id=? ORDER BY create_time desc limit 0,"
						+ cur;
			}
			if (!Utils.isNull(search)) {
				if ("noIndent".equals(type)) {
					sql = "SELECT a.state,c.id as mem_id,d.id,c.MEM_NAME,c.PHONE,b.CARD_NAME,a.* FROM f_user_card_"
							+ gym + " a,f_card b,f_mem_" + cust_name
							+ " c,f_emp d WHERE a.CARD_ID=b.ID AND a.MEM_ID=c.id and a.mc_id=d.id AND d.id=? and a.state='010' AND (indent_no LIKE ? OR b.CARD_NAME LIKE ?) ORDER BY create_time desc limit 0,"
							+ cur;
				} else if ("okIndent".equals(type)) {
					sql = "SELECT a.state,c.id as mem_id,d.id,c.MEM_NAME,c.PHONE,b.CARD_NAME,a.* FROM f_user_card_"
							+ gym + " a,f_card b,f_mem_" + cust_name
							+ " c,f_emp d WHERE a.CARD_ID=b.ID AND a.MEM_ID=c.id and a.mc_id=d.id AND d.id=? AND (a.state != '010') AND (indent_no LIKE ? OR b.CARD_NAME LIKE ?) ORDER BY create_time desc limit 0,"
							+ cur;
				} else if ("allIndent".equals(type)) {
					sql = "SELECT a.state,c.id as mem_id,d.id,c.MEM_NAME,c.PHONE,b.CARD_NAME,a.* FROM f_user_card_"
							+ gym + " a,f_card b,f_mem_" + cust_name
							+ " c,f_emp d WHERE a.CARD_ID=b.ID AND a.MEM_ID=c.id and a.mc_id=d.id AND d.id=? AND (indent_no LIKE ? OR b.CARD_NAME LIKE ?) ORDER BY create_time desc limit 0,"
							+ cur;
				}
			}
			// 查询该会员买的卡
			Entity en = new EntityImpl(this);
			if (!Utils.isNull(search)) {
				en.executeQuery(sql, new String[] { id, "%" + search + "%", "%" + search + "%" });
				list = en.getValues();
			} else {
				en.executeQuery(sql, new String[] { id });
				list = en.getValues();
			}
			if (list.size() < Integer.parseInt(cur)) {
				page = "N";
			}
			for (Map<String, Object> map : list) {
				String emp_id = map.get("id") + "";
				if (!"".equals(emp_id) && "null".equals(emp_id)) {
					map.put("name", MemUtils.getMemInfo(emp_id, cust_name).getName());
				}
			}

		} else {
			// 判断显示订单状态
			if ("noIndent".equals(type)) {
				sql = "SELECT a.state,c.id as mem_id,b.CARD_NAME,a.* FROM f_user_card_" + gym + " a,f_card b,f_mem_"
						+ cust_name
						+ " c WHERE a.CARD_ID=b.ID AND a.MEM_ID=c.id and c.phone=? and a.state='010' ORDER BY create_time desc limit 0,"
						+ cur;
			} else if ("okIndent".equals(type)) {
				sql = "SELECT a.state,c.id as mem_id,b.CARD_NAME,a.* FROM f_user_card_" + gym + " a,f_card b,f_mem_"
						+ cust_name
						+ " c WHERE a.CARD_ID=b.ID AND a.MEM_ID=c.id and c.phone=? AND (a.state !='010') ORDER BY create_time desc limit 0,"
						+ cur;
			} else if ("allIndent".equals(type)) {
				sql = "SELECT a.state,c.id as mem_id,b.CARD_NAME,a.* FROM f_user_card_" + gym + " a,f_card b,f_mem_"
						+ cust_name
						+ " c WHERE a.CARD_ID=b.ID AND a.MEM_ID=c.id and c.phone=? ORDER BY create_time desc limit 0,"
						+ cur;
			}

			if (!Utils.isNull(search)) {
				if ("noIndent".equals(type)) {
					sql = "SELECT a.state,c.id as mem_id,b.CARD_NAME,a.* FROM f_user_card_" + gym + " a,f_card b,f_mem_"
							+ cust_name
							+ " c WHERE a.CARD_ID=b.ID AND a.MEM_ID=c.id and c.phone=? and a.state='010' AND (indent_no LIKE ? OR b.CARD_NAME LIKE ?) ORDER BY create_time desc limit 0,"
							+ cur;
				} else if ("okIndent".equals(type)) {
					sql = "SELECT a.state,b.CARD_NAME,a.* FROM f_user_card_" + gym + " a,f_card b,f_mem_" + cust_name
							+ " c WHERE a.CARD_ID=b.ID AND a.MEM_ID=c.id and c.phone=? AND (a.state !='010') AND (indent_no LIKE ? OR b.CARD_NAME LIKE ?) ORDER BY create_time desc limit 0,"
							+ cur;
				} else if ("allIndent".equals(type)) {
					sql = "SELECT  a.state,c.id as mem_id,b.CARD_NAME,a.* FROM f_user_card_" + gym
							+ " a,f_card b,f_mem_" + cust_name
							+ " c WHERE a.CARD_ID=b.ID AND a.MEM_ID=c.id and c.phone=? AND (indent_no LIKE ? OR b.CARD_NAME LIKE ?) ORDER BY create_time desc limit 0,"
							+ cur;
				}
			}
			// 查询该会员买的卡
			Entity en = new EntityImpl(this);
			if (!Utils.isNull(search)) {
				en.executeQuery(sql, new String[] { phone, "%" + search + "%", "%" + search + "%" });
				list = en.getValues();
			} else {
				en.executeQuery(sql, new String[] { phone });
				list = en.getValues();
			}
			if (list.size() < Integer.parseInt(cur)) {
				page = "N";
			}
		}
		for (Map<String, Object> map : list) {
			String mem_id = map.get("mem_id") + "";
			String mc_id = Utils.getMapStringValue(map, "mc_id");
			if (!"".equals(mem_id) && !"null".equals(mem_id)) {
				map.put("mem_name", MemUtils.getMemInfo(mem_id, cust_name).getName());
			}
			if (!Utils.isNull(mc_id)) {
				MemInfo mc = MemUtils.getMemInfo(mc_id, cust_name);
				map.put("name", mc.getName());
				map.put("isEmp", isEmp);
				map.put("mc_phone", mc.getPhone());
			}
		}

		this.obj.put("list", list);
		this.obj.put("page", page);
		this.obj.put("isEmp", isEmp);
	}

	/**
	 * 根据list进行分页
	 * 
	 * @Title: listPage
	 * @author: liul
	 * @date: 2017年8月24日下午5:55:26
	 * @param list
	 * @param cur
	 * @return
	 */
	public List<Map<String, Object>> listPage(List<Map<String, Object>> list, int cur) {
		List<Map<String, Object>> newList = new ArrayList<>();
		// 比较list大小
		if (list.size() > cur) {
			for (int i = 0; i < cur; i++) {
				newList.add(list.get(i));
			}
		} else {
			newList = list;
		}
		return newList;
	}
}
