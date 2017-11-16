package com.mingsokj.fitapp.ws.bg.cashier;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Map;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.m.FitUser;
import com.mingsokj.fitapp.utils.MemUtils;

public class 消费记录 extends BasicAction {
	// 消费记录
	@Route(value = "/yp-ws-app-consume", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void consume() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String fk_user_id = request.getParameter("fk_user_id");
		String cur = request.getParameter("cur");
		if (cur == null || cur.length() <= 0) {
			cur = "1";
		}
		List<Map<String, Object>> list = new ArrayList<>();
		List<Map<String, Object>> listCheck = new ArrayList<>();
		List<Map<String, Object>> listCheckOut = new ArrayList<>();
		List<Map<String, Object>> listOther = new ArrayList<>();
		List<Map<String, Object>> listFlow = new ArrayList<>();
		List<Map<String, Object>> listLevel = new ArrayList<>();
		List<Map<String, Object>> listGoods = new ArrayList<>();

		int pageSize = 7;
		int curPage = Integer.parseInt(cur);
		int start = (curPage - 1) * pageSize + 1;
		int end = pageSize * curPage;

		Entity en = new EntityImpl(this);
		String sql = "select b.card_name,b.card_type, a.id,a.real_amt , a.pay_time,a.give_card,a.gym from f_user_card_"
				+ gym + " a , f_card b where mem_id = ? and a.card_id = b.ID";
		int size = en.executeQueryWithMaxResult(sql, new String[] { fk_user_id }, start, end);
		list = en.getValues();
		int total = en.getMaxResultCount();
		for (int i = 0; i < size; i++) {
			Map<String, Object> map = list.get(i);
			String buy_id = en.getStringValue("id", i);
			String give_card = en.getStringValue("give_card", i);// 是否发卡
			String mem_gym = en.getStringValue("gym", i);// 是否发卡
			String card_type = en.getStringValue("card_type", i);
			String consume_mold = en.getStringValue("card_name", i);
			long real_amt = en.getLongValue("real_amt", i);
			String pay_time = en.getFormatStringValue("pay_time", "yyyy-MM-dd HH:mm:ss", i);
			map.put("consume_mold", consume_mold);
			map.put("real_amt", Utils.toPrice(real_amt));
			map.put("pay_time", pay_time);
			map.put("buy_id", buy_id);
			map.put("mem_gym", mem_gym);
			map.put("give_card", give_card);
			map.put("card_type", card_type);
		}
		// 入场
		size = en.executeQuery(
				"SELECT id,CHECKIN_TIME as pay_time, CHECKIN_FEE as real_amt,CHECKIN_CARD_NAME as consume_mold from f_checkin_"
						+ gym + " WHERE MEM_ID=?",
				new String[] { fk_user_id });
		if (size > 0) {
			listCheck = en.getValues();
			for (int i = 0; i < listCheck.size(); i++) {
				listCheck.get(i).put("consume_mold", "入场");
				// 判断是否支付，如果支付将价格封装到list中
				String real_amt = en.getStringValue("real_amt", i);
				if ("".equals(real_amt) || real_amt == null) {
					listCheck.get(i).put("real_amt", "0.00");
				}
			}
			list.addAll(listCheck);
		}

		// 出场
		size = en.executeQuery(
				"SELECT CHECKOUT_TIME as pay_time , CHECKIN_FEE as real_amt,CHECKIN_CARD_NAME as consume_mold from f_checkin_"
						+ gym + " WHERE MEM_ID=? AND CHECKOUT_TIME is not null",
				new String[] { fk_user_id });
		if (size > 0) {
			listCheckOut = en.getValues();
			for (int i = 0; i < listCheckOut.size(); i++) {
				listCheckOut.get(i).put("consume_mold", "出场");
				listCheckOut.get(i).put("real_amt", "0.00");
			}
			list.addAll(listCheckOut);
		}

		// 其他支付记录
		size = en.executeQuery(
				"SELECT pay_time ,pay_type as consume_mold, real_amt from f_other_pay_" + gym + " WHERE mem_id=?",
				new String[] { fk_user_id });
		if (size > 0) {
			listOther = en.getValues();
			for (int i = 0; i < listOther.size(); i++) {
				long real_amt = en.getLongValue("real_amt", i);
				String consume_mold = en.getStringValue("consume_mold", i);
				listOther.get(i).put("consume_mold", consume_mold);
				listOther.get(i).put("real_amt", Utils.toPrice(real_amt));
			}
			list.addAll(listOther);
		}

		// 流水记录
		size = en.executeQuery(
				"SELECT op_time as pay_time,flow_type as consume_mold from f_flow_" + gym + " WHERE mem_id=? ",
				new String[] { fk_user_id });
		if (size > 0) {
			listFlow = en.getValues();
			for (int i = 0; i < listFlow.size(); i++) {
				String consume_mold = en.getStringValue("consume_mold", i);
				listFlow.get(i).put("consume_mold", consume_mold);
				listFlow.get(i).put("real_amt", "0.00");
			}
			list.addAll(listFlow);
		}

		// 请假记录
		size = en.executeQuery("SELECT pay_time ,REAL_AMT  from f_leave WHERE MEM_ID=? ", new String[] { fk_user_id });
		if (size > 0) {
			listLevel = en.getValues();
			for (int i = 0; i < listLevel.size(); i++) {
				listLevel.get(i).put("consume_mold", "请假");
				// 判断是否支付，如果支付将价格封装到list中
				long real_amt = en.getLongValue("real_amt", i);
				listLevel.get(i).put("real_amt", Utils.toPrice(real_amt));
			}
			list.addAll(listLevel);
		}

		// 商品销售
		size = en.executeQuery(
				"SELECT c.MEM_NAME , a.REAL_AMT ,a.pay_time from f_store_rec_" + gym + " a ,  f_mem_"
						+ user.getCust_name() + " c where a.MEM_ID =c.ID and a.mem_id = ? ",
				new String[] { fk_user_id });
		if (size > 0) {
			listGoods = en.getValues();
			for (int i = 0; i < listGoods.size(); i++) {
				listGoods.get(i).put("consume_mold", "购买商品");
				// 判断是否支付，如果支付将价格封装到list中
				long real_amt = en.getLongValue("real_amt", i);
				listGoods.get(i).put("real_amt", Utils.toPrice(real_amt));
			}
			list.addAll(listGoods);
		}

		total += en.getMaxResultCount();
		int totalpage = 0;
		int temp = total / pageSize;
		totalpage = total % pageSize > 0 ? temp + 1 : temp > 0 ? temp : 1;

		this.obj.put("consumelist", list);
		this.obj.put("total", total);
		this.obj.put("totalPage", totalpage);
		this.obj.put("curPage", curPage);
		this.obj.put("curSize", list.size());
		this.obj.put("user_id", fk_user_id);

	}

	// 失效会员卡
	@Route(value = "yp-ws-app-old_card", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void old_card() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String cust_name = user.getCust_name();
		String fk_user_id = request.getParameter("fk_user_id");
		List<Map<String, Object>> cardList = new ArrayList<>();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

		/*
		 * Entity en = new EntityImpl(this); String sql =
		 * " select a.*,b.card_name,b.card_type,b.id card_id from f_user_card_"
		 * + gym +
		 * " a,f_card b where a.card_id = b.id and a.mem_id=? and a.gym=? "; int
		 * size = en.executeQuery(sql, new String[] { fk_user_id, gym });
		 */

		List<Map<String, Object>> list = MemUtils.getMemCardsByOldCard(fk_user_id, gym, cust_name, L);
		if (list != null && list.size() > 0) {
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> map = list.get(i);
				String card_name = Utils.getMapStringValue(map, "card_name");
				String state = Utils.getMapStringValue(map, "state");
				String deadline = Utils.getMapStringValue(map, "deadline");
				map.put("card_name", card_name);
				map.put("deadline", deadline);
				Date dl = sdf.parse(deadline);
				if ("007".equals(state) || "008".equals(state) || "009".equals(state) || dl.before(new Date())) {
					cardList.add(map);
				}

			}

		}
		// List<Map<String, Object>> list = en.getValues();
		this.obj.put("oldCard", new HashSet<>(cardList));
		this.obj.put("user_id", fk_user_id);

	}

}
