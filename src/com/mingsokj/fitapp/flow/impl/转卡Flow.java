package com.mingsokj.fitapp.flow.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;

import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.flow.Flow;
import com.mingsokj.fitapp.m.FitUser;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.utils.MemUtils;

public class 转卡Flow extends Flow {

	@Override
	public void beforeData() throws Exception {
		// TODO Auto-generated method stub

	}

	@Override
	public void saveData() throws Exception {
		this.getAct();
		FitUser user = (FitUser) this.getAct().getSessionUser();
		String caPrice = this.getFormDataVal("caPrice");
		String toGym = this.getFormDataVal("toGym");// 被转会员所在GYM
		String gym = this.getFormDataVal("gym");// 当前GYM
		String cust_name = this.getFormDataVal("cust_name");
		String mem_id = this.getFormDataVal("mem_id");// 被转卡人id
		String remark = this.getFormDataVal("remark");
		String fk_user_card_id = this.getFormDataVal("fk_user_card_id");
		String fk_user_gym = this.getFormDataVal("fk_user_gym");
		String fk_user_id = this.getFormDataVal("fk_user_id");// 转卡人ID
		String transCardNo = this.getFormDataVal("transCardNo");//是否转卡号
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

		Entity en = new EntityImpl(this.getAct());
		int size = en.executeQuery("select * from f_user_card_" + fk_user_gym + " where id=?",
				new Object[] { fk_user_card_id });
		if (size > 0) {
			String from_id = en.getStringValue("id");
			String from_cust_name = en.getStringValue("cust_name");

			String from_card_id = en.getStringValue("card_id");
			String from_buy_time = en.getStringValue("buy_time");
			String from_active_type = en.getStringValue("active_type");
			String from_active_time = en.getStringValue("active_time");
			String from_deadline = en.getStringValue("deadline");
//			String from_real_amt = en.getStringValue("real_amt");
			String from_state = en.getStringValue("state");
			String from_remain_times = en.getStringValue("remain_times");

			en = new EntityImpl("f_user_card", this.getAct());
			en.setTablename("f_user_card_" + toGym);
			en.setValue("cust_name", from_cust_name);
			en.setValue("gym", gym);
			en.setValue("card_id", from_card_id);
			en.setValue("mem_id", mem_id);
			en.setValue("buy_time", from_buy_time);
			en.setValue("active_type", from_active_type);
			en.setValue("active_time", from_active_time);
			en.setValue("deadline", from_deadline);
			en.setValue("real_amt", 0);
			en.setValue("ca_amt", 0);
			en.setValue("state", from_state);
			en.setValue("remain_times", from_remain_times);
			en.setValue("buy_times", "-1");//-1表示该卡不是购买来的
			en.setValue("emp_id", "-1");
			en.setValue("remark", remark);
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String now = sdf.format(new Date());
			en.setValue("pay_time", now);
			en.setValue("create_time", now);
			en.create();
			en.executeUpdate("update f_user_card_" + fk_user_gym + "  set state='007',deadline='"
					+ sdf.format(new Date()) + "' where id=?", new Object[] { from_id });

			/**
			 * 如果被转卡人的状态未激活 则激活该会员
			 */
			MemInfo toMem = MemUtils.getMemInfo(mem_id, from_cust_name);
			MemInfo fromMem = MemUtils.getMemInfo(fk_user_id, from_cust_name);
			if (toMem != null) {
				String state = toMem.getState();
				if (!"001".equals(state)) {
					MemInfo.updateStateByGym("001", gym, this.getConn(), mem_id);
				}
				if(!Utils.isNull(fromMem.getMem_no()) && "Y".equals(transCardNo)){
					toMem.setMem_no(fromMem.getMem_no());
					toMem.update(this.getAct().getConnection(), false);
				}
			}
			/**
			 * 如果被转卡人转出了全部卡，则改变其状态（如果用户还有余额则不改变状态）
			 */
			if (fromMem != null) {
				List<Map<String, Object>> cardList = fromMem.getCardList(user.getViewGym());
				if (cardList.size() == 0) {
					if (fromMem.getRemainAmt() == 0) {
						MemInfo.updateStateByGym("007", gym, this.getConn(), fk_user_id);
					}
				}
				if(!Utils.isNull(fromMem.getMem_no()) && "Y".equals(transCardNo)){
					fromMem.setMem_no("=no=");
					fromMem.update(this.getAct().getConnection(), false);
				}
			}

			en = new EntityImpl("f_other_pay", this.getAct());
			en.setTablename("f_other_pay_" + gym);
			setPayEntityInfo(en, (Long.parseLong(caPrice) * 100) + "");
			en.setValue("pay_type", "转卡手续费");
			en.setValue("emp_id", user.getId());
			en.setValue("mem_id", fk_user_id);
			en.create();

			JSONObject obj = new JSONObject();
			obj.put("op_time", sdf.format(new Date()));
			obj.put("flow_num", fk_user_id);
			JSONArray goods = new JSONArray();
			JSONObject good = new JSONObject();
			good.put("name", "转卡手续费");
			good.put("price", caPrice);
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
			// 修改会员的状态
			en = new EntityImpl(this.getAct().getConnection());
			MemInfo.updateStateByGym("001", gym, this.getConn(), mem_id);
			this.getAct().obj.put("obj", obj);
			
		} else {
			throw new Exception("未查询到相关卡片，请刷新页面后重试");
		}

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
