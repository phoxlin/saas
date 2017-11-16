package com.mingsokj.fitapp.ws.bg;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

public class ActiveAction extends BasicAction {

	@Route(value = "/fit-bg-active-save", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void active_save() throws Exception {

		FitUser user = (FitUser) this.getSessionUser();
		String cust_name = user.getCust_name();
		// String gym = user.getViewGym();

		String e = request.getParameter("e");
		Entity en = this.getEntityFromPage(e);

		String m = request.getParameter("m");
		String[] items = request.getParameterValues("f_active_item__prj_name");
		String act_id = "";
		if ("add".equals(m)) {
			en.setValue("create_time", new Date());
			act_id = en.create();
			// 项目
			if (items != null && items.length > 0) {
				for (int i = 0; i < items.length; i++) {
					Entity item = this.getEntityFromPage("f_active_item", i);
					item.setValue("act_id", act_id);
					String type = item.getStringValue("prj_type");
					if (type == null || "".equals(type)) {
						type = "goods";
					}
					item.setValue("price", Utils.toPriceLong(item.getStringValue("price")));
					item.setValue("act_price", Utils.toPriceLong(item.getStringValue("act_price")));
					item.setValue("prj_type", type);
					item.create();
				}
			}
		} else {
			act_id = en.getStringValue("id");
			en.update();
			if (items != null && items.length > 0) {
				for (int i = 0; i < items.length; i++) {
					Entity item = this.getEntityFromPage("f_active_item", i);
					String item_id = item.getStringValue("id");
					item.setValue("act_id", act_id);
					String type = item.getStringValue("prj_type");
					if (type == null || "".equals(type)) {
						type = "goods";
					}
					item.setValue("prj_type", type);
					item.setValue("price", Utils.toPriceLong(item.getStringValue("price")));
					item.setValue("act_price", Utils.toPriceLong(item.getStringValue("act_price")));
					if (item_id == null || "".equals(item_id)) {
						item.create();
					} else {
						item.update();
					}
				}
			} else {
				en.executeUpdate("delete from f_active_item where act_id = ?", new Object[] { act_id });
			}

		}
		String view_gym[] = request.getParameterValues("view_gym");
		en = new EntityImpl("f_active_gym", this);
		en.executeUpdate("delete from f_active_gym where act_id = ?", new Object[] { act_id });
		if (view_gym != null && view_gym.length > 0) {
			for (int i = 0; i < view_gym.length; i++) {
				en.setTablename("f_active_gym");
				en.setValue("act_id", act_id);
				en.setValue("cust_name", cust_name);
				en.setValue("view_gym", view_gym[i]);
				en.create();
			}
		}

	}

	@Route(value = "/fit-bg-active-item-del", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void active_item_del() throws Exception {
		String item_id = request.getParameter("item_id");
		Entity en = new EntityImpl(this);
		en.executeUpdate("delete from f_active_item where id = ?", new Object[] { item_id });
	}

	/**
	 * 推荐活动
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-app-active-load-commend-active", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void commend_active() throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		String now = sdf.format(new Date());
		String cust_name = request.getParameter("cust_name");
		String gym = request.getParameter("gym");

		Entity en = new EntityImpl("f_active", this);
		int s = en.executeQuery(
				"select ID,TITLE,SUMMARY,PIC_URL from f_active where cust_name = ? and gym = ? and state = 'start' and for_mem = 'N' and start_time <= ? and end_time >= ?",
				new Object[] { cust_name, gym, now, now });
		if (s > 0) {
			this.obj.put("actives", en.getValues());
		}
	}

	/**
	 * 活动列表
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-app-active-list", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void active_list() throws Exception {
		String cust_name = request.getParameter("cust_name");
		String gym = request.getParameter("gym");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		String now = sdf.format(new Date());
		Entity en = new EntityImpl("f_active", this);
		int s = en.executeQuery(
				"select ID,TITLE,SUMMARY,PIC_URL,start_time,end_time from f_active where cust_name = ? and gym = ? and start_time <= ? and end_time >= ? and state = 'start' and for_mem ='Y' order by start_time desc ",
				new Object[] { cust_name, gym, now, now });
		if (s > 0) {
			this.obj.put("actives", en.getValues());
		}
	}

	/**
	 * 活动详情
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-app-active-detail", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void active_detail() throws Exception {
		String active_id = request.getParameter("active_id");
		String id = request.getParameter("id");
		Entity en = new EntityImpl("f_active", this);
		en.setValue("id", active_id);
		String p = request.getParameter("page");
		String cust_name = request.getParameter("cust_name");
		int page = 1;
		int pageSize = 5;
		try {
			page = Integer.parseInt(p);
		} catch (Exception e) {
		}
		int x = en.search();
		if (x > 0) {
			Map<String, Object> detail = en.getValues().get(0);
			int s = en.executeQuery("select count(*) num from f_active_record_" + cust_name + " where act_id = ?",
					new Object[] { active_id });
			if (s > 0) {
				detail.put("activeNums", en.getIntegerValue("num"));
			}
			this.obj.put("detail", detail);
			// 活动已参与人数
			// 活动项目
			en = new EntityImpl(this);
			x = en.executeQuery("select a.*,b.fee from f_active_item a,f_card b where a.prj_id = b.id and a.act_id = ?",
					new Object[] { active_id });
			if (x > 0) {
				for (int i = 0; i < x; i++) {
					en.getValues().get(i).remove("content");
				}
				this.obj.put("items", en.getValues());
			}
			// 会员信息
			MemInfo info = MemUtils.getMemInfo(id, cust_name, L, true, this.getConnection());
			List<MemInfo> mms = new ArrayList<>();
			mms.add(info);
			this.obj.put("mem", mms);
			// 活动评价
			en = new EntityImpl(this);
			x = en.executeQuery("select * from f_active_words where act_id = ?", new Object[] { active_id },
					(page - 1) * pageSize + 1, page * pageSize);

			List<Map<String, Object>> list = en.getValues();

			if (list != null && list.size() > 0) {
				Map<String, List<String>> map = new HashMap<>();
				for (int i = 0; i < list.size(); i++) {
					String mem_id = list.get(i).get("fk_user_id") + "";
					String mem_gym = list.get(i).get("fk_user_gym") + "";
					List<String> l = map.get(mem_gym);
					if (l == null) {
						l = new ArrayList<String>();
					}
					l.add(mem_id);
					map.put(mem_gym, l);
				}

				StringBuilder sb = new StringBuilder();
				List<String> params = new ArrayList<>();

				int xx = 0;
				for (String key : map.keySet()) {
					sb.append("select a.id,a.mem_name,b.nickname,b.headurl from f_mem_").append(key)
							.append(" a left join f_wx_cust_" + cust_name
									+ " b on a.wx_open_id = b.wx_open_id where a.id in(")
							.append(Utils.getListString("?", map.get(key).size())).append(")");
					if (xx != map.keySet().size() - 1) {
						sb.append("  union all  ");
					}
					params.addAll(map.get(key));
					xx++;
				}
				en.executeQuery(sb.toString(), params.toArray());

				List<Map<String, Object>> values = en.getValues();
				for (int i = 0; i < list.size(); i++) {
					String mem_id = list.get(i).get("fk_user_id") + "";
					for (int j = 0; j < values.size(); j++) {
						String mem_id__ = values.get(j).get("id") + "";
						if (mem_id.equals(mem_id__)) {
							list.get(i).put("mem_name", values.get(j).get("mem_name"));
							break;
						}
					}
				}
				this.obj.put("words", list);
			}

		} else {
			throw new Exception("没有您要找的活动");
		}
	}

	/**
	 * 活动买卡
	 */
	@Route(value = "/fit-app-active-buy-cards", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void buy_cards() throws Exception {
		String cust_name = request.getParameter("cust_name");
		String gym = request.getParameter("gym");
		String cards = request.getParameter("cards");
		String mem_id = request.getParameter("mem_id");
		String out_trade_no = request.getParameter("out_trade_no");

		String birthday = this.getParameter("birthday");
		String wxOpenId = this.getParameter("wxOpenId");
		String edit_id_card = this.getParameter("edit_id_card");
		String edit_mem_name = this.getParameter("edit_mem_name");
		String sex = this.getParameter("sex");

		// 活动买卡
		if (cards != null && !"".equals(cards)) {
			String cs[] = cards.split(",");
			Entity e = new EntityImpl(this);
			int x = e.executeQuery(
					"select a.ACT_PRICE,a.act_id,a.remark item_remark,b.* from f_active_item a , f_card b where a.prj_id = b.id and a.id in ("
							+ Utils.getListString("?", cs.length) + ")",
					cs);
			Date now = new Date();
			if (x > 0) {
				String act_id = e.getStringValue("act_id");
				// 参加记录
				Entity en = new EntityImpl("f_active_record", this);
				en.setTablename("f_active_record_" + cust_name);
				en.setValue("act_id", act_id);
				en.setValue("mem_id", mem_id);
				int s = en.search();
				if (s > 0) {
					throw new Exception("您已经参加过了,不能重复参加哒");
				}
				s = en.executeQuery("select count(*) num from f_active_record_" + cust_name + " where act_id = ?",
						new Object[] { act_id });
				if (s > 0) {
					int num = en.getIntegerValue("num");
					s = en.executeQuery("select num from f_active where id = ?", new Object[] { act_id });
					if (s > 0) {
						int total = en.getIntegerValue("num");
						if (total <= num) {
							throw new Exception("很抱歉,参与人数已满");
						}
					}
				}
				en.setValue("create_time", new Date());
				en.setValue("cust_name", cust_name);
				en.setValue("act_id", act_id);
				en.setValue("mem_id", mem_id);
				en.setValue("gym", gym);
				en.create();
				for (int i = 0; i < x; i++) {
					String fk_card_id = e.getStringValue("id", i);
					int days = 0;
					try {
						days = e.getIntegerValue("days", i);
					} catch (Exception e2) {
					}
					int times = e.getIntegerValue("times", i);
					String card_fee = e.getStringValue("act_price", i);
					String ca_amt  = e.getStringValue("ca_amt",i);
					// 批量买卡
					en = new EntityImpl("f_user_card", this);
					en.setTablename("f_user_card_" + gym);
					en.setValue("cust_name", cust_name);
					en.setValue("gym", gym);
					en.setValue("card_id", fk_card_id);
					en.setValue("mem_id", mem_id);
					en.setValue("emp_id", "-1");
					en.setValue("buy_time", now);
					en.setValue("active_type", "001");
					en.setValue("active_time", now);
					en.setValue("pay_time", Utils.parseData(now, "yyyy-MM-dd HH:mm:ss"));
					en.setValue("indent_no", System.currentTimeMillis());

					Calendar c = Calendar.getInstance();
					c.setTime(new Date());
					c.add(Calendar.DAY_OF_YEAR, days);

					en.setValue("deadline", c.getTime());
					en.setValue("real_amt", card_fee);
					en.setValue("ca_amt", ca_amt);
					en.setValue("remark", "");
					en.setValue("source", "");
					en.setValue("state", "001");
					en.setValue("out_trade_no", out_trade_no);
					en.setValue("create_time", now);
					en.setValue("remain_times", times);
					en.setValue("buy_times", times);
					en.create();
				}
				// 激活会员
				MemInfo mem = MemUtils.getMemInfo(mem_id, cust_name);
				if (!"005".equals(mem.getState()) && !"006".equals(mem.getState()) && !"001".equals(mem.getState())) {
					// 不是请假 挂失 激活 就激活
					mem.setState("001");
					mem.update(getConnection(), false);
				}
				// 查询买卡会员是否是该会所会员推荐过来的，如果是，则推荐人积分加上
				en = new EntityImpl(this);
				int size = en.executeQuery("select * from f_mem_" + cust_name + " where id=? and state in('003','004')",
						new String[] { mem_id });
				if (size > 0) {
					String refer_mem_id = en.getStringValue("refer_mem_id");
					if (!"".equals(refer_mem_id) && refer_mem_id != null) {
						// 获取会所的积分设置
						int recommend_points = Integer.parseInt(SysSet.getValues(cust_name, gym, "set_points",
								"recommend_points", this.getConnection()));
						en.executeUpdate("update f_mem_" + cust_name + " set total_cent=total_cent+" + recommend_points
								+ " where id=?", new String[] { refer_mem_id });
					}
				}
				// 修改会员信息
				Entity entity = new EntityImpl("f_mem", this);
				entity.setTablename("f_mem_" + cust_name);
				entity.setValue("id", mem_id);
				entity.setValue("birthday", birthday);
				entity.setValue("id_card", edit_id_card);
				entity.setValue("mem_name", edit_mem_name);
				entity.setValue("sex", sex);
				entity.update();
				// 同时修改微信性别
				Entity en2 = new EntityImpl(this);
				en2.executeUpdate("update f_wx_cust_" + cust_name + " set sex=? where wx_open_id=?",
						new String[] { sex, wxOpenId });
				// 修改后更新修改时间
				Entity updateTime = new EntityImpl("f_mem", this);
				int size2 = updateTime.executeQuery("select * from f_mem_" + cust_name + " where id=?",
						new String[] { mem_id });
				if (size2 > 0) {
					String update_time = updateTime.getStringValue("update_time");
					boolean flag = ("".equals(update_time) || update_time == null) ? true : false;
					if (flag) {
						updateTime.setTablename("f_mem_" + cust_name);
						updateTime.setValue("id", mem_id);
						updateTime.setValue("update_time", new Date());
						updateTime.update();
					}
				}
			} else {
				throw new Exception("没有参加活动");
			}
		} else {
			// 只是报名某个活动
			throw new Exception("没有参加活动");
		}

	}

	@Route(value = "/fit-app-active-joinActive", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void joinActive() throws Exception {
		String act_id = this.getParameter("act_id");
		String mem_id = this.getParameter("mem_id");
		String cust_name = this.getParameter("cust_name");
		String gym = this.getParameter("gym");

		String birthday = this.getParameter("birthday");
		String wxOpenId = this.getParameter("wxOpenId");
		String edit_id_card = this.getParameter("edit_id_card");
		String edit_mem_name = this.getParameter("edit_mem_name");
		String sex = this.getParameter("sex");

		Entity en = new EntityImpl("f_active_record", this);
		en.setTablename("f_active_record_" + cust_name);
		en.setValue("act_id", act_id);
		en.setValue("mem_id", mem_id);

		MemInfo mem = MemUtils.getMemInfo(mem_id, cust_name);
		if (!"001".equals(mem.getState())) {
			if ("005".equals(mem.getState()) || "006".equals(mem.getState())) {
				String state = "请假";
				if ("006".equals(mem.getState())) {
					state = "挂失";
				}
				throw new Exception("您的会员状态处于" + state + "中,暂时无法参加");
			} else {
				throw new Exception("很抱歉,此活动仅限会员参加.");
			}
		}

		int s = en.search();
		if (s > 0) {
			throw new Exception("您已经参加过了,不能重复参加哒");
		}
		s = en.executeQuery("select count(*) num from f_active_record_" + cust_name + " where act_id = ?",
				new Object[] { act_id });
		if (s > 0) {
			int num = en.getIntegerValue("num");
			s = en.executeQuery("select num from f_active where id = ?", new Object[] { act_id });
			if (s > 0) {
				int total = en.getIntegerValue("num");
				if (total <= num) {
					throw new Exception("很抱歉,参与人数已满");
				}
			}
		}

		en.setValue("create_time", new Date());
		en.setValue("cust_name", cust_name);
		en.setValue("act_id", act_id);
		en.setValue("mem_id", mem_id);
		en.setValue("gym", gym);
		en.create();

		// 修改会员信息
		Entity entity = new EntityImpl("f_mem", this);
		entity.setTablename("f_mem_" + cust_name);
		entity.setValue("id", mem_id);
		entity.setValue("birthday", birthday);
		entity.setValue("id_card", edit_id_card);
		entity.setValue("mem_name", edit_mem_name);
		entity.setValue("sex", sex);
		entity.update();
		// 同时修改微信性别
		Entity en2 = new EntityImpl(this);
		en2.executeUpdate("update f_wx_cust_" + cust_name + " set sex=? where wx_open_id=?",
				new String[] { sex, wxOpenId });
		// 修改后更新修改时间
		Entity updateTime = new EntityImpl("f_mem", this);
		int size2 = updateTime.executeQuery("select * from f_mem_" + cust_name + " where id=?",
				new String[] { mem_id });
		if (size2 > 0) {
			String update_time = updateTime.getStringValue("update_time");
			boolean flag = ("".equals(update_time) || update_time == null) ? true : false;
			if (flag) {
				updateTime.setTablename("f_mem_" + cust_name);
				updateTime.setValue("id", mem_id);
				updateTime.setValue("update_time", new Date());
				updateTime.update();
			}
		}
	}

}
