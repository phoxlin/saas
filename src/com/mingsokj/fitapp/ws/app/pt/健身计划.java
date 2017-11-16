package com.mingsokj.fitapp.ws.app.pt;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
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

public class 健身计划 extends BasicAction {
	/**
	 * 获取买卡带教练的会员
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-app-action-getMemWhoBuyCardWithPt", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void getMemWhoBuyCardWithPt() throws Exception {

		String pt_id = request.getParameter("pt_id");
		String cust_name = request.getParameter("cust_name");
		String gym = request.getParameter("gym");
		String search = request.getParameter("search");

		Entity en = new EntityImpl(this);
		String sql = "select b.id,b.mem_name,b.phone,b.gym,b.pic1 from f_user_card_" + gym + " a ,f_mem_" + cust_name + " b where a.pt_id = ? and a.mem_id = b.id";
		if (!Utils.isNull(search)) {
			if (search.matches("^((13[0-9])|(15[0-9])|(17[0-9])|(18[0-9]))\\d{8}$")) {
				sql += " and (b.mem_name like '%" + search + "%' or b.phone = '" + search + "')";
			} else {
				sql += " and b.mem_name like '%" + search + "%'";
			}
		}
		sql += "  group by a.mem_id";
		int s = en.executeQuery(sql, new Object[] { pt_id });
		if (s > 0) {
			 List<Map<String, Object>> list = en.getValues();
			for (int i = 0; i < s; i++) {
				String id = en.getStringValue("id",i);
				MemInfo memInfo = MemUtils.getMemInfo(id, cust_name);
				if(memInfo !=null){
					list.get(i).put("name", memInfo.getName());
					list.get(i).put("headurl", memInfo.getWxHeadUrl());
				}
			}
			this.obj.put("list",list);
		}
	}

	/**
	 * 查询会员的健身计划
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-app-action-queryMemFitPlan", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void queryMemFitPlan() throws Exception {
		String mem_id = request.getParameter("mem_id");
		String pt_id = request.getParameter("pt_id");
		String cust_name = request.getParameter("cust_name");
		String gym = request.getParameter("gym");
		String start_time = request.getParameter("start_time") + " 00:00:00";
		String end_time = request.getParameter("end_time") + " 23:59:59";
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String month = request.getParameter("month");
		String type = request.getParameter("type");

		start_time = month + "-01 00:00:00";
		Calendar cal = Calendar.getInstance();
		cal.setTime(sdf.parse(month + "-01"));
		cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));  
		end_time = sdf.format(cal.getTime()) + " 23:59:59";

		Entity en = new EntityImpl(this);

		String sql = "select a.*,b.mem_name,b.phone,b.pic1,c.headurl,c.nickname from f_fit_plan_" + cust_name + " a left join f_mem_" + cust_name + " b on a.mem_id = b.id left join f_wx_cust_" + cust_name + " c on b.wx_open_id = c.wx_open_id left join f_emp d on a.pt_id = d.id ";
		sql += " where a.mem_id = ? and a.cust_name = ? and a.gym = ?";
		if ("pt".equals(type)) {
			sql += " and a.pt_id = '" + pt_id + "' and start_time between ? and ? order by start_time desc";
		} else {
			sql += " and start_time between ? and ? order by start_time desc";
		}

		int s = en.executeQuery(sql, new Object[] { mem_id,cust_name,gym, start_time, end_time });
		if (s > 0) {

			Entity plan = new EntityImpl(this);
			List<Map<String, Object>> list = en.getValues();
			String mem_gym = en.getStringValue("mem_gym");
			for (int i = 0; i < s; i++) {
				String fit_plan_id = en.getStringValue("id", i);
				int x = plan.executeQuery("select * from f_fit_plan_detail_" + mem_gym + " where fit_plan_id = ?", new Object[] { fit_plan_id });
				if (x > 0) {
					list.get(i).put("plans", plan.getValues());
				}
			}
			this.obj.put("list", list);
		}
	}

	/**
	 * 新增计划
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-app-action-createFitPlan", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void createFitPlan() throws Exception {
		String mem_id = request.getParameter("mem_id");
		String mem_gym = request.getParameter("mem_gym");
		String pt_id = request.getParameter("pt_id");
		String cust_name = request.getParameter("cust_name");
		String gym = request.getParameter("gym");

		String fitPlanNumber = request.getParameter("fitPlanNumber");
		String fitPlanTitle = request.getParameter("fitPlanTitle");
		String fitPlanStartTime = request.getParameter("fitPlanStartTime");
		String fitPlanEndTime = request.getParameter("fitPlanEndTime");

		int num = 0;
		try {
			num = Integer.parseInt(fitPlanNumber);
		} catch (Exception e) {
			throw new Exception("课程节数设置不对哦");
		}

		Date now = new Date();
		if (num > 0) {
			Entity en = new EntityImpl("f_fit_plan", this);

			en.setTablename("f_fit_plan_" + cust_name);
			en.setValue("cust_name", cust_name);
			en.setValue("gym", gym);
			en.setValue("mem_id", mem_id);
			en.setValue("mem_gym", mem_gym);
			en.setValue("pt_id", pt_id);
			en.setValue("title", fitPlanTitle);
			en.setValue("start_time", fitPlanStartTime);
			en.setValue("end_time", fitPlanEndTime);
			en.setValue("create_time", now);
			en.setValue("state", "N");// 会员不可见
			String fit_plan_id = en.create();
			en = new EntityImpl("f_fit_plan_detail", this);
			en.setTablename("f_fit_plan_detail_" + mem_gym);
			for (int i = 0; i < num; i++) {
				en.setValue("fit_plan_id", fit_plan_id);
				en.setValue("num", i + 1);
				en.create();
			}
		}

	}

	@Route(value = "/fit-app-action-queryFitPlanDetail", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void queryFitPlanDetail() throws Exception {

		String fit_plan_id = request.getParameter("fit_plan_id");
		String detail_id = request.getParameter("detail_id");
		String mem_gym = request.getParameter("mem_gym");

		String cust_name = request.getParameter("cust_name");
//		String gym = request.getParameter("gym");

		Entity en = new EntityImpl("f_fit_plan", this);
		//String sql = "select a.*,b.mem_name,c.name from f_fit_plan_" + cust_name + " a left join f_mem_" + cust_name + " b on a.mem_id = b.id left join f_emp c on a.pt_id = c.id  where a.id = ?";
		//查询会员姓名
		String sql = "select a.* from f_fit_plan_" + cust_name + " a where a.id = ?";
		//查询教练姓名
		int s = en.executeQuery(sql, new Object[] { fit_plan_id });
		if (s > 0) {
			Map<String, Object> map = en.getValues().get(0);
			String mem_id = en.getStringValue("mem_id");
			String pt_id = en.getStringValue("pt_id");
			String mem_name = MemUtils.getMemInfo(mem_id, cust_name).getName();
			String name = MemUtils.getMemInfo(pt_id, cust_name).getName();
			map.put("mem_name", mem_name);
			map.put("name", name);
			this.obj.put("fit_plan", map);
			s = en.executeQuery("select * from f_fit_plan_detail_" + mem_gym + "  where  id = ?", new Object[] { detail_id });
			if (s > 0) {
				this.obj.put("detail", en.getValues().get(0));
			}
		}else{
			throw new Exception("出错啦,计划已不存在了");
		}

	}

	/**
	 * 编辑详情
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-app-action-saveFitPlanDetail", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void saveFitPlanDetail() throws Exception {
		String detail_id = request.getParameter("detail_id");
		String detail_start = request.getParameter("detail_start");
		String detail_end = request.getParameter("detail_end");
		String detail_plan_content = request.getParameter("detail_plan_content");
//		String cust_name = request.getParameter("cust_name");
		String memGym = request.getParameter("memGym");

//		String gym = request.getParameter("gym");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		Entity en = new EntityImpl("f_fit_plan_detail", this);
		en.setTablename("f_fit_plan_detail_" + memGym);
		en.setValue("id", detail_id);
		boolean flag = false;
		if (!Utils.isNull(detail_start)) {
			flag = true;
			en.setValue("start", sdf.parse(detail_start));
		}
		if (!Utils.isNull(detail_end)) {
			flag = true;
			en.setValue("end", sdf.parse(detail_end));
		}
		if (!Utils.isNull(detail_plan_content)) {
			flag = true;
			en.setValue("plan_content", detail_plan_content);
		}
		if (flag) {
			en.update();

		}

	}

	/**
	 * 健身详情
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-app-action-queryFitPlanDetailById", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void queryFitPlanDetailById() throws Exception {

		String fit_plan_id = request.getParameter("fit_plan_id");

		String cust_name = request.getParameter("cust_name");
		String gym = request.getParameter("gym");

		Entity en = new EntityImpl("f_fit_plan", this);
		String sql = "select a.*,b.mem_name,b.phone,c.name from f_fit_plan_" + gym + " a left join f_mem_" + cust_name + " b on a.mem_id = b.id left join f_emp c on a.pt_id = c.id  where a.id = ?";
		int s = en.executeQuery(sql, new Object[] { fit_plan_id });

		if (s > 0) {
			// 会员信息
			this.obj.put("mem", en.getValues().get(0));
			String mem_gym = en.getStringValue("mem_gym");
			s = en.executeQuery("select * from f_fit_plan_detail_" + mem_gym + " where fit_plan_id = ? ", new Object[] { fit_plan_id });
			if (s > 0) {
				this.obj.put("list", en.getValues());
			}
		}

	}

	@Route(value = "/fit-app-action-FitPlanSpeak", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void FitPlanSpeak() throws Exception {

		String detail_id = request.getParameter("detail_id");
		String mem_gym = request.getParameter("mem_gym");
		String mem_confirm = request.getParameter("mem_confirm");
		String pt_confirm = request.getParameter("pt_confirm");

//		String cust_name = request.getParameter("cust_name");
//		String gym = request.getParameter("gym");
		String text = request.getParameter("text");
		String type = request.getParameter("type");

		Entity en = new EntityImpl("f_fit_plan_detail", this);
		en.setTablename("f_fit_plan_detail_" + mem_gym);
		en.setValue("id", detail_id);
		if ("mem".equals(type)) {
			en.setValue("mem_say", text);
		} else if ("pt".equals(type)) {
			en.setValue("pt_say", text);
		}
		Date now = new Date();
		if ("Y".equals(mem_confirm)) {
			en.setValue("mem_confirm", mem_confirm);
			en.setValue("mem_confirm_time", now);
		}
		if ("Y".equals(pt_confirm)) {
			en.setValue("pt_confirm", pt_confirm);
			en.setValue("pt_confirm_time", now);
		}
		en.update();
	}

	@Route(value = "/fit-app-action-FitPlanDetailConfirm", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void FitPlanDetailConfirm() throws Exception {

		String detail_id = request.getParameter("detail_id");
		String mem_gym = request.getParameter("mem_gym");

		String type = request.getParameter("type");

		Entity en = new EntityImpl("f_fit_plan_detail", this);
		en.setTablename("f_fit_plan_detail_" + mem_gym);
		en.setValue("id", detail_id);
		Date now = new Date();
		if ("mem".equals(type)) {
			en.setValue("mem_confirm", "Y");
			en.setValue("mem_confirm_time", now);
		} else if ("pt".equals(type)) {
			en.setValue("pt_confirm", "Y");
			en.setValue("pt_confirm_time", now);
		}
		en.update();
		this.obj.put("now", now.getTime());
	}

	/**
	 * 删除健身计划
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-app-action-deleteFitPlan", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void deleteFitPlan() throws Exception {

		String plan_id = request.getParameter("plan_id");
		String mem_gym = request.getParameter("mem_gym");
		String cust_name = request.getParameter("cust_name");

		Entity en = new EntityImpl("f_fit_plan", this);
		en.setTablename("f_fit_plan_" + cust_name);
		en.setValue("id", plan_id);
		en.delete();

		en.executeUpdate("delete from f_fit_plan_detail_" + mem_gym + " where fit_plan_id = ?", new Object[] { plan_id });
	}

	/**
	 * 修改健身计划
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-app-action-saveEditFitPlan", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void saveEditFitPlan() throws Exception {

		String plan_id = request.getParameter("plan_id");
		String cust_name = request.getParameter("cust_name");
		String title = request.getParameter("title");
		String start_time = request.getParameter("start_time");
		String end_time = request.getParameter("end_time");

		Entity en = new EntityImpl("f_fit_plan", this);
		en.setTablename("f_fit_plan_" + cust_name);
		en.setValue("id", plan_id);
		en.setValue("title", title);
		en.setValue("start_time", start_time);
		en.setValue("end_time", end_time);
		en.update();
	}

}
