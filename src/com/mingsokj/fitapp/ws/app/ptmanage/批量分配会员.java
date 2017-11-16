package com.mingsokj.fitapp.ws.app.ptmanage;

import java.util.ArrayList;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;

public class 批量分配会员 extends BasicAction {

	@Route(value = "/fit-app-action-doDistributionpotentialMem", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void doDistributionpotentialMem() throws Exception {
		String gym = this.getParameter("gym");
		String cust_name = this.getParameter("cust_name");
		String ids = this.getParameter("ids");
		String b_mc_id = this.getParameter("b_mc_id");
		String mc_id = this.getParameter("mc_id");
		String type = this.getParameter("type");
		String[] fk_user_ids = null;
		if ("MC".equals(type)) {
			if (ids != null && !"".equals(ids)) {
				// 单个或多个分配
				fk_user_ids = ids.split(",");
				for (String fk_user_id : fk_user_ids) {
					Entity en = new EntityImpl(this);
					en.executeUpdate("update  f_mem_" + cust_name + " set mc_id=? where id=?",
							new Object[] { mc_id, fk_user_id });
				}
			} else {
				Entity en = new EntityImpl(this);
				// 分配所有
				String sql = "select id from  f_mem_" + cust_name + " where mc_id=?";
				int size = en.executeQuery(sql, new Object[] { b_mc_id });
				ArrayList<String> list = new ArrayList<String>();
				for (int i = 0; i < size; i++) {
					list.add(en.getStringValue("id", i));
				}
				for (int j = 0; j < size; j++) {
					en = new EntityImpl(this);
					en.executeUpdate("update  f_mem_" + cust_name + " set mc_id=? where id=?",
							new Object[] { mc_id, list.get(j) });
				}
			}

		} else if ("PT".equals(type)) {
			if (ids != null && !"".equals(ids)) {
				fk_user_ids = ids.split(",");
				for (String fk_user_id : fk_user_ids) {
					Entity en = new EntityImpl(this);
					en.executeUpdate("update  f_user_card_" + gym + " set pt_id=? where mem_id=?",
							new Object[] { mc_id, fk_user_id });
				}
			} else {
				Entity en = new EntityImpl(this);
				String sql = "SELECT a.id FROM f_mem_" + cust_name + " a, f_user_card_" + gym + " b WHERE"
						+ " b.mem_id = a.id AND a.state = '001' AND b.pt_id = ?   GROUP BY b.MEM_ID";
				int size = en.executeQuery(sql, new Object[] { b_mc_id });

				ArrayList<String> list = new ArrayList<String>();
				for (int i = 0; i < size; i++) {
					list.add(en.getStringValue("id", i));
				}
				for (int j = 0; j < size; j++) {
					en = new EntityImpl(this);
					en.executeUpdate("update  f_user_card_" + gym + " set pt_id=? where mem_id=?",
							new Object[] { mc_id, list.get(j) });
				}

			}
		}
	}

	@Route(value = "/fit-app-action-doDistributionMem", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void doDistributionMem() throws Exception {
		String gym = this.getParameter("gym");
		String ids = this.getParameter("ids");
		String pt_id = this.getParameter("pt_id");
		String[] fk_user_ids = ids.split(",");
		for (String fk_user_id : fk_user_ids) {
			Entity en = new EntityImpl(this);
			en.executeUpdate("update  f_user_card_" + gym + " set pt_id=? where mem_id=?",
					new Object[] { pt_id, fk_user_id });
		}

	}

}
