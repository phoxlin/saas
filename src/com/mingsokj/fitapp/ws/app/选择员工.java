package com.mingsokj.fitapp.ws.app;

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

/**
 * @author liul 2017年8月14日下午3:29:44
 */
public class 选择员工 extends BasicAction {

	@Route(value = "/fit-app-action-choice_emp", conn = true, type = ContentType.JSON, m = HttpMethod.POST)
	public void query_emp_role() throws Exception {
		String gym = this.getParameter("gym");
		String search = this.getParameter("search");
		String cust_name = this.getParameter("cust_name");
		Entity en = new EntityImpl(this);

		String type = this.getParameter("type");
		/*String sql = "select a.MEM_NAME name,b.* from f_mem_" + cust_name
				+ " a,f_emp b where  a.id=b.id and b." + type + "='Y' and b.gym=? ";*/
		String sql = "select a.fk_emp_id as id from f_emp_gym a,f_emp b where a.cust_name = ? and view_gym = ? and b.id=a.fk_emp_id and b."+type+"='Y'";
		en.executeQuery(sql,new String[]{cust_name,gym});
		
		List<Map<String, Object>> list = en.getValues();

		for (int i = 0; i < list.size(); i++) {
			String emp_id = en.getStringValue("id", i);
			MemInfo m = MemUtils.getMemInfo(emp_id, cust_name);
			if (m != null) {
				list.get(i).put("name", m.getName());
				list.get(i).put("pic_url",m.getWxHeadUrl());
			}
		}
		if (!Utils.isNull(search)) {
			List<Map<String, Object>> l = new ArrayList<Map<String, Object>>();
			for(int i=0;i<list.size();i++){
				if(Utils.getMapStringValue(list.get(i), "name").contains(search)){
					l.add(list.get(i));
				}
			}
			this.obj.put("list", l);
		}else{
			this.obj.put("list", list);
		}
	}
}
