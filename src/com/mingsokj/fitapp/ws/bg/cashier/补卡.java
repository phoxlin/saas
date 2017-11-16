package com.mingsokj.fitapp.ws.bg.cashier;

import org.json.JSONArray;
import org.json.JSONObject;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.mingsokj.fitapp.m.FitUser;

public class 补卡 extends BasicAction {
	/**
	 * 转卡
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-cashier-reportedgetFee", conn = true,  m = HttpMethod.POST, type = ContentType.JSON)
	public void reportedgetFee() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		Entity en = new EntityImpl(this);
		int size = en.executeQuery("select note from f_param  where  code='card_cash_setting' and gym=?", new Object[] { gym });
		String note = "";
		if(size > 0){
			note = en.getStringValue("note");
		}
		long fee = 0;
		if (note != null && note.length() > 0) {
			JSONArray arr = new JSONArray(note);
			JSONObject feeObj = (JSONObject) arr.get(0);
			fee = feeObj.getLong("mend_card_int");
		}
		this.obj.put("fee", fee);
	}
}
