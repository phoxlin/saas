package com.mingsokj.fitapp.ws.bg;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.utils.MemUtils;
import com.mingsokj.fitapp.ws.bg.set.SysSet;

/**
 * @author liul 2017年8月1日上午10:12:04
 */
public class LessonAction extends BasicAction {

	/**
	 * 显示推荐课程
	 * 
	 * @Title: showThisDayLesson
	 * @author: liul
	 * @date: 2017年8月1日上午10:14:31
	 * @throws Exception
	 */
	@Route(value = "fit-ws-app-showThisDayLesson", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void showThisDayLesson() throws Exception {
		String gym = request.getParameter("gym");
		String cust_name = request.getParameter("cust_name");
		String type = request.getParameter("type");
		List<Map<String, Object>> list = new ArrayList<>();
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		SimpleDateFormat format2 = new SimpleDateFormat("hh:mm");
		Date now = new Date();
		String nowTime = format.format(now);
		Entity en = new EntityImpl(this);
		Entity entity = new EntityImpl(this);
		String sql = "SELECT b.experience,b.PIC_URL,a.ID as plan_detail_id,b.id as plan_id,b.PLAN_NAME,a.START_TIME,a.END_TIME,b.PT_ID from f_plan_detail a,f_plan b,f_plan_list c WHERE a.PLAN_LIST_ID = c.ID AND c.PLAN_ID = b.ID AND a.lesson_time = ? AND b.GYM=? and b.experience='N' ORDER BY a.START_TIME ASC";
		if ("recommend".equals(type)) {
			sql = "SELECT b.experience,b.PIC_URL,a.ID as plan_detail_id,b.id as plan_id,b.PLAN_NAME,a.START_TIME,a.END_TIME,b.PT_ID from f_plan_detail a,f_plan b,f_plan_list c WHERE a.PLAN_LIST_ID = c.ID AND c.PLAN_ID = b.ID AND a.lesson_time > ? AND b.GYM=? and b.recommend_lesson='Y' and b.experience='N' group by b.id ORDER BY a.START_TIME ASC";
		}

		int size = en.executeQuery(sql, new String[] { nowTime, gym });
		if (size > 0) {
			list = en.getValues();
			for (Map<String, Object> map : list) {
				// 计算课程总上共多少分钟
				String start = map.get("start_time") + "";
				String end = map.get("end_time") + "";
				Date startDate = format2.parse(start);
				Date endDate = format2.parse(end);
				int minute = (int) ((endDate.getTime() - startDate.getTime()) / (60 * 1000));
				map.put("minute", minute);
				String pt_id = Utils.getMapStringValue(map, "pt_id");
				String plan_detail_id = map.get("plan_detail_id").toString();// 根据id查看约课情况
				int mem_nums = entity.executeQuery("select * from f_order_" + gym + " where plan_list_id=? and state='001'", new String[] { plan_detail_id });
				String plan_id = map.get("plan_id").toString();// 查看该团课约课上限
				map.put("mem_nums", mem_nums);
				entity.executeQuery("select top_num from f_plan where id=?", new String[] { plan_id });
				String top_num = entity.getStringValue("top_num");
				map.put("top_num", top_num);
				if (pt_id.equals("1")) {
					map.put("name", "未选择教练");
				} else {
					MemInfo pt = MemUtils.getMemInfo(pt_id, cust_name);
					if (pt != null) {
						String ptName = pt.getName();
						map.put("name",ptName );
					}
				}
			}
		}
		this.obj.put("list", list);
	}

	/**
	 * 根据日期查询课表信息
	 * 
	 * @Title: searchLessonForTime
	 * @author: liul
	 * @date: 2017年8月1日上午11:49:50
	 * @throws Exception
	 */
	@Route(value = "fit-ws-app-searchLessonForTime", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void searchLessonForTime() throws Exception {
		String cust_name = request.getParameter("cust_name");
		String gym = request.getParameter("gym");
		String day = request.getParameter("day");
		String type = request.getParameter("type");
		String id = request.getParameter("id");
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd hh:mm");
		String sql = "SELECT a.lesson_time,b.experience,a.state,b.ADDR_NAME,b.PIC_URL,b.id as plan_id,a.id as plan_detail_id,a.week,b.PLAN_NAME,a.START_TIME,a.END_TIME,b.PT_ID from f_plan_detail a,f_plan b,f_plan_list c WHERE a.PLAN_LIST_ID = c.ID AND c.PLAN_ID = b.ID AND a.lesson_time = ? AND b.GYM=? and b.experience='N' ORDER BY a.START_TIME ASC";
		if ("tiYan".equals(type)) {
			sql = "SELECT a.lesson_time,b.experience,a.state,b.ADDR_NAME,b.PIC_URL,b.id as plan_id,a.id as plan_detail_id,a.week,b.PLAN_NAME,a.START_TIME,a.END_TIME,b.PT_ID from f_plan_detail a,f_plan b,f_plan_list c WHERE a.PLAN_LIST_ID = c.ID AND c.PLAN_ID = b.ID AND a.lesson_time = ? AND b.GYM=? and b.experience='Y' ORDER BY a.START_TIME ASC";
		}
		List<Map<String, Object>> list = new ArrayList<>();
		Entity en = new EntityImpl(this);
		int size = en.executeQuery(sql, new String[] { day, gym });
		if (size > 0) {
			list = en.getValues();
			list = getLessonList(list, gym, id, cust_name);
		}

		// 判断预约时间是否已经结束
		// 获取预约设置
		int endTime = -1;
		int startTime = -1;
		try {
			startTime = Integer.parseInt(SysSet.getValues(cust_name, gym, "set_plan_order", "startTime", this.getConnection())) * 60;
		} catch (Exception e) {
		}
		try {
			endTime = Integer.parseInt(SysSet.getValues(cust_name, gym, "set_plan_order", "endTime", this.getConnection()));
		} catch (Exception e) {
		}
		if (endTime != -1 && startTime != -1) {
			for (Map<String, Object> map : list) {
				String lesson_time = map.get("lesson_time") + " ";
				lesson_time += map.get("start_time") + "";
				Date startDate = format.parse(lesson_time);
				int minute = (int) (startDate.getTime() - new Date().getTime()) / (60 * 1000);
				if (minute > endTime && minute < startTime * 60) {
					map.put("isOrder", "Y");
				} else {
					map.put("isOrder", "N");
				}
			}
		} else if (endTime != -1 && startTime == -1) {
			for (Map<String, Object> map : list) {
				String lesson_time = map.get("lesson_time") + " ";
				lesson_time += map.get("start_time") + "";
				Date startDate = format.parse(lesson_time);
				int minute = (int) (startDate.getTime() - new Date().getTime()) / (60 * 1000);
				if (minute > endTime) {
					map.put("isOrder", "Y");
				} else {
					map.put("isOrder", "N");
				}
			}
		} else if (endTime == -1 && startTime != -1) {
			for (Map<String, Object> map : list) {
				String lesson_time = map.get("lesson_time") + " ";
				lesson_time += map.get("start_time") + "";
				Date startDate = format.parse(lesson_time);
				int minute = (int) (startDate.getTime() - new Date().getTime()) / (60 * 1000);
				if (minute < startTime) {
					map.put("isOrder", "Y");
				} else {
					map.put("isOrder", "N");
				}
			}
		} else {
			for (Map<String, Object> map : list) {
				map.put("isOrder", "Y");
			}
		}
		this.obj.put("list", list);

	}

	/**
	 * 显示课程详情
	 * 
	 * @Title: showLessonDetail
	 * @author: liul
	 * @date: 2017年8月1日下午3:11:34
	 * @throws Exception
	 */
	@Route(value = "fit-ws-app-showLessonDetail", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void showLessonDetail() throws Exception {
		String cust_name = request.getParameter("cust_name");
		String gym = request.getParameter("gym");
		String id = request.getParameter("id");
		String user_id = request.getParameter("mem_id");
		String sql = "SELECT b.card_names,a.state,b.pic1,b.pic2,b.pic3,b.experience,b.CONTENT,a.LESSON_TIME,a.state,b.ADDR_NAME,b.PIC_URL,b.id as plan_id,a.id as plan_detail_id,a.week,b.PLAN_NAME,a.START_TIME,a.END_TIME,b.PT_ID,b.start_num from f_plan_detail a,f_plan b,f_plan_list c WHERE a.PLAN_LIST_ID = c.ID AND c.PLAN_ID = b.ID AND a.id=?";
		List<Map<String, Object>> list = new ArrayList<>();
		List<Map<String, Object>> mem_list = new ArrayList<>();
		Entity en = new EntityImpl(this);
		Entity entity = new EntityImpl(this);
		int size = en.executeQuery(sql, new String[] { id });
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd hh:mm");
		if (size > 0) {
			list = en.getValues();
			String card_names = en.getStringValue("card_names");
			if(!Utils.isNull(card_names)){
				entity.executeQuery("select card_name from f_card where id = ?",new Object[]{card_names});
				list.get(0).put("card_name", entity.getStringValue("card_name"));
			}
			for (Map<String, Object> map : list) {
				String plan_detail_id = map.get("plan_detail_id") + "";
				size = en.executeQuery("select * from f_order_" + gym + " where plan_list_id=?", new String[] { plan_detail_id });
				if (size > 0) {
					// 拿到约课的会员id查到该会员的头像
					for (Map<String, Object> map2 : en.getValues()) {
						String mem_id = map2.get("mem_id") + "";
						String order_id = map2.get("id") + "";
						int size2 = entity.executeQuery("select a.id ,b.state as order_state,b.op_time from f_mem_" + cust_name + " a,f_order_" + gym + " b where a.id=b.mem_id and b.id=?", new String[] { order_id });
						if (size2 > 0) {
							List<Map<String, Object>> mm = entity.getValues();
							for (int x = 0; x < mm.size(); x++) {
								MemInfo memInfo = MemUtils.getMemInfo(entity.getStringValue("id", x), cust_name);
								if (memInfo != null) {
									mm.get(x).put("name", memInfo.getName());
									mm.get(x).put("phone", memInfo.getPhone());
									mm.get(x).put("headurl", memInfo.getWxHeadUrl());
								}

							}
							mem_list.addAll(mm);
							/*
							 * String aa = entity.getStringValue("id");
							 * //查看该会员是否约课 if
							 * (entity.getStringValue("id").equals(user_id)) {
							 * this.obj.put("order_state", "Y"); }
							 */
						}
					}
				}
			}
			list = getLessonList(list, gym, user_id, cust_name);
		}
		// 判断预约时间是否已经结束
		// 获取预约设置
		int endTime = -1;
		int startTime = -1;
		try {
			startTime = Integer.parseInt(SysSet.getValues(cust_name, gym, "set_plan_order", "startTime", this.getConnection())) * 60;
		} catch (Exception e) {
		}
		try {
			endTime = Integer.parseInt(SysSet.getValues(cust_name, gym, "set_plan_order", "endTime", this.getConnection()));
		} catch (Exception e) {
		}
		if (endTime != -1 && startTime != -1) {
			for (Map<String, Object> map : list) {
				String lesson_time = map.get("lesson_time") + " ";
				String lesson_time2 = map.get("lesson_time") + " ";
				lesson_time += map.get("start_time") + "";
				lesson_time2 += map.get("end_time") + "";
				Date startDate = format.parse(lesson_time);
				String endOrderTime = lesson_time2;
				map.put("endOrderTime", endOrderTime);
				int minute = (int) (startDate.getTime() - new Date().getTime()) / (60 * 1000);
				if (minute > endTime && minute < startTime * 60) {
					map.put("isOrder", "Y");

				} else {
					map.put("isOrder", "N");
				}
			}
		} else if (endTime != -1 && startTime == -1) {
			for (Map<String, Object> map : list) {
				String lesson_time = map.get("lesson_time") + " ";
				lesson_time += map.get("start_time") + "";
				Date startDate = format.parse(lesson_time);
				int minute = (int) (startDate.getTime() - new Date().getTime()) / (60 * 1000);
				if (minute > endTime) {
					map.put("isOrder", "Y");
				} else {
					map.put("isOrder", "N");
				}
			}
		} else if (endTime == -1 && startTime != -1) {
			for (Map<String, Object> map : list) {
				String lesson_time = map.get("lesson_time") + " ";
				lesson_time += map.get("start_time") + "";
				Date startDate = format.parse(lesson_time);
				int minute = (int) (startDate.getTime() - new Date().getTime()) / (60 * 1000);
				if (minute < startTime) {
					map.put("isOrder", "Y");
				} else {
					map.put("isOrder", "N");
				}
			}
		} else {
			for (Map<String, Object> map : list) {
				map.put("isOrder", "Y");
			}

		}
		this.obj.put("list", list);
		this.obj.put("mem_list", mem_list);

	}

	/**
	 * 获取团课排期
	 * 
	 * @Title: showRecommendLesson
	 * @author: liul
	 * @date: 2017年8月2日下午4:50:19
	 * @throws Exception
	 */
	@Route(value = "fit-ws-app-showRecommendLesson", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void showRecommendLesson() throws Exception {
		String cust_name = request.getParameter("cust_name");
		String gym = request.getParameter("gym");
		String id = request.getParameter("id");
		List<Map<String, Object>> list = new ArrayList<>();
		String sql = "SELECT a.lesson_time,b.experience,a.state,b.ADDR_NAME,b.PIC_URL,b.id as plan_id,a.id as plan_detail_id,a.week,b.PLAN_NAME,a.START_TIME,a.END_TIME,b.PT_ID from f_plan_detail a,f_plan b,f_plan_list c WHERE a.PLAN_LIST_ID = c.ID AND c.PLAN_ID = b.ID AND b.GYM=? AND b.ID=? AND a.LESSON_TIME>NOW() ORDER BY a.LESSON_TIME ASC";
		Entity en = new EntityImpl(this);
		int size = en.executeQuery(sql, new String[] { gym, id });
		if (size > 0) {
			list = en.getValues();
			list = getLessonList(list, gym, id, cust_name);
		}
		this.obj.put("list", list);
	}

	/**
	 * 预约团课
	 * 
	 * @Title: orderLesson
	 * @author: liul
	 * @date: 2017年8月1日下午4:16:55
	 * @throws Exception
	 */
	@Route(value = "fit-ws-app-orderLesson", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void orderLesson() throws Exception {
		String cust_name = request.getParameter("cust_name");
		String gym = request.getParameter("gym");
		String id = request.getParameter("id");
		String plan_detail_id = request.getParameter("plan_detail_id");
		String plan_id = request.getParameter("plan_id");
		Entity entity = new EntityImpl("f_plan", this);
		Entity orderPlan = new EntityImpl("f_order", this);
		// 潜客无法约课
		int size4 = entity.executeQuery("select * from f_mem_" + cust_name + " where id=? and state !='001'", new String[] { id });
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
				throw new Exception("课程结束，无法取预约");
			}
		}
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd hh:mm");
		boolean flag = false;
		// 判断预约时间是否已经结束
		// 获取预约设置
		int endTime = 0;
		int startTime = 0;
		String st = SysSet.getValues(cust_name, gym, "set_plan_order", "startTime", this.getConnection());
		String ed = SysSet.getValues(cust_name, gym, "set_plan_order", "endTime", this.getConnection());
		if (st == null || st.length() <= 0) {
			startTime = -1;
		} else {
			startTime = Integer.parseInt(SysSet.getValues(cust_name, gym, "set_plan_order", "startTime", this.getConnection())) * 60;
		}
		if (ed == null || ed.length() <= 0) {
			endTime = -1;
		} else {
			endTime = Integer.parseInt(SysSet.getValues(cust_name, gym, "set_plan_order", "endTime", this.getConnection()));
		}
		entity.executeQuery("select * from f_plan_detail where id=?", new String[] { plan_detail_id });

		String lesson_time = entity.getStringValue("lesson_time") + " ";
		lesson_time += entity.getStringValue("start_time");
		Date startDate = format.parse(lesson_time);
		int minute = (int) (startDate.getTime() - new Date().getTime()) / (60 * 1000);
		if (endTime != -1 && startTime != -1) {

			if (minute > endTime && minute < startTime * 60) {
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
				String order_id = orderPlan.getStringValue("id");
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
			// 拿到团课教练id
			String emp_id = entity.getStringValue("pt_id");
			String card_names = entity.getStringValue("card_names");
			int top_num = 0;
			if (!"".equals(entity.getStringValue("top_num"))) {
				top_num = Integer.parseInt(entity.getStringValue("top_num"));
			}
			// 已经预约多少人
			int mem_nums = entity.executeQuery("select * from f_order_" + gym + " where plan_list_id=? and state='001'", new String[] { plan_detail_id });
			if ("".equals(card_names)) {
				orderPlan = new EntityImpl("f_order", this);
				orderPlan.setTablename("f_order_" + gym);
				orderPlan.setValue("gym", gym);
				orderPlan.setValue("cust_name", cust_name);
				orderPlan.setValue("mem_id", id);
				orderPlan.setValue("start_time", new Date());
				orderPlan.setValue("op_time", new Date());
				orderPlan.setValue("state", "001");
				orderPlan.setValue("plan_id", plan_id);
				orderPlan.setValue("emp_id", emp_id);
				orderPlan.setValue("plan_list_id", plan_detail_id);
				orderPlan.setValue("mem_nums", mem_nums);
				orderPlan.create();
				int sizeUpdate = 0;
				// 如果没设置人数上限，则可以无限人数预约
				if (top_num > 0) {
					// 预约人数是否已达上限
					sizeUpdate = orderPlan.executeUpdate("update f_order_" + gym + " set mem_nums=mem_nums+1 where plan_list_id=? and mem_nums<=" + top_num, new String[] { plan_detail_id });
				} else {
					sizeUpdate = orderPlan.executeUpdate("update f_order_" + gym + " set mem_nums=mem_nums+1 where plan_list_id=? ", new String[] { plan_detail_id });
				}
				if (sizeUpdate > 0) {

				} else {
					throw new Exception("预约人数已满");
				}
			} else {
				// 查看会员是否有这张私教卡
				//int size = entity.executeQuery("SELECT b.id,b.DEADLINE,b.REMAIN_TIMES FROM f_mem_" + cust_name + " a,f_user_card_" + gym + " b,f_card c WHERE a.ID = b.MEM_ID AND c.id=b.card_id AND b.REMAIN_TIMES > 0 AND b.state = '001' AND b.DEADLINE >NOW() AND c.ID=? AND b.MEM_ID=?", new String[] { card_names, id });
				List<Map<String, Object>> cards = MemUtils.getAllMemCardsByCardId(card_names, id, cust_name, gym);
				if (cards.size() >0) {
					int num = 0;
					for (Map<String, Object> map : cards) {
						int remain_times = Utils.getMapIntegerValue(map, "remain_times");
						num += remain_times;
					}
					// 查看该用户私教卡次数是否用完
					//int updateSize = entity.executeQuery("select sum(REMAIN_TIMES) num from f_user_card_" + gym + " where card_id=? AND state = '001' and mem_id=? and DEADLINE > NOW() AND REMAIN_TIMES > 0", new String[] { card_names, id });
					if (num > 0) {
						//int num = entity.getIntegerValue("num");
						//查询已预约并需要该卡的数量
						int s = entity.executeQuery("select view_gym from f_card_gym where fk_card_id = ?",new Object[]{card_names});
						Entity xx = new EntityImpl(this);
						StringBuilder sql = new StringBuilder();
						List<String> params = new ArrayList<>();
						for(int i=0;i<s;i++){
							sql.append("select count(*) num from f_plan a,f_order_").append(entity.getStringValue("view_gym", i)).append(" b where a.id = b.plan_id and a.card_names = ? and b.mem_id =? and b.state='001'");
							params.add(card_names);
							params.add(id);
							if(i!=s-1){
								sql.append(" union all ");
							}
						}
						
						s = entity.executeQuery(sql.toString(),params.toArray());
						int hasOrderNum = 0;
						if(s > 0){
							for(int i =0;i<s;i++){
								hasOrderNum += entity.getIntegerValue("num", i);
							}
						}
						
						if(hasOrderNum >= num){
							throw new Exception("该私教卡剩余"+num+"次,您已预约了"+hasOrderNum+"节需要消耗此卡的团课,暂时不能约其他课了");
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
							sizeUpdate = orderPlan.executeUpdate("update f_order_" + gym + " set mem_nums=mem_nums+1 where plan_list_id=? and mem_nums<=" + top_num, new String[] { plan_detail_id });
						} else {
							sizeUpdate = orderPlan.executeUpdate("update f_order_" + gym + " set mem_nums=mem_nums+1 where plan_list_id=? ", new String[] { plan_detail_id });
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
					// 如果可以在app上购买，直接去购买该私教卡界面
					entity.executeQuery("select * from f_card where id=?", new String[] { card_names });
					String showApp = entity.getStringValue("show_app");
					if ("Y".equals(showApp)) {
						this.obj.put("temp", "N");
						this.obj.put("card", entity.getValues());
					} else {
						// 拿到该卡片名字
						entity.executeQuery("select * from f_card where id=?", new String[] { card_names });
						String cardName = entity.getStringValue("card_name");
						throw new Exception("预约改课需要" + cardName + "私教卡");
					}
				}
			}
		} else {
			throw new Exception("预约时间已截止");
		}

	}

	/**
	 * 体验预约
	 * 
	 * @Title: orderExperienceLesson
	 * @author: liul
	 * @date: 2017年8月2日上午11:27:56
	 * @throws Exception
	 */
	@Route(value = "fit-ws-app-orderExperienceLesson", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void orderExperienceLesson() throws Exception {
		String cust_name = request.getParameter("cust_name");
		String gym = request.getParameter("gym");
		String id = request.getParameter("id");
		String plan_detail_id = request.getParameter("plan_detail_id");
		String plan_id = request.getParameter("plan_id");
		Entity entity = new EntityImpl("f_plan", this);
		Entity orderPlan = new EntityImpl("f_order", this);
		// 该团课教练id
		entity.executeQuery("select * from f_plan where id=?", new String[] { plan_id });
		String emp_id = entity.getStringValue("pt_id");
		// 查询是否已经预约该课程
		orderPlan.setTablename("f_order_" + gym);
		orderPlan.setValue("mem_id", id);
		orderPlan.setValue("plan_list_id", plan_detail_id);
		int size2 = orderPlan.search();
		if (size2 > 0) {
			throw new Exception("您已预约该课程");
		}
		// 已经预约多少人
		int mem_nums = entity.executeQuery("select * from f_order_" + gym + " where plan_list_id=?", new String[] { plan_detail_id });
		orderPlan.setValue("gym", gym);
		orderPlan.setValue("cust_name", cust_name);
		orderPlan.setValue("mem_id", id);
		orderPlan.setValue("start_time", new Date());
		orderPlan.setValue("op_time", new Date());
		orderPlan.setValue("state", "001");
		orderPlan.setValue("plan_id", plan_id);
		orderPlan.setValue("emp_id", emp_id);
		orderPlan.setValue("plan_list_id", plan_detail_id);
		orderPlan.setValue("mem_nums", mem_nums);
		orderPlan.create();
		entity.executeUpdate("update f_order_" + gym + " set mem_nums=mem_nums+1 where plan_list_id=?", new String[] { plan_detail_id });

	}

	/**
	 * 获取课程预约人数和教练名字
	 * 
	 * @Title: getLessonList
	 * @author: liul
	 * @date: 2017年8月1日下午3:04:26
	 * @param list
	 * @param gym
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> getLessonList(List<Map<String, Object>> list, String gym, String id, String cust_name) throws Exception {
		Entity entity = new EntityImpl(this);
		Entity en = new EntityImpl(this);
		for (Map<String, Object> map : list) {

			String pt_id = map.get("pt_id") + "";
			String plan_detail_id = map.get("plan_detail_id") + "";// 根据id查看约课情况
			int mem_nums = entity.executeQuery("select * from f_order_" + gym + " where plan_list_id=? and state='001'", new String[] { plan_detail_id });
			if (mem_nums > 0) {
				// 查看改会员是否预约改课
				String mem_id = entity.getStringValue("mem_id");
				if (mem_id.equals(id)) {
					map.put("isCanOrder", "Y");
					map.put("order_state", entity.getStringValue("state"));
				} else {
					map.put("isCanOrder", "N");
				}
			} else {
				map.put("isCanOrder", "N");
			}
			String plan_id = map.get("plan_id") + "";// 查看该团课约课上限
			map.put("mem_nums", mem_nums);
			int size2 = entity.executeQuery("select top_num from f_plan where id=?", new String[] { plan_id });
			String top_num = "";
			if (size2 > 0) {
				top_num = entity.getStringValue("top_num");
			} else {

				top_num = entity.getStringValue("top_num");
			}
			map.put("top_num", top_num);
			if (pt_id.equals("1")) {
				map.put("name", "未选择教练");
			} else {
				int size = en.executeQuery("select c.mem_name name,b.headurl,a.id from f_emp a,f_wx_cust_" + cust_name + " b,f_mem_" + cust_name + " c WHERE c.WX_OPEN_ID = b.WX_OPEN_ID and a.id=c.id AND a.ID=?", new String[] { pt_id });
				if (size > 0) {
					map.put("name", MemUtils.getMemInfo(en.getStringValue("id"), cust_name).getName());
					map.put("headurl", MemUtils.getMemInfo(en.getStringValue("id"), cust_name).getWxHeadUrl());
				} else {
					map.put("name", "-");

				}
			}
		}

		return list;
	}
}
