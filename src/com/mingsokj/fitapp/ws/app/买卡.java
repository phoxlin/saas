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
import com.mingsokj.fitapp.ws.bg.set.SysSet;

public class 买卡 extends BasicAction {
	@Route(value = "/yp-ws-app-buyCard", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void buyCard() throws Exception {
		String fk_card_id = this.getParameter("id");
		String birthday = this.getParameter("birthday");
		String wxOpenId = this.getParameter("wxOpenId");
		String edit_id_card = this.getParameter("edit_id_card");
		String edit_mem_name = this.getParameter("edit_mem_name");
		String sex = this.getParameter("sex");
		String gym = this.getParameter("gym");
		String out_trade_no = this.getParameter("out_trade_no");
		String cust_name = this.getParameter("cust_name");
		String fk_user_id = this.getParameter("fk_user_id");
		String priTimes = this.getParameter("priTimes");
		Entity cardEn = new EntityImpl(this);
		int carSize = cardEn.executeQuery("select days,times,card_type,fee from f_card where id=?",
				new Object[] { fk_card_id });
		String card_fee = "";
		int times = 0;
		int days = 0;
		if (carSize > 0) {
			try {
				days = cardEn.getIntegerValue("days");
			} catch (Exception e) {
			} finally {
                  days= 365*100;
			}
			times = cardEn.getIntegerValue("times");
			card_fee = cardEn.getStringValue("fee");
		}
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		Entity en = new EntityImpl("f_user_card", this);

		en.setTablename("f_user_card_" + gym);

		en.setValue("cust_name", cust_name);
		en.setValue("gym", gym);
		en.setValue("card_id", fk_card_id);
		en.setValue("mem_id", fk_user_id);
		en.setValue("emp_id", "-1");
		en.setValue("buy_time", sdf.format(new Date()));
		en.setValue("active_type", "001");
		en.setValue("active_time", sdf.format(new Date()));
		en.setValue("pay_time", sdf.format(new Date()));
		en.setValue("create_time", sdf.format(new Date()));

		Calendar c = Calendar.getInstance();
		c.setTime(new Date());
		c.add(Calendar.DAY_OF_YEAR, days);

		en.setValue("deadline", c.getTime());
		en.setValue("real_amt", card_fee);
		en.setValue("remark", "");
		en.setValue("source", "");
		en.setValue("state", "001");
		en.setValue("remain_times", times);
		en.setValue("buy_times", times);
		if("006".equals(cardEn.getStringValue("card_type"))){
			en.setValue("remain_times", priTimes);
			en.setValue("buy_times", priTimes);
		}
		en.setValue("out_trade_no", out_trade_no);
		en.create();
		// 修改会员信息
		Entity entity = new EntityImpl("f_mem", this);
		entity.setTablename("f_mem_" + cust_name);
		entity.setValue("id", fk_user_id);
		entity.setValue("birthday", birthday);
		entity.setValue("id_card", edit_id_card);
		entity.setValue("mem_name", edit_mem_name);
		entity.setValue("sex", sex);
		entity.update();
		// 同时修改微信性别
		Entity en2 = new EntityImpl(this);
		en2.executeUpdate("update f_wx_cust_" + cust_name + " set sex=? where wx_open_id=?",
				new String[] { sex, wxOpenId });
		// 修改后更新修改时间
		Entity updateTime = new EntityImpl("f_mem", this);
		int size2 = updateTime.executeQuery("select * from f_mem_" + cust_name + " where id=?",
				new String[] { fk_user_id });
		if (size2 > 0) {
			String update_time = updateTime.getStringValue("update_time");
			boolean flag = ("".equals(update_time) || update_time == null) ? true : false;
			if (flag) {
				updateTime.setTablename("f_mem_" + cust_name);
				updateTime.setValue("id", fk_user_id);
				updateTime.setValue("update_time", new Date());
				updateTime.update();
			}
		}
		// 查询买卡会员是否是该会所会员推荐过来的，如果是，则推荐人积分加上
		int size = en.executeQuery("select * from f_mem_" + cust_name + " where id=? and state in('003','004')",
				new String[] { fk_user_id });
		if (size > 0) {
			String refer_mem_id = en.getStringValue("refer_mem_id");
			if (!"".equals(refer_mem_id) && refer_mem_id != null) {
				// 获取会所的积分设置
				int recommend_points = Integer.parseInt(
						SysSet.getValues(cust_name, gym, "set_points", "recommend_points", this.getConnection()));
				en.executeUpdate(
						"update f_mem_" + cust_name + " set total_cent=total_cent+" + recommend_points + " where id=?",
						new String[] { refer_mem_id });

			}
		}
	}
}
