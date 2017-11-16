package com.mingsokj.fitapp.tool.hook;

import java.util.List;
import java.util.Map;

import com.jinhua.server.ms.QmHook;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.utils.MemUtils;

/**
 * @author liul 2017年7月25日下午12:05:34
 */
public class PriOrderHook extends QmHook {

	@Override
	public List<Map<String, Object>> getTrimedSet() throws Exception {
		List<Map<String, Object>> old = getRawResultSet(); // 为处理之前的数据
		String cust_name = null;
		for (Map<String, Object> map : old) {
			String id = Utils.getMapStringValue(map, "mem_id");
			if (Utils.isNull(cust_name)) {
				cust_name = Utils.getMapStringValue(map, "cust_name");
			}
			MemInfo info = MemUtils.getMemInfo(id, cust_name);
			if (info != null) {
				map.put("mem_name", info.getName());
			}
		}

		return old;
	}

}
