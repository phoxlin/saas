package com.mingsokj.fitapp.flow.impl;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import org.json.JSONArray;
import org.json.JSONObject;

import com.jinhua.server.db.DBUtils;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.tools.RedisUtils;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.flow.Flow;
import com.mingsokj.fitapp.m.FitUser;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.utils.MemUtils;
import com.mingsokj.fitapp.ws.bg.set.SysSet;

import redis.clients.jedis.Jedis;

public class 添加会员Flow extends Flow {

	@Override
	public void beforeData() throws Exception {

	}

	@Override
	public void saveData() throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String gym = this.getFormDataVal("gym");
		String op_id = this.getFormDataVal("op_id");
		String cust_name = this.getFormDataVal("cust_name");
		String mem_name = this.getFormDataVal("mem_name");
		String refer_mem_id = this.getFormDataVal("refer_mem_id");
		String fit_purpose = this.getFormDataVal("fit_purpose");
		String sex = this.getFormDataVal("sex");
		String birthday = this.getFormDataVal("birthday");
		String id_card = this.getFormDataVal("id_card");
		String phone = this.getFormDataVal("phone");
		String card_id = this.getFormDataVal("card_id");
		String activate_type = this.getFormDataVal("activate_type");
		String active_time = this.getFormDataVal("active_time");
		String sales = this.getFormDataVal("sales_id");
		String sales_name = this.getFormDataVal("sales_name");
		String coach = this.getFormDataVal("coach");
		String coach_name = this.getFormDataVal("coach_name");
		String source = this.getFormDataVal("source");
		String ca_amt = this.getFormDataVal("real_amt");
		String contract_no = this.getFormDataVal("contract_no");
		String remark = this.getFormDataVal("remark");
		String cardNum = this.getFormDataVal("cardNum");
		String cardNum1 = this.getFormDataVal("cardNum1");
		String cardNum2 = this.getFormDataVal("cardNum2");
		String cardNum3 = this.getFormDataVal("cardNum3");
		String give_days = this.getFormDataVal("give_days");// 赠送的次数/天数/金额
		String give_card_id = this.getFormDataVal("sendCard");// 赠送的私教卡ID
		String give_times = this.getFormDataVal("give_times");// 赠送的私教卡节数
		String card_cash_int = this.getFormDataVal("card_cash_int");
		String card_cash_fee = this.getFormDataVal("card_cash_fee");
		String pic1 = this.getFormDataVal("pic1");
		// String single_price = this.getFormDataVal("single_price");
		String pri_times = this.getFormDataVal("times");

		JSONArray goods = new JSONArray();

		Entity en = new EntityImpl("f_mem", this.getAct());
		Entity en2 = new EntityImpl("f_mem", this.getAct());
		en.setTablename("f_mem_" + cust_name);
		en2.setTablename("f_mem_" + cust_name);
		// 查询添加的会员是否是会员推荐的,或则是添加的潜在客户
		boolean flag = false;
		int size2 = en2.executeQuery("select * from f_mem_" + cust_name + " where phone=? and state in('003','004')", new String[] { phone });
		String mem_id = "";
		if (size2 > 0) {
			mem_id = en2.getStringValue("id");
			flag = true;
		}
		int size3 = en2.executeQuery("select * from f_mem_" + cust_name + " where phone=? and state ='001'", new String[] { phone });
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
		en.setValue("examine_emp_id", op_id);
		en.setValue("op_id", op_id);
		en.setValue("fit_purpose", fit_purpose);
		en.setValue("create_time", new Date());
		en.setValue("indent_no", System.currentTimeMillis());
		en.setValue("pic1", pic1);
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
		Entity cardEn = new EntityImpl(this.getAct());
		cardEn.executeQuery("select days,times,card_type,amt,card_name from f_card where id=?", new Object[] { card_id });
		int days = 0;
		try {
			days = cardEn.getIntegerValue("days");
		} catch (Exception e) {
		} finally {
			days = 365 * 100;
		}

		int times = cardEn.getIntegerValue("times");
		String card_type = cardEn.getStringValue("card_type");

		try {
			if ("006".equals(card_type)) {
				times = Integer.parseInt(pri_times);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		long amt = cardEn.getLongValue("amt");
		String card_name = cardEn.getStringValue("card_name");

		en = new EntityImpl("f_user_card", this.getAct());
		en.setTablename("f_user_card_" + gym);
		en.setValue("cust_name", cust_name);
		en.setValue("gym", gym);
		en.setValue("card_id", card_id);
		en.setValue("mem_id", fk_user_id);
		en.setValue("mc_id", sales);
		en.setValue("pt_id", coach);
		en.setValue("buy_time", new Date());
		en.setValue("pay_time", Utils.parseData(new Date(), "yyyy-MM-dd HH:mm:ss"));
		en.setValue("create_time", new Date());
		en.setValue("indent_no", System.currentTimeMillis());
		en.setValue("active_type", activate_type);
		String state = "001";
		if ("001".equals(activate_type)) { // 立即激活
			if ("001".equals(card_type)) {
				try {
					days = days + Integer.parseInt(give_days);
				} catch (Exception e) {
				}
				if (days == 0) {
					days = 100 * 365;
				}
			}
			en.setValue("active_time", new Date());
			Calendar c = Calendar.getInstance();
			c.setTime(new Date());
			c.add(Calendar.DAY_OF_YEAR, days);
			en.setValue("deadline", c.getTime());

			if ("002".equals(card_type)) {
				Entity userEn = new EntityImpl(this.getAct());
				userEn.executeQuery("select remain_amt  from f_mem_" + cust_name + " where id=?", new Object[] { fk_user_id });
				long remain_amt = userEn.getLongValue("remain_amt");
				remain_amt = remain_amt + amt * 100;
				try {
					remain_amt = remain_amt + Integer.parseInt(give_days) * 100;
				} catch (Exception e) {
				}
				// userEn.executeUpdate("update f_mem_" + cust_name + " set
				// remain_amt=? where id=?", new Object[] { remain_amt ,
				// fk_user_id });
				MemInfo.updateRemainAmtByCustname(remain_amt, fk_user_id, cust_name, this.getAct().getConnection());
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
		en.setValue("state", state);
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
		en.setValue("create_time", new Date());
		en.setValue("examine_emp_id", op_id);
		en.setValue("op_id", op_id);
		en.setValue("indent_no", System.currentTimeMillis());
		setPayEntityInfo2(en, Long.parseLong(ca_amt) * 100 + "", card_cash_int, card_cash_fee);
		Long yj = Long.parseLong(card_cash_fee) * 100;
		en.setValue("real_amt2", this.getPayDataLongPriceVal("real_amt") - yj);

		String buycard_id = en.create();

		JSONObject good = new JSONObject();
		good.put("name", card_name);
		good.put("price", ca_amt);
		good.put("num", 1);
		goods.put(good);

		// 如果会员推荐，给推荐人添加相应积分
		if (!Utils.isNull(refer_mem_id)) {
			// 获取会所的积分设置
			int recommend_points = 0;
			try {
				recommend_points = Integer.parseInt(SysSet.getValues(cust_name, gym, "set_points", "recommend_points", this.getAct().getConnection()));
			} catch (Exception e) {
			}
			en2.executeUpdate("update f_mem_" + cust_name + " set total_cent=ifnull(total_cent,0)+? where id=?", new Object[] { recommend_points, refer_mem_id });
		}
		// 是推荐的
		if (flag) {
			// 添加推荐人与该会员的关系
			Entity mem_recommend = new EntityImpl("f_mem_recommend", this.getAct());
			mem_recommend.setTablename("f_mem_recommend_" + gym);
			mem_recommend.setValue("recommend_mem_id", refer_mem_id);
			mem_recommend.setValue("be_recommend_mem_id", fk_user_id);
			mem_recommend.setValue("op_time", new Date());
			mem_recommend.create();
		}

		MemInfo m = new MemInfo();
		m.setPhone(phone);
		m.setSex(sex);
		m.setMem_name(mem_name);
		m.setGym(gym);
		m.setCust_name(cust_name);
		m.setBirthday(birthday);
		m.setIdCard(id_card);
		m.setState("001");
		m.setId(fk_user_id);
		m.setMc_id(sales);

		Jedis jd = RedisUtils.getConnection();
		RedisUtils.setHParam("MEM_" + gym, fk_user_id, m, jd);
		RedisUtils.setHParam("MEM_GYM", fk_user_id, gym, jd);
		RedisUtils.setHParam("MEM_CUST_NAME", fk_user_id, cust_name, jd);
		RedisUtils.freeConnection(jd);

		// if ("Y".equals(card_cash_int)) {
		boolean gived = true;
		// 更新会员卡号
		MemInfo mem1 = MemUtils.getMemInfo(fk_user_id, cust_name, this.getAct().L, true, this.getAct().getConnection());
		if (mem1 != null) {
			String mem_no = mem1.getMem_no();
			if (!"".equals(mem_no) && mem_no != null) {
				gived = false;
			}
		}
		// 平均押金
		int cards = 0;
		if (!Utils.isNull(cardNum)) {
			cards += 1;
		}
		if (!Utils.isNull(cardNum1)) {
			cards += 1;
		}
		if (!Utils.isNull(cardNum2)) {
			cards += 1;
		}
		if (!Utils.isNull(cardNum3)) {
			cards += 1;
		}
		// 算押金
		Long avg = 0l;
		try {
			avg = Utils.toPriceLong(card_cash_fee) / cards;
		} catch (Exception e) {
		}
		if (!Utils.isNull(cardNum) && gived) {
			MemInfo mem = new MemInfo();
			mem.setId(fk_user_id);
			mem.setMem_no(cardNum);
			mem.setCard_deposit_amt(avg);
			mem.setCust_name(cust_name);
			mem.update(this.getAct().getConnection(), false);
		}
		if (!Utils.isNull(cardNum1)) {
			mem1.setId(DBUtils.oid());
			mem1.setCard_deposit_amt(avg);
			mem1.setMem_no(cardNum1);
			mem1.setPid(fk_user_id);
			mem1.create(this.getAct().getConnection());
		}
		if (!Utils.isNull(cardNum2)) {
			mem1.setId(DBUtils.oid());
			mem1.setCard_deposit_amt(avg);
			mem1.setMem_no(cardNum2);
			mem1.setPid(fk_user_id);
			mem1.create(this.getAct().getConnection());
		}
		if (!Utils.isNull(cardNum3)) {
			mem1.setId(DBUtils.oid());
			mem1.setCard_deposit_amt(avg);
			mem1.setMem_no(cardNum3);
			mem1.setPid(fk_user_id);
			mem1.create(this.getAct().getConnection());
		}

		// 发卡押金
		en = new EntityImpl("f_other_pay", this.getAct());
		en.setTablename("f_other_pay_" + gym);
		en.setValue("real_amt", Utils.toPriceLong(card_cash_fee));
		en.setValue("ca_amt", Utils.toPriceLong(card_cash_fee));
		en.setValue("cash_amt", Utils.toPriceLong(card_cash_fee));
		en.setValue("card_cash_amt", 0);
		en.setValue("card_amt", 0);
		en.setValue("vouchers_amt", 0);
		en.setValue("vouchers_num", 0);
		en.setValue("wx_amt", 0);
		en.setValue("ali_amt", 0);
		en.setValue("is_free", "N");
		en.setValue("staff_account", "N");
		en.setValue("print", "N");
		en.setValue("pay_way", "cash_amt");
		en.setValue("send_msg", "N");
		en.setValue("pay_time", sdf.format(new Date()));
		en.setValue("pay_type", "发卡押金");
		en.setValue("mem_id", fk_user_id);

		FitUser user = (FitUser) this.getAct().getSessionUser();
		en.setValue("emp_id", user.getId());
		en.create();
		good = new JSONObject();
		good.put("name", "发卡押金");
		good.put("price", Utils.toPrice(avg));
		good.put("num", cards);
		goods.put(good);
		// }

		// 购买信息
		this.getAct().obj.put("buy_id", buycard_id);
		// 是否打印
		// action.obj.put("isPrintContract", "Y");
		String contractType = card_type;
		// 打印类型
		this.getAct().obj.put("contractType", contractType);

		// 赠送卡
		if ("001".equals(activate_type) && !"0".equals(give_card_id)) { // 立即激活--并且选择了卡片
			en = new EntityImpl("f_user_card", this.getAct());
			en.setTablename("f_user_card_" + gym);
			en.setValue("cust_name", cust_name);
			en.setValue("gym", gym);
			en.setValue("card_id", give_card_id);
			en.setValue("mem_id", fk_user_id);
			en.setValue("emp_id", op_id);
			en.setValue("examine_emp_id", op_id);
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
			en.setValue("state", "001");
			en.setValue("create_time", new Date());
			en.setValue("indent_no", System.currentTimeMillis());
			en.create();
		}

		JSONObject obj = new JSONObject();
		obj.put("op_time", sdf.format(new Date()));
		obj.put("flow_num", buycard_id);
		obj.put("goods", goods);
		obj.put("coach_name", coach_name);
		obj.put("sales_name", sales_name);
		obj.put("ca_amt", this.getPayDataLongPriceVal("ca_amt") / 100);
		obj.put("real_amt", this.getPayDataLongPriceVal("real_amt"));
		obj.put("cash_amt", this.getPayDataLongPriceVal("cash"));
		obj.put("wx_amt", this.getPayDataLongPriceVal("wx"));
		obj.put("card_amt", this.getPayDataLongPriceVal("remain_amt"));
		obj.put("card_cash_amt", this.getPayDataLongPriceVal("card"));
		obj.put("ali_amt", this.getPayDataLongPriceVal("ali"));
		obj.put("card_number", cardNum);
		obj.put("user_name", mem_name);
		obj.put("remain_amt", '0');
		obj.put("phone", phone);

		this.getAct().obj.put("obj", obj);

		// 是否打印合同
		String printContract = SysSet.getValues(cust_name, gym, "set_xiao_print", "printContract", this.getAct().getConnection());
		if (Utils.isNull(printContract)) {
			printContract = "ok";
		}
		this.getAct().obj.put("printContract", printContract);

	}

	@Override
	public String getSmsWords() throws Exception {
		return null;
	}

	@Override
	public String getSmsPhoneNumber() throws Exception {
		return null;
	}

	public void setPayEntityInfo2(Entity en, String ca_amt, String card_cash_int, String card_cash_fee) throws Exception {
		long real_amt = this.getPayDataLongPriceVal("real_amt");
		long cash_amt = this.getPayDataLongPriceVal("cash");
		long card_cash_amt = this.getPayDataLongPriceVal("remain_amt");
		long card_amt = this.getPayDataLongPriceVal("card");
		long vouchers_amt = this.getPayDataLongPriceVal("ticket");
		String vouchers_num = this.getPayDataVal("vouchers_num");
		long wx_amt = this.getPayDataLongPriceVal("wx");
		long ali_amt = this.getPayDataLongPriceVal("ali");
		boolean is_free = Utils.isTrue(this.getPayDataVal("freePay"));
		boolean staff_account = Utils.isTrue(this.getPayDataVal("empDelayPay"));
		boolean print = Utils.isTrue(this.getPayDataVal("xiaopiaoPrint"));
		boolean send_msg = Utils.isTrue(this.getPayDataVal("sendmsm"));

		if (is_free) {
			en.setValue("real_amt", 0);
			en.setValue("ca_amt", ca_amt);
			en.setValue("cash_amt", 0);
			en.setValue("card_cash_amt", 0);
			en.setValue("card_amt", 0);
			en.setValue("vouchers_amt", 0);
			en.setValue("vouchers_num", 0);
			en.setValue("wx_amt", 0);
			en.setValue("ali_amt", 0);
			en.setValue("pay_way", "free");
		} else {
			if ("Y".equals(card_cash_int)) {
				// en.setValue("real_amt", real_amt -
				// (Long.parseLong(card_cash_fee) * 100));
				Long yj = Long.parseLong(card_cash_fee) * 100;
				en.setValue("real_amt", real_amt - yj);
				// 从其他支付中减去押金
				if (cash_amt >= yj) {
					cash_amt -= yj;
				} else if (card_cash_amt >= yj) {
					card_cash_amt -= yj;
				} else if (card_amt >= yj) {
					card_amt -= yj;
				} else if (vouchers_amt >= yj) {
					vouchers_amt -= yj;
				} else if (wx_amt >= yj) {
					wx_amt -= yj;
				} else if (ali_amt >= yj) {
					ali_amt -= yj;
				} else {
					// 都求不够 拿来凑
					while (yj != 0L) {
						Long now = yj;
						if (cash_amt > 0) {
							yj -= cash_amt;
							cash_amt = cash_amt - now;
						} else if (card_cash_amt > 0) {
							yj -= card_cash_amt;
							card_cash_amt = 0L;
						} else if (card_amt > 0) {
							yj -= card_amt;
							card_amt = card_amt - now;
						} else if (vouchers_amt > 0) {
							yj -= vouchers_amt;
							vouchers_amt = vouchers_amt - now;
						} else if (wx_amt > 0) {
							yj -= wx_amt;
							wx_amt = wx_amt - now;
						} else if (ali_amt > 0) {
							yj -= ali_amt;
							ali_amt = ali_amt - now;
						}
					}
				}
			} else {
				en.setValue("real_amt", real_amt);
			}
			en.setValue("ca_amt", ca_amt);
			en.setValue("cash_amt", cash_amt);
			en.setValue("card_cash_amt", card_cash_amt);
			en.setValue("card_amt", card_amt);
			en.setValue("vouchers_amt", vouchers_amt);
			en.setValue("vouchers_num", vouchers_num);
			en.setValue("wx_amt", wx_amt);
			en.setValue("ali_amt", ali_amt);

			boolean set = false;
			if (cash_amt > 0) {
				set = true;
				en.setValue("pay_way", "cash_amt");
			}
			if (card_cash_amt > 0) {
				if (set) {
					en.setValue("pay_way", "together");
				} else {
					en.setValue("pay_way", "card_cash_amt");
				}
				set = true;
			}
			if (card_amt > 0) {
				if (set) {
					en.setValue("pay_way", "together");
				} else {
					en.setValue("pay_way", "card_amt");
				}
				set = true;
			}

			if (vouchers_amt > 0) {
				if (set) {
					en.setValue("pay_way", "together");
				} else {
					en.setValue("pay_way", "vouchers_amt");
				}
				set = true;
			}

			if (wx_amt > 0) {
				if (set) {
					en.setValue("pay_way", "together");
				} else {
					en.setValue("pay_way", "wx_amt");
				}
				set = true;
			}

			if (ali_amt > 0) {
				if (set) {
					en.setValue("pay_way", "together");
				} else {
					en.setValue("pay_way", "ali_amt");
				}
				set = true;
			}

		}
		en.setValue("is_free", is_free ? "Y" : "N");
		en.setValue("staff_account", staff_account ? "Y" : "N");
		en.setValue("print", print ? "Y" : "N");
		en.setValue("send_msg", send_msg ? "Y" : "N");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		en.setValue("pay_time", sdf.format(new Date()));
	}

}
