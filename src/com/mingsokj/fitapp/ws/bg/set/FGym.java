package com.mingsokj.fitapp.ws.bg.set;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.Utils;

/**
 * 
 * @author liul 2017年7月6日下午2:10:25
 */
public class FGym extends BasicAction {

	private Map<String, Boolean> custTables = new HashMap<>();
	private Map<String, Boolean> gymTables = new HashMap<>();
	public static String[] cust_tablenames = new String[] { "f_update", "f_wx_cust"/* wx用户 */, "f_fit_plan"/* 健身计划 */ , "f_mem"/* 会员 */ , "f_active_record"/* 活动参与记录 */ };
	public static String[] gym_tablenames = new String[] { "f_body_data", "f_msg_send", "f_flow", "f_class_record"/* 团课上课记录 */, "f_checkin"/* 出入场记录 */, "f_fit_plan_detail"/* 健身计划详细 */, "f_mem_maintain"/* 会员维护 */, "f_mem_recommend"/* 会员推荐 */, "f_order"/* 团课预约 */, "f_other_pay" /* 各种其他支付 */, "f_pre_fee"/* 付定金 */, "f_private_record"/* 私课消课记录 */, "f_rent"/* 租柜 */, "f_sign_month"/* 打卡记录 */, "f_store_rec"/* 商品出入库 */, "f_user_card"/* 会员卡 */, "f_private_order"/* 预约私教 */ };

	// 添加客户
	@Route(value = "/f_gym_add_cust", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void f_gym_add_cust() throws Exception {
		String e = request.getParameter("e");
		Entity en = this.getEntityFromPage(e);
		String gym_name = request.getParameter("f_gym__gym_name");
		String gym = request.getParameter("f_gym__gym");
		if (gym.length() > 4) {
			throw new Exception("门店代码不能超过4个字符");
		}

		// 随即获取gym
		// 查询gym是否重复
		Entity entity = new EntityImpl(this);
		int size = entity.executeQuery("select gym,bar_code from f_gym where gym=?", new String[] { gym });
		if (size > 0) {
			throw new Exception("门店代码重复了");
		}
		size = entity.executeQuery("select gym_name from f_gym where gym_name=?", new String[] { gym_name });
		if (size > 0) {
			throw new Exception("门店名称重复了");
		}

		en.setValue("gym", gym);
		en.setValue("cust_name", gym);
		en.setValue("GYM_NAME", gym_name);
		en.setValue("create_time", new Date());
		en.setValue("renew_time", new Date());
		String gymId = en.create();

		// 客户管理账号
		String login_name = request.getParameter("f_gym__login_name");
		String pwd = request.getParameter("f_gym__pwd");
		if (Utils.isNull(login_name) || Utils.isNull(pwd)) {
			throw new Exception("账号或密码为空");
		}
		en = new EntityImpl("f_emp", this);
		int s = en.executeQuery("select id from f_emp where login_name = ?", new Object[] { login_name }, 1, 1);
		if (s > 0) {
			throw new Exception("该账号已存在.");
		}
		en.setValue("id", gymId);
		en.setValue("cust_name", gym);
		en.setValue("gym", gym);
		en.setValue("login_name", login_name);
		en.setValue("pwd", Utils.getMd5(pwd));
		en.setValue("state", "sm");
		en.setValue("sm", "Y");
		en.create();
		// 可见会所
		en = new EntityImpl("f_emp_gym", this);
		en.setValue("cust_name", gym);
		en.setValue("gym", gym);
		en.setValue("view_gym", gym);
		en.setValue("cust_name", gym);
		en.setValue("fk_emp_id", gymId);
		en.create();
		/**
		 * 检查对应的客户和门店的表是否存在，如果不存在 就马上建 1.先把 cust_name分表的，处理了
		 * 
		 */
		for (int i = 0; i < cust_tablenames.length; i++) {
			String ct = cust_tablenames[i];
			Boolean ok = custTables.get(ct + "_" + gym);
			if (ok == null || !ok) {
				try {
					Entity en1 = new EntityImpl(this);
					en1.executeQuery("select count(1) num from " + ct + "_" + gym);
					custTables.put(ct + "_" + gym, true);
				} catch (Exception e1) {
					// 报错说明没有表，马上建
					Entity en1 = new EntityImpl(ct, this);
					en1.setTablename(ct + "_" + gym);
					en1.DDL(false);
					custTables.put(ct + "_" + gym, true);
				}
			}
		}
		for (int i = 0; i < gym_tablenames.length; i++) {
			String ct = gym_tablenames[i];
			Boolean ok = gymTables.get(ct + "_" + gym);
			if (ok == null || !ok) {
				try {
					Entity en1 = new EntityImpl(this);
					en1.executeQuery("select count(1) num from " + ct + "_" + gym);
					gymTables.put(ct + "_" + gym, true);
				} catch (Exception e1) {
					// 报错说明没有表，马上建
					Entity en1 = new EntityImpl(ct, this);
					en1.setTablename(ct + "_" + gym);
					en1.DDL(false);
					gymTables.put(ct + "_" + gym, true);
				}
			}
		}
	}

	// 添加门店
	@Route(value = "/f_gym_add_gym", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void f_gym_add_gym() throws Exception {
		String e = request.getParameter("e");
		Entity en = this.getEntityFromPage(e);
		String gym_name = en.getStringValue("gym_name");
		// String cust_name = user.getCust_name();
		// 前台选择会所再添加门店
		String cust_name = this.getParameter("cust_name");
		if ("".equals(cust_name) || cust_name == null) {
			throw new Exception("未查询到cust_name,请重新登录门店");
		}
		int size = en.executeQuery("select b.gym from f_gym b where b.cust_name =?", new String[] { cust_name });
		int index = 1;
		if (size > 0) {
			for (int i = 0; i < size; i++) {
				String gym1 = en.getStringValue("gym", i);
				if (gym1.length() >= 3) {
					String tail = gym1.substring(gym1.length() - 3);
					try {
						int tailIndex = 0;
						try {
							tailIndex = Integer.parseInt(tail);
						} catch (Exception e1) {
						}
						if (tailIndex >= index) {
							index = tailIndex + 1;
						}
					} catch (Exception e1) {
					}
				}
			}
		}
		String gymTail = Utils.leftPadding(index, 3, "0");
		String gym = cust_name + gymTail;
		// 查询cust_name是否重复
		en.setValue("gym_name", gym_name);
		en.setValue("cust_name", cust_name);
		en.setValue("gym", gym);
		en.setValue("create_time", new Date());
		en.setValue("renew_time", new Date());
		en.create();

		for (int i = 0; i < gym_tablenames.length; i++) {
			String ct = gym_tablenames[i];
			Boolean ok = gymTables.get(ct + "_" + gym);
			if (ok == null || !ok) {
				try {
					Entity en1 = new EntityImpl(this);
					en1.executeQuery("select count(1) num from " + ct + "_" + gym);
					gymTables.put(ct + "_" + gym, true);
				} catch (Exception e1) {
					// 报错说明没有表，马上建
					Entity en1 = new EntityImpl(ct, this);
					en1.setTablename(ct + "_" + gym);
					en1.DDL(false);
					gymTables.put(ct + "_" + gym, true);
				}
			}
		}
	}

	// 修改
	@Route(value = "/f_gym_update", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void f_gym_update() throws Exception {
		// 拿到当前客户的gym
		String e = request.getParameter("e");
		Entity en = this.getEntityFromPage(e);
		String id = en.getStringValue("id");
		en.update();
		String addType = request.getParameter("addType");
		// 修改账号密码
		if ("cust_name".equals(addType)) {
			String login_name = request.getParameter("f_gym__login_name");
			String pwd = request.getParameter("f_gym__pwd");
			if (Utils.isNull(login_name) || Utils.isNull(pwd)) {
				throw new Exception("账号或密码为空");
			}
			Entity entity = new EntityImpl("f_emp", this);
			int s = entity.executeQuery("select id from f_emp where login_name = ?", new Object[] { login_name });
			if (s > 0) {
				if (!id.equals(entity.getStringValue("id"))) {
					throw new Exception("该账号已存在.");
				}
			}
			s = entity.executeQuery("select * from f_emp where id = ?", new Object[] { id });
			if (s > 0) {
				String oldPwd = entity.getStringValue("pwd");
				if (!Utils.getMd5(pwd).equals(oldPwd)) {
					entity.setValue("pwd", Utils.getMd5(pwd));
				}
				entity.setValue("id", id);
				entity.setValue("login_name", login_name);
				entity.setValue("state", "sm");
				entity.setValue("sm", "Y");
				entity.update();
			}
		}

	}
}
