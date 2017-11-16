package com.mingsokj.fitapp.flow.impl;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import org.json.JSONArray;
import org.json.JSONObject;

import com.jinhua.server.BasicAction;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.flow.Flow;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.utils.MemUtils;

public class 升级Flow extends Flow {

	@Override
	public void beforeData() throws Exception {
		// TODO Auto-generated method stub

	}

	@Override
	public void saveData() throws Exception {
		BasicAction action = this.getAct();
		String fk_user_id = this.getFormDataVal("fk_user_id");
		String emp_id = this.getFormDataVal("emp_id");
		String fk_user_card_id = this.getFormDataVal("fk_user_card_id");
		String card_type = this.getFormDataVal("card_type");
		String updateCard = this.getFormDataVal("updateCard");
		String gym = this.getFormDataVal("gym");
		String cust_name = this.getFormDataVal("cust_name");

		long now_real_amt = this.getPayDataLongPriceVal("real_amt");
		long now_ca_amt = this.getPayDataLongPriceVal("ca_amt");

		Entity updateEn = new EntityImpl(action);
		int size = updateEn.executeQuery("select * from f_card where id=?", new Object[] { updateCard });
		if (size <= 0) {
			throw new Exception("未查询到相关卡片的信息，请刷新页面后重试");
		}
//		long update_fee = updateEn.getLongValue("fee") * 100;
		long update_days = updateEn.getLongValue("days");
		long update_times = updateEn.getLongValue("times");

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

		Entity en = new EntityImpl(action);
		size = en.executeQuery(
				"select a.*,b.times,b.fee from f_user_card_" + gym + " a,f_card b  where  a.card_id = b.id and a.id=?",
				new Object[] { fk_user_card_id });
		if (size <= 0) {
			throw new Exception("未查询到相关信息，请刷新页面后重试");
		}
		long remain_times = en.getLongValue("remain_times");
		long times = en.getLongValue("times");
//		long old_real_amt = en.getLongValue("real_amt");
		long old_ca_amt = en.getLongValue("ca_amt");
		Date active_time = en.getDateValue("active_time");

		if ("001".equals(card_type)) {// 天数卡
			int countdays = daysBetween(new Date(), active_time);
			Long days = update_days - countdays;
			if (days > 0) {
				// 计算新的到期日期
				Calendar cal = Calendar.getInstance();
				cal.setTime(new Date());
				cal.add(Calendar.DAY_OF_YEAR, days.intValue());
				Date newDeadLine = cal.getTime();
				Entity e = new EntityImpl("f_user_card", action);
				e.setTablename("f_user_card_" + gym);
				e.setValue("card_id", updateCard);
				e.setValue("deadline", newDeadLine);
				e.setValue("give_amt", now_real_amt);
				e.setValue("id", fk_user_card_id);
				e.update();

			} else {
				Entity e = new EntityImpl("f_user_card", action);
				e.setTablename("f_user_card_" + gym);
				e.setValue("card_id", updateCard);
				e.setValue("give_amt", now_real_amt);
				e.setValue("id", fk_user_card_id);
				e.update();
			}
		} else if ("003".equals(card_type)) {
			long useTimes = times - remain_times;
			times = update_times - useTimes;
			if (times > 0) {
				int countdays = daysBetween(new Date(), active_time);
				Long days = update_days - countdays;
				if (days > 0) {
					Calendar cal = Calendar.getInstance();
					cal.setTime(new Date());
					cal.add(Calendar.DAY_OF_YEAR, days.intValue());
					Date newDeadLine = cal.getTime();
					Entity e = new EntityImpl("f_user_card", action);
					e.setTablename("f_user_card_" + gym);
					e.setValue("card_id", updateCard);
					e.setValue("remain_times", times);
					e.setValue("deadline", newDeadLine);
					e.setValue("give_amt",  now_real_amt);
					e.setValue("ca_amt", old_ca_amt + now_ca_amt);
					e.setValue("id", fk_user_card_id);
					e.update();
				} else {
					Entity e = new EntityImpl("f_user_card", action);
					e.setTablename("f_user_card_" + gym);
					e.setValue("card_id", updateCard);
					e.setValue("real_amt", now_real_amt);
					e.setValue("ca_amt", old_ca_amt + now_ca_amt);
					e.setValue("id", fk_user_card_id);
					e.update();
				}

			} else {
				Entity e = new EntityImpl("f_user_card", action);
				e.setTablename("f_user_card_" + gym);
				e.setValue("card_id", updateCard);
				e.setValue("real_amt", now_real_amt);
				e.setValue("ca_amt", old_ca_amt + now_ca_amt);
				e.setValue("id", fk_user_card_id);
				e.update();
			}

		}

		en = new EntityImpl("f_other_pay", action);
		en.setTablename("f_other_pay_" + gym);
		setPayEntityInfo(en,this.getPayDataLongPriceVal("ca_amt")+"");
		en.setValue("emp_id", emp_id);
		en.setValue("pay_type", "升级补差价");
		en.setValue("mem_id", fk_user_id);
		en.setValue("pay_way", "cash_amt");
		en.setValue("is_free", "N");
		en.setValue("staff_account", "N");
		en.setValue("print", "N");
		en.setValue("send_msg", "N");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		en.setValue("pay_time", sdf.format(new Date()));
		en.setValue("pay_way", "");
		en.create();

		JSONObject obj = new JSONObject();
		obj.put("op_time", sdf.format(new Date()));
		obj.put("flow_num", fk_user_id);
		JSONArray goods = new JSONArray();
		JSONObject good = new JSONObject();
		good.put("name", "升级会员卡");
		good.put("price", Utils.toPrice(this.getPayDataLongPriceVal("real_amt")));
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
		obj.put("remain_amt", mem.remainAmt(this.getAct().getConnection()));
		obj.put("phone", mem.getPhone());

		this.getAct().obj.put("obj", obj);
	}

	public static int daysBetween(Date smdate, Date bdate) throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		smdate = sdf.parse(sdf.format(smdate));
		bdate = sdf.parse(sdf.format(bdate));
		Calendar cal = Calendar.getInstance();
		cal.setTime(smdate);
		long time1 = cal.getTimeInMillis();
		cal.setTime(bdate);
		long time2 = cal.getTimeInMillis();
		long between_days = (time2 - time1) / (1000 * 3600 * 24);

		return Integer.parseInt(String.valueOf(between_days));
	}

	@Override
	public String getSmsWords() throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String getSmsPhoneNumber() throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

}
