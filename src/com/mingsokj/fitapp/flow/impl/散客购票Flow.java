package com.mingsokj.fitapp.flow.impl;

import java.util.Date;

import org.json.JSONArray;
import org.json.JSONObject;

import com.jinhua.server.BasicAction;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.flow.Flow;

public class 散客购票Flow extends Flow {

	@Override
	public void beforeData() throws Exception {

	}

	@Override
	public void saveData() throws Exception {
		BasicAction action = this.getAct();
		action.getConnection();
		String gym = this.getFormDataVal("gym");
		String cust_name = this.getFormDataVal("cust_name");
		String card_id = this.getFormDataVal("card_id");
		String freePay = this.getPayDataVal("freePay");
		String ca_amt = this.getPayDataLongPriceVal("ca_amt") + "";
		Entity entity = new EntityImpl("f_fit", this.getAct());
		// 获取改卡的有效
		Entity en = new EntityImpl("f_card", this.getAct().getConnection());
		en.setValue("id", card_id);
		int size = en.search();
		int days = 0;
		if (size > 0) {
			try {
				days = en.getIntegerValue("days");
			} catch (Exception e) {
			} finally {
				days = 365 * 100;
			}
		} else {
			throw new Exception("请选择会员卡");

		}

		String emp_id = this.getFormDataVal("emp_id");

		int num = Integer.parseInt(this.getFormDataVal("num"));// 有效期天数
		JSONArray arr = new JSONArray();

		Date deadline = Utils.dateAddDay(new Date(), days);
		String ds = Utils.parseData(deadline, "yyyy-MM-dd HH:mm");
		for (int i = 0; i < num; i++) {
			com.jinhua.server.flow.Flow flow = new com.jinhua.server.flow.Flow();
			String checkin_no = flow.getFlownum();
			entity.setValue("cust_name", cust_name);
			entity.setValue("gym", gym);
			entity.setValue("card_id", card_id);
			entity.setValue("deadline", deadline);
			entity.setValue("emp_id", emp_id);
			entity.setValue("pay_time", new Date());
			entity.setValue("checkin_no", checkin_no);
			entity.setValue("state", "Y");// 状态Y已支付
			if (i == 0) {
				setPayEntityInfo(entity, ca_amt);
			} else {
				entity.setValue("cash", 0);
				entity.setValue("card", 0);
				entity.setValue("remain_amt", 0);
				entity.setValue("vouchers_amt", 0);
				entity.setValue("wx", 0);
				entity.setValue("ali", 0);
				entity.setValue("real_amt", 0);
				entity.setValue("is_free", freePay);
			}
			String buy_id = entity.create();

			// 购买信息
			JSONObject obj = new JSONObject();
			obj.put("buy_id", buy_id);
			obj.put("checkin_no", checkin_no);
			obj.put("deadline", ds);
			obj.put("real_amt", Utils.toPrice(this.getPayDataLongPriceVal("real_amt") / num));
			arr.put(obj);
		}
		action.obj.put("obj", arr);
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
