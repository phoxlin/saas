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

/**
 * 
 * @author hu
 *
 */
public class 收银统计 extends BasicAction {

	@Route(value = "/fit-bg-action-moneyReport", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void moneyReport() throws Exception {
		String cust_name = request.getParameter("cust_name");
		String curGym = request.getParameter("curGym");
		String dateFrom = request.getParameter("dateFrom");
		String dateTo = request.getParameter("dateTo");

		String from = "";
		String to = "";

		if (dateFrom != null && !"".equals(dateFrom)) {
			from = dateFrom + " 00:00:00";
		}
		if (dateTo != null && !"".equals(dateTo)) {
			to = dateTo + " 23:59:59";
		}

		Entity en = new EntityImpl(this);

		// 4大卡售额
		StringBuilder sql = new StringBuilder();
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();

		sql.append("select sum(CONVERT(IFNULL(a.real_amt,0),SIGNED)) total_real_amt").
		append(", sum(CONVERT(IFNULL(a.ca_amt,0),SIGNED)) total_ca_amt").
		append(", sum(CONVERT(IFNULL(a.cash_amt,0),SIGNED)) total_cash_amt").
		append(", sum(CONVERT(IFNULL(a.card_cash_amt,0),SIGNED)) total_card_cash_amt").
		append(", sum(CONVERT(IFNULL(a.card_amt,0),SIGNED)) total_card_amt").
		append(", sum(CONVERT(IFNULL(a.vouchers_amt,0),SIGNED)) total_vouchers_amt").
		append(", sum(CONVERT(IFNULL(a.wx_amt,0),SIGNED)) total_wx_amt").
		append(", sum(CONVERT(IFNULL(a.ali_amt,0),SIGNED)) total_ali_amt").
		append(",b.card_type card_type").
		append(" from f_user_card_" + curGym + " a,f_card b where a.card_id = b.id").
		append(" and a.pay_time between ? and ? group by b.card_type");

		int s = en.executeQuery(sql.toString(), new Object[] { from, to });
		if (s > 0) {
			list.addAll(en.getValues());
		}
		// 请假
		sql = new StringBuilder();
		sql.append("select 'leave' type,sum(CONVERT(a.real_amt,SIGNED)) total_real_amt").append(", sum(CONVERT(a.ca_amt,SIGNED)) total_ca_amt").append(", sum(CONVERT(a.cash_amt,SIGNED)) total_cash_amt").append(", sum(CONVERT(a.card_cash_amt,SIGNED)) total_card_cash_amt").append(", sum(CONVERT(a.card_amt,SIGNED)) total_card_amt").append(", sum(CONVERT(a.vouchers_amt,SIGNED)) total_vouchers_amt").append(", sum(CONVERT(a.wx_amt,SIGNED)) total_wx_amt").append(", sum(CONVERT(a.ali_amt,SIGNED)) total_ali_amt").append(" from f_leave a where cust_name = ? and gym = ? and pay_time between ? and ?");
		s = en.executeQuery(sql.toString(), new Object[] { cust_name, curGym, from, to });
		if (s > 0) {
			Map<String, Object> map = en.getValues().get(0);
			map.put("type", "leave");
			list.add(map);
		}
		// 转卡售额  和租柜售额  充值
		sql = new StringBuilder();
		sql.append(" select  sum(CONVERT(a.real_amt,SIGNED)) total_real_amt").append(", sum(CONVERT(a.ca_amt,SIGNED)) total_ca_amt").append(", sum(CONVERT(a.cash_amt,SIGNED)) total_cash_amt").append(", sum(CONVERT(a.card_cash_amt,SIGNED)) total_card_cash_amt").append(", sum(CONVERT(a.card_amt,SIGNED)) total_card_amt").append(", sum(CONVERT(a.vouchers_amt,SIGNED)) total_vouchers_amt").append(", sum(CONVERT(a.wx_amt,SIGNED)) total_wx_amt").append(", sum(CONVERT(a.ali_amt,SIGNED)) total_ali_amt").append(",pay_type type from f_other_pay_" + curGym + " a where pay_type in ('租柜费用','转卡手续费','充值')  and  pay_time between ? and ? group by pay_type");

		s = en.executeQuery(sql.toString(), new Object[] { from, to });
		if (s > 0) {
			list.addAll(en.getValues());
		}
		// 商品售额
		sql = new StringBuilder();
		sql.append(" select  sum(CONVERT(a.real_amt,SIGNED)) total_real_amt").append(", sum(CONVERT(a.ca_amt,SIGNED)) total_ca_amt").append(", sum(CONVERT(a.cash_amt,SIGNED)) total_cash_amt").append(", sum(CONVERT(a.card_cash_amt,SIGNED)) total_card_cash_amt").append(", sum(CONVERT(a.card_amt,SIGNED)) total_card_amt").append(", sum(CONVERT(a.vouchers_amt,SIGNED)) total_vouchers_amt").append(", sum(CONVERT(a.wx_amt,SIGNED)) total_wx_amt").append(", sum(CONVERT(a.ali_amt,SIGNED)) total_ali_amt").append(" from f_store_rec_" + curGym + " a where type='004' and  op_time between ? and ?");

		s = en.executeQuery(sql.toString(), new Object[] { from, to });
		if (s > 0) {
			Map<String, Object> map = en.getValues().get(0);
			map.put("type", "goods");
			list.add(map);
		}
		// 散客
		sql = new StringBuilder();
		sql.append(" select sum(CONVERT(a.real_amt,SIGNED)) total_real_amt").append(", sum(CONVERT(a.ca_amt,SIGNED)) total_ca_amt").append(", sum(CONVERT(a.cash_amt,SIGNED)) total_cash_amt").append(", sum(CONVERT(a.card_cash_amt,SIGNED)) total_card_cash_amt").append(", sum(CONVERT(a.card_amt,SIGNED)) total_card_amt").append(", sum(CONVERT(a.vouchers_amt,SIGNED)) total_vouchers_amt").append(", sum(CONVERT(a.wx_amt,SIGNED)) total_wx_amt").append(", sum(CONVERT(a.ali_amt,SIGNED)) total_ali_amt").append(" from f_fit a where cust_name = ? and gym = ? and  pay_time between ? and ?");

		s = en.executeQuery(sql.toString(), new Object[] { cust_name, curGym, from, to });
		if (s > 0) {
			Map<String, Object> map = en.getValues().get(0);
			map.put("type", "fit");
			list.add(map);
		}
		//其他
		sql = new StringBuilder();
		sql.append(" select  sum(CONVERT(a.real_amt,SIGNED)) total_real_amt").append(", sum(CONVERT(a.ca_amt,SIGNED)) total_ca_amt").append(", sum(CONVERT(a.cash_amt,SIGNED)) total_cash_amt").append(", sum(CONVERT(a.card_cash_amt,SIGNED)) total_card_cash_amt").append(", sum(CONVERT(a.card_amt,SIGNED)) total_card_amt").append(", sum(CONVERT(a.vouchers_amt,SIGNED)) total_vouchers_amt").append(", sum(CONVERT(a.wx_amt,SIGNED)) total_wx_amt").append(", sum(CONVERT(a.ali_amt,SIGNED)) total_ali_amt").append(",'other' type from f_other_pay_" + curGym + " a where pay_type in ('付定金','升级补差价' ,'补卡手续费','退卡','发卡押金','退卡押金','退柜押金')  and  pay_time between ? and ?");

		s = en.executeQuery(sql.toString(), new Object[] { from, to });
		if (s > 0) {
			list.addAll(en.getValues());
		}
		
		
		
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> map = list.get(i);
			if (map.containsKey("total_real_amt")) {
				map.put("total_real_amt", Utils.toPriceFromLongStr(getValue(map, "total_real_amt") + ""));
			}
			if (map.containsKey("total_ca_amt")) {
				map.put("total_ca_amt", Utils.toPriceFromLongStr(getValue(map, "total_ca_amt") + ""));
			}
			if (map.containsKey("total_cash_amt")) {
				map.put("total_cash_amt", Utils.toPriceFromLongStr(getValue(map, "total_cash_amt") + ""));
			}
			if (map.containsKey("total_card_cash_amt")) {
				map.put("total_card_cash_amt", Utils.toPriceFromLongStr(getValue(map, "total_card_cash_amt") + ""));
			}
			if (map.containsKey("total_card_amt")) {
				map.put("total_card_amt", Utils.toPriceFromLongStr(getValue(map, "total_card_amt") + ""));
			}
			if (map.containsKey("total_vouchers_amt")) {
				map.put("total_vouchers_amt", Utils.toPriceFromLongStr(getValue(map, "total_vouchers_amt") + ""));
			}
			if (map.containsKey("total_wx_amt")) {
				map.put("total_wx_amt", Utils.toPriceFromLongStr(getValue(map, "total_wx_amt") + ""));
			}
			if (map.containsKey("total_ali_amt")) {
				map.put("total_ali_amt", Utils.toPriceFromLongStr(getValue(map, "total_ali_amt") + ""));
			}

		}
		this.obj.put("list", list);
		/*
		 * for(String key:obj.keySet()){ JSONArray arr =
		 * this.obj.getJSONArray(key); for(int i=0;i<arr.length();i++){
		 * JSONObject o = arr.getJSONObject(i); if(o.has("total_real_amt")){
		 * o.put("total_real_amt",
		 * Utils.toPriceFromLongStr(o.getString("total_real_amt"))); }
		 * if(o.has("total_ca_amt") && !o.has("card_type")){
		 * o.put("total_ca_amt",
		 * Utils.toPriceFromLongStr(o.getString("total_ca_amt"))); }
		 * if(o.has("total_cash_amt")){ o.put("total_cash_amt",
		 * Utils.toPriceFromLongStr(o.getString("total_cash_amt"))); }
		 * if(o.has("total_card_cash_amt")){ o.put("total_card_cash_amt",
		 * Utils.toPriceFromLongStr(o.getString("total_card_cash_amt"))); }
		 * if(o.has("total_card_amt")){ o.put("total_card_amt",
		 * Utils.toPriceFromLongStr(o.getString("total_card_amt"))); }
		 * if(o.has("total_vouchers_amt")){ o.put("total_vouchers_amt",
		 * Utils.toPriceFromLongStr(o.getString("total_vouchers_amt"))); }
		 * if(o.has("total_wx_amt")){ o.put("total_wx_amt",
		 * Utils.toPriceFromLongStr(o.getString("total_wx_amt"))); }
		 * if(o.has("total_ali_amt")){ o.put("total_ali_amt",
		 * Utils.toPriceFromLongStr(o.getString("total_ali_amt"))); } } }
		 */

	}

	public String getValue(Map<String, Object> m, String key) {
		if (m.get(key) != null) {
			return m.get(key).toString();
		}
		return "0";
	}
}
