package com.mingsokj.fitapp.ws.app.sales;

import java.text.SimpleDateFormat;
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
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.utils.MemUtils;

public class 查询潜客详情 extends BasicAction {
	@Route(value = "/fit-app-action-updatePotentialCustoremer", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void updatePotentialCustoremer() throws Exception {
		String gym = this.getParameter("gym");
		String fk_user_id = this.getParameter("fk_user_id");
		String mem_name = this.getParameter("mem_name");
		String phone = this.getParameter("phone");
		String imp_level = this.getParameter("imp_level");
		String remark = this.getParameter("remark");

		MemInfo info = new MemInfo();
		info.setId(fk_user_id);
		info.setMem_name(mem_name);
		info.setPhone(phone);
		info.setRemark(remark);
		info.setImp_level(imp_level);
		info.setGym(gym);
		info.update(this.getConnection(), false);

	}

	@Route(value = "/fit-app-action-getPotentialCustomerById", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void getPotentialCustomerById() throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String gym = this.getParameter("gym");
		String cust_name = this.getParameter("cust_name");
		String fk_user_id = this.getParameter("fk_user_id");
		String type = this.getParameter("type");

		MemInfo mem = MemUtils.getMemInfo(fk_user_id, cust_name);
		if (!Utils.isNull(mem)) {
			Map<Object, Object> map = new HashMap<Object, Object>();
			map.put("xx", mem);
			this.obj.put("map", map);
		}
		// 维护记录
		Entity en = new EntityImpl(this);

		int size = en.executeQuery(
				"select a.*,b.mem_name name  from f_mem_maintain_" + gym + " a,f_mem_" + cust_name
						+ " b where  op_id = b.id and a.mem_id=? and a.type=? order by a.op_time desc",
				new Object[] { fk_user_id, type });
		if (size > 0) {
			List<Map<String, Object>> recordList = en.getValues();
			for (int i = 0; i < recordList.size(); i++) {
				Map<String, Object> record = recordList.get(i);
				Date op_time = (Date) record.get("op_time");
				record.put("op_time", sdf.format(op_time));
				mem = MemUtils.getMemInfo(record.get("op_id") + "", cust_name);
				if (!Utils.isNull(mem)) {
					record.put("op_name", mem.getMem_name());
				} else {
					record.put("op_name", "--");
				}
			}
			this.obj.put("record", recordList);
		}
	}
}
