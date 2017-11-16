package com.mingsokj.fitapp.m;

import java.io.Serializable;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.jinhua.server.db.Entity;
import com.jinhua.server.db.IDB;
import com.jinhua.server.db.impl.DBM;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.log.JhLog;

public class Gym implements Serializable {
	private static final long serialVersionUID = 1L;
	public String cust_name;
	public String gym;
	public String gymName;
	private String originalGym;
	public boolean canView = false;// 能否可见
	public boolean curShow = false;// 当前正在使用
	public boolean belongTo = false;
	public String logoUrl = "public/fit/images/logo.png";// 默认为公司logo
	public String addr;
	public String phone;
	public String awords;
	public int totalSmsNum;
	public int remainSmsNum;

	private Map<String, List<Map<String, Object>>> leaveInfos = new HashMap<>();// 所有请假信息
	private Map<String, List<Map<String, Object>>> cardsInfos = new HashMap<>();// 所有会员卡信息
	private Map<String, List<Map<String, Object>>> checkinInfos = new HashMap<>();// 所有入场信息

	/**
	 * 2.1 请假会员，销假时间是否到了如果到了自动销假<br/>
	 * 2.2 会员卡是否到期了，如果到期了自动修改状态为到期状态<br/>
	 * 2.3判断是否有预请假的时间到了，如果有自动修改状态为请假状态<br/>
	 * 2.4判断是否该自动出场了。
	 * 
	 * @param L
	 * @param conn
	 */
	private void process(Connection conn, JhLog L) throws Exception {
		/**
		 * <item code="001" note="激活" sort="1" /><br/>
		 * <item code="002" note="未激活" sort="2" /><br/>
		 * <item code="003" note="会籍跟踪" sort="3" /><br/>
		 * <item code="004" note="公共池" sort="4" /><br/>
		 * <item code="005" note="请假中" sort="5" /><br/>
		 * <item code="006" note="挂失中" sort="6" /><br/>
		 * <item code="007" note="转卡" sort="7" /><br/>
		 * <item code="008" note="退卡" sort="8" /><br/>
		 */
		// 查询所有买卡正式会员信息
		Entity en = new EntityImpl(conn, L);
		int size = en.executeQuery("select a.id,a.MEM_NAME,a.MEM_NO,a.PHONE,a.STATE from f_mem_" + cust_name + " a where a.gym=? and a.STATE in (?,?,?) ORDER BY a.CREATE_TIME", new String[] {this.gym, "001"/* 激活 */, "002"/* 未激活 */, "005"/* 请假中 */ });
		if (size > 0) {
			// 查询所有请假信息
			Entity leaveEntity = new EntityImpl(conn, L);
			int leaveSize = leaveEntity.executeQuery("select * from f_leave a where a.CUST_NAME=?", new String[] { cust_name });
			for (int i = 0; i < leaveSize; i++) {
				String mem_id = leaveEntity.getStringValue("mem_id", i);
				List<Map<String, Object>> li = leaveInfos.get(mem_id);
				if (li == null) {
					li = new ArrayList<>();
					leaveInfos.put(mem_id, li);
				}
				li.add(leaveEntity.getValues().get(i));
			}
			// 查询所有会员卡信息
			Entity cardsEntity = new EntityImpl(conn, L);
			int cardsSize = cardsEntity.executeQuery("select * from f_user_card_" + gym + " a ");
			for (int i = 0; i < cardsSize; i++) {
				String mem_id = cardsEntity.getStringValue("mem_id", i);
				List<Map<String, Object>> li = cardsInfos.get(mem_id);
				if (li == null) {
					li = new ArrayList<>();
					cardsInfos.put(mem_id, li);
				}
				li.add(cardsEntity.getValues().get(i));
			}

			// 如果现在是晚上12点到早上8点之间，需要处理自动出场
			Calendar now = Calendar.getInstance();
			int hour = now.get(Calendar.HOUR_OF_DAY);
			if (hour >= 22 || hour <= 8) {
				// 查询所有入场信息
				Entity checkinEntity = new EntityImpl(conn, L);
				int checkinSize = checkinEntity.executeQuery("select * from f_checkin_" + gym + " a where a.STATE=?", new String[] { "002" });
				for (int i = 0; i < checkinSize; i++) {
					String mem_id = checkinEntity.getStringValue("mem_id", i);
					List<Map<String, Object>> li = checkinInfos.get(mem_id);
					if (li == null) {
						li = new ArrayList<>();
						checkinInfos.put(mem_id, li);
					}
					li.add(checkinEntity.getValues().get(i));
				}
			}
			for (int i = 0; i < size; i++) {
				String id = en.getStringValue("id", i);
				String memName = en.getStringValue("mem_Name", i);
				String memNo = en.getStringValue("mem_No", i);
				String phone = en.getStringValue("phone", i);
				String state = en.getStringValue("STATE", i);
				Mem m = new Mem(id, memName, memNo, phone, state);
				m.checkTask(this, conn, L);
			}
		}
	}

	public void checkTask(String executeId, JhLog L) {
		new Thread(new Runnable() {
			@Override
			public void run() {
				long s = System.currentTimeMillis();
				IDB db = new DBM();
				Connection conn = null;
				try {
					conn = db.getConnection();
					conn.setAutoCommit(false);
					L.debug("客户【" + cust_name + "】门店【" + gym + "】-【" + gymName + "】开始检查会员状态(" + s + "):");
					process(conn, L);
					long end = System.currentTimeMillis();
					long es = end - s;
					L.debug("客户【" + cust_name + "】门店【" + gym + "】-【" + gymName + "】结束检查会员状态(" + s + "),.....................ok(" + es + "ms)");
					conn.commit();
				} catch (Exception e) {
					long end = System.currentTimeMillis();
					long es = end - s;
					L.error("客户【" + cust_name + "】门店【" + gym + "】-【" + gymName + "】结束检查会员状态(" + s + "),.....................not ok(" + es + "ms):");
					L.error(e);
				} finally {
					db.freeConnection(conn);
				}
			}
		}).start();
	}

	public Map<String, List<Map<String, Object>>> getLeaveInfos() {
		return leaveInfos;
	}

	public Map<String, List<Map<String, Object>>> getCardsInfos() {
		return cardsInfos;
	}

	public Map<String, List<Map<String, Object>>> getCheckinInfos() {
		return checkinInfos;
	}

	public String getOriginalGym() {
		if (this.originalGym == null) {
			this.originalGym = this.gym;
		}
		return originalGym;
	}

}