package com.mingsokj.fitapp.utils;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import com.jinhua.enuts.ColumnType;
import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Column;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.log.Logger;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.Utils;
import com.mysql.jdbc.exceptions.jdbc4.MySQLSyntaxErrorException;

public class CheckxmlAction extends BasicAction {
	private static Map<String, Boolean> custTables = new HashMap<>();
	private static Map<String, Boolean> gymTables = new HashMap<>();
	public static String[] cust_tablenames = new String[] { "f_update", "f_wx_cust"/* wx用户 */, "f_fit_plan"/* 健身计划 */ , "f_mem"/* 会员 */ , "f_active_record"/* 活动参与记录 */ };
	public static String[] gym_tablenames = new String[] { "f_body_data", "f_msg_send", "f_flow", "f_class_record"/* 团课上课记录 */, "f_checkin"/* 出入场记录 */, "f_fit_plan_detail"/* 健身计划详细 */, "f_mem_maintain"/* 会员维护 */, "f_mem_recommend"/* 会员推荐 */, "f_order"/* 团课预约 */, "f_other_pay" /* 各种其他支付 */, "f_pre_fee"/* 付定金 */, "f_private_record"/* 私课消课记录 */, "f_rent"/* 租柜 */, "f_sign_month"/* 打卡记录 */, "f_store_rec"/* 商品出入库 */, "f_user_card"/* 会员卡 */, "f_private_order"/* 预约私教 */ };

	@Route(value = "/checkdb", conn = true, m = HttpMethod.GET, type = ContentType.JSON)
	public void checkxml2() throws Exception {
		//String[] tables = new String[] { "f_update", "f_wx_cust"/* wx用户 */, "f_fit_plan"/* 健身计划 */ , "f_mem"/* 会员 */ , "f_active_record"/* 活动参与记录 */,"f_body_data", "f_msg_send", "f_flow", "f_class_record"/* 团课上课记录 */, "f_checkin"/* 出入场记录 */, "f_fit_plan_detail"/* 健身计划详细 */, "f_mem_maintain"/* 会员维护 */, "f_mem_recommend"/* 会员推荐 */, "f_order"/* 团课预约 */, "f_other_pay" /* 各种其他支付 */, "f_pre_fee"/* 付定金 */, "f_private_record"/* 私课消课记录 */, "f_rent"/* 租柜 */, "f_sign_month"/* 打卡记录 */, "f_store_rec"/* 商品出入库 */, "f_user_card"/* 会员卡 */, "f_private_order"/* 预约私教 */ };
		String[] tables = new String[]{"f_user_card"};
		checktables(tables, cust_tablenames, gym_tablenames);
	}

	public void checktables(String[] singleTables, String[] custTables, String[] gymTables) throws Exception {
		List<String> li = new ArrayList<>();
		List<String> logs = new ArrayList<>();
		Map<String, String> allTables = new HashMap<>();
		if (singleTables != null && singleTables.length > 0) {
			for (String s : singleTables) {
				allTables.put(s, s);
			}
		}
		Entity entity2 = new EntityImpl(this);
		int size = entity2.executeQuery("select cust_name,gym from f_gym order by cust_name,gym");
		Map<String, Set<String>> gymInfos = new HashMap<>();
		for (int i = 0; i < size; i++) {
			String cust_name = entity2.getStringValue("cust_name", i);
			String gym = entity2.getStringValue("gym", i);

			Set<String> gyms = gymInfos.get(cust_name);
			if (gyms == null) {
				gyms = new HashSet<>();
				gymInfos.put(cust_name, gyms);
			}
			gyms.add(gym);
		}

		if (custTables != null && custTables.length > 0) {
			for (String s : custTables) {
				allTables.put(s, s);
				for (String custname : gymInfos.keySet()) {
					allTables.put(s + "_" + custname, s);
				}
			}
		}
		if (gymTables != null && gymTables.length > 0) {
			for (String s : gymTables) {
				allTables.put(s, s);
				for (Entry<String, Set<String>> er : gymInfos.entrySet()) {
					Set<String> gyms = er.getValue();
					for (String g : gyms) {
						allTables.put(s + "_" + g, s);
					}
				}
			}
		}

		for (Entry<String, String> er : allTables.entrySet()) {
			checkTable(er.getKey(), er.getValue(), li, logs, getConnection());
		}
		this.obj.put("logs", Utils.getListString(logs));
		this.obj.put("sqls", Utils.getListString(li, ";"));
	}

	private static void checkTable(String tablename, String xmlName, List<String> li, List<String> logs, Connection conn) {
		/**
		 * 1.检查是否存在表<br/>
		 * 2.如果在，就检查字段是否匹配
		 */
		/**
		 * 检查是否存在表
		 */
		Entity en = new EntityImpl(conn);
		try {
			int size = en.executeQuery("SHOW TABLES LIKE '" + tablename + "'");
			if("f_user_card".equals(tablename)){
				System.out.println(11);
			}
			if (size <= 0) {
				// 没有表，
				Entity entity = new EntityImpl(xmlName, conn);
				entity.setTablename(tablename);
				entity.DDL(false);
				logs.add("增加了表：" + tablename);
			} else {
				// 有表,检查字段
				Entity entity = new EntityImpl(xmlName, conn);
				int size2 = en.executeQuery("show columns from " + tablename);

				for (Column col : entity.getCols()) {
					Boolean flag = false;
					String type2 = null;
					boolean nullable = true;
					if (size2 > 0) {
						for (int j = 0; j < size2; j++) {
							String field = en.getStringValue("Field", j).toLowerCase();
							if (col.getName().equals(field)) {
								flag = true;
								type2 = en.getStringValue("type", j);
								nullable = en.getBooleanValue("null", j);
								break;
							}
						}
					}
					if (!flag) {
						String type = "";
						if (col.getType() == ColumnType.STRING) {
							if (col.getLength() == 0) {
								throw new Exception(xmlName + ".xml中的【" + col.getName() + "】字段长度为0");
							} else {
								if (col.getLength() == 65000) {
									type = " text() ";
								} else if (col.getLength() == 15000000) {
									type = " MEDIUMTEXT () ";
								} else if (col.getLength() > 15000000) {
									type = " LONGTEXT () ";
								} else {
									type = " varchar(" + col.getLength() + ")";
								}
							}
						} else if (col.getType() == ColumnType.DATETIME || col.getType() == ColumnType.DATE) {
							type = " datetime ";

						} else if (col.getType() == ColumnType.INT || col.getType() == ColumnType.FLOAT || col.getType() == ColumnType.LONG) {
							type = " long  ";
						} else if (col.getType() == ColumnType.TEXT) {
							type = " text  ";
						} else if (col.getType() == ColumnType.LONGTEXT) {
							type = " LONGTEXT  ";
						} else if (col.getType() == ColumnType.MEDIUMTEXT) {
							type = " LONGTEXT  ";
						}
						String alertStr = "alter table " + tablename + " add " + col.getName() + type + (col.isNullable() ? "" : " not Null");

						li.add(alertStr);
					} else {
						// alter table admin MODIFY post VARCHAR(500)

						if (col.getType() == ColumnType.STRING) {
							if (!type2.equalsIgnoreCase("varchar(" + col.getLength() + ")")) {
								if (col.getLength() > 4000 && col.getLength() <= 65000) {
									if (!type2.equalsIgnoreCase("text")) {
										String alertStr = "alter table " + tablename + " MODIFY " + col.getName() + " text ";
										li.add(alertStr);
									}
								} else if (col.getLength() > 65000 && col.getLength() <= 15000000) {
									if (!type2.equalsIgnoreCase("MEDIUMTEXT")) {
										String alertStr = "alter table " + tablename + " MODIFY " + col.getName() + " MEDIUMTEXT ";
										li.add(alertStr);
									}
								} else if (col.getLength() > 15000000) {
									if (!type2.equalsIgnoreCase("LONGTEXT")) {
										String alertStr = "alter table " + tablename + " MODIFY " + col.getName() + " LONGTEXT ";
										li.add(alertStr);
									}
								} else {
									String alertStr = "alter table " + tablename + " MODIFY " + col.getName() + " varchar(" + col.getLength() + ")";
									li.add(alertStr);
								}
							} else {
								if (col.isNullable()) {
									// 如果配置里面写的可以为空，数据库里面配的不能为空，着产生一条修改语句：
									if (!nullable) {
										String alertStr = "alter table " + tablename + " MODIFY " + col.getName() + " varchar(" + col.getLength() + ") null";
										li.add(alertStr);
									}
								} 

							}
						} else if (col.getType() == ColumnType.DATETIME || col.getType() == ColumnType.DATE) {
							if (!(type2.equalsIgnoreCase("DATETIME") || type2.equalsIgnoreCase("DATE"))) {
								String alertStr = "alter table " + tablename + " MODIFY " + col.getName() + " DATETIME" +  (col.isNullable() ? "" : " not Null");
								li.add(alertStr);
							}
						} else if (col.getType() == ColumnType.INT || col.getType() == ColumnType.FLOAT || col.getType() == ColumnType.LONG) {
							if (!(type2.startsWith("bigint") ||type2.equalsIgnoreCase("INT") || type2.equalsIgnoreCase("FLOAT") || type2.equalsIgnoreCase("LONG"))) {
								String alertStr = "alter table " + tablename + " MODIFY " + col.getName() + " bigint" + (col.isNullable() ? "" : " not Null");
								li.add(alertStr);
							}
						} else if (col.getType() == ColumnType.TEXT) {
						} else if (col.getType() == ColumnType.LONGTEXT) {
						} else if (col.getType() == ColumnType.MEDIUMTEXT) {
						}
					}
				}

			}
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	/**
	 * 单表检查xml与数据库中的字段是否匹配
	 * 
	 * @param tables
	 * @throws Exception
	 */
	public void checkxmlMethod(String[] tables) throws Exception {

		List<String> list = new ArrayList<String>();
		for (int i = 0; i < tables.length; i++) {
			Entity en = new EntityImpl(tables[i], this);
			for (Column col : en.getCols()) {
				Boolean flag = false;
				int size = en.executeQuery("show columns from " + tables[i]);
				System.out.println(size + "name:" + col.getName());
				if (size > 0) {
					for (int j = 0; j < size; j++) {
						String field = en.getStringValue("Field", j).toLowerCase();
						if (col.getName().equals(field)) {
							flag = true;
							break;
						}
					}
				}
				if (!flag) {
					String type = "";
					if (col.getType() == ColumnType.STRING) {
						if (col.getLength() == 0) {
							throw new Exception(tables[i] + ".xml中的【" + col.getName() + "】字段长度为0");
						} else {
							type = " varchar(" + col.getLength() + ")";
						}
					} else if (col.getType() == ColumnType.DATETIME || col.getType() == ColumnType.DATE) {
						type = "datetime ";

					} else if (col.getType() == ColumnType.INT || col.getType() == ColumnType.FLOAT || col.getType() == ColumnType.LONG) {
						type = " bigint  ";
					} else if (col.getType() == ColumnType.TEXT) {
						type = " text  ";
					} else if (col.getType() == ColumnType.LONGTEXT) {
						type = " LONGTEXT  ";
					} else if (col.getType() == ColumnType.MEDIUMTEXT) {
						type = " LONGTEXT  ";
					}
					String alertStr = "alter table " + tables[i] + " add " + col.getName() + type + (col.isNullable() ? "" : " not Null");
					list.add(alertStr);
				}
			}

		}
		this.obj.put("alertStr2", list);
	}

	/**
	 * 多表检查xml与数据库中的字段是否匹配
	 * 
	 * @param tables
	 * @throws Exception
	 */
	public void checkxmlMethod1(String[] tables) throws Exception {
		Entity entity2 = new EntityImpl(this);
		StringBuffer result = new StringBuffer();
		int size = entity2.executeQuery("select cust_name,gym from yp_gym order by cust_name,gym");
		for (int i = 0; i < tables.length; i++) {
			String ct = tables[i];
			Entity entity = new EntityImpl(ct, this);
			if (size > 0) {
				for (int j = 0; j < size; j++) {
					String gym = entity2.getStringValue("gym", j);
					try {
						int size2 = entity.executeQuery("select count(1) num from " + ct + "_" + gym);
						if (size2 > 0) {
							int size3 = entity.executeQuery("show columns from " + ct + "_" + gym);
							for (Column col : entity.getCols()) {
								Boolean flag = false;
								if (size3 > 0) {
									for (int m = 0; m < size3; m++) {
										String field = entity.getStringValue("Field", m).toLowerCase();
										if (col.getName().equals(field)) {
											flag = true;
											break;
										}
									}
								}
								if (!flag) {
									String type = "";
									if (col.getType() == ColumnType.STRING) {
										if (col.getLength() == 0) {
											throw new Exception(ct + ".xml中的【" + col.getName() + "】字段长度为" + col.getLength());
										} else {
											type = " varchar(" + col.getLength() + ")";
										}
									} else if (col.getType() == ColumnType.DATETIME || col.getType() == ColumnType.DATE) {
										type = " datetime ";

									} else if (col.getType() == ColumnType.INT || col.getType() == ColumnType.FLOAT || col.getType() == ColumnType.LONG) {
										type = " bigint  ";
									} else if (col.getType() == ColumnType.TEXT) {
										type = " text  ";
									} else if (col.getType() == ColumnType.LONGTEXT) {
										type = " LONGTEXT  ";
									} else if (col.getType() == ColumnType.MEDIUMTEXT) {
										type = " LONGTEXT  ";
									}
									String alertStr = "alter table " + ct + "_" + gym + " add " + col.getName() + type + (col.isNullable() ? "" : " not Null");

									result.append(alertStr + ";");
									System.out.println("result:" + result);
								}
							}
						}
					} catch (MySQLSyntaxErrorException e1) {
						Logger.info("数据库中没有" + "【" + ct + "_" + gym + "】表");
					}
				}
			}
		}
		this.obj.put("alertStr", result);
	}

}
