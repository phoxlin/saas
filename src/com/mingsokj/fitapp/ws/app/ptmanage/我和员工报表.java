package com.mingsokj.fitapp.ws.app.ptmanage;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.Utils;

public class 我和员工报表 extends BasicAction {

	@Route(value = "/fit-app-action-exAndEmpsRecord", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void exAndEmpsRecord() throws Exception {
		String curGym = request.getParameter("curGym");
		String cust_name = request.getParameter("cust_name");
		String emp_id = request.getParameter("emp_id");
		String date = request.getParameter("date");
		String type = request.getParameter("type");

		String boss = request.getParameter("boss");
		Boolean isBoss = false;

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

		Date time = sdf.parse(date);
		String first_day = "";
		String last_day = "";

		String monday = "";
		String sunday = "";

		Calendar cDay = Calendar.getInstance();
		cDay.setTime(time);
		cDay.set(Calendar.DAY_OF_MONTH, cDay.getActualMinimum(Calendar.DAY_OF_MONTH));
		first_day = sdf.format(cDay.getTime()) + " 00:00:00";
		cDay.set(Calendar.DAY_OF_MONTH, cDay.getActualMaximum(Calendar.DAY_OF_MONTH));
		last_day = sdf.format(cDay.getTime()) + " 23:59:59";

		cDay.setTime(time);
		cDay.add(Calendar.DAY_OF_WEEK, -1);
		cDay.set(Calendar.DAY_OF_WEEK, cDay.getFirstDayOfWeek());
		cDay.add(Calendar.DAY_OF_WEEK, 1);
		monday = sdf.format(cDay.getTime()) + " 00:00:00";

		cDay.setTime(time);
		cDay.add(Calendar.DAY_OF_WEEK, -1);
		cDay.set(Calendar.DAY_OF_WEEK, cDay.getFirstDayOfWeek() + 6);
		cDay.add(Calendar.DAY_OF_WEEK, 1);
		sunday = sdf.format(cDay.getTime()) + " 23:59:59";

		Entity en = new EntityImpl(this);
		List<String> emps = new ArrayList<>();

		// 销售信息
		StringBuilder sql = new StringBuilder();
		sql.append("select sum(cast(a.real_amt as UNSIGNED INTEGER)) total_amt")
				.append(",sum(cast(a.buy_times as UNSIGNED INTEGER)) total_times").append(",count(a.id) sales_num")
				.append(",b.card_type");

		// 员工信息
		if (boss != null && "boss".equals(boss)) {
			// 老板
			isBoss = true;
			sql.append(" from f_user_card_" + curGym + " a,f_card b where a.card_id = b.id");
		} else {
			// 管理员
			int s = en.executeQuery("select emp_id from f_m_emp where p_emp_id = ? and type = ?",
					new Object[] { emp_id, type.toUpperCase() });
			if (s > 0) {
				// 下属类型
				if (type != null && !"".equals(type)) {
					// 教练或者会籍
					sql.append(" from f_user_card_" + curGym + " a,f_card b where a.card_id = b.id and a." + type
							+ "_id in (" + Utils.getListString("?", s + 1) + ")");
					emps.add(emp_id);
					for (int i = 0; i < s; i++) {
						emps.add(en.getStringValue("emp_id", i));
					}
				} else {
					// 全部
					sql.append(" from f_user_card_" + curGym + " a,f_card b where a.card_id = b.id and ( a.mc_id in ("
							+ Utils.getListString("?", s + 1) + ") or a.pt_id in (" + Utils.getListString("?", s + 1)
							+ "))");
					emps.add(emp_id);
					for (int i = 0; i < s; i++) {
						emps.add(en.getStringValue("emp_id", i));
					}
					emps.addAll(emps);
				}
			} else {
				// 只有自己一个人
				if (type != null && !"".equals(type)) {
					// 教练或者会籍
					sql.append(" from f_user_card_" + curGym + " a,f_card b where a.card_id = b.id and a." + type
							+ "_id =?");
					emps.add(emp_id);
				} else {
					sql.append(" from f_user_card_" + curGym
							+ " a,f_card b where a.card_id = b.id and a.mc_id = ? or a.pt_id = ?");
					emps.add(emp_id);
					emps.add(emp_id);
				}
			}
		}

		// 总共
		String allSql = sql.toString() + " and a.state !='010'  group by b.card_type";
		int s = en.executeQuery(allSql, emps.toArray());
		if (s > 0) {
			this.obj.put("allInfo", en.getValues());
		}
		// 当月
		String monthSql = sql.toString() + "  and a.state !='010'  and a.pay_time between ? and ? group by b.card_type";
		emps.add(first_day);
		emps.add(last_day);
		s = en.executeQuery(monthSql, emps.toArray());
		if (s > 0) {
			this.obj.put("monthInfo", en.getValues());
		}
		emps.remove(first_day);
		emps.remove(last_day);

		// 当周
		emps.add(monday);
		emps.add(sunday);
		String weekSql = sql.toString() + "  and a.state !='010'  and a.pay_time between ? and ? group by b.card_type";
		s = en.executeQuery(weekSql, emps.toArray());
		if (s > 0) {
			this.obj.put("weekInfo", en.getValues());
		}
		emps.remove(monday);
		emps.remove(sunday);

		// 当天
		emps.add(date);
		String dateSql = sql.toString()
				+ " and a.state !='010'  and TO_DAYS(a.pay_time) = TO_DAYS(?) group by b.card_type";
		s = en.executeQuery(dateSql, emps.toArray());
		if (s > 0) {
			this.obj.put("dayInfo", en.getValues());
		}
		emps.remove(date);
		String appendSql = "";
		if (!isBoss) {
			appendSql = " emp_id in (" + Utils.getListString("?", emps.size()) + ") ";
		}

		// 请假
		StringBuilder leaveSql = new StringBuilder();// card_type
														// 没有实际意思只是为了省一个js
		leaveSql.append("select count(id) num,sum(real_amt) total_amt,'all' card_type from f_leave where cust_name = '"
				+ cust_name + "' and gym = '" + curGym + "'" + (isBoss ? "" : " and " + appendSql))
				.append(" union all select count(id) num,sum(real_amt) total_amt,'month'  from f_leave where cust_name = '"
						+ cust_name + "' and gym = '" + curGym + "' and" + (isBoss ? " " : appendSql + " and ")
						+ " pay_time between ? and ?")
				.append(" union all select count(id) num,sum(real_amt) total_amt,'week'  from f_leave where cust_name = '"
						+ cust_name + "' and gym = '" + curGym + "' and" + (isBoss ? "  " : appendSql + " and ")
						+ " pay_time between ? and ?")
				.append(" union all select count(id) num,sum(real_amt) total_amt,'day'  from f_leave where cust_name = '"
						+ cust_name + "' and gym = '" + curGym + "' and" + (isBoss ? "  " : appendSql + " and ")
						+ " TO_DAYS(pay_time) = TO_DAYS(?)");
		List<String> p1 = new ArrayList<>();
		p1.addAll(emps);
		p1.addAll(emps);
		p1.add(first_day);
		p1.add(last_day);
		p1.addAll(emps);
		p1.add(monday);
		p1.add(sunday);
		p1.addAll(emps);
		p1.add(date);
		s = en.executeQuery(leaveSql.toString(), p1.toArray());
		if (s > 0) {
			this.obj.put("leaveInfo", en.getValues());
		}

		// 转卡和租柜充值
		StringBuilder other = new StringBuilder();
		other.append("select count(id) num,sum(real_amt) total_amt,pay_type type,'all' time from f_other_pay_" + curGym
				+ " where pay_type in ('租柜费用','转卡手续费','充值')  " + (isBoss ? "" : " and " + appendSql)
				+ " group by pay_type")
				.append(" union all select count(id) num,sum(real_amt) total_amt,pay_type,'month' from f_other_pay_"
						+ curGym + " where pay_type in ('租柜费用','转卡手续费','充值') and " + (isBoss ? "" : appendSql + "and")
						+ "  pay_time between ? and ? group by pay_type ")
				.append(" union all select count(id) num,sum(real_amt) total_amt,pay_type,'week' from f_other_pay_"
						+ curGym + " where pay_type in ('租柜费用','转卡手续费','充值')  and" + (isBoss ? "" : appendSql + "and")
						+ "  pay_time between ? and ? group by pay_type")
				.append(" union all select count(id) num,sum(real_amt) total_amt,pay_type,'day' from f_other_pay_"
						+ curGym + " where pay_type in ('租柜费用','转卡手续费','充值')  and" + (isBoss ? "" : appendSql + "and")
						+ "  TO_DAYS(pay_time) = TO_DAYS(?) group by pay_type");
		s = en.executeQuery(other.toString(), p1.toArray());
		if (s > 0) {
			this.obj.put("otherInfo", en.getValues());
		}

		// 散客
		other = new StringBuilder();
		other.append("select  count(id) num,sum(real_amt) total_amt,'all' card_type from f_fit where cust_name='"
				+ cust_name + "' and gym = '" + curGym + "' " + (isBoss ? "" : " and " + appendSql))
				.append(" union all select  count(id) num,sum(real_amt) total_amt,'month'  from  f_fit where cust_name='"
						+ cust_name + "' and gym = '" + curGym + "' and" + (isBoss ? "" : appendSql + " and ")
						+ "  pay_time between ? and ?")
				.append(" union all select  count(id) num,sum(real_amt) total_amt,'week'  from f_fit where cust_name='"
						+ cust_name + "' and gym = '" + curGym + "' and" + (isBoss ? "" : appendSql + " and ")
						+ "   pay_time between ? and ?")
				.append(" union all select  count(id) num,sum(real_amt) total_amt,'day'  from  f_fit where cust_name='"
						+ cust_name + "' and gym = '" + curGym + "' and" + (isBoss ? "" : appendSql + " and ")
						+ "  TO_DAYS(pay_time) = TO_DAYS(?)");
		s = en.executeQuery(other.toString(), p1.toArray());
		if (s > 0) {
			this.obj.put("fitInfo", en.getValues());
		}

		// 只有老板才用看商品
		if (isBoss) {
			if (!isBoss) {
				appendSql = " op_id in (" + Utils.getListString("?", emps.size()) + ") ";
			}
			StringBuilder goods = new StringBuilder();
			goods.append("select  count(id) num,sum(real_amt) total_amt,'all' card_type from f_store_rec_" + curGym
					+ " where type='004'" + (isBoss ? "" : " and " + appendSql))
					.append(" union all select  count(id) num,sum(real_amt) total_amt,'month'  from f_store_rec_"
							+ curGym + " where type='004' and " + (isBoss ? "" : appendSql + " and ")
							+ "  op_time between ? and ?")
					.append(" union all select  count(id) num,sum(real_amt) total_amt,'week'  from f_store_rec_"
							+ curGym + " where type='004' and " + (isBoss ? "" : appendSql + " and ")
							+ "   op_time between ? and ?")
					.append(" union all select  count(id) num,sum(real_amt) total_amt,'day'  from f_store_rec_" + curGym
							+ " where type='004' and " + (isBoss ? "" : appendSql + " and ")
							+ "  TO_DAYS(op_time) = TO_DAYS(?)");
			s = en.executeQuery(goods.toString(), p1.toArray());
			if (s > 0) {
				this.obj.put("goodsInfo", en.getValues());
			}
		}

		// 如果是会籍 不需要消课
		if (!"mc".equals(type)) {
			// 私教消课
			if (!isBoss) {
				appendSql = " pt_id in (" + Utils.getListString("?", emps.size()) + ") ";
			}
			StringBuilder sb = new StringBuilder();
			sb.append("select count(id) num,'all' type  from f_private_record_" + curGym).append(" where state ='end' ")
					.append((isBoss ? "" : " and " + appendSql))
					.append(" union all select count(id) num,'month' type  from f_private_record_" + curGym)
					.append(" where state ='end' and").append(isBoss ? "" : appendSql + " and ")
					.append(" end_time between ? and ?")
					.append(" union all select count(id) num,'week' type  from f_private_record_" + curGym)
					.append(" where state ='end' and").append(isBoss ? "" : appendSql + " and ")
					.append(" end_time between ? and ?")
					.append(" union all select count(id) num,'day' type  from f_private_record_" + curGym)
					.append(" where state ='end' and").append(isBoss ? "" : appendSql + " and ")
					.append(" TO_DAYS(end_time) = TO_DAYS(?)");
			s = en.executeQuery(sb.toString(), p1.toArray());
			if (s > 0) {
				this.obj.put("reduceClass", en.getValues());
			}

			// 团课消次
			sb = new StringBuilder();
			if (!isBoss) {
				appendSql = " a.pt_id in (" + Utils.getListString("?", emps.size()) + ") ";
			}
			sb.append("select sum(cast(a.MEM_NUMS as UNSIGNED INTEGER)) num,'all' type  from f_class_record_" + curGym)
					.append(" a ,f_plan b where a.plan_id = b.id and b.is_free = 'N'")
					.append((isBoss ? "" : " and " + appendSql))
					.append(" union all select sum(cast(a.MEM_NUMS as UNSIGNED INTEGER)) ,'month'   from f_class_record_"
							+ curGym)
					.append(" a ,f_plan b where a.plan_id = b.id and b.is_free = 'N' and")
					.append(isBoss ? "" : appendSql + " and ").append(" end_time between ? and ?")
					.append(" union all select sum(cast(a.MEM_NUMS as UNSIGNED INTEGER)) ,'week'   from f_class_record_"
							+ curGym)
					.append(" a ,f_plan b where a.plan_id = b.id and b.is_free = 'N' and")
					.append(isBoss ? "" : appendSql + " and ").append(" end_time between ? and ?")
					.append(" union all select sum(cast(a.MEM_NUMS as UNSIGNED INTEGER)) ,'day'   from f_class_record_"
							+ curGym)
					.append(" a ,f_plan b where a.plan_id = b.id and b.is_free = 'N' and")
					.append(isBoss ? "" : appendSql + " and ").append(" TO_DAYS(end_time) = TO_DAYS(?)");
			s = en.executeQuery(sb.toString(), p1.toArray());
			if (s > 0) {
				this.obj.put("reduceGClass", en.getValues());
			}

			// 次卡消次
			if (!isBoss) {
				appendSql = " emp_id in (" + Utils.getListString("?", emps.size()) + ") ";
			}
			sb = new StringBuilder();
			sb.append("select count(id) num,'all' type  from f_checkin_" + curGym).append(" where checkin_type ='003' ")
					.append((isBoss ? "" : " and" + appendSql))
					.append(" union all select count(id) num,'month' type  from f_checkin_" + curGym)
					.append(" where checkin_type ='003' and").append(isBoss ? "" : appendSql + " and ")
					.append(" checkin_time between ? and ?")
					.append(" union all select count(id) num,'week' type  from f_checkin_" + curGym)
					.append(" where checkin_type ='003' and").append(isBoss ? "" : appendSql + " and ")
					.append(" checkin_time between ? and ?")
					.append(" union all select count(id) num,'day' type  from f_checkin_" + curGym)
					.append(" where checkin_type ='003' and").append(isBoss ? "" : appendSql + " and ")
					.append(" TO_DAYS(checkin_time) = TO_DAYS(?)");

			s = en.executeQuery(sb.toString(), p1.toArray());
			if (s > 0) {
				this.obj.put("reduceTimesCard", en.getValues());
			}

			// 出入场
			sb = new StringBuilder();
			sb.append("select count(id) num,'all' type  from f_checkin_" + curGym)
					.append((isBoss ? "" : " where" + appendSql))
					.append(" union all select count(id) num,'month' type  from f_checkin_" + curGym).append(" where ")
					.append(isBoss ? "" : appendSql + " and ").append(" checkin_time between ? and ?")
					.append(" union all select count(id) num,'week' type  from f_checkin_" + curGym).append(" where ")
					.append(isBoss ? "" : appendSql + " and ").append(" checkin_time between ? and ?")
					.append(" union all select count(id) num,'day' type  from f_checkin_" + curGym).append(" where ")
					.append(isBoss ? "" : appendSql + " and ").append(" TO_DAYS(checkin_time) = TO_DAYS(?)");

			s = en.executeQuery(sb.toString(), p1.toArray());
			List<Map<String, Object>> fCheckinList = en.getValues();

			sb = new StringBuilder();
			sb.append("select count(id) num,'all' type  from f_fit")
					.append((isBoss ? "" : " where" + appendSql + " and gym='" + curGym + "'"))
					.append(" union all select count(id) num,'month' type  from f_fit").append(" where ")
					.append(isBoss ? "" : appendSql + " and ")
					.append(" checkin_time between ? and ?  and gym='" + curGym + "'")
					.append(" union all select count(id) num,'week' type  from f_fit").append(" where ")
					.append(isBoss ? "" : appendSql + " and ")
					.append(" checkin_time between ? and ? and gym='" + curGym + "'")
					.append(" union all select count(id) num,'day' type  from f_fit").append(" where ")
					.append(isBoss ? "" : appendSql + " and ")
					.append(" TO_DAYS(checkin_time) = TO_DAYS(?)   and gym='" + curGym + "'");

			s = en.executeQuery(sb.toString(), p1.toArray());
			List<Map<String, Object>> fFitCheckinList = en.getValues();
			long allNum = 0;
			long monthNum = 0;
			long weekNum = 0;
			long dayNum = 0;

			for (Map<String, Object> m1 : fCheckinList) {
				String checktype = m1.get("type") + "";
				if ("all".equals(checktype)) {
					allNum += (long) m1.get("num");
				} else if ("month".equals(checktype)) {
					monthNum += (long) m1.get("num");
				} else if ("week".equals(checktype)) {
					weekNum += (long) m1.get("num");
				} else if ("day".equals(checktype)) {
					dayNum += (long) m1.get("num");
				}
			}

			for (Map<String, Object> m1 : fFitCheckinList) {
				String checktype = m1.get("type") + "";
				if ("all".equals(checktype)) {
					allNum += (long) m1.get("num");
				} else if ("month".equals(checktype)) {
					monthNum += (long) m1.get("num");
				} else if ("week".equals(checktype)) {
					weekNum += (long) m1.get("num");
				} else if ("day".equals(checktype)) {
					dayNum += (long) m1.get("num");
				}
			}
			JSONArray checkInArr = new JSONArray();
			JSONObject checkInObj = new JSONObject();
			checkInObj.put("type", "all");
			checkInObj.put("num", allNum);
			checkInArr.put(checkInObj);

			checkInObj = new JSONObject();
			checkInObj.put("type", "month");
			checkInObj.put("num", monthNum);
			checkInArr.put(checkInObj);

			checkInObj = new JSONObject();
			checkInObj.put("type", "week");
			checkInObj.put("num", weekNum);
			checkInArr.put(checkInObj);

			checkInObj = new JSONObject();
			checkInObj.put("type", "day");
			checkInObj.put("num", dayNum);
			checkInArr.put(checkInObj);

			if (checkInArr.length() > 0) {
				this.obj.put("checkinInfo", checkInArr);
			}

		}

		// 添加会员 添加潜客
		if (!isBoss) {
			appendSql = " mc_id in (" + Utils.getListString("?", emps.size()) + ") ";
		}
		StringBuilder memSql = new StringBuilder();
		memSql.append("select count(id) num,state,'all' type from f_mem_" + cust_name
				+ " where gym ='"+curGym+"' and state in('001','003','004')  " + (isBoss ? "" : "and" + appendSql) + " group by state")
				.append(" union all select count(id),state,'month'   from f_mem_" + cust_name
						+ " where gym ='"+curGym+"' and state in('001','003','004') " + (isBoss ? "" : "and" + appendSql)
						+ " and create_time between ? and ?  group by state ")
				.append(" union all select count(id),state,'week'   from f_mem_" + cust_name
						+ " where gym ='"+curGym+"' and state in('001','003','004') " + (isBoss ? "" : "and" + appendSql)
						+ " and create_time between ? and ?  group by state ")
				.append(" union all select count(id),state,'day'   from f_mem_" + cust_name
						+ " where gym ='"+curGym+"' and state in('001','003','004')  " + (isBoss ? "" : "and" + appendSql)
						+ " and TO_DAYS(?) = TO_DAYS(create_time)  group by state");
		s = en.executeQuery(memSql.toString(), p1.toArray());
		if (s > 0) {
			this.obj.put("memInfo", en.getValues());
		}
		// 维护会员 维护潜客
		en = new EntityImpl(this);
		if (!isBoss) {
			appendSql = " op_id in (" + Utils.getListString("?", emps.size()) + ") ";
		}
		StringBuilder maintainSql = new StringBuilder();
		 maintainSql
				.append("select count(a.id) num,'001' state,'all' type from f_mem_maintain_" + curGym
						+ " a where  (a.type='mc' or a.type='pt') " + (isBoss ? "" : " and " + appendSql) + "")
				.append(" union all select count(a.id),'001' state,'month' type from f_mem_maintain_" + curGym
						+ " a where  (a.type='mc' or a.type='pt') " + (isBoss ? "" : " and " + appendSql)
						+ " and a.op_time between ? and ?")
				.append(" union all select count(a.id),'001' state,'week' type from f_mem_maintain_" + curGym
						+ " a where  (a.type='mc' or a.type='pt') " + (isBoss ? "" : " and " + appendSql)
						+ " and a.op_time between ? and ?")
				.append(" union all select count(a.id),'001' state,'day' type from f_mem_maintain_" + curGym
						+ " a  where  (a.type='mc' or a.type='pt') " + (isBoss ? "" : " and " + appendSql)
						+ " and TO_DAYS(a.op_time) = TO_DAYS(?)")
				.append(" union all select count(a.id) num,'004' state,'all' type from f_mem_maintain_" + curGym
						+ " a where  (a.type='qmc' or a.type='qpt') " + (isBoss ? "" : " and " + appendSql) + "")
				.append(" union all select count(a.id),'004' state,'month' type from f_mem_maintain_" + curGym
						+ " a where  (a.type='qmc' or a.type='qpt') " + (isBoss ? "" : " and " + appendSql)
						+ " and a.op_time between ? and ?")
				.append(" union all select count(a.id),'004' state,'week' type from f_mem_maintain_" + curGym
						+ " a where  (a.type='qmc' or a.type='qpt') " + (isBoss ? "" : " and " + appendSql)
						+ " and a.op_time between ? and ?")
				.append(" union all select count(a.id),'004' state,'day' type from f_mem_maintain_" + curGym
						+ " a  where  (a.type='qmc' or a.type='qpt') " + (isBoss ? "" : " and " + appendSql)
						+ " and TO_DAYS(a.op_time) = TO_DAYS(?)");
		p1.addAll(p1);

		s = en.executeQuery(maintainSql.toString(), p1.toArray());

		if (s > 0) {

			this.obj.put("maintainInfo", en.getValues());
		}
	}
}
