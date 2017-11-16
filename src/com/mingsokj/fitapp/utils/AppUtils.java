package com.mingsokj.fitapp.utils;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;
import java.util.WeakHashMap;

import org.json.JSONArray;
import org.json.JSONObject;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.c.Codes;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.IDB;
import com.jinhua.server.db.impl.DBM;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.Utils;

public class AppUtils extends BasicAction {

	private static final String UNIT = "万千佰拾亿千佰拾万千佰拾元角分";
	private static final String DIGIT = "零壹贰叁肆伍陆柒捌玖";
	private static final double MAX_VALUE = 9999999999999.99D;

	public static String change(String str) {
		double v = Double.parseDouble(str);
		if (v < 0 || v > MAX_VALUE) {
			return "参数非法!";
		}
		long l = Math.round(v * 100);
		if (l == 0) {
			return "零元整";
		}
		String strValue = l + "";
		// i用来控制数
		int i = 0;
		// j用来控制单位
		int j = UNIT.length() - strValue.length();
		String rs = "";
		boolean isZero = false;
		for (; i < strValue.length(); i++, j++) {
			char ch = strValue.charAt(i);
			if (ch == '0') {
				isZero = true;
				if (UNIT.charAt(j) == '亿' || UNIT.charAt(j) == '万' || UNIT.charAt(j) == '元') {
					rs = rs + UNIT.charAt(j);
					isZero = false;
				}
			} else {
				if (isZero) {
					rs = rs + "零";
					isZero = false;
				}
				rs = rs + DIGIT.charAt(ch - '0') + UNIT.charAt(j);
			}
		}
		if (!rs.endsWith("分")) {
			rs = rs + "整";
		}
		rs = rs.replaceAll("亿万", "亿");
		return rs;
	}

	@Route(value = "app-getWxParam", conn = true,m = HttpMethod.POST, type = ContentType.JSON)
	public void getWxParam() throws Exception {
		String cust_name = this.getParameter("cust_name");
		Entity en = new EntityImpl("yp_param", this);
		String sql = "select id,note from yp_param where code='wechat' and cust_name = ?";
		int size = en.executeQuery(sql, new String[] { cust_name });
		if (size > 0) {
			String note = en.getStringValue("note");
			this.obj.put("data", new JSONObject(note));
			this.obj.put("rs", "Y");
		}
	}

	public static JSONObject getWxParam(Connection conn, String cust_name) throws Exception {
		Entity en = new EntityImpl("yp_param", conn);
		JSONObject wechat = null;
		String sql = "select id,note from yp_param where code='wechat' and cust_name = ?";
		int size = en.executeQuery(sql, new String[] { cust_name });
		if (size > 0) {
			String note = en.getStringValue("note");
			wechat = new JSONObject(note);
		}
		return wechat;
	}

	public static List<Map<String, Object>> getCards(Connection conn, String gym, String id) throws Exception {
		long userDeadline = 0;
		Entity yp_type_user = new EntityImpl(conn);
		int s = yp_type_user.executeQuery("select a.id, a.TIMES,b.type_code,b.type_fee,b.card_type,b.type_name,a.deadline,a.sales_id,a.sales_name,a.sales_type from yp_type_user_" + gym + " a,yp_type b where a.type_code=b.type_code and a.mem_id=? and a.state=?", new String[] { id, "002" });
		if (s > 0) {
			for (int i = 0; i < s; i++) {
				Date deadline = yp_type_user.getDateValue("DEADLINE", i);
				if (deadline != null && deadline.getTime() > userDeadline) {
					userDeadline = deadline.getTime();
				}
			}
			for (int i = 0; i < s; i++) {
				String card_type = yp_type_user.getStringValue("card_type", i);
				String typeCard = Codes.note("CARD_TYPE", card_type);
				yp_type_user.getValues().get(i).put("card_typeStr", typeCard);
				// 计算剩余值
				if ("001".equals(card_type)) {// 天数卡
					long times = (userDeadline - System.currentTimeMillis());
					long days = times / (1000 * 60 * 24);
					yp_type_user.getValues().get(i).put("val", days + "天");
				} else if ("002".equals(card_type)) {// 储值卡
					yp_type_user.getValues().get(i).put("val", "");
				} else if ("003".equals(card_type)) {// 次数卡
					int times = yp_type_user.getIntegerValue("times", i);
					yp_type_user.getValues().get(i).put("val", times + "次");
				} else if ("004".equals(card_type)) {// 时间卡
					yp_type_user.getValues().get(i).put("val", "");
				} else if ("005".equals(card_type)) {// 单次入场卷
					yp_type_user.getValues().get(i).put("val", "");
				}
			}
		}
		return yp_type_user.getValues();

	}

	/**
	 * 获取卡代码
	 * 
	 * @return
	 * @throws Exception
	 */
	public static String getCardType_code(String cust_name) throws Exception {
		int num = 1;
		IDB db = new DBM();
		Connection conn = null;
		try {
			conn = db.getConnection();
			conn.setAutoCommit(false);
			Entity en = new EntityImpl(conn);
			String sql = "select  max(type_code+0) type_code from yp_type where CUST_NAME=? ";
			en.executeQuery(sql, new String[] { cust_name });
			String type_code = en.getStringValue("type_code");
			if (type_code != null && !"".equals(type_code)) {
				Float code = Float.parseFloat(type_code);
				num = code.intValue() + 1;
			}
			conn.commit();
		} catch (Exception e) {
			if (conn != null) {
				conn.rollback();
			}
			throw e;
		} finally {
			db.freeConnection(conn);
		}

		return Utils.leftPadding(num, 4, "0");
	}

	public static String getFive() throws Exception {
		Random rad = new Random();
		int result = rad.nextInt(100000);
		return Utils.leftPadding(result, 5, "0");
	}

	public static String getStringRandom(int length) {

		String val = "";
		Random random = new Random();

		// 参数length，表示生成几位随机数
		for (int i = 0; i < length; i++) {
			val += String.valueOf(random.nextInt(10));
		}
		return val.toUpperCase();
	}

	private static Map<String, String> gymNameInfo = new HashMap<>();
	private static Map<String, String> gymInfo = new HashMap<>();

	public static String gym2GymName(String gym, Connection conn) throws Exception {
		if (gymNameInfo.containsKey(gym)) {
			return gymNameInfo.get(gym);
		} else {
			gym2Cust(gym, conn);
			return gymNameInfo.get(gym);
		}
	}

	// 健身房的所有信息
	private static Map<String, Map<String, Object>> gymInfos = new WeakHashMap<>();

	public static String getCustName(String gym, Connection conn) throws Exception {
		Map<String, Object> m = getGymInfoByGym(gym, conn);
		return Utils.getMapStringValue(m, "cust_name");
	}

	public static String getGymName(String gym) throws Exception {
		IDB db = new DBM();
		Connection conn = null;
		try {
			conn = db.getConnection();
			conn.setAutoCommit(false);
			Map<String, Object> m = getGymInfoByGym(gym, conn);
			conn.commit();
			if (m == null) {
				return null;
			}
			return Utils.getMapStringValue(m, "gym_name");
		} catch (Exception e) {
			throw e;
		} finally {
			db.freeConnection(conn);
		}
	}

	/**
	 * 获取用户购买的卡种的通店铺组别 (时间卡)
	 * 
	 * @throws Exception
	 */
	public static String getgeneralStoreLevelByCard(String mem_id, String gym, Connection conn) throws Exception {
		String general_store_level = "";
		String sql = "select b.general_store_level,b.card_type from yp_type_user_" + gym + " a,yp_type b where a.type_code = b.type_code and a.mem_id=? and b.card_type in ( '001','002','003','004') ";
		Entity en = new EntityImpl(conn);
		int size = en.executeQuery(sql, new String[] { mem_id });
		if (size > 0) {
			for (int i = 0; i < size; i++) {
				String card_type = en.getStringValue("card_type", i);
				if ("001".equals(card_type)) {
					general_store_level = en.getStringValue("general_store_level", i);
					break;
				} else {
					general_store_level = en.getStringValue("general_store_level", i);
				}
			}
		}
		return general_store_level;
	}

	public static List<String> getGymBygeneralStoreLevel(String mem_id, String cust_name, String gym, Connection conn) throws Exception {
		List<String> list = new ArrayList<String>();
		list.add(gym);
		String general_store_level = getgeneralStoreLevelByCard(mem_id, gym, conn);
		if (general_store_level != null && !"".equals(general_store_level)) {
			Entity en = new EntityImpl(conn);
			String sql = "select gym,gym_level from yp_gym where cust_name=? ";
			int size = en.executeQuery(sql, new String[] { cust_name });
			if (size > 0) {
				for (int i = 0; i < size; i++) {
					String gym_level = en.getStringValue("gym_level", i);
					if (gym_level.contains(general_store_level) || general_store_level.contains(gym_level)) {
						list.add(en.getStringValue("gym", i));
					}
				}
			}
		}
		return list;
	}

	/**
	 * 获取健身房的可用卡种
	 * 
	 * @param gym
	 * @param conn
	 * @return
	 * @throws Exception
	 */
	public static List<Map<String, Object>> getGymUsableCards(String cust_name, String gym, Connection conn) throws Exception {
		List<Map<String, Object>> finalTypeList1 = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> finalTypeList2 = new ArrayList<Map<String, Object>>();

		/**
		 * 
		 */
		Entity en = new EntityImpl(conn);
		String sql = "select gym,gym_level from yp_gym where cust_name=?";
		en.executeQuery(sql, new String[] { cust_name });
		List<Map<String, Object>> levelList = en.getValues();

		en = new EntityImpl(conn);
		List<String> args = new ArrayList<String>();
		sql = "select * from yp_type where card_type<>'005' and state='001' and  cust_name=?";
		args.add(cust_name);
		// 如果card_type为空 则表示是直接购买会员卡
		en.executeQuery(sql, args.toArray());
		List<Map<String, Object>> typeList = en.getValues();

		/**
		 * 通店组别
		 */
		for (Map<String, Object> s : typeList) {
			String general_store_level = s.get("general_store_level") + "";
			String sclassgym = s.get("gym") + "";
			if (!"".equals(general_store_level) && general_store_level != null && !"null".equals(general_store_level)) {
				for (Map<String, Object> g : levelList) {
					String gym_level = g.get("gym_level") + "";
					if (gym_level.contains(general_store_level) || general_store_level.contains(gym_level)) {
						finalTypeList1.add(s);
						break;
					}
				}
			}
			if (sclassgym.equals(gym)) {
				finalTypeList1.add(s);
			}

		}
		/**
		 * 可见会所
		 */
		en = new EntityImpl(conn);
		sql = "select * from yp_type_gym where cust_name=?";
		en.executeQuery(sql, new String[] { cust_name });
		List<Map<String, Object>> typeGymList = en.getValues();
		for (Map<String, Object> s : typeList) {
			String typeCode = s.get("type_code") + "";
			String typegym = s.get("gym") + "";
			for (Map<String, Object> g : typeGymList) {
				String gymTypeCode = g.get("type_code") + "";
				if (typeCode.equals(gymTypeCode) && typegym.equals(gym)) {
					finalTypeList2.add(s);
				}
			}
		}
		Set<Map<String, Object>> set = new HashSet<Map<String, Object>>();
		set.addAll(finalTypeList1);
		set.addAll(finalTypeList2);
		ArrayList<Map<String, Object>> cardsList = new ArrayList<Map<String, Object>>(set);
		return cardsList;

	}

	public static String getAlleneral_store(String gym, Connection conn) throws Exception {
		Entity en = new EntityImpl(conn);
		// 查询当前gym的所属通店组别，
		String all = "";
		String sql = "select a.* from yp_gym a where gym=?";
		int size = en.executeQuery(sql, new String[] { gym });
		if (size > 0) {
			all = en.getStringValue("gym_level");// gym的所属通店组别
		}
		return convertString(all);
	}

	/**
	 * 
	 * @param cust_name
	 * @param gym
	 * @param conn
	 * @param type
	 *            私课还是团课, 为null 查询所有课程
	 * @param isFree
	 *            是否是免费团课,如果是私课,当前值不起作用
	 * @return
	 * @throws Exception
	 */
	public static List<Map<String, Object>> getGymUsableCourses(String cust_name, String gym, Connection conn, String type, boolean isFree) throws Exception {
		Entity en = new EntityImpl(conn);
		// 查询当前gym的所属通店组别，
		String all = "";
		String sql = "";
		List<Map<String, Object>> values = null;
		all = getAlleneral_store(gym, conn);
		en = new EntityImpl(conn);
		if (all.length() != 0) {
			if (type == null || type.length() == 0) {// 查询所有的课程
				sql = "select * from yp_private_plan where (general_store_level in(?) or gym=?) and state='001' and cust_name=?";
				en.executeQuery(sql, new String[] { all, gym, cust_name });
			} else {
				if ("002".equals(type)) {
					if (isFree) {// 免费团课
						sql = "select * from yp_private_plan where (general_store_level in(?) or gym=?) and state='001' and cust_name=? and lesson_type=? and (fee=0 or fee is null)";
					} else {// 付费团课
						sql = "select * from yp_private_plan where (general_store_level in(?) or gym=?) and state='001' and cust_name=? and fee>0  and lesson_type=?";
					}
				} else {// 私课
					sql = "select * from yp_private_plan where (general_store_level in(?) or gym=?) and state='001' and cust_name=? and lesson_type=?";
				}
				en.executeQuery(sql, new String[] { all, gym, cust_name, type });
			}
			values = en.getValues();
		} else {
			if (type == null || type.length() == 0) {
				sql = "select * from yp_private_plan where gym=? and state='001' and cust_name=?";
				en.executeQuery(sql, new String[] { gym, cust_name });
			} else {
				if ("002".equals(type)) {
					if (isFree) {// 免费团课
						sql = "select * from yp_private_plan where gym=? and state='001'  and cust_name=? and lesson_type=? and (fee=0 or fee is null)";
					} else {// 付费团课
						sql = "select * from yp_private_plan where gym=? and state='001'  and cust_name=? and lesson_type=? and fee>0";
					}
				} else {// 私课
					sql = "select * from yp_private_plan where gym=? and state='001'  and cust_name=? and lesson_type=?";
				}
				en.executeQuery(sql, new String[] { gym, cust_name, type });
			}
			values = en.getValues();
		}
		return values;

	}

	/**
	 * 1,2,3转化成'1','2','3'
	 * 
	 * @param str
	 * @return
	 */
	private static String convertString(String str) {
		String[] level = str.split(",");
		String newStr = "";
		for (int i = 0; i < level.length; i++) {
			newStr += "'" + level[i] + "',";
		}
		newStr = newStr.substring(0, newStr.length() - 1);
		return newStr;
	}

	public static void main(String[] args) {
		String str = "";
		System.out.println(convertString(str));
	}

	/**
	 * 获取健身房的所有信息
	 * 
	 * @param gym
	 * @param conn
	 */
	public static Map<String, Object> getGymInfoByGym(String gym, Connection conn) throws Exception {
		if (gymInfos.get(gym) == null) {
			Entity info = new EntityImpl(conn);
			String sql = "select a.* from yp_gym a where gym=?";
			int size = info.executeQuery(sql, new String[] { gym });
			if (size > 0) {
				Map<String, Object> vals = info.getValues().get(0);
				String gym_level = info.getStringValue("gym_level");
				String[] levels = gym_level.split(",");
				vals.put("levels", levels);
				gymInfos.put(gym, vals);
				return info.getValues().get(0);
			} else {
				return null;
			}
		} else {
			return gymInfos.get(gym);
		}
	}

	public static String gym2Cust(String gym, Connection conn) throws Exception {
		if (gymInfo.containsKey(gym)) {
			return gymInfo.get(gym);
		} else {
			Map<String, String> m = new HashMap<>();
			Entity en = new EntityImpl(conn);
			int size = en.executeQuery("select a.id,a.pid,a.gym,a.gym_name from yp_gym a");
			for (int i = 0; i < size; i++) {
				String pid = en.getStringValue("pid", i);
				String gymstr = en.getStringValue("gym", i);
				m.put(en.getStringValue("id", i), gymstr);
				if ("-1".equals(pid)) {
					gymInfo.put(gymstr, gymstr);
				}
				String gym_name = en.getStringValue("gym_name", i);
				gymNameInfo.put(gymstr, gym_name);
			}
			for (int i = 0; i < size; i++) {
				String pid = en.getStringValue("pid", i);
				if (!"-1".equals(pid)) {
					String gymstr = en.getStringValue("gym", i);
					gymInfo.put(gymstr, m.get(pid));
				}
			}
			if (gymInfo.containsKey(gym)) {
				return gymInfo.get(gym);
			} else {
				throw new Exception("错误的门店代码【" + gym + "】");
			}
		}
	}


	@Route(value = "AppUtils_getGYM", conn = true,m = HttpMethod.POST, type = ContentType.JSON)
	public void getGYM() throws Exception {
		String cust_name = request.getParameter("cust_name");
		JSONArray arr = new JSONArray();
		Entity en = new EntityImpl(this);
		int size = en.executeQuery("select gym code,gym_name note from yp_gym where cust_name=?", new String[] { cust_name });
		if (size > 0) {
			List<Map<String, Object>> gymList = en.getValues();
			for (Map<String, Object> map : gymList) {
				JSONObject obj = new JSONObject();
				obj.put("code", map.get("code"));
				obj.put("note", map.get("note"));
				arr.put(obj);
			}
		}
		this.obj.put("data", arr);
	}

	@Route(value = "AppUtils_getrole", conn = true,m = HttpMethod.POST, type = ContentType.JSON)
	public void getrole() throws Exception {
		String cust_name = request.getParameter("cust_name");
		JSONArray arr = new JSONArray();
		Entity en = new EntityImpl(this);
		int size = en.executeQuery("select code ,role_name note from sys_role where cust_name=?", new String[] { cust_name });
		if (size > 0) {
			List<Map<String, Object>> gymList = en.getValues();
			for (Map<String, Object> map : gymList) {
				JSONObject obj = new JSONObject();
				obj.put("code", map.get("code"));
				obj.put("note", map.get("note"));
				arr.put(obj);
			}
		}
		this.obj.put("data", arr);
	}

	private static Map<String, String> EMP_NAMES = new WeakHashMap<>();


	public static void checkUserDefaultPt(boolean forceReplace, String cust_name, String mem_id, String coach_id, Connection conn) throws Exception {
		boolean replace = forceReplace;
		if (!forceReplace) {
			Entity mem = new EntityImpl("yp_mem", conn);
			mem.setTablename("yp_mem_" + cust_name);
			mem.setValue("id", mem_id);
			int size = mem.search();
			if (size > 0) {
				String pt_id = mem.getStringValue("pt_id");
				if (!"".equals(pt_id)) {
					replace = false;
				} else {
					replace = true;
				}
			}
		}

		if (replace) {
			Entity emp = new EntityImpl("yp_emp", conn);
			emp.setValue("id", coach_id);
			int size = emp.search();
			if (size > 0) {
				String coach_name = emp.getStringValue("emp_name");

				Entity mem = new EntityImpl("yp_mem", conn);
				mem.setTablename("yp_mem_" + cust_name);
				mem.setValue("id", mem_id);
				mem.setValue("pt_id", coach_id);
				mem.setValue("pt_name", coach_name);
				mem.update();
			}
		}
	}
}
