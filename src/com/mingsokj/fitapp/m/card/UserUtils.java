package com.mingsokj.fitapp.m.card;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.jinhua.server.Action;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.IDB;
import com.jinhua.server.db.impl.DBM;
import com.jinhua.server.db.impl.EntityImpl;
import com.mingsokj.fitapp.m.FitUser;
import com.mingsokj.fitapp.m.Mem;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.utils.MemUtils;

public class UserUtils {

	private static Map<String, String> gymInfo = new HashMap<>();

	public static String getGymName(String gym, Connection conn) throws Exception {
		if (!gymInfo.containsKey(gym)) {
			Entity en = new EntityImpl(conn);
			int size = en.executeQuery("select a.GYM,a.GYM_NAME,a.CUST_NAME from f_gym a");
			for (int i = 0; i < size; i++) {
				gymInfo.put(en.getStringValue("gym", i), en.getStringValue("gym_name", i));
			}
		}
		if (gymInfo.containsKey(gym)) {
			return gymInfo.get(gym);
		} else {
			throw new Exception("错误的gym代码【" + gym + "】,系统里面找不到");
		}
	}

	public static String getGymName(String gym) throws Exception {
		IDB db = new DBM();
		Connection conn = null;
		try {
			conn = db.getConnection();
			conn.setAutoCommit(false);
			String gymName = getGymName(gym, conn);
			conn.commit();
			return gymName;
		} catch (Exception e) {
			throw e;
		} finally {
			db.freeConnection(conn);
		}
	}

	public static List<Map<String,Object>> getMemInfos(String key, Action act, FitUser user) throws Exception {
		List<Map<String,Object>> li = new ArrayList<>();
		StringBuilder sb = new StringBuilder();
		List<String> params = new ArrayList<>();

		sb.append("select a.id  from f_mem_");
		sb.append(user.getCust_name());
		sb.append(" a where a.phone like ? or a.mem_no like ? or a.mem_name like ? ");
		params.add(key + "%");
		params.add(key + "%");
		params.add(key + "%");
		Entity en = new EntityImpl(act);
		int size = en.executeQuery(sb.toString(), params.toArray(), 1, 5);

		if (size > 0) {
			for (int i = 0; i < size; i++) {
				MemInfo info = MemUtils.getMemInfo(en.getStringValue("id", i), user.getCust_name());
				li.add(info.toTitleMap());
			}
			return li;
		} else {
			return li;
		}
	}

	public static Mem getMemInfoByPhone(String phone, Action act, FitUser user) throws Exception {
		if (user == null || user.getLevelGyms().size() < 0) {
			throw new Exception("没有登陆？没有会员信息");
		}
		StringBuilder sb = new StringBuilder();
		List<String> params = new ArrayList<>();
		sb.append("select a.REMAIN_AMT,a.id,a.mem_name,a.MEM_NO,a.phone,a.PIC1, a.gym from f_mem_");
		sb.append(user.getCust_name());
		sb.append(" a where a.phone = ?");
		params.add(phone);
		Entity en = new EntityImpl(act);
		int size = en.executeQuery(sb.toString(), params.toArray(), 1, 1);
		if (size > 0) {
			Mem mem = new Mem();
			mem.setId(en.getStringValue("id"));
			mem.setMem_no(en.getStringValue("mem_no"));
			mem.setName(en.getStringValue("mem_name"));
			mem.setPhone(en.getStringValue("phone"));
			mem.setPicUrl(en.getStringValue("pic1"));
			mem.setGym(en.getStringValue("gym"));
			mem.setRemain_amt(en.getLongValue("remain_amt"));
			return mem;
		} else {
			throw new Exception("手机号码不存在");
		}
	}

	public static Mem getMemInfoByCardNo(String cardNo, Action act, FitUser user) throws Exception {
		if (user == null || user.getLevelGyms().size() < 0) {
			throw new Exception("没有登陆？没有会员信息");
		}
		StringBuilder sb = new StringBuilder();
		List<String> params = new ArrayList<>();
		sb.append("select a.REMAIN_AMT,a.id,a.mem_name,a.MEM_NO,a.phone,a.PIC1, a.gym from f_mem_");
		sb.append(user.getCust_name());
		sb.append(" a where a.mem_no = ?");
		params.add(cardNo);
		Entity en = new EntityImpl(act);
		int size = en.executeQuery(sb.toString(), params.toArray(), 1, 1);

		if (size > 0) {
			Mem mem = new Mem();
			mem.setId(en.getStringValue("id"));
			mem.setMem_no(en.getStringValue("mem_no"));
			mem.setName(en.getStringValue("mem_name"));
			mem.setPhone(en.getStringValue("phone"));
			mem.setPicUrl(en.getStringValue("pic1"));
			mem.setGym(en.getStringValue("gym"));
			mem.setRemain_amt(en.getLongValue("remain_amt"));
			return mem;
		} else {
			throw new Exception("手机号码不存在");
		}
	}

}
