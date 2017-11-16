package com.mingsokj.fitapp.ws.bg.cashier;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.SystemUtils;
import com.mingsokj.fitapp.m.FitUser;

public class 我的消息 extends BasicAction {
	@Route(value = "/yp-ws-bg-getMyMsg", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void queryReduceClassConfirm() throws Exception {
		FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
		String cust_name = user.getCust_name();
		String gym = user.getViewGym();

		// 查询是否有自己的消息
		Entity en = new EntityImpl(this);
		StringBuilder sb = new StringBuilder("select * from f_msg_rec where receiver_id = ? ");
		List<String> params = new ArrayList<>();
		params.add(user.getId());
		if (user.is系统管理员()) {
			sb.append(" or receiver_id ='OP' and cust_name = ? and gym =?");
			params.add(cust_name);
			params.add(gym);
		}
		sb.append(" order by state desc,send_time desc");

		String cur = request.getParameter("cur");

		int pageSize = 10;
		int curPage = Integer.parseInt(cur);
		int start = (curPage - 1) * pageSize + 1;
		int end = pageSize * curPage;

		en.executeQueryWithMaxResult(sb.toString(), params.toArray(), start, end);

		List<Map<String, Object>> list = en.getValues();
		int total = en.getMaxResultCount();
		int totalpage = 0;
		int temp = total / pageSize;
		totalpage = total % pageSize > 0 ? temp + 1 : temp > 0 ? temp : 1;

		this.obj.put("list", en.getValues());

		this.obj.put("total", total);
		this.obj.put("totalPage", totalpage);
		this.obj.put("curPage", curPage);
		this.obj.put("curSize", list.size());
	}
}
