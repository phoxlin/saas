package com.mingsokj.fitapp.ws.bg;

import java.text.SimpleDateFormat;
import java.util.Date;
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
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.m.FitUser;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.utils.MemUtils;
import com.mingsokj.fitapp.ws.bg.set.SysSet;

public class CheckInAction extends BasicAction {
	@Route(value = "/fit-cashier-seachMemByHandNo", conn = true, type = ContentType.JSON, m = HttpMethod.POST)
	public void seachMemByHandNo() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String cust_name = user.getCust_name();
		String handNo = this.getParameter("cashier_handNo");
		Entity en = new EntityImpl(this);
		String sql = " select mem_id,mem_gym,checkin_time  from f_checkin_" + gym
				+ " where hand_no=? and is_backHand='N' ";
		int size = en.executeQuery(sql, new Object[] { handNo });
		if (size > 0) {
			String mem_id = en.getStringValue("mem_id");
			String checkin_time = en.getFormatStringValue("checkin_time", "yyyy-MM-dd HH:mm:ss");
			sql = "select phone,mem_name,pic1 from f_mem_" + cust_name + " where id=?";
			size = en.executeQuery(sql, new Object[] { mem_id });
			if (size > 0) {
				Map<String, Object> userList = en.getValues().get(0);
				userList.put("checkin_time", checkin_time);
				this.obj.put("user", userList);
			}
		}
	}

	/**
	 * 借出手环
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-cashier-lendHandNo", conn = true, type = ContentType.JSON, m = HttpMethod.POST)
	public void lendHandNo() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String mem_id = this.getParameter("mem_id");
		String handNo = this.getParameter("handNo");
		Entity en = new EntityImpl(this);
		String sql = " select id  from f_checkin_" + gym + " where  hand_no=? and  state='002' ";
		int size = en.executeQuery(sql, new Object[] { handNo });
		if (size > 0) {
			throw new Exception("手牌【" + handNo + "】已经被使用，请更换一个");
		}
		sql = " select id  from f_checkin_" + gym + " where mem_id=? and  state='002' ";
		size = en.executeQuery(sql, new Object[] { mem_id });
		if (size > 0) {
			String id = en.getStringValue("id");
			en.executeUpdate("update f_checkin_" + gym + " set hand_no=?, is_backHand='N' where id=?",
					new Object[] { handNo, id });
		} else {
			// 单次入场券入场借用手环
			en.executeUpdate("update f_checkin_" + gym + " set hand_no=?, is_backHand='N' where id=?",
					new Object[] { handNo, mem_id });
		}
	}

	@Route(value = "/fit-cashier-seachMemBymemId", conn = true, type = ContentType.JSON, m = HttpMethod.POST)
	public void seachMemBymemId() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String cust_name = user.getCust_name();
		String mem_id = this.getParameter("mem_id");
		Entity en = new EntityImpl(this);
		String sql = "select phone,mem_name,pic1 from f_mem_" + cust_name + " where id=?";
		int size = en.executeQuery(sql, new Object[] { mem_id });
		if (size > 0) {
			Map<String, Object> userList = en.getValues().get(0);
			this.obj.put("user", userList);
		}
	}

	@Route(value = "/fit-cashier-notbackHand", conn = true, type = ContentType.JSON, m = HttpMethod.POST)
	public void notbackHand() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		Entity en = new EntityImpl(this);
		String sql = " select hand_no  from f_checkin_" + gym + " where  is_backHand='N' ";
		en.executeQuery(sql);
		this.obj.put("data", en.getValues());

	}

	@Route(value = "/fit-cashier-backHandNo", conn = true, type = ContentType.JSON, m = HttpMethod.POST)
	public void backHandNo() throws Exception {
		String handNo = this.getParameter("cashier_handNo");
		String remark = this.getParameter("remark");
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		Entity en = new EntityImpl(this);
		String sql = " select id,state  from f_checkin_" + gym + " where hand_no=? and is_backHand='N' ";
		int size = en.executeQuery(sql, new Object[] { handNo });
		if (size > 0) {
			String id = en.getStringValue("id");
			String state = en.getStringValue("state");
			if ("002".equals(state)) {
				en.executeUpdate(
						"update f_checkin_" + gym
								+ " set state='004',is_backHand='Y',checkout_time=?,remark=? where id=? ",
						new Object[] { new Date(), remark, id });
			} else {
				en.executeUpdate("update f_checkin_" + gym + " set state='004',is_backHand='Y',remark=? where id=? ",
						new Object[] { remark, id });
			}

		} else {
			throw new Exception("未查询到该手牌的入场信息");
		}

	}

	@Route(value = "/fit-userinfo-checkOut", conn = true, type = ContentType.JSON, m = HttpMethod.POST)
	public void checkOut() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String fk_user_id = this.getParameter("fk_user_id");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String now = sdf.format(new Date());
		String gym = user.getViewGym();
		Entity en = new EntityImpl(this);
		String sql = " select id, MAX(checkin_time)  from f_checkin_" + gym + " where mem_id=?  and state='002'";
		int size = en.executeQuery(sql, new Object[] { fk_user_id });
		if (size > 0) {
			String id = en.getStringValue("id");
			if (id != null && id.length() > 0) {
				en.executeUpdate(
						"update f_checkin_" + gym + " set state='004',is_backHand='Y',checkout_time=?  where id=? ",
						new Object[] { now, id });
			}
		}
	}

	@Route(value = "/fit-userinfo-getCheckInMsg", conn = true, type = ContentType.JSON, m = HttpMethod.POST)
	public void getCheckInMsg() throws Exception {
		String checkinId = this.getParameter("checkinId");
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();

		Entity en = new EntityImpl(this);

		int size = en.executeQuery("select * from f_checkin_" + gym + " where id=? ", new Object[] { checkinId });
		if (size > 0) {
			String checkin_fee = en.getStringValue("checkin_fee");
			String hand_no = en.getStringValue("hand_no");
			Date checkin_time = en.getDateValue("checkin_time");
			String fk_user_id = en.getStringValue("mem_id");

			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			JSONObject obj = new JSONObject();
			obj.put("op_time", sdf.format(new Date()));
			obj.put("flow_num", "");
			JSONArray goods = new JSONArray();
			if (!"".equals(checkin_fee) && checkin_fee != null) {
				JSONObject good = new JSONObject();
				good.put("name", "入场收费");
				good.put("price", checkin_fee);
				good.put("num", 1);
				goods.put(good);
			}
			obj.put("goods", goods);
			obj.put("hand_no", hand_no);
			obj.put("checkin_time", sdf.format(checkin_time));
			obj.put("ca_amt", checkin_fee);
			obj.put("real_amt", Long.parseLong(checkin_fee) * 100);
			obj.put("cash_amt", 0);
			obj.put("wx_amt", 0);
			obj.put("card_amt", Long.parseLong(checkin_fee) * 100);
			obj.put("card_cash_amt", 0);
			obj.put("remain_amt", checkin_fee);
			obj.put("ali_amt", 0);
			MemInfo mem = MemUtils.getMemInfo(fk_user_id, user.getCust_name());
			obj.put("card_number", mem.getMem_no());
			obj.put("user_name", mem.getName());
			obj.put("phone", mem.getPhone());

			this.obj.put("obj", obj);
		}
	}

	@Route(value = "/fit-userinfo-checkIn", conn = true, type = ContentType.JSON, m = HttpMethod.POST)
	public void checkIn() throws Exception {
		String conf = this.getParameter("conf");
		FitUser user = (FitUser) this.getSessionUser();
		String fk_user_id = this.getParameter("fk_user_id");
		String fk_user_gym = this.getParameter("fk_user_gym");
		String checkin_user_card_id = this.getParameter("checkin_user_card_id");
		String hand_no = this.getParameter("hand_no");
		String gym = user.getViewGym();

		String cust_name = user.getCust_name();
		Entity en = new EntityImpl(this);
		MemInfo mem = MemUtils.getMemInfo(fk_user_id, cust_name);

		if ("".equals(conf) || conf.length() <= 0 || conf == null) {
			conf = "N";
		}

		if (mem != null) {
			String state = mem.getState();
			if (!"001".equals(state)) {
				throw new Exception("用户未激活，暂不能入场");
			}
			Map<String, Object> checkinfo = mem.getCheckinfo(user.getViewGym());
			if (!Utils.isNull(checkinfo)) {
				throw new Exception("该用户已经入场或还有未归还的手牌，暂不能入场");
			}

		} else {
			throw new Exception("未查询到相关用户信息，请刷新后重试");
		}

		List<Map<String, Object>> cardList = mem.getCardList(user.getViewGym());
		if (Utils.isNull(cardList)) {
			throw new Exception("未查询到相关卡片信息，请刷新后重试");
		}
		Map<String, Object> card = null;
		for (Map<String, Object> m : cardList) {
			String id = m.get("card_id") + "";
			if (id.equals(checkin_user_card_id)) {
				card = m;
			}
		}
		if (Utils.isNull(card)) {
			/**
			 * 自动入场 默认选择一张卡 如果有天数卡默认选择天数卡
			 * 
			 */
			for (Map<String, Object> m : cardList) {
				String card_type = Utils.getMapStringValue(m, "card_type");
				if ("001".equals(card_type)) {
					card = m;
					break;
				}
			}
		}
		/**
		 * 如果没有天数卡 则选择次数卡
		 * 
		 */
		if (Utils.isNull(card)) {
			for (Map<String, Object> m : cardList) {
				String card_type = Utils.getMapStringValue(m, "card_type");
				if ("003".equals(card_type)) {
					card = m;
					break;
				}
			}
		}
		/**
		 * 自动入场如果没有次数卡则选择储值卡
		 * 
		 */
		if (Utils.isNull(card)) {
			for (Map<String, Object> m : cardList) {
				String card_type = Utils.getMapStringValue(m, "card_type");
				if ("002".equals(card_type)) {
					card = m;
					break;
				}
			}
		}
		if (Utils.isNull(card)) {
			throw new Exception("未查询到可用的会员卡，咱不能入场");
		}

		String card_type = Utils.getMapStringValue(card, "card_type");
		String card_name = Utils.getMapStringValue(card, "card_name");
		String checkin_fee = Utils.getMapStringValue(card, "checkin_fee");
		String card_state = Utils.getMapStringValue(card, "state");
		if (!"001".equals(card_state)) {
			throw new Exception("会员卡未激活，暂不能入场，请先激活");
		}
		if ("".equals(checkin_fee)) {
			checkin_fee = "0";
		}

		String sql = " select id,state  from f_checkin_" + gym + " where hand_no=? and is_backHand='N' ";
		int size = en.executeQuery(sql, new Object[] { hand_no });
		if (size > 0) {
			throw new Exception("手牌【" + hand_no + "】已经被使用，请更换一个");
		}

		// 次数卡入场扣次
		if ("003".equals(card_type)) {
			en = new EntityImpl(this);
			int remain_times = Utils.getMapIntegerValue(card, "remain_times");
			String f_user_card_gym = Utils.getMapStringValue(card, "gym");
			if (remain_times <= 0) {
				throw new Exception("所选卡片剩余次数不足，请充值后再试");
			}
			// String id = en.getStringValue("id");
			String id = Utils.getMapStringValue(card, "id");

			String ss = "update f_user_card_" + f_user_card_gym + " set remain_times=? ";
			if (remain_times == 1) {
				// 次数扣完了
				ss += ",state ='009'";
			}
			ss += " where id=?";
			en.executeUpdate(ss, new Object[] { remain_times - 1, id });

		}
		// 储值卡入场扣费
		long fee = 0;
		if ("002".equals(card_type) && "N".equals(conf)) {
			MemInfo m = MemUtils.getMemInfo(fk_user_id, cust_name);
			Long remain_amt = m.getRemainAmt();
			fee = remain_amt - Long.parseLong(checkin_fee) * 100;
			if (fee < 0) {
				throw new Exception("储值卡余额不足,暂无法入场,请先充值");
			}
			this.obj.put("fee", checkin_fee);
			this.obj.put("confirm", "Y");
		} else {
			conf = "Y";
			this.obj.put("confirm", "N");

		}
		if ("Y".equals(conf)) {
			if ("002".equals(card_type)) {
				en = new EntityImpl(this);
				sql = "select remain_amt  from f_mem_" + cust_name + " where id=?";
				en.executeQuery(sql, new Object[] { fk_user_id });
				Long remain_amt = en.getLongValue("remain_amt");
				fee = remain_amt - Long.parseLong(checkin_fee) * 100;
				MemInfo.updateRemainAmtByGym(fee, fk_user_id, gym, this.getConnection());
			}
			en = new EntityImpl("f_checkin", this);
			en.setTablename("f_checkin_" + gym);
			en.setValue("cust_name", cust_name);
			en.setValue("gym", gym);
			en.setValue("mem_id", fk_user_id);
			en.setValue("mem_gym", fk_user_gym);
			en.setValue("hand_no", hand_no);
			en.setValue("is_backHand", "N");
			en.setValue("checkin_time", new Date());
			en.setValue("state", "002");
			en.setValue("emp_id", user.getId());
			en.setValue("checkin_type", card_type);
			en.setValue("checkin_fee", checkin_fee != null ? checkin_fee : 0);
			en.setValue("checkin_user_card_id", checkin_user_card_id);
			en.setValue("checkin_card_name", card_name);
			en.create();
			// 是否打印小票
			String print = SysSet.getValues(cust_name, gym, "set_xiao_print", "set_print_key", this.getConnection());
			if (Utils.isNull(print) && "ok".equals(print)) {
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				JSONObject obj = new JSONObject();
				obj.put("op_time", sdf.format(new Date()));
				obj.put("flow_num", "");
				JSONArray goods = new JSONArray();
				if (!"".equals(checkin_fee) && checkin_fee != null) {
					JSONObject good = new JSONObject();
					good.put("name", "入场收费");
					good.put("price", checkin_fee);
					good.put("num", 1);
					goods.put(good);
				}
				obj.put("goods", goods);
				obj.put("hand_no", hand_no);
				obj.put("checkin_time", sdf.format(new Date()));
				obj.put("ca_amt", checkin_fee);
				obj.put("real_amt", Long.parseLong(checkin_fee) * 100);
				obj.put("cash_amt", 0);
				obj.put("wx_amt", 0);
				obj.put("card_amt", Long.parseLong(checkin_fee) * 100);
				obj.put("card_cash_amt", 0);
				obj.put("remain_amt", checkin_fee);
				obj.put("ali_amt", 0);
				mem = MemUtils.getMemInfo(fk_user_id, cust_name);
				obj.put("card_number", mem.getMem_no());
				obj.put("user_name", mem.getName());
				obj.put("phone", mem.getPhone());

				this.obj.put("obj", obj);
			}
		}

	}
}
