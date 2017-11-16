package com.mingsokj.fitapp.m;

import java.io.Serializable;
import java.sql.Connection;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.jinhua.server.c.Code;
import com.jinhua.server.c.Codes;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.IDB;
import com.jinhua.server.db.impl.DBM;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.log.JhLog;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.utils.GymUtils;
import com.mingsokj.fitapp.utils.MemUtils;

public class MemInfo implements Serializable {

	private static final long serialVersionUID = 1L;
	/**
	 * 基本信息
	 */
	private String pid;// 主卡id
	private String id;
	private String name;
	private String mem_name;
	private String nickname;
	private String wxHeadUrl;
	private String picUrl;
	private String sex;
	private String phone;
	private String addr;

	private String birthday;
	private String update_time;
	private String idCard;
	private String mem_no;
	private long card_deposit_amt = -1;
	private long remainAmt;
	private String mc_id;// 会稽ID
	private String pt_names;// 教练ID
	private String refer_mem_id;// 推荐人ID

	private String pic1;
	private String pic2;
	private String pic3;

	private String remark;
	private String wxOpenId;
	private String labels;
	private String summary;

	private String create_time;
	private String cust_name;
	private String gym;
	private String gymName;
	private String originalGym;
	private String state;
	private boolean emp;

	private String imp_level;// 重点会员等级

	private Cust cust;

	public MemInfo() {

	}

	public Map<String, Object> toTitleMap() {
		Map<String, Object> m = new HashMap<>();
		m.put("id", this.getId());
		m.put("name", this.getName());
		m.put("gym", this.getGym());
		try {
			m.put("gymName", this.getGymName());
		} catch (Exception e) {
			m.put("gymName", this.getGym());
		}
		m.put("sex", this.getSex());
		m.put("sexCode", this.getSexCode());
		m.put("picUrl", this.getPicUrl());
		m.put("headurl", this.getWxHeadUrl());
		m.put("phone", this.getPhone());
		m.put("mem_no", this.getMem_no());
		return m;
	}

	public static void main(String[] args) {
		IDB db = new DBM();
		JhLog L = new JhLog();
		Connection conn = null;
		try {
			conn = db.getConnection();
			conn.setAutoCommit(false);
			for (int i = 0; i < 2000000; i++) {
				try {
					Entity en = new EntityImpl("f_mem", conn);
					en.setTablename("f_mem_fit");
					en.setValue("phone", (1000000000 + i) + "");
					en.setValue("mem_name", (1000000000 + i) + "");
					en.setValue("cust_name", "fit");
					String t = (i % 100) + "";
					en.setValue("gym", "fit" + Utils.leftPadding(t, 3, "0"));
					en.setValue("sex", "male");
					en.setValue("mem_no", (1000000000 + i) + "");
					en.setValue("birthday", new Date());
					en.setValue("state", Utils.leftPadding(i % 4, 3, "0"));
					en.create();
					L.info(i);
				} catch (Exception e) {
					L.error(e);
				} finally {

				}
				if (i % 100 == 0) {
					conn.commit();
				}
			}

			conn.commit();
		} catch (Exception e1) {
			L.error(e1);
		} finally {
			db.freeConnection(conn);
		}
	}

	/**
	 * 更新员工或者会员信息
	 * 
	 * @throws Exception
	 */
	public static void updateRemainAmtByCustname(long remainAmt, String id, String cust_name, Connection conn) throws Exception {
		Entity mem = new EntityImpl(conn);
		mem.executeUpdate("update  f_mem_" + cust_name + " set remain_amt = ? where id = ?", new Object[] { remainAmt, id });
	}

	/**
	 * 更新员工或者会员信息
	 * 
	 * @throws Exception
	 */
	public static void updateRemainAmtByGym(long remainAmt, String id, String gym, Connection conn) throws Exception {
		Entity en = new EntityImpl(conn);
		int size = en.executeQuery("select b.cust_name from f_gym a,f_gym b where a.GYM=? and a.CUST_NAME=b.CUST_NAME", new String[] { gym });
		if (size > 0) {
			Entity mem = new EntityImpl(conn);
			String cust_name = en.getStringValue("cust_name");
			mem.executeUpdate("update  f_mem_" + cust_name + " set remain_amt = ? where id = ?", new Object[] { remainAmt, id });
		}
	}

	/**
	 * 更新员工或者会员信息
	 * 
	 * @throws Exception
	 */
	public static void updateRemainAmtWithBalanceAmtByCustname(long balanceAmt, Connection conn, String id, String cust_name) throws Exception {
		Entity mem = new EntityImpl(conn);
		mem.executeUpdate("update  f_mem_" + cust_name + " set remain_amt=remain_amt + ? where id = ?", new Object[] { balanceAmt, id });
	}

	/**
	 * 更新员工或者会员信息
	 * 
	 * @throws Exception
	 */
	public static void updateRemainAmtWithBalanceAmtByGym(long balanceAmt, String gym, Connection conn, String id) throws Exception {
		Entity en = new EntityImpl(conn);
		int size = en.executeQuery("select b.cust_name from f_gym a,f_gym b where a.GYM=? and a.CUST_NAME=b.CUST_NAME", new String[] { gym });
		if (size > 0) {
			Entity mem = new EntityImpl(conn);
			String cust_name = en.getStringValue("cust_name");
			mem.executeUpdate("update f_mem_" + cust_name + " set remain_amt=remain_amt + ? where id = ?", new Object[] { balanceAmt, id });
		}
	}

	/**
	 * 更新员工或者会员信息
	 * 
	 * @throws Exception
	 */
	public static void updateStateByCustname(String state, String cust_name, Connection conn, String id) throws Exception {
		JhLog L = new JhLog();
		Entity mem = new EntityImpl(conn, L);
		mem.executeUpdate("update f_mem_" + cust_name + " set state= ? where id = ?", new Object[] { state, id });
		MemUtils.getMemInfo(id, cust_name, L, true, conn);
	}

	/**
	 * 更新员工或者会员信息
	 * 
	 * @throws Exception
	 */
	public static void updateStateByGym(String state, String gym, Connection conn, String id) throws Exception {
		JhLog L = new JhLog();
		Entity en = new EntityImpl(conn, L);
		int size = en.executeQuery("select b.cust_name from f_gym a,f_gym b where a.GYM=? and a.CUST_NAME=b.CUST_NAME", new String[] { gym });
		if (size > 0) {
			Entity mem = new EntityImpl(conn, L);
			String cust_name = en.getStringValue("cust_name");
			mem.executeUpdate("update  f_mem_" + cust_name + " set state= ? where id = ?", new Object[] { state, id });
			MemUtils.getMemInfo(id, cust_name, L, true, conn);
		}
	}

	public String create(Connection conn) {
		// 1.判断f_mem表里面的数据
		String mem_id = null;
		try {
			Entity f_mem = new EntityImpl("f_mem", conn);
			f_mem.setTablename("f_mem_" + this.getCust_name());
			f_mem.setValue("id", this.getId());
			f_mem.setValue("pid", this.getPid());
			f_mem.setValue("BIRTHDAY", this.getBirthday());
			f_mem.setValue("gym", this.getGym());
			f_mem.setValue("cust_name", this.getCust_name());
			f_mem.setValue("ID_CARD", this.getIdCard());
			f_mem.setValue("mem_name", this.getMem_name());
			f_mem.setValue("sex", this.getSexCode());
			f_mem.setValue("pic1", this.getPicUrl());
			f_mem.setValue("phone", this.getPhone());
			f_mem.setValue("mem_no", this.getMem_no());
			if (this.getCard_deposit_amt() >= 0) {
				f_mem.setValue("card_deposit_amt", this.getCard_deposit_amt());
			}
			f_mem.setValue("state", this.getState());
			f_mem.setValue("addr", this.getAddr());
			f_mem.setValue("WX_OPEN_ID", this.getWxOpenId());
			f_mem.setValue("mc_id", this.getMc_id());
			f_mem.setValue("pt_names", this.pt_names);
			f_mem.setValue("remark", this.getRemark());
			f_mem.setValue("imp_level", this.getImp_level());
			f_mem.setValue("create_time", new Date());
			f_mem.setValue("refer_mem_id", this.getRefer_mem_id());
			mem_id = f_mem.create();
			if (this.isEmp()) {
				try {
					Entity emp = new EntityImpl("f_emp", conn);
					emp.setValue("id", this.getId());
					emp.setValue("cust_name", this.getCust_name());
					emp.setValue("labels", this.getLabels());
					emp.setValue("summary", this.getSummary());
					emp.setValue("pic1", this.getPic1());
					emp.setValue("pic2", this.getPic2());
					emp.setValue("pic3", this.getPic3());
					emp.save();
				} catch (Exception e) {
				}
			}
		} catch (Exception e) {
		}
		return mem_id;
	}

	/**
	 * 更新员工或者会员信息
	 * 
	 * @throws Exception
	 */
	public void update(Connection conn, boolean updateEmp) throws Exception {
		JhLog L = new JhLog();
		if (this.getId() != null && this.getId().length() == 24 && ((this.getGym() != null && this.getGym().length() > 0) || (this.getCust_name() != null && this.getCust_name().length() > 0))) {
			Entity en = new EntityImpl(conn, L);
			int size = 0;
			if (this.getCust_name() != null && this.getCust_name().length() > 0) {
			} else {
				size = en.executeQuery("select b.cust_name from f_gym a,f_gym b where a.GYM=? and a.CUST_NAME=b.CUST_NAME", new String[] { this.getGym() });
				if (size > 0) {
					this.cust_name = en.getStringValue("cust_name");
				}
			}
			try {
				// 1.判断f_mem表里面的数据
				Entity f_mem = new EntityImpl("f_mem", conn, L);
				f_mem.setTablename("f_mem_" + cust_name);
				f_mem.setValue("id", this.getId());
				f_mem.setValue("BIRTHDAY", this.getBirthday());
				f_mem.setValue("ID_CARD", this.getIdCard());
				f_mem.setValue("mem_name", this.getMem_name());
				f_mem.setValue("sex", this.getSexCode());
				f_mem.setValue("pic1", this.getPicUrl());
				f_mem.setValue("phone", this.getPhone());
				f_mem.setValue("state", this.getState());
				if ("=no=".equals(this.mem_no)) {
					f_mem.setNullValue("mem_no");
				} else {
					f_mem.setValue("mem_no", this.getMem_no());
				}
				if (this.getCard_deposit_amt() >= 0) {
					f_mem.setValue("card_deposit_amt", this.getCard_deposit_amt());
				}
				f_mem.setValue("addr", this.getAddr());
				f_mem.setValue("WX_OPEN_ID", this.getWxOpenId());
				if ("=no=".equals(this.mc_id)) {
					f_mem.setNullValue("mc_id");
				} else {
					f_mem.setValue("mc_id", this.getMc_id());
				}
				if ("=no=".equals(this.pt_names)) {
					f_mem.setNullValue("pt_names");
				} else {
					f_mem.setValue("pt_names", this.getPt_names());
				}
				f_mem.setValue("remark", this.getRemark());
				f_mem.setValue("imp_level", this.getImp_level());
				f_mem.update();
				if (this.isEmp() && updateEmp) {
					try {
						Entity emp = new EntityImpl("f_emp", conn);
						emp.setValue("id", this.getId());
						emp.setValue("labels", this.getLabels());
						emp.setValue("summary", this.getSummary());
						emp.setValue("pic1", this.getPic1());
						emp.setValue("pic2", this.getPic2());
						emp.setValue("pic3", this.getPic3());
						emp.update();
					} catch (Exception e) {
					}
				}
				if (this.getWxOpenId() != null && this.getWxOpenId().length() > 0) {
					if (this.getNickname() != null && this.getNickname().length() > 0) {
						Entity f_wx_cust = new EntityImpl(conn);
						f_wx_cust.executeUpdate("update f_wx_cust_" + this.getCust_name() + " a set a.nickname=? where a.wx_open_id=?", new String[] { this.getNickname(), this.getWxOpenId() });
					}
				}
				MemUtils.getMemInfo(id, cust_name, L, true, conn);
			} catch (Exception e) {
				throw e;
			}
		} else {
			throw new Exception("更新会员信息，没有设置会员Id，gym或者cust_name");
		}
	}

	public long remainAmt(Connection conn) throws Exception {
		long remainAmt = 0;
		try {
			Entity en = new EntityImpl(conn);
			int size = en.executeQueryWithMaxResult("select a.remain_amt from f_mem_" + this.getCust_name() + " a where a.id=?", new String[] { this.getId() }, 1, 1);
			if (size > 0) {
				remainAmt = en.getLongValue("remain_amt");
			}
			return remainAmt;
		} catch (Exception e) {
			throw e;
		}
	}

	public boolean search(String k) {
		if (this.getPhone().contains(k) || this.getMem_name().contains(k)  || this.getNickname().contains(k)) {
			return true;
		}
		return false;
	}

	public String getName() {
		if (!Utils.isNull(getNickname()) && !Utils.isNull(this.getMem_name()) && !this.mem_name.equals(this.getNickname())) {
			this.name = this.mem_name + "(" + this.getNickname() + ")";
		} else {
			if (!Utils.isNull(getNickname())) {
				this.name = this.getNickname();
			} else if (!Utils.isNull(getMem_name())) {
				this.name = this.getMem_name();
			} else {
				this.name = "=匿名=";
			}
		}
		return name;
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

	public String getAddr() {
		return addr;
	}

	public void setAddr(String addr) {
		this.addr = addr;
	}

	public String getSex() {
		if (sex != null && sex.length() > 0) {
			if ("male".equalsIgnoreCase(sex)) {
				return "男";
			}
			return "女";
		} else {
			return "";
		}
	}

	public String getSexCode() {
		return sex;
	}

	public String getBirthday() {
		return birthday;
	}

	public void setBirthday(String birthday) {
		this.birthday = birthday;
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

	public String getPt_names() {
		return pt_names;
	}

	public void setCust_name(String cust_name) {
		this.cust_name = cust_name;
	}

	public void setGym(String gym) {
		this.gym = gym;
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

	public String getState() {
		return state;
	}

	public String getCust_name() {
		return cust_name;
	}

	public String getGym() {
		return gym;
	}

	public String getOriginalGym() {
		return originalGym;
	}

	public void setState(String state) {
		this.state = state;
	}

	public void setOriginalGym(String originalGym) {
		this.originalGym = originalGym;
	}

	public String getMem_name() {
		return mem_name;
	}

	public void setMem_name(String mem_name) {
		this.mem_name = mem_name;
	}

	public String getLabels() {
		return labels;
	}

	public void setLabels(String labels) {
		this.labels = labels;
	}

	public String getSummary() {
		return summary;
	}

	public void setSummary(String summary) {
		this.summary = summary;
	}

	public long getCard_deposit_amt() {
		return card_deposit_amt;
	}

	public void setCard_deposit_amt(long card_deposit_amt) {
		this.card_deposit_amt = card_deposit_amt;
	}

	public boolean isEmp() {
		return emp;
	}

	public void setEmp(boolean emp) {
		this.emp = emp;
	}

	public String getPic1() {
		return pic1;
	}

	public void setPic1(String pic1) {
		this.pic1 = pic1;
	}

	public String getPic2() {
		return pic2;
	}

	public void setPic2(String pic2) {
		this.pic2 = pic2;
	}

	public String getPic3() {
		return pic3;
	}

	public void setPic3(String pic3) {
		this.pic3 = pic3;
	}

	public String getIdCard() {
		return idCard;
	}

	public void setIdCard(String idCard) {
		this.idCard = idCard;
	}

	public String getGymName() throws Exception {
		if (gymName == null || gymName.length() <= 0) {
			this.gymName = GymUtils.getGymName(this.gym);
		}
		return gymName;
	}

	public long getRemainAmt() throws Exception {
		IDB db = new DBM();
		Connection conn = null;
		try {
			conn = db.getConnection();
			conn.setAutoCommit(false);
			this.remainAmt = this.remainAmt(conn);
			conn.commit();
		} catch (Exception e) {
			throw e;
		} finally {
			db.freeConnection(conn);
		}
		return remainAmt;
	}

	public String getMc_id() {
		return mc_id;
	}

	public void setMc_id(String mc_id) {
		this.mc_id = mc_id;
	}

	public String getImp_level() {
		return imp_level;
	}

	public void setImp_level(String imp_level) {
		this.imp_level = imp_level;
	}

	public String getPid() {
		return pid;
	}

	public void setPid(String pid) {
		this.pid = pid;
	}

	public Cust getCust() {
		return cust;
	}

	public String getUpdate_time() {
		return update_time;
	}

	public void setUpdate_time(String update_time) {
		this.update_time = update_time;
	}

	public void setRemainAmt(long remainAmt) {
		this.remainAmt = remainAmt;
	}

	public void setCust(Cust cust) {
		this.cust = cust;
	}

	public Gym getViewGym(String viewGymCode) {
		for (Gym g : this.getCust().viewGyms) {
			if (g.gym.equals(viewGymCode)) {
				return g;
			}
		}
		return null;
	}

	public String getStateStr() throws Exception {
		Code code = Codes.code("user_state");
		return code.getNote(this.getState());
	}

	public List<Map<String, Object>> getCardList(String viewGym) throws Exception {
		List<Map<String, Object>> cardList = MemUtils.getMemCards(id, getCust_name(), viewGym);
		if (!Utils.isNull(this.pid)) {
			List<Map<String, Object>> cardList2 = MemUtils.getMemCards(this.pid, getCust_name(), viewGym);
			for (Map<String, Object> card : cardList2) {
				String is_fanmily = card.get("is_fanmily") + "";
				if ("Y".equals(is_fanmily)) {
					cardList.add(card);
				}
			}
		}
		return cardList;
	}

	public Map<String, Object> getCheckinfo(String viewGym) throws Exception {
		IDB db = new DBM();
		Connection conn = null;
		try {
			conn = db.getConnection();
			Entity en = new EntityImpl(conn);
			int size = en.executeQuery("select hand_no, is_backHand from f_checkin_" + viewGym + " where mem_id=? and state='002' group by checkin_time desc", new Object[] { id });
			if (size > 0) {
				return en.getValues().get(0);
			}
			return null;
		} catch (Exception e) {
			throw e;
		} finally {
			db.freeConnection(conn);
		}
	}

	public Map<String, Object> getRentBoxinfo(String viewGym) throws Exception {
		IDB db = new DBM();
		Connection conn = null;
		try {
			conn = db.getConnection();
			Entity en = new EntityImpl(conn);
			int size = en.executeQuery("select b.AREA_NO,b.BOX_NO from f_rent_" + viewGym + " a,f_box b WHERE a.BOX_ID=b.ID AND a.MEM_ID=? AND a.STATE='001'", new Object[] { id });
			if (size > 0) {
				return en.getValues().get(0);
			}
			return null;
		} catch (Exception e) {
			throw e;
		} finally {
			db.freeConnection(conn);
		}
	}

	public String getRemainAmtStr() throws Exception {
		return Utils.toPrice(this.getRemainAmt());
	}

	public String getMcName() throws Exception {
		if (!Utils.isNull(this.mc_id)) {
			MemInfo mem = MemUtils.getMemInfo(this.mc_id, this.cust_name);
			return mem.getName();
		}
		return "";
	}

	public String getPtName() throws Exception {
		if (!Utils.isNull(this.pt_names)) {
			MemInfo mem = MemUtils.getMemInfo(this.pt_names, this.cust_name);
			return mem.getName();
		}
		return "";
	}

	public String getRefer_mem_id() {
		return refer_mem_id;
	}

	public void setRefer_mem_id(String refer_mem_id) {
		this.refer_mem_id = refer_mem_id;
	}

	public void setPt_names(String pt_names) {
		this.pt_names = pt_names;
	}

	public String getCreate_time() {
		return create_time;
	}

	public void setCreate_time(String create_time) {
		this.create_time = create_time;
	}

}
