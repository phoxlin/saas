package com.mingsokj.fitapp.ws.app;

import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.m.FitUser;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.utils.MemUtils;

public class 销售排行 extends BasicAction {

	/**
	 * 会籍 私教销售排行
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-app-action-salesRankReport", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void salesRankReport() throws Exception {
		String gym = request.getParameter("gym");
		String cust_name = request.getParameter("cust_name");
		String month = request.getParameter("month");
		String week = request.getParameter("week");
		String role = request.getParameter("role");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

		// 员工在本会所的销售
		StringBuilder sql = new StringBuilder();
		List<String> params = new ArrayList<>();
		sql.append("select sum(cast(a.real_amt as UNSIGNED INTEGER)) total_amt,a." + role + "_id,c.mem_name name from f_user_card_" + gym + " a,f_emp b,f_mem_"+cust_name+" c where a." + role + "_id = b.id and a." + role + "_id = c.id");
		if ("所有月份".equals(month)) {

		} else {
			String begin = "";
			String end = "";
			if (week != null && !"".equals(week)) {
				String s = week.split("~")[0];
				String e = week.split("~")[1];
				begin = month.substring(0, 5) + s + " 00:00:00";
				end = month.substring(0, 5) + e + " 23:59:59";
				if (sdf.parse(begin).after(sdf.parse(end))) {
					// 说明是在年初的时候查看 几率小
					int y = Integer.parseInt(begin.substring(0, 4));
					if (begin.startsWith("12")) {
						// 说明是年末
						begin = y + 1 + "-" + s + " 00:00:00";
					} else {
						// 年初
						end = y + 1 + "-" + e + " 23:59:59";
					}
				}
			} else {
				begin = month + "-01 00:00:00";
				Calendar cDay = Calendar.getInstance();
				cDay.setTime(sdf.parse(begin));
				cDay.set(Calendar.DAY_OF_MONTH, cDay.getActualMaximum(Calendar.DAY_OF_MONTH));
				end = sdf.format(cDay.getTime()) + " 23:59:59";
			}
			params.add(begin);
			params.add(end);
			sql.append(" and a.pay_time between ? and ?");
		}
		sql.append(" group by a." + role + "_id").append(" order by total_amt desc");

		Entity en = new EntityImpl(this);
		int s = en.executeQuery(sql.toString(), params.toArray());
		if (s > 0) {
			 List<Map<String, Object>> list = en.getValues();
			for(int i=0;i<s;i++){
				String emp_id = en.getStringValue(role+"_id",i);
				MemInfo emp = MemUtils.getMemInfo(emp_id, cust_name);
				if(emp!=null){
					list.get(i).put("name", emp.getName());
					list.get(i).put("pic_url", emp.getPicUrl());
				}
			}
			this.obj.put("list",list);
		}
	}

	@Route(value = "/fit-app-action-reduceClassRankReport", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void reduceClassRank() throws Exception {
		String gym = request.getParameter("gym");
		String cust_name = request.getParameter("cust_name");
		String month = request.getParameter("month");
		String week = request.getParameter("week");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

		StringBuilder sql = new StringBuilder();
		List<String> params = new ArrayList<>();
		sql.append("select count(a.id) num,a.pt_id,c.mem_name name,d.headurl pic_url from f_private_record_" + gym + " a,f_emp b,f_mem_"+cust_name+" c,f_wx_cust_"+cust_name+" d where a.pt_id = b.id and a.state ='end' and a.pt_id = c.id and c.wx_open_id = d.wx_open_id");
		if ("所有月份".equals(month)) {

		} else {
			String begin = "";
			String end = "";
			if (week != null && !"".equals(week)) {
				String s = week.split("~")[0];
				String e = week.split("~")[1];
				begin = month.substring(0, 5) + s + " 00:00:00";
				end = month.substring(0, 5) + e + " 23:59:59";
				if (sdf.parse(begin).after(sdf.parse(end))) {
					// 说明是在年初的时候查看 几率小
					int y = Integer.parseInt(begin.substring(0, 4));
					if (begin.startsWith("12")) {
						// 说明是年末
						begin = y + 1 + "-" + s + " 00:00:00";
					} else {
						// 年初
						end = y + 1 + "-" + e + " 23:59:59";
					}
				}
			} else {
				begin = month + "-01 00:00:00";
				Calendar cDay = Calendar.getInstance();
				cDay.setTime(sdf.parse(begin));
				cDay.set(Calendar.DAY_OF_MONTH, cDay.getActualMaximum(Calendar.DAY_OF_MONTH));
				end = sdf.format(cDay.getTime()) + " 23:59:59";
			}
			params.add(begin);
			params.add(end);
			sql.append(" and a.end_time between ? and ?");
		}
		sql.append(" group by a.pt_id").append(" order by num desc");

		Entity en = new EntityImpl(this);
		int s = en.executeQuery(sql.toString(), params.toArray());
		if (s > 0) {
			 List<Map<String, Object>> list = en.getValues();
				for(int i=0;i<s;i++){
					String emp_id = en.getStringValue("pt_id",i);
					MemInfo emp = MemUtils.getMemInfo(emp_id, cust_name);
					if(emp!=null){
						list.get(i).put("name", emp.getName());
					}
				}
				this.obj.put("list",list);
		}

	}

	@Route(value = "/fit-app-action-salesFromRankReport", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void salesFromRank() throws Exception {

		String gym = request.getParameter("gym");

		Entity en = new EntityImpl(this);
		/**
		 * <option value="1">WI-到访</option> <option value="2">APPT-电话邀约</option>
		 * <option value="3">BR-转介绍</option> <option value="4">TI-电话咨询</option>
		 * <option value="5">DI-拉访</option> <option value="6">POS</option>
		 * <option value="7">场开</option> <option value="8">体测</option>
		 * <option value="9">续费</option>
		 */

		String ss[] = { "其他", "WI-到访", "APPT-电话邀约", "BR-转介绍", "TI-电话咨询", "DI-拉访", "POS", "场开", "体测", "续费", "excel导入" };
		int s = en.executeQuery("select count(id) num,source,sum(cast(real_amt as UNSIGNED INTEGER)) total_amt from f_user_card_" + gym + " group by source order by num desc");
		if (s > 0) {
			for (int i = 0; i < s; i++) {
				String source = en.getStringValue("source", i);
				int index = 0;
				if("excelExport".equals(source)){
					index = 10;
				} else {
					index = en.getIntegerValue("source", i);
				}
				en.getValues().get(i).put("name", ss[index]);
			}
			this.obj.put("list", en.getValues());
		}
	}

	// 后台销售统计
	@Route(value = "/fit-bg-action-salesRankReport", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void bgSalesRankReport() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String cust_name = user.getCust_name();
		String month = request.getParameter("month");
		String week = request.getParameter("week");

		if ("所有月份".equals(month)) {
			month = null;
		}

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

		// 会籍销售排名
		StringBuilder sql = new StringBuilder();
		List<String> params = new ArrayList<>();
		sql.append("select sum(cast(a.real_amt as UNSIGNED INTEGER)) total_amt,b.id from f_user_card_" + gym + " a,f_emp b where a.mc_id = b.id ");
		String begin = "";
		String end = "";
		if (month != null && !"".equals(month)) {
			if (week != null && !"".equals(week)) {
				String s = week.split("~")[0];
				String e = week.split("~")[1];
				begin = month.substring(0, 5) + s + " 00:00:00";
				end = month.substring(0, 5) + e + " 23:59:59";
				if (sdf.parse(begin).after(sdf.parse(end))) {
					// 说明是在年初的时候查看 几率小
					int y = Integer.parseInt(begin.substring(0, 4));
					if (begin.startsWith("12")) {
						// 说明是年末
						begin = y + 1 + "-" + s + " 00:00:00";
					} else {
						// 年初
						end = y + 1 + "-" + e + " 23:59:59";
					}
				}
			} else {
				begin = month + "-01 00:00:00";
				Calendar cDay = Calendar.getInstance();
				cDay.setTime(sdf.parse(begin));
				cDay.set(Calendar.DAY_OF_MONTH, cDay.getActualMaximum(Calendar.DAY_OF_MONTH));
				end = sdf.format(cDay.getTime()) + " 23:59:59";
			}
			params.add(begin);
			params.add(end);
			sql.append(" and a.pay_time between ? and ?");
		}
		sql.append(" group by a.mc_id").append(" order by total_amt desc limit 0,8");
		Entity en = new EntityImpl(this);
		int s = en.executeQuery(sql.toString(), params.toArray());
		if (s > 0) {
			for (int i = 0, l = en.getValues().size(); i < l; i++) {
				Map<String, Object> m = en.getValues().get(i);
				String id = Utils.getMapStringValue(m, "id");
				MemInfo info = MemUtils.getMemInfo(id, cust_name, L);
				if(info != null){
					m.put("name", info.getName());
				} else {
					m.put("name", "--");
				}
			}
			this.obj.put("mcSalesRank", en.getValues());
		}
		// 教练销售排名
		sql = new StringBuilder();
		params = new ArrayList<>();
		sql.append("select sum(cast(a.real_amt as UNSIGNED INTEGER)) total_amt,b.id from f_user_card_" + gym + " a,f_emp b where a.pt_id = b.id ");
		if (month != null && !"".equals(month)) {
			params.add(begin);
			params.add(end);
			sql.append(" and a.pay_time between ? and ?");
		}
		sql.append(" group by a.pt_id").append(" order by total_amt desc  limit 0,8");
		en.executeQuery(sql.toString(), params.toArray());
		if (s > 0) {
			for (int i = 0, l = en.getValues().size(); i < l; i++) {
				Map<String, Object> m = en.getValues().get(i);
				String id = Utils.getMapStringValue(m, "id");
				MemInfo info = MemUtils.getMemInfo(id, cust_name, L);
				m.put("name", info.getName());
			}

			this.obj.put("ptSsalesRank", en.getValues());
		}

		// 私教上课排名
		sql = new StringBuilder();
		params = new ArrayList<>();
		sql.append("select count(a.id) num,a.pt_id from f_private_record_" + gym + " a,f_emp b where a.pt_id = b.id and a.state ='end'");
		if (month != null && !"".equals(month)) {
			params.add(begin);
			params.add(end);
			sql.append(" and a.end_time between ? and ?");
		}
		sql.append(" group by a.pt_id").append(" order by num desc  limit 0,8");

		en = new EntityImpl(this);
		s = en.executeQuery(sql.toString(), params.toArray());
		if (s > 0) {
			for (int i = 0, l = en.getValues().size(); i < l; i++) {
				Map<String, Object> m = en.getValues().get(i);
				String id = Utils.getMapStringValue(m, "pt_id");
				MemInfo info = MemUtils.getMemInfo(id, cust_name, L);
				m.put("name", info.getName());
			}
			this.obj.put("reduceClassRank", en.getValues());
		}
		// 会员签到排名
		sql = new StringBuilder();
		params = new ArrayList<>();
		sql.append("select count(a.id) num,b.mem_name,b.id from f_checkin_" + gym + " a,f_mem_" + cust_name + " b where a.mem_id = b.id");
		if (month != null && !"".equals(month)) {
			params.add(begin);
			params.add(end);
			sql.append(" and a.checkin_time between ? and ?");
		}
		sql.append(" group by a.mem_id order by num desc  limit 0,8");

		en = new EntityImpl(this);
		s = en.executeQuery(sql.toString(), params.toArray());
		if (s > 0) {
			for (int i = 0, l = en.getValues().size(); i < l; i++) {
				Map<String, Object> m = en.getValues().get(i);
				String id = Utils.getMapStringValue(m, "id");
				MemInfo info = MemUtils.getMemInfo(id, cust_name, L);
				m.put("mem_name", info.getName());
			}

			this.obj.put("checkinRank", en.getValues());
		}

		// 算出最早的一个月
		s = en.executeQuery("select min(pay_time) time from f_user_card_" + gym + "");
		if (s > 0) {
			Date dateValue = en.getDateValue("time");
			if(dateValue !=null){
				this.obj.put("longlongago", dateValue.getTime());
			}
		}

		en = new EntityImpl(this);
		/**
		 * <option value="1">WI-到访</option> <option value="2">APPT-电话邀约</option>
		 * <option value="3">BR-转介绍</option> <option value="4">TI-电话咨询</option>
		 * <option value="5">DI-拉访</option> <option value="6">POS</option>
		 * <option value="7">场开</option> <option value="8">体测</option>
		 * <option value="9">续费</option>
		 */
		// 销售来源
		/*
		 * String ss[] = { "其他", "WI-到访", "APPT-电话邀约", "BR-转介绍", "TI-电话咨询",
		 * "DI-拉访", "POS", "场开", "体测", "续费" };
		 * 
		 * params = new ArrayList<>(); sql = new StringBuilder(); sql.append(
		 * "select count(id) num,source,sum(cast(real_amt as UNSIGNED INTEGER)) total_amt from f_user_card_"
		 * + gym); if (month != null && !"".equals(month)) { params.add(begin);
		 * params.add(end); sql.append(" where pay_time between ? and ?"); }
		 * sql.append(" group by source order by num desc");
		 * 
		 * s = en.executeQuery(sql.toString(),params.toArray()); if (s > 0) {
		 * for (int i = 0; i < s; i++) { int index =
		 * en.getIntegerValue("source", i); en.getValues().get(i).put("name",
		 * ss[index]); } this.obj.put("fromList", en.getValues()); }
		 */
	}
}
