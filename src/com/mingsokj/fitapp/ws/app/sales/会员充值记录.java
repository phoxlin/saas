package com.mingsokj.fitapp.ws.app.sales;

import java.util.List;
import java.util.Map;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.Utils;

/**
 * 会员卡充值记录
 * 
 * @author 1
 *
 */
public class 会员充值记录 extends BasicAction {
	@Route(value = "/fit-app-action-rechargeRecord", conn = true,  m = HttpMethod.POST, type = ContentType.JSON)
	public void rechargeRecord() throws Exception {
		String fk_user_id = request.getParameter("id");
		String gym = request.getParameter("gym");

		Entity en = new EntityImpl(this);
		String sql = "select a.real_amt,a.pay_time,b.card_name,a.remark,a.deadline from f_user_card_" + gym
				+ " a,f_card b where b.id = a.card_id and  a.mem_id = ?";
		int size = en.executeQuery(sql, new String[] { fk_user_id });
		List<Map<String, Object>> list = en.getValues();
		for (int i = 0; i < size; i++) {
			Map<String, Object> map = list.get(i);
			map.put("real_amt", Utils.toPrice(en.getLongValue("real_amt", i)));
			map.put("pay_time", en.getFormatStringValue("pay_time", "yyyy-MM-dd", i));
			map.put("deadline", en.getFormatStringValue("deadline", "yyyy-MM-dd", i));
		}
		this.obj.put("consumelist", list);

	}

}
