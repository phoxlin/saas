package com.mingsokj.fitapp.task;

import java.sql.Connection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

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

public class InitFit implements Runnable {

	public InitFit() {
		run();
	}

	@Override
	public void run() {
		JhLog L = new JhLog();
		IDB db = new DBM();
		Connection conn = null;
		Jedis jd = null;
		try {
			conn = db.getConnection();
			conn.setAutoCommit(false);
			jd = RedisUtils.getConnection();
			int totalMem = 0;
			L.info("开始加载会员至redis");
			if (jd != null) {
				Entity en = new EntityImpl(conn, L);
				Entity entity = new EntityImpl(conn, L);
				int size = en.executeQuery("select a.CUST_NAME,a.gym,a.GYM_NAME,a.PHONE,a.ADDR,a.AWORDS,a.TOTAL_SMS_NUM,a.REMAIN_SMS_NUM from f_gym a");
				Map<String, String> gyms = new HashMap<>();
				Set<String> custs = new HashSet<>();
				Map<String, Cust> custInfo = new HashMap<>();
				if (size > 0) {
					for (int i = 0; i < size; i++) {
						Gym gym = new Gym();
						String CUST_NAME = en.getStringValue("CUST_NAME", i);
						Cust cust = custInfo.get(CUST_NAME);
						if (cust == null) {
							cust = new Cust();
							custInfo.put(CUST_NAME, cust);
							cust.cust_name = CUST_NAME;
						}
						String g = en.getStringValue("gym", i);
						String gymName = en.getStringValue("gym_name", i);
						String phone = en.getStringValue("phone", i);
						String addr = en.getStringValue("addr", i);
						String awords = en.getStringValue("AWORDS", i);
						int total_sms_num = en.getIntegerValue("TOTAL_SMS_NUM", i);
						int remain_sms_num = en.getIntegerValue("REMAIN_SMS_NUM", i);
						gym.cust_name = CUST_NAME;
						gym.gym = g;
						gym.gymName = gymName;
						gym.phone = phone;
						gym.addr = addr;
						gym.awords = awords;
						gym.totalSmsNum = total_sms_num;
						gym.remainSmsNum = remain_sms_num;
						cust.viewGyms.add(gym);
						gyms.put(g, CUST_NAME);
						custs.add(CUST_NAME);
						RedisUtils.setHParam("GYM", g, gym, jd);
						RedisUtils.setHParam("CUST_NAME", g, CUST_NAME, jd);

					}
				}

				int pageSize = 5000;

				for (String cust_name : custs) {
					Entity empList = new EntityImpl(conn, L);
					int s = empList.executeQuery("select * from f_emp a where a.cust_name=?", new String[] { cust_name });
					Map<String, Map<String, Object>> empInfos = new HashMap<>();
					if (s > 0) {
						for (int i = 0; i < s; i++) {
							String id = empList.getStringValue("id", i);
							empInfos.put(id, empList.getValues().get(i));
						}
					}
					try {
						int s1 = entity.executeQuery("select count(id) total from f_mem_" + cust_name + "");
						if (s1 > 0) {
							totalMem = entity.getIntegerValue("total");
							L.info("会所" + cust_name + "会员数量" + totalMem);
							if (totalMem > 0) {
								int curPage = 1;
								int totalPage = totalMem % pageSize == 0 ? totalMem / pageSize : totalMem / pageSize + 1;
								String sql = "select a.pt_names, a.gym,a.pid,a.remark,a.imp_level,a.mc_id,a.addr,a.BIRTHDAY,a.ID_CARD,a.id,a.mem_name,a.sex,a.pic1,a.phone,a.mem_no,a.card_deposit_amt,a.wx_open_id,b.nickname,b.headurl,a.state,a.create_time  from f_mem_" + cust_name + " a LEFT JOIN f_wx_cust_" + cust_name + " b on a.WX_OPEN_ID=b.WX_OPEN_ID";
								for (; curPage <= totalPage; curPage++) {
									s1 = entity.executeQuery(sql, new Object[] {}, (curPage - 1) * pageSize + 1, curPage * pageSize);
									if (s1 > 0) {
										L.info("会所" + cust_name + "开始第" + curPage + "次加载,会员数量:" + s1);
										for (int k = 0; k < s1; k++) {
											MemInfo m = new MemInfo();
											m.setPt_names(entity.getStringValue("pt_names",k));
											m.setPid(entity.getStringValue("pid", k));
											m.setAddr(entity.getStringValue("addr"));
											m.setId(entity.getStringValue("id", k));
											m.setMem_name(entity.getStringValue("mem_name", k));
											m.setNickname(entity.getStringValue("nickname", k));
											m.setWxHeadUrl(entity.getStringValue("headurl", k));
											m.setPicUrl(entity.getStringValue("pic1", k));
											m.setSex(entity.getStringValue("sex", k));
											m.setBirthday(entity.getFormatStringValue("BIRTHDAY", "yyyy-MM-dd", k));
											m.setIdCard(entity.getStringValue("ID_CARD", k));

											m.setPhone(entity.getStringValue("phone", k));
											m.setAddr(entity.getStringValue("addr", k));
											m.setMem_no(entity.getStringValue("mem_no", k));
											String card_deposit_amt = entity.getStringValue("card_deposit_amt",k);
											if (!Utils.isNull(card_deposit_amt)) {
												m.setCard_deposit_amt(entity.getLongValue("card_deposit_amt",k));
											} else {
												m.setCard_deposit_amt(0);
											}
											m.setWxOpenId(entity.getStringValue("wx_open_id", k));
											m.setMc_id(entity.getStringValue("mc_id", k));
											m.setGym(entity.getStringValue("gym", k));
											m.setCust_name(cust_name);
											m.setRemark(entity.getStringValue("remark", k));
											m.setState(entity.getStringValue("state", k));
											m.setImp_level(entity.getStringValue("imp_level", k));
											// 判断是否是员工

											Map<String, Object> emp = empInfos.get(m.getId());
											if (emp != null && emp.size() > 0) {
												String labels = Utils.getMapStringValue(emp, "labels");
												String summary = Utils.getMapStringValue(emp, "summary");
												m.setLabels(labels);
												m.setSummary(summary);
												m.setEmp(true);
												m.setPic1(Utils.getMapStringValue(emp, "pic1"));
												m.setPic2(Utils.getMapStringValue(emp, "pic2"));
												m.setPic3(Utils.getMapStringValue(emp, "pic3"));
											} else {
												m.setEmp(false);
											}
											m.setCust(custInfo.get(cust_name));
											RedisUtils.setHParam("MEM_" + m.getCust_name(), m.getId(), m, jd);
											RedisUtils.setHParam("MEM_GYM", m.getId(), m.getGym(), jd);
											RedisUtils.setHParam("MEM_CUST_NAME", m.getId(), m.getCust_name(), jd);
										}
									}
								}

							}
						}
						// s1 = entity.executeQuery("select
						// a.imp_level,a.mc_id,a.addr,a.BIRTHDAY,a.ID_CARD,a.id,a.mem_name,a.sex,a.pic1,a.phone,a.mem_no,a.mem_no1,a.mem_no2,a.mem_no3,a.card_deposit_amt,a.card_deposit_amt1,a.card_deposit_amt2,a.card_deposit_amt3,a.wx_open_id,b.nickname,b.headurl,a.state
						// from f_mem_" + g + " a LEFT JOIN f_wx_cust_" +
						// cust_name + " b on a.WX_OPEN_ID=b.WX_OPEN_ID");
					} catch (Exception e) {
					}
				}
				conn.commit();
				L.info("加载完毕,总共" + totalMem + "条会员数据");
			} else {
				L.error("Redis 服务器连接出错，请检查。。");
			}
		} catch (Exception e) {
			L.error(e);
		} finally {
			db.freeConnection(conn);
			RedisUtils.freeConnection(jd);
		}

	}

}
