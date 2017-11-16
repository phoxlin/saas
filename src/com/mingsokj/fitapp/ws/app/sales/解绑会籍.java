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

public class 解绑会籍 extends BasicAction {
	/**
	 * 绑定会籍
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-app-action-bundledSales", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void bundledSales() throws Exception {
		String gym = this.getParameter("gym");
		String fk_user_id = this.getParameter("fk_user_id");
		String fk_sales_id = this.getParameter("fk_sales_id");
		MemInfo info = new MemInfo();
		info.setId(fk_user_id);
		info.setMc_id(fk_sales_id);
		info.setGym(gym);
		info.update(this.getConnection(), false);
		
	}

	@Route(value = "/fit-app-action-UnbundledSales", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void UnbundledSales() throws Exception {
		String gym = this.getParameter("gym");
		String fk_user_id = this.getParameter("fk_user_id");
		MemInfo info = new MemInfo();
		info.setId(fk_user_id);
		info.setMc_id("=no=");
		info.setGym(gym);
		info.update(this.getConnection(), false);
	}

	@Route(value = "/fit-app-action-UnbundledSalesALL", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void UnbundledSalesall() throws Exception {
		String gym = this.getParameter("gym");
		String cust_name = this.getParameter("cust_name");
		String fk_sales_id = this.getParameter("fk_user_id");
		String type = this.getParameter("type");
		String fk_user_ids = this.getParameter("ids");
		if ("MC".equals(type)) {
			if (fk_user_ids != null && !"".equals(fk_user_ids)) {
				String[] ids = fk_user_ids.split(",");
				for (String fk_user_id : ids) {
					
					MemInfo info = new MemInfo();
					info.setId(fk_user_id);
					info.setMc_id("");
					info.setGym(gym);
					info.update(this.getConnection(), false);
					
				}
			} else {
				Entity en = new EntityImpl(this);
				en.executeUpdate("update f_mem_" + cust_name + " set mc_id='' where mc_id=?", new Object[] { fk_sales_id });
			}
		} else if ("PT".equals(type)) {

			if (fk_user_ids != null && !"".equals(fk_user_ids)) {
				String[] ids = fk_user_ids.split(",");
				for (String fk_user_id : ids) {
					Entity en = new EntityImpl(this);
					en.executeUpdate("update f_user_card_" + gym + " set pt_id='' where mem_id=?",
							new Object[] { fk_user_id });
				}
			} else {
				Entity en = new EntityImpl(this);
				int size = en.executeQuery("select id from  f_user_card_" + gym + " where pt_id=?",
						new Object[] { fk_sales_id });
				if (size > 0) {
					List<Map<String, Object>> xx = en.getValues();
					for (int i = 0; i < xx.size(); i++) {
						en = new EntityImpl(this);
						String id = xx.get(i).get("id") + "";
						en.executeUpdate("update f_user_card_" + gym + " set pt_id='' where id=?", new Object[] { id });
					}
				}
			}
		}
	}
}
