package com.mingsokj.fitapp.ws.app.sales;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.utils.MemUtils;

/**
 * @author liul 2017年8月9日下午4:19:40
 */
public class 今日售额 extends BasicAction {
	@Route(value = "/fit-app-action-todayGetMoney", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void todayGetMoney() throws Exception {
		String gym = this.getParameter("gym");
		String cust_name = this.getParameter("cust_name");
		String id = this.getParameter("id");
		List<Map<String, Object>> mem = new ArrayList<>();
		List<Map<String, Object>> list = new ArrayList<>();
		Entity en = new EntityImpl("f_m_emp", this);
		en.setValue("p_emp_id", id);
		en.setValue("gym", gym);
		en.setValue("type", "MC");
		int size = en.search();
		List<String> emps = new ArrayList<String>();
		if (size > 0) {
			mem = en.getValues();
			for (int i = 0; i < mem.size(); i++) {
				emps.add(en.getStringValue("emp_id",i));
			}
		}
		//算上自己
		emps.add(id);
		String sql = "SELECT a.pay_time,a.REAL_AMT,b.MEM_NAME,b.id,d.CARD_NAME FROM f_user_card_" + gym + " a,f_mem_" + cust_name + " b,f_emp c,f_card d WHERE a.mc_id=c.ID AND a.MEM_ID = b.ID AND a.mc_id in(" + Utils.getListString("?", emps.size()) + ") AND a.card_id=d.id AND TO_DAYS(a.pay_time)=TO_DAYS(NOW())";
		String getPriceSql = "SELECT sum(a.REAL_AMT) as allPrice,a.pay_time,a.REAL_AMT,b.MEM_NAME,d.CARD_NAME FROM f_user_card_"+gym+" a,f_mem_" + cust_name + " b,f_emp c,f_card d WHERE a.mc_id=c.ID AND a.MEM_ID = b.ID AND a.mc_id in(" + Utils.getListString("?", emps.size()) + ") AND a.card_id=d.id AND TO_DAYS(a.pay_time)=TO_DAYS(NOW())";
		en.executeQuery(sql, emps.toArray());
		list = en.getValues();
		// 查询销售额总价
		en.executeQuery(getPriceSql, emps.toArray());
		String allPrice = en.getStringValue("allPrice");
		this.obj.put("allPrice", allPrice);
		for(int i=0;i<list.size();i++){
			MemInfo memInfo = MemUtils.getMemInfo(Utils.getMapStringValue(list.get(i), "id"), cust_name);
			if(memInfo!=null){
				list.get(i).put("mem_name", memInfo.getName());
			}
		}
		this.obj.put("list", list);
		

	}
}
