package com.mingsokj.fitapp.ws.app.sales;

import java.util.Calendar;
import java.util.Date;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.ws.bg.set.SysSet;

/**
 * @author liul 2017年8月17日下午3:26:52
 */
public class 添加新入会 extends BasicAction {

	@Route(value = "/fit-app-action-add_new_mem", conn = true, type = ContentType.JSON, m = HttpMethod.POST)
	public void choice_mem() throws Exception {
		String gym = this.getParameter("gym");
		// String emp_id = this.getParameter("id");
		String op_id = this.getParameter("id");
		String cust_name = this.getParameter("cust_name");
		String mem_name = this.getParameter("new_mem_name");
		String sex = this.getParameter("new_mem_sex");
		String birthday = this.getParameter("new_mem_birthday");
		String id_card = this.getParameter("new_mem_card");
		String phone = this.getParameter("new_mem_phone");
		String type = this.getParameter("type");// 是会籍还是教练添加的

		String card_id = this.getParameter("new_mem_card_id");
		if (Utils.isNull(card_id)) {
			throw new Exception("请选择卡");
		}
		String activate_type = this.getParameter("new_mem_activate_type");
		String active_time = this.getParameter("new_mem_active_time");
		String sales = "";
		String coach = "";
		// 如果是会籍提交则专属会籍是自己
		if ("MC".equals(type)) {
			sales = this.getParameter("id");
			coach = this.getParameter("new_mem_choice_pt_id");
		} else if ("PT".equals(type)) {
			sales = this.getParameter("new_mem_choice_mc_id");
			coach = this.getParameter("id");
		}
		String source = this.getParameter("new_mem_source");
		int ca_amt = Integer.parseInt(this.getParameter("new_mem_price"));
		int real_amt = Integer.parseInt(this.getParameter("new_mem_discount_price")) * 100;
		String contract_no = this.getParameter("new_mem_contract_no");
		String remark = this.getParameter("new_mem_remark");

		String give_days = this.getParameter("new_mem_give_days");// 赠送的次数/天数/金额
		String give_card_id = this.getParameter("new_mem_send_card");// 赠送的私教卡ID
		String give_times = this.getParameter("new_mem_give_times");// 赠送的私教卡节数

		Entity en = new EntityImpl("f_mem", this);
		Entity en2 = new EntityImpl("f_mem", this);
		en.setTablename("f_mem_" + cust_name);
		en2.setTablename("f_mem_" + cust_name);
		// 查询添加的会员是否是会员推荐的,或则是添加的潜在客户
		boolean flag = false;
		int size2 = en2.executeQuery("select * from f_mem_" + cust_name + " where phone=? and state in('003','004')",
				new String[] { phone });
		String mem_id = "";
		String refer_mem_id = this.getParameter("new_mem_choice_mem_id");
		if (size2 > 0) {
			if (!"".equals(refer_mem_id) && refer_mem_id != null) {
				mem_id = en2.getStringValue("id");
				flag = true;
			}
		}
		int size3 = en2.executeQuery("select * from f_mem_" + cust_name + " where phone=? and state ='001'",
				new String[] { phone });
		if (size3 > 0) {
			throw new Exception("该会员已经存在");
		}
		en.setValue("mem_name", mem_name);
		en.setValue("sex", sex);
		en.setValue("gym", gym);
		en.setValue("mc_id", sales);
		en.setValue("pt_names", coach);
		en.setValue("cust_name", cust_name);
		en.setValue("birthday", birthday);
		en.setValue("id_card", id_card);
		en.setValue("phone", phone);
		en.setValue("refer_mem_id", refer_mem_id);
		en.setValue("create_time", new Date());
		String userState = "001";
		if (!"001".equals(activate_type)) {
			userState = "002";
		}
		en.setValue("state", userState);
		String fk_user_id = "";
		// 如果是潜在会员就更新信息
		if (flag) {
			en.setValue("id", mem_id);
			fk_user_id = mem_id;
			en.update();
		} else {
			fk_user_id = en.create();
		}

		if ("".equals(card_id)) {
			throw new Exception("请选择会员卡");
		}
		Entity cardEn = new EntityImpl(this);
		cardEn.executeQuery("select days,times,card_type,amt from f_card where id=?", new Object[] { card_id });
		int days = cardEn.getIntegerValue("days");
		int times = cardEn.getIntegerValue("times");
		long amt = cardEn.getLongValue("amt");
		String card_type = cardEn.getStringValue("card_type");

		en = new EntityImpl("f_user_card", this);
		en.setTablename("f_user_card_" + gym);
		en.setValue("cust_name", cust_name);
		en.setValue("gym", gym);
		en.setValue("card_id", card_id);
		en.setValue("mem_id", fk_user_id);
		en.setValue("mc_id", sales);
		en.setValue("pt_id", coach);
		en.setValue("create_time", new Date());
		en.setValue("buy_time", new Date());
		en.setValue("active_type", activate_type);
		String state = "001";
		if ("001".equals(activate_type)) { // 立即激活
			if ("001".equals(card_type)) {
				try {
					days = days + Integer.parseInt(give_days);
				} catch (Exception e) {
				}
			}
			en.setValue("active_time", new Date());
			Calendar c = Calendar.getInstance();
			c.setTime(new Date());
			c.add(Calendar.DAY_OF_YEAR, days);
			en.setValue("deadline", c.getTime());

			if ("002".equals(card_type)) {
				Entity userEn = new EntityImpl(this);
				userEn.executeQuery("select remain_amt  from f_mem_" + cust_name + " where id=?",
						new Object[] { fk_user_id });
				long remain_amt = userEn.getLongValue("remain_amt");
				remain_amt = remain_amt + amt;
				try {
					remain_amt = remain_amt + Integer.parseInt(give_days);
				} catch (Exception e) {
				}
				MemInfo.updateRemainAmtByCustname(remain_amt, fk_user_id, cust_name, this.getConnection());
			}

		} else if ("003".equals(activate_type)) { // 指定日期开卡
			en.setValue("active_time", active_time);
			state = "002";
		} else { // 首次刷卡开卡 统一开卡
			state = "002";
		}
		en.setValue("contract_no", contract_no);
		en.setValue("remark", remark);
		en.setValue("source", source);
		if ("003".equals(card_type) || "006".equals(card_type)) {
			try {
				times = times + Integer.parseInt(give_days);
			} catch (Exception e) {

			}
			en.setValue("remain_times", times);
			en.setValue("buy_times", times);
		}
		en.setValue("give_card_id", "0".equals(give_card_id) ? "" : give_card_id);
		en.setValue("give_days", give_days);
		en.setValue("give_times", give_times);
		en.setValue("ca_amt", ca_amt);
		en.setValue("real_amt", real_amt);
		en.setValue("op_id", op_id);

		en.setValue("indent_no", System.currentTimeMillis());
		en.setValue("create_time", new Date());
		// 标注在app上添加的state为010
		en.setValue("buy_for_app", state);// 用于临时储存开卡状态，审核通过后，转存至state状态
		en.setValue("state", "010");
		en.create();

		// 如果会员推荐，给推荐人添加相应积分
		if (!Utils.isNull(refer_mem_id)) {
			// 获取会所的积分设置
			int recommend_points = 0;
			try {
				recommend_points = Integer.parseInt(
						SysSet.getValues(cust_name, gym, "set_points", "recommend_points", this.getConnection()));
			} catch (Exception e) {
				// TODO: handle exception
			}
			en2.executeUpdate("update f_mem_" + cust_name + " set total_cent=ifnull(total_cent,0)+? where id=?",
					new Object[] { recommend_points, refer_mem_id });
		}
		// 赠送卡
		if ("001".equals(activate_type) && !"0".equals(give_card_id)) { // 立即激活--并且选择了卡片
			en = new EntityImpl("f_user_card", this);
			en.setTablename("f_user_card_" + gym);
			en.setValue("cust_name", cust_name);
			en.setValue("gym", gym);
			en.setValue("card_id", give_card_id);
			en.setValue("mem_id", fk_user_id);
			en.setValue("emp_id", op_id);
			en.setValue("op_id", op_id);
			en.setValue("buy_time", new Date());
			en.setValue("active_type", activate_type);
			en.setValue("remain_times", give_times);
			en.setValue("buy_times", give_times);
			en.setValue("real_amt", 0);
			en.setValue("active_time", new Date());
			Calendar c = Calendar.getInstance();
			c.setTime(new Date());
			c.add(Calendar.DAY_OF_YEAR, days);
			en.setValue("deadline", c.getTime());
			en.setValue("ca_amt", ca_amt);
			en.setValue("cash_amt", 0);
			en.setValue("card_cash_amt", 0);
			en.setValue("card_amt", 0);
			en.setValue("vouchers_amt", 0);
			en.setValue("vouchers_num", 0);
			en.setValue("wx_amt", 0);
			en.setValue("ali_amt", 0);
			en.setValue("pay_way", "free");
			en.setValue("buy_for_app", state);// 用于临时储存开卡状态，审核通过后，转存至state状态
			en.setValue("state", "010");
			en.setValue("create_time", new Date());
			en.setValue("indent_no", System.currentTimeMillis());
			en.create();
		}

	}
}
