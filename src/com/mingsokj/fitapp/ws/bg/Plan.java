package com.mingsokj.fitapp.ws.bg;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
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
import com.mingsokj.fitapp.ws.bg.set.SysSet;

/**
 * @author liul 2017年7月14日下午1:40:20
 */
public class Plan extends BasicAction {
	/**
	 * 添加团课
	 * 
	 * @Title: addPlan
	 * @author: liul
	 * @date: 2017年7月14日下午1:42:23
	 * @throws Exception
	 */
	@Route(value = "/fit-action-lesson-addPlan", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void addPlan() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String cust_name = user.getCust_name();
		String user_id = user.getUser_id();
		String state = this.getParameter("hidden");
		String is_free = this.getParameter("is_free");
		String experience = this.getParameter("experience");
		Entity en = this.getEntityFromPage("f_plan");
		if ("Y".equals(experience)) {
			String plan_name = this.getParameter("f_plan__plan_name") + "(体验)";
			en.setValue("plan_name", plan_name);
		}
		String recommendLesson = this.getParameter("recommendLesson");

		en.setValue("gym", gym);
		en.setValue("cust_name", cust_name);
		en.setValue("experience", experience);
		en.setValue("recommend_lesson", recommendLesson);
		en.setValue("user_id", user_id);
		en.setValue("state", state);
		en.setValue("is_free", is_free);
		en.setValue("create_time", new Date());
		en.setValue("type", "001");// 团课类型为001
		en.create();
	}

	@Route(value = "/fit-action-lesson-addFreePlan", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void addFreePlan() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String cust_name = user.getCust_name();
		String gym = user.getViewGym();
		String user_id = user.getUser_id();
		Entity en = this.getEntityFromPage("f_plan");
		en.setValue("gym", gym);
		en.setValue("create_time", new Date());
		en.setValue("user_id", user_id);
		en.setValue("state", "001");
		en.setValue("cust_name", cust_name);
		en.setValue("type", "001");// 团课类型为001
		en.create();
	}

	/**
	 * 修改团课
	 * 
	 * @Title: editPlan
	 * @author: liul
	 * @date: 2017年7月18日下午4:00:12
	 * @throws Exception
	 */
	@Route(value = "/fit-action-lesson-editPlan", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void editPlan() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String cust_name = user.getCust_name();
		String user_id = user.getUser_id();
		String state = this.getParameter("hidden");
		String is_free = this.getParameter("is_free");
		String experience = this.getParameter("experience");
		String f_plan__card_names = this.getParameter("f_plan__card_names");
		String recommendLesson = this.getParameter("recommendLesson");
		Entity en = this.getEntityFromPage("f_plan");
		if ("".equals(f_plan__card_names) || f_plan__card_names == null) {
			Entity entity = new EntityImpl(this);
			entity.executeUpdate("update f_plan set card_names=null where id=?",
					new String[] { en.getStringValue("id") });
		}
		en.setValue("gym", gym);
		en.setValue("cust_name", cust_name);
		en.setValue("user_id", user_id);
		en.setValue("state", state);
		en.setValue("is_free", is_free);
		en.setValue("experience", experience);
		en.setValue("recommend_lesson", recommendLesson);
		en.setValue("create_time", new Date());
		en.setValue("type", "001");// 团课类型为001
		en.update();
	}

	/**
	 * 预约团课
	 * 
	 * @Title: orderLesson
	 * @author: liul
	 * @date: 2017年8月1日下午4:16:55
	 * @throws Exception
	 */
	@Route(value = "fit-action-lesson-orderLesson", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void orderLesson() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String cust_name = user.getCust_name();
		String gym = user.getViewGym();
		String id = this.getParameter("mem_id");
		String plan_detail_id = this.getParameter("plan_list_id");
		String plan_id = request.getParameter("plan_id");
		Entity orderPlan = new EntityImpl("f_order", this);
		Entity entity = new EntityImpl("f_plan", this);
		// 潜客无法约课
		int size4 = entity.executeQuery("select * from f_mem_" + cust_name + " where id=? and state !='001'",
				new String[] { id });
		if (size4 > 0) {
			throw new Exception("正常激活会员才能约课");
		}
		// 正在上课无法预约
		int size3 = entity.executeQuery("select * from f_plan_detail where id=?", new String[] { plan_detail_id });
		if (size3 > 0) {
			String state = entity.getStringValue("state");
			if ("003".equals(state)) {
				throw new Exception("正在上课，无法预约");
			}
			if ("002".equals(state)) {
				throw new Exception("课程结束，无法预约");
			}
		}
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd hh:mm");
		boolean flag = false;
		// 判断预约时间是否已经结束
		// 获取预约设置
		int endTime = -1;
		int startTime = -1;
		try {
			startTime = Integer.parseInt(
					SysSet.getValues(cust_name, gym, "set_plan_order", "startTime", this.getConnection())) * 60;
		} catch (Exception e) {
		}
		try {
			endTime = Integer
					.parseInt(SysSet.getValues(cust_name, gym, "set_plan_order", "endTime", this.getConnection()));
		} catch (Exception e) {
		}
		entity.executeQuery("select * from f_plan_detail where id=?", new String[] { plan_detail_id });

		String lesson_time = entity.getStringValue("lesson_time") + " ";
		lesson_time += entity.getStringValue("start_time");
		Date startDate = format.parse(lesson_time);
		int minute = (int) (startDate.getTime() - new Date().getTime()) / (60 * 1000);
		if (endTime != -1 && startTime != -1) {

			if (minute > endTime && minute < startTime) {
				flag = true;
			} else {
				flag = false;
			}
		} else if (endTime != -1 && startTime == -1) {

			if (minute > endTime) {
				flag = true;
			} else {
				flag = false;
			}

		} else if (endTime == -1 && startTime != -1) {
			if (minute < startTime) {
				flag = true;
			} else {
				flag = false;
			}
		} else {
			if (minute > 0) {
				flag = true;

			}

		}
		if (flag) {
			// 查询是否已经预约该课程
			orderPlan.setTablename("f_order_" + gym);
			orderPlan.setValue("mem_id", id);
			orderPlan.setValue("plan_list_id", plan_detail_id);
			int size2 = orderPlan.search();
			if (size2 > 0) {
				String state = orderPlan.getStringValue("state");
				// String order_id = orderPlan.getStringValue("id");
				if ("001".equals(state)) {
					throw new Exception("您已预约该课程");
				} else if ("002".equals(state)) {
					// 取消预约再次
					// orderPlan.executeUpdate("update f_order_"+gym+" set
					// state='001' where id=?", new String[]{order_id});
				}
			}
			// 查询预约次团课要求
			entity.setValue("id", plan_id);
			entity.search();
			String emp_id = entity.getStringValue("pt_id");
			String card_names = entity.getStringValue("card_names");
			int top_num = 0;
			if (!"".equals(entity.getStringValue("top_num"))) {
				top_num = Integer.parseInt(entity.getStringValue("top_num"));
			}
			// 已经预约多少人
			int mem_nums = entity.executeQuery("select * from f_order_" + gym + " where plan_list_id=? and state='001'",
					new String[] { plan_detail_id });
			if (Utils.isNull(card_names)) {
				orderPlan = new EntityImpl("f_order", this);
				orderPlan.setTablename("f_order_" + gym);
				orderPlan.setValue("gym", gym);
				orderPlan.setValue("cust_name", cust_name);
				orderPlan.setValue("mem_id", id);
				orderPlan.setValue("start_time", new Date());
				orderPlan.setValue("op_time", new Date());
				orderPlan.setValue("state", "001");
				orderPlan.setValue("plan_id", plan_id);
				orderPlan.setValue("plan_list_id", plan_detail_id);
				orderPlan.setValue("mem_nums", mem_nums);
				orderPlan.setValue("emp_id", emp_id);
				orderPlan.create();
				// 预约人数是否已达上限
				int sizeUpdate = 0;
				// 如果没设置人数上限，则可以无限人数预约
				if (top_num > 0) {
					// 预约人数是否已达上限
					sizeUpdate = orderPlan
							.executeUpdate(
									"update f_order_" + gym
											+ " set mem_nums=mem_nums+1 where plan_list_id=? and mem_nums<=" + top_num,
									new String[] { plan_detail_id });
				} else {
					sizeUpdate = orderPlan.executeUpdate(
							"update f_order_" + gym + " set mem_nums=mem_nums+1 where plan_list_id=? ",
							new String[] { plan_detail_id });
				}
				if (sizeUpdate > 0) {

				} else {
					throw new Exception("预约人数已满");
				}
			} else {
				// 查看会员是否有这张私教卡

				List<Map<String, Object>> cards = MemUtils.getAllMemCardsByCardId(card_names, id, cust_name, gym);
				if (cards.size() > 0) {
					int num = 0;
					for (Map<String, Object> map : cards) {
						int remain_times = Utils.getMapIntegerValue(map, "remain_times");
						num += remain_times;
					}

					/*
					 * int size = entity.executeQuery(
					 * "SELECT b.id,b.DEADLINE,b.REMAIN_TIMES FROM f_mem_" +
					 * cust_name + " a,f_user_card_" + gym +
					 * " b,f_card c WHERE a.ID = b.MEM_ID AND c.id=b.card_id AND b.state='001' and b.REMAIN_TIMES > 0 AND b.DEADLINE >NOW() AND c.ID=? AND b.MEM_ID=?"
					 * , new String[] { card_names, id }); if (size > 0) { //
					 * 查看该用户私教卡次数是否用完 int updateSize = entity.executeQuery(
					 * "select * from f_user_card_" + gym +
					 * " where card_id=? and mem_id=? and DEADLINE > NOW() AND REMAIN_TIMES > 0"
					 * , new String[] { card_names, id });
					 */
					if (num > 0) {
						// int num = entity.getIntegerValue("num");
						// 查询已预约并需要该卡的数量
						int s = entity.executeQuery("select view_gym from f_card_gym where fk_card_id = ?",
								new Object[] { card_names });
						StringBuilder sql = new StringBuilder();
						List<String> params = new ArrayList<>();
						for (int i = 0; i < s; i++) {
							sql.append("select count(*) num from f_plan a,f_order_")
									.append(entity.getStringValue("view_gym", i))
									.append(" b where a.id = b.plan_id and a.card_names = ? and b.mem_id =? and b.state ='001'");
							params.add(card_names);
							params.add(id);
							if (i != s - 1) {
								sql.append(" union all ");
							}
						}

						s = entity.executeQuery(sql.toString(), params.toArray());
						int hasOrderNum = 0;
						if (s > 0) {
							for (int i = 0; i < s; i++) {
								hasOrderNum += entity.getIntegerValue("num", i);
							}
						}

						if (hasOrderNum >= num) {
							throw new Exception("该私教卡剩余" + num + "次,您已预约了" + hasOrderNum + "节了");
						}

						orderPlan = new EntityImpl("f_order", this);
						orderPlan.setTablename("f_order_" + gym);
						orderPlan.setValue("gym", gym);
						orderPlan.setValue("cust_name", cust_name);
						orderPlan.setValue("mem_id", id);
						orderPlan.setValue("start_time", new Date());
						orderPlan.setValue("op_time", new Date());
						orderPlan.setValue("state", "001");
						orderPlan.setValue("plan_id", plan_id);
						orderPlan.setValue("plan_list_id", plan_detail_id);
						orderPlan.setValue("mem_nums", mem_nums);
						orderPlan.setValue("emp_id", emp_id);
						orderPlan.create();
						int sizeUpdate = 0;
						// 如果没设置人数上限，则可以无限人数预约
						if (top_num > 0) {
							// 预约人数是否已达上限
							sizeUpdate = orderPlan.executeUpdate(
									"update f_order_" + gym
											+ " set mem_nums=mem_nums+1 where plan_list_id=? and mem_nums<=" + top_num,
									new String[] { plan_detail_id });
						} else {
							sizeUpdate = orderPlan.executeUpdate(
									"update f_order_" + gym + " set mem_nums=mem_nums+1 where plan_list_id=? ",
									new String[] { plan_detail_id });
						}
						if (sizeUpdate > 0) {
							this.obj.put("temp", "Y");
						} else {
							throw new Exception("预约人数已满");
						}
					} else {
						throw new Exception("私教卡次数不足");
					}
				} else {
					this.obj.put("temp", "N");
					// 拿到该卡片名字
					entity.executeQuery("select * from f_card where id=?", new String[] { card_names });
					String cardName = entity.getStringValue("card_name");
					throw new Exception("预约该课需要" + cardName + "私教卡");
				}
			}
		} else {
			throw new Exception("预约时间已截止");
		}

	}

	/**
	 * 团课排期
	 * 
	 * @Title: addPaiQi
	 * @author: liul
	 * @date: 2017年7月15日上午9:09:06
	 * @throws Exception
	 */
	@Route(value = "/fit-action-lesson-addPaiQi", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void addPaiQi() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String cust_name = user.getCust_name();
		String op_id = user.getId();
		String id = this.getParameter("f_plan__pt_id");
		if ("".equals(id)) {
			throw new Exception("请选择课程");
		}
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		// 查询次课程是否已经拍过期，如果拍过则删除
		// Entity en = new EntityImpl("f_plan_list", this);
		// en.setValue("plan_id", id);
		// int size = en.search();
		// String planListId = en.getStringValue("id");
		/*
		 * if (size > 0) { en.setValue("plan_id", id); en.delete(); Entity
		 * planDetail = new EntityImpl("f_plan_detail", this);
		 * planDetail.executeUpdate(
		 * "DELETE  from f_plan_detail WHERE plan_list_id=?", new String[] {
		 * planListId }); }
		 */
		// 拿到排课起止日期,添加到排期表中
		String start = this.getParameter("start");
		String end = this.getParameter("end");
		if (Utils.isNull(start) || Utils.isNull(end)) {
			throw new Exception("请选择起止日期");
		}
		Date startDate = format.parse(start);
		Date enDate = format.parse(end);
		Entity en = new EntityImpl("f_plan_list", this);
		en.setValue("gym", gym);
		en.setValue("cust_name", cust_name);
		en.setValue("start_time", startDate);
		en.setValue("end_time", enDate);
		en.setValue("plan_id", id);
		en.setValue("state", "Y");
		en.setValue("op_id", op_id);
		en.setValue("create_time", new Date());
		String plan_list_id = en.create();
		/*
		 * Entity en2 = new EntityImpl("f_plan_list", this);
		 * en2.setValue("plan_id", id); en2.search(); String plan_list_id =
		 * en2.getStringValue("id");
		 */
		// 拿到排期的星期,添加到排期明细中
		String[] week = this.getParameterValues("week");
		String[] startTime = new String[8];
		String[] endTime = new String[8];
		String weekDays = "";
		for (String string : week) {
			weekDays += string;
		}
		Map<String, List<String>> map = getDates(start, end, weekDays);
		// 拿到日期和对应的星期
		for (int i = 0; i < week.length; i++) {
			startTime[Integer.parseInt(week[i])] = this.getParameter("startTime" + week[i]);
			endTime[Integer.parseInt(week[i])] = this.getParameter("endTime" + week[i]);
		}
		String[] date = new String[map.get("date").size()];
		map.get("date").toArray(date);
		String[] weekList = new String[map.get("week").size()];
		map.get("week").toArray(weekList);
		Entity entity = new EntityImpl("f_plan_detail", this);
		for (int i = 0; i < date.length; i++) {
			entity.setValue("plan_list_id", plan_list_id);
			entity.setValue("gym", gym);
			entity.setValue("cust_name", cust_name);
			entity.setValue("week", weekList[i]);
			String start_time = startTime[Integer.parseInt(weekList[i])];
			String end_time = endTime[Integer.parseInt(weekList[i])];
			entity.setValue("start_time", start_time);
			entity.setValue("end_time", end_time);
			Date lesson_time = format.parse(date[i]);
			entity.setValue("lesson_time", lesson_time);
			entity.setValue("state", "001");
			entity.create();
		}
	}

	/**
	 * 显示团课
	 * 
	 * @Title: showPlan
	 * @author: liul
	 * @date: 2017年7月15日下午1:06:46
	 * @throws Exception
	 */
	@Route(value = "/fit-action-lesson-showPlan", conn = true, slave = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void showPlan() throws Exception {
		// MsgUtils.sendPhoneMsg("fit", "fit", "消课", "18223586775",
		// "{'name':'刘磊','cardName':'瑜伽卡','times':'5'}",
		// this.getConnection(),"lesson");
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String cust_name = user.getCust_name();
		// 拿到星期一到星期天的日期
		String one = this.getParameter("searchMonday");
		String two = this.getParameter("searchTuesday");
		String three = this.getParameter("searchWednesday");
		String four = this.getParameter("searchThursday");
		String five = this.getParameter("searchFriday");
		String six = this.getParameter("searchSaturday");
		String seven = this.getParameter("searchSunday");
		List<Map<String, Object>> listOne = getList(one, cust_name, gym);
		List<Map<String, Object>> listTwo = getList(two, cust_name, gym);
		List<Map<String, Object>> listThree = getList(three, cust_name, gym);
		List<Map<String, Object>> listFour = getList(four, cust_name, gym);
		List<Map<String, Object>> listFive = getList(five, cust_name, gym);
		List<Map<String, Object>> listSix = getList(six, cust_name, gym);
		List<Map<String, Object>> listSeven = getList(seven, cust_name, gym);
		int listOneSize = listOne.size();
		int listTwoSize = listTwo.size();
		int listThreeSize = listThree.size();
		int listFourSize = listFour.size();
		int listFiveSize = listFive.size();
		int listSixSize = listSix.size();
		int listSevenSize = listSeven.size();
		// 初始化数组
		List<Integer> nums = new ArrayList<Integer>();
		nums.add(listOneSize);
		nums.add(listTwoSize);
		nums.add(listThreeSize);
		nums.add(listFourSize);
		nums.add(listFiveSize);
		nums.add(listSixSize);
		nums.add(listSevenSize);
		// 设置最大值Max
		int Max = Collections.max(nums);
		this.obj.put("listOne", listOne);
		this.obj.put("listTwo", listTwo);
		this.obj.put("listThree", listThree);
		this.obj.put("listFour", listFour);
		this.obj.put("listFive", listFive);
		this.obj.put("listSix", listSix);
		this.obj.put("listSeven", listSeven);
		this.obj.put("max", Max);
	}

	public List<Map<String, Object>> getList(String day, String cust_name, String gym) throws Exception {
		Entity en = new EntityImpl(this);
		List<Map<String, Object>> showPlan = new ArrayList<>();
		en.executeQuery(
				"SELECT a.state,a.LESSON_TIME,b.id as plan_id,a.id,a.week,b.PLAN_NAME,a.START_TIME,a.END_TIME,b.PT_ID from f_plan_detail a,f_plan b,f_plan_list c WHERE a.PLAN_LIST_ID = c.ID AND c.PLAN_ID = b.ID AND a.lesson_time = ? AND b.GYM='"
						+ gym + "' ORDER BY a.START_TIME ASC",
				new String[] { day });
		showPlan = (en.getValues());

		for (Map<String, Object> map : showPlan) {
			String pt_id = map.get("pt_id").toString();
			// 判断团课当前状态
			String state = map.get("state").toString();
			if ("001".equals(state)) {
				map.put("plan_state", "未上课");
			} else if ("002".equals(state)) {
				map.put("plan_state", "已上课");
			} else if ("003".equals(state)) {
				map.put("plan_state", "正在上课");
			}
			if (pt_id.equals("1")) {
				map.put("name", "未选择教练");
			} else {
				int size = en.executeQuery("select a.id,b.mem_name as name from f_emp a,f_mem_" + cust_name
						+ "  b where a.id=b.id and a.id=?", new String[] { pt_id });
				if (size > 0) {
					map.put("name", MemUtils.getMemInfo(en.getStringValue("id"), cust_name).getName());
				} else {
					map.put("name", "未选择教练");
				}
			}
		}
		return showPlan;
	}

	/**
	 * 获取团课详情
	 * 
	 * @Title: detailPlan
	 * @author: liul
	 * @date: 2017年7月18日下午2:24:31
	 * @throws Exception
	 */
	@Route(value = "/fit-action-lesson-detailPlan", conn = true, slave = true, m = HttpMethod.GET, type = ContentType.Forward)
	public void detailPlan() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String cust_name = user.getCust_name();
		String id = this.getParameter("id");
		Entity en = new EntityImpl("f_plan", this);
		int size = en.executeQuery("SELECT a.* FROM f_plan a WHERE a.ID=?", new String[] { id });
		String pt_id = en.getStringValue("pt_id");
		Entity entity = new EntityImpl(this);
		entity.executeQuery(
				"select b.mem_name as name from f_emp a,f_mem_" + cust_name + "  b where a.id=b.id and b.id=?",
				new String[] { pt_id });

		if (size > 0) {
			String nextPage = this.getParameter("nextpage");
			request.setAttribute("f_emp", entity);
			request.setAttribute("f_plan", en);
			this.obj.put("nextpage", nextPage);
		} else {
			throw new Exception("没有此团课，请联系管理员");
		}
	}

	/**
	 * 获取当天的团课
	 * 
	 * @Title: getNowPlan
	 * @author: liul
	 * @date: 2017年7月20日下午2:26:39
	 * @throws Exception
	 */

	@Route(value = "/fit-action-lesson-getNowPlan", conn = true, slave = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void getNowPlan() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		List<Map<String, Object>> list = new ArrayList<>();
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");

		Date now = new Date();
		String nowTime = format.format(now);
		Entity en = new EntityImpl(this);
		Entity entity = new EntityImpl(this);
		String sql = "SELECT a.START_TIME,a.END_TIME,a.ID as plan_detail_id,b.id as plan_id,b.PLAN_NAME,a.START_TIME,a.END_TIME,b.PT_ID from f_plan_detail a,f_plan b,f_plan_list c WHERE a.PLAN_LIST_ID = c.ID AND c.PLAN_ID = b.ID AND a.lesson_time = ? AND b.GYM=? ORDER BY a.START_TIME ASC";
		int size = en.executeQuery(sql, new String[] { nowTime, gym });
		if (size > 0) {
			list = en.getValues();
			for (Map<String, Object> map : list) {
				String pt_id = map.get("pt_id") + "";
				String plan_detail_id = map.get("plan_detail_id").toString();// 根据id查看约课情况
				int mem_nums = entity.executeQuery(
						"select * from f_order_" + gym + " where plan_list_id=? and state='001'",
						new String[] { plan_detail_id });
				String plan_id = map.get("plan_id").toString();// 查看该团课约课上限
				map.put("mem_nums", mem_nums);
				entity.executeQuery("select top_num from f_plan where id=?", new String[] { plan_id });
				String top_num = entity.getStringValue("top_num");
				map.put("top_num", top_num);
				if (pt_id.equals("1")) {
					map.put("name", "未选择教练");
				} else {
					MemInfo ptInfo = MemUtils.getMemInfo(pt_id, user.getCust_name(), L);
					if (ptInfo != null) {
						map.put("name", ptInfo.getName());
					} else {
						map.put("name", "-");
					}
				}
			}
		}
		this.obj.put("list", list);
	}

	/**
	 * 显示课程预约详情
	 * 
	 * @Title: showLessonDetail
	 * @author: liul
	 * @date: 2017年7月18日上午11:11:53
	 * @throws Exception
	 */
	@Route(value = "/fit-action-lesson-showLessonDetail", conn = true, slave = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void showLessonDetail() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String cust_name = user.getCust_name();
		String id = this.getParameter("id");
		String type = this.getParameter("type");
		Entity en = new EntityImpl("f_plan_detail", this);
		en.setValue("id", id);
		List<Map<String, Object>> list = new ArrayList<>();
		int size = en.search();
		if (size > 0) {
			Entity entity = new EntityImpl(this);
			list = en.getValues();
			String sql = "";
			if ("search".equals(type)) {
				String userName = this.getParameter("userName");
				String phone = this.getParameter("phone");
				sql = "SELECT b.id as mem_id,a.id,b.mem_name,b.PHONE,b.APP_OPEN_ID,a.state as order_state,a.START_TIME,c.card_names from f_order_"
						+ gym + " a,f_mem_" + cust_name
						+ " b,f_plan c WHERE a.MEM_ID=b.id and c.id=a.plan_id and PLAN_LIST_ID=? and b.phone like ? and b.mem_name like ?";
				entity.executeQuery(sql, new String[] { id, phone + "%", userName + "%" });
			} else if ("show".equals(type)) {
				// 获取团课预约详情
				sql = "SELECT b.id as mem_id,a.id,b.mem_name,b.PHONE,b.APP_OPEN_ID,a.state as order_state,a.START_TIME,c.card_names from f_order_"
						+ gym + " a,f_mem_" + cust_name
						+ " b,f_plan c WHERE a.MEM_ID=b.id and c.id=a.plan_id and PLAN_LIST_ID=?";
				entity.executeQuery(sql, new String[] { id });
			}
			list.addAll(entity.getValues());
			// 拿到私教卡名字
			for (Map<String, Object> map : list) {
				String card_id = map.get("card_names") + "";
				String mem_id = map.get("mem_id") + "";
				int size2 = entity.executeQuery("select * from f_card where id=?", new String[] { card_id });
				if (size2 > 0) {
					map.put("card_name", entity.getStringValue("card_name"));
				}
				if (!"".equals(mem_id) && !"null".equals(mem_id)) {
					map.put("mem_name", MemUtils.getMemInfo(mem_id, cust_name).getName());
				}
			}

			this.obj.put("list", list);
		} else {
			throw new Exception("未查到该课程，请联系管理员");
		}
	}

	/**
	 * 显示团课排期
	 * 
	 * @Title: showPlan
	 * @author: liul
	 * @date: 2017年7月15日下午3:55:16
	 * @throws Exception
	 */
	@Route(value = "/fit-action-lesson-showPaiQi", conn = true, slave = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void showPaiQi() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String cust_name = user.getCust_name();
		String type = this.getParameter("type");

		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		Date now = new Date();
		String nowTime = format.format(now);
		List<Map<String, Object>> list = new ArrayList<>();
		Entity en = new EntityImpl(this);
		String sql = "";
		// 用户是否是点击搜索
		if ("search".equals(type)) {
			String plan_name = this.getParameter("plan_name");
			String coach = this.getParameter("coach");
			String address = this.getParameter("address");
			// 拿到教练的id
			en.executeQuery("select a.id from f_emp a,f_mem_" + cust_name
					+ " b where a.id=b.id and b.mem_name like ? and pt='Y'", new String[] { coach + "%" });
			List<Map<String, Object>> empId = en.getValues();
			if (empId.size() > 0) {
				String empSize = Utils.getListString("?", empId.size());
				String[] search = new String[empId.size() + 4];
				search[0] = gym;
				search[1] = nowTime;
				search[2] = plan_name + "%";
				search[3] = address + "%";
				for (int i = 0; i < empId.size(); i++) {
					search[i + 4] = empId.get(i).get("id").toString();
				}
				sql = "SELECT c.create_time as create_time,c.id as PLAN_LIST_ID,b.id,count(a.PLAN_LIST_ID) as num,a.week,b.PLAN_NAME,c.START_TIME,c.END_TIME,b.pt_id from f_plan_detail a,f_plan b,f_plan_list c WHERE a.PLAN_LIST_ID = c.ID AND c.PLAN_ID = b.ID AND b.GYM=? AND c.END_TIME>? AND b.PLAN_NAME like ? AND b.ADDR_NAME LIKE ? and b.pt_id in ("
						+ empSize + ") GROUP BY PLAN_LIST_ID order by c.create_time desc";
				en.executeQuery(sql, search);
			} else {
				sql = "SELECT c.create_time as create_time,c.id as PLAN_LIST_ID,b.id,count(a.PLAN_LIST_ID) as num,a.week,b.PLAN_NAME,c.START_TIME,c.END_TIME,b.pt_id from f_plan_detail a,f_plan b,f_plan_list c WHERE a.PLAN_LIST_ID = c.ID AND c.PLAN_ID = b.ID AND b.GYM=? AND c.END_TIME>? AND b.PLAN_NAME like ? AND b.ADDR_NAME LIKE ? GROUP BY PLAN_LIST_ID order by c.create_time desc";
				en.executeQuery(sql, new String[] { gym, nowTime, plan_name + "%", address + "%" });
			}
		} else if ("show".equals(type)) {
			sql = "SELECT c.create_time as create_time, c.id as PLAN_LIST_ID,b.id,count(a.PLAN_LIST_ID) as num,a.week,b.PLAN_NAME,c.START_TIME,c.END_TIME,b.pt_id from f_plan_detail a,f_plan b,f_plan_list c WHERE a.PLAN_LIST_ID = c.ID AND c.PLAN_ID = b.ID AND b.GYM=? AND c.END_TIME>? GROUP BY PLAN_LIST_ID order by c.create_time desc ";
			en.executeQuery(sql, new String[] { gym, nowTime });
		}

		Entity en2 = new EntityImpl(this);
		Entity entity = new EntityImpl(this);
		String getEmpName = "select * from f_plan_list where id=?";

		list = en.getValues();
		// 拿到操作人和教练，封装到list中
		for (int i = 0; i < list.size(); i++) {
			String pt_id = list.get(i).get("pt_id") + "";
			if (pt_id.equals("1")) {
				list.get(i).put("name", "未选择教练");
			} else {
				int size2 = en2.executeQuery(
						"select a.id from f_emp a,f_mem_" + cust_name + " b where a.id=b.id and a.id=?",
						new String[] { pt_id });
				if (size2 > 0) {
					list.get(i).put("name", MemUtils.getMemInfo(en2.getStringValue("id"), cust_name).getName());
				} else {
					list.get(i).put("name", "未选择教练");
				}
			}
			int size2 = entity.executeQuery(getEmpName, new String[] { en.getStringValue("PLAN_LIST_ID", i) });
			if (size2 > 0) {
				list.get(i).put("emp_name", MemUtils.getMemInfo(entity.getStringValue("op_id"), cust_name).getName());
			} else {
				list.get(i).put("emp_name", "管理员");
			}
		}
		this.obj.put("list", list);
	}

	/**
	 * 查看排期
	 * 
	 * @Title: showOnePaiQi
	 * @author: liul
	 * @date: 2017年7月17日上午11:39:21
	 * @throws Exception
	 */
	@Route(value = "/fit-action-lesson-searchPaiQi", conn = true, slave = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void searchPaiQi() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String id = this.getParameter("id");
		List<Map<String, Object>> list = new ArrayList<>();
		Entity en = new EntityImpl(this);
		en.executeQuery(
				"SELECT a.week,a.START_TIME,a.END_TIME from f_plan_detail a,f_plan b,f_plan_list c,f_emp e WHERE a.PLAN_LIST_ID = c.ID AND c.PLAN_ID = b.ID AND e.ID=b.PT_ID AND b.GYM=? AND b.ID=? GROUP BY a.week ",
				new String[] { gym, id });
		list = en.getValues();
		this.obj.put("list", list);

	}

	/**
	 * 显示需要编辑的团课排期
	 * 
	 * @Title: showEditPlan
	 * @author: liul
	 * @date: 2017年7月17日下午5:38:06
	 * @throws Exception
	 */
	@Route(value = "/fit-action-lesson-showEditPlan", conn = true, slave = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void showEditPlan() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String id = this.getParameter("id");
		String type = this.getParameter("type");
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		Date now = new Date();
		String nowTime = format.format(now);
		Entity entity = new EntityImpl(this);
		List<Map<String, Object>> list = new ArrayList<>();
		String sql = "";
		if ("search".equals(type)) {
			String dayTime = this.getParameter("dayTime");
			String state = this.getParameter("state");
			String id2 = this.getParameter("id");
			sql = "SELECT a.ID, a.LESSON_TIME,a.week,a.START_TIME,a.END_TIME,b.START_NUM from f_plan_detail a,f_plan b,f_plan_list c WHERE a.PLAN_LIST_ID = c.ID AND c.PLAN_ID = b.ID  AND b.GYM=? AND c.ID=? AND a.LESSON_TIME like ? AND a.state = ? GROUP BY a.ID ";
			entity.executeQuery(sql, new String[] { gym, id2, dayTime + "%", state });
		} else if ("show".equals(type)) {
			sql = "SELECT a.ID, a.LESSON_TIME,a.week,a.START_TIME,a.END_TIME,b.START_NUM from f_plan_detail a,f_plan b,f_plan_list c WHERE a.PLAN_LIST_ID = c.ID AND c.PLAN_ID = b.ID  AND b.GYM=? AND c.ID=? AND a.LESSON_TIME>? GROUP BY a.ID ";
			entity.executeQuery(sql, new String[] { gym, id, nowTime });
		}

		list = entity.getValues();
		// 查看已预约的人数
		Entity en = new EntityImpl(this);
		String getNum = "SELECT COUNT(*) as num from f_order_" + gym + " WHERE PLAN_LIST_ID=?";
		for (int i = 0; i < list.size(); i++) {
			int size2 = en.executeQuery(getNum, new String[] { entity.getStringValue("id", i) });
			if (size2 > 0) {
				list.get(i).put("num", en.getStringValue("num"));
			} else {
				list.get(i).put("num", "0");
			}
		}
		this.obj.put("list", list);
	}

	/**
	 * 删除排期
	 * 
	 * @Title: searchPaiQi
	 * @author: liul
	 * @date: 2017年7月17日下午4:29:53
	 * @throws Exception
	 */
	@Route(value = "/fit-action-lesson-deletePlan", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void deletePlan() throws Exception {
		String id = this.getParameter("id");
		Entity en = new EntityImpl(this);
		int size = en.executeUpdate("delete from f_plan_list where id=?", new String[] { id });
		if (size <= 0) {
			throw new Exception("删除失败，未找到该课程");
		}
		en.executeUpdate("DELETE  from f_plan_detail WHERE plan_list_id=?", new String[] { id });
	}

	/**
	 * 取消课程
	 * 
	 * @Title: deletePlan
	 * @author: liul
	 * @date: 2017年7月18日上午10:28:35
	 * @throws Exception
	 */
	@Route(value = "/fit-action-lesson-cancelYuYue", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void cancelYuYue() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String id = this.getParameter("id");
		String detail_id = this.getParameter("detail_id");
		// 如果是上课状态无法修改时间
		Entity entity = new EntityImpl(this);
		int size = entity.executeQuery("select * from f_plan_detail where id=?", new String[] { detail_id });
		if (size > 0) {
			String state = entity.getStringValue("state");
			if ("003".equals(state)) {
				throw new Exception("正在上课，无法取消预约");
			}
			if ("002".equals(state)) {
				throw new Exception("已上课程，无法取消预约");
			}
		}
		Entity en = new EntityImpl("f_order", this);
		en.setTablename("f_order_" + gym);
		en.setValue("id", id);
		en.setValue("state", "002");
		en.update();
	}

	/**
	 * 取消预约
	 * 
	 * @Title: cancelLesson
	 * @author: liul
	 * @date: 2017年7月19日上午11:26:01
	 * @throws Exception
	 */
	@Route(value = "/fit-action-lesson-cancelLesson", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void cancelLesson() throws Exception {
		String id = this.getParameter("id");
		// 如果是上课状态无法取消预约
		Entity entity = new EntityImpl(this);
		int size = entity.executeQuery("select * from f_plan_detail where id=?", new String[] { id });
		if (size > 0) {
			String state = entity.getStringValue("state");
			if ("003".equals(state)) {
				throw new Exception("正在上课，无法取消预约");
			}

		}
		Entity en = new EntityImpl("f_plan_detail", this);
		en.setValue("id", id);
		en.delete();
	}

	/**
	 * 修改排期课程时间
	 * 
	 * @Title: editTime
	 * @author: liul
	 * @date: 2017年7月18日上午9:39:50
	 * @throws Exception
	 */
	@Route(value = "/fit-action-lesson-editTime", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void editTime() throws Exception {
		String id = this.getParameter("id");
		String startTime = this.getParameter("startTime");
		String endTime = this.getParameter("endTime");
		// 如果是上课状态无法修改时间
		Entity entity = new EntityImpl(this);
		int size = entity.executeQuery("select * from f_plan_detail where id=?", new String[] { id });
		if (size > 0) {
			String state = entity.getStringValue("state");
			if ("003".equals(state)) {
				throw new Exception("正在上课，无法修改时间");
			}
			if ("002".equals(state)) {
				throw new Exception("已上课程，无法修改时间");
			}
		}
		Entity en = new EntityImpl("f_plan_detail", this);
		en.setValue("id", id);
		en.setValue("start_time", startTime);
		en.setValue("end_time", endTime);
		en.update();
	}

	public static Map<String, List<String>> getDates(String dateFrom, String dateEnd, String weekDays) {
		long time = 1l;
		long perDayMilSec = 24 * 60 * 60 * 1000;
		List<String> dateList = new ArrayList<String>();
		List<String> weekList = new ArrayList<String>();
		Map<String, List<String>> map = new HashMap<>();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		// 需要查询的星期系数
		String strWeekNumber = weekDays;
		try {
			dateFrom = sdf.format(sdf.parse(dateFrom).getTime() - perDayMilSec);
			while (true) {
				time = sdf.parse(dateFrom).getTime();
				time = time + perDayMilSec;
				Date date = new Date(time);
				dateFrom = sdf.format(date);
				if (dateFrom.compareTo(dateEnd) <= 0) {
					// 查询的某一时间的星期系数
					Integer weekDay = dayForWeek(date);
					// 判断当期日期的星期系数是否是需要查询的
					if (strWeekNumber.indexOf(weekDay.toString()) != -1) {
						System.out.println(dateFrom);
						dateList.add(dateFrom);
						weekList.add("" + weekDay);
					}
				} else {
					break;
				}
			}
		} catch (ParseException e1) {
			e1.printStackTrace();
		}
		map.put("week", weekList);
		map.put("date", dateList);

		return map;
	}

	// 等到当期时间的周系数。星期日：1，星期一：2，星期二：3，星期三：4，星期四：5，星期五：6，星期六：7
	public static Integer dayForWeek(Date date) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		return calendar.get(Calendar.DAY_OF_WEEK);
	}

	/**
	 * 得到对应星期的系数 星期日：1，星期一：2，星期二：3，星期三：4，星期四：5，星期五：6，星期六：7
	 * 
	 * @param weekDays
	 *            星期格式 星期一|星期二
	 */
	public static String weekForNum(String weekDays) {
		// 返回结果为组合的星期系数
		String weekNumber = "";
		// 解析传入的星期
		if (weekDays.indexOf("|") != -1) {// 多个星期数
			String[] strWeeks = weekDays.split("\\|");
			for (int i = 0; i < strWeeks.length; i++) {
				weekNumber = weekNumber + "" + getWeekNum(strWeeks[i]).toString();
			}
		} else {// 一个星期数
			weekNumber = getWeekNum(weekDays).toString();
		}

		return weekNumber;

	}

	// 将星期转换为对应的系数 星期日：1，星期一：2，星期二：3，星期三：4，星期四：5，星期五：6，星期六：7
	public static Integer getWeekNum(String strWeek) {
		Integer number = 1;// 默认为星期日
		if ("星期日".equals(strWeek)) {
			number = 1;
		} else if ("星期一".equals(strWeek)) {
			number = 2;
		} else if ("星期二".equals(strWeek)) {
			number = 3;
		} else if ("星期三".equals(strWeek)) {
			number = 4;
		} else if ("星期四".equals(strWeek)) {
			number = 5;
		} else if ("星期五".equals(strWeek)) {
			number = 6;
		} else if ("星期六".equals(strWeek)) {
			number = 7;
		}
		return number;
	}
}
