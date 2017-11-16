package com.mingsokj.fitapp.flow.impl;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.json.JSONArray;
import org.json.JSONObject;

import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.flow.Flow;
import com.mingsokj.fitapp.m.FitUser;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.utils.MemUtils;

public class 充值Flow extends Flow {

	@Override
	public void beforeData() throws Exception {
		// TODO Auto-generated method stub

	}

	@Override
	public void saveData() throws Exception {
		String gym = this.getFormDataVal("gym");
		String cust_name = this.getFormDataVal("cust_name");
		String fk_user_id = this.getFormDataVal("fk_user_id");
		String money = this.getFormDataVal("money");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		Entity en = new EntityImpl(this.getAct());
		en.executeQuery("select remain_amt from f_mem_" + cust_name + " where id=?", new Object[] { fk_user_id });
		long remain_amt = en.getLongValue("remain_amt");
		remain_amt = remain_amt + Utils.toPriceLong(money);
		
		MemInfo.updateRemainAmtByCustname(remain_amt, fk_user_id, cust_name, this.getConn());
		
		FitUser user = (FitUser) this.getAct().getSessionUser();
		Entity entity = new EntityImpl("f_other_pay", this.getAct());
		entity.setTablename("f_other_pay_" + gym);
		Float f = Float.parseFloat(money) * 100;
		setPayEntityInfo(entity, f.intValue() + "");
		entity.setValue("pay_type", "充值");
		entity.setValue("mem_id", fk_user_id);
		entity.setValue("emp_id", user.getId());
		entity.create();

		JSONObject obj = new JSONObject();
		obj.put("op_time", sdf.format(new Date()));
		obj.put("flow_num", fk_user_id);
		JSONArray goods = new JSONArray();
		JSONObject good = new JSONObject();
		good.put("name", "充值");
		good.put("price", money);
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
		obj.put("remain_amt",  mem.remainAmt(getConn()));
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
