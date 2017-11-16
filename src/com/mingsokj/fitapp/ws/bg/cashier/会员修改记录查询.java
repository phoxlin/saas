package com.mingsokj.fitapp.ws.bg.cashier;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.c.Code;
import com.jinhua.server.c.Codes;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.m.FitUser;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.utils.MemUtils;

public class 会员修改记录查询 extends BasicAction {

	@Route(value = "/fit-mem-update-getUserCardDetial", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void getUserCardDetial() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String cust_name = user.getCust_name();
		String fk_update_id = this.getParameter("fk_update_id");
		String sql = "select id,card_name,card_type from f_card where cust_name=?";
		Entity en = new EntityImpl(this);
		int size = en.executeQuery(sql, new Object[] { cust_name });
		List<Map<String, Object>> allCards = en.getValues();

		sql = "select old_msg,id from f_update_" + cust_name + " where id=?";
		en = new EntityImpl(this);
		size = en.executeQuery(sql, new Object[] { fk_update_id });
		if (size > 0) {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			List<Map<String, Object>> cards = new ArrayList<Map<String, Object>>();
			for (int i = 0; i < size; i++) {
				String old_msg = en.getValues().get(i).get("old_msg") + "";
				Map<String, Object> x = (Map<String, Object>) getValue(old_msg);
				String active_time = x.get("active_time") + "";
				String deadline = x.get("deadline") + "";
				String card_id = x.get("card_id") + "";

				if (!Utils.isNull(active_time)) {
					x.put("active_time", sdf.format(Utils.parse2Date(active_time, "yyyy-MM-dd")));
				} else {
					x.put("active_time", "");
				}
				if (!Utils.isNull(deadline)) {
					x.put("deadline", sdf.format(Utils.parse2Date(deadline, "yyyy-MM-dd")));
				}
				// 教练
				String pt_id = x.get("pt_id") + "";
				if (!Utils.isNull(pt_id)) {
					MemInfo mem = MemUtils.getMemInfo(pt_id, cust_name);
					x.put("pt_name", mem.getName());
				}
				// 会籍
				String mc_id = x.get("mc_id") + "";
				if (!Utils.isNull(mc_id)) {
					MemInfo mem = MemUtils.getMemInfo(mc_id, cust_name);
					x.put("mc_name", mem.getName());
				}

				for (Map<String, Object> m : allCards) {
					String fk_card_id = m.get("id") + "";
					if (fk_card_id.equals(card_id)) {
						x.put("card_name", m.get("card_name"));
						x.put("card_type", m.get("card_type"));
					}

				}
				cards.add(x);
			}
			this.obj.put("cards", cards.get(0));
		}
	}

	@Route(value = "/fit-mem-update-record", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void record() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String fk_user_id = this.getParameter("fk_user_id");
		String cust_name = user.getCust_name();
		String update_id = this.getParameter("update_id");
		String sql = "select id, DATE_FORMAT(create_time,'%Y-%m-%d %H:%i:%S') create_time from f_update_" + cust_name
				+ " where fk_user_id=? and type='会员信息修改'";
		Entity en = new EntityImpl(this);
		int size = en.executeQuery(sql, new Object[] { fk_user_id });
		if (size > 0) {
			// 修改记录列表
			this.obj.put("upate_time", en.getValues());

			en = new EntityImpl(this);
			String par = "";
			if (Utils.isNull(update_id)) {
				sql = "select id,old_msg,create_time from f_update_" + cust_name
						+ " where fk_user_id=? and type='会员信息修改' group by create_time desc ";
				par = fk_user_id;
			} else {
				sql = "select old_msg from f_update_" + cust_name + " where id=?";
				par = update_id;
			}
			size = en.executeQuery(sql, new Object[] { par });
			if (size > 0) {
				String old_msg = en.getValues().get(0).get("old_msg") + "";
				Map<String, Object> x = (Map<String, Object>) getValue(old_msg);
				String sex = x.get("sex") + "";
				if ("famale".equals(sex)) {
					x.put("sex", "女");
				} else {
					x.put("sex", "男");
				}
				String mc_id = x.get("mc_id") + "";
				MemInfo mc = MemUtils.getMemInfo(mc_id, cust_name);
				if (mc != null) {
					x.put("mcName", mc.getMem_name());
				} else {
					x.put("mcName", "");
				}
				String pt_names = x.get("pt_names") + "";
				MemInfo pt = MemUtils.getMemInfo(pt_names, cust_name);
				if (pt != null) {
					x.put("ptName", pt.getMem_name());
				} else {
					x.put("ptName", "");
				}
				long remain_amt = Utils.toPriceLong(x.get("remain_amt") + "");
				x.put("remainAmtStr", Utils.toPrice(remain_amt / 100));
				Code code = Codes.code("user_state");
				x.put("stateStr", code.getNote(x.get("state") + ""));
				this.obj.put("user", x);
			}
		}

		sql = "select id,card_name,card_type from f_card where cust_name=?";
		en = new EntityImpl(this);
		size = en.executeQuery(sql, new Object[] { cust_name });
		List<Map<String, Object>> allCards = en.getValues();

		sql = "select old_msg,id from f_update_" + cust_name + " where fk_user_id=? and type='会员卡信息修改'";
		en = new EntityImpl(this);
		size = en.executeQuery(sql, new Object[] { fk_user_id });
		if (size > 0) {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			List<Map<String, Object>> cards = new ArrayList<Map<String, Object>>();
			for (int i = 0; i < size; i++) {
				String old_msg = en.getValues().get(i).get("old_msg") + "";
				String id = en.getValues().get(i).get("id") + "";
				Map<String, Object> x = (Map<String, Object>) getValue(old_msg);
				String active_time = x.get("active_time") + "";
				String deadline = x.get("deadline") + "";
				String card_id = x.get("card_id") + "";

				if (!Utils.isNull(active_time)) {
					x.put("active_time", sdf.format(Utils.parse2Date(active_time, "yyyy-MM-dd")));
				} else {
					x.put("active_time", "");
				}
				if (!Utils.isNull(deadline)) {
					x.put("deadline", sdf.format(Utils.parse2Date(deadline, "yyyy-MM-dd")));
				}
				// 教练
				String pt_id = x.get("pt_id") + "";
				if (!Utils.isNull(pt_id)) {
					MemInfo mem = MemUtils.getMemInfo(pt_id, cust_name);
					x.put("pt_name", mem.getName());
				}
				// 会籍
				String mc_id = x.get("mc_id") + "";
				if (!Utils.isNull(mc_id)) {
					MemInfo mem = MemUtils.getMemInfo(mc_id, cust_name);
					x.put("mc_name", mem.getName());
				}

				for (Map<String, Object> m : allCards) {
					String fk_card_id = m.get("id") + "";
					if (fk_card_id.equals(card_id)) {
						x.put("card_name", m.get("card_name"));
						x.put("card_type", m.get("card_type"));
					}

				}

				x.put("msg_id", id);
				cards.add(x);
			}
			this.obj.put("cards", cards);
		}

	}

	public Object getValue(String param) {
		Map<String, Object> map = new HashMap<String, Object>();
		String str = "";
		String key = "";
		Object value = "";
		char[] charList = param.toCharArray();
		boolean valueBegin = false;
		for (int i = 0; i < charList.length; i++) {
			char c = charList[i];
			if (c == '{') {
				if (valueBegin == true) {
					value = getValue(param.substring(i, param.length()));
					i = param.indexOf('}', i) + 1;
					map.put(key, value);
				}
			} else if (c == '=') {
				valueBegin = true;
				key = str;
				str = "";
			} else if (c == ',') {
				valueBegin = false;
				value = str;
				str = "";
				map.put(key, value);
			} else if (c == '}') {
				if (str != "") {
					value = str;
				}
				map.put(key, value);
				return map;
			} else if (c != ' ') {
				str += c;
			}
		}
		return map;
	}
}
