package com.mingsokj.fitapp.ws.bg.cashier;

import java.util.List;
import java.util.Map;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.c.Code;
import com.jinhua.server.c.Codes;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.m.FitUser;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.utils.MemUtils;

public class 出入场记录 extends BasicAction {

	/**
	 * 会员出入场记录
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-query-mem-checkin", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void checkinMems() throws Exception {
		String fk_user_id = request.getParameter("fk_user_id");
		String cur = request.getParameter("cur");
		if (cur == null || cur.length() <= 0) {
			cur = "1";
		}

		FitUser emp = (FitUser) this.getSessionUser();// 当前收银员
		String gym = emp.getViewGym();
		String cust_name = emp.getCust_name();

		int pageSize = 7;
		int curPage = Integer.parseInt(cur);
		int start = (curPage - 1) * pageSize + 1;
		int end = pageSize * curPage;

		Entity entity = new EntityImpl(this);
		String sql = "select * from f_checkin_" + gym + " where mem_id=? order by checkin_time desc";
		entity.executeQueryWithMaxResult(sql, new String[] { fk_user_id }, start, end);
		List<Map<String, Object>> list = entity.getValues();
		
		Entity emps = new EntityImpl(this);
		emps.executeQuery("select * from f_emp where gym=?", new String[]{gym});

		Code code = Codes.code("checkin_type");

		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> m = list.get(i);
			String checkin_time = "-";
			try {
				checkin_time = m.get("checkin_time").toString();
				checkin_time = Utils.parseData(Utils.parse2Date(checkin_time, "yyyy-MM-dd HH:mm"), "yyyy-MM-dd HH:mm");
			} catch (Exception e) {
			}
			m.put("checkin_time", checkin_time);
			String checkout_time = "-";
			try {
				checkout_time = m.get("checkout_time").toString();
				checkout_time = Utils.parseData(Utils.parse2Date(checkout_time, "yyyy-MM-dd HH:mm"), "yyyy-MM-dd HH:mm");
			} catch (Exception e) {
			}
			m.put("checkout_time", checkout_time);

			String checkin_type = m.get("checkin_type").toString();
			checkin_type = code.getNote(checkin_type);
			m.put("checkin_type", checkin_type);

			 String emp_id = m.get("emp_id").toString();
			 //查询操作人
			 int count = 0;
			 for(int j=0; j<emps.getMaxResultCount(); j++){
				 String _id = emps.getStringValue("id", j);
				 if(emp_id.equals(_id)){
					 MemInfo mm = MemUtils.getMemInfo(_id, cust_name);
					 if(mm != null){
						 m.put("emp_name", MemUtils.getMemInfo(_id, cust_name).getName());
					 } else {
						 m.put("emp_name", "--");
					 }
					 count ++;
					 break;
				 }
			 }
			 if(count == 0){
				 m.put("emp_name", "--");
			 }
		}

		int total = entity.getMaxResultCount();
		int totalpage = 0;
		int temp = total / pageSize;
		totalpage = total % pageSize > 0 ? temp + 1 : temp > 0 ? temp : 1;

		this.obj.put("checkinList", list);
		this.obj.put("total", total);
		this.obj.put("totalPage", totalpage);
		this.obj.put("curPage", curPage);
		this.obj.put("curSize", list.size());
		this.obj.put("user_id", fk_user_id);
	}
}
