package com.mingsokj.fitapp.utils;

import java.util.Calendar;
import java.util.Date;

import com.jinhua.server.tools.Utils;

public class DateUtils {
	/**
	 * 格式化时间
	 * @param fromDate
	 * @return 多少天前
	 * @throws Exception
	 */
	public static String toStringDate(String fromDate) throws Exception{
		Date date1 = Utils.parse2Date(fromDate, "yyyy-MM-dd HH:mm:ss");
		Calendar cal = Calendar.getInstance();
		Date date2 = cal.getTime();
		long tmp = date2.getTime() - date1.getTime();
		long secs = tmp / 1000;
		long mins = tmp / 1000 / 60;
		long hours = tmp / 1000 / 60 / 60;
		long days = tmp / 1000 / 60 / 60 / 24;
		String d = "";
		if(days > 0 && days <= 7){
			d = days + "天前";
		} else if(days > 7){
			int now_year = cal.get(Calendar.YEAR);
			cal.setTime(date1);
			int publish_year = cal.get(Calendar.YEAR);
			if(publish_year == now_year){
				d = Utils.parseData(date1, "MM-dd HH:mm");
			} else {
				d = Utils.parseData(date1, "yyyy-MM-dd HH:mm");
			}
		} else if(days <= 0 && hours > 0){
			d = hours + "小时前";
		} else if(days <= 0 && hours <= 0 && mins > 0){
			d = mins + "分钟前";
		} else if(days <= 0 && hours <= 0 && mins <= 0 && secs > 0){
			d = secs + "秒前";
		} else {
			d = "1秒前";
		}
		return d;
	}
	
	
	/**
	 * 格式化时间
	 * @param fromDate
	 * @return 昨天 今天
	 * @throws Exception
	 */
	public static String toStringDate2(String fromDate) throws Exception{
		Date date1 = Utils.parse2Date(fromDate, "yyyy-MM-dd HH:mm:ss");
		Calendar cal = Calendar.getInstance();
		Date date2 = cal.getTime();
		String d = "";
		String d1 = Utils.parseData(date1, "yyyy-MM-dd");
		String d2 = Utils.parseData(date2, "yyyy-MM-dd");
		if(d1.equals(d2)){
			d = "今天";
		} else {
			int now_year = cal.get(Calendar.YEAR);
			cal.setTime(date1);
			int publish_year = cal.get(Calendar.YEAR);
			if(publish_year == now_year){
				d = Utils.parseData(date1, "MM-dd");
			} else {
				d = Utils.parseData(date1, "yyyy-MM-dd");
			}
		}
		return d;
	}
}
