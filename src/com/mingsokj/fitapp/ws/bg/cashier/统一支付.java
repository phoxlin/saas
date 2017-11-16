package com.mingsokj.fitapp.ws.bg.cashier;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.mingsokj.fitapp.flow.Flow;

public class 统一支付 extends BasicAction {
	/**
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-pay", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void reduceTimes() throws Exception {
		String f = request.getParameter("f");
		String t = request.getParameter("t");
		Flow flow = (Flow) Class.forName(f).newInstance();
		flow.setT(t);
		flow.setAct(this);
		flow.beforeData();
		flow.saveData();
		flow.afterData();
	}
}
