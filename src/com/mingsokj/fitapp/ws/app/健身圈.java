package com.mingsokj.fitapp.ws.app;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.Resources;
import com.jinhua.server.wx.Wx;
import com.mingsokj.fitapp.utils.DateUtils;

public class 健身圈 extends BasicAction {

	/**
	 * 健身圈详细信息
	 */
	@Route(value = "/fit-ws-bg-interact-detail", conn = true, m = HttpMethod.GET, type = ContentType.Forward)
	public void interactDetail() throws Exception {
		String id = this.getParameter("id");
		Entity interact = new EntityImpl("f_interact", this);
		interact.setValue("id", id);
		interact.search();

		Entity f_interact_pic = new EntityImpl("f_interact_pic", this);
		f_interact_pic.setValue("interact_id", id);
		f_interact_pic.search();

		request.setAttribute("f_interact", interact);
		request.setAttribute("f_interact_pic", f_interact_pic);
	}

	/**
	 * 获取健身圈列表
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-app-action-interactList", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void interactList() throws Exception {
		String cust_name = this.getParameter("cust_name");
		String gym = this.getParameter("gym");
		String user_id = this.getParameter("user_id");
//		String wxOpenId = this.getParameter("wxOpenId");
		String num = this.getParameter("num");
		if (num == null || num.length() <= 0) {
			num = "1";
		}

		int pageSize = 20;
		int curPage = Integer.parseInt(num);
		int start = (curPage - 1) * pageSize + 1;
		int end = pageSize * curPage;

		Entity interact = new EntityImpl("f_interact", this);
		String sql = "select * from f_interact where cust_name =? and gym=? and auth_type=? or user_id=? order by release_time desc";
		int size = interact.executeQueryWithMaxResult(sql, new String[] { cust_name, gym, "001", user_id }, start, end);
		if (size > 0) {
			Entity f_interact_pic = new EntityImpl("f_interact_pic", this);
			f_interact_pic.setValue("cust_name", cust_name);
			f_interact_pic.setValue("gym", gym);
			int p_size = f_interact_pic.search();

			// 点赞
			Entity zan = new EntityImpl("f_interact_zan", this);
			int zan_x = zan.executeQuery("SELECT * FROM f_interact_zan  WHERE cust_name=? AND gym=?", new String[] { cust_name, gym });

			for (int i = 0; i < size; i++) {
				String id = interact.getStringValue("id", i);
				String release_time = interact.getStringValue("release_time", i);
//				String employee = interact.getStringValue("employee", i);
				String mem_id = interact.getStringValue("user_id", i);
				Entity en = new EntityImpl(this);
				int siez = en.executeQuery("select * from f_mem_" + cust_name + " where id=?", new String[] { mem_id });
				String openId = "";
				String nickName = "";
				if (siez > 0) {
					openId = en.getStringValue("wx_open_id");
				}
				String pic = "";
				en = new EntityImpl("f_emp", this);
				if (openId != "") {
					int xx = en.executeQuery("select b.headurl wx_head_url,b.sex wx_sex,b.nickname wx_nickname from f_mem_" + cust_name + " a ,f_wx_cust_" + cust_name + " b where a.WX_OPEN_ID=b.WX_OPEN_ID and a.WX_OPEN_ID=? limit 1", new String[] { openId });
					if (xx > 0) {
						pic = en.getStringValue("wx_head_url");
						nickName = en.getStringValue("wx_nickname");
					}
				}
				release_time = DateUtils.toStringDate(release_time);
				int count = 0;
				List<String> pics = new ArrayList<String>();
				// 圈圈图片
				for (int j = 0; j < p_size; j++) {
					String interact_id = f_interact_pic.getStringValue("interact_id", j);
					if (id.equals(interact_id)) {
						pics.add(f_interact_pic.getStringValue("pic_link", j));
						count++;
						if (count == 9) {
							break;
						}
					}
				}
				// 是否点赞
				for (int j = 0; j < zan_x; j++) {
					String i_id = zan.getStringValue("interact_id", j);
					String u_id = zan.getStringValue("user_id", j);
					if (user_id.equals(u_id) && i_id.equals(id)) {
						interact.getValues().get(i).put("zan", true);
					} else {
						interact.getValues().get(i).put("zan", false);
					}
				}

				interact.getValues().get(i).put("release_time", release_time);
				interact.getValues().get(i).put("pic_count", count);
				interact.getValues().get(i).put("pics", pics);
				interact.getValues().get(i).put("pic_url", pic);
				interact.getValues().get(i).put("user_name", nickName);
				interact.getValues().get(i).put("nickName", nickName);
			}
		}
		int total = interact.getMaxResultCount();
		String flag = "N";
		if (end >= total) {
			flag = "Y";
		}
		this.obj.put("list", interact.getValues());
		this.obj.put("flag", flag);
		this.obj.put("next", curPage + 1);
	}

	/**
	 * 发布圈圈
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-app-action-saveInteract", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void saveInteract() throws Exception {
		String cust_name = request.getParameter("cust_name");
		String gym = request.getParameter("gym");
		String user_id = request.getParameter("user_id");
		String user_name = request.getParameter("user_name");
		String content = request.getParameter("content");
		String pics = request.getParameter("serverId");
		String auth_type = request.getParameter("auth_type");
		Entity interact = new EntityImpl("f_interact", this);
		interact.setValue("cust_name", cust_name);
		interact.setValue("gym", gym);
		interact.setValue("auth_type", auth_type);
		interact.setValue("type", "phone");
		interact.setNullValue("art_title");
		interact.setNullValue("summary");
		interact.setValue("content", content);
		interact.setValue("create_time", new Date());
		interact.setValue("user_id", user_id);
		interact.setValue("user_name", user_name);
		interact.setNullValue("employee");
		interact.setValue("g_num", 0);
		interact.setValue("state", "Y");
		interact.setValue("release_time", new Date());
		interact.setValue("goods", "N");
		String interact_id = interact.create();
		List<String> urlList = new ArrayList<String>();
		String appId = Resources.getProperty("wx." + cust_name + ".appId", "");
		String appSecret = Resources.getProperty("wx." + cust_name + ".appSecret", "");
		if (pics != null && pics.length() > 0) {
			String[] tmp = pics.split(",");
			Wx wx = new Wx(appId, appSecret, L);
			for (String url : tmp) {
				// 需要AppID，appsecret
				String picurl = wx.downMedia(url);
				urlList.add(picurl);
				L.error("picurl------------------------------>" + picurl);
			}
			if (urlList != null && urlList.size() > 0) {
				for (int i = 0; i < urlList.size(); i++) {
					L.error("picurl------------------------------>" + urlList.get(i));
					Entity f_interact_pic = new EntityImpl("f_interact_pic", this);
					f_interact_pic.setValue("cust_name", cust_name);
					f_interact_pic.setValue("gym", gym);
					f_interact_pic.setValue("interact_id", interact_id);
					f_interact_pic.setValue("pic_link", urlList.get(i));
					f_interact_pic.create();
				}
			}

		}
	}

	/**
	 * 点赞
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-app-action-interactZan", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void interactZan() throws Exception {
		String cust_name = request.getParameter("cust_name");
		String gym = request.getParameter("gym");
		String user_id = request.getParameter("user_id");
		String interact_id = request.getParameter("interact_id");
		Entity zan = new EntityImpl("f_interact_zan", this);
		zan.setValue("cust_name", cust_name);
		zan.setValue("gym", gym);
		zan.setValue("user_id", user_id);
		zan.setValue("interact_id", interact_id);
		int size = zan.search();
		if (size > 0) {
			Entity en = new EntityImpl("f_interact_zan", this);
			en.setValue("id", zan.getStringValue("id"));
			zan.delete();

			Entity interact = new EntityImpl("f_interact", this);
			interact.executeUpdate("update f_interact SET g_num = g_num - 1 WHERE id = ?", new String[] { interact_id });
		} else {
			zan.create();

			Entity interact = new EntityImpl("f_interact", this);
			interact.executeUpdate("update f_interact SET g_num = g_num + 1 WHERE id = ?", new String[] { interact_id });
		}
	}

}
