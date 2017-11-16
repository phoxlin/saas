package com.mingsokj.fitapp.flow.impl;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.json.JSONArray;
import org.json.JSONObject;

import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.flow.Flow;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.utils.MemUtils;

public class 预付定金Flow extends Flow {

	@Override
	public void beforeData() throws Exception {
		// TODO Auto-generated method stub

	}

	@Override
	public void saveData() throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String gym = this.getFormDataVal("gym");
		String cust_name = this.getFormDataVal("cust_name");
		String fk_user_id = this.getFormDataVal("fk_user_id");
		String pre_money = this.getFormDataVal("pre_money");
		String real_money = this.getFormDataVal("real_money");
		String user_time = this.getFormDataVal("user_time");
		String emp_id = this.getFormDataVal("emp_id");

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

		Entity en = new EntityImpl("f_pre_fee", this.getAct());
		en.setTablename("f_pre_fee_" + gym);
		en.setValue("cuat_name", cust_name);
		en.setValue("gym", gym);
		en.setValue("pay_amt", pre_money);
		en.setValue("user_amt", real_money);
		en.setValue("state", "001");
		en.setValue("mem_id", fk_user_id);
		en.setValue("emp_id", emp_id);
		en.setValue("user_time", user_time);
		en.setValue("op_time", sdf.format(new Date()));

		String pre_id = en.create();
		// 添加到other_pay
		Entity other = new EntityImpl("f_other_pay", this.getAct());
		other.setTablename("f_other_pay_" + gym);
		other.setValue("pay_type", "付定金");
		other.setValue("mem_id", fk_user_id);
		other.setValue("emp_id", emp_id);
		setPayEntityInfo(other, this.getPayDataLongPriceVal("ca_amt") + "");
		other.create();

		JSONObject obj = new JSONObject();
		obj.put("op_time", sdf.format(new Date()));
		obj.put("flow_num", pre_id);
		JSONArray goods = new JSONArray();
		JSONObject good = new JSONObject();
		good.put("name", "预付定金");
		good.put("price", pre_money);
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
		obj.put("user_name", mem.getName());
		obj.put("remain_amt", mem.remainAmt(getConn()));
		obj.put("phone", mem.getPhone());

		this.getAct().obj.put("obj", obj);

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
