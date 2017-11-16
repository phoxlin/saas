package com.mingsokj.fitapp.ws.app.mem;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.json.JSONObject;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.log.Logger;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.Resources;
import com.jinhua.server.tools.Utils;
import com.jinhua.server.wx.Wx;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.utils.MemUtils;

public class 体测数据 extends BasicAction {

	@Route(value = "/fit-ws-app-queryBodyDataListByMemId", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void queryBodyDataListByMemId() throws Exception {
		String cust_name = request.getParameter("cust_name");
//		String gym = request.getParameter("gym");
		String mem_id = request.getParameter("mem_id");
		MemInfo mem = MemUtils.getMemInfo(mem_id, cust_name);
		if (mem == null) {
			throw new Exception("数据加载延迟,请稍后尝试");
		}
		String memGym = mem.getGym();
		Entity en = new EntityImpl("f_body_data", this);

		int s = en.executeQuery("select * from f_body_data_" + memGym + " where mem_id = ? order by create_time desc", new Object[] { mem_id });
		if (s > 0) {
			this.obj.put("list", en.getValues());
		}
	}

	@Route(value = "/fit-ws-app-queryBodyDataById", slave = true, conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void queryBodyDataById() throws Exception {
		String cust_name = request.getParameter("cust_name");
//		String gym = request.getParameter("gym");
		String mem_id = request.getParameter("mem_id");
		String data_id = request.getParameter("data_id");
		MemInfo mem = MemUtils.getMemInfo(mem_id, cust_name);
		if (mem == null) {
			throw new Exception("数据加载延迟,请稍后尝试");
		}
		String memGym = mem.getGym();
		Entity en = new EntityImpl("f_body_data", this);
		en.setTablename("f_body_data_" + memGym);
		en.setValue("id", data_id);
		int s = en.search();
		if (s > 0) {
			this.obj.put("bodyData", en.getValues().get(0));
		}
	}

	private SimpleDateFormat sdf = new SimpleDateFormat(" HH:mm:ss");

	@Route(value = "/fit-ws-app-saveBodyData", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void saveBodyData() throws Exception {
		String cust_name = request.getParameter("cust_name");
//		String gym = request.getParameter("gym");
		String mem_id = request.getParameter("mem_id");
		String data_id = request.getParameter("data_id");
		String pt_id = request.getParameter("pt_id");
		String content = request.getParameter("content");
		String create_time = request.getParameter("create_time");
		String serverId = this.getParameter("serverId");
		Logger.error("serverId------------------------------>" + serverId);
		MemInfo mem = MemUtils.getMemInfo(mem_id, cust_name);
		JSONObject obj = new JSONObject(content);
		List<String> urlList = new ArrayList<String>();
		String appId = Resources.getProperty("wx." + cust_name + ".appId", "");
		String appSecret = Resources.getProperty("wx." + cust_name + ".appSecret", "");
		if (serverId != null && serverId != "") {
			String[] urls = serverId.split(",");
			Wx wx = new Wx(appId, appSecret, L);
			for (String url : urls) {
				// 需要AppID，appsecret
				String picurl = wx.downMedia(url);
				urlList.add(picurl);

			}
		}
		// 将图片添加到obj中
		int put = 0;
		for (int i = 0; i < urlList.size(); i++) {
			obj.put("pic" + (i + 1), urlList.get(i));
			put++;
		}

		// 是否是修改并且已有上传过的图片
		String imgs = this.getParameter("hasUploadImgs");
		if (!Utils.isNull(imgs)) {
			for (String url : imgs.split(",")) {
				obj.put("pic" + (++put), url);
			}
		}

		if (mem == null) {
			throw new Exception("数据加载延迟,请稍后尝试");
		}
		String memGym = mem.getGym();
		Entity en = new EntityImpl("f_body_data", this);
		en.setTablename("f_body_data_" + memGym);
		en.setValue("cust_name", cust_name);
		en.setValue("gym", memGym);
		en.setValue("content", obj);
		en.setValue("mem_id", mem_id);
		if (Utils.isNull(create_time)) {
			en.setValue("create_time", create_time + sdf.format(new Date()));
		} else {
			en.setValue("create_time", new Date());
		}

		if (!Utils.isNull(pt_id) && !pt_id.equals(mem_id)) {
			en.setValue("pt_id", pt_id);
		}
		if (Utils.isNull(data_id)) {
			en.create();
		} else {
			en.setValue("id", data_id);
			en.update();
		}

	}

	@Route(value = "/fit-ws-app-deleteBodyDataById", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void deleteBodyDataById() throws Exception {
		String cust_name = request.getParameter("cust_name");
//		String gym = request.getParameter("gym");
		String data_id = request.getParameter("data_id");
		String mem_id = request.getParameter("mem_id");

		MemInfo mem = MemUtils.getMemInfo(mem_id, cust_name);
		if (mem == null) {
			throw new Exception("数据加载延迟,请稍后尝试");
		}
		String memGym = mem.getGym();
		Entity en = new EntityImpl("f_body_data", this);
		en.setTablename("f_body_data_" + memGym);
		en.setValue("id", data_id);
		en.delete();
	}
}
