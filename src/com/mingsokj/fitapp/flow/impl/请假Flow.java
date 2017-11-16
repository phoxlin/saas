package com.mingsokj.fitapp.flow.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;

import com.jinhua.server.BasicAction;
import com.jinhua.server.c.Code;
import com.jinhua.server.c.Codes;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.flow.Flow;
import com.mingsokj.fitapp.m.FitUser;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.utils.MemUtils;

public class 请假Flow extends Flow {

	@Override
	public void beforeData() throws Exception {
	}

	@Override
	public void saveData() throws Exception {

		FitUser user = (FitUser) this.getAct().getSessionUser();
		String cust_name = user.getCust_name();
		BasicAction action = this.getAct();

		String fk_user_id = this.getFormDataVal("fk_user_id");
		String fk_user_gym = this.getFormDataVal("fk_user_gym");
		String startTime = this.getFormDataVal("startTime");
		String endTimes = this.getFormDataVal("endTimes");
//		String fee = this.getFormDataVal("fee");
		String leave_num = this.getFormDataVal("leave_num");
		String remark = this.getFormDataVal("remark");
		String freePay = this.getPayDataVal("freePay");

		String buy_card_id = this.getFormDataVal("buy_card_id");
		String is_free = this.getFormDataVal("is_free");
		// 免费请假 更新已请假次数
		if ("true".equals(is_free)) {
			Entity en = new EntityImpl(action);
			Map<String, Object> card = MemUtils.getMemCardsById(buy_card_id, fk_user_id, cust_name, fk_user_gym);
			int leave_times = Utils.getMapIntegerValue(card, "leave_times") + 1;

			en.executeUpdate("update f_user_card_" + card.get("gym") + " set leave_times =? where id = ?",
					new Object[] { leave_times, buy_card_id });
		}
		// 检查应付价格
		String card_id = this.getFormDataVal("card_id");
		Entity en = new EntityImpl(action);
		int s = en.executeQuery("select leave_unit_price from f_card where id = ?", new Object[] { card_id });
		if (s == 0) {
			throw new Exception("不存在的卡种");
		}
		Long leave_unit_price = en.getLongValue("leave_unit_price");
		if (!"true".equals(is_free) && !"true".equals(freePay)) {
			if (this.getPayDataLongPriceVal("ca_amt") != Long.parseLong(leave_num) * leave_unit_price * 100) {
				throw new Exception("非法操作");
			}
		}

		// 检查用户状态
		en = new EntityImpl(action);
		en.executeQuery("select state from  f_mem_" + cust_name + " where id=?", new String[] { fk_user_id });
		String state = en.getStringValue("state");
		if (!"001".equals(state)) {
			Code code = Codes.code("user_state");
			String note = code.getNote(state);
			throw new Exception("用户状态为【" + note + "】,暂不能请假");
		}

		/**
		 * 余额支付
		 */
		Long remain_amt = Utils.toPriceLong(this.getPayDataVal("remain_amt"));
		if (remain_amt > 0) {
			MemInfo info = MemUtils.getMemInfo(fk_user_id, cust_name);
			if (info != null) {
				long user_remain_amt = info.getRemainAmt();
				user_remain_amt = user_remain_amt - remain_amt;
				if (user_remain_amt < 0) {
					throw new Exception("会员余额不足，暂不能使用余额支付");
				}
				MemInfo.updateRemainAmtByCustname(user_remain_amt, fk_user_id, cust_name, this.getConn());
			} else {
				throw new Exception("未查询到相关会员信息");
			}
		}

		// 产生请假记录
		en = new EntityImpl("f_leave", action);
		en.setValue("cust_name", user.getCust_name());
		en.setValue("gym", fk_user_gym);
		en.setValue("mem_id", fk_user_id);
		en.setValue("start_time", startTime);
		en.setValue("end_time", endTimes);
		// en.setValue("real_amt", fee);
		en.setValue("remark", remark);
		en.setValue("state", "001");
		en.setValue("emp_id", user.getId());
		// 支付金额记录
		setPayEntityInfo(en, Utils.toPriceLong(this.getPayDataVal("ca_amt")) + "");
		en.create();
		// 更新用户状态
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date start_time = sdf.parse(startTime);
		if (!start_time.after(new Date())) {
			en = new EntityImpl(action);
			MemInfo.updateStateByCustname("005", cust_name, this.getConn(), fk_user_id);

			// 更改所有卡为请假状态
			// cust_name
			String sql = "";
			ArrayList<String> parList = new ArrayList<String>();
			int size = en.executeQuery("select gym from f_gym where cust_name=?", new Object[] { cust_name });
			for (int i = 0; i < size; i++) {
				sql += "select id,gym from f_user_card_" + en.getStringValue("gym", i)
						+ " where state='001' and mem_id=?";
				if (size - 1 != i) {
					sql += " union ";
				}
				parList.add(fk_user_id);
			}

			size = en.executeQuery(sql, parList.toArray());
			if (size > 0) {
				for (int i = 0; i < size; i++) {
					Entity e = new EntityImpl(this.getAct().getConnection());
					e.executeUpdate("update f_user_card_" + en.getStringValue("gym", i) + " set state='004' where id=?",
							new Object[] { en.getStringValue("id", i) });
				}
			}
		}

		JSONObject obj = new JSONObject();
		obj.put("op_time", sdf.format(new Date()));
		obj.put("flow_num", fk_user_id);
		JSONArray goods = new JSONArray();
		JSONObject good = new JSONObject();
		good.put("name", "请假费用");
		good.put("price", this.getPayDataLongPriceVal("real_amt") / 100);
		good.put("num", 1);
		goods.put(good);
		obj.put("goods", goods);
		obj.put("real_amt", this.getPayDataLongPriceVal("real_amt"));
		obj.put("ca_amt", this.getPayDataLongPriceVal("ca_amt") / 100);
		obj.put("cash_amt", this.getPayDataLongPriceVal("cash"));
		obj.put("wx_amt", this.getPayDataLongPriceVal("wx"));
		obj.put("card_amt", this.getPayDataLongPriceVal("remain_amt"));
		obj.put("card_cash_amt", this.getPayDataLongPriceVal("card"));
		obj.put("ali_amt", this.getPayDataLongPriceVal("ali"));
		MemInfo mem = MemUtils.getMemInfo(fk_user_id, cust_name);
		obj.put("card_number", "");
		obj.put("user_name", mem.getName());
		obj.put("remain_amt", mem.remainAmt(getConn()));
		obj.put("phone", mem.getPhone());

		this.getAct().obj.put("obj", obj);

	}

	@Override
	public String getSmsWords() throws Exception {
		return null;
	}

	@Override
	public String getSmsPhoneNumber() throws Exception {
		return null;
	}

}
