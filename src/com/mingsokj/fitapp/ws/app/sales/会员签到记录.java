package com.mingsokj.fitapp.ws.app.sales;

import java.util.List;
import java.util.Map;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.c.Code;
import com.jinhua.server.c.Codes;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.Utils;

public class 会员签到记录 extends BasicAction {
	@Route(value = "/fit-app-action-checkInRecord", conn = true,  m = HttpMethod.POST, type = ContentType.JSON)
	public void checkInRecord() throws Exception {
		String fk_user_id = request.getParameter("id");
		String gym = request.getParameter("gym");
		Entity en = new EntityImpl(this);

		String sql = "select * from f_checkin_" + gym + " where mem_id=? order by checkin_time desc";
		int size = en.executeQuery(sql, new String[] { fk_user_id });
		List<Map<String, Object>> list = en.getValues();

		Code code = Codes.code("checkin_type");

		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> m = list.get(i);
			String checkin_time = "-";
			try {
				checkin_time = m.get("checkin_time").toString();
				checkin_time = Utils.parseData(Utils.parse2Date(checkin_time, "yyyy-MM-dd HH:mm"), "yyyy-MM-dd HH:mm");
			} catch (Exception e) {
			}
			m.put("checkin_time", checkin_time);
			String checkout_time = "-";
			try {
				checkout_time = m.get("checkout_time").toString();
				checkout_time = Utils.parseData(Utils.parse2Date(checkout_time, "yyyy-MM-dd HH:mm"),
						"yyyy-MM-dd HH:mm");
			} catch (Exception e) {
			}
			m.put("checkout_time", checkout_time);

			String checkin_type = m.get("checkin_type").toString();
			checkin_type = code.getNote(checkin_type);
			m.put("checkin_type", checkin_type);
		}
		this.obj.put("checkinList", list);
		this.obj.put("checkinsize", size);

	}

}
