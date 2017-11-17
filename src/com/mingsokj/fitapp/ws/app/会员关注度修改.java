package com.mingsokj.fitapp.ws.app;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.mingsokj.fitapp.m.MemInfo;

public class 会员关注度修改 extends BasicAction {

	@Route(value = "/fit-app-action-changeFoucs", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void getEmpList() throws Exception {
		String gym = this.getParameter("gym");
		String fk_user_id = this.getParameter("fk_user_id");
		String imp_level = this.getParameter("imp_level");
		
		MemInfo info = new MemInfo();
		info.setGym(gym);
		info.setImp_level(imp_level);
		info.setId(fk_user_id);
		info.update(this.getConnection(), false);
	}
}
