package com.mingsokj.fitapp.ws.bg.mem;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.SystemUtils;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.m.FitUser;

public class 指纹 extends BasicAction {
	@Route(value = "/fit-cashier-mem-add-finger", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void addFinger() throws Exception {
		FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
		String cust_name = user.getCust_name();
//		String gym = user.getViewGym();

		String mem_id = this.getParameter("mem_id");
		if (Utils.isNull(mem_id)) {
			throw new Exception("没有找到您要操作的会员");
		}
		String fingerData = this.getParameter("fingerData");
		String finger = this.getParameter("finger");

		Entity en = new EntityImpl("f_mem", this);
		en.executeUpdate("update f_mem_" + cust_name + " set " + finger + " = ? where id = ?", new Object[] { fingerData, mem_id });
	}
	@Route(value = "/fit-cashier-mem-query-finger", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void queryFinger() throws Exception {
		FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
		String cust_name = user.getCust_name();
//		String gym = user.getViewGym();
		
		String mem_id = this.getParameter("mem_id");
		if (Utils.isNull(mem_id)) {
			throw new Exception("没有找到您要操作的会员");
		}
		Entity en = new EntityImpl("f_mem", this);
		int s = en.executeQuery("select finger1,finger2 from f_mem_"+cust_name+" where id = ?", new Object[]{mem_id});
		if(s >0){
			this.obj.put("fingerData1", en.getStringValue("finger1"));
			this.obj.put("fingerData2", en.getStringValue("finger2"));
		}else{
			throw new Exception("没有找到您要操作的会员");
		}
		
	}
}
