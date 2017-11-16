package com.mingsokj.fitapp.ws.bg.cashier;

import org.json.JSONArray;
import org.json.JSONObject;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.mingsokj.fitapp.m.FitUser;
import com.mingsokj.fitapp.ws.bg.set.SysSet;

/**
* @author liul
* 2017年9月11日下午6:24:38
*/
public class 小票打印设置 extends BasicAction {
	
	/**
	 * 设置打印小票
	 * @Title: setPrint
	 * @author: liul
	 * @date: 2017年9月11日下午6:44:08
	 * @throws Exception
	 */
	@Route(value = "/fit-ws-bg-cashier-setPrint", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void setPrint() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String cust_name = user.getCust_name();
		String print = this.getParameter("print");
		String printContract = this.getParameter("printContract");
		String autoCheckIn = this.getParameter("autoCheckIn");
		
		Entity en = new EntityImpl("f_param",this);
		en.setValue("gym", gym);
		en.setValue("cust_name", cust_name);
		en.setValue("code", "set_xiao_print");
		int size =en.search();
		JSONObject obj = new JSONObject();
		JSONArray array = new JSONArray();
		obj.put("set_print_key", print);
		obj.put("printContract", printContract);
		obj.put("autoCheckIn", autoCheckIn);
		obj.put("gym", gym);
		array.put(obj);
		en.setValue("note", array);
		//是否已经设置打印参数
		if (size > 0) {
			en.update();
		}else{
			en.create();
		}
	}
	/**
	 * 获取小票打印设置
	 * @Title: getPrint
	 * @author: liul
	 * @date: 2017年9月11日下午6:44:29
	 * @throws Exception
	 */
	@Route(value = "/fit-ws-bg-cashier-getPrint", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void getPrint() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String cust_name = user.getCust_name();
		Entity en = new EntityImpl("f_param",this);
		en.setValue("gym", gym);
		en.setValue("cust_name", cust_name);
		en.setValue("code", "set_xiao_print");
		int size =en.search();
		if (size > 0) {
			String print = SysSet.getValues(cust_name, gym, "set_xiao_print", "set_print_key", this.getConnection());
			String printContract = SysSet.getValues(cust_name, gym, "set_xiao_print", "printContract", this.getConnection());
			String autoCheckIn = SysSet.getValues(cust_name, gym, "set_xiao_print", "autoCheckIn", this.getConnection());
			this.obj.put("print", print);
			this.obj.put("printContract", printContract);
			this.obj.put("autoCheckIn", autoCheckIn);
		}
		
	}
}
