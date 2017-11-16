package com.mingsokj.fitapp.m.card;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONObject;

import com.jinhua.User;
import com.jinhua.server.Action;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;

/**
 * 单次入场卷
 * 
 * 
 * @author terry
 *
 */
public class OnceCard extends ICard {

	public OnceCard() {
		/*
		 */
	}

	public OnceCard(Action act, String cust_name, String gym, String cardno) throws Exception {
		this.setCust_name(cust_name);
		this.setGym(gym);
		this.setCardno(cardno);
		Entity en = new EntityImpl(act);
		int size = en.executeQuery("select * from  yp_fit_" + cust_name + " where card_no=? and gym=?", new String[] { cardno, gym });
		if (size > 0) {
			this.setSales_id(en.getStringValue("emp_id"));
			this.setCheckinState(ICard.getCheckinState(en.getStringValue("state")));
			this.setDeadline(en.getDateValue("deadline"));
			this.setType_code(en.getStringValue("type_code"));
			this.setMemId(en.getStringValue("mem_id"));
			this.setBuyDate(en.getDateValue("buy_time"));
		} else {
			throw new Exception("系统查询不到对应的单次入场卷【" + cardno + "】");
		}
	}

	@Override
	public void checkOut(Action act, JSONObject obj) throws Exception {
		Entity en = new EntityImpl(act);
		String sql = "update yp_fit_" + this.getCust_name() + " set state='004' where gym=? and card_no=?";
		en.executeUpdate(sql, new String[] { this.getGym(), this.getCardno() });
		sql = "update yp_checkin_" + getGym() + " set state='004', checkout_time=? where mem_no=? and cust_name=? and gym=? ";
		en.executeUpdate(sql, new Object[] { new Date(), this.getCardno(), this.getCust_name(), this.getGym() });
		try {
			sql = "update yp_box set is_rent='N',state='001' where mem_id=? and cust_name=? and gym=? ";
			en.executeUpdate(sql, new String[] { this.getCardno(), this.getCust_name(), this.getGym() });
		} catch (Exception e) {
		}
		obj.put("flag", "CHECKOUT");
	}

	@Override
	public void autoCheckin(Action act, User emp, HttpServletRequest request, JSONObject obj) throws Exception {

	}

}
