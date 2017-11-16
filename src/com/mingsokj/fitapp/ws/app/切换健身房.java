package com.mingsokj.fitapp.ws.app;

import java.util.ArrayList;
import java.util.List;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.Utils;

public class 切换健身房 extends BasicAction {

	@Route(value = "/fit-ws-app-getGymByCustname", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void getGymByCustname() throws Exception {
		String cust_name = this.getParameter("cust_name");
		String id = this.getParameter("id");
		String type = this.getParameter("type");
		Entity en = new EntityImpl(this);

		if (!Utils.isNull(id) && "emp".equals(type)) {
			int s = en.executeQuery("select * from f_emp where id = ?", new Object[] { id });
			if (s > 0) {
				en.executeQuery("select b.gym_name,a.view_gym gym from f_emp_gym a,f_gym b where a.cust_name = b.cust_name and b.gym = a.view_gym and fk_emp_id = ? ", new Object[] { id });
			} else {
				en.executeQuery("select gym,gym_name  from  f_gym where cust_name=?", new Object[] { cust_name });
			}
		} else {
			en.executeQuery("select gym,gym_name  from  f_gym where cust_name=?", new Object[] { cust_name });
		}
		this.obj.put("gym", en.getValues());
	}

	@Route(value = "/fit-ws-app-checkIsEmpAfterChangeGym", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void checkIsEmpAfterChangeGym() throws Exception {

		String cust_name = this.getParameter("cust_name");
		String gym = this.getParameter("gym");
		String mem_id = this.getParameter("id");
		Entity en = new EntityImpl(this);

		int s = en.executeQuery("select a.* from f_emp a,f_emp_gym b where a.id = b.fk_emp_id and b.cust_name = ? and b.view_gym = ? and a.id = ?", new Object[] { cust_name, gym, mem_id });
		if (s > 0) {
			this.obj.put("isEmp", "Y");
			this.obj.put("emp", en.getValues().get(0));

			List<String> roles = new ArrayList<String>();
			String mc = en.getStringValue("mc");
			String pt = en.getStringValue("pt");
			String ex_mc = en.getStringValue("ex_mc");
			String ex_pt = en.getStringValue("ex_pt");
			if ("Y".equals(mc)) {
				roles.add("我是会籍");
			}
			if ("Y".equals(pt)) {
				roles.add("我是教练");
			}
			if ("Y".equals(ex_mc)) {
				roles.add("会籍管理");
			}
			if ("Y".equals(ex_pt)) {
				roles.add("教练管理");
			}
			this.obj.put("role", Utils.getListString(roles));
		}
	}

}
