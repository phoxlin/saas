package com.mingsokj.fitapp.ws.app;

import com.alibaba.fastjson.JSONObject;
import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.mingsokj.fitapp.utils.MsgUtils;

/**
* @author liul
* 2017年9月5日上午11:33:52
*/
public class 发送短信验证码 extends BasicAction {
	
	@Route(value = "/fit-ws-app-sendYanZheng", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void sendYanZheng() throws Exception{
		String code = this.getParameter("code");
		String phone = this.getParameter("phone");
		String gym = this.getParameter("gym");
		String cust_name = this.getParameter("cust_name");
		JSONObject obj = new JSONObject();
		obj.put("name", "");
		obj.put("code", code);
		obj.put("minute", 3);
		MsgUtils.sendPhoneMsg(cust_name, gym, "验证码", phone, obj.toString(), this.getConnection(),"yanZheng");
	}
}
