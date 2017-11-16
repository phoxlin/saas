package com.mingsokj.fitapp.ws.app;

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
 * @author liul 2017年8月17日下午2:09:30
 */
public class 选择会员 extends BasicAction {

	@Route(value = "/fit-app-action-choice_mem", conn = true, type = ContentType.JSON, m = HttpMethod.POST)
	public void choice_mem() throws Exception {
		String cust_name = this.getParameter("cust_name");
		String cur = this.getParameter("cur");
		String pt_id = this.getParameter("pt_id");
		if ("".equals(cur) || cur == null) {
			cur = "10";
		}
		int curStart = Integer.parseInt(cur);
		String search = this.getParameter("search");
		Entity en = new EntityImpl("f_mem", this);
		en.setTablename("f_mem_" + cust_name);
		List<Map<String, Object>> listSize = null;
		String state = "N";
		String sql = "select * from f_mem_"+cust_name;
		if(!Utils.isNull(pt_id)){
			sql += " where pt_names = '"+pt_id+"'";
		}
		if (!"".equals(search)) {
			sql += (sql.contains("where")?" and":" where") + " (mem_name like '%"+search + "%' or phone like '%"+search + "%')";
			en.executeQuery(sql, 1, curStart);
			listSize = en.getValues();
		} else {
			en.executeQuery(sql, 1, curStart);
			listSize = en.getValues();
		}
		for(int i=0;i<listSize.size();i++){
			String mem_id = listSize.get(i).get("id")+"";
			MemInfo m = MemUtils.getMemInfo(mem_id, cust_name);
			if(m!=null){
				listSize.get(i).put("mem_name", m.getName());
				listSize.get(i).put("wx_head", m.getWxHeadUrl());
			}
		}
		
		if (listSize.size() >= curStart) {
			state = "Y";
		}

		this.obj.put("list", listSize);
		this.obj.put("state", state);
	}
}
