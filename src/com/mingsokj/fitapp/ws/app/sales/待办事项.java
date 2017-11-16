package com.mingsokj.fitapp.ws.app.sales;

import java.util.List;
import java.util.Map;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;

public class 待办事项 extends BasicAction {
	@Route(value = "/fit-app-action-customersToBeDone", conn = true,  m = HttpMethod.POST, type = ContentType.JSON)
	public void customersToBeDone() throws Exception {
		String gym = this.getParameter("gym");
		String id = this.getParameter("id");
		Entity en = new EntityImpl(this);
		en.executeUpdate("update f_mem_maintain_" + gym + "  set upcoming='N' where id=?", new Object[] { id });

	}

	@Route(value = "/fit-app-action-showCustomersToBeDone", conn = true,  m = HttpMethod.POST, type = ContentType.JSON)
	public void showCustomersToBeDone() throws Exception {
		String gym = this.getParameter("gym");
		String cust_name = this.getParameter("cust_name");
//		String state = this.getParameter("state");
		String fk_user_id = this.getParameter("fk_user_id");
		String from = this.getParameter("from");
		// f_mem_maintain_fit
		Entity en = new EntityImpl(this);
		int size = en.executeQuery(
				" select a.content,a.op_time,b.mem_name,b.id,a.id m_id  from  f_mem_maintain_" + gym + " a,f_mem_" + cust_name
						+ " b where a.mem_id = b.id  and a.op_id=?  and a.upcoming='Y' and a.type=?",
				new Object[] { fk_user_id, from });
		List<Map<String, Object>> list = en.getValues();
		for (int i = 0; i < size; i++) {
			Map<String, Object> map = list.get(i);
			map.put("op_time", en.getFormatStringValue("op_time", "yyyy-MM-dd", i));
		}
		this.obj.put("data", list);
	}
}
