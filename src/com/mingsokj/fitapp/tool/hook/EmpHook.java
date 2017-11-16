package com.mingsokj.fitapp.tool.hook;

import java.util.List;
import java.util.Map;

import com.jinhua.server.ms.QmHook;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.utils.MemUtils;

public class EmpHook extends QmHook {

	@Override
	public List<Map<String, Object>> getTrimedSet() throws Exception {
		List<Map<String, Object>> old = getRawResultSet(); // 为处理之前的数据
		String cust_name = null;
		for (Map<String, Object> m : old) {
			String id = Utils.getMapStringValue(m, "id");
			if (Utils.isNull(cust_name)) {
				cust_name = Utils.getMapStringValue(m, "cust_name");
			}

			MemInfo info = MemUtils.getMemInfo(id, cust_name);
			if (info != null) {
				m.put("pic_url", info.getWxHeadUrl());
				m.put("name", info.getName());
				m.put("phone", info.getPhone());
			}

		}
		return old;
	}
}
