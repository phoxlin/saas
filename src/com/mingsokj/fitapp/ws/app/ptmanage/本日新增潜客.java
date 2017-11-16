package com.mingsokj.fitapp.ws.app.ptmanage;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.utils.MemUtils;

public class 本日新增潜客 extends BasicAction {
	private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

	@Route(value = "/fit-app-action-todayAddPotentialCustomer", conn = true,  m = HttpMethod.POST, type = ContentType.JSON)
	public void todayAddPotentialCustomer() throws Exception {
		String id = request.getParameter("id");
		String cust_name = request.getParameter("cust_name");
		String gym = request.getParameter("gym");
		Entity en = new EntityImpl("f_m_emp", this);
		en.setValue("p_emp_id", id);
		en.setValue("gym", gym);
		en.setValue("type", "MC");
		int size = en.search();
		this.obj.put("type", "mc");
		if (size > 0) {
			String type = en.getStringValue("type");
			this.obj.put("type", type);
		}

		List<String> ids = new ArrayList<String>();
		for (int i = 0; i < size; i++) {
			ids.add(en.getStringValue("emp_id", i));
		}
		ids.add(id);// 算上自己
		en = new EntityImpl(this);
		size = en.executeQuery("select a.id,a.mem_name,a.phone,a.create_time,a.imp_level,b.headurl from f_mem_" + cust_name
				+ " a left join f_wx_cust_"+cust_name+" b on a.wx_open_id = b.wx_open_id where a.gym = '"+gym+"' and a.state='003' and  TO_DAYS(NOW()) = TO_DAYS(a.CREATE_TIME)  and mc_id in ("
				+ Utils.getListString("?", ids.size()) + ")", ids.toArray());
		List<Map<String, Object>> memList = en.getValues();
		for (int i = 0; i < size; i++) {
			Map<String, Object> xx = memList.get(i);
			String fk_user_id = xx.get("id") + "";
			MemInfo mem = MemUtils.getMemInfo(fk_user_id, cust_name);
			xx.put("headurl", mem.getWxHeadUrl());
			xx.put("mem_name", mem.getName());
			if (xx.get("create_time") != null) {
				xx.put("create_time", sdf.format(xx.get("create_time")));
			}
		}
		this.obj.put("data", memList);
	}
}
