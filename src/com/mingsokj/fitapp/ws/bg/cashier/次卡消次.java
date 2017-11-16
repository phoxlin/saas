package com.mingsokj.fitapp.ws.bg.cashier;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import org.json.JSONObject;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.SystemUtils;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.m.FitUser;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.utils.GymUtils;
import com.mingsokj.fitapp.utils.MemUtils;

public class 次卡消次 extends BasicAction {
	/**
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-cashier-reduceTimes", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void reduceTimes() throws Exception {
		String times = this.getParameter("times");
		String coach = this.getParameter("coach");
		String type = this.getParameter("type");// 消次、消课
		String remark = this.getParameter("remark");
		String fk_user_card_id = this.getParameter("fk_user_card_id");
		String fk_user_gym = this.getParameter("fk_user_gym");
		String fk_user_id = this.getParameter("fk_user_id");
		FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
		String cust_name = user.getCust_name();

		Map<String, Object> map = MemUtils.getMemCardsById(fk_user_card_id, fk_user_id, cust_name, user.getViewGym());

		Entity en = new EntityImpl(this);
		if (map != null) {
			String card_id = Utils.getMapStringValue(map, "card_id");
			String card_name = Utils.getMapStringValue(map, "card_name");
			int remain_times = Utils.getMapIntegerValue(map, "remain_times");
			int totaltimes = Utils.getMapIntegerValue(map, "times");
			String f_user_card_gym = Utils.getMapStringValue(map, "now_gym");
			remain_times = remain_times - Integer.parseInt(times);
			if (remain_times < 0) {
				throw new Exception("消次次数大于剩余次数，请检查后重试");
			} else {
				if (remain_times == 0) {
					en.executeUpdate(
							"update f_user_card_" + f_user_card_gym + " set remain_times=0,state='009' where id=?",
							new Object[] { fk_user_card_id });
				} else {
					en.executeUpdate("update f_user_card_" + f_user_card_gym + " set remain_times=? where id=?",
							new Object[] { remain_times, fk_user_card_id });
				}

				if ("消课".equals(type)) {
					// 消课记录
					for (int i = 0; i < Integer.parseInt(times); i++) {
						en = new EntityImpl("f_private_record", this);
						en.setTablename("f_private_record_" + fk_user_gym);
						en.setValue("gym", fk_user_gym);
						en.setValue("mem_id", fk_user_id);
						en.setValue("pt_id", coach);
						en.setValue("op_id", user.getId());
						en.setValue("op_time", new Date());
						en.setValue("card_id", card_id);
						en.setValue("user_card_id", fk_user_card_id);
						en.setValue("state", "end");
						en.setValue("start_time", new Date());
						en.setValue("end_time", new Date());
						en.setValue("comment", remark);
						en.create();
					}
				} else {
					for (int i = 0; i < Integer.parseInt(times); i++) {
						en = new EntityImpl("f_checkin", this);
						en.setTablename("f_checkin_" + fk_user_gym);
						en.setValue("cust_name", fk_user_gym);
						en.setValue("gym", fk_user_gym);
						en.setValue("mem_id", fk_user_id);
						en.setValue("mem_gym", fk_user_gym);
						en.setValue("hand_no", "");
						en.setValue("is_backHand", "Y");
						en.setValue("checkin_time", new Date());
						en.setValue("checkout_time", new Date());
						en.setValue("state", "004");
						en.setValue("emp_id", user.getId());
						en.setValue("checkin_type", "003");
						en.setValue("checkin_fee", 0);
						en.setValue("checkin_user_card_id", fk_user_card_id);
						en.setValue("checkin_card_name", card_name);
						en.create();

					}
				}
				MemInfo mem = MemUtils.getMemInfo(fk_user_id, cust_name);
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				JSONObject obj = new JSONObject();
				obj.put("op_time", sdf.format(new Date()));
				obj.put("op_name", user.getMemInfo().getName());
				obj.put("type_name", card_name);
				obj.put("totaltimes", totaltimes);
				obj.put("reduceTimes", times);
				obj.put("times", remain_times);
				obj.put("card_number", mem.getMem_no());
				obj.put("user_name", mem.getName());
				obj.put("phone", mem.getPhone());
				obj.put("gymName", GymUtils.getGymName(fk_user_gym));
				this.obj.put("obj", obj);

			}
		} else {
			throw new Exception("未查询到相关卡片，请刷新页面后重试");
		}
	}

}
