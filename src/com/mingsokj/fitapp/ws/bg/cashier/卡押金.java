package com.mingsokj.fitapp.ws.bg.cashier;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.json.JSONArray;
import org.json.JSONObject;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.m.FitUser;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.utils.MemUtils;

public class 卡押金 extends BasicAction {

	/**
	 * 会员签到查询
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-cashier-getCardCashInt", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void getCardCashInt() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		Entity en = new EntityImpl(this);
		int size = en.executeQuery("select note from f_param  where  code='card_cash_setting' and gym=?", new Object[] { gym });
		String note = "";
		if (size > 0) {
			note = en.getStringValue("note");
		}
		long fee = 0;
		if (note != null && note.length() > 0) {
			JSONArray arr = new JSONArray(note);
			JSONObject feeObj = (JSONObject) arr.get(0);
			fee = feeObj.getLong("card_cash_int");
		}
		this.obj.put("fee", fee);

	}

	@Route(value = "/fit-card_retreat", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void card_retreat() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String fk_user_id = this.getParameter("fk_user_id");
		String gym = user.getViewGym();
		String cust_name = user.getCust_name();
		Entity en = new EntityImpl(this);
		MemInfo mem = MemUtils.getMemInfo(fk_user_id, cust_name, L, true, this.getConnection());

		String back = this.getParameter("back");
		if (mem != null) {
			long card_deposit_amt = mem.getCard_deposit_amt();
			if (card_deposit_amt == 0) {
				throw new Exception("该会员卡押金为0");
			}
			this.obj.put("card_money", Utils.toPrice(card_deposit_amt));
			if ("Y".equals(back)) {
				en = new EntityImpl("f_other_pay", this);
				en.setTablename("f_other_pay_" + gym);
				en.setValue("emp_id", user.getId());
				en.setValue("real_amt", -card_deposit_amt);
				en.setValue("ca_amt", -card_deposit_amt);
				en.setValue("cash_amt", -card_deposit_amt);
				en.setValue("card_cash_amt", 0);
				en.setValue("card_amt", 0);
				en.setValue("vouchers_amt", 0);
				en.setValue("vouchers_num", 0);
				en.setValue("wx_amt", 0);
				en.setValue("ali_amt", 0);
				en.setValue("pay_type", "退卡押金");
				en.setValue("mem_id", fk_user_id);
				en.setValue("pay_way", "cash_amt");
				en.setValue("is_free", "N");
				en.setValue("staff_account", "N");
				en.setValue("print", "N");
				en.setValue("send_msg", "N");
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				en.setValue("pay_time", sdf.format(new Date()));
				en.create();
				// 更新会员卡押金
				mem.setCard_deposit_amt(0);
				mem.setMem_no("=no=");
				mem.update(this.getConnection(), false);
			}
		} else {
			throw new Exception("没有查询到此会员,请稍后尝试");
		}
	}
}
