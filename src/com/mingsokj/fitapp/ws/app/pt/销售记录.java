package com.mingsokj.fitapp.ws.app.pt;

import java.text.SimpleDateFormat;
import java.util.Calendar;
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

public class 销售记录 extends BasicAction {

	/**
	 * 销售记录
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-app-action-empSalesRecord", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void pt_sales_records() throws Exception {

		String cust_name = request.getParameter("cust_name");
		String gym = request.getParameter("gym");
		String emp_id = request.getParameter("emp_id");
		String condition = request.getParameter("condition");
		String card_type = request.getParameter("card_type");
		String type = request.getParameter("type");

		if (emp_id == null || "".equals(emp_id)) {
			throw new Exception("错误的请求");
		}

		String time = request.getParameter("conditionData");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

		Entity en = new EntityImpl("f_user_card", this);
		// String sql = "select a.id
		// buy_id,a.pay_time,a.real_amt,b.mem_name,c.card_name,c.times,d.headurl
		// from f_user_card_" + gym + " a,f_mem_" + cust_name + " b,f_card c left join
		// f_wx_cust_"+gym+ " d on b.wx_open_id = d.wx_open_id where a.mem_id =
		// b.id and a.card_id = c.id ";
		String sql = "SELECT	a.buy_times as times,a.mem_id,a.id buy_id,a.pay_time,a.real_amt,b.mem_name,c.card_name,d.headurl,d.nickname FROM f_user_card_" + gym + " a LEFT JOIN 	f_mem_" + cust_name + " b ON a.mem_id = b.id LEFT JOIN 	f_card c on  a.card_id = c.id LEFT JOIN f_wx_cust_" + cust_name + " d ON b.wx_open_id = d.wx_open_id";
		if ("PT".equals(type)) {
			sql += " where a.pt_id = ?";
		} else {
			sql += " where a.mc_id = ?";
		}
		if (card_type != null && !"".equals(card_type)) {
			sql += " and c.card_type='" + card_type + "'";
		}

		int s = 0;
		if (!"所有月份".equals(time) && "month".equals(condition)) {
			String first_day = time + "-01 00:00:00";

			Calendar cDay = Calendar.getInstance();
			cDay.setTime(sdf.parse(time + "-01"));
			cDay.set(Calendar.DAY_OF_MONTH, cDay.getActualMaximum(Calendar.DAY_OF_MONTH));
			String last_day = sdf.format(cDay.getTime()) + " 23:59:59";
			sql += " and a.pay_time between ? and ?  order by a.pay_time desc";

			s = en.executeQuery(sql, new Object[] { emp_id, first_day, last_day });
		} else if ("day".equals(condition)) {
			String toDayStart = time + " 00:00:00";
			String toDayEnd = time + " 23:59:59";
			sql += " and a.pay_time between ? and ?  order by a.pay_time desc";
			s = en.executeQuery(sql, new Object[] { emp_id, toDayStart, toDayEnd });
		} else {
			sql += " order by a.pay_time desc";
			s = en.executeQuery(sql, new Object[] { emp_id });
		}

		if (s > 0) {
			List<Map<String, Object>> list = en.getValues();
			for (int i = 0; i < s; i++) {
				String mem_id = en.getStringValue("mem_id", i);
				MemInfo m = MemUtils.getMemInfo(mem_id, cust_name);
				if (m != null) {
					list.get(i).put("name", m.getName());
				}
			}
			this.obj.put("list", list);
		}

	}

	// 卡种销售详情
	@Route(value = "/fit-app-action-user-card-detail", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void user_card_detail() throws Exception {
		String cust_name = request.getParameter("cust_name");
		String gym = request.getParameter("gym");
		// String mem_gym = request.getParameter("mem_gym");
		String buy_id = request.getParameter("buy_id");

		Entity en = new EntityImpl(this);
		int s = en.executeQuery("select a.*,b.card_type,b.card_name,c.id mem_id,c.phone from f_user_card_" + gym + " a,f_card b,f_mem_" + cust_name + " c where a.card_id = b.id and a.mem_id = c.id and a.id = ? limit 0,1", new Object[] { buy_id });
		if (s > 0) {
			String give_card_id = en.getStringValue("give_card_id");
			String ca_amt = en.getStringValue("ca_amt");
			String real_amt = en.getStringValue("real_amt");
			en.getValues().get(0).put("ca_amt", Utils.toPriceFromLongStr(ca_amt));
			en.getValues().get(0).put("real_amt", Utils.toPriceFromLongStr(real_amt));
			if (give_card_id != null && !"".equals(give_card_id)) {
				Entity e = new EntityImpl(this);
				e.executeQuery("select card_name from f_card where id = ?", new Object[] { give_card_id });
				this.obj.put("give_card", e.getValues().get(0));
			}
			String memId = en.getStringValue("mem_id");
			MemInfo info = MemUtils.getMemInfo(memId, cust_name, L);
			en.getValues().get(0).put("mem_name", info.getName());
			en.getValues().get(0).put("wxHeadUrl", info.getWxHeadUrl());
			this.obj.put("card", en.getValues().get(0));
		}
	}

}
