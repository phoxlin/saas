package com.mingsokj.fitapp.ws.bg.cashier;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.mingsokj.fitapp.m.FitUser;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.m.card.UserUtils;
import com.mingsokj.fitapp.utils.MemUtils;
import com.mingsokj.fitapp.ws.bg.set.SysSet;

public class 签到查询 extends BasicAction {

	/**
	 * 会员签到查询
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-query-mems", conn = true, slave = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void queryMems() throws Exception {
		FitUser emp = (FitUser) this.getSessionUser();// 当前收银员
		String key = request.getParameter("key");
		List<Map<String, Object>> mems = UserUtils.getMemInfos(key, this, emp);
		this.obj.put("data", mems);
		String autoCheckIn = SysSet.getValues(emp.getCust_name(), emp.getGym(), "set_xiao_print", "autoCheckIn",
				this.getConnection());
		this.obj.put("autoCheckIn",autoCheckIn);
	}

	/**
	 * 会员详细查询
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-query-mem", conn = true, slave = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void queryMem() throws Exception {
		FitUser emp = (FitUser) this.getSessionUser();// 当前收银员
		String id = request.getParameter("id");
		MemInfo mem = MemUtils.getMemInfo(id, emp.getCust_name(), L);
		Map<Object, Object> map = new HashMap<Object, Object>();
		map.put("xx", mem);
		this.obj.put("map", map);
		this.obj.put("cards", mem.getCardList(emp.getViewGym()));
		this.obj.put("checkinfo", mem.getCheckinfo(emp.getViewGym()));
		this.obj.put("boxinfo", mem.getRentBoxinfo(emp.getViewGym()));

	}

}
