package com.mingsokj.fitapp.ws.app;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;

public class 解绑微信 extends BasicAction {
	@Route(value = "/fit-app-action-unbundledWechatAccount", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void unbundledWechatAccount() throws Exception {
		String cust_name = this.getParameter("cust_name");
		String id = this.getParameter("id");
		Entity en = new EntityImpl(this);
		try {
			en.executeUpdate("update f_mem_" + cust_name + " set wx_open_id='' where id=?", new Object[] { id });
		} catch (Exception e) {
		}
		try {
			en.executeUpdate("update f_emp set wx_open_id='' where id=?", new Object[] { id });
		} catch (Exception e) {
		}
	}
}
