package com.mingsokj.fitapp.ws.bg.cashier;

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
import com.mingsokj.fitapp.m.FitUser;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.utils.MemUtils;

/**
 * @author liul 2017年8月18日上午9:58:59
 */
public class App新入会审核 extends BasicAction {

	@Route(value = "/fit-app-action-showExamine", conn = true, type = ContentType.JSON, m = HttpMethod.POST)
	public void showExamine() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String cust_name = user.getCust_name();
		String state = this.getParameter("type");
		String searchVal = this.getParameter("searchVal");
		Entity en = new EntityImpl(this);
		String cur = request.getParameter("cur");
		if (cur == null || cur.length() <= 0) {
			cur = "1";
		}
		int pageSize = 6;
		int curPage = Integer.parseInt(cur);
		int start = (curPage - 1) * pageSize + 1;
		int end = pageSize * curPage;
		int size = 0;
		String sql = "SELECT a.mem_id,a.state,a.create_time,b.CARD_NAME,b.CARD_TYPE,a.BUY_TIME,a.ca_amt,a.real_amt,c.MEM_NAME,c.phone,a.buy_for_app,a.ID,a.examine_emp_id FROM f_user_card_"
				+ gym + " a,f_card b,f_mem_" + cust_name + " c WHERE a.MEM_ID=c.ID AND a.CARD_ID=b.ID ";
		if ("ok".equals(state)) {
			sql = "SELECT a.mem_id,a.state,a.create_time,b.card_type,b.CARD_NAME,a.BUY_TIME,a.ca_amt,a.real_amt,c.MEM_NAME ,c.phone,a.buy_for_app,a.ID,a.examine_emp_id,a.op_id FROM f_user_card_"
					+ gym + " a,f_card b,f_mem_" + cust_name
					+ " c WHERE  a.MEM_ID=c.ID AND a.CARD_ID=b.ID AND a.state!='010' ";
		} else if ("no".equals(state)) {
			sql = "SELECT a.mem_id,a.state,a.create_time,b.card_type,b.CARD_NAME,a.BUY_TIME,a.ca_amt,a.real_amt,c.MEM_NAME ,c.phone,a.buy_for_app,a.ID,a.examine_emp_id,a.op_id FROM f_user_card_"
					+ gym + " a,f_card b,f_mem_" + cust_name
					+ " c WHERE  a.MEM_ID=c.ID AND a.CARD_ID=b.ID AND a.state='010' ";
		}
		if (!Utils.isNull(searchVal)) {
			sql += " and (c.mem_name like '" + searchVal + "%' or b.CARD_NAME like '" + searchVal + "%')";
		}
		size = en.executeQueryWithMaxResult(sql, start, end);
		int total = 0;
		int totalpage = 0;
		total = en.getMaxResultCount();
		List<Map<String, Object>> list = new ArrayList<>();
		if (size > 0) {
			list = en.getValues();
			// 如果已审核，将审核人名字添加到集合中
			for (Map<String, Object> map : list) {
				String examine_emp_id = map.get("examine_emp_id") + "";
				String op_id = map.get("op_id") + "";
				String mem_id = map.get("mem_id") + "";
				MemInfo mem = MemUtils.getMemInfo(mem_id, cust_name);
				if (mem != null) {
					map.put("mem_name", mem.getName());
				}

				if (!Utils.isNull(op_id)) {
					int size2 = en.executeQuery("select a.id,b.mem_name as name from f_emp a,f_mem_" + cust_name
							+ "  b where a.id=b.id and a.id=?", new String[] { op_id });
					if (size2 > 0) {
						String id = en.getStringValue("id");
						map.put("op_name", MemUtils.getMemInfo(id, cust_name).getName());
					} else {
						map.put("op_name", "admin");
					}
				} else {
					map.put("op_name", "admin");
				}
				// 前台审核
				if (!"".equals(examine_emp_id) && !"null".equals(examine_emp_id)) {
					int size2 = en.executeQuery("select a.id,b.mem_name as name from f_emp a,f_mem_" + cust_name
							+ "  b where a.id=b.id and a.id=?", new String[] { examine_emp_id });
					if (size2 > 0) {
						String id = en.getStringValue("id");
						map.put("examine_name", MemUtils.getMemInfo(id, cust_name).getName());
					} else {
						map.put("examine_name", "admin");
					}
					// 后台添加新入会后直接支付
				} else {
					map.put("examine_name", "admin");
				}
			}
		}

		int temp = total / pageSize;
		totalpage = total % pageSize > 0 ? temp + 1 : temp > 0 ? temp : 1;
		this.obj.put("list", list);
		this.obj.put("total", total);// 总条数
		this.obj.put("totalPage", totalpage);// 总页数
		this.obj.put("curPage", curPage);// 当前页
		this.obj.put("curSize", list.size());// 当前页显示条数
	}

}
