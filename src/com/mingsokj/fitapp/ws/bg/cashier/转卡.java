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
import com.mingsokj.fitapp.m.FitUser;

public class 转卡 extends BasicAction {
	/**
	 * 转卡
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-transferCard-doTransferCard", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void doTransferCard() throws Exception {
		String fk_user_gym = this.getParameter("fk_user_gym");// 转卡人健身房
		String fk_user_card_id = this.getParameter("fk_user_card_id");// 转卡人卡片id
//		String fk_user_id = this.getParameter("fk_user_id");// 转卡人ID
		String gym = this.getParameter("gym");// 被转卡人健身房
		String mem_id = this.getParameter("mem_id");// 被转卡人ID
		String remark = this.getParameter("remark");// 转卡 备注
//		String fee = this.getParameter("fee");// 转卡费用
		FitUser user = (FitUser) this.getSessionUser();
		/**
		 * 查询被转卡人是否存在
		 */
		Entity en = new EntityImpl(this);
		int size = en.executeQuery("select id from f_mem_" + user.getCust_name() + " where id=?",
				new Object[] { mem_id });
		if (size <= 0) {
			throw new Exception("未查询到相关用户，请重新选择");
		}
		en = new EntityImpl(this);
		size = en.executeQuery("select * from f_user_card_" + fk_user_gym + " where id=?",
				new Object[] { fk_user_card_id });
		if (size > 0) {
			String from_id = en.getStringValue("id");
			String from_cust_name = en.getStringValue("cust_name");
			String from_card_id = en.getStringValue("card_id");
			String from_buy_time = en.getStringValue("buy_time");
			String from_active_type = en.getStringValue("active_type");
			String from_active_time = en.getStringValue("active_time");
			String from_deadline = en.getStringValue("deadline");
			String from_real_amt = en.getStringValue("real_amt");
			String from_state = en.getStringValue("state");
			String from_remain_times = en.getStringValue("remain_times");

			en = new EntityImpl("f_user_card", this);
			en.setTablename("f_user_card_" + gym);
			en.setValue("cust_name", from_cust_name);
			en.setValue("gym", gym);
			en.setValue("card_id", from_card_id);
			en.setValue("mem_id", mem_id);
			en.setValue("buy_time", from_buy_time);
			en.setValue("active_type", from_active_type);
			en.setValue("active_time", from_active_time);
			en.setValue("deadline", from_deadline);
			en.setValue("real_amt", from_real_amt);
			en.setValue("state", from_state);
			en.setValue("remain_times", from_remain_times);
			en.setValue("emp_id", "-1");
			en.setValue("remark", remark);
			en.create();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			en.executeUpdate("update f_user_card_" + fk_user_gym + "  set state='007',deadline='"
					+ sdf.format(new Date()) + "' where id=?", new Object[] { from_id });
		} else {
			throw new Exception("未查询到相关卡片，请刷新页面后重试");
		}

	}

	@Route(value = "/fit-transferCard-queryGymByCard", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void queryGymByCard() throws Exception {
		String fk_user_gym = this.getParameter("fk_user_gym");
		String fk_user_card_id = this.getParameter("fk_user_card_id");
//		String fk_user_id = this.getParameter("fk_user_id");
		Entity en = new EntityImpl(this);
		String sql = " select c.gym,c.gym_name  from  f_card_gym a,f_user_card_" + fk_user_gym
				+ " b,f_gym c where a.view_gym = c.gym and a.fk_card_id = b.card_id and  b.id=?";
		en.executeQuery(sql, new Object[] { fk_user_card_id });

		this.obj.put("gym", en.getValues());
	}

	@Route(value = "/fit-transferCard-fee", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void queryTransferCardFee() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		Entity en = new EntityImpl(this);
		int size = en.executeQuery("select note from f_param  where  code='card_cash_setting' and gym=?",
				new Object[] { gym });
		long fee = 0;
		if (size > 0) {
			String note = en.getStringValue("note");
			if (note != null) {
				JSONArray arr = new JSONArray(note);
				JSONObject feeObj = (JSONObject) arr.get(0);
				fee = feeObj.getLong("turn_card_int");
			}
		}
		this.obj.put("fee", fee);
	}
}
