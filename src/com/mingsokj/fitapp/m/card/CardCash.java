package com.mingsokj.fitapp.m.card;

import org.json.JSONArray;
import org.json.JSONObject;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.mingsokj.fitapp.m.FitUser;
import com.mingsokj.fitapp.ws.bg.set.SysSet;

public class CardCash extends BasicAction {
	// 押金设置
	// 办卡，补卡，转卡，跨店转卡
	@Route(value = "/f_card_cash", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void f_card_cash() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String card_cash = request.getParameter("card_cash");
		String mend_card = request.getParameter("mend_card");
		String turn_card = request.getParameter("turn_card");
		String shift_card = request.getParameter("shift_card");
		// 获取gym
		String gym = user.getViewGym();
		String cust_name = user.getCust_name();
		
		if(card_cash.equals(null)||card_cash.equals("")){
			card_cash = "0";
		} if(mend_card.equals(null)||mend_card.equals("")){
			mend_card = "0";
		} if(turn_card.equals(null)||turn_card.equals("")){
			turn_card = "0";
		} if(shift_card.equals(null)||shift_card.equals("")){
			shift_card = "0";
		} 
		int card_cash_int = 0;
		int mend_card_int = 0;
		int turn_card_int = 0;
		int shift_card_int = 0;
		try {
			card_cash_int = Integer.parseInt(card_cash);
			mend_card_int = Integer.parseInt(mend_card);
			turn_card_int = Integer.parseInt(turn_card);
			shift_card_int = Integer.parseInt(shift_card);
		} catch (Exception er) {
			throw new Exception("请输入正确费用");
		}
		Entity entity = new EntityImpl("f_param", this);
		Entity en = new EntityImpl("f_param", this);
		JSONObject obj = new JSONObject();
		JSONArray array = new JSONArray();
		String sql = "select * from f_param where gym=? and code=?";
		int size = en.executeQuery(sql, new String[] { gym, "card_cash_setting" });
		if (size > 0) {
			array = new JSONArray("[]");
			obj.put("gym", gym);
			obj.put("card_cash_int", card_cash_int);
			obj.put("mend_card_int", mend_card_int);
			obj.put("turn_card_int", turn_card_int);
			obj.put("shift_card_int", shift_card_int);
			array.put(obj);

			entity.setValue("id", en.getStringValue("id"));
			entity.setValue("note", array.toString());
			entity.update();
		} else {
			array = new JSONArray("[]");
			obj.put("gym", gym);
			obj.put("card_cash_int", card_cash_int);
			obj.put("mend_card_int", mend_card_int);
			obj.put("turn_card_int", turn_card_int);
			obj.put("shift_card_int", shift_card_int);
			array.put(obj);
			en = new EntityImpl("f_param", this);
			en.setValue("cust_name", cust_name);
			en.setValue("gym", gym);
			en.setValue("code", "card_cash_setting");
			en.setValue("note", array.toString());
			en.create();
		}

	}

	// 显示已设置的押金
	@Route(value = "/f_card_cash_set", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void f_card_cash_set() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String cust_name = user.getCust_name();
		Entity entity = new EntityImpl("f_param", this);
		String sql = "select * from f_param where gym = ? and cust_name = ? and code = ?";
		int size = entity.executeQuery(sql, new String[] { gym, cust_name, "card_cash_setting" });
		if (size > 0) {
			String card_cash_int = SysSet.getValues(cust_name, gym, "card_cash_setting", "card_cash_int", this.getConnection());
			String mend_card_int = SysSet.getValues(cust_name, gym, "card_cash_setting", "mend_card_int", this.getConnection());
			String turn_card_int = SysSet.getValues(cust_name, gym, "card_cash_setting", "turn_card_int", this.getConnection());
			String shift_card_int = SysSet.getValues(cust_name, gym, "card_cash_setting", "shift_card_int", this.getConnection());

			obj.put("card_cash_int", card_cash_int);
			obj.put("mend_card_int", mend_card_int);
			obj.put("turn_card_int", turn_card_int);
			obj.put("shift_card_int", shift_card_int);
		}
	}
}
