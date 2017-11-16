package com.mingsokj.fitapp.ws.dx;

import java.io.InputStream;
import java.math.BigDecimal;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.hp.hpl.sparta.ParseException;
import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.m.FitUser;
import com.mingsokj.fitapp.utils.ExcelUtils;

public class 会员Excel导入 extends BasicAction {
	private static String[] cardTypes = new String[] { "天数卡", "次卡", };
	private static String[] states = new String[] { "激活", "未激活", "公共池", "挂失" };

	/**
	 * 批量导入会员<br/>
	 * 
	 * 使用注意:<br/>
	 * 1.性别格式为: 男 女<br/>
	 * 2.手机号码,不能重复<br/>
	 * 4.余额 必须填大于0的数字,非法数字默认为0<br/>
	 * 5.积分 必须填大于0的数字,非法数字默认为0<br/>
	 * 6.会员卡类型 只支持: 天数卡 次卡 <br/>
	 * 7.会员卡 为系统里面当前已经存在的卡种名称<br/>
	 * 8.卡号 不能重复或者不填<br/>
	 * 9.购卡时间 日期格式统一为: 2016-12-21<br/>
	 * 10. 办卡费用 必须填大于0的数字,非法数字默认为0<br/>
	 * 11. 会员状态 只支持: 激活 未激活 公共池 ,默认为激活<br/>
	 * 12. 会籍电话 电话如果在系统里面没有找到,默认空 <br/>
	 * 
	 * @throws Exception
	 */
	@Route(value = "/ws-import-excel-users", conn = true, m = HttpMethod.POST)
	public void importUsers() throws Exception {
		boolean confirmed = Utils.isTrue(this.getParameter("confirm"));
		String u = this.getParameter("url");
		HttpURLConnection conn = null;
		InputStream is = null;
		URL url = null;
		Workbook wb = null;
		Sheet st = null;
		try {
			url = new URL(u);
			conn = (HttpURLConnection) url.openConnection();
			conn.setDoInput(true);
			conn.setRequestMethod("GET");
			is = conn.getInputStream();
			wb = new XSSFWorkbook(is);
			st = wb.getSheetAt(0);
		} catch (Exception e) {
			throw e;
		} finally {
			try {
				if (wb != null) {
					wb.close();
				}
			} catch (Exception e) {
			}
			try {
				if (is != null) {
					is.close();
				}
			} catch (Exception e) {
			}
			try {
				if (conn != null) {
					conn.disconnect();
				}
			} catch (Exception e) {
			}
		}

		FitUser user = (FitUser) this.getSessionUser();

		/**
		 * 第1列表示:姓名*<br/>
		 * 第2列表示:性别*<br/>
		 * 第3列表示:手机号码*<br/>
		 * 第4列表示:生日<br/>
		 * 第5列表示:余额<br/>
		 * 第6列表示:积分<br/>
		 * 第7列表示:会员卡类型*<br/>
		 * 第8列表示:会员卡*<br/>
		 * 第9列表示:卡号<br/>
		 * 第10列表示:购卡时间*<br/>
		 * 第11列表示:开卡时间<br/>
		 * 第12列表示:结束时间<br/>
		 * 第13列表示:购卡费用<br/>
		 * 第14列表示:会员状态*<br/>
		 * 第15列表示:会籍电话<br/>
		 * 第16列表示:剩余次数<br/>
		 * 第17列表示:备注<br/>
		 * 
		 */

		// 检查从第几行开始，检查列名：第一列：姓名 第二列：性别 第三列：手机号码 第四列：生日
		int rowIndex = 0;
		boolean flag = false;
		for (int i = 0; i < st.getLastRowNum(); i++) {
			Row row = st.getRow(i);
			if (row != null) {
				String name = ExcelUtils.getValue(row.getCell(0));
				String sex = ExcelUtils.getValue(row.getCell(1));
				String phone = ExcelUtils.getValue(row.getCell(2));
				String birthday = ExcelUtils.getValue(row.getCell(3));// 生日
				String amt = ExcelUtils.getValue(row.getCell(4));// 余额
				String cent = ExcelUtils.getValue(row.getCell(5));// 积分
				String cardType = ExcelUtils.getValue(row.getCell(6));// 会员卡类型
				String cardName = ExcelUtils.getValue(row.getCell(7));// 会员卡*
				String mem_no = ExcelUtils.getValue(row.getCell(8));// 卡号
				String buyTime = ExcelUtils.getValue(row.getCell(9));// 购卡时间*
				String actTime = ExcelUtils.getValue(row.getCell(10));// 开卡时间*
				String endTime = ExcelUtils.getValue(row.getCell(11));// 结束时间*
				String fee = ExcelUtils.getValue(row.getCell(12));// 购卡费用
				String state = ExcelUtils.getValue(row.getCell(13));// 会员状态*
				String emp_phone = ExcelUtils.getValue(row.getCell(14));// 会籍电话
				String cardSurplusTimes = ExcelUtils.getValue(row.getCell(15));// 剩余次数
				String remark = ExcelUtils.getValue(row.getCell(16));// 备注
				if (name.equals("姓名") && sex.equals("性别") && phone.equals("手机号码") && birthday.equals("生日") && amt.equals("余额") && cent.equals("积分") && cardType.equals("会员卡类型") && cardName.equals("会员卡") && mem_no.equals("卡号") && buyTime.equals("购卡时间") && actTime.equals("开卡时间") && endTime.equals("结束时间") && fee.equals("购卡费用") && state.equals("会员状态") && emp_phone.equals("会籍电话") && cardSurplusTimes.equals("剩余次数") && remark.equals("备注")) {
					rowIndex = i + 1;
					flag = true;
					break;
				}
			}
		}

		if (!flag) {
			throw new Exception("模板内容不对");
		}

		List<Map<String, String>> data = new ArrayList<>();// 判断后存放的excel数据集

		Set<String> memPhones = new HashSet<String>();

		Set<String> phones = new HashSet<>();// 系统里面的所有会员电话
		Set<String> memNos = new HashSet<>();// 系统里面的所有卡号
		Map<String, String> gymInfo = new HashMap<>();// 系统里面的所有门店代码
		Map<String, String> gymNameInfo = new HashMap<>();// 系统里面的所有门店 名称
		Set<String> cardNames = new HashSet<>();// 系统里面的所有卡种名称
		Set<String> emp_phones = new HashSet<>();// 系统里面的所有会籍电话
		Map<String, String> cardInfos = new HashMap<>();
		Map<String, Set<String>> cardGyms = new HashMap<>();
		Map<String, String> empInfo = new HashMap<>();// 会籍电话对于ID
		// 健身房所有会员手机号码和卡号
		Entity en = new EntityImpl(this);
		int size = en.executeQuery("select phone,mem_no from f_mem_" + user.getCust_name() + " where state in (?,?,?)", new String[] { "001", "002", "003" });// 可用会员的状态
		for (int i = 0; i < size; i++) {
			String p = en.getStringValue("phone", i);
			String no = en.getStringValue("mem_no", i);
			phones.add(p);
			memNos.add(no);
		}
		size = en.executeQuery("select a.gym,a.gym_name from f_gym a where a.cust_name=?", new String[] { user.getCust_name() });
		for (int i = 0; i < size; i++) {
			String g = en.getStringValue("gym", i);
			String gym_name = en.getStringValue("gym_name", i);
			gymInfo.put(g, gym_name);
			gymNameInfo.put(gym_name, g);
		}
		size = en.executeQuery("select a.gym,a.card_name,a.card_type,a.id,a.days,a.times from f_card a where a.cust_name=? and a.card_type in (?,?)", new String[] { user.getCust_name(), "001", "003" });
		for (int i = 0; i < size; i++) {
			String id = en.getStringValue("id", i);
			String type_name = en.getStringValue("card_name", i);
			String card_type = en.getStringValue("card_type", i);// 001为天数卡，003为次数卡
			int days = en.getIntegerValue("days", i);
			int times = en.getIntegerValue("times", i);

			cardNames.add(type_name);
			String pre = cardInfos.put(type_name, id);
			if (pre != null && !pre.equals(user.getGym())) {
				String tg = en.getStringValue("gym", i);
				if (tg.equals(user.getGym())) {
					cardInfos.put(type_name + "__card_type", card_type);
					cardInfos.put(type_name + "__days", days + "");
					cardInfos.put(type_name + "__times", times + "");
				} else if (tg.equals(user.getCust_name())) {
					cardInfos.put(type_name + "__card_type", card_type);
					cardInfos.put(type_name + "__days", days + "");
					cardInfos.put(type_name + "__times", times + "");
				} else {
					cardInfos.put(type_name, pre);
				}
			} else {
				cardInfos.put(type_name + "__card_type", card_type);
				cardInfos.put(type_name + "__days", days + "");
				cardInfos.put(type_name + "__times", times + "");
			}
		}

		size = en.executeQuery("select a.FK_CARD_ID,a.VIEW_GYM from f_card_gym a where a.CUST_NAME=?", new String[] { user.getCust_name() });
		if (size > 0) {
			for (int i = 0; i < size; i++) {
				String fk_card_id = en.getStringValue("fk_card_id", i);
				String VIEW_GYM = en.getStringValue("VIEW_GYM", i);

				Set<String> gyms = cardGyms.get(fk_card_id);
				if (gyms == null) {
					gyms = new HashSet<>();
					cardGyms.put(fk_card_id, gyms);
				}
				gyms.add(VIEW_GYM);
			}
		}

		size = en.executeQuery("select b.id,b.phone,b.mem_name from f_emp a,f_mem_" + user.getCust_name() + " b where a.id = b.id and a.CUST_NAME=?", new String[] { user.getCust_name() });
		for (int i = 0; i < size; i++) {
			String phone = en.getStringValue("phone", i);
			emp_phones.add(phone);
			empInfo.put(phone, en.getStringValue("id", i));
			empInfo.put(phone + "__name", en.getStringValue("mem_name", i));
		}

		List<String> errors = new ArrayList<>();
		List<String> warnings = new ArrayList<>();

		Map<String, Map<String, Object>> newCards = new HashMap<>();

		for (; rowIndex <= st.getLastRowNum(); rowIndex++) {
			Row row = st.getRow(rowIndex);
			if (row == null) {
				continue;
			}
			String name = ExcelUtils.getValue(row.getCell(0));// 姓名*
			String sex = ExcelUtils.getValue(row.getCell(1));// 性别*
			String phone = ExcelUtils.getValue(row.getCell(2));// 手机号码*
			String birthday = ExcelUtils.getValue(row.getCell(3));// 生日
			String amt = ExcelUtils.getValue(row.getCell(4));// 余额
			String cent = ExcelUtils.getValue(row.getCell(5));// 积分
			String cardType = ExcelUtils.getValue(row.getCell(6));// 会员卡类型
			String cardName = ExcelUtils.getValue(row.getCell(7));// 会员卡*
			String mem_no = ExcelUtils.getValue(row.getCell(8));// 卡号
			String buyTime = ExcelUtils.getValue(row.getCell(9));// 购卡时间*
			String actTime = ExcelUtils.getValue(row.getCell(10));// 开卡时间*

			String endTime = ExcelUtils.getValue(row.getCell(11));// 结束时间*

			String fee = ExcelUtils.getValue(row.getCell(12));// 办卡费用
			String state = ExcelUtils.getValue(row.getCell(13));// 会员状态*
			String emp_phone = ExcelUtils.getValue(row.getCell(14));// 会籍电话
			String cardSurplusTimes = ExcelUtils.getValue(row.getCell(15));// 剩余次数
			String remark = ExcelUtils.getValue(row.getCell(16));// 备注

			// 数据检查

			if (name == null || name.length() <= 0) {
				name = "会员";
			}
			if ("男".equals(sex)) {
				sex = "male";
			} else {
				sex = "female";
			}
			if (phone == null || phone.trim().length() <= 0) {
				errors.add("第" + (rowIndex + 1) + "行,手机号码不能为空");
				continue;
			} else {
				phone = phone.trim();
				if (phones.contains(phone)) {
					memPhones.add(phone);// 系统里面有过的会员
				}
			}
			if (birthday == null || birthday.length() <= 0) {
				birthday = Utils.parseData(new Date(), "yyyy-MM-dd");
			} else {
				try {
					Utils.parse2Date(birthday, "yyyy-MM-dd");// 检查下生日格式,如果不对就默认当天
				} catch (Exception ee) {
					birthday = Utils.parseData(new Date(), "yyyy-MM-dd");
				}
			}
			String gym = user.getViewGym();
			if (amt == null || amt.length() <= 0) {
				amt = "0";
			} else {
				try {
					Float.parseFloat(amt);
				} catch (Exception e) {
					amt = "0";
				}
			}

			if (cent == null || cent.length() <= 0) {
				cent = "0";
			} else {
				try {
					Float.parseFloat(cent);
				} catch (Exception e) {
					cent = "0";
				}
			}

			if (!Utils.contains(cardTypes, cardType)) {
				errors.add("第" + (rowIndex + 1) + "行,会员卡类型[" + cardType + "]错误,只能包括:[" + Utils.getListString(cardTypes) + "]");
			}
			Map<String, Object> card = newCards.get(cardName);
			if (card == null) {
				card = new HashMap<>();
				newCards.put(cardName, card);
				card.put("cardtype", cardType);
				card.put("cardName", cardName);
				card.put("fee", fee);
				card.put("times", cardSurplusTimes);
				Date actDate = Utils.parse2Date(actTime, "yyyy-MM-dd");
				try {
					Date endDate = Utils.parse2Date(endTime, "yyyy-MM-dd");
					if (endDate.after(actDate)) {
						long days = (endDate.getTime() - actDate.getTime()) / 1000 / 60 / 60 / 24;
						card.put("datePeriod", days + "");
					} else {
						errors.add("第" + (rowIndex + 1) + "行,结束时间比开卡时间早");
					}
				} catch (Exception e) {
					errors.add("第" + (rowIndex + 1) + "行,会员卡[" + cardName + "]不存在,新建卡的结束时间不能为空");
				}

				if (Utils.contains(cardNames, cardName)) {
					card.put("cardId", cardInfos.get(cardName));
				}

			}

			// names.add(gym);

			if (mem_no != null && mem_no.length() > 0) {
				if (Utils.contains(memNos, mem_no)) {
					// throw new Exception("第" + (rowIndex + 1) + "卡号[" +
					// mem_no + "]重复");
				} else {
					memNos.add(mem_no);
				}
			}

			if (buyTime == null || buyTime.length() <= 0) {
				errors.add("第" + (rowIndex + 1) + "行,购卡时间不能为空");
			} else {
				try {
					Utils.parse2Date(buyTime, "yyyy-MM-dd");// 检查下生日格式,如果不对就默认当天
				} catch (Exception ee) {
					errors.add("第" + (rowIndex + 1) + "行,购卡时间[" + buyTime + "]格式不对请用:yyyy-MM-dd格式(即2016-10-18)");
				}
			}

			if (fee == null || fee.length() <= 0) {
				fee = "0";
			} else {
				try {
					Float.parseFloat(fee);
				} catch (Exception e) {
					fee = "0";
				}
			}
			if (!Utils.contains(states, state)) {
				throw new Exception("第" + (rowIndex + 1) + "行,会员状态[" + state + "]错误,只能包括:[" + Utils.getListString(states) + "]");
			} else {
				if ("激活".equals(state)) {
					state = "001";
				} else if ("未激活".equals(state)) {
					state = "002";
				} else if ("挂失".equals(state)) {
					state = "006";
				} else {
					state = "004";
				}
			}
			if (actTime == null || actTime.length() <= 0) {
				warnings.add("第" + (rowIndex + 1) + "行,开卡时间为空");
				state = "002";
			} else {
				try {
					Utils.parse2Date(actTime, "yyyy-MM-dd");// 检查下生日格式,如果不对就默认当天
				} catch (Exception ee) {
					errors.add("第" + (rowIndex + 1) + "行,开卡时间[" + actTime + "]格式不对请用:yyyy-MM-dd格式(即2016-10-18)");
				}
			}

			if (emp_phone != null && emp_phone.length() > 0) {
				// 检查电话是否存在
				emp_phone = emp_phone.trim();
				if (!emp_phones.contains(emp_phone)) {
					errors.add("第" + (rowIndex + 1) + "行,会籍电话[" + emp_phone + "]错误,系统里面没有查询到该会籍");
				}
			}
			if (cardSurplusTimes != null && cardSurplusTimes.length() > 0) {
				try {
					Integer.parseInt(cardSurplusTimes);
				} catch (Exception e) {
					cardSurplusTimes = "0";
				}
			} else {
				cardSurplusTimes = "0";
			}

			if (remark != null) {
				if (remark.length() > 4000) {
					remark = remark.substring(0, 4000);
				}
			}

			Map<String, String> m = new HashMap<>();
			m.put("name", name);
			m.put("sex", sex);
			m.put("phone", phone);
			m.put("birthday", birthday);
			m.put("cust_name", user.getCust_name());
			m.put("gym", gym);
			m.put("amt", amt);
			m.put("cent", cent);
			m.put("cardType", cardType);
			m.put("cardName", cardName);
			m.put("mem_no", mem_no);
			m.put("buyTime", buyTime);
			m.put("actTime", actTime);
			m.put("endTime", endTime);
			m.put("fee", fee);
			m.put("state", state);
			// m.put("emp_name", emp_name);
			m.put("emp_phone", emp_phone);
			m.put("cardSurplusTimes", cardSurplusTimes);
			m.put("remark", remark);
			data.add(m);
		}
		// 判断是否需要先新建卡种,测试下数据是否报错
		try {
			if (newCards.size() > 0) {
				for (Map<String, Object> card : newCards.values()) {
					if (!card.containsKey("cardtype")) {
						throw new Exception("待建新卡里面卡类型没有设置【天数卡，次卡】");
					}
					if (!card.containsKey("cardName")) {
						throw new Exception("待建新卡里面卡类型没有设置卡名称");
					}
					/**
					 * 好像都不得报错，所以这些检查可有可无
					 */
				}
			}
		} catch (Exception e) {
			errors.add(e.getMessage());
		}
		if (errors.size() > 0) {
			throw new Exception(Utils.getListString(errors));
		}

		if (warnings.size() > 0) {
			if (!confirmed) {
				obj.put("flag", "msg");
				throw new Exception(Utils.getListString(warnings));
			}
		}

		if (!confirmed) {
			throw new Exception("数据检查通过，请保存上传数据");
		}

		// 开始建卡
		if (newCards.size() > 0) {
			for (Map<String, Object> card : newCards.values()) {
				String cardId = Utils.getMapStringValue(card, "cardId");
				String cardName = Utils.getMapStringValue(card, "cardName");
				if (cardId == null || cardId.length() <= 0) {
					String cardType = Utils.getMapStringValue(card, "cardtype");
					long fee = Utils.getMapLongValue(card, "fee") * 100;
					long times = Utils.getMapLongValue(card, "times");
					long datePeriod = Utils.getMapLongValue(card, "datePeriod");// 天数卡,天数

					// yp_type添加的卡未提交，获取的还是原type_code，故有如此处理

					Entity f_card = new EntityImpl("f_card", this);
					f_card.setValue("cust_name", user.getCust_name());
					f_card.setValue("gym", user.getGym());
					if ("天数卡".equals(cardType)) {
						f_card.setValue("card_type", "001");
					} else {
						f_card.setValue("card_type", "003");
					}
					f_card.setValue("card_name", cardName);
					f_card.setValue("days", datePeriod);
					f_card.setValue("amt", 0);
					f_card.setValue("times", times);
					f_card.setValue("fee", fee);
					f_card.setValue("checkin_fee", 0);
					f_card.setValue("op_time", new Date());
					f_card.setValue("op_user_id", user.getId());
					f_card.setValue("remark", "自动导入会员信息，系统自动创建的卡");
					f_card.setValue("state", "001");
					f_card.setValue("show_app", "N");
					f_card.setValue("app_amt", 0);
					f_card.setValue("is_lession_only", "N");
					// f_card.setValue("pic_url", "");
					f_card.setValue("labels", "自动创建");
					f_card.setValue("summary", "自动导入会员信息，系统自动创建的卡");
					f_card.setValue("content", "自动导入会员信息，系统自动创建的卡");
					f_card.setValue("is_share", "N");
					f_card.setValue("is_fanmily", "N");
					// f_card.setValue("leave_days", "");
					f_card.setValue("leave_free_times", 0);
					f_card.setValue("leave_unit", 1);
					f_card.setValue("leave_unit_price", 0);
					f_card.setValue("count", 100);
					cardId = f_card.create();
				}
				Set<String> gyms = cardGyms.get(cardId);
				if(gyms==null){
					gyms=new HashSet<>();
					cardGyms.put(cardId, gyms);
				}

				if (!Utils.contains(gyms, user.getViewGym())) {
					Entity f_card_gym = new EntityImpl("f_card_gym", this);
					f_card_gym.setValue("cust_name", user.getCust_name());
					f_card_gym.setValue("gym", user.getViewGym());
					f_card_gym.setValue("fk_card_id", cardId);
					f_card_gym.setValue("view_gym", user.getViewGym());
					f_card_gym.create();
					gyms.add(user.getViewGym());
				}
				cardInfos.put(cardName, cardId);
			}
		}

		BigDecimal num100 = new BigDecimal(100);

		// 所有数据正常,进行数据插入
		for (int i = 0, l = data.size(); i < l; i++) {
			Map<String, String> m = data.get(i);
			String name = Utils.getMapStringValue(m, "name");
			String sex = Utils.getMapStringValue(m, "sex");
			String phone = Utils.getMapStringValue(m, "phone");
			String birthday = Utils.getMapStringValue(m, "birthday");
			String cust_name = Utils.getMapStringValue(m, "cust_name");
			String amt = Utils.getMapStringValue(m, "amt");
			// String cent = Utils.getMapStringValue(m, "cent");
			// String cardType = Utils.getMapStringValue(m, "cardType");
			String cardName = Utils.getMapStringValue(m, "cardName");
			String mem_no = Utils.getMapStringValue(m, "mem_no");
			String buyTime = Utils.getMapStringValue(m, "buyTime");
			String actTime = Utils.getMapStringValue(m, "actTime");
			String endTime = Utils.getMapStringValue(m, "endTime");
			// String fee = Utils.getMapStringValue(m, "fee");
			String state = Utils.getMapStringValue(m, "state");
			String emp_phone = Utils.getMapStringValue(m, "emp_phone");
			String cents = Utils.getMapStringValue(m, "cent");
			String cardSurplusTimes = Utils.getMapStringValue(m, "cardSurplusTimes");
			String remark = Utils.getMapStringValue(m, "remark");

			String mc_id = Utils.getMapStringValue(empInfo, emp_phone);

			Entity f_mem = new EntityImpl("f_mem", this);
			f_mem.setTablename("f_mem_" + cust_name);
			// f_mem.setValue("pid", "");
			f_mem.setValue("cust_name", cust_name);
			f_mem.setValue("gym", user.getViewGym());
			f_mem.setValue("mem_name", name);
			f_mem.setValue("phone", phone);
			// f_mem.setValue("is_emp", "");
			f_mem.setValue("sex", sex);
			f_mem.setValue("mem_no", mem_no);
			f_mem.setValue("card_deposit_amt", 0);
			f_mem.setValue("birthday", birthday);
			// f_mem.setValue("id_card", "");身份证号
			// f_mem.setValue("addr", "");
			// f_mem.setValue("pic1", "");
			// f_mem.setValue("pic1_time", new Date());
			// f_mem.setValue("app_head", "");
			// f_mem.setValue("app_open_id", "");
			f_mem.setValue("wx_open_id", "");
			f_mem.setValue("mc_id", mc_id);
			// f_mem.setValue("pt_names", "");
			// f_mem.setValue("user_type", "");
			long u_amt = 0;
			try {
				u_amt = new BigDecimal(amt).multiply(num100).longValue();
			} catch (Exception e) {
			}
			f_mem.setValue("total_amt", u_amt);
			f_mem.setValue("remain_amt", u_amt);
			long cent = 0;
			try {
				cent = new BigDecimal(cents).longValue();
			} catch (Exception e) {
			}
			f_mem.setValue("total_cent", cent);
			f_mem.setValue("remain_cent", cent);
			f_mem.setValue("remark", remark);
			f_mem.setValue("create_time", new Date());
			// f_mem.setValue("update_time", "");
			// f_mem.setValue("finger1", "");
			// f_mem.setValue("finger2", "");

			// f_mem.setValue("rent_rec_id", "");
			// f_mem.setValue("is_rent", "N");
			// f_mem.setValue("rent_no", "");
			// f_mem.setValue("is_give_card", "");
			f_mem.setValue("state", state);
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

			if (memPhones.contains(phone)) {
				Entity entity = new EntityImpl(this);
				int checksize = entity.executeQuery("select a.id from f_mem_" + cust_name + " a where a.phone=?", new String[] { phone });
				if (checksize > 0) {
					id = entity.getStringValue("id");
				} else {
					id = f_mem.create();
					memPhones.add(phone);
				}
			} else {
				id = f_mem.create();
				memPhones.add(phone);
			}

			Entity entity = new EntityImpl("f_user_card", this);
			entity.setTablename("f_user_card_" + user.getViewGym());
			entity.setValue("cust_name", cust_name);
			entity.setValue("gym", user.getViewGym());
			// cardInfos.put(type_name + "__card_type", card_type);
			// cardInfos.put(type_name + "__days", days + "");
			// cardInfos.put(type_name + "__times", times + "");
			String card_id = Utils.getMapStringValue(cardInfos, cardName);
			int days = Utils.getMapIntegerValue(cardInfos, cardName + "__days");

			entity.setValue("card_id", card_id);
			entity.setValue("mem_id", id);
			entity.setValue("emp_id", user.getId());
			entity.setValue("emp_name", user.getMemInfo().getName());
			entity.setValue("source", "excelExport");

			entity.setValue("buy_time", buyTime);
			entity.setValue("create_time", new Date());
			entity.setValue("active_type", "001");
			entity.setValue("active_time", actTime);

			Date deadline = Utils.dateAddDay(Utils.parse2Date(buyTime, "yyyy-MM-dd"), days);
			try {
				Date endDate = Utils.parse2Date(endTime, "yyyy-MM-dd");
				entity.setValue("deadline", endDate);
			} catch (Exception e) {
				entity.setValue("deadline", deadline);
			}
			// entity.setValue("contract_no", "");
			entity.setValue("remark", "excel导入");
			entity.setValue("state", "001");
			entity.setValue("buy_for_app", "N");
			entity.setValue("op_id", user.getId());
			entity.setValue("buy_times", cardSurplusTimes);
			entity.setValue("remain_times", cardSurplusTimes);
			entity.setValue("give_card", "N");
			// entity.setValue("pt_id", "");
			entity.setValue("mc_id", mc_id);
			entity.setValue("examine_emp_id", "");

			entity.setValue("give_days", "0");
			entity.setValue("give_card_id", "");
			entity.setValue("give_times", "0");
			entity.setValue("give_amt", "0");
			// entity.setValue("leave_times", "");
			entity.setValue("real_amt", "0");
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
		}

		this.obj.put("count", data.size());

	}

	/**
	 * 计算两个日期之间相差的天数
	 * 
	 * @param smdate
	 *            较小的时间
	 * @param bdate
	 *            较大的时间
	 * @return 相差天数
	 * @throws ParseException
	 */
	public static int daysBetween(Date smdate, Date bdate) throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		smdate = sdf.parse(sdf.format(smdate));
		bdate = sdf.parse(sdf.format(bdate));
		Calendar cal = Calendar.getInstance();
		cal.setTime(smdate);
		long time1 = cal.getTimeInMillis();
		cal.setTime(bdate);
		long time2 = cal.getTimeInMillis();
		long between_days = (time2 - time1) / (1000 * 3600 * 24);

		return Integer.parseInt(String.valueOf(between_days));
	}
}
