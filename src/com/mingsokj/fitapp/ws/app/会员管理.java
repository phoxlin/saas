package com.mingsokj.fitapp.ws.app;

import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.flow.Flow;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.SystemUtils;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.m.FitUser;
import com.mingsokj.fitapp.m.Mem;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.m.card.UserUtils;
import com.mingsokj.fitapp.utils.MemUtils;

public class 会员管理 extends BasicAction {
	@Route(value = "/fit-ws-bg-mem-searchMemByGym", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void searchMemByGym() throws Exception {
		FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
		String cust_name = user.getCust_name();

		String cur = request.getParameter("cur");
		String isEmp = request.getParameter("isEmp");
		if (cur == null || cur.length() <= 0) {
			cur = "1";
		}
		// String gym = this.getParameter("gym");
		String par = this.getParameter("par");
		Entity en = new EntityImpl(this);
		JSONObject obj = null;
		if (!"".equals(par)) {
			obj = new JSONObject(par);
		}
		String sql = "select id,mem_name name,phone,mem_no,gym from f_mem_" + cust_name + "";

		if (isEmp != null & !"".equals(isEmp)) {
			sql += "  where is_emp = '" + isEmp + "'";
		}

		en = new EntityImpl(this);
		int i = 1;
		for (String str : obj.keySet()) {
			String value = obj.getString(str);
			if (!"".equals(value)) {
				if (i == 1) {
					sql += ((isEmp != null && !"".equals(isEmp)) ? " and " : " where ") + str + " like '%" + value
							+ "%'";
				} else {
					sql += " or " + str + " like '" + value + "%'";
				}
				i++;
			}
		}

		int pageSize = 10;
		int curPage = Integer.parseInt(cur);
		int start = (curPage - 1) * pageSize + 1;
		int end = pageSize * curPage;

		en.executeQueryWithMaxResult(sql, start, end);
		List<Map<String, Object>> list = en.getValues();
		int total = en.getMaxResultCount();
		int totalpage = 0;
		int temp = total / pageSize;
		totalpage = total % pageSize > 0 ? temp + 1 : temp > 0 ? temp : 1;
		for (int j = 0; j < list.size(); j++) {
			String id = en.getStringValue("id", j);
			MemInfo memInfo = MemUtils.getMemInfo(id, cust_name, L);
			if (memInfo != null) {
				list.get(j).put("name", memInfo.getName());
			}
		}
		this.obj.put("mem", list);
		this.obj.put("total", total);
		this.obj.put("totalPage", totalpage);
		this.obj.put("curPage", curPage);
		this.obj.put("curSize", list.size());
	}

	/**
	 * 购买会员卡
	 */
	@Route(value = "/fit-ws-bg-Mem-getMineCard", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void getMineCard() throws Exception {
		String fk_user_id = this.getParameter("fk_user_id");
		String fk_card_type = this.getParameter("fk_card_type");
		Entity en = new EntityImpl(this);
		String sql = "select a.id,a.buy_time,a.deadline,a.state,b.card_name from  f_user_card a,f_card b  where a.card_id = b.id and a.mem_id=? and b.card_type=?";
		en.executeQuery(sql, new Object[] { fk_user_id, fk_card_type });
		this.obj.put("data", en.getValues());
	}

	/**
	 * 购买会员卡
	 */
	@Route(value = "/fit-ws-bg-Mem-buyCard", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void buyCard() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String fk_user_id = this.getParameter("fk_user_id");
		String card_id = this.getParameter("card_id");
		String activate_type = this.getParameter("activate_type");
		String active_time = this.getParameter("active_time");
		String sales = this.getParameter("sales");
		String remark = this.getParameter("remark");
		String real_amt = this.getParameter("real_amt");
		String contract_no = this.getParameter("contract_no");
		String source = this.getParameter("source");

		Entity cardEn = new EntityImpl(this);
		cardEn.executeQuery("select days,times,card_type from f_card where id=?", new Object[] { card_id });
		int days = cardEn.getIntegerValue("days");
		int times = cardEn.getIntegerValue("times");
		String card_type = cardEn.getStringValue("card_type");

		Entity en = new EntityImpl("f_user_card", this);
		en.setTablename("f_user_card_" + gym);
		en.setValue("cust_name", user.getCust_name());
		en.setValue("gym", user.getViewGym());
		en.setValue("card_id", card_id);
		en.setValue("mem_id", fk_user_id);
		en.setValue("emp_id", sales);
		en.setValue("buy_time", new Date());
		en.setValue("active_type", activate_type);
		String state = "001";
		if ("001".equals(activate_type)) {
			en.setValue("active_time", new Date());

			Calendar c = Calendar.getInstance();
			c.setTime(new Date());
			c.add(Calendar.DAY_OF_YEAR, days);
			en.setValue("deadline", c.getTime());
		} else if ("003".equals(activate_type)) {
			en.setValue("active_time", active_time);
			state = "002";
		}

		else {
			state = "002";
		}
		en.setValue("contract_no", contract_no);
		en.setValue("real_amt", real_amt);
		en.setValue("remark", remark);
		en.setValue("source", source);
		en.setValue("state", state);
		if ("003".equals(card_type) || "006".equals(card_type)) {
			en.setValue("remain_times", times);
			en.setValue("buy_times", times);
		}
		en.create();
	}

	/**
	 * 散客购票
	 * 
	 * @Title: buyOneCard
	 * @author: liul
	 * @date: 2017年7月24日下午2:24:06
	 * @throws Exception
	 */
	@Route(value = "/fit-ws-bg-Mem-buyOneCard", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void buyOneCard() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String cust_name = user.getCust_name();
		String gym = user.getViewGym();
		String card_id = this.getParameter("card_id");
		String real_amt = this.getParameter("real_amt");
		Entity entity = new EntityImpl("f_fit", this);
		int num = Integer.parseInt(this.getParameter("num")) + 1;// 有效期天数
		Date deadline = new Date(System.currentTimeMillis() + 24 * 60 * 60 * 1000 * num);
		Flow flow = new Flow();
		String checkin_no = flow.getFlownum();
		entity.setValue("cust_name", cust_name);
		entity.setValue("gym", gym);
		entity.setValue("card_id", card_id);
		entity.setValue("deadline", deadline);
		entity.setValue("emp_id", user.getId());
		entity.setValue("real_amt", real_amt);
		entity.setValue("buy_time", new Date());
		entity.setValue("checkin_no", checkin_no);
		entity.setValue("state", "Y");// 状态Y已支付
		entity.create();
	}

	/**
	 * 会员添加
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-ws-bg-addMem", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void addMem() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String cust_name = user.getCust_name();
		Entity mem = this.getEntityFromPage("f_mem");
		String mem_no = mem.getStringValue("f_mem__mem_no");

		Entity en = new EntityImpl("f_mem", this);
		mem.setTablename("f_mem_" + cust_name);
		String sql = "select id from f_mem_" + cust_name + " where mem_no = ?";
		int size = en.executeQuery(sql, new Object[] { mem_no });
		if (size > 0) {
			throw new Exception("重复的会员卡号");
		}
		mem.setValue("gym", gym);
		mem.setValue("cust_name", cust_name);
		mem.create();
	}

	/**
	 * 修改添加
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-ws-bg-updateMem", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void updateMem() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String cust_name = user.getCust_name();

		Entity mem = this.getEntityFromPage("f_mem");
		String mem_no = mem.getStringValue("f_mem__mem_no");
		String id = mem.getStringValue("f_mem__id");

		Entity en = new EntityImpl("f_mem", this);
		mem.setTablename("f_mem_" + cust_name);
		String sql = "select id from f_mem where  id!=? and mem_no = ?";
		int size = en.executeQuery(sql, new Object[] { id, mem_no });
		if (size > 0) {
			throw new Exception("重复的会员卡号");
		}
		mem.update();
	}

	@Route(value = "/fit-ws-bg-detial", conn = true, m = HttpMethod.GET, type = ContentType.Forward)
	public void detial() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String cust_name = user.getCust_name();

		String id = this.getParameter("id");
		Entity en = new EntityImpl("f_mem", this);
		String sql = "select * from f_mem_" + cust_name + " where id=?";
		int size = en.executeQuery(sql, new Object[] { id });
		if (size > 0) {
			request.setAttribute("f_mem", en);
			this.obj.put("nextpage", "pages/f_mem/f_mem_edit.jsp");
		}
	}

	@Route(value = "/fit-ws-bg-mem-query", conn = true, m = HttpMethod.GET, type = ContentType.JSON)
	public void query() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String cust_name = user.getCust_name();
		String gym = user.getViewGym();

		String phone = request.getParameter("phone");
		Mem mem = null;
		if (phone.matches("^((13[0-9])|(15[0-9])|(17[0-9])|(18[0-9]))\\d{8}$")) {
			mem = UserUtils.getMemInfoByPhone(phone, this, user);
		} else {
			mem = UserUtils.getMemInfoByCardNo(phone, this, user);
		}
		String emp_id = mem.getId();

		Entity en = new EntityImpl("f_emp", this);
		int s = en.executeQuery("select * from f_emp  where id = ?", new Object[] { emp_id });
		if (s > 0) {
			this.obj.put("isEmp", "Y");
			this.obj.put("emp", en.getValues().get(0));
			s = en.executeQuery("select * from f_mem_" + cust_name + " where id = ?", new Object[] { emp_id });
			if (s > 0) {
				MemInfo info = MemUtils.getMemInfo(mem.getId(), cust_name, L);
				this.obj.put("mem_name", info.getName());
				JSONObject m = new JSONObject(mem);
				this.obj.put("mem", m);
			}

		} else {

			// 查询会员在当前会所拥有的会员卡
			List<Map<String, Object>> allCards = MemUtils.getMemCards(mem.getId(), cust_name, gym);

			/*
			 * Entity cards = new EntityImpl(this); s = cards.executeQuery(
			 * "select a.*,b.card_name,b.count from f_user_card_" + gym +
			 * " a,f_card b where a.card_id = b.id and mem_id = ? ", new
			 * Object[] { mem.getId() });
			 */
			String card_name = "";
			Float count = 100f;
			Date now = new Date();
			if (allCards != null && allCards.size() > 0) {
				for (int i = 0; i < allCards.size(); i++) {
					Date deadline = Utils.getMapDateValue(allCards.get(i), "deadline");
					if (deadline != null && deadline.after(now)) {
						String f = Utils.getMapStringValue(allCards.get(i), "count");
						if (f != null && !"".equals(f)) {
							Float count_ = Float.parseFloat(f);
							if (count_ < count) {
								count = count_;
								card_name = Utils.getMapStringValue(allCards.get(i), "card_name");
								this.obj.put("card_name", card_name);
							}
						}
					}
				}
			}
			MemInfo info = MemUtils.getMemInfo(mem.getId(), cust_name, L);
			this.obj.put("mem_name", info.getName());
			JSONObject m = new JSONObject(mem);
			this.obj.put("mem", m);
			this.obj.put("count", count);
		}
	}

	/**
	 * 更改会籍
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-ws-bg-Mem-changeSales", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void changeSales() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String fk_user_ids = this.getParameter("fk_user_id");
		String fk_sales_id = this.getParameter("fk_sales_id");
		String ids[] = fk_user_ids.split(",");
		for (String fk_user_id : ids) {
			MemInfo info = new MemInfo();
			info.setMc_id(fk_sales_id);
			info.setId(fk_user_id);
			info.setGym(gym);
			info.update(this.getConnection(), false);
		}
	}

	/**
	 * 更改会籍
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-ws-bg-Mem-changeCoach", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void changeCoach() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String cust_name = user.getCust_name();
		String fk_user_ids = this.getParameter("fk_user_id");
		String fk_coach_id = this.getParameter("fk_coach_id");
		String ids[] = fk_user_ids.split(",");
		Entity en = new EntityImpl(this);
		for (String fk_user_id : ids) {
			en.executeUpdate("update f_mem_" + cust_name + " set pt_names=? where id=?",
					new Object[] { fk_coach_id, fk_user_id });
		}
	}
}
