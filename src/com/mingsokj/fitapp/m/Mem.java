package com.mingsokj.fitapp.m;

import java.io.Serializable;
import java.sql.Connection;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.log.JhLog;
import com.jinhua.server.log.Logger;
import com.jinhua.server.tools.Utils;
import com.jinhua.server.wx.Wx;
import com.mingsokj.fitapp.m.card.UserUtils;
import com.mingsokj.fitapp.utils.GymUtils;

public class Mem implements Serializable {

	private static final long serialVersionUID = 1L;
	/**
	 * 基本信息
	 */
	private String id;
	private String name;
	private String nickname;
	private String wxHeadUrl;
	private String picUrl;
	private String sex;
	private String phone;
	private String mem_no;
	private String remark;
	private long remain_amt;
	private String wxOpenId;

	private String cust_name;
	private String gym;
	private String originalGym;
	private String state;

	private Cust cust;

	public long getRemain_amt() {
		return remain_amt;
	}

	public void setRemain_amt(long remain_amt) {
		this.remain_amt = remain_amt;
	}

	/**
	 * 购卡信息
	 */
	private UserUtils cards;
	/**
	 * 入场信息
	 */
	private Date checkinTime;
	private Date checkoutTime;
	private MemUserState userState;

	/**
	 * 手环或者租柜信息
	 */
	private String boxNo;
	private boolean rent;
	private String rentId;
	private Date startRentTime;
	private Date endRentTime;

	public Mem() {
	}

	public Mem(String wxOpenId, String cust_name, String gym, Connection conn) throws Exception {
		// 查询是否已经绑定为会员
		Entity en = new EntityImpl(conn);
		int size = en.executeQuery(
				"select a.*,b.headurl wx_head_url,b.sex wx_sex,b.nickname wx_nickname,a.state from f_mem_" + cust_name
						+ " a ,f_wx_cust_" + cust_name + " b where a.WX_OPEN_ID=b.WX_OPEN_ID and a.WX_OPEN_ID=?",
				new String[] { wxOpenId }, 1, 1);
		if (size > 0) {
			this.id = en.getStringValue("id");
			this.wxOpenId = en.getStringValue("wx_open_id");
			this.nickname = en.getStringValue("nickname");
			this.name = en.getStringValue("MEM_NAME");
			this.mem_no = en.getStringValue("mem_no");
			this.phone = en.getStringValue("phone");
			this.remark = en.getStringValue("remark");
			this.picUrl = en.getStringValue("pic1");
			this.nickname = en.getStringValue("wx_nickname");
			this.wxHeadUrl = en.getStringValue("wx_head_url");
			this.sex = en.getStringValue("wx_sex");
			this.state = en.getStringValue("state");
			// 用户门店信息查询
			this.cust = new Cust();
			this.cust.cust_name = cust_name;// 客户信息

			Set<String> viewGyms = new HashSet<>();
			size = en.executeQuery("select a.VIEW_GYM from f_emp_gym a where a.CUST_NAME=? and a.FK_EMP_ID=?",
					new String[] { cust_name, this.id });
			for (int i = 0; i < size; i++) {
				viewGyms.add(en.getStringValue("VIEW_GYM", i));
			}
			size = en.executeQuery("select a.gym,a.GYM_NAME,a.logo_Url from f_gym a where a.CUST_NAME=?",
					new String[] { cust_name });
			for (int i = 0; i < size; i++) {
				Gym g = new Gym();
				g.gym = en.getStringValue("gym", i);
				g.gymName = en.getStringValue("GYM_NAME", i);
				g.logoUrl = en.getStringValue("LOGO_URL", i);
				if (viewGyms.contains(g.gym)) {
					g.canView = true;
				}
				if (gym.equals(g.gym)) {
					g.curShow = true;
					g.belongTo = true;
				}
				this.cust.viewGyms.add(g);
			}
		} else {
			throw new Exception("wx_open_id【" + wxOpenId + "】,没有在【" + cust_name + "->" + gym + "】登记为会员");
		}
	}

	public Mem(String mem_id, String gym, Connection conn) throws Exception {
		this.id = mem_id;
		Entity en = new EntityImpl(conn);
		int size = en.executeQuery("select * from f_mem_" + cust_name + " a where a.id=?", new String[] { this.id });
		if (size > 0) {
			this.wxOpenId = en.getStringValue("wx_open_id");
			this.name = en.getStringValue("MEM_NAME");
			this.mem_no = en.getStringValue("mem_no");
			this.phone = en.getStringValue("phone");
			this.remark = en.getStringValue("remark");
			this.state = en.getStringValue("state");
			this.originalGym = en.getStringValue("original_gym");

			if (Utils.isNull(originalGym)) {
				this.originalGym = gym;
			}

			String cust_name = en.getStringValue("cust_name");

			// 用户门店信息查询
			this.cust = new Cust();
			this.cust.cust_name = cust_name;// 客户信息
			this.cust_name = cust_name;
			Set<String> viewGyms = new HashSet<>();
			size = en.executeQuery("select a.VIEW_GYM from f_emp_gym a where a.CUST_NAME=? and a.FK_EMP_ID=?",
					new String[] { cust_name, this.id });
			for (int i = 0; i < size; i++) {
				viewGyms.add(en.getStringValue("VIEW_GYM", i));
			}
			size = en.executeQuery("select a.gym,a.GYM_NAME,a.logo_Url from f_gym a where a.CUST_NAME=?",
					new String[] { cust_name });
			for (int i = 0; i < size; i++) {
				Gym g = new Gym();
				g.gym = en.getStringValue("gym", i);
				g.gymName = en.getStringValue("GYM_NAME", i);
				g.logoUrl = en.getStringValue("LOGO_URL", i);
				if (viewGyms.contains(g.gym)) {
					g.canView = true;
				}
				if (gym.equals(g.gym)) {
					g.curShow = true;
					g.belongTo = true;
				}
				this.cust.viewGyms.add(g);
			}
		}
	}

	public Mem(String id, String memName, String memNo, String phone, String state) {
		this.id = id;
		this.name = memName;
		this.mem_no = memNo;
		this.phone = phone;
		this.state = state;
	}

	/**
	 * 2.1 请假会员，销假时间是否到了如果到了自动销假<br/>
	 * 2.2 会员卡是否到期了，如果到期了自动修改状态为到期状态<br/>
	 * 2.3判断是否有预请假的时间到了，如果有自动修改状态为请假状态<br/>
	 * 2.4判断是否该自动出场了。
	 * 
	 * @param L
	 * @param conn
	 * @throws Exception
	 */
	public void checkTask(Gym gym, Connection conn, JhLog L) throws Exception {
		// 先判断简单的，自动出场处理
		List<Map<String, Object>> checkins = gym.getCheckinInfos().get(this.getId());
		if (checkins != null && checkins.size() > 0) {
			// 处理自动出场情况
			autoCheckOut(checkins, conn, L);
		} else {
			L.debug("会员没有入场信息不需要处理。。。");
		}
		List<Map<String, Object>> leaveList = gym.getLeaveInfos().get(this.getId());
		// 会员卡是否到期了，如果到期了自动修改状态为到期状态<br/>
		List<Map<String, Object>> cardsList = gym.getCardsInfos().get(this.getId());
		if (cardsList != null && cardsList.size() > 0) {
			cardsCheck(cardsList, leaveList, conn, L);
		} else {
			L.debug("会员没有会员卡不需要检查哈。。。");
		}
	}

	private void cardsCheck(List<Map<String, Object>> cardList, List<Map<String, Object>> leaveList, Connection conn,
			JhLog L) throws Exception {
		L.debug("检查会员【" + this.id + "-" + name + "-" + this.phone + "】是否有会员卡到期了，是否销假时间到了和预请假情况处理");
		/**
		 * <data type="user_state" note="会员状态" canedit="Y" ispublic="N"><br/>
		 * <item code="001" note="激活" sort="1" /><br/>
		 * <item code="002" note="未激活" sort="2" /><br/>
		 * <item code="003" note="会籍跟踪" sort="3" /><br/>
		 * <item code="004" note="公共池" sort="4" /><br/>
		 * <item code="005" note="请假中" sort="5" /><br/>
		 * <item code="006" note="挂失中" sort="6" /><br/>
		 * <item code="007" note="转卡" sort="7" /><br/>
		 * <item code="008" note="退卡" sort="8" /><br/>
		 * </data><br/>
		 * 
		 * 会员卡 状态 码表<br/>
		 * <item code="001" note="已激活" sort="1" /><br/>
		 * <item code="002" note="未激活" sort="2" /><br/>
		 * <item code="003" note="退费" sort="3" /><br/>
		 * <item code="004" note="请假" sort="4" /><br/>
		 * <item code="005" note="补卡" sort="5" /><br/>
		 * <item code="006" note="挂失" sort="6" /><br/>
		 * <item code="007" note="转卡" sort="7" /><br/>
		 * <item code="008" note="退卡" sort="8" /><br/>
		 * <item code="009" note="过期" sort="8" /><br/>
		 * 
		 * <data type="ACTIVE_TYPE" note="开卡类型" canedit="Y" ispublic="N"><br/>
		 * <item code="001" note="立即激活" sort="1" /><br/>
		 * <item code="002" note="首次刷卡" sort="2" /><br/>
		 * <item code="003" note="指定日期" sort="3" /><br/>
		 * </data><br/>
		 */
		Entity en = new EntityImpl(conn);
		for (int k = 0; k < cardList.size(); k++) {
			Map<String, Object> m = cardList.get(k);
			String id = Utils.getMapStringValue(m, "id");
			String mem_id = Utils.getMapStringValue(m, "mem_id");
			String gym = Utils.getMapStringValue(m, "gym");
			String active_type = Utils.getMapStringValue(m, "active_type");
			// Date active_time = Utils.getMapDateValue(m, "active_time");
			Date deadline = Utils.getMapDateValue(m, "deadline");
			String state = Utils.getMapStringValue(m, "state");
			// 只需要处理 已激活，未激活，请假
			if ("002".equals(state)) {
				// 未激活
				// 需要处理 【指定日期】和 【统一开卡】 类型
				if ("003".equals(active_type)) {
					// 指定日期
					String card_id = Utils.getMapStringValue(m, "card_id");
					int s = en.executeQuery("select a.DAYS from f_card a where a.id=?", new String[] { card_id });
					if (s > 0) {
						int days = 0;
						try {
							days = en.getIntegerValue("days");
						} catch (Exception e) {
						}
						// 更新会员卡状态和到期时间
						en.executeUpdate("update f_user_card_" + gym + " a set a.deadline=?,a.state=? where a.id=?",
								new Object[] { Utils.dateAddDay(new Date(), days), "001", id });
						// 更新会员状态
						MemInfo.updateStateByCustname("001", cust_name, conn, mem_id);
					} else {
						L.error("自动开卡失败，指定的卡id【" + card_id + "】在系统里面查询失败");
					}
				}
			} else if ("001".equals(state)) {
				// 已激活
				// 判断是否到期，
				if (deadline != null) {
					try {
						if (Utils.dateCompareToDate(new Date(), deadline) > 0) {
							// 过期了
							en.executeUpdate("update f_user_card_" + gym + " a set a.STATE=? where a.id=?",
									new Object[] { "009", id });
						}
					} catch (Exception e) {
						L.error(e);
					}
				}
				// 判断是否有指定请假日期
				/**
				 * <data type="LEAVE_STATE" note="会员请假状态" <br/>
				 * <item code="001" note="请假中" sort="1" /><br/>
				 * <item code="002" note="请假结束" sort="2" /><br/>
				 * <item code="003" note="未付款" sort="3" /><br/>
				 * <item code="004" note="超时未付款" sort="4" /><br/>
				 * </data><br/>
				 */
				if (leaveList != null && leaveList.size() > 0) {
					for (Map<String, Object> leave : leaveList) {
						String state1 = Utils.getMapStringValue(leave, "state");
						if ("001".equals(state1)) {
							// 只需要处理 请假中的状态
							Date start_time = Utils.getMapDateValue(leave, "start_time");
							// Date cancel_time = Utils.getMapDateValue(leave,
							// "cancel_time");
							if (start_time != null) {
								try {
									if (Utils.dateCompareToDate(new Date(), start_time) >= 0) {
										// 到了请假时间，自动请假
										MemInfo.updateStateByGym("005", gym, conn, mem_id);
										// 可用卡种全部改成请假状态 只处理 已激活 =>请假
										for (Map<String, Object> card : cardList) {
											String state2 = Utils.getMapStringValue(card, "state");
											if ("001".equals(state2)) {
												String cardId = Utils.getMapStringValue(card, "id");
												en.executeUpdate(
														"update f_user_card_" + gym + " a set a.STATE=? where a.id=?",
														new String[] { "004", cardId });
											}
										}
										break;
									}
								} catch (Exception e) {
									L.error(e);
								}
							}
						}
					}
				}
			} else if ("004".equals(state)) {
				// 请假
				if (leaveList != null && leaveList.size() > 0) {
					for (Map<String, Object> leave : leaveList) {
						String state1 = Utils.getMapStringValue(leave, "state");
						String leaveId = Utils.getMapStringValue(leave, "id");
						if ("001".equals(state1)) {
							// 只需要处理 请假中的状态
							Date end_time = Utils.getMapDateValue(leave, "end_time");
							// Date cancel_time = Utils.getMapDateValue(leave,
							// "cancel_time");
							if (end_time != null) {
								try {
									if (Utils.dateCompareToDate(new Date(), end_time) > 0) {
										// 到了请假结束时间，自动销假
										en.executeUpdate("update f_leave a set a.STATE=?,a.cancel_time=? where a.ID=?",
												new Object[] { "002", new Date(), leaveId });
										MemInfo.updateStateByGym("001", gym, conn, mem_id);
										// 可用卡种全部改成请假状态 只处理 请假 =>已激活
										for (Map<String, Object> card : cardList) {
											String state2 = Utils.getMapStringValue(card, "state");
											if ("004".equals(state2)) {
												String cardId = Utils.getMapStringValue(card, "id");
												en.executeUpdate(
														"update f_user_card_" + gym + " a set a.STATE=? where a.id=?",
														new String[] { "001", cardId });
											}
										}
										break;
									}
								} catch (Exception e) {
									L.error(e);
								}
							}
						}
					}
				}
			}
		}
	}

	private void autoCheckOut(List<Map<String, Object>> checkins, Connection conn, JhLog L) {
		L.debug("发现会员【" + this.id + "-" + name + "-" + this.phone + "】忘记出场了，现在进行自动出场处理");
		Entity en = new EntityImpl(conn);
		for (int k = 0; k < checkins.size(); k++) {
			Map<String, Object> m = checkins.get(k);
			String id = Utils.getMapStringValue(m, "id");
			String gym = Utils.getMapStringValue(m, "gym");
			String hand_no = Utils.getMapStringValue(m, "hand_no");

			String remark = "晚上系统自动出场";
			String updateState = "003";
			if (!Utils.isNull(hand_no)) {
				updateState = "003-2";
				remark = "晚上系统自动出场（未归还手牌号【" + hand_no + "】）";
			}

			try {
				en.executeUpdate(
						"update f_checkin_" + gym
								+ " a set a.is_backhand = ?, STATE=? ,a.checkout_time=? ,a.remark=? where a.id = ?",
						new Object[] { "Y", updateState, new Date(), remark, id });
			} catch (Exception e) {
				L.error(e);
			}
		}
	}

	public void create(Connection conn) throws Exception {
		Entity f_mem = new EntityImpl("f_mem", conn);
		f_mem.setTablename("f_mem_" + this.getGym());
		f_mem.setValue("id", id);
		f_mem.setValue("cust_name", this.getCust_name());
		f_mem.setValue("gym", this.getGym());
		f_mem.setValue("mem_name", name);
		f_mem.setValue("sex", this.getSex());
		f_mem.setValue("phone", phone);
		f_mem.setValue("wx_open_id", wxOpenId);
		f_mem.setValue("mc_id", id);
		f_mem.setValue("create_time", new Date());
		f_mem.setValue("state", "002");
		f_mem.save();
	}

	// 当前会员正在查看的门店信息
	public Gym getGym正在查看的门店信息() throws Exception {
		for (Gym g : this.cust.viewGyms) {
			if (g.curShow) {
				return g;
			}
		}
		throw new Exception("当前用户没有登陆？没有找到信息");
	}

	// 当前会员注册的门店信息
	public Gym getGym会员注册的门店信息() throws Exception {

		for (Gym g : this.cust.viewGyms) {
			if (g.belongTo) {
				return g;
			}
		}
		throw new Exception("当前用户没有登陆？没有找到信息");
	}

	public static void updateWx(Wx wx, String cust_name, Connection conn, JhLog L) throws Exception {
		Entity en = new EntityImpl(conn);
		int size = en.executeUpdate(
				"update f_wx_cust_" + cust_name + " a set a.headurl=?,a.sex=?,a.nickname=? where a.WX_OPEN_ID=?",
				new String[] { wx.getHeadUrl(), wx.getSex(), wx.getNickname(), wx.getOpenId() });
		if (size <= 0) {
			Logger.warn("可能系统微信数据被误删了， 现在自动不回来");
			Entity f_wx_cust = new EntityImpl("f_wx_cust", conn, L);
			f_wx_cust.setTablename("f_wx_cust_" + cust_name);
			f_wx_cust.setValue("wx_open_id", wx.getOpenId());
			f_wx_cust.setValue("cust_name", cust_name);
			f_wx_cust.setValue("gym", cust_name);
			f_wx_cust.setValue("headUrl", wx.getHeadUrl());
			f_wx_cust.setValue("sex", wx.getSex());
			f_wx_cust.setValue("nickname", wx.getNickname());
			f_wx_cust.create();
		}

	}

	public void setName(String name) {
		this.name = name;
	}

	public String getWxHeadUrl() {
		if (this.wxHeadUrl != null && this.wxHeadUrl.length() > 6) {
			return wxHeadUrl;
		} else {
			return "public/fit/images/cashier/default_head.png";
		}
	}

	public void setWxHeadUrl(String wxHeadUrl) {
		this.wxHeadUrl = wxHeadUrl;
	}

	public String getSex() {
		if ("male".equals(sex)) {
			return "男";
		}
		return "女";
	}

	public void setSex(String sex) {
		this.sex = sex;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getMem_no() {
		return mem_no;
	}

	public void setMem_no(String mem_no) {
		this.mem_no = mem_no;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public UserUtils getCards() {
		return cards;
	}

	public void setCards(UserUtils cards) {
		this.cards = cards;
	}

	public Date getCheckinTime() {
		return checkinTime;
	}

	public void setCheckinTime(Date checkinTime) {
		this.checkinTime = checkinTime;
	}

	public Date getCheckoutTime() {
		return checkoutTime;
	}

	public void setCheckoutTime(Date checkoutTime) {
		this.checkoutTime = checkoutTime;
	}

	public MemUserState getUserState() {
		return userState;
	}

	public void setUserState(MemUserState userState) {
		this.userState = userState;
	}

	public String getBoxNo() {
		return boxNo;
	}

	public void setBoxNo(String boxNo) {
		this.boxNo = boxNo;
	}

	public boolean isRent() {
		return rent;
	}

	public void setRent(boolean rent) {
		this.rent = rent;
	}

	public String getRentId() {
		return rentId;
	}

	public void setRentId(String rentId) {
		this.rentId = rentId;
	}

	public Date getStartRentTime() {
		return startRentTime;
	}

	public void setStartRentTime(Date startRentTime) {
		this.startRentTime = startRentTime;
	}

	public Date getEndRentTime() {
		return endRentTime;
	}

	public void setEndRentTime(Date endRentTime) {
		this.endRentTime = endRentTime;
	}

	public String getCust_name() throws Exception {
		if (this.cust_name == null) {
			this.cust_name = this.getCust().cust_name;
		}
		if (this.cust_name == null) {
			this.cust_name = this.getGym正在查看的门店信息().cust_name;
		}
		return cust_name;
	}

	public void setCust_name(String cust_name) {
		this.cust_name = cust_name;
	}

	public void setGym(String gym) {
		this.gym = gym;
	}

	public String getGym() throws Exception {
		if (this.gym == null) {
			this.gym = this.getGym正在查看的门店信息().gym;
		}
		return gym;
	}

	public String getGymName() throws Exception {
		return GymUtils.getGymName(this.gym);
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getWxOpenId() {
		return wxOpenId;
	}

	public void setWxOpenId(String wxOpenId) {
		this.wxOpenId = wxOpenId;
	}

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public String getPicUrl() {
		return picUrl;
	}

	public void setPicUrl(String picUrl) {
		this.picUrl = picUrl;
	}

	public Cust getCust() {
		return cust;
	}

	public void setCust(Cust cust) {
		this.cust = cust;
	}

	public String getState() {
		return state;
	}

	public String getOriginalGym() throws Exception {
		if (this.originalGym == null) {
			this.originalGym = this.getGym正在查看的门店信息().getOriginalGym();
		}
		return originalGym;
	}

	public void setOriginalGym(String originalGym) {
		this.originalGym = originalGym;
	}

}
