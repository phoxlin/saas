package com.mingsokj.fitapp.flow.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
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

public class 补卡Flow extends Flow {

	@Override
	public void beforeData() throws Exception {
		// TODO Auto-generated method stub

	}

	@Override
	public void saveData() throws Exception {
		String fk_user_id = this.getFormDataVal("userId");
		String gym = this.getFormDataVal("gym");
		String cust_name = this.getFormDataVal("cust_name");
		String ca_amt = this.getFormDataVal("real_amt");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

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

		String mem_no = this.getFormDataVal("mem_no");

		// cust_name
		Entity en = new EntityImpl(this.getAct());
		String sql = "";
		ArrayList<String> parList = new ArrayList<String>();
		int size = en.executeQuery("select gym from f_gym where cust_name=?", new Object[] { cust_name });
		for (int i = 0; i < size; i++) {
			sql += "select id,gym from f_user_card_" + en.getStringValue("gym", i) + " where state='006' and mem_id=?";
			if (size - 1 != i) {
				sql += " union ";
			}
			parList.add(fk_user_id);
		}

		size = en.executeQuery(sql, parList.toArray());
		if (size > 0) {
			for (int i = 0; i < size; i++) {
				Entity e = new EntityImpl(this.getAct().getConnection());
				e.executeUpdate("update f_user_card_" + en.getStringValue("gym", i) + " set state='001' where id=?",
						new Object[] { en.getStringValue("id", i) });
			}
		}

		MemInfo info = new MemInfo();
		info.setId(fk_user_id);
		info.setMem_no(mem_no);
		info.setGym(gym);
		info.setState("001");
		info.update(this.getAct().getConnection(), false);

		en = new EntityImpl("f_other_pay", this.getAct());
		en.setTablename("f_other_pay_" + gym);
		setPayEntityInfo(en, (Long.parseLong(ca_amt) * 100) + "");
		en.setValue("pay_type", "补卡手续费");
		en.setValue("mem_id", fk_user_id);
		FitUser user = (FitUser) this.getAct().getSessionUser();
		en.setValue("emp_id", user.getId());
		en.create();

		JSONObject obj = new JSONObject();
		obj.put("op_time", sdf.format(new Date()));
		obj.put("flow_num", fk_user_id);
		JSONArray goods = new JSONArray();
		JSONObject good = new JSONObject();
		good.put("name", "补卡");
		good.put("price", ca_amt);
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
		obj.put("card_number", mem_no);
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
