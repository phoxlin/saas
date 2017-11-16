package com.mingsokj.fitapp.ws.app.sales;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;

public class 查询会员会员卡 extends BasicAction {
	@Route(value = "/fit-app-action-getMemCards", conn = true,  m = HttpMethod.POST, type = ContentType.JSON)
	public void getMemCards() throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String id = request.getParameter("id");
		String gym = request.getParameter("gym");
		String cust_name = request.getParameter("cust_name");
		Entity en = new EntityImpl(this);
		/**
		 * 查询用户的会员卡
		 */
		int size = en.executeQuery("select state from f_mem_" + cust_name + " where id=?", new Object[] { id });
		if (size > 0) {
			String state = en.getStringValue("state");
			if ("001".equals(state)) {
				en = new EntityImpl(this);
				String sql = " select a.*,b.card_name,b.card_type,b.id card_id from f_user_card_" + gym
						+ " a,f_card b where a.card_id = b.id and a.mem_id=? and a.gym=? and a.state in('001','002','003','004')";
				size = en.executeQuery(sql, new Object[] { id, gym });
				if (size > 0) {
					List<Map<String, Object>> cardList = en.getValues();

					for (int i = 0; i < cardList.size(); i++) {
						Date active_time = (Date) cardList.get(i).get("active_time");
						Date deadline = (Date) cardList.get(i).get("deadline");
						if (active_time != null) {
							cardList.get(i).put("active_time", sdf.format(active_time));
						} else {
							cardList.get(i).put("active_time", "");
						}
						if (deadline != null) {
							cardList.get(i).put("deadline", sdf.format(deadline));
						} else {
							cardList.get(i).put("deadline", "");
						}
					}

					this.obj.put("userCard", en.getValues());
				}
			}
		}

	}

}
