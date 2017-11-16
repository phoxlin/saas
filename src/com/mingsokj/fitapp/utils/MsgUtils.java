package com.mingsokj.fitapp.utils;

import java.sql.Connection;
import java.util.Date;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.alibaba.fastjson.JSONObject;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.tools.Utils;

public class MsgUtils {

	public static void sendPhoneMsg(String cust_name, String gym, String type, String phone, String content,
			Connection conn, String sendType) throws Exception {

		String regExp = "^((13[0-9])|(15[^4])|(18[0,1,2,3,5-9])|(17[0-8])|(147))\\d{8}$";
		Pattern p = Pattern.compile(regExp);
		Matcher m = p.matcher(phone);
		
		if (!m.matches()) {
			//throw new Exception("手机号码格式错误");
			System.out.println("手机号码格式错误");
			return;
		}
		if (Utils.isNull(cust_name)) {
			//throw new Exception("cust_name为空");
			System.out.println("cust_name为空");
			return;
		}
		if (Utils.isNull(gym)) {
			//throw new Exception("gym为空");
			System.out.println("gym为空");
			return;
		}

		Entity entity = new EntityImpl("f_msg_send", conn);
		entity.setTablename("f_msg_send_" + gym);
		entity.setValue("cust_name", cust_name);
		entity.setValue("gym", gym);
		entity.setValue("type", type);
		entity.setValue("create_time", new Date());
		entity.setValue("content", content);
		entity.setValue("phone", phone);
		entity.setValue("state", "N");
		// msg.sendMessage();
		String reString = "";
		
		// 群发短信
			reString = SendMsg.sendMsg(phone, content, sendType);
			try {
				JSONObject obj = JSONObject.parseObject(reString);
				String state = obj.getString("showapi_res_code");
				//发送消息后对该会所的短信进行扣次
				if ("0".equals(state)) {
					Entity en = new EntityImpl("f_gym", conn);
					en.executeUpdate("update f_gym set REMAIN_SMS_NUM=ifnull(REMAIN_SMS_NUM,0qw)-?  where gym=? and cust_name=?", new Object[] { 1,gym, gym });
					entity.setValue("state", "Y");
				}
			} catch (Exception e) {
				System.out.println("短信扣次失败,json转换出错");
			}
		entity.create();
	}

}
