
package com.mingsokj.fitapp.box;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.mingsokj.fitapp.m.FitUser;
import com.mingsokj.fitapp.utils.MemUtils;
import com.mingsokj.fitapp.ws.bg.set.SysSet;

public class AddBox extends BasicAction {

	// 添加柜子
	@Route(value = "/fit-action-box_add", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void box_add() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String area_no = request.getParameter("area_no");
		String box_nums = request.getParameter("box_nums");
		// 获取gym
		String gym = user.getViewGym();
		String cust_name = user.getCust_name();
		/*
		 * Entity en = this.getEntityFromPage(e);
		 */ // 拿到需要加入柜子数量
		int box_nums_int = 0;
		try {
			box_nums_int = Integer.parseInt(box_nums);
		} catch (Exception er) {
			throw new Exception("柜子数量请输数字");
		}
		// 区域号不能重复
		Entity entity = new EntityImpl("f_box", this);
		entity.setValue("area_no", area_no);
		entity.setValue("gym", gym);
		int size = entity.search();
		if (size > 0) {
			throw new Exception("区域重复");
		}

		String state = "Y";
		for (int i = 1; i <= box_nums_int; i++) {
			Entity f_box = new EntityImpl("f_box", this);
			f_box.setValue("cust_name", cust_name);
			f_box.setValue("gym", gym);
			f_box.setValue("state", state);
			f_box.setValue("box_nums", box_nums);
			f_box.setValue("box_no", i);
			f_box.setValue("area_no", area_no);
			f_box.create();
		}
		this.obj.put("count", box_nums_int);

	}

	// 设置租柜费用
	@Route(value = "/fitapp_box_set", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void box_set() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String charge_no = request.getParameter("charge_no");
		String cash_pledge = request.getParameter("cash_pledge");

		String gym = user.getViewGym();
		String cust_name = user.getCust_name();

		int charge_no_set = 0;
		int cash_pledge_set = 0;
		try {
			charge_no_set = Integer.parseInt(charge_no);
			cash_pledge_set = Integer.parseInt(cash_pledge);
		} catch (Exception er) {
			throw new Exception("请输入正确费用");
		}
		Entity en = new EntityImpl("f_param", this);
		Entity entity = new EntityImpl("f_param", this);
		JSONArray array = new JSONArray();
		JSONObject obj = new JSONObject();
		String sql = "select * from f_param where gym=? and code=?";
		int size = en.executeQuery(sql, new String[] { gym, "set_cash" });
		if (size > 0) {
			array = new JSONArray("[]");
			obj.put("gym", gym);
			obj.put("charge_no_set", charge_no_set);
			obj.put("cash_pledge_set", cash_pledge_set);
			array.put(obj);

			entity.setValue("id", en.getStringValue("id"));
			entity.setValue("note", array.toString());
			entity.update();
		} else {
			array = new JSONArray("[]");
			obj.put("gym", gym);
			obj.put("charge_no_set", charge_no_set);
			obj.put("cash_pledge_set", cash_pledge_set);
			array.put(obj);
			en = new EntityImpl("f_param", this);
			en.setValue("cust_name", cust_name);
			en.setValue("gym", gym);
			en.setValue("code", "set_cash");
			en.setValue("note", array.toString());
			en.create();
		}
	}

	// 显示已设置的租柜费用
	@Route(value = "/fitapp_box_show", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void box_set_show() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String cust_name = user.getCust_name();
		String gym = user.getViewGym();
		Entity entity = new EntityImpl("f_param", this);
		String sql = "select * from f_param where gym = ? and cust_name = ? and code = ?";
		int size = entity.executeQuery(sql, new String[] { gym, cust_name, "set_cash" });
		if (size > 0) {
			String cash_pledge_set = SysSet.getValues(cust_name, gym, "set_cash", "cash_pledge_set",
					this.getConnection());
			String charge_no_set = SysSet.getValues(cust_name, gym, "set_cash", "charge_no_set", this.getConnection());

			this.obj.put("cash_pledge_set", cash_pledge_set);
			this.obj.put("charge_no_set", charge_no_set);
		}

	}

	/**
	 * 显示箱柜
	 * 
	 * @Title: showBox
	 * @author: liul
	 * @date: 2017年7月26日上午10:06:58
	 * @throws Exception
	 */
	@Route(value = "/fit-action-showBox", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void showBox() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		List<Map<String, Object>> list = new ArrayList<>();
		Entity en = new EntityImpl("f_box", this);
		int size = en.executeQuery("SELECT * from f_box where gym=? GROUP BY AREA_NO", new String[] { gym });
		int rent = 0;
		int except = 0;
		if (size > 0) {
			Entity entity = new EntityImpl("f_rent", this);
			list = en.getValues();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm");
			Date now = new Date();
			String nowTime = sdf.format(now);
			for (Map<String, Object> map : list) {
				String area_no = map.get("area_no") + "";
				entity.executeQuery("select id from f_box where area_no=?", new String[] { area_no });
				for (Map<String, Object> map2 : entity.getValues()) {
					String box_id = map2.get("id") + "";
					rent += entity.executeQuery("select * from f_rent_" + gym + " where box_id=? and state='001'",
							new String[] { box_id });
					except += entity.executeQuery("select * from f_rent_" + gym + " where end_time<? and box_id=?",
							new String[] { nowTime, box_id });
				}
				map.put("rent", rent);
				map.put("except", except);
				rent = 0;
				except = 0;
			}

			this.obj.put("list", list);
		}
	}

	/**
	 * 显示所有箱柜
	 * 
	 * @Title: showAllBox
	 * @author: liul
	 * @date: 2017年7月26日下午2:38:45
	 * @throws Exception
	 */
	@Route(value = "/fit-action-showAllBox", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void showAllBox() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		List<Map<String, Object>> list = new ArrayList<>();
		Map<String, JSONArray> numsMap = new HashMap<>();
		// 拿到所有箱柜的区域
		Entity en = new EntityImpl("f_box", this);
		Entity entity = new EntityImpl(this);
		int size = en.executeQuery("SELECT area_no from f_box where gym=? GROUP BY AREA_NO", new String[] { gym });
		if (size > 0) {
			list = en.getValues();
			for (Map<String, Object> map : list) {
				String area_no = map.get("area_no") + "";
				JSONArray arr = new JSONArray();

				// 根据area_no拿到箱柜编号
				int size2 = entity.executeQuery("SELECT * from f_box where AREA_NO=? and gym=?",
						new String[] { area_no, gym });
				if (size2 > 0) {
					for (Map<String, Object> string : entity.getValues()) {
						String id = string.get("id") + "";
						String state = string.get("state")+"";
						
						JSONObject obj = new JSONObject();
						// 查询改柜子状态
						int size3 = entity.executeQuery(
								"select * from f_rent_" + gym + " where box_id=? and state='001'", new String[] { id });
						if (size3 > 0) {
							if ("001".equals(entity.getStringValue("state"))) {
								String mem_id = entity.getStringValue("mem_id");
								// 查询租柜人名字
								String name = MemUtils.getMemInfo(mem_id, user.getCust_name()).getName();
								obj.put("mem_name", name);
								Date endDate = entity.getDateValue("end_time");
								Calendar aCalendar = Calendar.getInstance();
								aCalendar.setTime(new Date());
								long now = aCalendar.getTime().getTime();
								aCalendar.setTime(endDate);
								long end = aCalendar.getTime().getTime();
								if (end < now) {
									long day = (now - end) / 1000 / 3600 / 24;
									obj.put("time", "逾期" + day + "天");
								} else {

									obj.put("time", entity.getStringValue("end_time").substring(0, 10));
								}
							} else {
								obj.put("time", "N");
							}
						} else {
							obj.put("time", "N");
						}
						if ("N".equals(state)) {
							obj.put("state", "N");
						} else {
							obj.put("state", "Y");
						}
						obj.put("id", id);
						obj.put("box_no", string.get("box_no"));
						arr.put(obj);
					}
				}
				numsMap.put(area_no, arr);
			}
		}
		// 查询已租柜子数量
		Entity en2 = new EntityImpl(this);
		en2.executeQuery("SELECT count(*) as is_rent from f_box WHERE state='N' and gym=?", new String[] { gym });
		String isRent = en2.getStringValue("is_rent");
		en2.executeQuery("SELECT count(*) as no_rent from f_box WHERE state='Y'and gym=?", new String[] { gym });
		String noRent = en2.getStringValue("no_rent");
		en2.executeQuery("SELECT count(*) as all_rent from f_box where gym=?", new String[] { gym });
		String all = en2.getStringValue("all_rent");
		this.obj.put("isRent", isRent);
		this.obj.put("noRent", noRent);
		this.obj.put("all", all);
		this.obj.put("list", list);
		this.obj.put("numsMap", numsMap);

	}

	/**
	 * 刪除箱柜
	 * 
	 * @Title: delBox
	 * @author: liul
	 * @date: 2017年7月26日上午11:51:48
	 * @throws Exception
	 */
	@Route(value = "/fit-action-delBox", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void delBox() throws Exception {
		String area_no = this.getParameter("area_no");
		Entity en = new EntityImpl("f_box", this);
		en.executeUpdate("delete from f_box where area_no=?", new String[] { area_no });
	}

	/**
	 * 显示修改箱柜
	 * 
	 * @Title: showeditBox
	 * @author: liul
	 * @date: 2017年7月26日下午2:07:39
	 * @throws Exception
	 */
	@Route(value = "/fit-action-showeditBox", conn = true, m = HttpMethod.GET, type = ContentType.Forward)
	public void showeditBox() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String area_no = this.getParameter("area_no");
		Entity en = new EntityImpl(this);
		int size = en.executeQuery("SELECT * from f_box where AREA_NO=? and gym=? GROUP BY AREA_NO",
				new String[] { area_no, gym });
		if (size > 0) {
			String nextPage = this.getParameter("nextpage");
			request.setAttribute("f_box", en);
			this.obj.put("nextpage", nextPage);
		}
	}

	/**
	 * 显示租柜信息
	 * 
	 * @Title: showrentBox
	 * @author: liul
	 * @date: 2017年7月27日上午9:47:53
	 * @throws Exception
	 */
	@Route(value = "/fit-action-showrentBox", conn = true, m = HttpMethod.GET, type = ContentType.Forward)
	public void showrentBox() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String cust_name = user.getCust_name();
		String box_id = this.getParameter("box_id");
		Entity en = new EntityImpl("f_rent", this);
		Entity entity = new EntityImpl(this);
		en.setTablename("f_rent_" + gym);
		en.setValue("box_id", box_id);
		en.executeQuery("SELECT a.*,b.MEM_NAME FROM f_rent_" + gym + " a ,f_mem_" + cust_name
				+ " b WHERE a.MEM_ID=b.ID AND a.box_id=? and a.state='001'", new String[] { box_id });
		entity.executeQuery("SELECT c.AREA_NO,c.BOX_NO FROM f_box c WHERE c.id=? ", new String[] { box_id });
		request.setAttribute("f_box", entity);
		String nextPage = this.getParameter("nextpage");
		request.setAttribute("f_rent", en);
		this.obj.put("nextpage", nextPage);
	}

	/**
	 * 显示归还柜子信息
	 * 
	 * @Title: showBackBox
	 * @author: liul
	 * @date: 2017年7月27日下午3:57:31
	 * @throws Exception
	 */
	@Route(value = "/fit-action-showBackBox", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void showBackBox() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String id = this.getParameter("id");
		Entity en = new EntityImpl("f_rent", this);
		en.setTablename("f_rent_" + gym);
		en.setValue("id", id);
		int size = en.search();
		if (size > 0) {
			this.obj.put("end_time", en.getStringValue("end_time").substring(0, 10));
		}
	}

	/**
	 * 归还柜子
	 * 
	 * @Title: backBox
	 * @author: liul
	 * @date: 2017年7月27日下午4:01:50
	 * @throws Exception
	 */
	@Route(value = "/fit-action-backBox", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void backBox() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String id = this.getParameter("id");
		String remark = this.getParameter("remark");
		String gym = user.getViewGym();
		Entity en = new EntityImpl("f_rent", this);
		en.setTablename("f_rent_" + gym);
		en.executeUpdate("update f_rent_" + gym + " set state='002',NO_RENT_REMARK=?,NO_RENT_TIME=? where id=?",
				new Object[] { remark, new Date(), id });
		// 拿到柜子id，修改柜子状态
		en.setValue("id", id);
		en.search();
		String box_id = en.getStringValue("box_id");
		String fk_user_id = en.getStringValue("mem_id");
		String rent_deposit_amt = en.getStringValue("rent_deposit_amt");
		en.executeUpdate("update f_box set state='Y' where id=?", new String[] { box_id });
		this.obj.put("money", rent_deposit_amt);
		this.obj.put("fk_user_id", fk_user_id);
	}

	/**
	 * 退柜押金
	 * 
	 * @Title: backBoxMoney
	 * @author: liul
	 * @date: 2017年8月18日下午5:38:52
	 * @throws Exception
	 */
	@Route(value = "/fit-action-backBoxMoney", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void backBoxMoney() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String fk_user_id = this.getParameter("fk_user_id");
		String money = this.getParameter("money");
		String id = this.getParameter("rent_id");
		String gym = user.getViewGym();
		Entity en = new EntityImpl(this);
		en.executeUpdate("update f_rent_" + gym + " set no_rent_deposit_amt=? where id=?", new String[] { money, id });
		en = new EntityImpl("f_other_pay", this);
		int backMoney = Integer.parseInt(money);
		en.setTablename("f_other_pay_" + gym);
		en.setValue("real_amt", -(backMoney * 100));
		en.setValue("ca_amt", -(backMoney * 100));
		en.setValue("cash_amt", -(backMoney * 100));
		en.setValue("emp_id", user.getId());
		en.setValue("card_cash_amt", 0);
		en.setValue("card_amt", 0);
		en.setValue("vouchers_amt", 0);
		en.setValue("vouchers_num", 0);
		en.setValue("wx_amt", 0);
		en.setValue("ali_amt", 0);
		en.setValue("pay_type", "退柜押金");
		en.setValue("mem_id", fk_user_id);
		en.setValue("pay_way", "cash_amt");
		en.setValue("is_free", "N");
		en.setValue("staff_account", "N");
		en.setValue("print", "N");
		en.setValue("send_msg", "N");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		en.setValue("pay_time", sdf.format(new Date()));
		en.create();
	}

	/**
	 * 修改箱柜
	 * 
	 * @Title: editBox
	 * @author: liul
	 * @date: 2017年7月26日下午2:15:16
	 * @throws Exception
	 */
	@Route(value = "/fit-action-editBox", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void editBox() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String area_no = request.getParameter("area_no");
		String box_nums = request.getParameter("box_nums");
		String area_no_old = request.getParameter("area_no_old");
		// 获取gym
		String gym = user.getViewGym();
		String cust_name = user.getCust_name();

		// 修改的时候先删除该区域以前的箱柜
		Entity en = new EntityImpl(this);
		en.executeUpdate("delete from f_box where area_no=?", new String[] { area_no_old });
		// 添加箱柜
		int box_nums_int = 0;
		try {
			box_nums_int = Integer.parseInt(box_nums);
		} catch (Exception er) {
			throw new Exception("柜子数量请输数字");
		}

		String state = "Y";
		Entity f_box = new EntityImpl("f_box", this);
		for (int i = 1; i <= box_nums_int; i++) {
			f_box.setValue("cust_name", cust_name);
			f_box.setValue("gym", gym);
			f_box.setValue("state", state);
			f_box.setValue("box_nums", box_nums);
			f_box.setValue("box_no", i);
			f_box.setValue("area_no", area_no);
			f_box.create();
		}
		this.obj.put("count", box_nums_int);
	}

	/**
	 * 获取租柜的价格
	 * 
	 * @Title: getPrice
	 * @author: liul
	 * @date: 2017年7月27日上午11:36:07
	 * @throws Exception
	 */
	@Route(value = "/fit-action-getPrice", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void getPrice() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String cust_name = user.getCust_name();
		String start_time = this.getParameter("rentStartTime");
		String end_time = this.getParameter("rentEndTime");
		String type = this.getParameter("type");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date startDate = sdf.parse(start_time);
		Date endDate = sdf.parse(end_time);
		if (startDate.getTime() > endDate.getTime()) {
			throw new Exception("开始时间不能大于结束时间");
		}
		// 获取租柜设置
		Entity param = new EntityImpl("f_param", this);
		param.setValue("gym", gym);
		param.setValue("cust_name", cust_name);
		param.setValue("code", "set_cash");
		int size = param.search();
		if (size > 0) {
			String cash = SysSet.getValues(cust_name, gym, "set_cash", "cash_pledge_set", this.getConnection());
			String price = SysSet.getValues(cust_name, gym, "set_cash", "charge_no_set", this.getConnection());
			if (price == null || price.length() <= 0) {
				price = "0";
			}
			if (cash == null || cash.length() <= 0) {
				cash = "0";
			}
			if ("xuFei".equals(type)) {
				// 计算租了几天
				Calendar aCalendar = Calendar.getInstance();
				aCalendar.setTime(startDate);
				long startDay = aCalendar.getTime().getTime();
				aCalendar.setTime(endDate);
				long endDay = aCalendar.getTime().getTime();
				long day = (endDay - startDay) / 1000 / 3600 / 24;
				long caPrice = Integer.parseInt(price) * day;
				this.obj.put("caPrice", caPrice);
				this.obj.put("cash", 0);
			} else {
				// 计算租了几天
				Calendar aCalendar = Calendar.getInstance();
				aCalendar.setTime(startDate);
				long startDay = aCalendar.getTime().getTime();
				aCalendar.setTime(endDate);
				long endDay = aCalendar.getTime().getTime();
				long day = (endDay - startDay) / 1000 / 3600 / 24 + 1;
				long caPrice = Integer.parseInt(price) * day + Integer.parseInt(cash);
				this.obj.put("caPrice", caPrice);
				this.obj.put("cash", cash);
			}
		} else {
			throw new Exception("请设置租柜价格");
		}
	}

}