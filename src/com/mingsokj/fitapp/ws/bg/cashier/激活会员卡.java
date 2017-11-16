package com.mingsokj.fitapp.ws.bg.cashier;

import java.util.Calendar;
import java.util.Date;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.mingsokj.fitapp.m.FitUser;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.utils.MemUtils;

public class 激活会员卡 extends BasicAction {
	@Route(value = "/fit-cashier-activeCard", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void getCardCashInt() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String cust_name = user.getCust_name();
		String fk_user_id = this.getParameter("fk_user_id");
		String fk_user_gym = this.getParameter("fk_user_gym");
		String fk_card_id = this.getParameter("fk_card_id");

		Entity en = new EntityImpl(this);
		int size = en.executeQuery("select a.*,b.card_type,b.days,b.amt,b.times from f_user_card_" + fk_user_gym
				+ " a,f_card b  where b.id = a.card_id and  a.id=?", new Object[] { fk_card_id });
		if (size > 0) {
			String card_type = en.getStringValue("card_type");
			int days = 0;
			try {
				days = en.getIntegerValue("days");
			} catch (Exception e) {
			}
			long amt = en.getLongValue("amt");
			int times = en.getIntegerValue("times");
			int give_days = en.getIntegerValue("give_days");
			try {
				days = days + give_days;
			} catch (Exception e) {
			}
			if (days == 0) {
				days = 100 * 365;
			}

			Calendar c = Calendar.getInstance();
			c.setTime(new Date());
			c.add(Calendar.DAY_OF_YEAR, days);
			Date deadline = c.getTime();

			if ("002".equals(card_type)) {
				Entity userEn = new EntityImpl(this);
				userEn.executeQuery("select remain_amt  from f_mem_" + cust_name + " where id=?",
						new Object[] { fk_user_id });
				String tmp = userEn.getStringValue("remain_amt");
				long remain_amt = tmp != null && tmp.length() > 0 ? Long.parseLong(tmp) : 0;
				remain_amt = remain_amt + amt * 100;
				try {
					remain_amt = remain_amt + give_days * 100;
				} catch (Exception e) {
				}
				MemInfo.updateRemainAmtByCustname(remain_amt, fk_user_id, cust_name, this.getConnection());
			}
			en = new EntityImpl(this);
			en.executeUpdate(
					"update f_user_card_" + fk_user_gym + " set deadline=?,remain_times=?,state='001' where id=?",
					new Object[] { deadline, times, fk_card_id });

			/**
			 * 如果会员没有激活，则激活会员
			 */
			MemInfo mem = MemUtils.getMemInfo(fk_user_id, cust_name);
			String state = mem.getState();
			if (state != "001") {
				MemInfo.updateStateByCustname("001", cust_name, this.getConnection(), fk_user_id);
			}
		} else {
			throw new Exception("未查询到相关信息，请刷新页面后重试");
		}

	}
}
