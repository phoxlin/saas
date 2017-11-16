package com.mingsokj.fitapp.ws.bg.cashier;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
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
import com.mingsokj.fitapp.m.FitUser;
import com.mingsokj.fitapp.utils.GymUtils;
import com.mingsokj.fitapp.utils.MemUtils;

/**
 * @author liul 2017年8月10日下午4:13:46
 */
public class 入场报表 extends BasicAction {

	@Route(value = "/fit-query-chekinReport", conn = true, slave=true , m = HttpMethod.POST, type = ContentType.JSON)
	public void checkinMems() throws Exception {
		String cur = request.getParameter("cur");
		String inOut = request.getParameter("type");
		String search = request.getParameter("search");
		String searchKey = request.getParameter("searchKey");
		String start_time = request.getParameter("start_time");
		String end_time = request.getParameter("end_time");
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd"); 
		  //获取前月的第一天
        Calendar   cal_1=Calendar.getInstance();//获取当前日期 
        cal_1.add(Calendar.MONTH,0);
        cal_1.set(Calendar.DAY_OF_MONTH,1);//设置为1号,当前日期既为本月第一天 
        String firstDay = format.format(cal_1.getTime());
        //获取前月的最后一天
        Calendar cale = Calendar.getInstance();   
        cale.set(Calendar.DAY_OF_MONTH, cale.getActualMaximum(Calendar.DAY_OF_MONTH)); 
        String lastDay = format.format(cale.getTime());
		if (cur == null || cur.length() <= 0) {
			cur = "1";
		}

		FitUser emp = (FitUser) this.getSessionUser();// 当前收银员
		String cust_name = emp.getCust_name();
		String gym = emp.getViewGym();

		int pageSize = 2;
		int curPage = Integer.parseInt(cur);
		int start = (curPage - 1) * pageSize + 1;
		int end = pageSize * curPage;

		Entity entity = new EntityImpl(this);
		String sql = "SELECT a.CHECKIN_TIME,b.* FROM f_checkin_" + gym + " a, f_mem_" + cust_name + " b WHERE a.MEM_ID=b.ID AND TO_DAYS(a.CHECKIN_TIME)=TO_DAYS(NOW()) AND a.state='002'";
		int allNums = 0;
		allNums = entity.executeQuery(sql);
		
		
		if ("inOut".equals(inOut)) {
			sql = "SELECT a.CHECKIN_TIME,a.checkout_time,b.* FROM f_checkin_" + gym + " a, f_mem_" + cust_name + " b WHERE a.MEM_ID=b.ID AND TO_DAYS(a.CHECKIN_TIME)=TO_DAYS(NOW())";
			allNums = entity.executeQuery("SELECT a.CHECKIN_TIME,a.checkout_time,b.* FROM f_checkin_" + gym + " a, f_mem_" + cust_name + " b WHERE a.MEM_ID=b.ID AND TO_DAYS(a.CHECKIN_TIME)=TO_DAYS(NOW())");
		}else if ("allInOutMem".equals(inOut)) {
			//根据日期查询
			if(!Utils.isNull(start_time) && !Utils.isNull(end_time)){
				sql = "SELECT a.CHECKIN_TIME,a.checkout_time,b.* FROM f_checkin_" + gym + " a, f_mem_" + cust_name + " b WHERE a.MEM_ID=b.ID AND  a.checkin_time BETWEEN '"+start_time+"' AND '"+end_time+"' ";
			}else if (!Utils.isNull(start_time) && Utils.isNull(end_time)) {
				end_time = lastDay;
				sql = "SELECT a.CHECKIN_TIME,a.checkout_time,b.* FROM f_checkin_" + gym + " a, f_mem_" + cust_name + " b WHERE a.MEM_ID=b.ID AND  a.checkin_time BETWEEN '"+start_time+"' AND '"+end_time+"' ";
			}else if (Utils.isNull(start_time) && !Utils.isNull(end_time)) {
				start_time = firstDay;
				sql = "SELECT a.CHECKIN_TIME,a.checkout_time,b.* FROM f_checkin_" + gym + " a, f_mem_" + cust_name + " b WHERE a.MEM_ID=b.ID AND  a.checkin_time BETWEEN '"+start_time+"' AND '"+end_time+"' ";
			}else{
				start_time = firstDay;
				end_time = lastDay;
				this.obj.put("start_time", start_time);
				this.obj.put("end_time", end_time);
				sql = "SELECT a.CHECKIN_TIME,a.checkout_time,b.* FROM f_checkin_" + gym + " a, f_mem_" + cust_name + " b WHERE a.MEM_ID=b.ID AND  a.checkin_time BETWEEN '"+start_time+"' AND '"+end_time+"' ";
			}
			allNums = entity.executeQuery(sql);
		}
		if ("1".equals(search)) {
			sql += "  and (b.mem_name like '"+searchKey + "%' or b.phone like '" + searchKey + "%' )";
			allNums = entity.executeQuery(sql);
		}
		entity.executeQueryWithMaxResult(sql, start, end);
		List<Map<String, Object>> list = entity.getValues();
		List<Map<String, Object>> cardMsg = new ArrayList<>();
		int j = 0;
		String mem_id2 = "";
		// 拿到会员的信息
		for (Map<String, Object> map : list) {
			String mem_id = map.get("id") + "";
			// 如果是同一个用户的信息，则只存 一条
			if (j > 0) {
				if (!mem_id.equals(mem_id2)) {
					mem_id2 = map.get("id") + "";
					String mem_gym = map.get("gym") + "";
					List<Map<String, Object>> cards = MemUtils.getMemCards(mem_id, cust_name, gym);
					if (cards != null && cards.size() > 0) {
						for (int x = 0; x < cards.size(); x++) {
							Map<String, Object> card = cards.get(x);
							Boolean has = false;
							int hasNo = 0;
							for (int y = 0; y < cardMsg.size(); y++) {
								Map<String, Object> hasCard = cardMsg.get(y);
								if (Utils.getMapStringValue(hasCard, "card_type").equals(Utils.getMapStringValue(card, "card_type")) && Utils.getMapStringValue(hasCard, "mem_id").equals(Utils.getMapStringValue(card, "mem_id"))) {
									has = true;
									hasNo = y;
									break;
								}
							}
							if (has) {
								Map<String, Object> c = cardMsg.get(hasNo);
								int s = Utils.getMapIntegerValue(card, "remain_times");
								int ss = Utils.getMapIntegerValue(card, "days");
								
								c.put("remain_times",Utils.getMapIntegerValue(c, "remain_times")+s);
								c.put("days",Utils.getMapIntegerValue(c, "days")+ss);
							} else {
								cardMsg.add(card);
							}
						}
					}
					String gymName = GymUtils.getGymName(mem_gym);
					map.put("gym_name",gymName);
					
				}
			} else {
				mem_id2 = map.get("id") + "";
				String mem_gym = map.get("gym") + "";
				List<Map<String, Object>> cards = MemUtils.getMemCards(mem_id, cust_name, gym);
				if (cards != null && cards.size() > 0) {
					for (int x = 0; x < cards.size(); x++) {
						Map<String, Object> card = cards.get(x);
						Boolean has = false;
						int hasNo = 0;
						for (int y = 0; y < cardMsg.size(); y++) {
							Map<String, Object> hasCard = cardMsg.get(y);
							if (Utils.getMapStringValue(hasCard, "card_type").equals(Utils.getMapStringValue(card, "card_type")) && Utils.getMapStringValue(hasCard, "mem_id").equals(Utils.getMapStringValue(card, "mem_id"))) {
								has = true;
								hasNo = y;
								break;
							}
						}
						if (has) {
							Map<String, Object> c = cardMsg.get(hasNo);
							int s = Utils.getMapIntegerValue(card, "remain_times");
							int ss = Utils.getMapIntegerValue(card, "days");
							
							c.put("remain_times",Utils.getMapIntegerValue(c, "remain_times")+s);
							c.put("days",Utils.getMapIntegerValue(c, "days")+ss);
						} else {
							cardMsg.add(card);
						}
					}
				}
				String gymName = GymUtils.getGymName(mem_gym);
				map.put("gym_name",gymName);
				// 查询该会员属于哪个店
			/*	en.executeQuery("select * from f_gym where gym=?", new String[] { mem_gym });
				map.put("gym_name", en.getStringValue("gym_name"));*/
			}
			j++;
		}
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		for (int i = 0; i < cardMsg.size(); i++) {
			String deadlineStr = cardMsg.get(i).get("deadline") + "";

			String type = cardMsg.get(i).get("card_type") + "";
			if ("001".equals(type)) {
				if (!"".equals(deadlineStr) && !"null".equals(deadlineStr)) {
					Date deadline = sdf.parse(deadlineStr);
					long endTime = deadline.getTime();
					long nowTime = new Date().getTime();
					long days = (endTime - nowTime) / (1000 * 60 * 60 * 24);
					cardMsg.get(i).put("days", days);
				} else {
					cardMsg.get(i).put("days", "未激活");
				}
			}
		}
		int total = 0;
		int totalpage = 0;
		total = entity.getMaxResultCount();
		int temp = total / pageSize;
		totalpage = total % pageSize > 0 ? temp + 1 : temp > 0 ? temp : 1;

		this.obj.put("mems", list);
		this.obj.put("allNums", allNums);
		this.obj.put("cardMsg", cardMsg);
		this.obj.put("total", total);// 总条数
		this.obj.put("totalPage", totalpage);// 总页数
		this.obj.put("curPage", curPage);// 当前页
		this.obj.put("curSize", list.size());// 当前页显示条数
	}
	
	public String getDay(){
		
		
		return null;
	}
}
