package com.mingsokj.fitapp.flow.impl;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import org.json.JSONArray;
import org.json.JSONObject;

import com.jinhua.server.BasicAction;
import com.jinhua.server.db.DBUtils;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.flow.Flow;
import com.mingsokj.fitapp.m.FitUser;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.utils.MemUtils;
import com.mingsokj.fitapp.ws.bg.set.SysSet;

public class 购卡Flow extends Flow {

	public 购卡Flow() {
		super();
	}

	// 保存前的数据检查，也可以先不做.
	@Override
	public void beforeData() throws Exception {

	}

	@Override
	public void saveData() throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String flowId = this.getPayDataVal("flowId");
		String card_id = this.getFormDataVal("card_id");
		String preId = this.getFormDataVal("preId");
		String pre_fee = this.getFormDataVal("pre_fee");
		String activate_type = this.getFormDataVal("activate_type");
		String active_time = this.getFormDataVal("active_time");
		String sales_id = this.getFormDataVal("sales_id");
		String sales_name = this.getFormDataVal("sales_name");
		String coach_id = this.getFormDataVal("coach_id");
		String coach_name = this.getFormDataVal("coach_name");
		String source = this.getFormDataVal("source");
		String ca_amt = this.getFormDataVal("real_amt");
		String contract_no = this.getFormDataVal("contract_no");
		String remark = this.getFormDataVal("remark");
		String fk_user_id = this.getFormDataVal("userId");
		String gym = this.getFormDataVal("gym");
		String cust_name = this.getFormDataVal("cust_name");
		String cardNum = this.getFormDataVal("cardNum");
		String cardNum1 = this.getFormDataVal("cardNum1");
		String cardNum2 = this.getFormDataVal("cardNum2");
		String cardNum3 = this.getFormDataVal("cardNum3");
		String give_days = this.getFormDataVal("give_days");// 赠送的次数/天数/金额
		String give_card_id = this.getFormDataVal("sendCard");// 赠送的私教卡ID
		String give_times = this.getFormDataVal("give_times");// 赠送的私教卡节数
		String op_id = this.getFormDataVal("op_id");
		String card_cash_int = this.getFormDataVal("card_cash_int");
		String card_cash_fee = this.getFormDataVal("card_cash_fee");
		// String single_price = this.getFormDataVal("single_price");
		String pri_times = this.getFormDataVal("times");

		if (Long.parseLong(pre_fee) > 0) {
			long xx = Long.parseLong(ca_amt) * 100 - Long.parseLong(pre_fee) * 100;
			if (xx < 0) {
				xx = 0;
			}
			ca_amt = Utils.toPrice(xx);
		}
		JSONArray goods = new JSONArray();
		BasicAction action = this.getAct();
		if ("".equals(card_id)) {
			throw new Exception("请选择会员卡");
		}
		Entity cardEn = new EntityImpl(this.getAct());
		cardEn.executeQuery("select days,times,amt,card_type,card_name from f_card where id=?",
				new Object[] { card_id });

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
		MemInfo info = MemUtils.getMemInfo(fk_user_id, cust_name);
		if (info != null) {
			String state = info.getState();
			if ("005".equals(state)) {
				throw new Exception("用户正在请假中，如需购卡请先销假");
			}
		} else {
			throw new Exception("未查询到相关会员信息");
		}

		/**
		 * 余额支付
		 */
		Long pay_remain_amt = Utils.toPriceLong(this.getPayDataVal("remain_amt"));
		if (pay_remain_amt > 0) {

			long user_remain_amt = info.getRemainAmt();
			user_remain_amt = user_remain_amt - pay_remain_amt;
			if (user_remain_amt < 0) {
				throw new Exception("会员余额不足，暂不能使用余额支付");
			}
			MemInfo.updateRemainAmtByCustname(user_remain_amt, fk_user_id, cust_name, this.getConn());
		}

		Entity en = new EntityImpl(this.getAct());
		en = new EntityImpl("f_user_card", this.getAct());
		en.setTablename("f_user_card_" + gym);
		en.setValue("cust_name", cust_name);
		en.setValue("gym", gym);
		en.setValue("card_id", card_id);
		en.setValue("mem_id", fk_user_id);
		en.setValue("mc_id", sales_id);
		en.setValue("pt_id", coach_id);
		en.setValue("buy_time", new Date());
		en.setValue("pay_time", Utils.parseData(new Date(), "yyyy-MM-dd HH:mm:ss"));
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
				userEn.executeQuery("select remain_amt  from f_mem_" + cust_name + " where id=?",
						new Object[] { fk_user_id });
				String tmp = userEn.getStringValue("remain_amt");
				long remain_amt = tmp != null && tmp.length() > 0 ? Long.parseLong(tmp) : 0;
				remain_amt = remain_amt + amt * 100;
				try {
					remain_amt = remain_amt + Integer.parseInt(give_days) * 100;
				} catch (Exception e) {
				}
				MemInfo.updateRemainAmtByCustname(remain_amt, fk_user_id, cust_name, this.getConn());
			}

		} else if ("003".equals(activate_type)) { // 指定日期开卡
			en.setValue("active_time", active_time);
			state = "002";
		} else { // 首次刷卡开卡 统一开卡
			state = "002";
			en.setValue("active_time", Utils.parseData(new Date(), "yyyy-MM-dd"));
		}
		en.setValue("contract_no", contract_no);
		if (preId != null && !"".equals(preId)) {
			remark = remark + "   ,预付费抵扣" + pre_fee;
		}
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
		en.setValue("op_id", op_id);
		en.setValue("examine_emp_id", op_id);

		if ("Y".equals(card_cash_int)) {
			en.setValue("give_card", "Y");
		} else {
			en.setValue("give_card", "N");
		}

		setPayEntityInfo2(en, Float.parseFloat(ca_amt) * 100 + "", card_cash_int, card_cash_fee);
		en.setValue("create_time", new Date());
		en.setValue("indent_no", flowId);
		Long yj = Long.parseLong(card_cash_fee) * 100;
		en.setValue("real_amt2", this.getPayDataLongPriceVal("real_amt") - yj);
		String buycard_id = en.create();

		// 购买信息
		action.obj.put("buy_id", buycard_id);
		// 是否打印
		// action.obj.put("isPrintContract", "Y");
		String contractType = card_type;
		// 打印类型
		action.obj.put("contractType", contractType);

		JSONObject good = new JSONObject();
		good.put("name", card_name);
		good.put("price", ca_amt);
		good.put("num", 1);
		goods.put(good);

//		if ("Y".equals(card_cash_int)) {
			// 更新会员卡号
			MemInfo mem1 = MemUtils.getMemInfo(fk_user_id, cust_name);
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
			if (cards > 0) {
				Long avg = Utils.toPriceLong(card_cash_fee) / cards;
				if (!Utils.isNull(cardNum)) {
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
				good.put("name", "卡押金");
				good.put("price", Utils.toPrice(avg));
				good.put("num", cards);
				goods.put(good);
			}
//		}
		MemInfo.updateStateByGym("001", gym, this.getAct().getConnection(), fk_user_id);

		// 赠送卡
		if ("001".equals(activate_type) && !"0".equals(give_card_id)) { // 立即激活--并且选择了卡片
			en = new EntityImpl("f_user_card", this.getAct());
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
			en.setValue("state", "001");
			en.setValue("create_time", new Date());
			en.setValue("indent_no", System.currentTimeMillis());
			en.create();
		}
		// 更新定金表
		if (preId != null && !"".equals(preId)) {
			en.executeUpdate("update f_pre_fee_" + gym + " set state='002' where id=?", new Object[] { preId });
		}

		JSONObject obj = new JSONObject();
		obj.put("op_time", sdf.format(new Date()));
		obj.put("flow_num", buycard_id);
		obj.put("goods", goods);
		obj.put("coach_name", coach_name);
		obj.put("sales_name", sales_name);
		obj.put("ca_amt", ca_amt);
		obj.put("real_amt", this.getPayDataLongPriceVal("real_amt"));
		obj.put("ca_amt", this.getPayDataLongPriceVal("ca_amt") / 100);
		obj.put("cash_amt", this.getPayDataLongPriceVal("cash"));
		obj.put("wx_amt", this.getPayDataLongPriceVal("wx"));
		obj.put("card_amt", this.getPayDataLongPriceVal("remain_amt"));
		obj.put("card_cash_amt", this.getPayDataLongPriceVal("card"));
		obj.put("ali_amt", this.getPayDataLongPriceVal("ali"));
		obj.put("card_number", cardNum);
		MemInfo mem = MemUtils.getMemInfo(fk_user_id, cust_name);
		obj.put("user_name", mem.getName());
		// obj.put("remain_amt", mem.remainAmt(this.getAct().getConnection()));
		obj.put("phone", mem.getPhone());

		action.obj.put("obj", obj);

		// 修改会员状态
		MemInfo memInfo = new MemInfo();
		memInfo.setId(fk_user_id);
		memInfo.setGym(gym);
		memInfo.setCust_name(cust_name);
		memInfo.setState("001");
		// 会员如果没有专属教练或会籍则添加进去
		Entity memEntity = new EntityImpl("f_mem", this.getAct().getConnection());
		memEntity.setTablename("f_mem_" + cust_name);
		memEntity.setValue("id", fk_user_id);
		int memSize = memEntity.search();
		if (memSize > 0) {
			String mc_id = memEntity.getStringValue("mc_id");
			String pt_names = memEntity.getStringValue("pt_names");
			if ((mc_id == null || "".equals(mc_id)) && sales_id != null && !"".equals(sales_id)) {
				memInfo.setMc_id(sales_id);
			}
			if ((pt_names == null || "".equals(pt_names)) && coach_id != null && !"".equals(coach_id)) {
				memInfo.setPt_names(coach_id);
			}

		}
		memInfo.update(this.getAct().getConnection(), false);
		// 是否打印合同
		String printContract = SysSet.getValues(cust_name, gym, "set_xiao_print", "printContract",
				this.getAct().getConnection());
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

	public void setPayEntityInfo2(Entity en, String ca_amt, String card_cash_int, String card_cash_fee)
			throws Exception {
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
						if (cash_amt > 0) {
							if (cash_amt >= yj) {
								cash_amt -= yj;
								yj = 0L;
							} else {
								yj -= cash_amt;
							}
						} else if (card_cash_amt > 0) {
							if (card_cash_amt >= yj) {
								card_cash_amt -= yj;
								yj = 0L;
							} else {
								yj -= card_cash_amt;
							}
						} else if (card_amt > 0) {
							if (card_amt >= yj) {
								card_amt -= yj;
								yj = 0L;
							} else {
								yj -= card_amt;
							}
						} else if (vouchers_amt > 0) {
							if (vouchers_amt >= yj) {
								vouchers_amt -= yj;
								yj = 0L;
							} else {
								yj -= vouchers_amt;
							}
						} else if (wx_amt > 0) {
							if (wx_amt >= yj) {
								wx_amt -= yj;
								yj = 0L;
							} else {
								yj -= wx_amt;
							}
						} else if (ali_amt > 0) {
							if (ali_amt >= yj) {
								ali_amt -= yj;
								yj = 0L;
							} else {
								yj -= ali_amt;
							}
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
