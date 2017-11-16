package com.mingsokj.fitapp.ws.bg.set;

import java.sql.Connection;
import java.util.HashMap;
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
import com.mingsokj.fitapp.m.FitUser;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.utils.GymUtils;
import com.mingsokj.fitapp.utils.MemUtils;

/**
 * @author liul 2017年7月7日上午11:28:00
 */
public class SysSet extends BasicAction {

	/**
	 * 获取设置信息
	 * 
	 * @Title: getValues
	 * @author: liul
	 * @date: 2017年7月7日下午4:40:24
	 * @param cust_name
	 * @param gym
	 * @param code
	 * @param key
	 * @param conn
	 * @return
	 * @throws Exception
	 */
	public static String getValues(String cust_name, String gym, String code, String key, Connection conn) throws Exception {
		Entity entity = new EntityImpl(conn);
		String sql = "select * from f_param where cust_name=? and gym = ? and code=?";
		int size = entity.executeQuery(sql, new String[] { cust_name, gym, code });
		String val = "";
		if (size > 0) {
			String note = entity.getStringValue("note");
			if (key == null) {
				// 直接将gym作为key
				JSONObject obj = new JSONObject(note);
				if (obj.has(gym)) {
					val = obj.getString(gym);
				}
			} else {
				JSONArray array = new JSONArray(note);
				for (int i = 0; i < array.length(); i++) {
					JSONObject object = array.getJSONObject(i);
					if (object.has("gym")) {
						if (gym.equals(object.get("gym"))) {
							if (object.has(key)) {
								val = object.getString(key);
							}
							break;
						}
					}
				}
			}
		}

		// 如果分店没有，则取总店设置
		if ((val == null || val.length() <= 0) && size > 0) {
			String note = entity.getStringValue("note");
			if (key == null) {
				// 直接将gym作为key
				JSONObject obj = new JSONObject(note);
				if (obj.has(cust_name)) {
					val = obj.getString(cust_name);
				}
			} else {
				JSONArray array = new JSONArray(note);
				for (int i = 0; i < array.length(); i++) {
					JSONObject object = array.getJSONObject(i);
					if (object.has("gym")) {
						if (cust_name.equals(object.get("gym"))) {
							if (object.has(key)) {
								val = object.getString(key);
							}
							break;
						}
					}
				}
			}
		}

		return val;
	}

	/**
	 * 短信设置
	 * 
	 * @Title: f_set_messgae
	 * @author: liul
	 * @date: 2017年7月7日上午11:34:27
	 * @throws Exception
	 */
	@Route(value = "/f_set_messgae", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void f_set_messgae() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String[] getChoice = request.getParameterValues("msg");
		String gym = user.getViewGym();
		String cust_name = user.getCust_name();
		// 检查该用户是否已经设置过
		for (String string : getChoice) {
			Entity en = new EntityImpl("f_param", this);
			en.setValue("gym", gym);
			en.setValue("code", string);
			int size = en.search();
			if (size > 0) {
				JSONArray o = new JSONArray();
				String id = en.getStringValue("id");
				JSONObject obj = new JSONObject();
				obj.put("gym", gym);
				obj.put("msg", "Y");
				o.put(obj);
				en = new EntityImpl("f_param", this);
				en.setValue("id", id);
				en.setValue("note", o);
				en.update();
			} else {
				JSONArray o = new JSONArray();
				JSONObject obj = new JSONObject();
				obj.put("gym", gym);
				obj.put("msg", "Y");
				o.put(obj);
				en = new EntityImpl("f_param", this);
				en.setValue("cust_name", cust_name);
				en.setValue("gym", gym);
				en.setValue("code", string);
				en.setValue("note", o);
				en.create();
			}
		}
		// 未选中的设置为不发送消息
		Entity entity = new EntityImpl(this);
		Entity entity2 = new EntityImpl(this);
		String item = Utils.getListString("?", getChoice.length);
		int size = entity.executeQuery("select id from f_param where code not in (" + item + ")", getChoice);
		for (int i = 0; i < size; i++) {
			JSONArray o = new JSONArray();
			String id = entity.getStringValue("id", i);
			JSONObject obj = new JSONObject();
			obj.put("gym", gym);
			obj.put("msg", "N");
			o.put(obj);
			entity2 = new EntityImpl("f_param", this);
			entity2.setValue("id", id);
			entity2.setValue("note", o);
			entity2.update();
		}
	}

	/**
	 * 获取用户短信设置详情
	 * 
	 * @Title: getMsg
	 * @author: liul
	 * @date: 2017年7月7日下午4:30:34
	 * @throws Exception
	 */
	@Route(value = "/getMsg", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void getMsg() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String cust_name = user.getCust_name();
		Entity en = new EntityImpl("f_param", this);
		en.setValue("gym", gym);
		en.setValue("cust_name", cust_name);
		int size = en.search();
		Map<String, String> map = new HashMap<>();
		// 查询短信设置
		for (int i = 0; i < size; i++) {
			String value = SysSet.getValues(cust_name, gym, en.getStringValue("code", i), "msg", this.getConnection());
			map.put(en.getStringValue("code", i), value);
		}
		this.obj.put("getMsg", map);
	}

	/**
	 * 打印合同设置
	 * 
	 * @Title: f_set_print
	 * @author: liul
	 * @date: 2017年7月13日上午11:30:47
	 * @throws Exception
	 */
	@Route(value = "/fit-action-gym-f_set_print", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void f_set_print() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String cust_name = user.getCust_name();
		String gym = user.getViewGym();
		// 拿到设置的卡类型
		String type = this.getParameter("type");
		String[] cardMsg = this.getParameterValues("cardMsg");
		String[] memMsg = this.getParameterValues("memMsg");

		JSONArray arrayCard = new JSONArray();
		JSONArray arrayMem = new JSONArray();
		JSONObject obj = new JSONObject();
		if (cardMsg != null) {
			arrayCard = new JSONArray(cardMsg);
			obj.put("cardMsg", arrayCard);
		}
		if (memMsg != null) {
			arrayMem = new JSONArray(memMsg);
			obj.put("memMsg", arrayMem);
		}

		Entity en = new EntityImpl("f_param", this);
		// 如果已经设置过，直接修改
		Entity entity = new EntityImpl("f_param", this);
		entity.setValue("code", "set_print" + type);
		entity.setValue("gym", gym);
		int size = entity.search();
		if (size > 0) {
			en.setValue("id", entity.getStringValue("id"));
			en.setValue("code", "set_print" + type);
			en.setValue("cust_name", cust_name);
			en.setValue("gym", gym);
			en.setValue("note", obj);
			en.update();
		} else {
			en.setValue("code", "set_print" + type);
			en.setValue("cust_name", cust_name);
			en.setValue("gym", gym);
			en.setValue("note", obj);
			en.create();
		}

	}

	/**
	 * 获取私教设置详情
	 * 
	 * @Title: getPrivateSet
	 * @author: liul
	 * @date: 2017年7月11日下午2:52:26
	 * @throws Exception
	 */
	@Route(value = "/getPrivateSet", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void getPrivateSet() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String cust_name = user.getCust_name();
		Entity en = new EntityImpl("f_param", this);
		en.setValue("gym", gym);
		en.setValue("cust_name", cust_name);
		en.setValue("code", "private_class");
		int size = en.search();
		if (size > 0) {
			// 查询短信设置
			String delay = SysSet.getValues(cust_name, gym, "private_class", "delay", this.getConnection());
			String checkType = SysSet.getValues(cust_name, gym, "private_class", "checkType", this.getConnection());
			String coachType = SysSet.getValues(cust_name, gym, "private_class", "coachType", this.getConnection());
			String needFingerPrint = SysSet.getValues(cust_name, gym, "private_class", "needFingerPrint", this.getConnection());
			String startTime = SysSet.getValues(cust_name, gym, "private_class", "startTime", this.getConnection());
			String endTime = SysSet.getValues(cust_name, gym, "private_class", "endTime", this.getConnection());

			this.obj.put("checkType", checkType);
			this.obj.put("delay", delay);
			this.obj.put("coachType", coachType);
			this.obj.put("needFingerPrint", needFingerPrint);
			this.obj.put("startTime", startTime);
			this.obj.put("endTime", endTime);
		}
	}

	/**
	 * 保存合同
	 * 
	 * @Title: savaContract
	 * @author: liul
	 * @date: 2017年7月10日下午1:48:30
	 * @throws Exception
	 */
	@Route(value = "/f_set_contract", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void f_set_contract() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String content = this.getParameter("content");
		String type = this.getParameter("f_contract__type");
		String gym = user.getViewGym();
		String cust_name = user.getCust_name();
		Entity en = new EntityImpl("f_contract", this);
		Entity entity = new EntityImpl("f_contract", this);
		// 查询是否已经设置了合同
		entity.setValue("gym", gym);
		entity.setValue("cust_name", cust_name);
		entity.setValue("type", type);
		int size = entity.search();
		if (size > 0) {
			en.setValue("id", entity.getStringValue("id"));
			en.setValue("content", content);
			en.setValue("state", "Y");
			en.update();
		} else {
			en.setValue("gym", gym);
			en.setValue("cust_name", cust_name);
			en.setValue("type", type);
			en.setValue("content", content);
			en.setValue("state", "Y");
			en.update();
			en.create();
		}
	}

	/**
	 * 私教设置
	 * 
	 * @Title: f_set_private
	 * @author: liul
	 * @date: 2017年7月11日上午10:54:25
	 * @throws Exception
	 */
	@Route(value = "/f_set_private", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void f_set_private() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String cust_name = user.getCust_name();
		// 拿到用户设置的参数
		String startTime = this.getParameter("start-time");
		String endTime = this.getParameter("end-time");
		String checkType = this.getParameter("checkType");
		String delay = this.getParameter("delay");
		String coachType = this.getParameter("coachType");
		String needFingerPrint = this.getParameter("needFingerPrint");
		Entity en = new EntityImpl("f_param", this);
		Entity entity = new EntityImpl("f_param", this);
		JSONObject obj = new JSONObject();
		JSONArray array = new JSONArray();
		String sql = "select * from f_param where gym=? and code=?";
		int size = en.executeQuery(sql, new String[] { gym, "private_class" });
		if (size > 0) {
			array = new JSONArray("[]");
			obj.put("gym", gym);
			obj.put("startTime", startTime);
			obj.put("endTime", endTime);
			obj.put("checkType", checkType);
			obj.put("delay", delay);
			obj.put("coachType", coachType);
			obj.put("needFingerPrint", needFingerPrint);
			array.put(obj);

			entity.setValue("id", en.getStringValue("id"));
			entity.setValue("note", array.toString());
			entity.update();
		} else {
			array = new JSONArray("[]");
			obj.put("gym", gym);
			obj.put("startTime", startTime);
			obj.put("endTime", endTime);
			obj.put("checkType", checkType);
			obj.put("delay", delay);
			obj.put("coachType", coachType);
			obj.put("needFingerPrint", needFingerPrint);
			array.put(obj);
			en = new EntityImpl("f_param", this);
			en.setValue("cust_name", cust_name);
			en.setValue("gym", gym);
			en.setValue("code", "private_class");
			en.setValue("note", array.toString());
			en.create();
		}

	}

	/**
	 * 团课预约设置
	 * 
	 * @Title: setPlanOrder
	 * @author: liul
	 * @date: 2017年7月19日下午2:20:17
	 * @throws Exception
	 */
	@Route(value = "/fit-action-gym-setPlanOrder", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void setPlanOrder() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String cust_name = user.getCust_name();
		// 拿到用户设置的参数
		String startTime = this.getParameter("start_time");
		String endTime = this.getParameter("end_time");
		Entity en = new EntityImpl("f_param", this);
		Entity entity = new EntityImpl("f_param", this);
		JSONObject obj = new JSONObject();
		JSONArray array = new JSONArray();
		String sql = "select * from f_param where gym=? and code=?";
		int size = en.executeQuery(sql, new String[] { gym, "set_plan_order" });
		if (size > 0) {
			array = new JSONArray("[]");
			obj.put("gym", gym);
			obj.put("startTime", startTime);
			obj.put("endTime", endTime);
			array.put(obj);

			entity.setValue("id", en.getStringValue("id"));
			entity.setValue("note", array.toString());
			entity.update();
		} else {
			array = new JSONArray("[]");
			obj.put("gym", gym);
			obj.put("startTime", startTime);
			obj.put("endTime", endTime);
			array.put(obj);
			en = new EntityImpl("f_param", this);
			en.setValue("cust_name", cust_name);
			en.setValue("gym", gym);
			en.setValue("code", "set_plan_order");
			en.setValue("note", array.toString());
			en.create();
		}

	}

	/**
	 * 积分设置
	 * 
	 * @Title: setPoints
	 * @author: liul
	 * @date: 2017年8月16日上午11:43:52
	 * @throws Exception
	 */
	@Route(value = "/fit-action-gym-setPoints", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void setPoints() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String cust_name = user.getCust_name();
		// 拿到用户设置的参数
		String recommend_points = this.getParameter("recommend_points");
		Entity en = new EntityImpl("f_param", this);
		Entity entity = new EntityImpl("f_param", this);
		JSONObject obj = new JSONObject();
		JSONArray array = new JSONArray();
		String sql = "select * from f_param where gym=? and code=?";
		int size = en.executeQuery(sql, new String[] { gym, "set_points" });
		if (size > 0) {
			array = new JSONArray("[]");
			obj.put("gym", gym);
			obj.put("recommend_points", recommend_points);
			array.put(obj);

			entity.setValue("id", en.getStringValue("id"));
			entity.setValue("note", array.toString());
			entity.update();
		} else {
			array = new JSONArray("[]");
			obj.put("gym", gym);
			obj.put("recommend_points", recommend_points);
			array.put(obj);
			en = new EntityImpl("f_param", this);
			en.setValue("cust_name", cust_name);
			en.setValue("gym", gym);
			en.setValue("code", "set_points");
			en.setValue("note", array.toString());
			en.create();
		}

	}

	/**
	 * 获取团课设置
	 * 
	 * @Title: getPlanSet
	 * @author: liul
	 * @date: 2017年7月19日下午2:40:35
	 * @throws Exception
	 */
	@Route(value = "/fit-action-gym-getPlanSet", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void getPlanSet() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String cust_name = user.getCust_name();
		// 获取打印设置信息
		Entity getPrint = new EntityImpl("f_param", this);
		getPrint.setValue("gym", gym);
		getPrint.setValue("cust_name", cust_name);
		getPrint.setValue("code", "set_plan_order");
		int size2 = getPrint.search();
		if (size2 > 0) {
			// 拿到需要打印的参数
			String startTime = SysSet.getValues(cust_name, gym, "set_plan_order", "startTime", this.getConnection());
			String endTime = SysSet.getValues(cust_name, gym, "set_plan_order", "endTime", this.getConnection());
			this.obj.put("startTime", startTime);
			this.obj.put("endTime", endTime);
		}
	}

	/**
	 * 获取积分设置
	 * 
	 * @Title: getPointsSet
	 * @author: liul
	 * @date: 2017年8月16日下午2:17:20
	 * @throws Exception
	 */
	@Route(value = "/fit-action-gym-getPointsSet", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void getPointsSet() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String cust_name = user.getCust_name();
		// 获取打印设置信息
		Entity getPrint = new EntityImpl("f_param", this);
		getPrint.setValue("gym", gym);
		getPrint.setValue("cust_name", cust_name);
		getPrint.setValue("code", "set_points");
		int size2 = getPrint.search();
		if (size2 > 0) {
			// 拿到需要打印的参数
			String recommend_points = SysSet.getValues(cust_name, gym, "set_points", "recommend_points", this.getConnection());
			this.obj.put("recommend_points", recommend_points);
		}
	}

	// 获取打印设置
	@Route(value = "/fit-action-gym-getPrintSet", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void getPrintSet() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String cust_name = user.getCust_name();
		String type = this.getParameter("type");
		// 获取打印设置信息
		Entity getPrint = new EntityImpl("f_param", this);
		getPrint.setValue("gym", gym);
		getPrint.setValue("cust_name", cust_name);
		getPrint.setValue("code", "set_print" + type);
		int size2 = getPrint.search();
		if (size2 > 0) {
			// 拿到需要打印的参数
			String note = getPrint.getStringValue("note");
			JSONObject obj = new JSONObject(note);
			JSONArray arrayCard = new JSONArray();
			JSONArray arrayMem = new JSONArray();
			arrayCard = obj.getJSONArray("cardMsg");
			arrayMem = obj.getJSONArray("memMsg");
			List<Object> listCard = arrayCard.toList();
			List<Object> listMem = arrayMem.toList();
			this.obj.put("listCard", listCard);
			this.obj.put("listMem", listMem);
		}
	}

	/**
	 * 获取合同打印需要的信息
	 * 
	 * @Title: getPrintMsg
	 * @author: liul
	 * @date: 2017年7月11日下午3:52:40
	 * @throws Exception
	 */
	@Route(value = "/fit-action-gym-getPrintMsg", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void getPrintMsg() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String cust_name = user.getCust_name();
		String type = this.getParameter("type");
		StringBuffer sbMem = new StringBuffer();// 用于储存打印的用户信息
		StringBuffer sbCard = new StringBuffer();// 用于储存打印的卡信息
		String userName = user.getMemInfo().getName();
		String contractNo = "";
		// 拿到购卡记录的id
		String id = this.request.getParameter("id");
		Map<String, Object> printCardMsg = new HashMap<>();
		Map<String, Object> printMemMsg = new HashMap<>();
		// 拿到打印合同的设置
		Entity getPrint = new EntityImpl("f_param", this);
		getPrint.setValue("gym", gym);
		getPrint.setValue("cust_name", cust_name);
		getPrint.setValue("code", "set_print" + type);
		int size2 = getPrint.search();
		if (size2 > 0) {
			// 拿到需要打印的参数
			String note = getPrint.getStringValue("note");
			JSONObject obj = new JSONObject(note);
			JSONArray arrayCard = new JSONArray();
			JSONArray arrayMem = new JSONArray();
			arrayCard = obj.getJSONArray("cardMsg");
			arrayMem = obj.getJSONArray("memMsg");
			List<Object> listCard = arrayCard.toList();
			List<Object> listMem = arrayMem.toList();
			String sqlCard = "";
			String sqlMem = "";
			for (Object card : listCard) {
				sqlCard += (card + ",");
			}
			for (Object mem : listMem) {
				sqlMem += (mem + ",");
			}
			// 通过拼接sql来查询所需要的值
			Entity search = new EntityImpl(this);
			String sql1 = "";
			// 如果是买的私教课
			if (type.equals("002")) {
				sql1 = "select " + sqlMem + "card_id,mem_id,contract_no from f_mem_" + cust_name + " m,f_user_lesson u WHERE m.ID=u.MEM_ID AND u.ID=?";
			} else {
				sql1 = "select " + sqlMem + "card_id,mem_id,contract_no from f_mem_" + cust_name + " m,f_user_card u WHERE m.ID=u.MEM_ID AND u.ID=?";
			}
			String sql2 = "select " + sqlCard + "id,card_type from f_card where id=?";
			int size = search.executeQuery(sql1, new String[] { id });
			if (size > 0) {
				printMemMsg.putAll(search.getValues().get(0));
				contractNo = search.getStringValue("contract_no");
				// 拿到卡id
				String card_id = search.getStringValue("card_id");
				// 拿到卡信息
				Entity card = new EntityImpl("f_card", this);
				card.setTableComment("f_card");
				card.executeQuery(sql2, new String[] { card_id });
				printCardMsg.putAll(card.getValues().get(0));
				// 拿到需要打印的会员信息
				sbMem.append(getMemMsg(printMemMsg));
				// 将需要打印卡的信息
				sbCard.append(getCardMsg(printCardMsg, printMemMsg));

			} else {
				throw new Exception("未查到相关信息");
			}
		} else {
			Entity en = new EntityImpl("f_user_card", this);
			if (type.equals("002")) {
				en = new EntityImpl("f_user_lesson", this);
			}

			en.setValue("id", id);
			int size = en.search();
			if (size > 0) {
				printMemMsg.putAll(en.getValues().get(0));// 购卡记录详细
				// 拿到购卡会员id，卡id
				String card_id = en.getStringValue("card_id");
				String mem_id = en.getStringValue("mem_id");
				contractNo = en.getStringValue("contract_no");
				// 拿到该会员信息
				Entity mem = new EntityImpl("f_mem", this);
				mem.setTablename("f_mem_" + cust_name);
				mem.setValue("id", mem_id);
				mem.search();
				printMemMsg.putAll(mem.getValues().get(0));
				// 拿到卡信息
				Entity card = new EntityImpl("f_card", this);
				card.setTableComment("f_card");
				card.setValue("id", card_id);
				card.search();
				printCardMsg.putAll(card.getValues().get(0));
				getMemMsg(printMemMsg);
				getCardMsg(printCardMsg, printMemMsg);
			} else {
				throw new Exception("未查到相关信息");
			}
		}
		this.obj.put("sbMem", sbMem.toString());
		this.obj.put("sbCard", sbCard.toString());
		this.obj.put("contractNo", contractNo);
		this.obj.put("userName", userName);
	}

	/**
	 * 获取合同打印需要的信息
	 * 
	 * @Title: getPrintMsg
	 * @author: liul
	 * @date: 2017年7月11日下午3:52:40
	 * @throws Exception
	 */
	@Route(value = "/fit-action-gym-getPrintMsg-2", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void getPrintMsgReal() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String cust_name = user.getCust_name();
		String type = this.getParameter("type");
		StringBuffer sbMem = new StringBuffer();// 用于储存打印的用户信息
		StringBuffer sbCard = new StringBuffer();// 用于储存打印的卡信息
		String buy_id = request.getParameter("buy_id");
		String mem_gym = request.getParameter("mem_gym");
		String userName = user.getMemInfo() == null ? GymUtils.getGymName(user.getViewGym()) : user.getMemInfo().getName();
		String contractNo = "";
		// 是否发卡
		String check_give_card = request.getParameter("give_card");
		// 拿到购卡记录的id
		Map<String, Object> printCardMsg = new HashMap<>();
		Map<String, Object> printMemMsg = new HashMap<>();
		// 拿到打印合同的设置
		Entity getPrint = new EntityImpl("f_param", this);
		getPrint.setValue("gym", gym);
		getPrint.setValue("cust_name", cust_name);
		getPrint.setValue("code", "set_print" + type);
		int size2 = getPrint.search();
		if (size2 > 0) {
			// 拿到需要打印的参数
			String note = getPrint.getStringValue("note");
			JSONObject obj = new JSONObject(note);
			JSONArray arrayCard = new JSONArray();
			JSONArray arrayMem = new JSONArray();
			arrayCard = obj.getJSONArray("cardMsg");
			arrayMem = obj.getJSONArray("memMsg");
			List<Object> listCard = arrayCard.toList();
			List<Object> listMem = arrayMem.toList();
			String sqlCard = "";
			String sqlMem = "";
			for (Object card : listCard) {
				sqlCard += (card + ",");
			}
			for (Object mem : listMem) {
				sqlMem += (mem + ",");
			}
			// 通过拼接sql来查询所需要的值
			Entity search = new EntityImpl(this);
			String sql1 = "";
			// 如果是买的私教课
			if (sqlMem.contains("mc_id")) {
				sqlMem = sqlMem.replace("mc_id", "m.mc_id");
			}
			if (sqlMem.contains("pt_id")) {
				sqlMem = sqlMem.replace("pt_id", "m.pt_id");
			}
			if (sqlMem.contains("create_time")) {
				sqlMem = sqlMem.replace("create_time", "m.create_time");
			}
			sql1 = "select " + sqlMem + "card_id,mem_id,contract_no,emp_name,is_give_card,pid from f_mem_" + cust_name + " m,f_user_card_" + gym + " u WHERE m.ID=u.MEM_ID AND u.ID=?";
			// }
			String sql2 = "select " + sqlCard + "id,card_type,is_fanmily from f_card where id=?";
			int size = search.executeQuery(sql1, new String[] { buy_id });
			if (size > 0) {
				printMemMsg.putAll(search.getValues().get(0));
				contractNo = search.getStringValue("contract_no");
				// 拿到卡id
				String card_id = search.getStringValue("card_id");
				// 拿到卡信息
				Entity card = new EntityImpl("f_card", this);
				card.setTableComment("f_card");
				card.executeQuery(sql2, new String[] { card_id });
				printCardMsg.putAll(card.getValues().get(0));

				// 查询有无副卡押金
				if (printCardMsg.containsKey("is_fanmily") && "Y".equals(printCardMsg.get("is_fanmily")) && "Y".equals(check_give_card)) {
					String mem_id = Utils.getMapStringValue(printMemMsg, "mem_id");
					String pid = search.getStringValue("pid");
					if (!Utils.isNull(pid)) {
						// 说明是家庭成员想补打合同
						mem_id = pid;
					}
					Entity en = new EntityImpl(this);
					int s = en.executeQuery("select card_deposit_amt,mem_no from f_mem_" + cust_name + " where pid = ?", new Object[] { mem_id });
					if (s > 0) {
						for (int i = 0; i < s; i++) {
							printMemMsg.put("card_deposit_amt" + (i + 1), en.getStringValue("card_deposit_amt", i));
							printMemMsg.put("mem_no" + (i + 1), en.getStringValue("mem_no", i));
						}
					}
				}

				printMemMsg.put("check_give_card", check_give_card);
				// 查询会籍姓名 教练姓名
				if (!Utils.isNull(search.getStringValue("mc_id"))) {
					MemInfo empMc = MemUtils.getMemInfo(search.getStringValue("mc_id"), cust_name, L);
					if (empMc != null) {
						printMemMsg.put("mc_name", empMc.getMem_name());
					}
				}
				if (!Utils.isNull(search.getStringValue("pt_id"))) {
					MemInfo empPt = MemUtils.getMemInfo(search.getStringValue("pt_id"), cust_name, L);
					if (empPt != null) {
						printMemMsg.put("pt_name", empPt.getMem_name());
					}
				}
				// 拿到需要打印的会员信息
				sbMem.append(getMemMsg(printMemMsg));
				// 将需要打印卡的信息
				sbCard.append(getCardMsg(printCardMsg, printMemMsg));

			} else {
				throw new Exception("未查到相关信息");
			}
		} else {
			Entity en = new EntityImpl("f_user_card", this);
			en.setTablename("f_user_card_" + gym);
			// if (type.equals("006")) {
			// en = new EntityImpl("f_user_lesson", this);
			// en.setTablename("f_user_lesson");
			// }

			en.setValue("id", buy_id);
			int size = en.search();
			if (size > 0) {
				// 拿到购卡会员id，卡id
				String card_id = en.getStringValue("card_id");
				String mem_id = en.getStringValue("mem_id");
				contractNo = en.getStringValue("contract_no");
				// 拿到该会员信息
				Entity mem = new EntityImpl("f_mem", this);
				mem.setTablename("f_mem_" + cust_name);
				mem.setValue("id", mem_id);
				mem.search();
				printMemMsg.putAll(mem.getValues().get(0));

				// 购卡信息
				printMemMsg.putAll(en.getValues().get(0));// 购卡记录详细
				// 查询教练 会籍姓名
				if (!Utils.isNull(en.getStringValue("mc_id"))) {
					MemInfo empMc = MemUtils.getMemInfo(en.getStringValue("mc_id"), cust_name, L);
					if (empMc != null) {
						printMemMsg.put("mc_name", empMc.getMem_name());
					}
				}
				if (!Utils.isNull(en.getStringValue("pt_id"))) {
					MemInfo empPt = MemUtils.getMemInfo(en.getStringValue("pt_id"), cust_name, L);
					if (empPt != null) {
						printMemMsg.put("pt_name", empPt.getMem_name());
					}
				}
				// 拿到卡信息
				Entity card = new EntityImpl("f_card", this);
				card.setTableComment("f_card");
				card.setValue("id", card_id);
				card.search();
				printCardMsg.putAll(card.getValues().get(0));
				// 查询有无副卡押金
				if (printCardMsg.containsKey("is_fanmily") && "Y".equals(printCardMsg.get("is_fanmily")) && "Y".equals(check_give_card)) {
					String pid = mem.getStringValue("pid");
					if (!Utils.isNull(pid)) {
						// 家庭成员打印合同
						mem_id = pid;
					}
					Entity e = new EntityImpl(this);
					int s = e.executeQuery("select card_deposit_amt,mem_no from f_mem_" + cust_name + " where pid = ?", new Object[] { mem_id });
					if (s > 0) {
						for (int i = 0; i < s; i++) {
							printMemMsg.put("card_deposit_amt" + (i + 1), e.getStringValue("card_deposit_amt", i));
							printMemMsg.put("mem_no" + (i + 1), e.getStringValue("mem_no", i));
						}
					}
				}
				printMemMsg.put("check_give_card", check_give_card);
				// 拿到需要打印的会员信息
				sbMem.append(getMemMsg(printMemMsg));
				// 将需要打印卡的信息
				sbCard.append(getCardMsg(printCardMsg, printMemMsg));
			} else {
				throw new Exception("未查到相关信息");
			}
		}
		this.obj.put("sbMem", sbMem.toString());
		this.obj.put("sbCard", sbCard.toString());
		this.obj.put("contractNo", contractNo);
		this.obj.put("userName", userName);
	}

	/**
	 * 封装用户信息
	 * 
	 * @Title: getMemMsg
	 * @author: liul
	 * @date: 2017年7月14日上午9:47:06
	 * @param printMemMsg
	 * @return
	 * @throws Exception
	 */
	public String getMemMsg(Map<String, Object> printMemMsg) throws Exception {
		StringBuffer sbMem = new StringBuffer();
		if (printMemMsg.get("mem_name") != null) {
			sbMem.append("<div class='col-xs-6' >会员姓名:" + printMemMsg.get("mem_name") + "</div>");
		}
		if (printMemMsg.get("sex") != null) {
			if (printMemMsg.get("sex").equals("male")) {
				sbMem.append("<div class='col-xs-6' >会员性别:男</div>");
			} else {
				sbMem.append("<div class='col-xs-6' >会员性别:女" + "</div>");
			}

		}
		if (printMemMsg.get("phone") != null) {
			sbMem.append("<div class='col-xs-6' >手机号码:" + printMemMsg.get("phone") + "</div>");
		}
		if (printMemMsg.get("birthday") != null) {
			sbMem.append("<div class='col-xs-6' >出生日期:" + printMemMsg.get("birthday") + "</div>");
		}
		if (printMemMsg.get("mem_no") != null && !"".equals(printMemMsg.get("mem_no"))) {
			sbMem.append("<div class='col-xs-6' >会员卡号:" + printMemMsg.get("mem_no") + "</div>");
		}
		if (printMemMsg.get("mem_no1") != null && !"".equals(printMemMsg.get("mem_no1"))) {
			sbMem.append("<div class='col-xs-6' >副卡1卡号:" + printMemMsg.get("mem_no1") + "</div>");
		}
		if (printMemMsg.get("mem_no2") != null && !"".equals(printMemMsg.get("mem_no2"))) {
			sbMem.append("<div class='col-xs-6' >副卡2卡号:" + printMemMsg.get("mem_no2") + "</div>");
		}
		if (printMemMsg.get("mem_no3") != null && !"".equals(printMemMsg.get("mem_no3"))) {
			sbMem.append("<div class='col-xs-6' >副卡3卡号:" + printMemMsg.get("mem_no3") + "</div>");
		}
		if (printMemMsg.get("id_card") != null) {
			sbMem.append("<div class='col-xs-6' >身份证号:" + printMemMsg.get("id_card") + "</div>");
		}
		if (printMemMsg.get("create_time") != null) {
			sbMem.append("<div class='col-xs-6' >入会时间:" + printMemMsg.get("create_time").toString().substring(0, 16) + "</div>");
		}
		if (printMemMsg.get("mc_id") != null) {
			/*
			 * Entity mc = new EntityImpl("f_emp",this);
			 * mc.setValue("id",printMemMsg.get("mc_id")); mc.search();
			 */
			sbMem.append("<div class='col-xs-6' >会籍姓名:" + printMemMsg.get("mc_name") + "</div>");
		}
		if (printMemMsg.get("pt_id") != null) {
			/*
			 * Entity mc = new EntityImpl("f_emp",this);
			 * mc.setValue("id",printMemMsg.get("mc_id")); mc.search();
			 */
			sbMem.append("<div class='col-xs-6' >教练姓名:" + printMemMsg.get("pt_name") + "</div>");
		}

		return sbMem.toString();
	}

	/**
	 * 封装卡信息
	 * 
	 * @Title: getCardMsg
	 * @author: liul
	 * @date: 2017年7月14日上午9:46:53
	 * @param printCardMsg
	 * @param printMemMsg
	 * @return
	 */
	public String getCardMsg(Map<String, Object> printCardMsg, Map<String, Object> printMemMsg) {

		StringBuffer sbCard = new StringBuffer();
		if (printCardMsg.get("card_name") != null) {
			sbCard.append("<div class='col-xs-6' >卡名称:" + printCardMsg.get("card_name") + "</div>");
		}
		if (printCardMsg.get("days") != null) {
			sbCard.append("<div class='col-xs-6' >有效天数:" + printCardMsg.get("days") + "</div>");
		}
		/*if (printCardMsg.get("times") != null) {
			sbCard.append("<div class='col-xs-6' >有效次数:" + printCardMsg.get("times") + "</div>");
		}*/
		if (printCardMsg.get("amt") != null) {
			sbCard.append("<div class='col-xs-6' >储值金额:" + printCardMsg.get("amt") + "</div>");
		}
		if (printCardMsg.get("deadline") != null) {
			String deadline = changeDate(printCardMsg.get("deadline").toString());
			sbCard.append("<div class='col-xs-6' >到期时间:" + deadline + "</div>");
		}
		if (printCardMsg.get("active_time") != null) {
			String active_time = changeDate(printCardMsg.get("active_time").toString());
			sbCard.append("<div class='col-xs-6' >开卡时间:" + active_time + "</div>");
		}
		if (printCardMsg.get("buy_time") != null) {
			String buy_time = changeDate(printCardMsg.get("buy_time").toString());
			sbCard.append("<div class='col-xs-6' >充值时间:" + buy_time + "</div>");
		}
		/*
		 * if(printCardMsg.get("real_amt") != null){ sbCard.append(
		 * "<div class='col-xs-6' >实收金额:"
		 * +Utils.toPriceFromLongStr(printMemMsg.get("real_amt")+"")+"</div>");
		 * }
		 */
		
		if (printCardMsg.get("times") != null  && !"006".equals(printCardMsg.get("card_type"))) {
			sbCard.append("<div class='col-xs-6' >有效次数:" + printCardMsg.get("times") + "</div>");
		}
		if (printMemMsg.get("buy_times") != null && "006".equals(printCardMsg.get("card_type"))) {
			sbCard.append("<div class='col-xs-6' >有效课数:" + printMemMsg.get("buy_times") + "</div>");
		}
		if (printMemMsg.get("deadline") != null) {
			String deadline = changeDate(printMemMsg.get("deadline").toString());
			sbCard.append("<div class='col-xs-6' >到期时间:" + deadline + "</div>");
		}
		if (printMemMsg.get("active_time") != null) {
			String active_time = changeDate(printMemMsg.get("active_time").toString());
			sbCard.append("<div class='col-xs-6' >开卡时间:" + active_time + "</div>");
		}
		if (printMemMsg.get("buy_time") != null) {
			String buy_time = changeDate(printMemMsg.get("buy_time").toString());
			sbCard.append("<div class='col-xs-6' >购买时间:" + buy_time + "</div>");
		}
		if (printMemMsg.get("real_amt") != null) {
			sbCard.append("<div class='col-xs-6' >实收金额:" + Utils.toPriceFromLongStr(printMemMsg.get("real_amt") + "") + "元</div>");
		}
		if (printCardMsg.get("leave_free_times") != null) {
			sbCard.append("<div class='col-xs-6' >免费请假次数:" + printCardMsg.get("leave_free_times") + "</div>");
		}
		if ("Y".equals(printMemMsg.get("check_give_card"))) {
			// 选择了发卡
			if (printMemMsg.get("card_deposit_amt") != null && !"".equals(printMemMsg.get("card_deposit_amt"))) {
				sbCard.append("<div class='col-xs-6' >主卡押金:" + Utils.toPriceFromLongStr(printMemMsg.get("card_deposit_amt") + "") + "元</div>");
			}
			if (printMemMsg.get("card_deposit_amt1") != null && !"".equals(printMemMsg.get("card_deposit_amt1"))) {
				sbCard.append("<div class='col-xs-6' >副卡1押金:" + Utils.toPriceFromLongStr(printMemMsg.get("card_deposit_amt1") + "") + "元</div>");
			}
			if (printMemMsg.get("card_deposit_amt2") != null && !"".equals(printMemMsg.get("card_deposit_amt2"))) {
				sbCard.append("<div class='col-xs-6' >副卡2押金:" + Utils.toPriceFromLongStr(printMemMsg.get("card_deposit_amt2") + "") + "元</div>");
			}
			if (printMemMsg.get("card_deposit_amt3") != null && !"".equals(printMemMsg.get("card_deposit_amt3"))) {
				sbCard.append("<div class='col-xs-6' >副卡3押金:" + Utils.toPriceFromLongStr(printMemMsg.get("card_deposit_amt3") + "") + "元</div>");
			}
		}
		if (printMemMsg.get("give_days") != null && !"0".equals(printMemMsg.get("give_days"))) {
			if ("001".equals(printCardMsg.get("card_type"))) {
				sbCard.append("<div class='col-xs-6' >赠送时间:" + printMemMsg.get("give_days") + "天</div>");
			} else if ("002".equals(printCardMsg.get("card_type"))) {
				sbCard.append("<div class='col-xs-6' >赠送储值额度:" + printMemMsg.get("give_days") + "元</div>");
			} else if ("003".equals(printCardMsg.get("card_type"))) {
				sbCard.append("<div class='col-xs-6' >赠送次数:" + printMemMsg.get("give_days") + "次</div>");
			} else if ("006".equals(printCardMsg.get("card_type"))) {
				sbCard.append("<div class='col-xs-6' >赠送次数:" + printMemMsg.get("give_days") + "次</div>");
			}
		}

		if (!Utils.isNull(printMemMsg.get("give_card_id")) && !Utils.isNull(printMemMsg.get("give_times"))) {
			try {
				Entity en = new EntityImpl(this);
				int s = en.executeQuery("select card_name from f_card where id = ?", new Object[] { printMemMsg.get("give_card_id") });
				if (s > 0) {
					sbCard.append("<div class='col-xs-6' >赠送私教:" + en.getStringValue("card_name") + "</div>");
					sbCard.append("<div class='col-xs-6' >赠送私教次数:" + printMemMsg.get("give_times") + "次</div>");
				}

			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		/*
		 * if (printMemMsg.get("give_times") != null &&
		 * !"0".equals(printMemMsg.get("give_times"))) {
		 * sbCard.append("<div class='col-xs-6' >赠送次数:" +
		 * printMemMsg.get("give_times") + "次</div>"); } if
		 * (printMemMsg.get("give_amt") != null &&
		 * !"0".equals(printMemMsg.get("give_amt"))) {
		 * sbCard.append("<div class='col-xs-6' >赠送储值额度:" +
		 * printMemMsg.get("give_amt") + "元</div>"); }
		 */
		if (printMemMsg.get("remark") != null) {
			sbCard.append("<div class='col-xs-12' >购卡备注:" + printMemMsg.get("remark") + "</div>");
		}
		return sbCard.toString();
	}

	// 日期格式转换
	public String changeDate(String str) {
		String date = str.substring(0, 4) + "年";
		date += str.substring(5, 7) + "月";
		date += str.substring(8, 10) + "日";
		return date;
	}

	@Route(value = "/fit-cashier-query-gymSetByKey", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void gymSetByKey() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String cust_name = user.getCust_name();
		String gym = user.getViewGym();
		String key = this.getParameter("key");
		String code = this.getParameter("code");
		String value = SysSet.getValues(cust_name, gym, code, key, this.getConnection());
		this.obj.put("value", value);

	}

}
