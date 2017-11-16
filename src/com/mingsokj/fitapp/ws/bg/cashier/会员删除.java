package com.mingsokj.fitapp.ws.bg.cashier;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.m.FitUser;

public class 会员删除 extends BasicAction {

	@Route(value = "/fit-mem-del", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void del() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String fk_user_id = this.getParameter("fk_user_id");
		String cust_name = user.getCust_name();
		if (!Utils.isNull(cust_name) && !Utils.isNull(fk_user_id)) {
			Entity en = new EntityImpl(this);
			en.executeUpdate("delete from f_mem_" + cust_name + " where id=?", new Object[] { fk_user_id });
		}
	}
}
