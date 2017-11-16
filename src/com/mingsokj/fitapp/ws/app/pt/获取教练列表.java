package com.mingsokj.fitapp.ws.app.pt;

import java.util.ArrayList;
import java.util.List;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.utils.MemUtils;

public class 获取教练列表 extends BasicAction {
	@Route(value = "/fit-ws-app-getEmpList", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void getEmpList() throws Exception {
		String cust_name = this.getParameter("cust_name");
		String gym = this.getParameter("gym");
		Entity en = new EntityImpl(this);
		//int size = en.executeQuery("SELECT c.id FROM f_emp c where c.cust_name =? AND c.pt = 'Y' ", new Object[] { cust_name });
		int size = en.executeQuery("select a.id from f_emp a,f_emp_gym b where a.id = b.fk_emp_id and a.pt ='Y' and b.cust_name = ? and b.view_gym = ?",new Object[]{cust_name,gym});
		List<MemInfo> list = new ArrayList<>();
		for (int i = 0; i < size; i++) {
			String id = en.getStringValue("id", i);
			MemInfo info = MemUtils.getMemInfo(id, cust_name, L);
			if (info != null) {
				list.add(info);
			}
		}
		this.obj.put("list", list);

	}

	@Route(value = "/fit-ws-app-getEmpDetial", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void getEmpDetial() throws Exception {
		String cust_name = this.getParameter("cust_name");
//		String gym = this.getParameter("gym");
		String fk_emp_id = this.getParameter("fk_emp_id");
		Entity en = new EntityImpl(this);
		//int size = en.executeQuery("select a.* from f_emp a,f_wx_cust_" + cust_name + " b,f_mem_" + cust_name + " c where c.wx_open_id = b.wx_open_id and a.id=c.id and a.gym=? and a.pt='Y'  and a.id=?", new Object[] { gym, fk_emp_id });
		int size = en.executeQuery("select * from f_emp where id = ?",new Object[] { fk_emp_id});
		if (size > 0) {
			for (int i = 0; i < size; i++) {
				String id = en.getStringValue("id", i);
				MemInfo info = MemUtils.getMemInfo(id, cust_name);
				if (info != null) {
					en.getValues().get(i).put("name", info.getName());
					en.getValues().get(i).put("pic_url", info.getWxHeadUrl());
					en.getValues().get(i).put("phone", info.getPhone());
				}
			}

			this.obj.put("list", en.getValues().get(0));
		} else {
			throw new Exception("未查询到该教练详情，请刷新页面后重试");
		}
	}

}
