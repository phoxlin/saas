package com.mingsokj.fitapp.ws.bg.cashier;

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
import com.mingsokj.fitapp.m.FitUser;
import com.mingsokj.fitapp.m.Gym;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.utils.MemUtils;

/**
 * @author liul 2017年8月15日上午10:19:45
 */
public class 推荐会员查询 extends BasicAction {

	@Route(value = "/fit-cashier-search_recommend", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void search_recommend() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();// 当前收银员
		String fk_user_id = this.getParameter("fk_user_id");
		String type = this.getParameter("type");// 用于app上推荐会员查询
		String gym = "";
		String cust_name = "";
		if ("app".equals(type)) {
			gym = this.getParameter("gym");
			cust_name = this.getParameter("cust_name");
		} else {
			gym = user.getViewGym();
			cust_name = user.getCust_name();
		}

		String phone = this.getParameter("phone");
		Entity en = new EntityImpl("f_mem", this);
		en.setTablename("f_mem_" + cust_name);
		int size = 0;

		if (!"".equals(fk_user_id) && fk_user_id != null) {
			size = en.executeQuery("select * from f_mem_" + cust_name + " where id=?", new String[] { fk_user_id });
		} else {

			size = en.executeQuery("select * from f_mem_" + cust_name + " where phone=? and state in('003','004')",
					new String[] { phone });
		}
		List<Map<String, Object>> list = new ArrayList<>();
		if (size > 0) {
			list = en.getValues();
			for (Map<String, Object> map : list) {
				String mc_id = map.get("mc_id") + "";
				
				String id = map.get("id") + "";
				String pt_names = map.get("pt_names") + "";
				String refer_mem_id = map.get("refer_mem_id") + "";

				map.put("mc_name", "");
				if (!Utils.isNull(mc_id)) {
					map.remove(mc_id);//先移除 如果员工会所可见再加入
					MemInfo mc = MemUtils.getMemInfo(mc_id, cust_name);
					//查询会员已经有的会籍 的可见门店是否有现在看这个店
					for(Gym g :mc.getCust().viewGyms){
						if(g.gym.equals(gym)){
							map.put("mc_name", mc.getName());
							map.put("mc_id", mc_id);
							break;
						}
					}
				} 

				if (!"".equals(id) && !"null".equals(id)) {
					map.put("mem_name", MemUtils.getMemInfo(id, cust_name).getName());
				} else {
					map.put("mem_name", "");
				}
				map.put("pt_name", "");
				if (!Utils.isNull(pt_names)) {
					map.remove(pt_names);//先移除 如果员工会所可见再加入
					MemInfo pt = MemUtils.getMemInfo(pt_names, cust_name);
					//查询会员已经有的教练 的可见门店是否有现在看这个店
					for(Gym g :pt.getCust().viewGyms){
						if(g.gym.equals(gym)){
							map.put("pt_name", pt.getName());
							map.put("pt_names", pt_names);
							break;
						}
					}
				} 
				if (!"".equals(refer_mem_id) && !"null".equals(refer_mem_id)) {

					map.put("refer_mem_phone", MemUtils.getMemInfo(refer_mem_id, cust_name).getPhone());
					map.put("refer_mem_name", MemUtils.getMemInfo(refer_mem_id, cust_name).getName());
					map.put("refer_mem_id", refer_mem_id);
				} else {
					map.put("refer_mem_phone", "");
				}
			}
		}
		this.obj.put("list", list);
	}
}
