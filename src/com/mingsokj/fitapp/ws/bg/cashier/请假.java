package com.mingsokj.fitapp.ws.bg.cashier;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
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
import com.mingsokj.fitapp.m.FitUser;
import com.mingsokj.fitapp.m.MemInfo;

public class 请假 extends BasicAction {
	/**
	 * 请假记录
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-query-mem-leaveinfo", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void leaveinfo() throws Exception {
		String fk_user_id = request.getParameter("fk_user_id");
		String cur = request.getParameter("cur");
		if (cur == null || cur.length() <= 0) {
			cur = "1";
		}

		int pageSize = 7;
		int curPage = Integer.parseInt(cur);
		int start = (curPage - 1) * pageSize + 1;
		int end = pageSize * curPage;

		Entity entity = new EntityImpl(this);
		String sql = "select * from f_leave where mem_id=? order by start_time desc";
		entity.executeQueryWithMaxResult(sql, new String[] { fk_user_id }, start, end);
		List<Map<String, Object>> list = entity.getValues();

		Code code = Codes.code("LEAVE_STATE");
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> m = list.get(i);
			String start_time = "-";
			try {
				start_time = m.get("start_time").toString();
				start_time = Utils.parseData(Utils.parse2Date(start_time, "yyyy-MM-dd "), "yyyy-MM-dd ");
			} catch (Exception e) {
			}
			m.put("start_time", start_time);
			String end_time = "-";
			try {
				end_time = m.get("end_time").toString();
				end_time = Utils.parseData(Utils.parse2Date(end_time, "yyyy-MM-dd "), "yyyy-MM-dd ");
			} catch (Exception e) {
			}
			m.put("end_time", end_time);
			String cancel_time = "-";
			try {
				cancel_time = m.get("cancel_time").toString();
				cancel_time = Utils.parseData(Utils.parse2Date(cancel_time, "yyyy-MM-dd "), "yyyy-MM-dd ");
			} catch (Exception e) {
			}
			m.put("cancel_time", cancel_time);
			int countDays = 0;
			if (!"-".equals(cancel_time)) {
				countDays = daysBetween(start_time, cancel_time);
			}
			m.put("countDays", countDays);
			String state = m.get("state").toString();
			m.put("state", code.getNote(state));

		}

		int total = entity.getMaxResultCount();
		int totalpage = 0;
		int temp = total / pageSize;
		totalpage = total % pageSize > 0 ? temp + 1 : temp > 0 ? temp : 1;

		this.obj.put("leaveList", list);
		this.obj.put("total", total);
		this.obj.put("totalPage", totalpage);
		this.obj.put("curPage", curPage);
		this.obj.put("curSize", list.size());
		this.obj.put("user_id", fk_user_id);
	}

	/**
	 * 销假
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-cashier-salesLeave", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void salesLeave() throws Exception {
		String fk_user_id = this.getParameter("fk_user_id");
		String fk_user_gym = this.getParameter("fk_user_gym");
		FitUser user = (FitUser) this.getSessionUser();

		Entity en = new EntityImpl(this);
		int ss = en.executeQuery("select state from  f_mem_" + user.getCust_name() + " where id=?",
				new String[] { fk_user_id });
		if (ss == 0) {
			throw new Exception("错误操作,请重试");
		}
		String state = en.getStringValue("state");
		if (!"005".equals(state)) {
			throw new Exception("用户没有请假,暂不能销假");
		}
		// 更新会员状态
		en = new EntityImpl(this);
		MemInfo.updateStateByGym("001", fk_user_gym, this.getConnection(), fk_user_id);
		// 获取请假信息
		en.executeQuery("select  id,start_time,MAX(start_time) st from f_leave where mem_id=? and  state='001'",
				new Object[] { fk_user_id });
		Date st = en.getDateValue("start_time");
		String fk_leave_id = en.getStringValue("id");
		// 计算请假开始日期到销假之间的天数
		int countDays = daysBetween(st, new Date());
		// 更新请假表
		en.executeUpdate("update f_leave set cancel_time=?,state='002' where id=?",
				new Object[] { new Date(), fk_leave_id });

		String sql = "";
		ArrayList<String> parList = new ArrayList<String>();
		int size = en.executeQuery("select gym from f_gym where cust_name=?", new Object[] { user.getCust_name() });
		for (int i = 0; i < size; i++) {
			sql += "select id,gym,deadline from f_user_card_" + en.getStringValue("gym", i)
					+ " where state='004' and mem_id=?";
			if (size - 1 != i) {
				sql += " union ";
			}
			parList.add(fk_user_id);
		}
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		size = en.executeQuery(sql, parList.toArray());
		if (size > 0) {
			for (int i = 0; i < size; i++) {
				Date deadline = en.getDateValue("deadline", i);
				Calendar cal = Calendar.getInstance();
				cal.setTime(deadline);
				cal.add(Calendar.DAY_OF_YEAR, countDays < 0 ? 0 : countDays);
				deadline = cal.getTime();

				Entity e = new EntityImpl(this);
				e.executeUpdate(
						"update f_user_card_" + en.getStringValue("gym", i) + " set state='001',deadline=? where id=?",
						new Object[] { sdf.format(deadline), en.getStringValue("id", i) });
			}
		}

	}

	public static int daysBetween(Date smdate, Date bdate) throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		smdate = sdf.parse(sdf.format(smdate));
		bdate = sdf.parse(sdf.format(bdate));
		Calendar cal = Calendar.getInstance();
		cal.setTime(smdate);
		long time1 = cal.getTimeInMillis();
		cal.setTime(bdate);
		long time2 = cal.getTimeInMillis();
		long between_days = (time2 - time1) / (1000 * 3600 * 24);

		return Integer.parseInt(String.valueOf(between_days));
	}

	public static int daysBetween(String smdate, String bdate) throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance();
		cal.setTime(sdf.parse(smdate));
		long time1 = cal.getTimeInMillis();
		cal.setTime(sdf.parse(bdate));
		long time2 = cal.getTimeInMillis();
		long between_days = (time2 - time1) / (1000 * 3600 * 24);

		return Integer.parseInt(String.valueOf(between_days));
	}

}
