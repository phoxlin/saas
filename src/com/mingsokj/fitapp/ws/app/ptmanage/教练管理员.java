package com.mingsokj.fitapp.ws.app.ptmanage;

import java.util.ArrayList;
import java.util.HashMap;
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
 * @author liul 2017年8月8日上午11:24:10
 */
public class 教练管理员 extends BasicAction {

	/**
	 * 显示该管理员管理的教练
	 * 
	 * @Title: showCoach
	 * @author: liul
	 * @date: 2017年8月8日上午11:24:35
	 * @throws Exception
	 */
	@Route(value = "/fit-ws-app-ptmanange-showCoach", slave = true ,conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void showCoach() throws Exception {
		String id = request.getParameter("id");
		String gym = request.getParameter("gym");
		String cust_name = request.getParameter("cust_name");
		String search = request.getParameter("search");
		Entity en = new EntityImpl(this);
		List<Map<String, String>> empList = new ArrayList<>();

		int size = en.executeQuery("select emp_id from f_m_emp a where a.P_EMP_ID=? and a.TYPE=? and a.gym=?", new String[] { id, "PT", gym });
		if (size > 0) {
			List<String> ids = en.getStringListValue("emp_id");
			for (int i = 0; i < ids.size(); i++) {				
				MemInfo m = MemUtils.getMemInfo(ids.get(i), cust_name, L);
				if (m != null) {
					if(!Utils.isNull(search) && !m.search(search)){
						continue;
					}
					Map<String, String> mm = new HashMap<>();
					mm.put("id", m.getId());
					mm.put("name", m.getName());
					mm.put("pic_url", m.getWxHeadUrl());
					mm.put("labels", m.getLabels());
					mm.put("summary", m.getSummary());
					empList.add(mm);
				}
			}

		}
		this.obj.put("list", empList);
	}

	/**
	 * 今日入场
	 * 
	 * @Title: todayCheckin
	 * @author: liul
	 * @date: 2017年8月8日下午4:47:39
	 * @throws Exception
	 */
	@Route(value = "/fit-ws-app-ptmanange-todayCheckin", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void todayCheckin() throws Exception {
		String gym = request.getParameter("gym");
		String cust_name = request.getParameter("cust_name");
		Entity en = new EntityImpl("f_checkin", this);
		String search = this.getParameter("search");
		String sql = "SELECT a.CHECKIN_TIME,a.CHECKOUT_TIME,b.* FROM f_checkin_" + gym + " a,f_mem_" + cust_name + " b WHERE a.MEM_ID=b.ID AND TO_DAYS(CHECKIN_TIME)=TO_DAYS(NOW()) AND a.GYM=?";
		if (search != null && !"".equals(search)) {
			sql = "SELECT a.CHECKIN_TIME,a.CHECKOUT_TIME,b.* FROM f_checkin_" + gym + " a,f_mem_" + cust_name + " b WHERE a.MEM_ID=b.ID AND TO_DAYS(CHECKIN_TIME)=TO_DAYS(NOW()) AND a.GYM=? and b.mem_name like '%" + search + "%' order by a.CHECKOUT_TIME";
		}
		;
		en.executeQuery(sql, new String[] { gym });
		List<Map<String, Object>> list = en.getValues();
		for(int i =0;i<list.size();i++){
			String mem_id = en.getStringValue("id",i);
			MemInfo m = MemUtils.getMemInfo(mem_id, cust_name);
			if(m!=null){
				list.get(i).put("mem_name", m.getName());
				list.get(i).put("headUrl", m.getWxHeadUrl());
			}
		}
		
		this.obj.put("list",list );
	}
}
