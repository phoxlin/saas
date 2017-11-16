package com.mingsokj.fitapp.flow;

import java.nio.ByteBuffer;
import java.security.SecureRandom;
import java.sql.Connection;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.concurrent.atomic.AtomicInteger;

import org.json.JSONObject;

import com.jinhua.server.BasicAction;
import com.jinhua.server.db.Entity;
import com.jinhua.server.log.Logger;
import com.jinhua.server.tools.Utils;

public abstract class Flow {
	private JSONObject formObj = null;
	private JSONObject payObj = null;

	public JSONObject getFormObj() {
		return formObj;
	}

	public void setFormObj(JSONObject formObj) {
		this.formObj = formObj;
	}

	private BasicAction act;
	private static final AtomicInteger NEXT_COUNTER = new AtomicInteger(new SecureRandom().nextInt());
	private static final int LOW_ORDER_THREE_BYTES = 0x00ffffff;
	private String flownum;// 流水号
	private static final char[] HEX_CHARS = new char[] { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };
	private Date op_time = new Date();
	private Date pay_time = null;
	private Connection conn;
	private String id;
	private String pid = "-1";
	private String cust_name;
	private String gym;
	private String empId;// 销售员ID
	private String empName;// 销售员姓名
	private FlowType type;// 流水类型
	private String gdName;// 商品名称
	private String actId = "-1";// 活动ID
	private String memId;// 会员ID
	private String userName;// 会员名称
	private String phone = "";// 会员电话
	private String cardNumber = "";// 会员卡号
	private String cardNumber1 = "";// 会员卡号1
	private String cardNumber2 = "";// 会员卡号2
	private String cardNumber3 = "";// 会员卡号3
	private JSONObject content = new JSONObject();// 消费详情
	private long caAmt;// 应收金额
	private long realAmt;// 实收金额
	private boolean isChange = false;// 手动修改金额
	private String chgRemark;// 修改原因
	private String chgOpId;// 修改人ID
	private long remainAmt;// 用户账户剩余金额
	private long giftAmt;// 消费赠金
	private long remainGiftAmt;// 剩余赠金
	private long cashAmt;// 现金
	private long wxAmt;// 微信
	private long aliAmt;// 支付宝
	private long cardAmt;// 单笔下卡金额
	private long cardCashAmt;// 刷卡金额
	private long giftCardAmt;// 代金券
	private String giftCardNo;// 卷号
	private String opId;// 操作人id
	private String opName;// 操作人名字
	private String dataTableName = null;// 业务表名
	private String dataId = "-1";// 业务数据id
	private String state;// 流水状态 001 已付款 002 未付款004分单
	private String T;
	private String carId;

	public Flow() {
		this(NEXT_COUNTER.getAndIncrement());
	}

	private Flow(int andIncrement) {
		String x = new SimpleDateFormat("HHmmss").format(op_time);
		Calendar op = Calendar.getInstance();
		op.setTime(op_time);
		int year = op.get(Calendar.YEAR) - 2010;
		int month = op.get(Calendar.MONTH) + 1;
		int day = op.get(Calendar.DAY_OF_MONTH);
		int counter = andIncrement & LOW_ORDER_THREE_BYTES;
		this.flownum = Utils.int2hex(year) + Utils.int2hex(month) + Utils.int2hex(day) + x + toHexString(counter);
		this.flownum = flownum.toUpperCase();
	}

	public void setPayEntityInfo(Entity en, String ca_amt) throws Exception {
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
			en.setValue("real_amt", real_amt);
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

	public String getFormDataVal(String name) {
		if (formObj == null) {
			String formData = this.getAct().request.getParameter("formData");
			try {
				formObj = new JSONObject(formData);
			} catch (Exception e) {
			}
		}
		return formObj.getString(name);
	}

	public String getPayDataVal(String name) {
		if (payObj == null) {
			String payObjStr = this.getAct().request.getParameter("payData");
			try {
				payObj = new JSONObject(payObjStr);
			} catch (Exception e) {
			}
		}
		return payObj.getString(name);
	}

	public long getPayDataLongPriceVal(String name) {
		if (payObj == null) {
			String payObjStr = this.getAct().request.getParameter("payData");
			try {
				payObj = new JSONObject(payObjStr);
			} catch (Exception e) {
			}
		}
		return Utils.toPriceLong(payObj.getString(name));
	}

	public String getTrimedFlownum() {
		StringBuilder sb = new StringBuilder();
		sb.append(this.flownum.substring(0, 3));
		sb.append("-");
		sb.append(this.flownum.substring(3, 9));
		sb.append("-");
		sb.append(this.flownum.substring(9));
		return sb.toString();
	}

	public abstract void beforeData() throws Exception;

	public abstract void saveData() throws Exception;

	public abstract String getSmsWords() throws Exception;

	public abstract String getSmsPhoneNumber() throws Exception;

	public void afterData() throws Exception {
		if (Utils.isNull(this.isPrintContract())) {
			this.act.obj.put("isPrintContract", "N");
		} else {
			this.act.obj.put("isPrintContract", "Y");
			this.act.obj.put("contractType", isPrintContract());
		}

		boolean sendSms = Utils.isTrue(act.request.getParameter("sendSms"));
		if (sendSms) {
			Logger.info("Sending msg" + getSmsWords() + " to phone:" + this.getSmsPhoneNumber());
		}
	}

	// 是否需要打印什么什么合同的名字，如果不需要打印就返回 null,如果需要打印就重写这个方法
	public String isPrintContract() {
		return null;
	}

	public String getT() {
		return T;
	}

	public void setT(String t) throws Exception {
		if ("web".equalsIgnoreCase(t)) {
		} else if ("android".equalsIgnoreCase(t)) {
		} else if ("ios".equalsIgnoreCase(t)) {
		} else if ("wx".equalsIgnoreCase(t)) {
		} else {
			throw new Exception("错误的终端名称，只能包括【web,android,ios,wx】");
		}

		T = t;
	}

	public String getFlownum() {
		return flownum;
	}

	public void setFlownum(String flownum) {
		this.flownum = flownum;
	}

	public Date getOp_time() {
		return op_time;
	}

	public void setOp_time(Date op_time) {
		this.op_time = op_time;
	}

	public Connection getConn() {
		return conn;
	}

	public void setConn(Connection conn) {
		this.conn = conn;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getPid() {
		return pid;
	}

	public void setPid(String pid) {
		this.pid = pid;
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

	public String getEmpId() {
		return empId;
	}

	public void setEmpId(String empId) {
		this.empId = empId;
	}

	public String getCardNumber1() {
		return cardNumber1;
	}

	public void setCardNumber1(String cardNumber1) {
		this.cardNumber1 = cardNumber1;
	}

	public String getCardNumber2() {
		return cardNumber2;
	}

	public void setCardNumber2(String cardNumber2) {
		this.cardNumber2 = cardNumber2;
	}

	public String getCardNumber3() {
		return cardNumber3;
	}

	public void setCardNumber3(String cardNumber3) {
		this.cardNumber3 = cardNumber3;
	}

	public String getDataTableName() {
		return dataTableName;
	}

	public void setDataTableName(String dataTableName) {
		this.dataTableName = dataTableName;
	}

	public String getEmpName() {
		return empName;
	}

	public void setPay_time(Date pay_time) {
		this.pay_time = pay_time;
	}

	public Date getPay_time() {
		return pay_time;
	}

	public void setEmpName(String empName) {
		this.empName = empName;
	}

	public FlowType getType() {
		return type;
	}

	public void setType(FlowType type) {
		this.type = type;
	}

	public String getActId() {
		return actId;
	}

	public void setActId(String actId) {
		this.actId = actId;
	}

	public String getMemId() {
		return memId;
	}

	public void setMemId(String memId) {
		this.memId = memId;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getCardNumber() {
		return cardNumber;
	}

	public void setCardNumber(String cardNumber) {
		this.cardNumber = cardNumber;
	}

	public JSONObject getContent() {
		return content;
	}

	public void setContent(JSONObject content) {
		this.content = content;
	}

	public long getCaAmt() {
		return caAmt;
	}

	public void setCaAmt(long caAmt) {
		this.caAmt = caAmt;
	}

	public long getRealAmt() {
		return realAmt;
	}

	public void setRealAmt(long realAmt) {
		this.realAmt = realAmt;
	}

	public boolean isChange() {
		return isChange;
	}

	public void setChange(boolean isChange) {
		this.isChange = isChange;
	}

	public String getChgRemark() {
		return chgRemark;
	}

	public void setChgRemark(String chgRemark) {
		this.chgRemark = chgRemark;
	}

	public String getChgOpId() {
		return chgOpId;
	}

	public void setChgOpId(String chgOpId) {
		this.chgOpId = chgOpId;
	}

	public long getRemainAmt() {
		return remainAmt;
	}

	public void setRemainAmt(long remainAmt) {
		this.remainAmt = remainAmt;
	}

	public long getGiftAmt() {
		return giftAmt;
	}

	public void setGiftAmt(long giftAmt) {
		this.giftAmt = giftAmt;
	}

	public long getRemainGiftAmt() {
		return remainGiftAmt;
	}

	public void setRemainGiftAmt(long remainGiftAmt) {
		this.remainGiftAmt = remainGiftAmt;
	}

	public long getCashAmt() {
		return cashAmt;
	}

	public void setCashAmt(long cashAmt) {
		this.cashAmt = cashAmt;
	}

	public long getWxAmt() {
		return wxAmt;
	}

	public void setWxAmt(long wxAmt) {
		this.wxAmt = wxAmt;
	}

	public long getAliAmt() {
		return aliAmt;
	}

	public void setAliAmt(long aliAmt) {
		this.aliAmt = aliAmt;
	}

	public long getCardAmt() {
		return cardAmt;
	}

	public void setCardAmt(long cardAmt) {
		this.cardAmt = cardAmt;
	}

	public long getGiftCardAmt() {
		return giftCardAmt;
	}

	public void setGiftCardAmt(long giftCardAmt) {
		this.giftCardAmt = giftCardAmt;
	}

	public String getGiftCardNo() {
		return giftCardNo;
	}

	public void setGiftCardNo(String giftCardNo) {
		this.giftCardNo = giftCardNo;
	}

	public String getOpId() {
		return opId;
	}

	public void setOpId(String opId) {
		this.opId = opId;
	}

	public String getOpName() {
		return opName;
	}

	public void setOpName(String opName) {
		this.opName = opName;
	}

	public String getDataId() {
		return dataId;
	}

	public void setDataId(String dataId) {
		this.dataId = dataId;
	}

	public void setCaAmt(String price) {
		try {
			Float f = Float.parseFloat(price) * 100;
			this.setCaAmt(f.longValue());
		} catch (Exception e) {
		}
	}

	public String getGdName() {
		return gdName;
	}

	public void setGdName(String gdName) {
		this.gdName = gdName;
	}

	public long getCardCashAmt() {
		return cardCashAmt;
	}

	public void setCardCashAmt(long cardCashAmt) {
		this.cardCashAmt = cardCashAmt;
	}

	public String getCarId() {
		return carId;
	}

	public void setCarId(String carId) {
		this.carId = carId;
	}

	private static byte int0(final int x) {
		return (byte) (x);
	}

	private static byte int1(final int x) {
		return (byte) (x >> 8);
	}

	private void putToByteBuffer(ByteBuffer buffer, int counter) {
		buffer.put(int1(counter));
		buffer.put(int0(counter));
	}

	private byte[] toByteArray(int counter) {
		ByteBuffer buffer = ByteBuffer.allocate(2);
		putToByteBuffer(buffer, counter);
		return buffer.array();
	}

	private String toHexString(int counter) {
		char[] chars = new char[4];
		int i = 0;
		for (byte b : toByteArray(counter)) {
			chars[i++] = HEX_CHARS[b >> 4 & 0xF];
			chars[i++] = HEX_CHARS[b & 0xF];
		}
		return new String(chars);
	}

	public void setAct(BasicAction act) throws Exception {
		this.act = act;
		this.conn = act.getConnection();
	}

	public BasicAction getAct() {
		return act;
	}

}
