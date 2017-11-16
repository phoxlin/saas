package com.mingsokj.fitapp.utils;

import java.sql.Connection;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.jinhua.server.db.Entity;
import com.jinhua.server.db.IDB;
import com.jinhua.server.db.impl.DBM;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.log.JhLog;
import com.jinhua.server.tools.RedisUtils;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.m.Cust;
import com.mingsokj.fitapp.m.Gym;
import com.mingsokj.fitapp.m.MemInfo;

import redis.clients.jedis.Jedis;

public class MemUtils {

	public static void main(String[] args) throws Exception {

	}

	public static List<MemInfo> getMemList(String[] ids, String cust_name, Connection conn) throws Exception {
		List<MemInfo> li = new ArrayList<>();
		if (ids.length > 0) {
			for (int i = 0; i < ids.length; i++) {
				String id = ids[i];
				MemInfo m = MemUtils.getMemInfo(id, cust_name);
				li.add(m);
			}
		}
		return li;
	}

	public static MemInfo getMemInfo(String id, String cust_name) throws Exception {
		JhLog L = new JhLog();
		return getMemInfo(id, cust_name, L);
	}

	public static MemInfo getMemInfoByWxOpenId(String wxOpenId, String cust_name, JhLog L, Connection conn) throws Exception {
		return queryMemInfo(conn, L, cust_name, wxOpenId, "wxOpenId");
	}

	public static MemInfo getMemInfo(String id, String cust_name, JhLog L, boolean getNew, Connection conn) throws Exception {
		Jedis jd = null;
		MemInfo mm = null;
		try {
			jd = RedisUtils.getConnection();
			MemInfo m = queryMemInfo(conn, L, cust_name, id, null);
			if (m != null) {
				RedisUtils.setHParam("MEM_" + m.getCust_name(), m.getId(), m, jd);
				RedisUtils.setHParam("MEM_GYM", m.getId(), m.getGym(), jd);
				RedisUtils.setHParam("MEM_CUST_NAME", m.getId(), m.getCust_name(), jd);
				mm = m;
			}
			return mm;
		} catch (Exception e) {
			throw e;
		} finally {
			RedisUtils.freeConnection(jd);
		}

	}

	public static MemInfo getMemInfo(String id, String cust_name, JhLog L) throws Exception {
		Jedis jd = null;
		MemInfo mm = null;
		Connection conn = null;
		IDB db = new DBM();
		try {
			jd = RedisUtils.getConnection();
			mm = (MemInfo) RedisUtils.getHParam("MEM_" + cust_name, id, jd);
			if (mm == null) {
				conn = db.getConnection();
				conn.setAutoCommit(false);
				MemInfo m = queryMemInfo(conn, L, cust_name, id, null);
				if (m != null) {
					RedisUtils.setHParam("MEM_" + m.getCust_name(), m.getId(), m, jd);
					RedisUtils.setHParam("MEM_GYM", m.getId(), m.getGym(), jd);
					RedisUtils.setHParam("MEM_CUST_NAME", m.getId(), m.getCust_name(), jd);
					mm = m;
				}
				conn.commit();
			}
			return mm;
		} catch (Exception e) {
			throw e;
		} finally {
			RedisUtils.freeConnection(jd);
			db.freeConnection(conn);
		}
	}

	private static MemInfo queryMemInfo(Connection conn, JhLog L, String cust_name, String id, String idType) throws Exception {
		String sql = "select a.update_time,a.pt_names, a.gym,a.pid,a.remark,a.imp_level,a.mc_id,a.addr,a.BIRTHDAY,a.ID_CARD,a.id,a.mem_name,a.sex,a.pic1,a.phone,a.mem_no,a.card_deposit_amt,a.wx_open_id,b.nickname,b.headurl,a.state,a.create_time from f_mem_" + cust_name + " a LEFT JOIN f_wx_cust_" + cust_name + " b on a.WX_OPEN_ID=b.WX_OPEN_ID  where a.id=?";
		if ("wxOpenId".equalsIgnoreCase(idType)) {
			sql = "select a.update_time,a.pt_names,a.gym,a.pid,a.remark,a.imp_level,a.mc_id,a.addr,a.BIRTHDAY,a.ID_CARD,a.id,a.mem_name,a.sex,a.pic1,a.phone,a.mem_no,a.card_deposit_amt,a.wx_open_id,b.nickname,b.headurl,a.state,a.create_time from f_mem_" + cust_name + " a LEFT JOIN f_wx_cust_" + cust_name + " b on a.WX_OPEN_ID=b.WX_OPEN_ID  where a.wx_open_id=?";
		}
		Entity entity = new EntityImpl(conn, L);
		int s = entity.executeQuery(sql, new String[] { id }, 1, 1);
		if (s > 0) {
			MemInfo m = new MemInfo();
			m.setPt_names(entity.getStringValue("pt_names"));
			m.setPid(entity.getStringValue("pid"));
			m.setMc_id(entity.getStringValue("mc_id"));
			m.setId(entity.getStringValue("id"));
			m.setMem_name(entity.getStringValue("mem_name"));
			m.setNickname(entity.getStringValue("nickname"));
			m.setWxHeadUrl(entity.getStringValue("headurl"));
			m.setPicUrl(entity.getStringValue("pic1"));
			m.setAddr(entity.getStringValue("addr"));
			m.setSex(entity.getStringValue("sex"));
			m.setBirthday(entity.getFormatStringValue("BIRTHDAY", "yyyy-MM-dd"));
			m.setIdCard(entity.getStringValue("ID_CARD"));
			m.setPhone(entity.getStringValue("phone"));
			m.setMem_no(entity.getStringValue("mem_no"));
			m.setCreate_time(entity.getFormatStringValue("create_time", "yyyy-MM-dd"));
			m.setUpdate_time(entity.getFormatStringValue("update_time", "yyyy-MM-dd"));
			String card_deposit_amt = entity.getStringValue("card_deposit_amt");

			if (!Utils.isNull(card_deposit_amt)) {
				m.setCard_deposit_amt(entity.getLongValue("card_deposit_amt"));
			} else {
				m.setCard_deposit_amt(0);
			}

			m.setWxOpenId(entity.getStringValue("wx_open_id"));
			m.setGym(entity.getStringValue("gym"));
			m.setCust_name(cust_name);
			m.setRemark(entity.getStringValue("remark"));
			m.setState(entity.getStringValue("state"));
			m.setImp_level(entity.getStringValue("imp_level"));
			Entity empList = new EntityImpl(conn, L);
			s = empList.executeQuery("select a.labels,a.summary ,a.PIC1,a.PIC2,a.PIC3 from f_emp a where a.cust_name=? and a.id=?", new String[] { cust_name, id }, 1, 1);
			if (s > 0) {
				String labels = empList.getStringValue("labels");
				String summary = empList.getStringValue("summary");
				m.setLabels(labels);
				m.setSummary(summary);
				m.setPic1(empList.getStringValue("pic1"));
				m.setPic2(empList.getStringValue("pic2"));
				m.setPic3(empList.getStringValue("pic3"));
				m.setEmp(true);
			} else {
				m.setEmp(false);
			}

			Entity en = new EntityImpl(conn);
			int size = en.executeQuery("select a.CUST_NAME,a.gym,a.GYM_NAME,a.PHONE,a.ADDR,a.AWORDS,a.TOTAL_SMS_NUM,a.REMAIN_SMS_NUM from f_gym a where a.cust_name=?", new String[] { cust_name });
			Cust cust = new Cust();
			cust.cust_name = cust_name;
			if (size > 0) {
				for (int i = 0; i < size; i++) {
					Gym gym = new Gym();
					String g = en.getStringValue("gym", i);
					String gymName = en.getStringValue("gym_name", i);
					String phone = en.getStringValue("phone", i);
					String addr = en.getStringValue("addr", i);
					String awords = en.getStringValue("AWORDS", i);
					int total_sms_num = en.getIntegerValue("TOTAL_SMS_NUM", i);
					int remain_sms_num = en.getIntegerValue("REMAIN_SMS_NUM", i);
					gym.cust_name = cust_name;
					gym.gym = g;
					gym.gymName = gymName;
					gym.phone = phone;
					gym.addr = addr;
					gym.awords = awords;
					gym.totalSmsNum = total_sms_num;
					gym.remainSmsNum = remain_sms_num;
					cust.viewGyms.add(gym);
				}
			}
			m.setCust(cust);
			return m;
		} else {
			return null;
		}
	}

	/**
	 * 根据 f_user_card ID 查询卡片
	 * 
	 * @param fk_card_id
	 * @param fk_user_id
	 * @param cust_name
	 * @param gym
	 * @return
	 * @throws Exception
	 */
	public static Map<String, Object> getMemCardsById(String fk_card_id, String fk_user_id, String cust_name, String gym) throws Exception {
		Map<String, Object> cardMap = null;
		List<Map<String, Object>> cardList = getMemCards(fk_user_id, cust_name, gym);
		for (Map<String, Object> card : cardList) {
			String card_id = card.get("id") + "";
			if (fk_card_id.equals(card_id)) {
				cardMap = card;
			}
		}
		return cardMap;
	}

	/**
	 * 根据 f_card ID 查询卡片
	 * 
	 * @param fk_card_id
	 * @param fk_user_id
	 * @param cust_name
	 * @param gym
	 * @return
	 * @throws Exception
	 */
	public static Map<String, Object> getMemCardsByCardId(String fk_card_id, String fk_user_id, String cust_name, String gym) throws Exception {
		Map<String, Object> cardMap = null;
		List<Map<String, Object>> cardList = getMemCards(fk_user_id, cust_name, gym);
		for (Map<String, Object> card : cardList) {
			String card_id = card.get("card_id") + "";
			if (fk_card_id.equals(card_id)) {
				cardMap = card;
			}
		}
		return cardMap;
	}

	/**
	 * 根据 f_card ID 查询所有卡片
	 * 
	 * @param fk_card_id
	 * @param fk_user_id
	 * @param cust_name
	 * @param gym
	 * @return
	 * @throws Exception
	 */
	public static List<Map<String, Object>> getAllMemCardsByCardId(String fk_card_id, String fk_user_id, String cust_name, String gym) throws Exception {
		List<Map<String, Object>> cards = new ArrayList<>();
		List<Map<String, Object>> cardList = getMemCards(fk_user_id, cust_name, gym);
		for (Map<String, Object> card : cardList) {
			String card_id = card.get("card_id") + "";
			if (fk_card_id.equals(card_id)) {
				cards.add(card);
			}
		}
		return cards;
	}

	public static List<Map<String, Object>> getMemCards(String id, String cust_name, String gym) throws Exception {
		JhLog L = new JhLog();
		return getMemCards(id, gym, cust_name, L);
	}

	public static List<Map<String, Object>> getMemCardsByOldCard(String id, String gym, String cust_name, JhLog L) throws Exception {
		if (Utils.isNull(id) || Utils.isNull(gym)) {
			throw new Exception("获取会员信息时id 或者 gym不能为空");
		}
		Connection conn = null;
		IDB db = new DBM();
		try {
			conn = db.getConnection();
			conn.setAutoCommit(false);
			List<Map<String, Object>> cardList = new ArrayList<Map<String, Object>>();
			Entity en = new EntityImpl(conn, L);
			int size = en.executeQuery("select gym from f_gym where cust_name=?", new Object[] { cust_name });

			ArrayList<String> parList = new ArrayList<String>();

			StringBuilder sql = new StringBuilder();
			if (size > 0) {
				for (int i = 0; i < size; i++) {
					String now_gym = en.getStringValue("gym", i);
					sql.append("select a.id,a.CUST_NAME,a.gym,a.CARD_ID,a.MEM_ID,a.ACTIVE_TIME,a.DEADLINE,a.mc_id,a.remain_times,a.buy_time,a.pt_id,a.state,a.real_amt," + "b.count,b.checkin_fee,b.card_name,b.card_type,b.id card_id,b.leave_free_times,b.leave_unit,b.leave_unit_price,b.times,b.times,b.days,'" + now_gym + "' now_gym " + "from f_user_card_" + now_gym + "  a,f_card b,f_card_gym c  where a.card_id = b.id and b.id = c.fk_card_id and c.view_gym='" + gym + "' and a.mem_id=? and a.state in ('007','008','009')");

					if (size - 1 != i) {
						sql.append(" union all ");
					}
					parList.add(id);
				}
				en = new EntityImpl(conn, L);
				size = en.executeQuery(sql.toString(), parList.toArray());

				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				if (size > 0) {
					String now = Utils.parseData(new Date(), "yyyy-MM-dd");
					for (int i = 0; i < en.getResultCount(); i++) {

						String now_gym = en.getStringValue("now_gym", i);
						String state = en.getStringValue("state", i);
						String active_time = en.getStringValue("active_time", i);
						String deadline = en.getStringValue("deadline", i);

						if (!Utils.isNull(active_time)) {
							en.getValues().get(i).put("active_time", sdf.format(Utils.parse2Date(active_time, "yyyy-MM-dd")));
						} else {
							en.getValues().get(i).put("active_time", "");
						}
						if (!Utils.isNull(deadline)) {
							en.getValues().get(i).put("deadline", sdf.format(Utils.parse2Date(deadline, "yyyy-MM-dd")));
						}
						// 教练
						String pt_id = en.getStringValue("pt_id", i);
						if (!Utils.isNull(pt_id)) {
							MemInfo mem = MemUtils.getMemInfo(pt_id, cust_name);
							en.getValues().get(i).put("pt_name", mem.getName());
						}
						// 会籍
						String mc_id = en.getStringValue("mc_id", i);
						if (!Utils.isNull(mc_id)) {
							MemInfo mem = MemUtils.getMemInfo(mc_id, cust_name);
							en.getValues().get(i).put("mc_name", mem.getName());
						}
						en.getValues().get(i).put("now_gym", now_gym);
						cardList.add(en.getValues().get(i));
					}

				}

			}

			conn.commit();
			return sortCards(cardList);
		} catch (Exception e) {
			throw e;
		} finally {
			db.freeConnection(conn);
		}
	}

	public static List<Map<String, Object>> getMemCards(String id, String gym, String cust_name, JhLog L) throws Exception {
		if (Utils.isNull(id) || Utils.isNull(gym)) {
			throw new Exception("获取会员信息时id 或者 gym不能为空");
		}
		Connection conn = null;
		IDB db = new DBM();
		try {
			conn = db.getConnection();
			conn.setAutoCommit(false);
			List<Map<String, Object>> cardList = new ArrayList<Map<String, Object>>();
			Entity en = new EntityImpl(conn, L);
			int size = en.executeQuery("select gym from f_gym where cust_name=?", new Object[] { cust_name });

			ArrayList<String> parList = new ArrayList<String>();

			StringBuilder sql = new StringBuilder();
			if (size > 0) {
				for (int i = 0; i < size; i++) {
					String now_gym = en.getStringValue("gym", i);
					sql.append("select a.remark,a.leave_times,a.id,a.CUST_NAME,a.gym,a.CARD_ID,a.MEM_ID,a.ACTIVE_TIME,a.DEADLINE,a.mc_id,a.remain_times,a.buy_time,a.pt_id,a.state,a.real_amt," + "b.count,b.checkin_fee,b.card_name,b.card_type,b.id card_id,b.leave_free_times,b.leave_unit,b.leave_unit_price,b.times,b.times,b.days,b.is_fanmily,'" + now_gym + "' now_gym " + "from f_user_card_" + now_gym + "  a,f_card b,f_card_gym c  where a.card_id = b.id and b.id = c.fk_card_id and c.view_gym='" + gym + "' and a.mem_id=? and a.state in('001','002','004','006')");
					if (size - 1 != i) {
						sql.append(" union all ");
					}
					parList.add(id);
				}
				en = new EntityImpl(conn, L);
				size = en.executeQuery(sql.toString(), parList.toArray());

				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				if (size > 0) {
					String now = Utils.parseData(new Date(), "yyyy-MM-dd");
					for (int i = 0; i < en.getResultCount(); i++) {

						String state = en.getStringValue("state", i);
						String active_time = en.getStringValue("active_time", i);
						String deadline = en.getStringValue("deadline", i);

						if (!Utils.isNull(active_time)) {
							en.getValues().get(i).put("active_time", sdf.format(Utils.parse2Date(active_time, "yyyy-MM-dd")));
						} else {
							en.getValues().get(i).put("active_time", "");
						}
						if (!Utils.isNull(deadline)) {
							en.getValues().get(i).put("deadline", sdf.format(Utils.parse2Date(deadline, "yyyy-MM-dd")));
							if (Utils.parse2Date(deadline, "yyyy-MM-dd").after(Utils.parse2Date(now, "yyyy-MM-dd"))) {
								cardList.add(en.getValues().get(i));
							}
						} else {
							en.getValues().get(i).put("deadline", "");
							if ("002".equals(state)) {
								cardList.add(en.getValues().get(i));
							}
						}
						// 教练
						String pt_id = en.getStringValue("pt_id", i);
						if (!Utils.isNull(pt_id)) {
							MemInfo mem = MemUtils.getMemInfo(pt_id, cust_name);
							en.getValues().get(i).put("pt_name", mem.getName());
						}
						// 会籍
						String mc_id = en.getStringValue("mc_id", i);
						if (!Utils.isNull(mc_id)) {
							MemInfo mem = MemUtils.getMemInfo(mc_id, cust_name);
							en.getValues().get(i).put("mc_name", mem.getName());
						}
					}

				}

			}

			conn.commit();
			return sortCards(cardList);
		} catch (Exception e) {
			throw e;
		} finally {
			db.freeConnection(conn);
		}
	}

	public static List<Map<String, Object>> sortCards(List<Map<String, Object>> cards) {
		List<Map<String, Object>> list001 = new ArrayList<>();
		List<Map<String, Object>> list002 = new ArrayList<>();
		List<Map<String, Object>> list003 = new ArrayList<>();
		List<Map<String, Object>> list004 = new ArrayList<>();
		List<Map<String, Object>> list005 = new ArrayList<>();
		List<Map<String, Object>> list006 = new ArrayList<>();
		/**
		 * <data type="CARD_TYPE" note="卡种类型" canedit="Y" ispublic="N"><br/>
		 * <item code="001" note="天数卡" sort="1" /><br/>
		 * <item code="002" note="储值卡" sort="2" /><br/>
		 * <item code="003" note="次数卡" sort="3" /><br/>
		 * <item code="004" note="计时卡" sort="4" /><br/>
		 * <item code="005" note="单次入场卷" sort="5" /><br/>
		 * <item code="006" note="私教课程" sort="5" /><br/>
		 * </data><br/>
		 */

		for (int i = 0; i < cards.size(); i++) {
			Map<String, Object> m = cards.get(i);
			String card_type = Utils.getMapStringValue(m, "card_type");
			if ("001".equals(card_type)) {
				list001.add(m);
			} else if ("002".equals(card_type)) {
				list002.add(m);
			} else if ("003".equals(card_type)) {
				list003.add(m);
			} else if ("004".equals(card_type)) {
				list004.add(m);
			} else if ("005".equals(card_type)) {
				list005.add(m);
			} else if ("006".equals(card_type)) {
				list006.add(m);
			}
		}
		list001.addAll(list003);
		list001.addAll(list002);
		list001.addAll(list004);
		list001.addAll(list005);
		list001.addAll(list006);
		return list001;
	}
}
