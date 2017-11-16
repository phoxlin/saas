package com.mingsokj.fitapp.tool.hook;

import java.util.List;
import java.util.Map;

import com.jinhua.server.ms.QmHook;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.utils.MemUtils;

public class ActiveWordsHook extends QmHook {

	@Override
	public List<Map<String, Object>> getTrimedSet() throws Exception {

		List<Map<String, Object>> list = this.getRawResultSet();
		if (list != null && list.size() > 0) {
			String gym = null;
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> map = list.get(i);
				String id = Utils.getMapStringValue(map, "fk_user_id");
				if (Utils.isNull(gym)) {
					gym = Utils.getMapStringValue(map, "fk_user_gym");
				}
				MemInfo info = MemUtils.getMemInfo(id, gym.replaceAll("\\d*",""));
				if (info != null) {
					map.put("mem_name", info.getName());
				}
			}
		}
		return list;
	}

}
