package com.mingsokj.fitapp.ws.app.sales;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;

public class 会籍首页查询 extends BasicAction {
	@Route(value = "/fit-app-action-showSalesInfo", conn = true,  m = HttpMethod.POST, type = ContentType.JSON)
	public void showSalesInfo() throws Exception {
		String gym = this.getParameter("gym");
		String cust_name = this.getParameter("cust_name");
		String fk_sales_id = this.getParameter("fk_user_id");
		/**
		 * 新增会员
		 */
		Entity en = new EntityImpl(this);
		int size = en.executeQuery(
				"select id from f_mem_" + cust_name
						+ " where gym = '"+gym+"' and state='001' and DATE_FORMAT( create_time, '%Y%m' ) = DATE_FORMAT( CURDATE( ) , '%Y%m' ) and mc_id=?",
				new Object[] { fk_sales_id });
		this.obj.put("cSize", size);
		/**
		 * 本月新增潜客
		 */
		en = new EntityImpl(this);
		size = en.executeQuery(
				"select id from f_mem_" + cust_name
						+ " where gym = '"+gym+"' and state='003' and DATE_FORMAT( create_time, '%Y%m' ) = DATE_FORMAT( CURDATE( ) , '%Y%m' ) and mc_id=?",
				new Object[] { fk_sales_id });
		this.obj.put("pcSize", size);
		/**
		 * 维护次数
		 */
		en = new EntityImpl(this);
		size = en.executeQuery(
				"select id from f_mem_maintain_" + gym
						+ " where  DATE_FORMAT( op_time, '%Y%m' ) = DATE_FORMAT( CURDATE( ) , '%Y%m' ) and ( type='mc' or type='qmc') and op_id=?",
				new Object[] { fk_sales_id });
		this.obj.put("mSize", size);

	}

}
