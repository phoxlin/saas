package com.mingsokj.fitapp.ws.bg;

import java.text.SimpleDateFormat;
import java.util.Date;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;

public class 试用申请 extends BasicAction {

	@Route(value = "/fit-apply", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void apply() throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String clubName = this.getParameter("clubName");
		String clubaddress = this.getParameter("clubaddress");
		String dress = this.getParameter("dress");
		String contactName = this.getParameter("contactName");
		String contactPhone = this.getParameter("contactPhone");

		Entity en = new EntityImpl(this);
		int size = en.executeQuery("select id from f_customer where phone=?", new Object[] { contactPhone });
		if (size > 0) {
			throw new Exception("该手机号码已经申请过了，请不要重复申请");
		}

		en = new EntityImpl("f_customer", this);
		en.setValue("addr", dress + " " + clubaddress);
		en.setValue("name", contactName);
		en.setValue("phone", contactPhone);
		en.setValue("customer_name", clubName);
		en.setValue("create_time", sdf.format(new Date()));
		en.setValue("state","001");
		en.create(); 
	}
}
