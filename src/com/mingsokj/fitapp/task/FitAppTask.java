package com.mingsokj.fitapp.task;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;

import com.jinhua.Task;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.tools.RedisUtils;
import com.mingsokj.fitapp.m.Gym;

import redis.clients.jedis.Jedis;

public class FitAppTask extends Task {
	/**
	 * 自动销假
	 */
	/**
	 * 会员卡自动到期
	 */
	/**
	 * 请假时间到了 会员卡状态和会员状态变成已经请假
	 * 自动出场
	 */

	@Override
	public String execute(String executeId, Connection conn) throws Exception {
		/**
		 * 每天每4个小时全客户，全门店检查一次，步骤：<br/>
		 * 1.查询当前所有客户，及所有门店信息<br/>
		 * 2.按照各个门店为单位，进行会员状态检查。具体检查内容：<br/>
		 * 2.1 请假会员，销假时间是否到了如果到了自动销假<br/>
		 * 2.2 会员卡是否到期了，如果到期了自动修改状态为到期状态<br/>
		 * 2.3判断是否有预请假的时间到了，如果有自动修改状态为请假状态<br/>
		 * 2.4判断是否该自动出场了。
		 * 
		 */

		/**
		 * 查询所有门店信息顺便，更新下系统的门店缓存
		 */
		Jedis jd = null;
		try {
			jd = RedisUtils.getConnection();
			Entity en = new EntityImpl(conn, L);
			int size = en.executeQuery("select a.CUST_NAME,a.gym,a.GYM_NAME,a.PHONE,a.ADDR,a.AWORDS,a.TOTAL_SMS_NUM,a.REMAIN_SMS_NUM from f_gym a");
			if (size > 0) {
				List<Gym> gyms = new ArrayList<Gym>();
				for (int i = 0; i < size; i++) {
					Gym gym = new Gym();
					String CUST_NAME = en.getStringValue("CUST_NAME", i);
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
					gyms.add(gym);
					RedisUtils.setHParam("GYM", g, gym, jd);
				}
				// 每个门店自己处理自己的数据检查
				for (int i = 0; i < gyms.size(); i++) {
					Gym g = gyms.get(i);
					g.checkTask(executeId, L);
				}
			}
		} catch (Exception e) {
			throw e;
		} finally {
			RedisUtils.freeConnection(jd);
		}
		return null;
	}

	/**
	 * 每隔4小时执行一次
	 */
	@Override
	public String getRegulation() {
		return "0 0 0/4 * * ? ";
		// return "0 0/1 * * * ? ";// 测试用每分钟执行一次
	}
}
