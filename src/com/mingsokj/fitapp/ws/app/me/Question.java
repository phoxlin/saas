package com.mingsokj.fitapp.ws.app.me;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;

/**
 * @author liul 2017年7月20日上午10:47:18
 */
public class Question extends BasicAction {

	/**
	 * 保存意见反馈
	 * 
	 * @Title: saveQuestion
	 * @author: liul
	 * @throws Exception
	 * @date: 2017年7月20日上午10:48:38
	 */
	@Route(value = "/fit-app-action-saveQuestion", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void saveQuestion() throws Exception {
		String gym = this.getParameter("gym");
		String cust_name = this.getParameter("cust_name");
		String mem_id = this.getParameter("mem_id");
		String mem_msg = this.getParameter("mem_msg");
		String content = this.getParameter("content");
		if ("".equals(mem_msg)) {
			mem_msg = "未填写";
		}
		Entity en = new EntityImpl("f_feedback", this);
		en.setValue("gym", gym);
		en.setValue("cust_name", cust_name);
		en.setValue("mem_id", mem_id);
		en.setValue("mem_msg", mem_msg);
		en.setValue("content", content);
		en.setValue("stete", "N");
		en.setValue("create_date", new Date());
		en.create();
	}

	/**
	 * 显示体验卡
	 * 
	 * @Title: showExperienceLesson
	 * @author: liul
	 * @date: 2017年7月21日上午9:10:43
	 * @throws Exception
	 */
	@Route(value = "/fit-app-action-showExperienceLesson", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void showExperienceLesson() throws Exception {
		String gym = this.getParameter("gym");
		Entity en = new EntityImpl("f_plan", this);
		en.setValue("gym", gym);
		en.setValue("experience", "Y");
		int size = en.search();
		List<Map<String, Object>> list = new ArrayList<>();
		if (size > 0) {
			list = en.getValues();
		}
		String pt_id = "";
		for (int i = 0; i < size; i++) {
			pt_id += en.getStringValue("pt_id", i) + ",";
		}

		if (pt_id != null && pt_id.length() > 0 && pt_id.contains(",")) {
			pt_id = pt_id.substring(0, pt_id.length() - 1);
		}

		// 查询教练信息
		Entity emps = new EntityImpl(this);
		emps.executeQuery("select * from f_emp where id in('" + pt_id.replace(",", "','") + "')");
		for (int i = 0; i < size; i++) {
			String pt = en.getStringValue("pt_id", i);
			Map<String, Object> map = new HashMap<String, Object>();
			for (int j = 0; j < emps.getMaxResultCount(); j++) {
				String id = emps.getStringValue("id", j);
				if (id.equals(pt)) {
					map = emps.getValues().get(j);
					break;
				}
			}
			list.get(i).put("pt", map);
		}
		this.obj.put("list", list);
	}

	/**
	 * 获取体验卡详情
	 * 
	 * @Title: showLessonDetail
	 * @author: liul
	 * @date: 2017年7月21日上午9:11:16
	 * @throws Exception
	 */
	@Route(value = "/fit-app-action-showLessonDetail", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void showLessonDetail() throws Exception {
		String id = this.getParameter("id");
		Entity en = new EntityImpl("f_plan", this);
		en.setValue("id", id);
		int size = en.search();
		List<Map<String, Object>> list = new ArrayList<>();
		if (size > 0) {
			list = en.getValues();
		}
		String pt_id = "";
		for (int i = 0; i < size; i++) {
			pt_id += en.getStringValue("pt_id", i) + ",";
		}

		if (pt_id != null && pt_id.length() > 0 && pt_id.contains(",")) {
			pt_id = pt_id.substring(0, pt_id.length() - 1);
		}

		// 查询教练信息
		Entity emps = new EntityImpl(this);
		emps.executeQuery("select * from f_emp where id in('" + pt_id.replace(",", "','") + "')");
		for (int i = 0; i < size; i++) {
			String pt = en.getStringValue("pt_id", i);
			Map<String, Object> map = new HashMap<String, Object>();
			for (int j = 0; j < emps.getMaxResultCount(); j++) {
				String _id = emps.getStringValue("id", j);
				if (_id.equals(pt)) {
					map = emps.getValues().get(j);
					break;
				}
			}
			list.get(i).put("pt", map);
		}
		this.obj.put("list", list);
	}
}
