package com.mingsokj.fitapp.ws.app.pt;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.json.JSONArray;

import com.alibaba.fastjson.JSONObject;
import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.SystemUtils;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.m.FitUser;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.utils.MemUtils;
import com.mingsokj.fitapp.utils.MsgUtils;

public class 消课 extends BasicAction {

	/**
	 * 消课前查询
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-app-action-pt-reduce-class-query", conn = true,  m = HttpMethod.POST, type = ContentType.JSON)
	public void reduce_class_query() throws Exception {
		// 会员购卡信息
		String buy_id = request.getParameter("buy_id");// 购卡ID
		String mem_gym = request.getParameter("mem_gym");// 会员会所
//		String cust_name = request.getParameter("cust_name");
		String emp_gym = request.getParameter("emp_gym");
//		String emp_id = request.getParameter("emp_id");
//		String emp_name = request.getParameter("emp_name");

		if(!emp_gym.equals(mem_gym)){
			throw new Exception("请在同一会所操作消课");
		}
		
		Entity en = new EntityImpl("f_user_card", this);
		int s = en.executeQuery("select a.mem_id,a.remain_times,b.id card_id,b.card_type ,b.card_name from f_user_card_" + mem_gym + " a,f_card b where a.id = ? and a.card_id =b.id", new Object[] { buy_id });
		if (s == 0) {
			throw new Exception("不存在的会员卡");
		}
		String mem_id = en.getStringValue("mem_id");
//		String card_id = en.getStringValue("card_id");
		String card_type = en.getStringValue("card_type");
//		String card_name = en.getStringValue("card_name");
		Integer remain_times = en.getIntegerValue("remain_times");

		if (!"006".equals(card_type)) {
			throw new Exception("私教只能给私教卡消课");
		}
		if (remain_times == null || remain_times == 0) {
			throw new Exception("会员卡剩余次数为0,不能上课哦");
		}

		// 消课设置 按照员工所在的会所查询

		// 查询是否有上课 只需要一条记录
		en = new EntityImpl("f_private_record", this);
		s = en.executeQuery("select * from f_private_record_" + mem_gym + " where mem_id = ? and user_card_id = ? order by op_time desc limit 0,1", new Object[] { mem_id, buy_id });

		String record_id = en.getStringValue("id");

		String state = "end";
		if (s != 0) {
			this.obj.put("record_id", record_id);
			state = en.getStringValue("state");
		}

		this.obj.put("state", state);
	}

	/**
	 * 消课主页信息
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-ws-app-pt-showInit-data", conn = true,  m = HttpMethod.POST, type = ContentType.JSON)
	public void reduce_index() throws Exception {
//		String cust_name = request.getParameter("cust_name");
		String emp_gym = request.getParameter("gym");
		String emp_id = request.getParameter("emp_id");

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

		Entity en = new EntityImpl(this);
		Date now = new Date();
		// 今日消课
		int s = en.executeQuery("select count(id) count from f_private_record_" + emp_gym + " where state = 'end' and pt_id = ? and op_time >= ?", new Object[] { emp_id, sdf.format(now) + " 00:00:00" });
		this.obj.put("today_reduce_class", en.getStringValue("count"));
		// 私课销售
		sdf = new SimpleDateFormat("yyyy-MM");
		s = en.executeQuery("select count(a.id) count from f_user_card_" + emp_gym + " a,f_card b where a.card_id = b.id and b.card_type='006' and a.pt_id = ? and a.pay_time >= ?", new Object[] { emp_id, sdf.format(now) + "-01 00:00:00" });
		this.obj.put("today_sales_private_class", en.getStringValue("count"));
		/**
		 * 维护次数
		 */
		en = new EntityImpl(this);
		s = en.executeQuery(
				"select id from f_mem_maintain_" + emp_gym
						+ " where  DATE_FORMAT( op_time, '%Y%m' ) = DATE_FORMAT( CURDATE( ) , '%Y%m' ) and ( type='pt' or type='qpt') and op_id=?",
				new Object[] { emp_id });
		this.obj.put("mSize", s);
	}

	/**
	 * 消课第三方确认
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-ws-bg-reduceClassConfirm", conn = true,  m = HttpMethod.POST, type = ContentType.JSON)
	public void reduceClassConfirm() throws Exception {
		FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
		String table = request.getParameter("data_table_name");
		String id = request.getParameter("data_id");
//		String msg_id = request.getParameter("msg_id");
		String cust_name = user.getCust_name();
		Entity en = new EntityImpl("f_private_record", this);
		Date now = new Date();
		en.setTablename(table);
		en.setValue("id", id);
		int s = en.search();
		String user_card_id  = en.getStringValue("user_card_id");
		String gym  = en.getStringValue("gym");
		String mem_id = "";
		if (s > 0) {
			mem_id = en.getStringValue("mem_id");
			String state = en.getStringValue("state");
			if ("end".equals(state)) {
					throw new Exception("已经结束上课了,请不要重复操作");
			}
//			String pt_id = en.getStringValue("pt_id");

			en.setValue("id", id);
			en.setValue("op_id", user.getId());
			en.setValue("op_time", now);
			en.setValue("state", "end");
			en.setValue("end_time", now);
			en.update();

			en.executeUpdate("update f_msg_rec set state = 'READ',receiver_id = ? where data_id =?", new Object[] { user.getId(), id });
			
			//消次
			en = new EntityImpl("f_user_card", this);
			s = en.executeQuery("select remain_times from f_user_card_" + gym +" where id = ?",new Object[]{user_card_id});
			if(s ==0){
				throw new Exception("不存在的会员卡");
			}
			int remain_times = en.getIntegerValue("remain_times");
			if(remain_times == 0){
				//需要通知教练
				throw new Exception("该私教卡次数不足,无法完成消课");
			}
			en.executeUpdate("update f_user_card_" +gym +" set remain_times=remain_times-1 where id = ?", new Object[]{user_card_id});
			//扣次成功，发送短信
			// 扣次成功，发送消息
			Entity getCard = new EntityImpl(this);
			String phone = MemUtils.getMemInfo(mem_id, cust_name).getPhone(); 
			String name = MemUtils.getMemInfo(mem_id, cust_name).getName(); 
			int size = getCard.executeQuery("SELECT * FROM f_card a ,f_user_card_"+gym+" b WHERE a.id=b.CARD_ID AND b.id=?", new String[]{user_card_id});
			String cardName = "";
			String times = "";
			if (size > 0) {
				cardName = getCard.getStringValue("card_name");
				times = getCard.getStringValue("remain_times");
			}
			//String content = "私教卡"+getCard.getStringValue("card_name")+"成功扣次,剩余次数"+getCard.getStringValue("remain_times");
			JSONObject obj = new JSONObject();
			obj.put("name", name);
			obj.put("cardName", cardName);
			obj.put("times", times);
			MsgUtils.sendPhoneMsg(cust_name, gym, "私课扣次", phone, obj.toString(), this.getConnection(),"lesson");
			/*// 查询有没有发送消息
			en = new EntityImpl("f_msg_rec", this);

			en.setValue("cust_name", user.getMem().getCust_name());
			en.setValue("gym", user.getMem().getGym正在查看的门店信息().gym);
			en.setValue("msg_type", "mem_reduce_lesson_confirm");
			en.setValue("msg_content", "下课成功");
			en.setValue("create_time", now);
			en.setValue("send_time", now);
			en.setValue("sender_id", user.getId());
			en.setValue("receiver_id", pt_id);
			en.setValue("state", "SEND");
			en.create();*/
			// 发送给教练开始上课的消息
		} else {
			throw new Exception("无效的上课请求");
		}

		// 通知教练开始上课?
	}

	/**
	 * 消课
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-app-action-pt-reduce-class", conn = true,  m = HttpMethod.POST, type = ContentType.JSON)
	public void reduce_class() throws Exception {
		String record_id = request.getParameter("private_record_id");
		String type = request.getParameter("type");
		String buy_id = request.getParameter("buy_id");

		String cust_name = request.getParameter("cust_name");
		String mem_gym = request.getParameter("mem_gym");// 会员会所
		String empGym = request.getParameter("empGym");
		String mem_id = "";
		String emp_id = request.getParameter("emp_id");
		
		if(!empGym.equals(mem_gym)){
			throw new Exception("请在同一会所操作消课");
		}
		
		Entity en = new EntityImpl("f_user_card", this);
		int s = en.executeQuery("select a.mem_id,a.remain_times,b.id card_id,b.card_type ,b.card_name from f_user_card_" + mem_gym + " a,f_card b where a.id = ? and a.card_id =b.id", new Object[] { buy_id });
		if (s == 0) {
			throw new Exception("不存在的会员卡");
		}
		mem_id = en.getStringValue("mem_id");
		String card_id = en.getStringValue("card_id");
//		String card_type = en.getStringValue("card_type");
		String card_name = en.getStringValue("card_name");
		Integer remain_times = en.getIntegerValue("remain_times");
		
		
		Date now = new Date();
		
		if ("start".equals(type)) {
			if(remain_times <=0){
				throw new Exception("该会员卡次数不足,不能开课");
			}
			// 查询是否正在上课
			en = new EntityImpl("f_private_record",this);
			s = en.executeQuery("select * from f_private_record_" +mem_gym +" where user_card_id = ? and state != 'end'",new Object[]{buy_id});
			if(s >0){
				throw new Exception("该学员的课程还没有结课,请不要重复操作噢.");
			}
			// 生成上课记录
			en.setTablename("f_private_record_" + mem_gym);
			en.setValue("cust_name", cust_name);
			en.setValue("gym", empGym);
			en.setValue("mem_id", mem_id);
			en.setValue("pt_id", emp_id);
			en.setValue("op_time", now);
			en.setValue("card_id", card_id);
			en.setValue("user_card_id", buy_id);
			en.setValue("state", "start");
			en.setValue("start_time", now);
			en.create();
			
		} else if ("end".equals(type)) {

			en = new EntityImpl("f_private_record", this);
			en.setTablename("f_private_record_" + mem_gym);
			en.setValue("id", record_id);
			s = en.search();
			String state = en.getStringValue("state");
			if("end".equals(state)){
				throw new Exception("上课记录已经完结,无需操作");
			}
			Entity param = new EntityImpl("f_param", this);
			s = param.executeQuery("select * from f_param where cust_name = ? and gym = ? and code='private_class'", new Object[] { cust_name, empGym });
			int checkType = 2;
			if (s >0) {
				JSONArray note = new JSONArray(param.getStringValue("note"));
				checkType = note.getJSONObject(0).getInt("checkType");
				// 上课时间
//				String startTime = note.getJSONObject(0).getString("startTime");
//				String endTime = note.getJSONObject(0).getString("endTime");
			}


			if (checkType == 3) {
				//现在用查询 之后可以用传递
				MemInfo m = MemUtils.getMemInfo(mem_id, cust_name);
				MemInfo emp = MemUtils.getMemInfo(emp_id, cust_name);
				String msg_content = "教练【" + emp.getName() + "】请求下课,课程【" + card_name + "】所属会员【" + m.getName() + "】";
				en = new EntityImpl("f_msg_rec", this);
				en.setValue("cust_name", cust_name);
				en.setValue("gym", empGym);
				en.setValue("msg_type", "mem_reduce_lesson");
				en.setValue("msg_content", msg_content);
				en.setValue("sender_id", emp_id);
				en.setValue("receiver_id", "OP");
				en.setValue("data_table_name", "f_private_record_" + mem_gym);
				en.setValue("data_id", record_id);
				en.setValue("create_time", new Date());
				en.setValue("send_time", new Date());
				en.setValue("state", "SEND");
				en.create();
				this.obj.put("wait", "Y");
			} else {
				//直接消课 上课时查询了剩余次数的 就不查了吧
				en.executeUpdate("update f_user_card_"+mem_gym+" set remain_times = remain_times -1 where id = ?",new Object[]{buy_id});
				en.executeUpdate("update f_private_record_"+mem_gym+" set end_time = ?,state ='end' where id = ?",new Object[]{now,record_id});
				// 扣次成功，发送消息
				Entity getCard = new EntityImpl(this);
				String phone = MemUtils.getMemInfo(mem_id, cust_name).getPhone();
				String name = MemUtils.getMemInfo(mem_id, cust_name).getName();
				int size = getCard.executeQuery("SELECT * FROM f_card a ,f_user_card_"+mem_gym+" b WHERE a.id=b.CARD_ID AND b.id=?", new String[]{buy_id});
				String cardName = "";
				String times = "";
				if (size > 0) {
					cardName = getCard.getStringValue("card_name");
					times = getCard.getStringValue("remain_times");
				}
				//String content = "私教卡"+getCard.getStringValue("card_name")+"成功扣次,剩余次数"+getCard.getStringValue("remain_times");
				JSONObject obj = new JSONObject();
				obj.put("name", name);
				obj.put("cardName", cardName);
				obj.put("times", times);
				MsgUtils.sendPhoneMsg(cust_name, mem_gym, "私课扣次", phone, obj.toString(), this.getConnection(),"lesson");
			}

			en.setValue("state", "end");
			en.setValue("end_time", new Date());
			en.update();
			// 扣次
			/*
			 * Entity user_card = new EntityImpl("f_user_card", this);
			 * user_card.setTablename("f_user_card_" + mem_gym);
			 * user_card.setValue("id", buy_id); int s = user_card.search(); if
			 * (s > 0) { Integer times =
			 * user_card.getIntegerValue("remain_times"); if (times == null ||
			 * times == 0) { throw new Exception("该会员卡已经没有次数了"); } user_card.
			 * executeUpdate("update f_user_card set remain_times = remain_times - 1 where id = ?"
			 * , new Object[] { buy_id }); }
			 */
		} else if ("delete".equals(type)) {
			en.delete();
		}

	}

	/**
	 * 消课状态
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-ws-app-pt-getReduceClassRecord", conn = true,  m = HttpMethod.POST, type = ContentType.JSON)
	public void reduce_class_record() throws Exception {
		String cust_name = request.getParameter("cust_name");
		String emp_gym = request.getParameter("emp_gym");
		String emp_id = request.getParameter("emp_id");
		String type = request.getParameter("type");
		String typePlan = request.getParameter("typePlan");
		String condition = request.getParameter("condition");
		String conditionData = request.getParameter("conditionData");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

		
		Entity en = new EntityImpl(this);
		//String sql = "select a.*,b.card_name,d.headurl from f_private_record_" + emp_gym + " a,f_card b,f_mem_"+emp_gym+" c,f_wx_cust_"+emp_gym+" d where  a.pt_id = ? and a.state = ? and a.card_id = b.id and a.mem_id = c.id and c.wx_open_id = d.wx_open_id";
		String sql = "select a.*,b.card_name,d.headurl,d.nickname from f_private_record_" + emp_gym + " a left join f_card b on a.card_id = b.id left join f_mem_"+cust_name+" c on a.mem_id = c.id left join f_wx_cust_"+cust_name+" d on c.wx_open_id = d.wx_open_id where  a.pt_id = ? and a.state = ? ";
		if ("planClass".equals(typePlan)) {
			String first_day = conditionData + "-01 00:00:00";

			Calendar cDay = Calendar.getInstance();
			cDay.setTime(sdf.parse(conditionData + "-01"));
			cDay.set(Calendar.DAY_OF_MONTH, cDay.getActualMaximum(Calendar.DAY_OF_MONTH));
			String last_day = sdf.format(cDay.getTime()) + " 23:59:59";
			this.obj.put("list", getOrderRecord(emp_id, first_day, last_day, emp_gym,cust_name));
		} else {
			if ("month".equals(condition) && !"所有月份".equals(conditionData)) {
				String first_day = conditionData + "-01 00:00:00";

				Calendar cDay = Calendar.getInstance();
				cDay.setTime(sdf.parse(conditionData + "-01"));
				cDay.set(Calendar.DAY_OF_MONTH, cDay.getActualMaximum(Calendar.DAY_OF_MONTH));
				String last_day = sdf.format(cDay.getTime()) + " 23:59:59";

				sql += " and a.op_time between '" + first_day + "' and '" + last_day + "'";

			}
			if ("card".equals(condition) && !"all".equals(conditionData)) {
				sql += " and card_id = '" + conditionData + "'";
			}
			if ("day".equals(condition)) {
				String strat = conditionData + " 00:00:00";
				String end = conditionData + " 23:59:59";
				sql += " and a.op_time between '" + strat + "' and '" + end + "'";
			}
			sql += "  order by op_time desc";
			int s = en.executeQuery(sql, new Object[] { emp_id, type });
			if (s > 0) {
				Map<String, List<String>> mem = new HashMap<>();
				Set<String> gyms = new HashSet<>();
				for (int i = 0; i < s; i++) {
					gyms.add(en.getStringValue("gym", i));
					List<String> mems = mem.get(en.getStringValue("gym", i));
					if (mems == null) {
						mems = new ArrayList<>();
					}
					mems.add(en.getStringValue("mem_id", i));
					mem.put(en.getStringValue("gym", i), mems);
				}

				StringBuilder sb = new StringBuilder();
				int ii = 0;
				List<String> params = new ArrayList<>();
				for (String g : gyms) {
					sb.append("select id,mem_name,gym from f_mem_" + cust_name + " where id in(" + Utils.getListString("?", mem.get(g).size()) + ")");
					params.addAll(mem.get(g));
					if (ii != gyms.size() - 1) {
						sb.append(" union all ");
					}
				}
				Entity m = new EntityImpl(this);
				int x = m.executeQuery(sb.toString(), params.toArray());
				for (int i = 0; i < s; i++) {
					for (int j = 0; j < x; j++) {
						if (en.getStringValue("mem_id", i).equals(m.getStringValue("id", j))) {
							
							MemInfo mm = MemUtils.getMemInfo(m.getStringValue("id", j), cust_name);
							if(mm !=null){
								en.getValues().get(i).put("mem_name",mm.getName());
							}
							break;
						}
					}
				}
				if ("mem_name".equals(condition)) {
					List<Map<String, Object>> list = new ArrayList<>();
					for (int i = 0; i < en.getValues().size(); i++) {
						if (en.getStringValue("mem_name", i).contains((conditionData))) {
							list.add(en.getValues().get(i));
						}
					}
					this.obj.put("list", list);
				} else {
					this.obj.put("list", en.getValues());
				}
			}
			if ("Y".equals(request.getParameter("init"))) {
				// 查卡种
				s = en.executeQuery("select id,card_name from f_card where cust_name = ? and gym = ? and card_type ='006' ", new Object[] { cust_name, emp_gym });
				if (s > 0) {
					this.obj.put("cards", en.getValues());
				}
			}
		}

	}

	/**
	 * 团课消课记录查询
	 * 
	 * @Title: getOrderRecord
	 * @author: liul
	 * @date: 2017年8月8日上午11:10:31
	 * @param empId
	 * @param first_day
	 * @param last_day
	 * @param gym
	 * @return
	 * @throws Exception
	 */

	public List<Map<String, Object>> getOrderRecord(String empId, String first_day, String last_day, String gym,String cust_name) throws Exception {
		Entity entity = new EntityImpl(this);
		//String sql = "SELECT b.PLAN_NAME as card_name,a.GYM,a.CUST_NAME,a.END_TIME as op_time,a.START_TIME,a.PT_ID,d.MEM_ID,e.MEM_NAME from f_class_record_" + gym + " a,f_plan b,f_emp c,f_order_" + gym + " d,f_mem_" + cust_name + " e WHERE d.MEM_ID=e.ID AND a.plan_id=b.ID AND a.PT_ID=c.ID AND d.plan_list_id=a.PLAN_DETAIL_ID and a.pt_id=? AND END_TIME BETWEEN ? AND ? ";
		String sql = "select b.PLAN_NAME as card_name,a.GYM,a.CUST_NAME,a.END_TIME as op_time,a.START_TIME,a.PT_ID,d.MEM_ID,e.MEM_NAME,f.headurl from f_class_record_" + gym + " a left join f_plan b on a.plan_id = b.id left join f_emp c on a.pt_id = c.id left join f_order_" + gym + " d on a.plan_detail_id = d.PLAN_LIST_ID left join f_mem_" + cust_name + " e on d.mem_id = e.id left join f_wx_cust_"+cust_name +" f on e.wx_open_id = f.wx_open_id where  a.pt_id=? AND END_TIME BETWEEN ? AND ? ";
		entity.executeQuery(sql, new String[] { empId, first_day, last_day });
		
		List<Map<String, Object>> list  = entity.getValues();
		for(int i = 0;i<list.size();i++){
			MemInfo memInfo = MemUtils.getMemInfo(entity.getStringValue("mem_id",i), cust_name);
			if(memInfo !=null){
				list.get(i).put("mem_name", memInfo.getName()	);
			}
		}
		return list;
	}
}
