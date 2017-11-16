package com.mingsokj.fitapp.ws.app.sales;

import java.text.SimpleDateFormat;
import java.util.Date;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;

public class 添加跟单记录 extends BasicAction {
	@Route(value = "/fit-app-action-addMaintian", conn = true,  m = HttpMethod.POST, type = ContentType.JSON)
	public void addMaintian() throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String gym = this.getParameter("gym");
		String cust_name = this.getParameter("cust_name");
		String mem_id = this.getParameter("fk_user_id");
		String content = this.getParameter("recordText");
		String upcoming = this.getParameter("upcoming");
		String upcoming_time = this.getParameter("upcomingTime");
		String op_id = this.getParameter("op_id");
		String type = this.getParameter("type");
		Entity en = new EntityImpl("f_mem_maintain", this);
		en.setTablename("f_mem_maintain_" + gym);
		en.setValue("cust_name", cust_name);
		en.setValue("gym", gym);
		en.setValue("mem_id", mem_id);
		en.setValue("content", content);
		en.setValue("upcoming", upcoming);
		if ("Y".equals(upcoming)) {
			en.setValue("upcoming_time", upcoming_time);
		}
		en.setValue("op_id", op_id);
		en.setValue("op_time", sdf.format(new Date()));
		en.setValue("type",type);
		en.create();
	}
}
