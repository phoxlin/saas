package com.mingsokj.fitapp.m;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import com.jinhua.User;
import com.jinhua.server.Action;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.IDB;
import com.jinhua.server.db.impl.DBM;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.tools.SystemUtils;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.utils.MemUtils;

/**
 * 员工用户类，只用来处理员工信息，和逻辑
 * 
 * @author terry
 *
 */
public class FitUser extends User {

	private static final long serialVersionUID = 1L;
	private String id;
	private String loginName;
	private boolean exPT;
	private boolean exMc;
	private boolean PT;
	private boolean MC;
	private boolean OP;
	private boolean SM;
	private Set<String> labels = new HashSet<>();
	private String summary;
	private String content;
	private String state;
	
	private List<String> PTs = new ArrayList<>();// 如果是经理，存储被管理者的id
	private List<String> MCs = new ArrayList<>();// 如果是经理，存储被管理者的id

	private List<String> levelGyms = new ArrayList<>();// 通本店的相关门店代码
	private List<String> cds = new ArrayList<>();// 权限
	private String cust_name;
	private String gym;
	private String viewGym;// 正在查看的门店代码

	public FitUser(String id, String cust_name, Connection conn) throws Exception {
		this.cust_name = cust_name;
		Entity en = new EntityImpl(conn);
		// 员工表没有wxOpenId，先用wxOpenId在会员表里面查询出基本信息
		int size = en.executeQuery("select a.* from f_emp a where  a.id=?  and a.cust_name=?", new String[] { id, cust_name }, 1, 1);
		if (size > 0) {
			this.getM().putAll(en.getValues().get(0));
			this.exMc = en.getBooleanValue("EX_MC");
			this.exPT = en.getBooleanValue("EX_PT");
			this.OP = en.getBooleanValue("OP");
			this.MC = en.getBooleanValue("MC");
			this.PT = en.getBooleanValue("PT");
			this.SM = en.getBooleanValue("SM");
			this.id = en.getStringValue("id");
			this.loginName = en.getStringValue("LOGIN_NAME");
			this.summary = en.getStringValue("SUMMARY");
			this.content = en.getStringValue("CONTENT");
			this.gym = en.getStringValue("gym");
			this.state = en.getStringValue("state");
			this.viewGym = this.gym;
			String LABELS = en.getStringValue("LABELS");
			if (LABELS != null && LABELS.length() > 0) {
				this.labels.addAll(Utils.split(LABELS, new String[] { ",", "，", ";", "；", " " }));
			}

			// 用户门店信息查询
			Set<String> viewGyms = new HashSet<>();
			size = en.executeQuery("select a.VIEW_GYM from f_emp_gym a where a.CUST_NAME=? and a.FK_EMP_ID=?", new String[] { cust_name, this.id });
			for (int i = 0; i < size; i++) {
				viewGyms.add(en.getStringValue("VIEW_GYM", i));
			}

			this.levelGyms.addAll(viewGyms);
			// 权限
			en = new EntityImpl(conn);
			size = en.executeQuery("select auth from f_emp_auth where cust_name = ? and gym = ? and emp_id = ?", new Object[] { cust_name, gym, id });
			if (size > 0) {
				for (int i = 0; i < size; i++) {
					this.getCds().add(en.getStringValue("auth", i));
				}
			}

		} else {
			throw new Exception("id【" + id + "】,没有登记为员工");
		}
	}

	public FitUser() {

	}

	@Override
	public void validite(String name, String pwd, Action act) throws Exception {
		Entity en = new EntityImpl(act);
		int size = en.executeQuery("select * from f_emp a where a.LOGIN_NAME=? and a.PWD=?", new String[] { name, pwd }, 1, 1);
		if (size > 0) {
			String gym = en.getStringValue("gym");
			this.cust_name = en.getStringValue("cust_name");
			this.getM().putAll(en.getValues().get(0));
			this.exMc = en.getBooleanValue("EX_MC");
			this.exPT = en.getBooleanValue("EX_PT");
			this.OP = en.getBooleanValue("OP");
			this.MC = en.getBooleanValue("MC");
			this.PT = en.getBooleanValue("PT");
			this.SM = en.getBooleanValue("SM");
			this.id = en.getStringValue("id");
			this.state = en.getStringValue("state");
			this.loginName = en.getStringValue("LOGIN_NAME");
			this.summary = en.getStringValue("SUMMARY");
			this.content = en.getStringValue("CONTENT");
			String LABELS = en.getStringValue("LABELS");
			if (LABELS != null && LABELS.length() > 0) {
				this.labels.addAll(Utils.split(LABELS, new String[] { ",", "，", ";", "；", " " }));
			}
			this.gym = en.getStringValue("gym");
			this.viewGym = this.gym;
			// 用户门店信息查询
			Set<String> viewGyms = new HashSet<>();
			size = en.executeQuery("select a.VIEW_GYM from f_emp_gym a where a.CUST_NAME=? and a.FK_EMP_ID=?", new String[] { cust_name, this.id });
			for (int i = 0; i < size; i++) {
				viewGyms.add(en.getStringValue("VIEW_GYM", i));
			}

			this.levelGyms.addAll(viewGyms);
			// 权限
			en = new EntityImpl(act);
			size = en.executeQuery("select auth from f_emp_auth where cust_name = ? and gym = ? and emp_id = ?", new Object[] { cust_name, gym, id });
			if (size > 0) {
				for (int i = 0; i < size; i++) {
					this.getCds().add(en.getStringValue("auth", i));
				}
			}

			SystemUtils.setSessionUser(this, act.request, act.response);
		} else {
			throw new Exception("用户名或者密码错误");
		}
	}

	/**
	 * // 如果是经理，存储被管理者的id
	 * 
	 * @return
	 */
	public List<String> getPTs() {
		return PTs;
	}

	/**
	 * // 如果是经理，存储被管理者的id
	 * 
	 * @return
	 */
	public List<String> getMCs() {
		return MCs;
	}

	public boolean is会稽经理() {
		return this.exMc;
	}

	public boolean is会稽() {
		return this.MC;
	}

	public boolean is教练经理() {
		return this.exPT;
	}

	public boolean is教练() {
		return this.PT;
	}

	public boolean is操作人员() {
		return this.OP;
	}

	public boolean is系统管理员() {
		return this.SM;
	}

	public String getId() {
		return id;
	}

	public String getLoginName() {
		return loginName;
	}

	public Set<String> getLabels() {
		return labels;
	}

	public String getSummary() {
		return summary;
	}

	public String getContent() {
		return content;
	}

	public void setId(String id) {
		this.id = id;
	}

	@Override
	public String getUser_id() {
		return this.getId();
	}

	@Override
	public void setUser_id(String user_id) {
		this.setId(user_id);
	}

	public List<String> getLevelGyms() throws Exception {
		return this.levelGyms;
	}

	public MemInfo getMemInfo() throws Exception {
		return MemUtils.getMemInfo(id, this.getCust_name());
	}

	public void setExPT(boolean exPT) {
		this.exPT = exPT;
	}

	public void setExMc(boolean exMc) {
		this.exMc = exMc;
	}

	public void setPT(boolean pT) {
		PT = pT;
	}

	public void setMC(boolean mC) {
		MC = mC;
	}

	public void setOP(boolean oP) {
		OP = oP;
	}

	public void setSM(boolean sM) {
		SM = sM;
	}

	public List<String> getCds() {
		return cds;
	}

	public boolean hasPower(String cd) {
		if (this.is系统管理员()) {
			if (cds.size() <= 0) {
				return true;
			}
		}
		return cds.contains(cd);
	}

	public String getCust_name() {
		return cust_name;
	}

	public void setCust_name(String cust_name) {
		this.cust_name = cust_name;
	}

	public String getGym() {
		return gym;
	}

	public void setGym(String gym) {
		this.gym = gym;
	}

	public String getViewGym() {
		return viewGym;
	}

	public void setViewGym(String viewGym) {
		this.viewGym = viewGym;
	}

	public void setCds(List<String> cds) {
		this.cds = cds;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public Cust getCust() throws Exception {
		IDB db = new DBM();
		Connection conn = null;
		Cust cust = new Cust();
		try {
			conn = db.getConnection();
			Entity en = new EntityImpl(conn);
			int size = en.executeQuery("select a.CUST_NAME,a.gym,a.GYM_NAME,a.PHONE,a.ADDR,a.AWORDS,a.TOTAL_SMS_NUM,a.REMAIN_SMS_NUM from f_gym a where a.cust_name=?", new String[] { cust_name });
			cust.cust_name = cust_name;
			if (size > 0) {
				for (int i = 0; i < size; i++) {
					Gym gym = new Gym();
					String g = en.getStringValue("gym", i);
					String gymName = en.getStringValue("gym_name", i);
					String phone = en.getStringValue("phone", i);
					String addr = en.getStringValue("addr", i);
					String awords = en.getStringValue("AWORDS", i);
					int total_sms_num = en.getIntegerValue("TOTAL_SMS_NUM", i);
					int remain_sms_num = en.getIntegerValue("REMAIN_SMS_NUM", i);
					gym.cust_name = cust_name;
					gym.gym = g;
					gym.gymName = gymName;
					gym.phone = phone;
					gym.addr = addr;
					gym.awords = awords;
					gym.totalSmsNum = total_sms_num;
					gym.remainSmsNum = remain_sms_num;
					cust.viewGyms.add(gym);
				}
			}
		} catch (Exception e) {
			throw e;
		} finally {
			db.freeConnection(conn);
		}
		return cust;
	}
}
