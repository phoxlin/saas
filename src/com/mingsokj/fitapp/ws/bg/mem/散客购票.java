package com.mingsokj.fitapp.ws.bg.mem;

import java.util.List;
import java.util.Map;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.mingsokj.fitapp.m.FitUser;

/**
 * @author liul 2017年7月12日上午10:24:39
 */
public class 散客购票 extends BasicAction {
	/**
	 * 单次购票
	 * 
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-ws-bg-Mem-showOneCard", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void buyOneCard() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		if (user != null) {
			String gym = user.getViewGym();
			String sql = "select * from f_card where gym=? and card_type='005'";
			Entity en = new EntityImpl(this);
			en.executeQuery(sql, new String[] { gym });
			List<Map<String, Object>> typeList = en.getValues();
			this.obj.put("list", typeList);
		}
	}
}
