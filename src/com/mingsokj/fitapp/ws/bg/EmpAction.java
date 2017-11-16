package com.mingsokj.fitapp.ws.bg;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.SystemUtils;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.m.FitUser;
import com.mingsokj.fitapp.m.Gym;
import com.mingsokj.fitapp.m.Mem;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.m.card.UserUtils;
import com.mingsokj.fitapp.utils.GymUtils;
import com.mingsokj.fitapp.utils.MemUtils;

/**
 * 员工操作类
 * 
 * @author yxz
 *
 */
public class EmpAction extends BasicAction {
	/**
	 * 查询会籍 教练 员工 团课
	 */
	@Route(value = "/fit-ws-bg-emp-searchEmpByType", slave = true, conn = true, type = ContentType.JSON, m = HttpMethod.POST)
	public void searchEmpByType() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String cust_name = user.getCust_name();
		String cur = request.getParameter("cur");
		String search = this.getParameter("search");
		if (cur == null || cur.length() <= 0) {
			cur = "1";
		}
		int pageSize = 30;
		int curPage = Integer.parseInt(cur);
		int start = (curPage - 1) * pageSize + 1;
		int end = pageSize * curPage;
		String type = this.getParameter("type");
		// String sql = "select a.id from f_emp a,f_mem_" + cust_name + "
		// b,f_emp_gym
		// c where a.id=b.id and c.view_gym=?";
		String sql = "select a.id from f_emp a,f_emp_gym b where a.id = b.fk_emp_id and b.cust_name = '" + cust_name + "' and b.view_gym = ?";

		if ("sales".equals(type)) {
			sql += " and a.mc='Y' ";
			if (!"".equals(search) && search != null) {
				// 关联会员
				sql = "select a.id from f_emp a,f_emp_gym b,f_mem_" + cust_name + " c where a.id = b.fk_emp_id and a.id = c.id and b.cust_name = '" + cust_name + "' and b.view_gym = ?";
				sql += " and a.mc='Y' ";
				sql += " and (c.mem_name like '" + search + "%' or c.phone like '" + search + "%')";
			}
		} else if ("coach".equals(type)) {
			sql += " and a.pt='Y' ";
			if (!"".equals(search) && search != null) {
				sql = "select a.id from f_emp a,f_emp_gym b,f_mem_" + cust_name + " c where a.id = b.fk_emp_id and a.id = c.id and b.cust_name = '" + cust_name + "' and b.view_gym = ?";
				sql += " and a.mc='Y' ";
				sql += " and (c.mem_name like '" + search + "%' or c.phone like '" + search + "%')";
			}
		} else if ("plan".equals(type)) {
			sql = "select id,plan_name as name from f_plan where gym=?";
			if (!"".equals(search) && search != null) {
				sql += " and plan_name like '%" + search + "%'";
			}
		} else if ("mem".equals(type)) {
			sql = "select id,mem_name as name from f_mem_" + user.getCust_name() + " where gym=? ";
		}

		Entity en = new EntityImpl(this);
		en.executeQueryWithMaxResult(sql, new Object[] { user.getViewGym() }, start, end);
		int total = en.getMaxResultCount();
		int totalpage = 0;
		int temp = total / pageSize;
		totalpage = total % pageSize > 0 ? temp + 1 : temp > 0 ? temp : 1;
		List<Map<String, Object>> list = new ArrayList<>();
		list = en.getValues();
		if ("sales".equals(type) || "coach".equals(type)) {
			for (Map<String, Object> map : list) {
				String emp_id = map.get("id") + "";
				if (!"".equals(emp_id) && !"null".equals(emp_id)) {
					map.put("name", MemUtils.getMemInfo(emp_id, cust_name).getName());
				}
			}
		}

		this.obj.put("emps", list);
		this.obj.put("total", total);
		this.obj.put("totalPage", totalpage);
		this.obj.put("curPage", curPage);
		this.obj.put("curSize", en.getValues().size());

	}

	@Route(value = "/fit-ws-bg-emp-searchMem", slave = true, conn = true, type = ContentType.JSON, m = HttpMethod.POST)
	public void searchMem() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String cust_name = user.getCust_name();
		String mem_name = this.getParameter("mem_name");
		String phone = this.getParameter("phone");
		String mem_no = this.getParameter("mem_no");
		Entity en = new EntityImpl(this);
		if ("".equals(mem_name) && "".equals(phone) && "".equals(mem_no)) {
			en.executeQuery("select id,mem_name as name from f_mem_" + cust_name + " where gym=? limit 0,20", new String[] { gym });
		}
		int size = en.executeQuery("select id,mem_name as name from f_mem_" + cust_name + " where mem_name like ? and phone like ? and mem_no like ?", new String[] { "%" + mem_name + "%", "%" + phone + "%", "%" + mem_no + "%" });
		if (size > 0) {
			this.obj.put("emps", en.getValues());
		}
	}

	/**
	 * 添加修改员工
	 * 
	 * @throws Exception
	 */
	@Route(value = "/emp-save", conn = true, type = ContentType.JSON, m = HttpMethod.POST)
	public void emp_save() throws Exception {
		FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
		if (user == null) {
			this.getRequest().getRequestDispatcher("/").forward(request, response);
		}
		String cust_name = user.getCust_name();
		String gym = user.getViewGym();

		Entity e = this.getEntityFromPage("f_emp");
		e.setValue("cust_name", cust_name);
		String g = e.getStringValue("gym");
		if (Utils.isNull(g)) {
			e.setValue("gym", gym);
		}

//		String pwd = Utils.getMd5(e.getStringValue("pwd"));
		String m = this.getParameter("m");
		String emp_id = "";

		Entity en = new EntityImpl("f_emp", this);
		String login_name = e.getStringValue("login_name");
		if ("add".equals(m)) {
			//创建会员
			String mem_name = this.getParameter("f_emp__mem_name");
			String sex = this.getParameter("f_emp__sex");
			String phone = this.getParameter("f_emp__phone");
			String idCard = this.getParameter("f_emp__idCard");
//			String state = this.getParameter("f_emp__state");
			int x = en.executeQuery("select id from f_mem_"+ cust_name+" where phone = ?",new Object[]{phone});
			if(x>0){
				throw new Exception("该手机号已经是会员了,请使用绑定会籍/教练功能");
			}
			MemInfo mem = new MemInfo();
			mem.setCust_name(cust_name);
			mem.setGym(gym);
			mem.setSex(sex);
			mem.setPhone(phone);
			mem.setIdCard(idCard);
			mem.setMem_name(mem_name);
			mem.setState("003");
			String id = mem.create(getConnection());
			//创建员工
			String role = this.getParameter("role");
			e.setValue(role, "Y");
			e.setValue("id", id);
			emp_id = e.create();
		} else {
			emp_id = e.getStringValue("id");
			int s = en.executeQuery("select * from f_emp where login_name = ?", new Object[] { login_name });
//			String oldPwd = "";
			if (s > 0) {
				String id = en.getStringValue("id");
				if (s > 1 || (s == 1 && !id.equals(emp_id))) {
					throw new Exception("登录名重复,请重新设置");
				}
			}

			/*
			 * oldPwd = en.getStringValue("pwd"); if (!Utils.isNull(oldPwd) &&
			 * oldPwd.equals(e.getStringValue("pwd"))) { // 密码没有变动 } else {
			 * e.setValue("pwd", pwd); }
			 */
			e.update();

		}
		// 权限
		String role = this.getParameter("role");
		String[] power = this.getParameterValues("power");
		if (role != null && !"".equals(role) && power != null && power.length > 0) {
			en = new EntityImpl(this);
			en.executeUpdate("delete from f_emp_auth where emp_id = ? and cust_name = ? and gym = ? and auth like '" + role + "%'", new Object[] { emp_id, cust_name, gym });
			for (int i = 0; i < power.length; i++) {
				en = new EntityImpl("f_emp_auth", this);
				en.setValue("cust_name", cust_name);
				en.setValue("gym", gym);
				en.setValue("emp_id", emp_id);
				en.setValue("auth", power[i]);
				en.create();
			}
		}
		// 可见会所
		String[] viewGym = this.getParameterValues("viewGym");
		if (viewGym != null && viewGym.length > 0) {
			en.executeUpdate("delete from f_emp_gym where fk_emp_id = ?", new Object[] { emp_id });
			for (int i = 0; i < viewGym.length; i++) {
				en = new EntityImpl("f_emp_gym", this);
				en.setValue("cust_name", cust_name);
				en.setValue("gym", gym);
				en.setValue("fk_emp_id", emp_id);
				en.setValue("view_gym", viewGym[i]);
				en.create();
			}
		}
		// 下属员工
		if ("all".equals(role) || "ex".equals(role)) {
			String[] subMcs = this.getParameterValues("subMc");
			String[] subPts = this.getParameterValues("subPt");
			if (subMcs != null && subMcs.length > 0) {
				en.executeUpdate("delete from f_m_emp where p_emp_id = ? and type = 'MC' and gym = ?", new Object[] { emp_id, gym });
				en = new EntityImpl("f_m_emp", this);
				for (int i = 0; i < subMcs.length; i++) {
					en.setValue("cust_name", cust_name);
					en.setValue("gym", gym);
					en.setValue("p_emp_id", emp_id);
					en.setValue("emp_id", subMcs[i]);
					en.setValue("type", "MC");
					en.create();
				}
			} else {
				en.executeUpdate("delete from f_m_emp where p_emp_id = ? and type = 'MC' and gym = ?", new Object[] { emp_id, gym });
			}
			if (subPts != null && subPts.length > 0) {
				en.executeUpdate("delete from f_m_emp where p_emp_id = ? and type = 'PT' and gym = ?", new Object[] { emp_id, gym });
				en = new EntityImpl("f_m_emp", this);
				for (int i = 0; i < subPts.length; i++) {
					en.setValue("cust_name", cust_name);
					en.setValue("gym", gym);
					en.setValue("p_emp_id", emp_id);
					en.setValue("emp_id", subPts[i]);
					en.setValue("type", "PT");
					en.create();
				}
			} else {
				en.executeUpdate("delete from f_m_emp where p_emp_id = ? and type = 'PT' and gym = ?", new Object[] { emp_id, gym });
			}
		}
		//刷新缓存
		MemUtils.getMemInfo(emp_id, cust_name, L, true, getConnection());
	}

	/**
	 * 查询所有会籍 教练</br>
	 * 
	 * @throws Exception
	 */
	@Route(value = "/emp-query-mc-and-pt", conn = true, type = ContentType.JSON, m = HttpMethod.POST)
	public void findAllMCandPT() throws Exception {
		String emp_id = this.getParameter("emp_id");
		FitUser user = (FitUser) this.getSessionUser();
		if (user == null) {
			this.getRequest().getRequestDispatcher("/").forward(request, response);
		}
		String cust_name = user.getCust_name();
		String gym = user.getViewGym();
		Entity en = new EntityImpl("f_emp", this);

		String type = request.getParameter("role");

		// 查询所有会籍 教练
		// String sql = "select a.*,b.mem_name name,c.p_emp_id,c.type from f_emp
		// a left join f_mem_" + cust_name + " b on a.id=b.id left join f_m_emp
		// c on
		// a.id = c.emp_id where a.cust_name = ? and a.ex_" + type + "='N' and
		// a.gym = ? and a.state='002' and a." + type + " = 'Y' group by a.id";
		String sql = "select a.*,b.p_emp_id,b.type from f_emp a left join f_m_emp b on a.id=b.p_emp_id and b.type=?  where a.cust_name = ? and a.gym = ? and a.state='002' and a." + type + " = 'Y' and a.ex_" + type + "='N'  and a.sm ='N' group by a.id ";
		// 关联可见会所

		// 主管 不能被管
		// sql = "select emp.*,b.p_emp_id, b.type from ( SELECT a.* FROM f_emp
		// a, f_emp_gym c WHERE a.id = c.fk_emp_id AND c.cust_name = ? AND
		// c.view_gym = ? AND a.state = '002' AND a." + type + " = 'Y' AND
		// a.ex_" + type + " = 'N' AND a.sm = 'N' GROUP BY a.id )emp left join
		// f_m_emp b ON emp.id = b.emp_id AND b.type =? and b.gym = ?";
		// 随便管
		sql = "select emp.*,b.p_emp_id, b.type from ( SELECT a.* FROM f_emp a, f_emp_gym c WHERE a.id = c.fk_emp_id AND c.cust_name = ? AND c.view_gym = ? AND a.state = '002' AND a." + type + " = 'Y' GROUP BY a.id )emp left join f_m_emp b ON emp.id = b.emp_id and b.p_emp_id = ? AND b.type =? and b.gym = ?";
		int s = en.executeQuery(sql, new Object[] { cust_name, gym, emp_id, type.toUpperCase(), gym });
		if (s > 0) {
			List<Map<String, Object>> emps = en.getValues();

			for (int i = 0; i < s; i++) {
				String eid = en.getStringValue("id", i);
				MemInfo emp = MemUtils.getMemInfo(eid, cust_name);
				if (emp != null) {
					emps.get(i).put("name", emp.getName());
				}
			}
			this.obj.put("emps", emps);
		}
		if (emp_id != null && !"".equals(emp_id)) {
			// 查询当前员工的下属
			en = new EntityImpl("f_m_emp", this);
			sql = "select * from f_m_emp where cust_name = ? and gym = ? and p_emp_id = ?";
			if (type != null && !"".equals(type)) {
				sql += " and type = '" + type + "'";
			}
			s = en.executeQuery(sql, new Object[] { cust_name, gym, emp_id });
			if (s > 0) {
				this.obj.put("subordinate", en.toJson());
			}
			JSONArray list = this.obj.getJSONArray("emps");
			for (int i = 0; i < list.length(); i++) {
				JSONObject emp = list.getJSONObject(i);
				if (emp_id.equals(emp.getString("id"))) {
					// 移除自身
					list.remove(i);
					break;
				}
			}
		}
	}

	/**
	 * 查询所有下属
	 * 
	 * @throws Exception
	 */
	@Route(value = "/emp-query-subordinate-by-emp_id", slave = true, conn = true, type = ContentType.JSON, m = HttpMethod.POST)
	public void findSubordinateByEmpId() throws Exception {
		// 主管ID
		String emp_id = this.getParameter("emp_id");
		FitUser user = (FitUser) this.getSessionUser();
		if (user == null) {
			this.getRequest().getRequestDispatcher("/").forward(request, response);
		}
		String cust_name = user.getCust_name();
		String gym = user.getViewGym();
		Entity en = new EntityImpl("f_emp", this);

		if (emp_id != null && !"".equals(emp_id)) {
			// 查询当前员工的下属
			en = new EntityImpl("f_m_emp", this);
			int s = en.executeQuery("select * from f_m_emp where cust_name = ? and gym = ? and p_emp_id = ?", new Object[] { cust_name, gym, emp_id });
			if (s > 0) {
				this.obj.put("subordinate", en.toJson());
			}
		}
	}

	@Route(value = "/emp-bind-sm", conn = true, type = ContentType.JSON, m = HttpMethod.POST)
	public void emp_bind_sm() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		if (!user.getCD().contains("EMP_AUTH")) {
			// 无员工管理权限
		}
		String cust_name = user.getCust_name();
		String gym = user.getViewGym();
		String name = request.getParameter("name");
		String role = request.getParameter("role");
		String pwd = request.getParameter("pwd");
		String login_name = request.getParameter("phone");
		String bind = request.getParameter("bind");

		if (!Utils.isNull(pwd)) {
			pwd = Utils.getMd5(pwd);
		}

		String emp_id = request.getParameter("emp_id");
		String[] viewGym = request.getParameterValues("viewGym[]");// 可见会所
		if (Utils.isNull(emp_id)) {
			// 添加
			Entity emp = new EntityImpl(this);
			int s = emp.executeQuery("select sm from f_emp where  login_name = ?", new Object[] { login_name });
			if (s > 0) {
				String sm = emp.getStringValue("SM");
				if ("Y".equals(sm)) {
					throw new Exception("该账户已经是电脑端工作人员了");
				} else {
					emp.executeUpdate("update f_emp set SM = 'Y' where id = ?", new Object[] { emp.getStringValue("id") });
				}
			} else {
				// 查询是否是会员手机
				Mem m = UserUtils.getMemInfoByPhone(login_name, this, user);
				if (m == null) {
					// 不是会员
					emp.setValue("login_name", login_name);
					emp.setValue(role, bind);
					emp.setValue("pwd", pwd);
					emp.setValue("name", name);
					emp.setValue("state", "002");
					emp.setValue("cust_name", cust_name);
					emp.setValue("gym", gym);
					if (login_name.matches("^((13[0-9])|(15[0-9])|(17[0-9])|(18[0-9]))\\d{8}$")) {
						emp.setValue("phone", login_name);
					}
					emp_id = emp.create();
				} else {
					// 是会员
					String mem_id = m.getId();
					s = emp.executeQuery("select id from f_emp where id = ?", new Object[] { mem_id });
					if (s == 0) {
						// 非员工
						emp.setValue("login_name", login_name);
						emp.setValue(role, bind);
						emp.setValue("pwd", pwd);
						emp.setValue("name", name);
						emp.setValue("state", "002");
						emp.setValue("cust_name", cust_name);
						emp.setValue("gym", gym);
						if (login_name.matches("^((13[0-9])|(15[0-9])|(17[0-9])|(18[0-9]))\\d{8}$")) {
							emp.setValue("phone", login_name);
						}
						emp_id = emp.create();
					} else {
						// 是员工
						emp.executeUpdate("update f_emp set sm = 'Y',login_name = ? where id = ?", new Object[] { login_name, mem_id });
						emp_id = mem_id;
					}
				}
			}
		} else {
			// 从会员表添加的管理
			Entity en = new EntityImpl("f_mem", this);
			en.setTablename("f_mem_" + cust_name);
			en.setValue("id", emp_id);
			int s = en.search();
			if (s == 0) {
				throw new Exception("不存在的会员,请重新选择会员");
			}

			s = en.executeQuery("select id from f_emp where login_name = ?", new Object[] { login_name });
			if (s > 1 || (s == 1 && !emp_id.equals(en.getStringValue("id")))) {
				throw new Exception("登录名重复,请换一个");
			}

			en = new EntityImpl("f_emp", this);
			s = en.executeQuery("select id from f_emp a where a.id=?", new String[] { emp_id });

			if (s <= 0) {
				en.setValue("id", emp_id);
				en.setValue("cust_name", cust_name);
				en.setValue("gym", gym);
				en.setValue("login_name", login_name);
				en.setValue("pwd", pwd);
				en.setValue("state", "002");
				en.setValue("sm", "Y");
				en.setValue("mc", "N");
				en.setValue("pt", "N");
				en.setValue("ex_mc", "N");
				en.setValue("ex_pt", "N");
				en.create();
			} else {
				en.setValue("id", emp_id);
				en.setValue("sm", "Y");
				en.setValue("login_name", login_name);
				if (!Utils.isNull(pwd)) {
					en.setValue("pwd", pwd);
				}
				en.update();
			}
			// 查询可见会所有无数据
			/*
			 * en = new EntityImpl("f_emp_gym", this); en.setValue("cust_name",
			 * cust_name); en.setValue("view_gym", gym);
			 * en.setValue("fk_emp_id", emp_id); s = en.search(); if (s <= 0) {
			 * // 添加可见会所 en.setValue("cust_name", cust_name);
			 * en.setValue("view_gym", gym); en.setValue("gym", gym);
			 * en.setValue("fk_emp_id", emp_id); en.create(); }
			 */

			en = new EntityImpl("f_m_emp", this);

			// 权限
			String[] powers = this.getParameterValues("power[]");

			if (powers != null && powers.length > 0) {

				for (int i = 0; i < viewGym.length; i++) {
					String g = viewGym[i];
					if (powers != null && powers.length > 0) {
						s = en.executeQuery("select * from f_emp_auth where emp_id = ? and cust_name = ? and gym = ? and auth like '" + role.toLowerCase() + "%'", new Object[] { emp_id, cust_name, g });
						if (s > 0 && g.equals(gym)) {
							en.executeUpdate("delete from f_emp_auth where emp_id = ? and cust_name = ? and gym = ? and auth like '" + role.toLowerCase() + "%'", new Object[] { emp_id, cust_name, g });
							en = new EntityImpl("f_emp_auth", this);
							for (int j = 0; j < powers.length; j++) {
								en.setValue("cust_name", cust_name);
								en.setValue("gym", g);
								en.setValue("emp_id", emp_id);
								en.setValue("auth", powers[j]);
								en.create();
							}
						} else if (s <= 0) {
							en = new EntityImpl("f_emp_auth", this);
							for (int j = 0; j < powers.length; j++) {
								en.setValue("cust_name", cust_name);
								en.setValue("gym", g);
								en.setValue("emp_id", emp_id);
								en.setValue("auth", powers[j]);
								en.create();
							}
						}
					}
				}

				/*
				 * en.
				 * executeUpdate("delete from f_emp_auth where emp_id = ? and cust_name = ? and gym = ? and auth like 'sm%'"
				 * , new Object[] { emp_id, cust_name, gym }); for (int i = 0; i
				 * < powers.length; i++) { en = new EntityImpl("f_emp_auth",
				 * this); en.setValue("cust_name", cust_name);
				 * en.setValue("gym", gym); en.setValue("emp_id", emp_id);
				 * en.setValue("auth", powers[i]); en.create(); }
				 */
			}

		}

		/*
		 * // 权限 String[] powers = this.getParameterValues("power[]"); if
		 * (powers != null && powers.length > 0) { Entity en = new
		 * EntityImpl(this); en.
		 * executeUpdate("delete from f_emp_auth where emp_id = ? and cust_name = ? and gym = ? and auth like 'sm%'"
		 * , new Object[] { emp_id, cust_name, gym }); for (int i = 0; i <
		 * powers.length; i++) { en = new EntityImpl("f_emp_auth", this);
		 * en.setValue("cust_name", cust_name); en.setValue("gym", gym);
		 * en.setValue("emp_id", emp_id); en.setValue("auth", powers[i]);
		 * en.create(); } }
		 */
		// 可见会所
		if (viewGym != null && viewGym.length > 0) {
			Entity en = new EntityImpl(this);
			en.executeUpdate("delete from f_emp_gym where fk_emp_id = ?", new Object[] { emp_id });
			for (int i = 0; i < viewGym.length; i++) {
				en = new EntityImpl("f_emp_gym", this);
				en.setValue("cust_name", cust_name);
				en.setValue("gym", gym);
				en.setValue("fk_emp_id", emp_id);
				en.setValue("view_gym", viewGym[i]);
				en.create();
			}
		}
	}

	/**
	 * 通用的员工角色设置
	 * 
	 * @throws Exception
	 */
	@Route(value = "/emp-generic-role-bind", conn = true, type = ContentType.JSON, m = HttpMethod.POST)
	public void emp_generic_role_bind() throws Exception {
		FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
		if (user == null) {
			this.getRequest().getRequestDispatcher("/").forward(request, response);
		}
		if (!user.getCD().contains("EMP_AUTH")) {
			// 无员工管理权限
		}
		String cust_name = user.getCust_name();
		String gym = user.getViewGym();

		String emp_id = request.getParameter("emp_id");
		String role = request.getParameter("role");
		String bind = request.getParameter("bind");

		Entity en = new EntityImpl("f_emp", this);
		en.setValue("id", emp_id);
		en.search();
		String r = en.getStringValue(role);
		if (!"Y".equals(r)) {
			en.setValue(role, bind);
			en.update();
		}
		String reg_gym = en.getStringValue("gym");
		if ("Y".equals(bind)) {
			// 绑定
			// 添加员工可见会所
			Entity f_emp_gym = new EntityImpl("f_emp_gym", this);
			f_emp_gym.setValue("view_gym", gym);
			f_emp_gym.setValue("fk_emp_id", emp_id);
			int s = f_emp_gym.search();
			if (s == 0) {
				// 添加一条可见会所
				f_emp_gym.setValue("cust_name", cust_name);
				f_emp_gym.setValue("gym", reg_gym);
				f_emp_gym.setValue("fk_emp_id", emp_id);
				f_emp_gym.setValue("view_gym", gym);
				f_emp_gym.create();
			}
		} else {
			// 解绑
			Entity f_emp_gym = new EntityImpl("f_emp_gym", this);
			f_emp_gym.executeUpdate("delete from f_emp_gym where cust_name = ? and view_gym = ? and fk_emp_id = ?", new Object[] { cust_name, gym, emp_id });
			int s = f_emp_gym.executeQuery("select * from f_emp_gym where cust_name = ? and fk_emp_id = ? ", new Object[] { cust_name, emp_id });
			if (s == 0) {
				// 无可见会所了
				en.setValue("MC", "N");
				en.setValue("PT", "N");
				en.setValue("OP", "N");
				en.setValue("EX_MC", "N");
				en.setValue("EX_PT", "N");
				en.update();
			}
		}
	}

	@Route(value = "/emp-bind-role-ex", conn = true, type = ContentType.JSON, m = HttpMethod.POST)
	public void emp_bind_role_ex() throws Exception {

		FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
		if (user == null) {
			this.getRequest().getRequestDispatcher("/").forward(request, response);
		}
		if (!user.getCD().contains("EMP_AUTH")) {
			// 无员工管理权限
		}
		String cust_name = user.getCust_name();
		String gym = user.getViewGym();
		String role = request.getParameter("role");

		String mcs[] = request.getParameterValues("mcs[]");
		String pts[] = request.getParameterValues("pts[]");

		String emp_id = request.getParameter("emp_id");
		if (emp_id == null || "".equals(emp_id)) {
			throw new Exception("请先选择员工");
		}

		Entity en = new EntityImpl("f_mem", this);
		en.setTablename("f_mem_" + cust_name);
		en.setValue("id", emp_id);
		int s = en.search();
		if (s == 0) {
			// throw new Exception("未知错误,会员与员工数据不统一");
		}
		String mem_name = en.getStringValue("mem_name");
		String phone = en.getStringValue("phone");
		String wx_open_id = en.getStringValue("wx_open_id");

		en = new EntityImpl("f_emp", this);

		en.setValue("id", emp_id);
		s = en.search();
		String ex = "";
		if ("pt".equals(role)) {
			ex = "ex_pt";
		} else {
			ex = "ex_mc";
		}
		if (s == 0) {
			en.setValue("id", emp_id);
			en.setValue("cust_name", cust_name);
			en.setValue("gym", gym);
			en.setValue("name", mem_name);
			en.setValue("phone", phone);
			en.setValue("wx_open_id", wx_open_id);
			en.setValue("state", "002");
			en.setValue("MC", "N");
			en.setValue("PT", "N");
			en.setValue("OP", "N");
			en.setValue("EX_MC", "N");
			en.setValue("EX_PT", "N");
			en.setValue("SM", "N");
			en.setValue(ex, "Y");
			en.create();
		} else {
			en.setValue(ex, "Y");
			en.update();
		}
		/*
		 * // 查询可见会所有无数据 en = new EntityImpl("f_emp_gym", this);
		 * en.setValue("cust_name", cust_name); en.setValue("view_gym", gym);
		 * en.setValue("fk_emp_id", emp_id); s = en.search(); if (s == 0) { //
		 * 添加可见会所 en.setValue("cust_name", cust_name); en.setValue("view_gym",
		 * gym); en.setValue("gym", gym); en.setValue("fk_emp_id", emp_id);
		 * en.create(); }
		 */

		en = new EntityImpl("f_m_emp", this);
		// 删除当前GYM之前的下级
		String type = "";

		if ("pt".equals(role)) {
			type = "PT";
		} else {
			type = "MC";
		}
		en.executeUpdate("delete from f_m_emp where cust_name = ? and gym = ? and p_emp_id = ? and type = ?", new Object[] { cust_name, gym, emp_id, type });
		// 添加下级
		if (pts != null) {
			for (String id : pts) {
				en.setValue("cust_name", cust_name);
				en.setValue("gym", gym);
				en.setValue("type", "PT");
				en.setValue("p_emp_id", emp_id);
				en.setValue("emp_id", id);
				en.create();
			}
		}
		if (mcs != null) {
			for (String id : mcs) {
				en.setValue("cust_name", cust_name);
				en.setValue("gym", gym);
				en.setValue("type", "MC");
				en.setValue("p_emp_id", emp_id);
				en.setValue("emp_id", id);
				en.create();
			}
		}
		// 将当前员工设置成主管
		// en.executeUpdate("update f_emp set " + role + " = 'Y' where id =?",
		// new Object[] { emp_id });
		// 权限
		String[] powers = this.getParameterValues("power[]");
		if (powers != null && powers.length > 0) {
			en.executeUpdate("delete from f_emp_auth where emp_id = ? and cust_name = ? and gym = ? and auth like '" + ex + "%'", new Object[] { emp_id, cust_name, gym });
			for (int i = 0; i < powers.length; i++) {
				en = new EntityImpl("f_emp_auth", this);
				en.setValue("cust_name", cust_name);
				en.setValue("gym", gym);
				en.setValue("emp_id", emp_id);
				en.setValue("auth", powers[i]);
				en.create();
			}
		}

		// 可见会所
		String[] viewGym = this.getParameterValues("viewGym[]");
		if (viewGym != null && viewGym.length > 0) {
			en.executeUpdate("delete from f_emp_gym where fk_emp_id = ?", new Object[] { emp_id });
			for (int i = 0; i < viewGym.length; i++) {
				en = new EntityImpl("f_emp_gym", this);
				en.setValue("cust_name", cust_name);
				en.setValue("gym", gym);
				en.setValue("fk_emp_id", emp_id);
				en.setValue("view_gym", viewGym[i]);
				en.create();
			}
		}
	}

	/**
	 * 查询本门店某个角色的可见员工 传递参数role=mc 或者role=mc,pt
	 * 
	 * @throws Exception
	 */
	@Route(value = "/emp-query-by-role", slave = true, conn = true, type = ContentType.JSON, m = HttpMethod.POST)
	public void query_emp_role() throws Exception {

		FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
		if (user == null) {
			this.getRequest().getRequestDispatcher("/").forward(request, response);
		}
		if (!user.getCD().contains("EMP_AUTH")) {
			// 无员工管理权限
		}

		String role = request.getParameter("role");
		String roles[] = role.split(",");
		Entity en = new EntityImpl("f_emp", this);
		String sql = "select a.* from f_emp a right join f_emp_gym b on a.id = b.fk_emp_id where b.cust_name = '" + user.getCust_name() + "' and b.gym='" + user.getViewGym() + "'";
		for (int i = 0; i < roles.length; i++) {
			if (i == 0) {
				sql += " and a." + roles[i] + "='Y'";
			} else {
				sql += " or a." + roles[i] + "='Y'";
			}
		}

		int s = en.executeQuery(sql);
		if (s > 0) {
			this.obj.put("emps", en.toJson().getJSONArray("listData"));
		}

	}

	/**
	 * 查询本门店某个角色的可见员工 传递参数role=mc 或者role=mc,pt
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-emp-del-viewGym", conn = true, type = ContentType.JSON, m = HttpMethod.POST)
	public void fit_emp_del_viewGym() throws Exception {
		FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
		if (user == null) {
			this.getRequest().getRequestDispatcher("/").forward(request, response);
		}
		if (!user.getCD().contains("EMP_AUTH")) {
			// 无员工管理权限
		}
	}

	/**
	 * 员工可见门店
	 */
	@Route(value = "/fit-ws-emp-viewgym-list", conn = true, type = ContentType.Forward, m = HttpMethod.GET)
	public void fit_ws_emp_viewgym_list() throws Exception {
		FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
		if (user == null) {
			this.getRequest().getRequestDispatcher("/").forward(request, response);
		}
		if (!user.getCD().contains("EMP_AUTH")) {
			// 无员工管理权限
		}
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		for (String g : user.getLevelGyms()) {
			Map<String, Object> m = new HashMap<String, Object>();
			m.put("gym_name", GymUtils.getGymName(g));
			m.put("gym", g);
			list.add(m);
		}

		if (user.is系统管理员() && user.getCds().size() <= 0) {
			List<Gym> viewGyms = user.getCust().viewGyms;
			list = new ArrayList<Map<String, Object>>();
			for (Gym g : viewGyms) {
				Map<String, Object> m = new HashMap<String, Object>();
				m.put("gym_name", g.gymName);
				m.put("gym", g.gym);
				list.add(m);
			}
		}

		request.setAttribute("gyms", list);
		this.obj.put("nextpage", request.getParameter("nextPage"));
	}

	/**
	 * 编辑教练APP端展示内容
	 */
	@Route(value = "/fit-bg-emp-save-edit-pt", conn = true, type = ContentType.Forward, m = HttpMethod.POST)
	public void fit_bg_emp_save_edit_pt() throws Exception {
		FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
		if (user == null) {
			this.getRequest().getRequestDispatcher("/").forward(request, response);
		}
		String e = request.getParameter("e");
		Entity en = this.getEntityFromPage(e);

		en.update();
	}

	/**
	 * 从会员表选取会员成为员工
	 * 
	 * @throws Exception
	 */
	@Route(value = "/emp-generic-role-bind-fromMem", conn = true, type = ContentType.Forward, m = HttpMethod.POST)
	public void bind_empFromMem() throws Exception {

		FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
		if (user == null) {
			this.getRequest().getRequestDispatcher("/").forward(request, response);
		}

		String[] powers = request.getParameterValues("power[]");
		String[] viewGym = request.getParameterValues("viewGym[]");
		String emp_id = request.getParameter("emp_id");
		String bind = request.getParameter("bind");
		String role = request.getParameter("role");

		String cust_name = user.getCust_name();
		String gym = user.getViewGym();

		Entity en = new EntityImpl("f_mem", this);
		en.setTablename("f_mem_" + cust_name);
		en.setValue("id", emp_id);
		int s = en.search();
		if (s == 0) {
			throw new Exception("未知错误");
		}
		String mem_name = en.getStringValue("mem_name");
		String phone = en.getStringValue("phone");

		en = new EntityImpl("f_emp", this);

		en.setValue("id", emp_id);
		s = en.search();
		if (s == 0) {
			en.setValue("id", emp_id);
			en.setValue("cust_name", cust_name);
			en.setValue("gym", gym);
			en.setValue("name", mem_name);
			en.setValue("phone", phone);
			en.setValue("state", "002");
			en.setValue("mc", "N");
			en.setValue("pt", "N");
			en.setValue("ex_mc", "N");
			en.setValue("ex_pt", "N");
			en.setValue("pt", "N");
			en.setValue("sm", "N");
			en.setValue(role, bind);
			en.create();
		} else {
			en.setValue(role, bind);
			en.update();
			// 移除可见会所
		}

		/*
		 * if ("Y".equals(bind)) { en = new EntityImpl("f_emp_gym", this);
		 * en.setValue("cust_name", cust_name); en.setValue("view_gym", gym);
		 * en.setValue("fk_emp_id", emp_id); s = en.search(); if (s == 0) { //
		 * 添加可见会所 en.setValue("cust_name", cust_name); en.setValue("view_gym",
		 * gym); en.setValue("gym", gym); en.setValue("fk_emp_id", emp_id);
		 * en.create(); } } else if ("N".equals(bind)) { en = new
		 * EntityImpl("f_emp_gym", this); en.setValue("cust_name", cust_name);
		 * en.setValue("view_gym", gym); en.setValue("fk_emp_id", emp_id); //
		 * en.delete(); }
		 */
		// 权限
		if (powers != null && powers.length > 0) {
			en.executeUpdate("delete from f_emp_auth where emp_id = ? and cust_name = ? and gym = ? and auth like '" + role.toLowerCase() + "%'", new Object[] { emp_id, cust_name, gym });
			for (int i = 0; i < powers.length; i++) {
				en = new EntityImpl("f_emp_auth", this);
				en.setValue("cust_name", cust_name);
				en.setValue("gym", gym);
				en.setValue("emp_id", emp_id);
				en.setValue("auth", powers[i]);
				en.create();
			}
		}
		// 可见会所
		if (viewGym != null && viewGym.length > 0) {
			en.executeUpdate("delete from f_emp_gym where fk_emp_id = ?", new Object[] { emp_id });
			for (int i = 0; i < viewGym.length; i++) {
				en = new EntityImpl("f_emp_gym", this);
				en.setValue("cust_name", cust_name);
				en.setValue("gym", gym);
				en.setValue("fk_emp_id", emp_id);
				en.setValue("view_gym", viewGym[i]);
				en.create();
			}
		}
	}

	@Route(value = "/ws-bg-emp-generic-role-unbind", conn = true, type = ContentType.Forward, m = HttpMethod.POST)
	public void delRole() throws Exception {

		String emp_id = request.getParameter("emp_id");
		String role = request.getParameter("role");

		String s = role + " = 'N'";
		if ("ex".equals(role)) {
			s = " ex_mc = 'N',ex_pt ='N'";
		}

		Entity en = new EntityImpl(this);
		en.executeUpdate("update f_emp set " + s + " where id = ?", new Object[] { emp_id });

		// 删除下属
		en.executeUpdate("delete from f_m_emp where p_emp_id = ?", new Object[] { emp_id });

	}

	@Route(value = "/sm_change_emp_pwd", conn = true, type = ContentType.Forward, m = HttpMethod.POST)
	public void sm_change_emp_pwd() throws Exception {

		String emp_id = request.getParameter("f_emp__id");

		String login_name = request.getParameter("f_emp__login_name");
		String f_emp__new_pwd = request.getParameter("f_emp__new_pwd");
		if (Utils.isNull(f_emp__new_pwd)) {
			throw new Exception("请提供需要修改的密码");
		}

		Entity en = new EntityImpl("f_emp", this);
		int s = en.executeQuery("select * from f_emp where login_name = ?", new Object[] { login_name });
		if (s > 0) {
			if (!emp_id.equals(en.getStringValue("id"))) {
				throw new Exception("登录名重复");
			}
		}
		en.setValue("id", emp_id);
		en.setValue("login_name", login_name);
		en.setValue("pwd", Utils.getMd5(f_emp__new_pwd));
		en.update();
	}

	@Route(value = "/fit-bg-emp-detail", conn = true, type = ContentType.Forward, m = HttpMethod.POST)
	public void emp_detail() throws Exception {

		String emp_id = request.getParameter("emp_id");
		Entity en = new EntityImpl("f_emp", this);

		// 可见会所
		int s = en.executeQuery("select * from f_emp_gym where fk_emp_id = ?", new Object[] { emp_id });
		if (s > 0) {
			List<String> viewGyms = new ArrayList<String>();
			for(int i=0;i<s;i++){
				viewGyms.add(en.getStringValue("view_gym",i));
			}
			this.obj.put("viewGyms", viewGyms);
		}
	}
}
