package com.mingsokj.fitapp.ws.app.sales;

import java.util.ArrayList;
import java.util.List;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.Utils;

/**
 * @author hu
 */
public class 会籍主管 extends BasicAction {
	@Route(value = "/fit-ws-app-mcManager", conn = true,  m = HttpMethod.POST, type = ContentType.JSON)
	public void showSalesInfo() throws Exception {
		String id = request.getParameter("id");
		String gym = request.getParameter("gym");
		String cust_name = request.getParameter("cust_name");
		Entity en = new EntityImpl("f_m_emp", this);
		en.setValue("p_emp_id", id);
		en.setValue("gym", gym);
		en.setValue("type", "MC");
		int size = en.search();
		if (size > 0) {
			String type = en.getStringValue("type");
			this.obj.put("type", type);
		} else {
			size = en.executeQuery("select ex_mc from f_emp where id = ?",new Object[]{id});
			if(size == 0 || !"Y".equals(en.getStringValue("ex_mc"))){
				throw new Exception("您不是会籍管理员");
			}
		}

		// 今日售卡
		List<String> ids = new ArrayList<String>();
		for (int i = 0; i < size; i++) {
			ids.add(en.getStringValue("emp_id", i));
		}
		ids.add(id);// 算上自己
		en.executeQuery("select count(a.id) count from f_user_card_" + gym
				+ " a,f_card b where a.card_id = b.id and TO_DAYS(a.pay_time) = TO_DAYS(now()) and a.mc_id in ("
				+ Utils.getListString("?", ids.size()) + ")", ids.toArray());
		this.obj.put("salseCards", en.getStringValue("count"));


		// 本日新增
		int memsize = en.executeQuery("select id,mem_name,phone,create_time,imp_level from f_mem_" + cust_name
				+ " where gym = '"+gym+"' and state='001' and  TO_DAYS(NOW()) = TO_DAYS(CREATE_TIME)  and mc_id in ("
				+ Utils.getListString("?", ids.size()) + ")", ids.toArray());
		int psize = en.executeQuery("select id,mem_name,phone,create_time,imp_level from f_mem_" + cust_name
				+ " where  gym = '"+gym+"' and state='003' and  TO_DAYS(NOW()) = TO_DAYS(CREATE_TIME)  and mc_id in ("
				+ Utils.getListString("?", ids.size()) + ")", ids.toArray());
		this.obj.put("newAdd", memsize + psize);

		// 今日维护

		size = en.executeQuery(
				"select id from  f_mem_maintain_" + gym + " where TO_DAYS(op_time) = TO_DAYS(now()) and type='mc' and op_id in ("
						+ Utils.getListString("?", ids.size()) + ")",
				ids.toArray());
		this.obj.put("wh", size);
	}
}
