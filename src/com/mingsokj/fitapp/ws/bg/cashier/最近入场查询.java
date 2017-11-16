package com.mingsokj.fitapp.ws.bg.cashier;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;

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
import com.mingsokj.fitapp.utils.MemUtils;

public class 最近入场查询 extends BasicAction {

	/**
	 * 入场会员查询
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-query-chekinMems", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void checkinMems() throws Exception {
		JSONArray arr = new JSONArray();
		List<Map<String, Object>> cardMsg = new ArrayList<>();
		Code code = Codes.code("checkin_state");
		String cur = request.getParameter("cur");
		if (cur == null || cur.length() <= 0) {
			cur = "1";
		}
		String search = this.getParameter("search");
		FitUser emp = (FitUser) this.getSessionUser();// 当前收银员
		String gym = emp.getViewGym();
		String cust_name = emp.getCust_name();

		int pageSize = 2;
		int curPage = Integer.parseInt(cur);
		int start = (curPage - 1) * pageSize + 1;
		int end = pageSize * curPage;

		int total = 0;
		int totalpage = 0;

		Entity en = new EntityImpl(this);
		String sql = "select * from f_checkin_" + gym
				+ " where TO_DAYS(checkin_time) = TO_DAYS(NOW()) and state='002'  order by checkin_time desc";
		if(!Utils.isNull(search)){
			sql = "select a.* from f_checkin_" + gym
					+ " a,f_mem_"+cust_name+" b where a.mem_id = b.id and TO_DAYS(a.checkin_time) = TO_DAYS(NOW()) and a.state='002' "
							+ " and (b.mem_name like '"+search+"%' or b.phone = '"+search+"')"
							+ "  order by a.checkin_time desc";
		}
		int size = en.executeQueryWithMaxResult(sql, start, end);
		List<Map<String, Object>> list = en.getValues();
		if (size > 0) {
			total = en.getMaxResultCount();
			int temp = total / pageSize;
			totalpage = total % pageSize > 0 ? temp + 1 : temp > 0 ? temp : 1;
			for (int i = 0; i < list.size(); i++) {
				String mem_id = en.getStringValue("mem_id", i);
				Map<String, Object> xx = list.get(i);
				if (!"-1".equals(mem_id)) {
					MemInfo meminfo = MemUtils.getMemInfo(mem_id, cust_name);
					JSONObject obj = new JSONObject(meminfo);
					Map<String, Object> m = obj.toMap();
					String checkin_time = "-";
					try {
						checkin_time = Utils.getMapFormatStringValue(xx, "checkin_time", "MM-dd HH:mm");
					} catch (Exception e) {
					}
					m.put("checkin_time", checkin_time);

					String checkout_time = "-";
					try {
						checkout_time = Utils.getMapFormatStringValue(xx, "checkout_time", "MM-dd HH:mm");
					} catch (Exception e) {
					}
					m.put("checkout_time", checkout_time);

					String state = Utils.getMapStringValue(xx, "state");
					state = code.getNote(state);
					m.put("state", state);
					m.put("hand_no", Utils.getMapStringValue(xx, "hand_no"));
					m.put("is_backhand", Utils.getMapStringValue(xx, "is_backhand"));
					arr.put(m);
				} else {
					// 单次入场券入场

					Map<String, Object> m = new HashMap<String, Object>();
					m.put("id", "-1");
					m.put("imgUrl", "");
					m.put("remark", "");
					m.put("name", Utils.getMapStringValue(xx, "checkin_card_name"));
					m.put("sex", "-");
					m.put("phone", "-");
					m.put("mem_no", "-");
					m.put("pid", "");
					m.put("checkin_id", Utils.getMapStringValue(xx, "id"));
					String checkin_time = "-";
					try {
						checkin_time = Utils.getMapFormatStringValue(xx, "checkin_time", "MM-dd HH:mm");
					} catch (Exception e) {
					}
					m.put("checkin_time", checkin_time);

					String checkout_time = "-";
					try {
						checkout_time = Utils.getMapFormatStringValue(xx, "checkout_time", "MM-dd HH:mm");
					} catch (Exception e) {
					}
					m.put("checkout_time", checkout_time);

					String state = Utils.getMapStringValue(xx, "state");
					state = code.getNote(state);
					m.put("state", state);
					m.put("hand_no", Utils.getMapStringValue(xx, "hand_no"));
					m.put("is_backhand", Utils.getMapStringValue(xx, "is_backhand"));
					arr.put(m);
				}

			}
		}
		List<Map<String, Object>> cardRemarks = new ArrayList<>();
		// 拿到会员购卡卡信息
		for (int k = 0; k < arr.length(); k++) {
			String mem_id = ((JSONObject) arr.get(k)).getString("id");
			List<Map<String, Object>> cards = MemUtils.getMemCards(mem_id, cust_name, gym);
			if (cards != null && cards.size() > 0) {
				for (int i = 0; i < cards.size(); i++) {
					Map<String, Object> card = cards.get(i);
					//System.out.println(card);
					//每张卡的备注
					String remark = Utils.getMapStringValue(card,"remark");
					String card_name = Utils.getMapStringValue(card,"card_name");
					Map<String, Object> r = new HashMap<>();
					r.put("mem_id", mem_id);
					r.put("card_name", card_name);
					r.put("remark", remark);
					cardRemarks.add(r);
					
					Boolean has = false;
					int hasNo = 0;
					for (int j = 0; j < cardMsg.size(); j++) {
						Map<String, Object> hasCard = cardMsg.get(j);
						if (Utils.getMapStringValue(hasCard, "card_type")
								.equals(Utils.getMapStringValue(card, "card_type"))
								&& Utils.getMapStringValue(hasCard, "mem_id")
										.equals(Utils.getMapStringValue(card, "mem_id"))) {
							has = true;
							hasNo = j;
							break;
						}
					}
					if (has) {
						Map<String, Object> map = cardMsg.get(hasNo);
						int s = Utils.getMapIntegerValue(card, "remain_times");
						int ss = Utils.getMapIntegerValue(card, "days");
						
						
						map.put("remain_times", Utils.getMapIntegerValue(map, "remain_times") + s);
						map.put("days", Utils.getMapIntegerValue(map, "days") + ss);
					} else {
						cardMsg.add(card);
					}
				}
			}
		}
		this.obj.put("cardRemarks", cardRemarks);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		for (int i = 0; i < cardMsg.size(); i++) {
			String deadlineStr = cardMsg.get(i).get("deadline") + "";
			String type = cardMsg.get(i).get("card_type") + "";
			if ("001".equals(type)) {
				if (!"".equals(deadlineStr)) {
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
		
		this.obj.put("mems", arr);
		this.obj.put("cardMsg", cardMsg);
		this.obj.put("total", total);// 总条数
		this.obj.put("totalPage", totalpage);// 总页数
		this.obj.put("curPage", curPage);// 当前页
		this.obj.put("curSize", list.size());// 当前页显示条数
	}
}
