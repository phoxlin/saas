package com.mingsokj.fitapp.utils;

import java.util.HashMap;
import java.util.Map;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.util.EntityUtils;

import com.jogamp.opengl.math.geom.AABBox;


/**
* @author liul
* 2017年9月5日下午3:46:33
*/
public class SendMsg {
	/**
	 * 
	 * @Title: sendMsg
	 * @author: liul
	 * @date: 2017年9月5日下午4:15:42
	 * @param phone 接收人电话
	 * @param content 发送内容
	 */
	public static String sendMsg(String phone,String content,String type) {
		//发送短信
	    String host = "http://ali-sms.showapi.com";
	    String path = "/sendSms";
	    String method = "GET";
	    String appcode = "ad0c7edc7ff34632a7ee0925dd8209ae";
	    Map<String, String> headers = new HashMap<String, String>();
	    //最后在header中的格式(中间是英文空格)为Authorization:APPCODE 83359fd73fe94948385f570e3c139105
	    headers.put("Authorization", "APPCODE " + appcode);
	    Map<String, String> querys = new HashMap<String, String>();
	    querys.put("content", content);//content为json格式如:{"name":"张三","content":"你好"}
	    querys.put("mobile", phone);//接收人电话
	    if ("yanZheng".equals(type)) {
	    	//发送验证码
	    	querys.put("tNum", "T170317001324");//模板号
		}else if ("lesson".equals(type)) {
			//扣次
			querys.put("tNum", "T170317001311");//模板号
		} 
		
		//查询模板
		 /* String host = "http://ali-sms.showapi.com";
		    String path = "/searchTemplate";
		    String method = "GET";
		    String appcode = "ad0c7edc7ff34632a7ee0925dd8209ae";
		    Map<String, String> headers = new HashMap<String, String>();
		    //最后在header中的格式(中间是英文空格)为Authorization:APPCODE 83359fd73fe94948385f570e3c139105
		    headers.put("Authorization", "APPCODE " + appcode);
		    Map<String, String> querys = new HashMap<String, String>();
		    querys.put("tNum", "");*/

		//创建模板
		  /*String host = "http://ali-sms.showapi.com";
		    String path = "/createTemplate";
		    String method = "GET";
		    String appcode = "ad0c7edc7ff34632a7ee0925dd8209ae";
		    Map<String, String> headers = new HashMap<String, String>();
		    //最后在header中的格式(中间是英文空格)为Authorization:APPCODE 83359fd73fe94948385f570e3c139105
		    headers.put("Authorization", "APPCODE " + appcode);
		    Map<String, String> querys = new HashMap<String, String>();
		    //querys.put("content", "尊敬的用户[name]您好,你的私教卡[cardName]已成功扣次，剩余次数[times]");
		    querys.put("content", "尊敬的用户[name]您好！您本次的验证码是[code],有效时间[minute]分钟");
		    querys.put("notiPhone", "18223586775");
		    querys.put("title", "在健身");*/
	    String state = "";
	    try {
	    	
	    	HttpResponse response = HttpUtils.doGet(host, path, method, headers, querys);
	    	System.out.println(response.toString());
	    	//state = response.toString();
	    	//获取response的body
	    	
	    	//System.out.println(EntityUtils.toString(response.getEntity()));
	    	state = EntityUtils.toString(response.getEntity());
	    } catch (Exception e) {
	    	e.printStackTrace();
	    }
	    return state ;
	}
}
