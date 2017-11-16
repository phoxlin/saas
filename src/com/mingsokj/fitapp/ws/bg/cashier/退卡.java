package com.mingsokj.fitapp.ws.bg.cashier;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

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

public class 退卡 extends BasicAction {
	@Route(value = "/fit-cashier-backCard", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void doTransferCard() throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		String fk_user_gym = this.getParameter("fk_user_gym");
		String cust_name = this.getParameter("cust_name");
		String fk_user_card_id = this.getParameter("fk_card_id");
		String fk_user_id = this.getParameter("fk_user_id");
		String back = this.getParameter("back");
		String backMoney = this.getParameter("backMoney");
		FitUser user = (FitUser) this.getSessionUser();

		Map<String, Object> card = MemUtils.getMemCardsById(fk_user_card_id, fk_user_id, user.getCust_name(),
				user.getViewGym());
		if (card != null) {
			Date deadLine = sdf.parse(card.get("deadline") + "");
			float real_amt = Float.parseFloat(card.get("real_amt") + "");
			String rt = card.get("remain_times") + "";
			if ("null".equals(rt) || "".equals(rt)) {
				rt = "0";
			}
			int remain_times = Integer.parseInt(rt);
			String card_type = card.get("card_type") + "";
			String t = card.get("times") + "";
			if ("null".equals(t) || "".equals(t)) {
				t = "0";
			}
			int times = Integer.parseInt(t);
			int days = 0;
			try {
				days = Integer.parseInt(card.get("days") + "");
			} catch (Exception e) {
			} finally {
				days = 365 * 100;
			}

			float backmoney = 0;
			if ("001".equals(card_type)) {// 天数卡
				int contDays = daysBetween(new Date(), deadLine);
				if (days <= 0) {
					backmoney = 0;
				} else {
					backmoney = ((real_amt / 100) / days) * contDays;
				}
			} else if ("003".equals(card_type) || "006".equals(card_type)) {
				if (times <= 0) {
					backmoney = 0;
				} else {
					backmoney = ((real_amt / 100) / times) * remain_times;
				}
			} else if ("002".equals(card_type)) {
				Entity en = new EntityImpl(this);
				int size = en.executeQuery("select remain_amt from f_mem_" + user.getCust_name() + " where id=?",
						new Object[] { fk_user_id });
				if (size > 0) {
					backmoney = en.getFloatValue("remain_amt") / 100;
				}
				if ("Y".equals(back)) {
					MemInfo.updateRemainAmtByGym(0, fk_user_id, fk_user_gym, this.getConnection());
				}
			}

			BigDecimal b = new BigDecimal(backmoney);
			float bMoney = b.setScale(1, BigDecimal.ROUND_HALF_UP).floatValue();

			if ("Y".equals(back)) {
				String card_gym = Utils.getMapStringValue(card, "now_gym");

				Entity e = new EntityImpl(this);
				e.executeUpdate("update f_user_card_" + card_gym + " set state='008' where id=?",
						new Object[] { fk_user_card_id });
				MemInfo mem = MemUtils.getMemInfo(fk_user_id, cust_name);
				if (mem != null) {
					List<Map<String, Object>> cards = mem.getCardList(user.getViewGym());
					long ra = mem.getRemainAmt();
					if (cards.size() == 0 && ra == 0) {
						MemInfo.updateStateByGym("008", cust_name, this.getConnection(), fk_user_id);
					}
				}

				if (!Utils.isNull(backMoney)) {
					bMoney = Float.parseFloat(backMoney);
				}

				Entity en = new EntityImpl(this);
				en = new EntityImpl("f_other_pay", this);
				en.setTablename("f_other_pay_" + fk_user_gym);
				en.setValue("emp_id", user.getId());
				en.setValue("real_amt", -(long) (bMoney * 100));
				en.setValue("ca_amt", -(long) (bMoney * 100));
				en.setValue("cash_amt", -(long) (bMoney * 100));
				en.setValue("card_cash_amt", 0);
				en.setValue("card_amt", 0);
				en.setValue("vouchers_amt", 0);
				en.setValue("vouchers_num", 0);
				en.setValue("wx_amt", 0);
				en.setValue("ali_amt", 0);
				en.setValue("pay_type", "退卡");
				en.setValue("mem_id", fk_user_id);
				en.setValue("pay_way", "cash_amt");
				en.setValue("is_free", "N");
				en.setValue("staff_account", "N");
				en.setValue("print", "N");
				en.setValue("send_msg", "N");
				en.setValue("pay_time", sdf2.format(new Date()));
				en.create();

			}

			this.obj.put("backmoney", bMoney + "");

		} else {
			throw new Exception("未查询到相关卡片，请刷新页面后重试");
		}
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
}
