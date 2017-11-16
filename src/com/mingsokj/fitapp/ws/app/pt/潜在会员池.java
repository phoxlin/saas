package com.mingsokj.fitapp.ws.app.pt;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;

public class 潜在会员池 extends BasicAction {

	/**
	 * 绑定教练
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-app-action-bundledPt", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void bundledPt() throws Exception {
		String gym = this.getParameter("gym");
//		String cust_name = this.getParameter("cust_name");
		String fk_pt_id = this.getParameter("fk_pt_id");
		String fk_user_id = this.getParameter("fk_user_id");
		Entity en = new EntityImpl(this);
		int size = en.executeQuery("select pt_id from f_user_card_" + gym + " where mem_id=?",
				new Object[] { fk_user_id });
		if (size > 0) {
			boolean flag = false;
			for (int i = 0; i < size; i++) {
				String pt_id = en.getStringValue("pt_id", i);
				if (pt_id != null && !"".equals(pt_id)) {
					flag = true;
					break;
				}
			}
			if (flag) {
				throw new Exception("绑定出错了,请刷新页面后重试");
			}

		}
		en.executeUpdate("update  f_user_card_" + gym + " set pt_id=? where mem_id=?",
				new Object[] { fk_pt_id, fk_user_id });

	}

	@Route(value = "/fit-app-action-showPotentialMemPool", slave = true, conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void showPotentialMemPool() throws Exception {
		String gym = this.getParameter("gym");
		String cust_name = this.getParameter("cust_name");
		String searchValue = this.getParameter("searchValue");
		Entity en = new EntityImpl(this);
		String sql = "select a.id,a.mem_name,a.phone from f_mem_" + cust_name + " a,f_user_card_" + gym
				+ " b where a.id = b.mem_id and a.state='001' ";

		if (searchValue != null && !"".equals(searchValue)) {
			sql += "  and (a.mem_name like '%" + searchValue + "%' or a.phone like '%" + searchValue + "%' )";
		}
		sql += " GROUP BY a.id";
		int size = en.executeQuery(sql);
		if (size > 0) {
			List<Map<String, Object>> memList = en.getValues();

			/**
			 * 查询买了私教卡的会员
			 */
			en = new EntityImpl(this);
			sql = "SELECT x.mem_id FROM f_user_card_" + gym
					+ " x,f_card y WHERE x.CARD_ID = y.id AND  ( y.CARD_TYPE = '006' or x.pt_id is not null OR x.pt_id !='')  GROUP BY x.mem_id";
			en.executeQuery(sql);
			List<Map<String, Object>> memSClassList = en.getValues();

			Map<String, Object> xx = new HashMap<String, Object>();
			for (Map<String, Object> m : memList) {
				xx.put(m.get("id") + "", m);
			}
			for (Map<String, Object> s : memSClassList) {
				String mem_id = s.get("mem_id") + "";
				if (xx.containsKey(mem_id)) {
					xx.remove(mem_id);
				}
			}

			this.obj.put("mems", xx.values());
		}
	}
}
