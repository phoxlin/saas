package com.mingsokj.fitapp.ws.app.pt;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.alibaba.fastjson.JSONObject;
import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.log.Logger;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.utils.MemUtils;
import com.mingsokj.fitapp.utils.MsgUtils;

/**
 * @author liul 2017年8月4日下午3:17:13
 */
public class 团操课 extends BasicAction {

	@Route(value = "/fit-ws-app-pt-showPtLesson", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void showPtLesson() throws Exception {
		String cust_name = request.getParameter("cust_name");
		String gym = request.getParameter("gym");
		String id = request.getParameter("id");
		String type = request.getParameter("type");
		String day = request.getParameter("day");
		String sql = "SELECT b.addr_name,b.experience,b.PIC_URL,a.ID as plan_detail_id,b.id as plan_id,b.PLAN_NAME,a.START_TIME,a.END_TIME,b.PT_ID,b.start_num from f_plan_detail a,f_plan b,f_plan_list c WHERE a.PLAN_LIST_ID = c.ID AND c.PLAN_ID = b.ID AND a.lesson_time = ? AND b.PT_ID=? AND b.GYM=? ORDER BY a.START_TIME ASC";
		Entity en = new EntityImpl(this);
		Entity entity = new EntityImpl(this);
		List<Map<String, Object>> list = new ArrayList<>();
		SimpleDateFormat format2 = new SimpleDateFormat("HH:mm");
		int size = en.executeQuery(sql, new String[] { day, id,gym });
		if (size > 0) {
			list = en.getValues();
			for (Map<String, Object> map : list) {
				map.put("type", type);
				// 计算课程总上共多少分钟
				String start = map.get("start_time") + "";
				String end = map.get("end_time") + "";
				Date startDate = format2.parse(start);
				Date endDate = format2.parse(end);
				int minute = (int) ((endDate.getTime() - startDate.getTime()) / (60 * 1000));
				map.put("minute", minute);
				String pt_id = map.get("pt_id") + "";
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
					MemInfo info = MemUtils.getMemInfo(pt_id, cust_name, L);
					if (info != null) {
						map.put("name", info.getName());
						map.put("headurl", info.getWxHeadUrl());

					}
				}
			}
		}
		this.obj.put("list", list);
	}

	/**
	 * 团课上课，下课
	 * 
	 * @Title: attendClass
	 * @author: liul
	 * @date: 2017年8月7日上午10:28:01
	 * @throws Exception
	 */
	@Route(value = "/fit-ws-app-pt-attendClass", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void attendClass() throws Exception {
		String gym = request.getParameter("gym");
		String cust_name = request.getParameter("cust_name");
		L.info("custr_name:"+cust_name); 
		Logger.info("custr_name:"+cust_name); 
		String id = request.getParameter("id");
		String state = request.getParameter("state");
		String plan_id = request.getParameter("plan_id");
		Entity en = new EntityImpl("f_plan_detail", this);
		Entity entity = new EntityImpl("f_plan", this);
		Entity record = new EntityImpl("f_class_record", this);
		List<Map<String, Object>> list = new ArrayList<>();
		List<Map<String, Object>> mem_list = new ArrayList<>();
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		// 查看预约人数是否达到最低开课人数要求
		entity.setValue("id", plan_id);
		entity.search();
		String pt_id = entity.getStringValue("pt_id");
		int start_num = entity.getIntegerValue("start_num");
		String experience = entity.getStringValue("experience");
		// 查看该课程预约的人数
		
		String sql="select * from f_order_" + gym + " a, f_mem_"+cust_name+" b where a.mem_id=b.id and a.plan_list_id=? and a.state='001'";
		L.info(sql);
		int mem_nums = entity.executeQuery(sql, new String[] { id });

		// 查看是否是体验课
		if ("N".equals(experience) || "".equals(experience) || experience == null) {
			if (start_num > 0) {

				if (mem_nums >= start_num) {
					list.addAll(entity.getValues()) ;
					if ("001".equals(state)) {// 未上课，修改为正在上课的状态
						en.setValue("id", id);
						en.setValue("state", "003");
						en.update();
						// 将信息添加到团课记录表中
						record.setTablename("f_class_record_" + gym);
						record.setValue("cust_name", cust_name);
						record.setValue("gym", gym);
						record.setValue("pt_id", pt_id);
						record.setValue("plan_detail_id", id);
						record.setValue("state", "001");
						record.setValue("mem_nums", mem_nums);
						record.setValue("start_time", new Date());
						record.setValue("plan_id", plan_id);
						record.create();
						// 查询该课程需不需要扣次
						en.executeQuery("select * from f_plan where id=?", new String[] { plan_id });
						String is_free = en.getStringValue("is_free");
						String card_names = en.getStringValue("card_names");
						// 如果绑卡并扣次，则扣去会员相应卡的次数
						if ("Y".equals(is_free) && !"".equals(card_names)) {
							// 查询到预约该课程的会员进行扣次
							if (mem_nums > 0) {
								for (int i = 0; i < list.size(); i++) {
									String mem_id = list.get(i).get("mem_id") + "";
									String phone = MemUtils.getMemInfo(mem_id, cust_name).getPhone();
									String name = MemUtils.getMemInfo(mem_id, cust_name).getName();
									//获取购卡信息id
									int updateSize = 0;
									
									/*Entity getUserCardId = new EntityImpl("f_user_card",this);
									int size2 = getUserCardId.executeQuery("select * from f_user_card_"+gym+" where mem_id=? and card_names=?",new String[]{mem_id,card_names});
									if (size2 > 0) {
										for (int j = 0; j < size2; j++) {
											String user_card_id = getUserCardId.getStringValue("id",j);
											updateSize = entity.executeUpdate("update f_user_card_" + gym + " set remain_times=remain_times-1 where id=? and remain_times > 0 ", new String[] {user_card_id });
											if (updateSize > 0) {
												break;
											}
										}
									}*/
									String now_gym = "";
									int times = 0;
									List<Map<String, Object>> cards = MemUtils.getAllMemCardsByCardId(card_names, mem_id, cust_name, gym);
									if(cards.size() >0){
										for (Map<String, Object> map : cards) {
											int remain_times = Utils.getMapIntegerValue(map, "remain_times");
											now_gym = Utils.getMapStringValue(map, "now_gym");
											if(remain_times >0){
												times = remain_times - 1;
												if(remain_times == 1){
													updateSize = entity.executeUpdate("update f_user_card_" + now_gym + " set remain_times=remain_times-1,state='009' where id=?", new String[] {Utils.getMapStringValue(map, "id") });
												}else{
													updateSize = entity.executeUpdate("update f_user_card_" + now_gym + " set remain_times=remain_times-1 where id=?", new String[] {Utils.getMapStringValue(map, "id") });
												}
												break;
											}
										}
									}
									if (updateSize > 0) {
										// 扣次成功，发送消息
										Entity getCard = new EntityImpl(this);
										int size = getCard.executeQuery("SELECT * FROM f_card a ,f_user_card_"+now_gym+" b WHERE a.id=b.CARD_ID AND b.CARD_ID=? AND b.MEM_ID=?", new String[]{card_names,mem_id});
										String cardName = "";
										if (size > 0) {
											cardName = getCard.getStringValue("card_name");
										}
										//String content = "私教卡:"+getCard.getStringValue("card_name")+"成功扣次,剩余次数"+getCard.getStringValue("remain_times");
										JSONObject obj = new JSONObject();
										obj.put("name", name);
										obj.put("cardName", cardName);
										obj.put("times", times);
										MsgUtils.sendPhoneMsg(cust_name, gym, "团课扣次", phone, obj.toString(), this.getConnection(),"lesson");
									} else {
										// 扣次失败，给予教练提示该会员卡次数不够，并且依然扣去该私教卡的次数，次数变为负数
										entity.executeUpdate("update f_user_card_" + gym + " set remain_times=remain_times-1 where mem_id=? and card_id=? ", new String[] { mem_id, card_names });
										// 拿到该会员的信息
										entity.executeQuery("select * from f_mem_" + cust_name + " where id=?", new String[] { mem_id });
										mem_list.addAll(entity.getValues());
									}
									this.obj.put("mem_list", mem_list);
								}
							}
						} else {
							// 否则则不扣次
						}
					}
					// 下课
					else if ("003".equals(state)) {
						en.setValue("id", id);
						en.setValue("state", "002");
						en.update();
						// 更新记录表信息
						record.executeUpdate("update f_class_record_" + gym + "  set end_time=?,state='002' where plan_detail_id=?", new String[] { format.format(new Date()), id });
					}
				} else {
					throw new Exception("预约人数未达到开课人数");
				}
			}
			// 随便多少人都可以开课
			else {
				// 至少有一个会员就可以开课
				if (mem_nums > 0) {
					list.addAll(entity.getValues()) ;
					if ("001".equals(state)) {// 未上课，修改为正在上课的状态
						en.setValue("id", id);
						en.setValue("state", "003");
						en.update();
						// 将信息添加到团课记录表中
						record.setTablename("f_class_record_" + gym);
						record.setValue("cust_name", cust_name);
						record.setValue("gym", gym);
						record.setValue("pt_id", pt_id);
						record.setValue("plan_detail_id", id);
						record.setValue("state", "001");
						record.setValue("mem_nums", mem_nums);
						record.setValue("start_time", new Date());
						record.setValue("plan_id", plan_id);
						record.create();
						// 查询该课程需不需要扣次
						en.executeQuery("select * from f_plan where id=?", new String[] { plan_id });
						String is_free = en.getStringValue("is_free");
						String card_names = en.getStringValue("card_names");
						// 如果绑卡并扣次，则扣去会员相应卡的次数
						if ("Y".equals(is_free) && !"".equals(card_names)) {
							// 查询到预约该课程的会员进行扣次
							if (mem_nums > 0) {
								for (int i = 0; i < list.size(); i++) {
									String mem_id = list.get(i).get("mem_id") + "";
									String phone = MemUtils.getMemInfo(mem_id, cust_name).getPhone();
									String name = MemUtils.getMemInfo(mem_id, cust_name).getName();
									//获取购卡信息id
									int updateSize = 0;
									/*Entity getUserCardId = new EntityImpl("f_user_card",this);
									int size2 = getUserCardId.executeQuery("select * from f_user_card_"+gym+" where mem_id=? and card_id=?",new String[]{mem_id,card_names});
									if (size2 > 0) {
										for (int j = 0; j < size2; j++) {
											String user_card_id = getUserCardId.getStringValue("id",j);
											updateSize = entity.executeUpdate("update f_user_card_" + gym + " set remain_times=remain_times-1 where id=? and remain_times > 0 ", new String[] {user_card_id });
											if (updateSize > 0) {
												break;
											}
										}
									}*/
									String now_gym = "";
									int times = 0;
									List<Map<String, Object>> cards = MemUtils.getAllMemCardsByCardId(card_names, mem_id, cust_name, gym);
									if(cards.size() >0){
										for (Map<String, Object> map : cards) {
											int remain_times = Utils.getMapIntegerValue(map, "remain_times");
											now_gym = Utils.getMapStringValue(map, "now_gym");
											if(remain_times >0){
												times = remain_times - 1;
												if(remain_times == 1){
													updateSize = entity.executeUpdate("update f_user_card_" + now_gym + " set remain_times=remain_times-1,state='009' where id=?", new String[] {Utils.getMapStringValue(map, "id") });
												}else{
													updateSize = entity.executeUpdate("update f_user_card_" + now_gym + " set remain_times=remain_times-1 where id=?", new String[] {Utils.getMapStringValue(map, "id") });
												}
												break;
											}
										}
									}
									if (updateSize > 0) {
										// 扣次成功，发送消息
										Entity getCard = new EntityImpl(this);
										int size = getCard.executeQuery("SELECT * FROM f_card a ,f_user_card_"+now_gym+" b WHERE a.id=b.CARD_ID AND b.CARD_ID=? AND b.MEM_ID=?", new String[]{card_names,mem_id});
										String cardName = "";
										if (size > 0) {
											cardName = getCard.getStringValue("card_name");
										}
										//String content = "私教卡:"+getCard.getStringValue("card_name")+"成功扣次,剩余次数"+getCard.getStringValue("remain_times");
										JSONObject obj = new JSONObject();
										obj.put("name", name);
										obj.put("cardName", cardName);
										obj.put("times", times);
										MsgUtils.sendPhoneMsg(cust_name, gym, "团课扣次", phone, obj.toString(), this.getConnection(),"lesson");
									} else {
										// 扣次失败，给予教练提示该会员卡次数不够，并且依然扣去该私教卡的次数，次数变为负数
										entity.executeUpdate("update f_user_card_" + gym + " set remain_times=remain_times-1 where mem_id=? and card_id=? ", new String[] { mem_id, card_names });
										// 拿到该会员的信息
										entity.executeQuery("select * from f_mem_" + cust_name + " where id=?", new String[] { mem_id });
										mem_list.addAll(entity.getValues());
									}
									this.obj.put("mem_list", mem_list);
								}
							}
						} else {
							// 否则则不扣次
						}
					}
					// 下课
					else if ("003".equals(state)) {
						en.setValue("id", id);
						en.setValue("state", "002");
						en.update();
						// 更新记录表信息
						record.executeUpdate("update f_class_record_" + gym + "  set end_time=?,state='002' where plan_detail_id=?", new String[] { format.format(new Date()), id });
					}
				}
				// 否则提示人数为0，不能开课
				else {
					throw new Exception("人数为0，开课失败");
				}
			}
		} else {
			if ("001".equals(state)) {// 未上课，修改为正在上课的状态
				en.setValue("id", id);
				en.setValue("state", "003");
				en.update();
				// 将信息添加到团课记录表中
				record.setTablename("f_class_record_" + gym);
				record.setValue("cust_name", cust_name);
				record.setValue("gym", gym);
				record.setValue("pt_id", pt_id);
				record.setValue("plan_detail_id", id);
				record.setValue("state", "001");
				record.setValue("mem_nums", mem_nums);
				record.setValue("plan_id", plan_id);
				record.setValue("start_time", new Date());
				record.create();
			} // 下课
			else if ("003".equals(state)) {
				en.setValue("id", id);
				en.setValue("state", "002");
				en.update();
				// 更新记录表信息
				record.executeUpdate("update f_class_record_" + gym + "  set end_time=?,state='002' where plan_detail_id=?", new String[] { format.format(new Date()), id });
			}
		}
	}

}
