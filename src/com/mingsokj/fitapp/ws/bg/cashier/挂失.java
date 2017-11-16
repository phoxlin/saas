package com.mingsokj.fitapp.ws.bg.cashier;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.mingsokj.fitapp.m.FitUser;
import com.mingsokj.fitapp.m.MemInfo;

public class 挂失 extends BasicAction {

	/**
	 * 挂失
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-cashier-reportedLoss", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void reportedLoss() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String nowGym = user.getViewGym();
		String cust_name = user.getCust_name();
		String fk_user_id = this.getParameter("fk_user_id");
		String fk_user_gym = this.getParameter("fk_user_gym");

		Entity en = new EntityImpl(this);
		int size = en.executeQuery("select mem_no,state from f_mem_" + cust_name + " where id=?", new Object[] { fk_user_id });
		if (size > 0) {
			String state = en.getStringValue("state");
			String mem_no = en.getStringValue("mem_no");
			if (!"001".equals(state)) {
				throw new Exception("用户未激活，暂不能挂失");
			}
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			// en.executeUpdate("update f_mem_" + cust_name + " set
			// state='006',mem_no='' where id=?", new Object[] { fk_user_id });
			MemInfo memInfo = new MemInfo();
			memInfo.setId(fk_user_id);
			memInfo.setGym(fk_user_gym);
			memInfo.setState("006");
			memInfo.update(this.getConnection(), false);

			en = new EntityImpl("f_flow", this);
			en.setTablename("f_flow_" + nowGym);
			en.setValue("flow_type", "挂失");
			en.setValue("mem_id", fk_user_id);
			en.setValue("mem_gym", fk_user_gym);
			en.setValue("content", "挂失了会员卡【" + mem_no + "】");
			en.setValue("op_id", user.getId());
			en.setValue("op_name", user.getMemInfo() != null ? user.getMemInfo().getName() : "管理员");
			en.setValue("op_time", sdf.format(new Date()));
			en.create();

			en = new EntityImpl(this);
			// cust_name
			String sql = "";
			ArrayList<String> parList = new ArrayList<String>();
			size = en.executeQuery("select gym from f_gym where cust_name=?", new Object[] { cust_name });
			for (int i = 0; i < size; i++) {
				sql += "select id,gym from f_user_card_" + en.getStringValue("gym", i) + " where state='001' and mem_id=?";
				if (size - 1 != i) {
					sql += " union ";
				}
				parList.add(fk_user_id);
			}

			size = en.executeQuery(sql, parList.toArray());
			if (size > 0) {
				for (int i = 0; i < size; i++) {
					Entity e = new EntityImpl(this);
					e.executeUpdate("update f_user_card_" + en.getStringValue("gym", i) + " set state='006' where id=?", new Object[] { en.getStringValue("id", i) });
				}
			}

		} else {
			throw new Exception("查询用户失败，请刷新页面后重试");
		}
	}

}
