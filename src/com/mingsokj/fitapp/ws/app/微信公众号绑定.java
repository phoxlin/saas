package com.mingsokj.fitapp.ws.app;

import java.util.Date;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.m.MemInfo;

public class 微信公众号绑定 extends BasicAction {

	@Route(value = "/f-ws-app-bindWx", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void bindWx() throws Exception {
		String cust_name = request.getParameter("cust_name");
		String gym = request.getParameter("gym");
		String phone = request.getParameter("phone");
		String wxOpenId = request.getParameter("wxOpenId");
		boolean confirm = Utils.isTrue(request.getParameter("confirm"));

		Entity en = new EntityImpl(this);
		int size = en.executeQuery("select nickname,sex from f_wx_cust_" + cust_name + " a where a.WX_OPEN_ID=?", new String[] { wxOpenId }, 1, 1);
		if (size > 0) {
			String nickname = en.getStringValue("nickname");
			String sex = en.getStringValue("sex");
			int s = en.executeQuery("select a.id,a.WX_OPEN_ID from f_mem_" + cust_name + " a where a.phone=?", new String[] { phone }, 1, 1);
			if (s > 0) {
				String id = en.getStringValue("id");
				String WX_OPEN_ID = en.getStringValue("WX_OPEN_ID");

				if (Utils.isNull(WX_OPEN_ID)) {
					if (!confirm) {
						this.obj.put("flag", "old-phone");
						return;
					}
				} else {
					if (!wxOpenId.equals(WX_OPEN_ID)) {
						if (!confirm) {
							this.obj.put("flag", "bind-new-phone");
							return;
						}
					} else {
						return;
					}
				}
				MemInfo info = new MemInfo();
				info.setWxOpenId(wxOpenId);
				info.setId(id);
				info.setGym(gym);
				info.update(this.getConnection(), false);

				try {
					en.executeUpdate("update f_emp a set a.WX_OPEN_ID=? where a.id=?", new String[] { wxOpenId, id });
				} catch (Exception e) {
				}

			} else {
				if (Utils.isNull(nickname)) {
					nickname = "N/A";
				}
				Entity f_mem = new EntityImpl("f_mem", this);
				f_mem.setTablename("f_mem_" + cust_name);
				f_mem.setValue("cust_name", cust_name);
				f_mem.setValue("gym", gym);
				f_mem.setValue("phone", phone);
				f_mem.setValue("mem_name", "");
				f_mem.setValue("sex", sex);
				f_mem.setValue("create_time", new Date());
				f_mem.setValue("wx_open_id", wxOpenId);
				f_mem.setValue("is_emp", "Y");
				f_mem.setValue("state", "004");
				f_mem.create();
			}
		} else {
			throw new Exception("请在微信里面登录系统");
		}
	}

}
