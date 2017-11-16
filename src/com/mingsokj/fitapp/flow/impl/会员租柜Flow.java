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

/**
 * @author liul 2017年7月27日上午11:21:03
 */
public class 会员租柜Flow extends Flow {

	@Override
	public void beforeData() throws Exception {
		// TODO Auto-generated method stub

	}

	@Override
	public void saveData() throws Exception {
		SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		this.getAct().getConnection();
		FitUser user = (FitUser) this.getAct().getSessionUser();
		String gym = this.getFormDataVal("gym");
		String cust_name = this.getFormDataVal("cust_name");
		String caPrice = Integer.parseInt(this.getFormDataVal("caPrice")) * 100 + "";
		String ca_amt = this.getFormDataVal("real_amt");
		String box_id = this.getFormDataVal("box_id");
		String emp_id = this.getFormDataVal("emp_id");
		String rentStartTime = this.getFormDataVal("rentStartTime");
		String rentEndTime = this.getFormDataVal("rentEndTime");
		String userId = this.getFormDataVal("userId");
		String rentRemark = this.getFormDataVal("rentRemark");
		String cash = this.getFormDataVal("cash");
		// 实际支付价格减去了押金的
		float allPrice = Float.parseFloat(caPrice);
		float cashPrice = Float.parseFloat(cash) * 100;
		String rent_box_amt = (allPrice - cashPrice) + "";
		String type = this.getFormDataVal("type");
		JSONArray goods = new JSONArray();

		/**
		 * 余额支付
		 */
		Long remain_amt = Utils.toPriceLong(this.getPayDataVal("remain_amt"));
		if (remain_amt > 0) {
			MemInfo info = MemUtils.getMemInfo(userId, cust_name);
			if (info != null) {
				long user_remain_amt = info.getRemainAmt();
				user_remain_amt = user_remain_amt - remain_amt;
				if (user_remain_amt < 0) {
					throw new Exception("会员余额不足，暂不能使用余额支付");
				}
				MemInfo.updateRemainAmtByCustname(user_remain_amt, userId, cust_name, this.getConn());
			} else {
				throw new Exception("未查询到相关会员信息");
			}
		}

		Entity en = new EntityImpl("f_rent", this.getAct());
		en.setTablename("f_rent_" + gym);
		if ("xuFei".equals(type)) {
			String rent_id = this.getFormDataVal("rent_id");
			en.setValue("id", rent_id);
			en.search();
			// 拿到之前的价格，将续费价格叠加上去
			long real_amt = en.getLongValue("real_amt") + this.getPayDataLongPriceVal("real_amt");
			long cash_amt = en.getLongValue("cash_amt") + this.getPayDataLongPriceVal("real_amt");
			;
			long card_cash_amt = en.getLongValue("card_cash_amt") + this.getPayDataLongPriceVal("remain_amt");
			long card_amt = en.getLongValue("card_amt") + this.getPayDataLongPriceVal("card");
			long wx_amt = en.getLongValue("wx_amt") + this.getPayDataLongPriceVal("wx");
			long ali_amt = en.getLongValue("ali_amt") + this.getPayDataLongPriceVal("ali");
			long rent_box_amt_xufei = en.getLongValue("rent_box_amt")
					+ (this.getPayDataLongPriceVal("real_amt") * 100 - this.getPayDataLongPriceVal("real_amt") * 100);
			String vouchers_num = this.getPayDataVal("vouchers_num");
			boolean is_free = Utils.isTrue(this.getPayDataVal("freePay"));
			boolean staff_account = Utils.isTrue(this.getPayDataVal("empDelayPay"));
			boolean print = Utils.isTrue(this.getPayDataVal("xiaopiaoPrint"));
			boolean send_msg = Utils.isTrue(this.getPayDataVal("sendmsm"));
			long vouchers_amt = this.getPayDataLongPriceVal("ticket");
			en.setValue("id", rent_id);
			if (is_free) {
				en.setValue("real_amt", 0);
				en.setValue("ca_amt", ca_amt);
				en.setValue("cash_amt", 0);
				en.setValue("card_cash_amt", 0);
				en.setValue("card_amt", 0);
				en.setValue("vouchers_amt", 0);
				en.setValue("vouchers_num", 0);
				en.setValue("wx_amt", 0);
				en.setValue("ali_amt", 0);
				en.setValue("pay_way", "free");
				en.setValue("rent_box_amt", rent_box_amt_xufei);
			} else {
				en.setValue("real_amt", real_amt);
				en.setValue("ca_amt", ca_amt);
				en.setValue("cash_amt", cash_amt);
				en.setValue("card_cash_amt", card_cash_amt);
				en.setValue("card_amt", card_amt);
				en.setValue("vouchers_amt", vouchers_amt);
				en.setValue("vouchers_num", vouchers_num);
				en.setValue("wx_amt", wx_amt);
				en.setValue("ali_amt", ali_amt);
				en.setValue("rent_box_amt", rent_box_amt_xufei);
				boolean set = false;
				if (cash_amt > 0) {
					set = true;
					en.setValue("pay_way", "cash_amt");
				}
				if (card_cash_amt > 0) {
					if (set) {
						en.setValue("pay_way", "together");
					} else {
						en.setValue("pay_way", "card_cash_amt");
					}
					set = true;
				}
				if (card_amt > 0) {
					if (set) {
						en.setValue("pay_way", "together");
					} else {
						en.setValue("pay_way", "card_amt");
					}
					set = true;
				}

				if (vouchers_amt > 0) {
					if (set) {
						en.setValue("pay_way", "together");
					} else {
						en.setValue("pay_way", "vouchers_amt");
					}
					set = true;
				}

				if (wx_amt > 0) {
					if (set) {
						en.setValue("pay_way", "together");
					} else {
						en.setValue("pay_way", "wx_amt");
					}
					set = true;
				}

				if (ali_amt > 0) {
					if (set) {
						en.setValue("pay_way", "together");
					} else {
						en.setValue("pay_way", "ali_amt");
					}
					set = true;
				}

			}
			en.setValue("is_free", is_free ? "Y" : "N");
			en.setValue("staff_account", staff_account ? "Y" : "N");
			en.setValue("print", print ? "Y" : "N");
			en.setValue("send_msg", send_msg ? "Y" : "N");
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			en.setValue("pay_time", sdf.format(new Date()));
			en.setValue("end_time", rentEndTime);
			en.update();
			// 将续费添加到other pay
			Entity entity = new EntityImpl("f_other_pay", this.getAct());
			entity.setTablename("f_other_pay_" + gym);
			setPayEntityInfo(entity, caPrice);
			entity.setValue("pay_type", "租柜费用");
			entity.setValue("mem_id", userId);
			entity.setValue("emp_id", user.getId());
			entity.create();

			// 租柜成功后修改柜子状态
			en.executeUpdate("update f_box set state='N' where id=?", new String[] { box_id });
			JSONObject good = new JSONObject();
			good.put("name", "租柜续费");
			good.put("price", this.getPayDataLongPriceVal("real_amt") / 100);
			good.put("num", 1);
			goods.put(good);

		} else {
			en.setValue("cust_name", cust_name);
			en.setValue("gym", gym);
			en.setValue("mem_id", userId);
			en.setValue("box_id", box_id);
			en.setValue("start_time", rentStartTime);
			en.setValue("end_time", rentEndTime);
			en.setValue("RENT_REMARK", rentRemark);
			en.setValue("emp_id", emp_id);
			en.setValue("OP_TIME", new Date());
			en.setValue("RENT_DEPOSIT_AMT", cash);
			en.setValue("rent_box_amt", rent_box_amt);// 租柜价格
			en.setValue("state", "001");
			setPayEntityInfo(en, caPrice);
			en.create();

			// 拿到租柜押金，添加到押金表中
			Entity entity = new EntityImpl("f_other_pay", this.getAct());
			entity.setTablename("f_other_pay_" + gym);
			setPayEntityInfo(entity, caPrice);
			entity.setValue("pay_type", "租柜费用");
			entity.setValue("mem_id", userId);
			entity.setValue("emp_id", user.getId());
			entity.create();
			// 租柜成功后修改柜子状态
			en.executeUpdate("update f_box set state='N' where id=?", new String[] { box_id });
			JSONObject good = new JSONObject();
			good.put("name", "租柜费用");
			good.put("price", (allPrice - cashPrice) / 100);
			good.put("num", 1);
			goods.put(good);
			good = new JSONObject();
			good.put("name", "租柜押金");
			good.put("price", cash);
			good.put("num", 1);
			goods.put(good);
		}
		JSONObject obj = new JSONObject();
		obj.put("op_time", sdf2.format(new Date()));
		obj.put("flow_num", "");
		obj.put("goods", goods);
		obj.put("real_amt", this.getPayDataLongPriceVal("real_amt"));
		obj.put("ca_amt", this.getPayDataLongPriceVal("ca_amt") / 100);
		obj.put("cash_amt", this.getPayDataLongPriceVal("cash"));
		obj.put("wx_amt", this.getPayDataLongPriceVal("wx"));
		obj.put("card_amt", this.getPayDataLongPriceVal("remain_amt"));
		obj.put("card_cash_amt", this.getPayDataLongPriceVal("card"));
		obj.put("ali_amt", this.getPayDataLongPriceVal("ali"));
		MemInfo mem = MemUtils.getMemInfo(userId, cust_name);
		obj.put("user_name", mem.getName());
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
