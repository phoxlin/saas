package com.mingsokj.fitapp.flow.impl;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.json.JSONArray;
import org.json.JSONObject;

import com.jinhua.server.BasicAction;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.flow.Flow;
import com.mingsokj.fitapp.m.FitUser;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.m.card.UserUtils;
import com.mingsokj.fitapp.utils.MemUtils;

public class 商品销售Flow extends Flow {

	@Override
	public void beforeData() throws Exception {

	}

	@Override
	public void saveData() throws Exception {
		JSONArray goodsArr = new JSONArray();
		BasicAction action = this.getAct();
		String goods_str = this.getFormDataVal("goods");
		String userType = this.getFormDataVal("userType");
		String userId = this.getFormDataVal("userId");
		String mem_gym = this.getFormDataVal("mem_gym");// 会员所在GYM
		String total_amt = this.getFormDataVal("total_amt");// 不打折 不改价的情况下需支付的金额

		Long real_amt = Utils.toPriceLong(this.getPayDataVal("real_amt"));
		Long ca_amt = Utils.toPriceLong(this.getFormDataVal("ca_amt"));// 应付价格
//		String send_sms = this.getFormDataVal("sendSms");

		Float count = Float.parseFloat(this.getFormDataVal("count"));
		String payType = this.getPayDataVal("together");

		Long cash = Utils.toPriceLong(this.getPayDataVal("cash"));
		Long card = Utils.toPriceLong(this.getPayDataVal("card"));
		Long remain_amt = Utils.toPriceLong(this.getPayDataVal("remain_amt"));
		Long ticket = Utils.toPriceLong(this.getPayDataVal("ticket"));
		Long wx = Utils.toPriceLong(this.getPayDataVal("wx"));
		Long ali = Utils.toPriceLong(this.getPayDataVal("ali"));

//		String together = this.getPayDataVal("together");
		String freePay = this.getPayDataVal("freePay");
		String empDelayPay = this.getPayDataVal("empDelayPay");
		String xiaopiaoPrint = this.getPayDataVal("xiaopiaoPrint");
		String sendSms = this.getPayDataVal("sendSms");
		FitUser user = (FitUser) action.getSessionUser();
		String cust_name = this.getFormDataVal("cust_name");
		String gym = this.getFormDataVal("gym");// 当前会所

		/**
		 * 余额支付
		 */
		MemInfo mem = MemUtils.getMemInfo(userId, cust_name);
		if (remain_amt > 0) {
			if (mem != null) {
				long user_remain_amt = mem.getRemainAmt();
				user_remain_amt = user_remain_amt - remain_amt;
				if (user_remain_amt < 0) {
					throw new Exception("会员余额不足，暂不能使用余额支付");
				}
				MemInfo.updateRemainAmtByCustname(user_remain_amt, userId, cust_name, this.getConn());
			} else {
				throw new Exception("未查询到相关会员信息");
			}
		}

		if (real_amt == 0L) {// 实收金额
			real_amt += Utils.toPriceLong(this.getPayDataVal("cash"));
			real_amt += Utils.toPriceLong(this.getPayDataVal("card"));
			real_amt += Utils.toPriceLong(this.getPayDataVal("remain_amt"));
			real_amt += Utils.toPriceLong(this.getPayDataVal("ticket"));
			real_amt += Utils.toPriceLong(this.getPayDataVal("wx"));
			real_amt += Utils.toPriceLong(this.getPayDataVal("ali"));
		}

		Date now = new Date();

		if ("anonymous".equals(userType) && remain_amt > 0) {
			throw new Exception("非会员不能使用余额支付");
		}

		if (!"anonymous".equals(userType)) {
			if (mem == null) {
				throw new Exception("没有查询到该会员的信息,无法购买");
			}
		}
		// 总价格
		Long total_price = Utils.toPriceLong(total_amt);
		if (goods_str != null && !"".equals(goods_str)) {

			Boolean price_change = false;
			Float percent = real_amt.floatValue() / total_price;
			if (real_amt.longValue() != ca_amt.longValue()) {
				// 改价支付
				price_change = true;
			}

			JSONObject goods = new JSONObject(goods_str);

			Entity en = new EntityImpl(action);
			int i = 0;
			for (String id : goods.keySet()) {
				Long sale_num = goods.getJSONObject(id).getLong("num");
				String version = goods.getJSONObject(id).getString("name");

				// 查询数量是否充足
				// int s = en.executeQuery("select a.*,b.goods_name from
				// f_good_version a,f_goods b where a.goods_id =b.id and a.id =
				// ?",new Object[]{id});
				int s = en.executeQuery("select a.*  from f_good_version a where a.id = ?", new Object[] { id });
				if (s == 0) {
					throw new Exception("商品" + version + "已经不存在了");
				}
				// 数据库的规格信息
				Integer num = en.getIntegerValue("num");
				String store_id = en.getStringValue("store_id");
				String goods_id = en.getStringValue("goods_id");
				Long goods_price = en.getLongValue("goods_price");
				Long emp_price = en.getLongValue("emp_price");
				// String goods_name = en.getStringValue("goods_name");

				if (sale_num.longValue() > num.longValue()) {
					throw new Exception("商品" + version + "库存数量不足,剩余数量" + num);
				}
				JSONObject goodObj = new JSONObject();
				goodObj.put("name", version);

				// 更新库存和销量
				en.executeUpdate("update f_good_version  set num=num - ? ,sales_num =sales_num + ? where id = ?",
						new Object[] { sale_num, sale_num, id });
				// 出库
				en = new EntityImpl("f_store_rec", action);
				if ("mem".equals(userType)) {
					en.setTablename("f_store_rec_" + mem_gym);
					en.setValue("mem_id", userId);
				} else {
					en.setTablename("f_store_rec_" + gym);
				}
				en.setValue("cust_name", cust_name);
				en.setValue("gym", gym);// 可以是在哪个会所购买的
				en.setValue("goods_id", goods_id);
				en.setValue("goods_version_id", id);
				en.setValue("store_id", store_id);
				en.setValue("type", "004");
				en.setValue("nums_in", 0);
				en.setValue("nums_out", sale_num);
				en.setValue("total_nums", num);
				en.setValue("after_total_nums", num - sale_num);
				en.setValue("op_id", user.getId());
				StringBuilder remark = new StringBuilder();

				// 小票
				goodObj.put("num", sale_num);

				// 是否手动改价 暂时可以不考虑
				if (price_change) {
					if (i == goods.keySet().size() - 1) {
						en.setValue("real_amt", real_amt);
						goodObj.put("price", Utils.toPrice(real_amt / sale_num));
					} else {
						Long p = new Float(goods_price * percent).longValue();
						real_amt -= p;
						en.setValue("real_amt", p);
						goodObj.put("price", Utils.toPrice(p / sale_num));
					}
				} else {
					if ("mem".equals(userType)) {
						en.setValue("real_amt", Math.round(goods_price * sale_num * count / 100));
						goodObj.put("price", Utils.toPrice(Math.round(goods_price * count / 100)));
					} else if ("emp".equals(userType)) {
						en.setValue("real_amt", emp_price * sale_num);
						goodObj.put("price", Utils.toPrice(emp_price));

					} else {
						en.setValue("real_amt", goods_price * sale_num);
						goodObj.put("price", Utils.toPrice(goods_price));
					}
				}

				goodsArr.put(goodObj);

				en.setValue("send_msg", sendSms);
				en.setValue("staff_account", empDelayPay);
				en.setValue("print", xiaopiaoPrint);
				if ("true".equals(payType)) {
					en.setValue("pay_way", "联合支付");
				} else {
					if (cash > 0) {
						en.setValue("pay_way", "现金");
					} else if (card > 0) {
						en.setValue("pay_way", "刷卡");
					} else if (remain_amt > 0) {
						en.setValue("pay_way", "会员卡余额");
					} else if (ticket > 0) {
						en.setValue("pay_way", "代金券");
					} else if (wx > 0) {
						en.setValue("pay_way", "微信");
					} else if (ali > 0) {
						en.setValue("pay_way", "支付宝");
					}
				}
				// 免单
				if ("true".equals(freePay)) {
					en.setValue("cash", 0);
					en.setValue("card", 0);
					en.setValue("remain_amt", 0);
					en.setValue("vouchers_amt", 0);
					en.setValue("wx", 0);
					en.setValue("ali", 0);
					en.setValue("real_amt", 0);
					en.setValue("is_free", freePay);
				} else {
					// 具体支付方式及金额
					Long this_real_amt = Long.parseLong(en.getStringValue("real_amt"));
					long cal_real_amt = 0L;
					if (cash.longValue() >= this_real_amt.longValue()) {
						en.setValue("cash_amt", this_real_amt);
						cash -= this_real_amt;
					} else if (card.longValue() >= this_real_amt.longValue()) {
						en.setValue("card_amt", this_real_amt);
						card -= this_real_amt;
					} else if (remain_amt.longValue() >= this_real_amt.longValue()) {
						en.setValue("card_cash_amt", this_real_amt);
						remain_amt -= this_real_amt;
					} else if (ticket.longValue() >= this_real_amt.longValue()) {
						en.setValue("vouchers_amt", this_real_amt);
						ticket -= this_real_amt;
					} else if (wx.longValue() >= this_real_amt.longValue()) {
						en.setValue("wx_amt", this_real_amt);
						wx -= this_real_amt;
					} else if (ali.longValue() >= this_real_amt.longValue()) {
						en.setValue("ali_amt", this_real_amt);
						ali -= this_real_amt;
					} else {
						if (cash > 0 && this_real_amt != cal_real_amt) {
							if (cash > this_real_amt - cal_real_amt) {
								cash = cash - (this_real_amt - cal_real_amt);
								en.setValue("cash_amt", this_real_amt - cal_real_amt);
							} else {
								cal_real_amt += cash;
								en.setValue("cash_amt", cash);
								cash = 0l;
							}
						}
						if (card > 0 && this_real_amt != cal_real_amt) {
							if (card > this_real_amt - cal_real_amt) {
								card = card - (this_real_amt - cal_real_amt);
								en.setValue("card_amt", this_real_amt - cal_real_amt);
							} else {
								cal_real_amt += card;
								en.setValue("card_amt", card);
								card = 0l;
							}
						}
						if (remain_amt > 0 && this_real_amt != cal_real_amt) {

							if (remain_amt > this_real_amt - cal_real_amt) {
								remain_amt = remain_amt - (this_real_amt - cal_real_amt);
								en.setValue("card_cash_amt", this_real_amt - cal_real_amt);
							} else {
								cal_real_amt += remain_amt;
								en.setValue("card_cash_amt", remain_amt);
								remain_amt = 0l;
							}
						}
						if (ticket > 0 && this_real_amt != cal_real_amt) {

							if (ticket > this_real_amt - cal_real_amt) {
								ticket = ticket - (this_real_amt - cal_real_amt);
								en.setValue("vouchers_amt", this_real_amt - cal_real_amt);
							} else {
								cal_real_amt += ticket;
								en.setValue("vouchers_amt", ticket);
								ticket = 0l;
							}
						}
						if (wx > 0 && this_real_amt != cal_real_amt) {

							if (wx > this_real_amt - cal_real_amt) {
								wx = wx - (this_real_amt - cal_real_amt);
								en.setValue("wx_amt", this_real_amt - cal_real_amt);
							} else {
								cal_real_amt += wx;
								en.setValue("wx_amt", wx);
								wx = 0l;
							}

						}
						if (ali > 0 && this_real_amt != cal_real_amt) {
							if (ali > this_real_amt - cal_real_amt) {
								ali = ali - (this_real_amt - cal_real_amt);
								en.setValue("ali_amt", this_real_amt - cal_real_amt);
							} else {
								cal_real_amt += ali;
								en.setValue("ali_amt", ali);
								ali = 0l;
							}

						}
					}
				}

				if ("mem".equals(userType)) {
					remark.append("会所【" + UserUtils.getGymName(mem.getGym())+ "】的会员【").append(mem.getMem_name()).append("】购买商品【").append(version)
							.append("数量:").append(sale_num).append("应付:")
							.append(Utils.toPriceFromLongStr(goods_price * sale_num + "")).append("实付")
							.append(Utils.toPriceFromLongStr(en.getStringValue("real_amt")));
					if (total_price.longValue() != ca_amt.longValue()) {
						// 会员享受了员工价
						remark.append(",商品打折比例:" + count + "%.");
					}
					en.setValue("mem_id", userId);
				} else if ("emp".equals(userType)) {
					remark.append("内部员工【"+mem.getMem_name()+"】购买,").append("员工价:").append(Utils.toPriceFromLongStr(sale_num * emp_price + ""))
							.append("实付").append(Utils.toPriceFromLongStr(en.getStringValue("real_amt")));
					en.setValue("emp_id", userId);
					en.setValue("mem_id", userId);
				} else {
					remark.append("散客购买");
				}
				// 改价原因
				if (price_change) {
					remark.append("改价原因:....");
				}
				en.setValue("op_time", now);
				en.setValue("pay_time", now);
				en.setValue("ca_amt", goods_price * sale_num);
				en.setValue("remark", remark.toString());

				boolean is_free = Utils.isTrue(this.getPayDataVal("freePay"));
				boolean staff_account = Utils.isTrue(this.getPayDataVal("empDelayPay"));
				boolean print = Utils.isTrue(this.getPayDataVal("xiaopiaoPrint"));
				boolean send_msg = Utils.isTrue(this.getPayDataVal("sendmsm"));
				en.setValue("is_free", is_free ? "Y" : "N");
				en.setValue("staff_account", staff_account ? "Y" : "N");
				en.setValue("print", print ? "Y" : "N");
				en.setValue("send_msg", send_msg ? "Y" : "N");
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				en.setValue("pay_time", sdf.format(new Date()));
				en.create();
				// 流水
				i++;
			}

		}
		JSONObject obj = new JSONObject();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		obj.put("op_time", sdf.format(new Date()));
		obj.put("flow_num", "");
		obj.put("goods", goodsArr);
		obj.put("real_amt", this.getPayDataLongPriceVal("real_amt"));
		obj.put("ca_amt", this.getPayDataLongPriceVal("ca_amt") / 100);
		obj.put("cash_amt", this.getPayDataLongPriceVal("cash"));
		obj.put("wx_amt", this.getPayDataLongPriceVal("wx"));
		obj.put("card_amt", this.getPayDataLongPriceVal("remain_amt"));
		obj.put("card_cash_amt", this.getPayDataLongPriceVal("card"));
		obj.put("ali_amt", this.getPayDataLongPriceVal("ali"));
		if (userId != null && !"".equals(userId) && !"-1".equals(userId)) {
			MemInfo meminfo = MemUtils.getMemInfo(userId, cust_name);
			obj.put("card_number", meminfo.getMem_no());
			obj.put("user_name", meminfo.getName());
			obj.put("remain_amt", meminfo.remainAmt(this.getAct().getConnection()));
			obj.put("phone", meminfo.getPhone());
		} else {
			obj.put("card_number", "-");
			obj.put("user_name", "-");
			obj.put("remain_amt", "-");
			obj.put("phone", "-");
		}
		this.getAct().obj.put("obj", obj);

	}

	@Override
	public String getSmsWords() throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String getSmsPhoneNumber() throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

}
