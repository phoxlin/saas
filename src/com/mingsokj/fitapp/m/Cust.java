package com.mingsokj.fitapp.m;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class Cust implements Serializable {
	private static final long serialVersionUID = 1L;
	public String cust_name;// 当前客户代码 ，如果这个代码和下面的 gym相等 则，可以取得对应客户名称
	// 可见门店的code和note
	public List<Gym> viewGyms = new ArrayList<>();

	public Gym getCurGym() throws Exception {
		if (viewGyms.size() > 0) {
			for (int i = 0; i < viewGyms.size(); i++) {
				Gym g = viewGyms.get(i);
				if (g.curShow) {
					return g;
				}
			}
			throw new Exception("当前用户没有登陆？没有指定门店显示");
		}
		throw new Exception("当前用户没有可见门店");
	}

}
