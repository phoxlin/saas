package com.mingsokj.fitapp.ws.app;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.utils.MemUtils;

public class 买卡获取卡片 extends BasicAction {
	@Route(value = "/yp-ws-app-getCardsDetial", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void getCardsDetial() throws Exception {
		String card_id = this.getParameter("card_id");
		// String gym = this.getParameter("gym");
		String cust_name = this.getParameter("cust_name");
		String id = this.getParameter("id");
		Entity en = new EntityImpl(this);
		int size = en.executeQuery("select a.* from f_card a where id=? ", new Object[] { card_id });
		if (size > 0) {
			MemInfo info = MemUtils.getMemInfo(id, cust_name, L, true, this.getConnection());
			List<MemInfo> list = new ArrayList<>();
			list.add(info);
			this.obj.put("list", list);
			this.obj.put("data", en.getValues().get(0));
		}
	}

	@Route(value = "/yp-ws-app-getCards", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void getCards() throws Exception {
		String cust_name = this.getParameter("cust_name");
		String gym = this.getParameter("gym");
		Entity en = new EntityImpl(this);
		en.executeQuery(
				"select a.* from f_card a, f_card_gym b where a.show_app = 'Y' and a.id = b.fk_card_id and b.view_gym =? and (is_fanmily !='Y' or is_fanmily is null) and a.card_type !='005' ",
				new Object[] { gym });
		List<Map<String, Object>> cardList2 = en.getValues();
		this.obj.put("cards", cardList2);
		String logo_url = "app/images/" + cust_name + "/card_logo.png";
		File file = new File(logo_url);
		if (!file.exists()) {
			logo_url = "app/images/card_logo.png";
		}
		this.obj.put("logo_url", logo_url);
	}
}
