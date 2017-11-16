package com.mingsokj.fitapp.ws.bg.cashier;

import java.text.SimpleDateFormat;
import java.util.Date;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.mingsokj.fitapp.m.FitUser;

public class 单次入场券入场 extends BasicAction {

	@Route(value = "/fit-cashier-enter-singleCard", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void reduceTimes() throws Exception {
		String key = this.getParameter("key");
		FitUser user = (FitUser) this.getSessionUser();
		if (key != null && !"".equals(key)) {
			String id = key.split(":")[1];
			Entity en = new EntityImpl(this);
			int size = en.executeQuery("select a.state,a.deadline,a.card_id,b.card_name,a.checkin_no from f_fit a,f_card b where a.card_id = b.id and  a.checkin_no=? and a.gym=?",
					new Object[] { id, user.getViewGym() });
			if (size > 0) {
				String state = en.getStringValue("state");
				if ("Y".equals(state)) {
					String deadline = en.getStringValue("deadline");
					String checkin_no = en.getStringValue("checkin_no");
					String card_name = en.getStringValue("card_name");
					String card_id = en.getStringValue("card_id");
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
					Date dl = sdf.parse(deadline);
					if (dl.after(new Date())) {
						en.executeUpdate(" update f_fit set state='N',checkin_time=? where checkin_no=?",
								new Object[] { new Date(), id });
						en = new EntityImpl("f_checkin", this);
						en.setTablename("f_checkin_" + user.getViewGym());
						en.setValue("cust_name", user.getCust_name());
						en.setValue("gym", user.getViewGym());
						en.setValue("mem_id", "-1");
						en.setValue("mem_gym", user.getViewGym());
						en.setValue("hand_no", "");
						en.setValue("is_backHand", "Y");
						en.setValue("checkin_time", new Date());
						en.setValue("state", "002");
						en.setValue("emp_id", user.getId());
						en.setValue("checkin_type", "006");
						en.setValue("checkin_fee", 0);
						en.setValue("checkin_user_card_id", card_id);
						en.setValue("checkin_card_name", card_name+"("+checkin_no+")");
						en.create();
					} else {
						throw new Exception("该单次入场券已经过期，请重新购买");
					}
				} else {
					throw new Exception("该单次入场券已经被使用，请重新购买");
				}
			} else {
				throw new Exception("未查询到该单次入场券信息");
			}
		} else {
			throw new Exception("错误的单次入场券");
		}

	}
}
