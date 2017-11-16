package com.mingsokj.fitapp.ws.app.ptmanage;

import java.text.SimpleDateFormat;
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

public class 查询会籍的所有客户 extends BasicAction {
	private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

	@Route(value = "/fit-app-action-searchMemsByEmp", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void searchMemsByEmp() throws Exception {
		String cust_name = this.getParameter("cust_name");
		String gym = this.getParameter("gym");
		String emp_id = this.getParameter("emp_id");
		String type = this.getParameter("type");
		String searchValue = this.getParameter("search");
		Entity en = new EntityImpl(this);
		List<Map<String, Object>> memList = null;
		if ("MC".equals(type)) {
			String sql = "select a.id,a.mem_name,a.phone,a.create_time,a.imp_level,a.state,e.headurl from  f_mem_" + cust_name
					+ " a" + " LEFT JOIN f_wx_cust_" + cust_name + " e on e.WX_OPEN_ID = a.WX_OPEN_ID where a.mc_id=?";
			if (searchValue != null && !"".equals(searchValue)) {
				sql += "  and (a.mem_name like '%" + searchValue + "%' or a.phone like '%" + searchValue + "%' )";
			}

			int size = en.executeQuery(sql, new Object[] { emp_id });
			memList = en.getValues();
			for (int i = 0; i < size; i++) {
				Map<String, Object> xx = memList.get(i);
				if (xx.get("create_time") != null) {
					xx.put("create_time", sdf.format(xx.get("create_time")));
				} else {
					xx.put("create_time", "");
				}
			}
		} else if ("PT".equals(type)) {
			String sql = "SELECT a.id,a.mem_name,a.phone,a.imp_level,a.create_time FROM f_mem_" + cust_name
					+ " a, f_user_card_" + gym + " b WHERE" + " b.mem_id = a.id AND a.state = '001' AND b.pt_id = ?  ";
			if (searchValue != null && !"".equals(searchValue)) {
				sql += "  and (mem_name like '%" + searchValue + "%' or phone like '%" + searchValue + "%' )";
			}
			sql += " GROUP BY b.MEM_ID";
			int size = en.executeQuery(sql, new Object[] { emp_id });
			memList = en.getValues();
			for (int i = 0; i < size; i++) {
				Map<String, Object> xx = memList.get(i);
				String id = Utils.getMapStringValue(xx, "id");
				MemInfo info = MemUtils.getMemInfo(id, cust_name, L);
				if (info != null) {
					xx.put("mem_name", info.getName());
				}
				if (xx.get("create_time") != null) {
					xx.put("create_time", sdf.format(xx.get("create_time")));
				} else {
					xx.put("create_time", "");
				}
			}

		}
		this.obj.put("mems", memList);
	}
}
