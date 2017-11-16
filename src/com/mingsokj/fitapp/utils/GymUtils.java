package com.mingsokj.fitapp.utils;

import com.jinhua.server.tools.RedisUtils;
import com.mingsokj.fitapp.m.Gym;
import com.mingsokj.fitapp.task.InitFit;

public class GymUtils {
	public static String getGymName(String gym) throws Exception {
		Gym g = (Gym) RedisUtils.getHParam("GYM", gym);
		if (g == null) {
			new InitFit();
			g = (Gym) RedisUtils.getHParam("GYM", gym);
		}
		if (g == null) {
			throw new Exception("系统没有找到门店代码【" + gym + "】");
		} else {
			return g.gymName;
		}
	}
}
