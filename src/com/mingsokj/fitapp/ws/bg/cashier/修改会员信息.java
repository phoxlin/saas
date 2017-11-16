package com.mingsokj.fitapp.ws.bg.cashier;

import java.util.Date;
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

public class 修改会员信息 extends BasicAction {

	@Route(value = "/fit-mem-update", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void setPrint() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String id = this.getParameter("id");
		String mem_name = this.getParameter("mem_name");
		String mem_phone = this.getParameter("mem_phone");
		String mem_sex = this.getParameter("mem_sex");
		String birthday = this.getParameter("birthday");
		String pt_id = this.getParameter("pt_id");
		String mc_id = this.getParameter("mc_id");
		String remain_amt = this.getParameter("remain_amt");
		String cust_name = user.getCust_name();

		long ra = 0;
		try {
			ra = (long) Float.parseFloat(remain_amt) * 100;
		} catch (Exception e) {
			// TODO: handle exception
		}
		/**
		 * 修改之前的用户信息
		 */
		Map<String, Object> old_msg = null;
		Map<String, Object> new_msg = null;
		Entity en = new EntityImpl(this);
		int size = en.executeQuery("select * from f_mem_" + cust_name + " where id=?", new Object[] { id });
		if (size > 0) {
			old_msg = en.getValues().get(0);
		}

		MemInfo.updateRemainAmtByCustname(ra, id, cust_name, this.getConnection());
		MemInfo info = new MemInfo();
		info.setCust_name(user.getCust_name());
		info.setId(id);
		info.setBirthday(birthday);
		info.setPhone(mem_phone);
		info.setSex(mem_sex);
		info.setMem_name(mem_name);
		info.setMc_id(mc_id);
		info.setPt_names(pt_id);
		info.update(this.getConnection(), false);

		/**
		 * 修改之后的信息
		 */
		en = new EntityImpl(this);
		size = en.executeQuery("select * from f_mem_" + cust_name + " where id=?", new Object[] { id });
		if (size > 0) {
			new_msg = en.getValues().get(0);
		}

		en = new EntityImpl("f_update", this);
		en.setTablename("f_update_" + cust_name);
		en.setValue("fk_user_id", id);
		en.setValue("old_msg", old_msg);
		en.setValue("new_msg", new_msg);
		en.setValue("create_time", Utils.parseData(new Date(), "yyyy-MM-dd HH:mm:ss"));
		en.setValue("fk_create_id", user.getId());
		en.setValue("type", "会员信息修改");
		en.create();

	}

	@Route(value = "/fit-mem-getUserCardDetial", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void getUserCardDetial() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String fk_user_id = this.getParameter("fk_user_id");
		String fk_user_gym = this.getParameter("fk_user_gym");
		String fk_card_id = this.getParameter("fk_card_id");

		Map<String, Object> c = MemUtils.getMemCardsById(fk_card_id, fk_user_id, user.getCust_name(), fk_user_gym);
		this.obj.put("card", c);

	}

	@Route(value = "/fit-mem-updateCard", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void updateCard() throws Exception {

		FitUser user = (FitUser) this.getSessionUser();

		String real_amt = this.getParameter("real_amt");
		String create_time = this.getParameter("create_time");
		String deadline = this.getParameter("deadLine");
		String remain_times = this.getParameter("times");
		String mc_id = this.getParameter("sales_id");
		String pt_id = this.getParameter("coach_id");
		String remark = this.getParameter("remark");
		String fk_user_gym = this.getParameter("fk_user_gym");
		String fk_card_id = this.getParameter("fk_card_id");
		String fk_user_id = this.getParameter("fk_user_id");
		String cust_name = user.getCust_name();

		long ra = 0;
		try {
			ra = Long.parseLong(real_amt);
		} catch (Exception e) {
		}

		int rt = 0;
		try {
			rt = Integer.parseInt(remain_times);
		} catch (Exception e) {
		}

		Map<String, Object> c = MemUtils.getMemCardsById(fk_card_id, fk_user_id, cust_name, fk_user_gym);
		if (!Utils.isNull(c)) {
			String now_gym = c.get("now_gym") + "";

			Map<String, Object> old_msg = null;
			Map<String, Object> new_msg = null;
			Entity en = new EntityImpl(this);
			int size = en.executeQuery("select * from f_user_card_" + now_gym + " where id=?",
					new Object[] { fk_card_id });
			if (size > 0) {
				old_msg = en.getValues().get(0);
			}

			en = new EntityImpl(this);
			en.executeUpdate(
					"update f_user_card_" + now_gym
							+ " set real_amt=?,create_time=?,deadline=?,remain_times=?,mc_id=?,pt_id=?,remark=?  where id=?",
					new Object[] { ra * 100, create_time, deadline, rt, mc_id, pt_id, remark, fk_card_id });

			en = new EntityImpl(this);
			size = en.executeQuery("select * from f_user_card_" + now_gym + " where id=?", new Object[] { fk_card_id });
			if (size > 0) {
				new_msg = en.getValues().get(0);
			}
			en = new EntityImpl("f_update", this);
			en.setTablename("f_update_" + cust_name);
			en.setValue("fk_user_id", fk_user_id);
			en.setValue("old_msg", old_msg);
			en.setValue("new_msg", new_msg);
			en.setValue("create_time", Utils.parseData(new Date(), "yyyy-MM-dd HH:mm:ss"));
			en.setValue("fk_create_id", user.getId());
			en.setValue("type", "会员卡信息修改");
			en.create();

		}

	}

}
