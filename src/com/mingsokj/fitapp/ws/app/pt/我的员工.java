package com.mingsokj.fitapp.ws.app.pt;

import java.util.List;
import java.util.Map;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.utils.MemUtils;

public class 我的员工 extends BasicAction {

	/**
	 * 主管的员工
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-app-action-searchEmpsByEx", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void ex_pt_emps() throws Exception {
		String cust_name = request.getParameter("cust_name");
		String gym = request.getParameter("gym");
		String emp_id = request.getParameter("emp_id");
		String name = request.getParameter("name");
		String type = request.getParameter("type");

		Entity en = new EntityImpl(this);
		int s = en.executeQuery("select * from f_emp where id = ?", new Object[] { emp_id });
		if (s == 0) {
			throw new Exception("您不是主管,不能进行此操作");
		}
		if ("MC".equals(type) && !"Y".equals(en.getStringValue("ex_mc"))) {
			throw new Exception("您不是会籍主管,不能进行此操作");
		}
		if ("PT".equals(type) && !"Y".equals(en.getStringValue("ex_pt"))) {
			throw new Exception("您不是会籍主管,不能进行此操作");
		}
		// 查询下属
		String sql = "select c.mem_name name,a.id,c.phone phone,c.wx_open_id from f_emp a,f_m_emp b,f_mem_" + cust_name
				+ " c where a.id = b.emp_id and a.id=c.id and b.cust_name = ? and b.gym = ? and b.p_emp_id = ? and b.type=? and a.state='002'";
		if (name != null && !"".equals(name)) {
			sql += " and c.mem_name like '%" + name + "%'";
		}
		s = en.executeQuery(sql, new Object[] { cust_name, gym, emp_id, type });
		if (s > 0) {
			// 头像
			List<Map<String, Object>> list = en.getValues();
			for (int i = 0; i < s; i++) {
				Map<String, Object> m = list.get(i);
				String id = m.get("id") + "";
				MemInfo mem = MemUtils.getMemInfo(id, cust_name);
				m.put("headurl", mem.getWxHeadUrl());
				m.put("mem_name", mem.getName());
				m.put("name", mem.getName());
			}

			this.obj.put("list", list);
		}
	}
}
