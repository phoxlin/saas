package com.mingsokj.fitapp.ws.bg.cashier;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.m.FitUser;

public class 升级 extends BasicAction {
	@Route(value = "/fit-ws-bg-Mem-updateCard", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void updateCard() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String fk_user_card_id = this.getParameter("fk_user_card_id");
		String updateCard = this.getParameter("updateCard");

		Entity updateEn = new EntityImpl(this);
		int size = updateEn.executeQuery("select * from f_card where id=?", new Object[] { updateCard });
		if (size <= 0) {
			throw new Exception("未查询到相关卡片的信息，请刷新页面后重试");
		}
		long update_fee = updateEn.getLongValue("fee");

		Entity en = new EntityImpl(this);
		size = en.executeQuery(
				"select a.*,b.times,b.fee from f_user_card_" + gym + " a,f_card b  where  a.card_id = b.id and a.id=?",
				new Object[] { fk_user_card_id });
		if (size <= 0) {
			throw new Exception("未查询到相关信息，请刷新页面后重试");
		}

		float fee =Float.parseFloat(Utils.toPrice((en.getLongValue("real_amt2"))));
		if (fee == 0) {
			fee =Float.parseFloat(Utils.toPrice((en.getLongValue("real_amt"))));
		}
		float countFee = update_fee - fee;
		if (countFee < 0) {
			countFee = 0;
		}
		this.obj.put("fee", countFee);

	}

}
