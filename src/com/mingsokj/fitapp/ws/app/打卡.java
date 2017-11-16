package com.mingsokj.fitapp.ws.app;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.Resources;
import com.jinhua.server.wx.Wx;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.utils.MemUtils;

public class 打卡 extends BasicAction {

	@Route(value = "/fit-app-action-sign-query", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void sign_query() throws Exception {
		String cust_name = request.getParameter("cust_name");
		String gym = request.getParameter("gym");
		String user_id = request.getParameter("user_id");

		// 查询会员属于哪个会所的
		MemInfo m = MemUtils.getMemInfo(user_id, cust_name);
		String userGym = m.getGym();

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date now = new Date();
		Calendar c = Calendar.getInstance();
		String firstday, lastday;
		if (userGym == null || "".equals(userGym)) {
			userGym = gym;
		}
		c.add(Calendar.MONTH, 0);
		c.set(Calendar.DAY_OF_MONTH, 1);

		firstday = sdf.format(c.getTime()) + " 00:00:00";
		// 获取前月的最后一天
		c = Calendar.getInstance();
		c.add(Calendar.MONTH, 1);
		c.set(Calendar.DAY_OF_MONTH, 0);
		lastday = sdf.format(c.getTime()) + " 23:59:59";

		Entity en = new EntityImpl(this);
		int s = en.executeQuery(
				"select user_id,count(id) count,max(sign_time) time from f_sign_month_" + userGym
						+ " where user_id = ? and sign_time between ? and ?",
				new Object[] { user_id, firstday, lastday });
		if (s > 0) {
			Integer count = en.getIntegerValue("count");
			if (count == null) {
				count = 0;
			}
			Date time = en.getDateValue("time");
			this.obj.put("sign_in", "N");
			if (time != null) {
				if (sdf.format(now).equals(sdf.format(time))) {
					this.obj.put("sign_in", "Y");
				}
			}
			this.obj.put("sign_count", count);
		}
	}

	@Route(value = "/fit-app-action-sign-in", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void sign_in() throws Exception {
		String cust_name = request.getParameter("cust_name");
		String gym = request.getParameter("gym");
		String user_id = request.getParameter("user_id");

		// 查询会员属于哪个会所的
		MemInfo m = MemUtils.getMemInfo(user_id, cust_name);
		String userGym = m.getGym();

		Entity en = new EntityImpl("f_sign_month", this);
		en.setTablename("f_sign_month_" + userGym);
		en.setValue("user_id", user_id);
		en.setValue("cust_name", cust_name);
		en.setValue("gym", gym);
		en.setValue("sign_time", new Date());
		String id = en.create();
		this.obj.put("id", id);
	}

	@Route(value = "/fit-app-action-sign-user-record", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void sign_in_rank_reocrd() throws Exception {
		String gym = request.getParameter("gym");
		String userGym = request.getParameter("userGym");
		String user_id = request.getParameter("user_id");

		if (userGym == null || "".equals(userGym)) {
			userGym = gym;
		}

		Entity en = new EntityImpl(this);
		int s = en.executeQuery("select * from f_sign_month_" + userGym + " where user_id = ? order by sign_time asc",
				new Object[] { user_id });
		if (s > 0) {
			this.obj.put("list", en.getValues());
		}

	}

	@Route(value = "/fit-app-action-sign-rank", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void sign_in_rank() throws Exception {
		String cust_name = request.getParameter("cust_name");
		String gym = request.getParameter("gym");
		String user_id = request.getParameter("user_id");

		MemInfo m = MemUtils.getMemInfo(user_id, cust_name);
		String userGym = m.getGym();

		Entity en = new EntityImpl(this);
		String sql = "select a.count,b.id from (select user_id,count(id) count,min(sign_time) sign_time from f_sign_month_"
				+ gym + " group by user_id) a,f_mem_" + cust_name
				+ " b where a.user_id = b.id order by a.count desc,a.sign_time asc";
		int s = en.executeQuery(sql, new Object[] {}, 1, 50);
		if (s > 0) {
			for (int i = 0; i < s; i++) {
				String id = en.getStringValue("id", i);
				// pic_url

				MemInfo info = MemUtils.getMemInfo(id, cust_name, L);
				en.getValues().get(i).put("mem_name", info.getName());
				en.getValues().get(i).put("pic_url", info.getWxHeadUrl());
			}
			this.obj.put("list", en.getValues());
		}
		this.obj.put("userGym", userGym);
		this.obj.put("headUrl", m.getWxHeadUrl());
	}

	// 打卡并发布圈圈
	@Route(value = "/fit-app-action-sign-write-remark", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void sign_in_rank_remark() throws Exception {
		String remark = request.getParameter("remark");
		String cust_name = request.getParameter("cust_name");
		String gym = request.getParameter("gym");
		String userGym = request.getParameter("userGym");
		String user_id = request.getParameter("user_id");
		String user_name = request.getParameter("user_name");
		String sendToQQ = request.getParameter("sendToQQ");
		String sign_imgs = request.getParameter("sign_imgs");

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		if (userGym == null || "".equals(userGym)) {
			userGym = gym;
		}
		Entity en = new EntityImpl(this);
		int s = en.executeQuery("select id,max(sign_time) time from f_sign_month_" + userGym + " where user_id = ? ",
				new Object[] { user_id });
		Date now = new Date();
		if (s > 0) {
			Date time = en.getDateValue("time");
			if (time != null && !"".equals(time)) {
				if (sdf.format(now).equals(sdf.format(time))) {
					throw new Exception("今天已经打过卡了");
				}
			}
		}
		MemInfo m = MemUtils.getMemInfo(user_id, cust_name);
		Entity e = new EntityImpl("f_sign_month", this);
		e.setTablename("f_sign_month_" + m.getGym());
		e.setValue("user_id", user_id);
		e.setValue("cust_name", cust_name);
		e.setValue("gym", gym);
		e.setValue("remark", remark);
		e.setValue("sign_time", new Date());
		e.create();

		if ("true".equals(sendToQQ)) {
			en = new EntityImpl("f_interact", this);
			en.setValue("cust_name", cust_name);
			en.setValue("gym", gym);
			en.setValue("auth_type", "001");
			en.setValue("type", "phone");
			en.setValue("content", remark);
			en.setValue("user_id", user_id);
			en.setValue("user_name", user_name);
			en.setValue("g_num", 0);
			en.setValue("state", "Y");
			en.setValue("release_time", now);
			en.setValue("create_time", now);
			en.setValue("goods", "N");
			String interact_id = en.create();
			// 图片
			if (sign_imgs != null && !"".equals(sign_imgs)) {
				String[] imgs = sign_imgs.split(",");
				String picture = "";
				String appId = Resources.getProperty("wx." + cust_name + ".appId", "");
				String appSecret = Resources.getProperty("wx." + cust_name + ".appSecret", "");
				Wx wx = new Wx(appId, appSecret, L);
				for (String img : imgs) {
					picture = wx.downMedia(img);
					Entity pic = new EntityImpl("f_interact_pic", this);
					pic.setValue("cust_name", cust_name);
					pic.setValue("gym", gym);
					pic.setValue("interact_id", interact_id);
					pic.setValue("pic_link", picture);
					pic.create();
				}
			}
		}
	}
}
