package com.mingsokj.fitapp.box;

import java.util.List;
import java.util.Map;

import org.json.JSONObject;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.mingsokj.fitapp.m.FitUser;
import com.mingsokj.fitapp.utils.MemUtils;

/**
 * @author liul 2017年7月28日上午10:09:15
 */
public class BoxRecord extends BasicAction {
	/**
	 * 搜素租柜记录
	 * 
	 * @Title: searchOrder
	 * @author: liul
	 * @date: 2017年7月28日下午12:58:41
	 * @throws Exception
	 */
	@Route(value = "/fit-box-searchOrder", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void searchOrder() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String cust_name = user.getCust_name();
		String cur = request.getParameter("cur");
		if (cur == null || cur.length() <= 0) {
			cur = "1";
		}
		String par = this.getParameter("par");
		Entity en = new EntityImpl(this);
		String sql = "SELECT a.*,b.MEM_NAME,b.MEM_NO,c.AREA_NO,c.BOX_NO FROM f_rent_"+gym+" a,f_mem_"+cust_name+" b,f_box c WHERE a.MEM_ID=b.ID and a.BOX_ID = c.ID";
		JSONObject obj = null;
		if (!"".equals(par)) {
			obj = new JSONObject(par);
			for (String str : obj.keySet()) {
				String value = obj.getString(str);
				if (!"".equals(value)) {
					if ("a.start_time".equals(str)) {
						sql += " and " + str + ">'" + value + "'";
					} else if ("a.end_time".equals(str)) {
						sql += " and " + str + "<'" + value + "'";
					} else {

						sql += " and " + str + " like '%" + value + "%'";
					}
				}
			}
		}

		int pageSize = 8;
		int curPage = Integer.parseInt(cur);
		int start = (curPage - 1) * pageSize + 1;
		int end = pageSize * curPage;
		en.executeQueryWithMaxResult(sql, start, end);
		List<Map<String, Object>> list = en.getValues();
		int total = en.getMaxResultCount();
		int totalpage = 0;
		int temp = total / pageSize;
		totalpage = total % pageSize > 0 ? temp + 1 : temp > 0 ? temp : 1;
		list = en.getValues();
		if (list.size() > 0) {
			// 获取操作人员信息
			for (Map<String, Object> map : list) {
				String emp_id = map.get("emp_id") + "";
				if ("admin".equals(emp_id)) {
					map.put("emp_name", "管理员");
				} else {
					try {
						String name = MemUtils.getMemInfo(emp_id, cust_name).getName();
						map.put("emp_name", name);
					} catch (Exception e) {
						map.put("emp_name", "管理员");
					}
					
				}
			}
		}

		this.obj.put("total", total);
		this.obj.put("totalPage", totalpage);
		this.obj.put("curPage", curPage);
		this.obj.put("curSize", list.size());
		// 查询柜子区域
		en.executeQuery("SELECT * FROM f_box where gym=? GROUP BY AREA_NO", new String[] { gym });
		this.obj.put("list", list);
		this.obj.put("area_no", en.getValues());
	}

	/**
	 * 获取会员是否租柜
	 * 
	 * @Title: getMemBox
	 * @author: liul
	 * @date: 2017年7月28日下午2:48:22
	 * @throws Exception
	 */
	@Route(value = "/fit-box-getMemBox", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void getMemBox() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();
		String id = this.getParameter("id");
		Entity en = new EntityImpl(this);
		String sql = "select b.AREA_NO,b.BOX_NO from f_rent_"+gym+" a,f_box b WHERE a.BOX_ID=b.ID AND a.MEM_ID=? AND a.STATE='001'";
		en.executeQuery(sql, new String[] { id });
		this.obj.put("list", en.getValues());
	}
}
