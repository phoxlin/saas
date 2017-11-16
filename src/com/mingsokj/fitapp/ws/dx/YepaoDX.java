package com.mingsokj.fitapp.ws.dx;

import java.sql.Connection;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.log.JhLog;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.ws.bg.set.FGym;

public class YepaoDX {
	private String cust_name;
	private Connection conn;
	private Connection yepaoConn;

	private Map<String, Boolean> custTables = new HashMap<>();
	private Map<String, Boolean> gymTables = new HashMap<>();

	private Set<String> gymList = new HashSet<>();// 除开总店的其他分店的集合
	private Map<String, Map<String, Object>> gymInfos = new HashMap<>();// 门店的基本信息
	private Map<String, String> gymNames = new HashMap<>();

	private Map<String, String> cards = new HashMap<>();
	private JhLog L;
	private Set<String> donePhones = new HashSet<>();

	// 从也跑系统导出健身房所有基本信息
	public YepaoDX(String cust_name, Connection conn, Connection yepaoConn, JhLog L) throws Exception {
		this.cust_name = cust_name;
		this.conn = conn;
		this.yepaoConn = yepaoConn;
		this.L = L;
		Entity en = new EntityImpl(yepaoConn);
		int size = en.executeQuery("select * from yp_gym a where a.cust_name=?", new String[] { cust_name });
		if (size > 0) {
			for (int i = 0; i < size; i++) {
				String gym = en.getStringValue("gym", i);
				String gym_name = en.getStringValue("gym_name", i);
				gymNames.put(gym, gym_name);
				if (!gym.equals(cust_name)) {
					gymList.add(gym);
				}
				gymInfos.put(gym, en.getValues().get(i));
			}
		} else {
			throw new Exception("cust_name【" + cust_name + "】在也跑系统里面没有找到");
		}
	}

	private void do员工信息() throws Exception {
		Entity en1 = new EntityImpl(yepaoConn);
		Entity yepao = new EntityImpl(yepaoConn);
		int size = en1.executeQuery("select * from yp_emp a where a.CUST_NAME=?", new String[] { cust_name });
		// 直接复制也跑员工信息，员工数量少不用分页
		for (int j = 0; j < size; j++) {
			Map<String, Object> m = en1.getValues().get(j);
			String empId = Utils.getMapStringValue(m, "id");
			// 新系统员工信息要有一个对应的会员信息
			String phone = Utils.getMapStringValue(m, "phone");
			String gym = Utils.getMapStringValue(m, "gym");
			Entity f_mem = new EntityImpl("f_mem", conn);
			f_mem.setTablename("f_mem_" + cust_name);
			// f_mem.setValue("pid", "");
			f_mem.setValue("id", empId);
			f_mem.setValue("cust_name", cust_name);
			f_mem.setValue("gym", gym);
			f_mem.setValue("mem_name", Utils.getMapStringValue(m, "emp_name"));
			f_mem.setValue("phone", phone);
			// f_mem.setValue("is_emp", "");
			f_mem.setValue("sex", Utils.getMapStringValue(m, "sex"));
			// f_mem.setValue("mem_no", Utils.getMapStringValue(m, "emp_no"));
			f_mem.setValue("card_deposit_amt", 0);
			f_mem.setValue("birthday", Utils.getMapDateValue(m, "birthday"));
			// f_mem.setValue("id_card", "");身份证号
			// f_mem.setValue("addr", "");
			// f_mem.setValue("pic1", "");
			// f_mem.setValue("pic1_time", new Date());
			// f_mem.setValue("app_head", "");
			// f_mem.setValue("app_open_id", "");
			f_mem.setValue("wx_open_id", "");
			f_mem.setValue("mc_id", Utils.getMapStringValue(m, "id"));
			// f_mem.setValue("pt_names", "");
			// f_mem.setValue("user_type", "");
			long u_amt = 0;
			f_mem.setValue("total_amt", u_amt);
			f_mem.setValue("remain_amt", u_amt);
			long cent = 0;
			f_mem.setValue("total_cent", cent);
			f_mem.setValue("remain_cent", cent);
			f_mem.setValue("remark", Utils.getMapStringValue(m, "remark") + "，也跑系统导入的员工信息");
			f_mem.setValue("create_time", new Date());
			// f_mem.setValue("update_time", "");
			// f_mem.setValue("finger1", "");
			// f_mem.setValue("finger2", "");

			// f_mem.setValue("rent_rec_id", "");
			// f_mem.setValue("is_rent", "N");
			// f_mem.setValue("rent_no", "");
			// f_mem.setValue("is_give_card", "");
			f_mem.setValue("state", "001");
			// f_mem.setValue("ic_pwd", "");
			f_mem.setValue("amt_checkin_fee", 0);
			// f_mem.setValue("refer_mem_id", "");
			// f_mem.setValue("refer_mem_gym", "");
			// f_mem.setValue("imp_level", "");
			// f_mem.setValue("checkin_level", "");
			// f_mem.setValue("checkin_times", "");
			// f_mem.setValue("have_car", "");
			// f_mem.setValue("wants", "");
			// f_mem.setValue("fit_purpose", "");
			String id = null;
			Entity entity = new EntityImpl(conn);
			if (donePhones.contains(phone)) {
				continue;
			}
			donePhones.add(phone);
			int checksize = entity.executeQuery("select a.id from f_mem_" + cust_name + " a where a.phone=?", new String[] { phone });
			if (checksize > 0) {
				id = entity.getStringValue("id");
			} else {
				id = f_mem.create();
			}

			// 查询员工权限
			int s = yepao.executeQuery("select b.MC,b.PT,b.EX,b.OP from yp_emp_role a,sys_role b where a.ROLE=b.CODE and a.EMP_ID=?", new String[] { empId });
			String mc = "N";
			String pt = "N";
			String ex_pt = "N";
			String ex_mc = "N";
			String op = "N";
			if (s > 0) {
				mc = yepao.getBooleanValue("mc") ? "Y" : "N";
				pt = yepao.getBooleanValue("pt") ? "Y" : "N";
				ex_pt = yepao.getBooleanValue("ex") ? "Y" : "N";
				ex_pt = yepao.getBooleanValue("ex") ? "Y" : "N";
				op = yepao.getBooleanValue("op") ? "Y" : "N";
			}
			// 添加员工信息
			Entity f_emp = new EntityImpl("f_emp", conn);
			f_emp.setValue("id", id);
			f_emp.setValue("cust_name", cust_name);
			f_emp.setValue("gym", gym);
			f_emp.setValue("state", "002");
			f_emp.setValue("mc", mc);
			f_emp.setValue("pt", pt);
			f_emp.setValue("ex_pt", ex_pt);
			f_emp.setValue("ex_mc", ex_mc);
			f_emp.setValue("op", op);
			f_emp.setValue("summary", "也跑系统导入员工");
			f_emp.setValue("pic1", Utils.getMapStringValue(m, "pic2"));
			f_emp.create();
			// 添加员工可见门店信息
			s = yepao.executeQuery("select a.GYM from yp_emp_gym a where a.EMP_ID=?", new String[] { id });
			for (int i = 0; i < s; i++) {
				Entity f_emp_gym = new EntityImpl("f_emp_gym", conn);
				f_emp_gym.setValue("cust_name", cust_name);
				f_emp_gym.setValue("gym", yepao.getStringValue("gym", i));
				f_emp_gym.setValue("fk_emp_id", id);
				f_emp_gym.setValue("VIEW_GYM", yepao.getStringValue("gym", i));
				f_emp_gym.create();
			}
		}

	}

	private void do门店信息() throws Exception {
		// 先添加总店信息
		create门店信息(cust_name);
		create门店相关表(cust_name);
		// 添加总店管理员账号
		Map<String, Object> data = gymInfos.get(cust_name);
		String login_name = Utils.getMapStringValue(data, "admin_login");
		String admin_pwd = Utils.getMapStringValue(data, "admin_pwd");
		Entity en = new EntityImpl("f_emp", conn);
		int s = en.executeQuery("select id from f_emp where login_name = ?", new Object[] { login_name }, 1, 1);

		en.setValue("cust_name", cust_name);
		en.setValue("gym", cust_name);
		en.setValue("login_name", login_name);
		en.setValue("pwd", admin_pwd);
		en.setValue("state", "sm");
		en.setValue("sm", "Y");
		String empId = null;
		if (s > 0) {
			L.warn("导入也跑门店信息发现客户管理员账号【" + login_name + "】已存在.");
			empId = en.getStringValue("id");
		} else {
			empId = en.create();
		}
		// 可见会所
		Entity f_emp_gym = new EntityImpl("f_emp_gym", conn);
		f_emp_gym.setValue("cust_name", cust_name);
		f_emp_gym.setValue("gym", cust_name);
		f_emp_gym.setValue("view_gym", cust_name);
		f_emp_gym.setValue("fk_emp_id", empId);
		f_emp_gym.create();

		// 添加分店信息
		for (String g : gymList) {
			create门店信息(g);
			create门店相关表(g);
		}
	}

	private void create门店信息(String gym) throws Exception {
		Map<String, Object> data = gymInfos.get(gym);
		Entity f_gym = new EntityImpl("f_gym", conn);
		f_gym.setValue("cust_name", cust_name);
		f_gym.setValue("gym", gym);
		f_gym.setValue("gym_name", Utils.getMapStringValue(gymNames, gym));
		f_gym.setValue("addr", Utils.getMapStringValue(data, "addr"));
		f_gym.setValue("phone", Utils.getMapStringValue(data, "link_phone"));
		f_gym.setValue("total_sms_num", 2000);
		f_gym.setValue("remain_sms_num", 2000);
		f_gym.setValue("create_time", new Date());
		f_gym.setValue("renew_time", new Date());
		f_gym.create();
	}

	private void create门店相关表(String gym) throws Exception {
		if (gym.equals(cust_name)) {
			for (int i = 0; i < FGym.cust_tablenames.length; i++) {
				String ct = FGym.cust_tablenames[i];
				Boolean ok = custTables.get(ct + "_" + gym);
				if (ok == null || !ok) {
					try {
						Entity en1 = new EntityImpl(conn);
						en1.executeQuery("select count(1) num from " + ct + "_" + gym);
						custTables.put(ct + "_" + gym, true);
					} catch (Exception e1) {
						// 报错说明没有表，马上建
						Entity en1 = new EntityImpl(ct, conn);
						en1.setTablename(ct + "_" + gym);
						en1.DDL(false);
						custTables.put(ct + "_" + gym, true);
					}
				}
			}
		}
		for (int i = 0; i < FGym.gym_tablenames.length; i++) {
			String ct = FGym.gym_tablenames[i];
			Boolean ok = gymTables.get(ct + "_" + gym);
			if (ok == null || !ok) {
				try {
					Entity en1 = new EntityImpl(conn);
					en1.executeQuery("select count(1) num from " + ct + "_" + gym);
					gymTables.put(ct + "_" + gym, true);
				} catch (Exception e1) {
					// 报错说明没有表，马上建
					Entity en1 = new EntityImpl(ct, conn);
					en1.setTablename(ct + "_" + gym);
					en1.DDL(false);
					gymTables.put(ct + "_" + gym, true);
				}
			}
		}
	}

	// 1.门店信息，2.员工信息，3，卡种信息 4.会员信息。5.会员卡信息
	public void process() throws Exception {
		do门店信息();
		do员工信息();
		do卡种信息();
		do会员信息();
	}

	private void do会员信息() throws Exception {
		Entity yepao = new EntityImpl(yepaoConn);
		Entity yepaoCard = new EntityImpl(yepaoConn);
		int size = yepao.executeQuery("select count(*) num from yp_mem_" + cust_name);
		if (size > 0) {
			int num = yepao.getIntegerValue("num");
			int pageSize = 500;
			// 分页没500个会员进行一组处理
			int totalPage = (num % pageSize == 0) ? num / pageSize : num / pageSize + 1;
			int curPage = 1;
			for (; curPage <= totalPage; curPage++) {
				int s1 = yepao.executeQuery("select * from yp_mem_" + cust_name, new Object[] {}, (curPage - 1) * pageSize + 1, curPage * pageSize);
				if (s1 > 0) {
					L.info("也跑系统，会所" + cust_name + "开始第" + curPage + "次加载,会员数量:" + s1);
					for (int i = 0; i < s1; i++) {
						String gym = yepao.getStringValue("gym", i);
						String phone = yepao.getStringValue("phone", i);
						Entity f_mem = new EntityImpl("f_mem", conn);
						f_mem.setTablename("f_mem_" + cust_name);
						// f_mem.setValue("pid", "");
						f_mem.setValue("id", yepao.getStringValue("id", i));
						f_mem.setValue("cust_name", cust_name);
						f_mem.setValue("gym", gym);
						f_mem.setValue("mem_name", yepao.getStringValue("user_name", i));
						f_mem.setValue("phone", phone);
						// f_mem.setValue("is_emp", "");
						f_mem.setValue("sex", yepao.getStringValue("sex", i));
						f_mem.setValue("mem_no", yepao.getStringValue("mem_no", i));
						f_mem.setValue("card_deposit_amt", 0);
						f_mem.setValue("birthday", yepao.getDateValue("birthday", i));
						f_mem.setValue("id_card", yepao.getStringValue("id_num", i));// 身份证号
						f_mem.setValue("addr", yepao.getStringValue("room_addr", i));
						f_mem.setValue("pic1", yepao.getStringValue("pic2", i));
						f_mem.setValue("pic1_time", new Date());
						// f_mem.setValue("app_head", "");
						f_mem.setValue("app_open_id", "");
						f_mem.setValue("wx_open_id", "");
						f_mem.setValue("mc_id", yepao.getStringValue("sales_id", i));
						// f_mem.setValue("pt_names", "");
						// f_mem.setValue("user_type", "");
						f_mem.setValue("total_amt", yepao.getLongValue("amt", i));
						f_mem.setValue("remain_amt", yepao.getLongValue("amt", i));
						long cent = 0;
						f_mem.setValue("total_cent", cent);
						f_mem.setValue("remain_cent", cent);
						f_mem.setValue("remark", yepao.getStringValue("remark", i) + "，也跑系统导入数据");
						f_mem.setValue("create_time", new Date());
						// f_mem.setValue("update_time", "");
						// f_mem.setValue("finger1", "");
						// f_mem.setValue("finger2", "");

						// f_mem.setValue("rent_rec_id", "");
						// f_mem.setValue("is_rent", "N");
						// f_mem.setValue("rent_no", "");
						// f_mem.setValue("is_give_card", "");
						f_mem.setValue("state", yepao.getStringValue("state", i));
						// f_mem.setValue("ic_pwd", "");
						f_mem.setValue("amt_checkin_fee", 0);
						// f_mem.setValue("refer_mem_id", "");
						// f_mem.setValue("refer_mem_gym", "");
						// f_mem.setValue("imp_level", "");
						// f_mem.setValue("checkin_level", "");
						// f_mem.setValue("checkin_times", "");
						// f_mem.setValue("have_car", "");
						// f_mem.setValue("wants", "");
						// f_mem.setValue("fit_purpose", "");
						String id = null;
						Entity entity1 = new EntityImpl(conn);
						int checksize = entity1.executeQuery("select a.id from f_mem_" + cust_name + " a where a.phone=?", new String[] { phone });
						if (checksize > 0) {
							id = entity1.getStringValue("id");
						} else {
							id = f_mem.create();
						}

						// 会员卡信息
						int s = yepaoCard.executeQuery("SELECT\n" + "	a.gym,a.sales_id,\n" + "	a.type_code,\n" + "	a.mem_id,\n" + "	a.buy_time,\n" + "	a.act_time,\n" + "	a.times,\n" + "	a.deadline,\n" + "	a.is_give,\n" + "	a.card_number,\n" + "	a.state,\n" + "	b.active_type,\n" + "	b.active_time,\n" + "	b.price,\n" + "	b.real_price\n" + "FROM\n" + "	yp_type_user_" + cust_name + " a,\n" + "	yp_buy_card_record_" + cust_name + " b\n" + "WHERE\n" + "	a.type_code = b.type_code\n" + "AND a.mem_id = b.mem_id and a.mem_id=?", new String[] { id });
						if (s > 0) {
							for (int j = 0; j < s; j++) {
								try {
									Entity entity = new EntityImpl("f_user_card", conn);
									entity.setTablename("f_user_card_" + gym);
									entity.setValue("cust_name", cust_name);
									entity.setValue("gym", gym);
									String card_id = Utils.getMapStringValue(cards, yepaoCard.getStringValue("type_code", j));
									if (card_id == null || card_id.length() <= 0) {
										continue;
									}
									entity.setValue("card_id", card_id);
									entity.setValue("mem_id", id);
									entity.setValue("emp_id", yepaoCard.getStringValue("sales_id", j));
									entity.setValue("emp_name", "");
									entity.setValue("source", "YepaoImport");

									entity.setValue("buy_time", yepaoCard.getDateValue("buy_time", j));
									entity.setValue("create_time", new Date());
									entity.setValue("active_type", "001");
									entity.setValue("active_time", yepaoCard.getDateValue("act_time", j));

									entity.setValue("deadline", yepaoCard.getDateValue("deadline", j));
									// entity.setValue("contract_no", "");
									entity.setValue("remark", "excel导入");
									entity.setValue("state", "001");
									entity.setValue("buy_for_app", "N");
									entity.setValue("op_id", "sys");
									entity.setValue("buy_times", yepaoCard.getIntegerValue("times", j));
									entity.setValue("remain_times", yepaoCard.getIntegerValue("times", j));
									entity.setValue("give_card", "N");
									// entity.setValue("pt_id", "");
									entity.setValue("mc_id", yepaoCard.getStringValue("sales_id", j));
									entity.setValue("examine_emp_id", "");

									entity.setValue("give_days", "0");
									entity.setValue("give_card_id", "");
									entity.setValue("give_times", "0");
									entity.setValue("give_amt", "0");
									// entity.setValue("leave_times", "");
									entity.setValue("real_amt", yepaoCard.getLongValue("real_price", j));
									entity.setValue("real_amt2", "0");
									entity.setValue("ca_amt", "0");
									entity.setValue("cash_amt", "0");
									entity.setValue("card_cash_amt", "0");
									entity.setValue("card_amt", "0");
									entity.setValue("vouchers_amt", "0");
									entity.setValue("vouchers_num", "0");
									entity.setValue("wx_amt", "0");
									entity.setValue("ali_amt", "0");
									entity.setValue("is_free", "N");
									entity.setValue("staff_account", "N");
									entity.setValue("print", "N");
									entity.setValue("send_msg", "N");
									// entity.setValue("pay_way", "cash_amt");
									// entity.setValue("pay_time", new Date());
									// entity.setValue("out_trade_no", "");
									// entity.setValue("indent_no", "");
									entity.create();
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

	private void do卡种信息() throws Exception {
		Entity yepao = new EntityImpl(yepaoConn);
		int size = yepao.executeQuery("select * from yp_type a where a.CUST_NAME=?", new String[] { cust_name });
		for (int i = 0; i < size; i++) {
			String type_code = yepao.getStringValue("type_code", i);
			String type_name = yepao.getStringValue("type_name", i);
			String card_type = yepao.getStringValue("card_type", i);
			String gym = yepao.getStringValue("gym", i);
			int days = yepao.getIntegerValue("days", i);
			long amt = yepao.getLongValue("amt", i);
			int times = yepao.getIntegerValue("times", i);
			long type_fee = yepao.getLongValue("type_fee", i);
			long CHECKIN_FEE = yepao.getIntegerValue("CHECKIN_FEE", i);
			int dis_goods = yepao.getIntegerValue("dis_goods", i);

			Entity en = new EntityImpl(conn);
			int s = en.executeQuery("select * from f_card a where a.card_name=? and a.cust_name=?", new String[] { type_name, cust_name });
			if (s > 0) {
				cards.put(type_code, en.getStringValue("id"));
				continue;
			}
			Entity f_card = new EntityImpl("f_card", conn);
			f_card.setValue("cust_name", cust_name);
			f_card.setValue("gym", gym);
			f_card.setValue("card_type", card_type);
			f_card.setValue("card_name", type_name);
			f_card.setValue("days", days);
			f_card.setValue("amt", amt);
			f_card.setValue("times", times);
			f_card.setValue("fee", type_fee);
			f_card.setValue("checkin_fee", CHECKIN_FEE);
			f_card.setValue("op_time", new Date());
			f_card.setValue("op_user_id", "sys");
			f_card.setValue("remark", "导入也跑会员信息，系统自动创建的卡");
			f_card.setValue("state", "001");
			f_card.setValue("show_app", "N");
			f_card.setValue("app_amt", 0);
			f_card.setValue("is_lession_only", "N");
			// f_card.setValue("pic_url", "");
			f_card.setValue("labels", "自动创建");
			f_card.setValue("summary", "导入也跑会员信息，系统自动创建的卡");
			f_card.setValue("content", "导入也跑会员信息，系统自动创建的卡");
			f_card.setValue("is_share", "N");
			f_card.setValue("is_fanmily", "N");
			// f_card.setValue("leave_days", "");
			f_card.setValue("leave_free_times", 0);
			f_card.setValue("leave_unit", 1);
			f_card.setValue("leave_unit_price", 0);
			f_card.setValue("count", dis_goods);
			String cardId = f_card.create();
			cards.put(type_code, cardId);
		}
		// 卡种可见门店
		size = yepao.executeQuery("select a.gym,a.type_code from yp_type_gym a where a.cust_name=?", new String[] { cust_name });
		for (int i = 0; i < size; i++) {
			String gym = yepao.getStringValue("gym", i);
			String type_code = yepao.getStringValue("type_code", i);
			String cardId = Utils.getMapStringValue(cards, type_code);
			Entity f_card_gym = new EntityImpl("f_card_gym", conn);
			f_card_gym.setValue("cust_name", cust_name);
			f_card_gym.setValue("gym", gym);
			f_card_gym.setValue("fk_card_id", cardId);
			f_card_gym.setValue("view_gym", gym);
			f_card_gym.create();
		}
	}

}
