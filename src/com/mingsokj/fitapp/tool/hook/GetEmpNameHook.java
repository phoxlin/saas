package com.mingsokj.fitapp.tool.hook;

import java.util.List;
import java.util.Map;

import com.jinhua.server.ms.QmHook;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.utils.MemUtils;

public class GetEmpNameHook extends QmHook {

	@Override
	public List<Map<String, Object>> getTrimedSet() throws Exception {
		List<Map<String, Object>> old = getRawResultSet(); // 为处理之前的数据
		for (Map<String, Object> map : old) {
			String cust_name = Utils.getMapStringValue(map, "cust_name");
			String empId = Utils.getMapStringValue(map, "mc_id");
			String pt_names = Utils.getMapStringValue(map, "pt_names");
			try {
				map.put("mc_id", MemUtils.getMemInfo(empId, cust_name).getName());
			} catch (Exception e) {
			}
			try {
				map.put("pt_names", MemUtils.getMemInfo(pt_names, cust_name).getName());
			} catch (Exception e) {
			}
		}
		return old;
	}

}
