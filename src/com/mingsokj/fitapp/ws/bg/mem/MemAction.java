package com.mingsokj.fitapp.ws.bg.mem;

import java.util.Date;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.RedisUtils;
import com.jinhua.server.tools.SystemUtils;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.m.FitUser;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.utils.GymUtils;

import redis.clients.jedis.Jedis;

public class MemAction extends BasicAction {

	/**
	 * 散客登记-添加会员
	 * 
	 * @throws Exception
	 */
	@Route(value = "/mem-add-traveler", conn = true, type = ContentType.JSON, m = HttpMethod.POST)
	public void query_emp_role() throws Exception {

		FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
		String create_gym = this.getParameter("create_gym");
		if (user == null) {
			this.getRequest().getRequestDispatcher("/").forward(request, response);
		}
		
		boolean flag = false;
		String cust_name = user.getCust_name();
		String gym = user.getViewGym();
		
		//跨店转卡  在其他店创建会员
		if(!Utils.isNull(create_gym)){
			gym = create_gym;
		}
		
		Entity mem = this.getEntityFromPage("f_mem");
		MemInfo m = new MemInfo();
		
		Entity mem_recommend = new EntityImpl("f_mem_recommend", this);
		String mem_sex = this.getParameter("mem_sex");
		m.setSex(mem_sex);
		// 本店有无重复
		Entity en = new EntityImpl("f_mem", this);
		en.setTablename("f_mem_" + cust_name);
		String phone = mem.getStringValue("phone");
		int s = en.executeQuery("select * from f_mem_" + cust_name + " where phone = ?", new Object[] { phone });
		if (s > 0) {
			throw new Exception("手机"+phone+ "已经是"+GymUtils.getGymName(gym)+"的会员了");
		}

		// 推荐人查询
		String mem_id = request.getParameter("mem_id");
		
		if (!"".equals(mem_id) && mem_id != null) {
			flag = true;
			mem_recommend.setTablename("f_mem_recommend_" + gym);
			mem_recommend.setValue("recommend_mem_id", mem_id);
			m.setRefer_mem_id(mem_id);
		}

		String mc = request.getParameter("f_mem__mc_id");
		String pt_name = request.getParameter("f_mem__pt_names");
		if (!Utils.isNull(pt_name)) {
			m.setPt_names(pt_name);
		}
		if (Utils.isNull(mc)) {
			// 公共池
			m.setState("004");
		} else {
			// 会籍跟踪
			m.setState("003");
			m.setMc_id(mc);
		}
		
		m.setPhone(phone);
		m.setGym(gym);
		m.setRemark(this.getParameter("f_mem__remark"));
		m.setMem_name(this.getParameter("f_mem__mem_name"));
		m.setCust_name(cust_name);
		m.setBirthday(this.getParameter("f_mem__birthday"));
		String newMemId = m.create(this.getConnection());
		m.setId(newMemId);
		this.obj.put("mem_id", newMemId);//拿到新建会员id传到前台
		Jedis jd = RedisUtils.getConnection();
		RedisUtils.setHParam("MEM_" + gym, newMemId, m, jd);
		RedisUtils.setHParam("MEM_CUST_NAME", newMemId, cust_name, jd);
		RedisUtils.freeConnection(jd);
		
		// 查看该潜客是否是会员推荐的
		if (flag) {
			// 查询被推荐会员的id
			en.setValue("phone", phone);
			int size = en.search();
			if (size > 0) {
				mem_recommend.setValue("be_recommend_mem_id", newMemId);
				mem_recommend.setValue("op_time", new Date());
				mem_recommend.setValue("state", "002");
				mem_recommend.create();
			}
		}
	}
}
