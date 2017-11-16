package com.mingsokj.fitapp.ws.bg.cashier;

import java.util.List;
import java.util.Map;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.mingsokj.fitapp.m.FitUser;

public class 获取预付费信息 extends BasicAction {
	@Route(value = "/fit-ws-bg-getPreFeeById", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void getPreFeeById() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String fk_user_id = this.getParameter("fk_user_id");
		Entity en = new EntityImpl(this);
		int size = en.executeQuery(
				"select pay_amt,user_amt,id from f_pre_fee_" + gym + " where mem_id=? and state='001' ",
				new Object[] { fk_user_id });
		List<Map<String, Object>> preList = en.getValues();
		for (int i = 0; i < size; i++) {
			Map<String, Object> pre = preList.get(i);
			pre.put("name", "预付" + pre.get("pay_amt") + "抵扣" + pre.get("user_amt"));
		}
		this.obj.put("data", preList);
	}
}
