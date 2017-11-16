package com.mingsokj.fitapp.ws.app.sales;

import java.text.SimpleDateFormat;
import java.util.Date;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;

public class 添加潜在客户 extends BasicAction {
	@Route(value = "/fit-app-action-savePotentialCustomer", conn = true,  m = HttpMethod.POST, type = ContentType.JSON)
	public void savePotentialCustomer() throws Exception {
		/**
		 * 	sex : sex,
			birthday : birthday,
		 */
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String cust_name = this.getParameter("cust_name");// 登录人的GYM
		String sex = this.getParameter("sex");// 登录人的GYM
		String birthday = this.getParameter("birthday");// 登录人的GYM
		String gym = this.getParameter("gym");// 登录人的GYM
		String fk_user_id = this.getParameter("fk_user_id");// 登录人ID
		String mem_name = this.getParameter("mem_name");// 潜在客户姓名
		String phone = this.getParameter("phone");// 潜客电话
//		String source = this.getParameter("source");// 来源
		String remark = this.getParameter("remark");// 备注
		String imp_level = this.getParameter("imp_level");// 关注度
		String from = this.getParameter("from");

		Entity en = new EntityImpl("f_mem", this);
		int size = en.executeQuery("select id from f_mem_" + cust_name + " where phone=?", new Object[] { phone });
		if (size > 0) {
			throw new Exception("该手机号已经被使用了");
		}
		en = new EntityImpl("f_mem", this);
		en.setTablename("f_mem_" + cust_name);
		en.setValue("cust_name", cust_name);
		en.setValue("gym", gym);
		en.setValue("mem_name", mem_name);
		en.setValue("phone", phone);
		en.setValue("remark", remark);
		en.setValue("imp_level", imp_level);
		en.setValue("create_time", sdf.format(new Date()));
		en.setValue("sex", sex);
		en.setValue("birthday", birthday);
		if ("false".equals(from)) {
			en.setValue("mc_id", fk_user_id);
			en.setValue("state", "003");
		} else {
			en.setValue("state", "004");
		}
		en.create();

	}
}
