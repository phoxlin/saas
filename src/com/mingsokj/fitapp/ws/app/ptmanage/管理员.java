package com.mingsokj.fitapp.ws.app.ptmanage;

import java.util.ArrayList;
import java.util.List;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.Utils;

/**
 * @author liul 2017年8月8日上午11:09:51
 */
public class 管理员 extends BasicAction {

	/**
	 * 判断是哪个角色的管理员
	 * 
	 * @Title: isManage
	 * @author: liul
	 * @date: 2017年8月8日上午11:11:44
	 * @throws Exception
	 */
	@Route(value = "/fit-ws-app-ptmanange-isManage", conn = true,  m = HttpMethod.POST, type = ContentType.JSON)
	public void isManage() throws Exception {
		String id = request.getParameter("id");
		String gym = request.getParameter("gym");
		String cust_name = request.getParameter("cust_name");
		Entity en = new EntityImpl("f_m_emp", this);
		en.setValue("p_emp_id", id);
		en.setValue("gym", gym);
		en.setValue("type", "PT");
		int size = en.search();
		if (size > 0) {
			String type = en.getStringValue("type");
			this.obj.put("type", type);
		} else {
			size = en.executeQuery("select ex_pt from f_emp where id = ?",new Object[]{id});
			if(size == 0 || !"Y".equals(en.getStringValue("ex_pt"))){
				throw new Exception("您不是教练管理员");
			}
		}

		// 今日售课(售课节数)
		List<String> ids = new ArrayList<String>();
		for (int i = 0; i < size; i++) {
			if ("PT".equals(en.getStringValue("type"))) {
				ids.add(en.getStringValue("emp_id", i));
			}
		}
		ids.add(id);// 算上自己

		en.executeQuery("select sum(cast(b.times as UNSIGNED INTEGER)) times from f_user_card_" + gym
				+ " a,f_card b where a.card_id = b.id and TO_DAYS(a.pay_time) = TO_DAYS(now()) and b.card_type='006' and a.pt_id in ("
				+ Utils.getListString("?", ids.size()) + ")", ids.toArray());
		this.obj.put("privateClassSalseTimes", en.getStringValue("times"));

		// 今日入场
		int checkinNums = en.executeQuery(
				"SELECT a.CHECKIN_TIME,a.CHECKOUT_TIME,b.* FROM f_checkin_" + gym + " a,f_mem_" + cust_name
						+ " b WHERE a.MEM_ID=b.ID AND TO_DAYS(CHECKIN_TIME)=TO_DAYS(NOW()) AND a.GYM=?",
				new String[] { gym });
		this.obj.put("checkinNums", checkinNums);
		// 今日维护

		size = en.executeQuery("select id from  f_mem_maintain_" + gym
				+ " where TO_DAYS(op_time) = TO_DAYS(now()) and (type='pt' or type='qpt' ) and op_id in ("
				+ Utils.getListString("?", ids.size()) + ")", ids.toArray());
		this.obj.put("wh", size);

	}
}
