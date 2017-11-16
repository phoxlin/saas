package com.mingsokj.fitapp.ws.app;

import java.io.File;
import java.text.SimpleDateFormat;
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

/**
 * @author liul 2017年8月3日下午3:05:01
 */
public class MyCards extends BasicAction {

	/**
	 * 获取我的会员卡
	 * 
	 * @Title: getMyCards
	 * @author: liul
	 * @date: 2017年8月3日下午3:05:25
	 * @throws Exception
	 */
	@Route(value = "/yp-ws-app-getMyCards", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void getMyCards() throws Exception {
		String cust_name = this.getParameter("cust_name");
		String gym = this.getParameter("gym");
		String id = this.getParameter("id");
		Entity en = new EntityImpl(this);
		/**
		 * 查询用户的会员卡
		 */
		int size = en.executeQuery("select state from f_mem_" + cust_name + " where id=?", new Object[] { id });
		if (size > 0) {
			/*
			 * String state = en.getStringValue("state"); en = new
			 * EntityImpl(this); String sql =
			 * " select a.*,b.card_name,b.card_type,b.id card_id from f_user_card_"
			 * + gym +
			 * " a,f_card b where a.card_id = b.id and a.mem_id=? and a.gym=? and a.state in('001','002','003','004')"
			 * ; size = en.executeQuery(sql, new Object[] { id, gym }); if (size
			 * > 0) { List<Map<String, Object>> cardList = en.getValues();
			 * 
			 * for (int i = 0; i < cardList.size(); i++) { Date active_time =
			 * (Date) cardList.get(i).get("active_time"); Date deadline = (Date)
			 * cardList.get(i).get("deadline"); if (active_time != null) {
			 * cardList.get(i).put("active_time", sdf.format(active_time)); }
			 * else { cardList.get(i).put("active_time", ""); } if (deadline !=
			 * null) { cardList.get(i).put("deadline", sdf.format(deadline)); }
			 * else { cardList.get(i).put("deadline", "未激活"); } }
			 */

			// }
			List<Map<String, Object>> cardList = MemUtils.getMemCards(id, gym, cust_name, L);
			if (cardList != null && cardList.size() > 0) {

				this.obj.put("cards", cardList);
			}
		}
		String logo_url = "app/images/" + cust_name + "/card_logo.png";
		File file = new File(logo_url);
		if (!file.exists()) {
			logo_url = "app/images/card_logo.png";
		}
		this.obj.put("logo_url", logo_url);
	}

	/**
	 * 获取卡详情
	 * 
	 * @Title: getMyCardsMsg
	 * @author: liul
	 * @date: 2017年8月3日下午3:54:38
	 * @throws Exception
	 */
	@Route(value = "/yp-ws-app-getMyCardsMsg", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void getMyCardsMsg() throws Exception {

		String cust_name = this.getParameter("cust_name");
		String gym = this.getParameter("gym");
		String id = this.getParameter("id");
		String mem_id = this.getParameter("mem_id");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Map<String, Object> cards = MemUtils.getMemCardsById(id, mem_id, cust_name, gym);
		if (cards != null) {
			MemInfo info = MemUtils.getMemInfo(mem_id, cust_name);
			String card_type = Utils.getMapStringValue(cards, "card_type");
			Date deadline = Utils.getMapDateValue(cards, "deadline");
			Date active = Utils.getMapDateValue(cards, "active_time");
			if (deadline != null && active != null) {
				String active_time = sdf.format(active);
				long endTime = deadline.getTime();
				long nowTime = new Date().getTime();
				long days = (endTime - nowTime) / (1000 * 60 * 60 * 24);

				String deadline2 = sdf.format(deadline);
				cards.put("active_time", active_time);
				cards.put("mem_no", info.getMem_no());
				cards.put("REMAIN_AMT", info.getRemainAmt());
				cards.put("deadline", deadline2);
				if (endTime > nowTime) {
					cards.put("days", days);
				} else {
					cards.put("days", "已过期");
				}
			} else {
				cards.put("days", "卡未激活");
			}
			this.obj.put("cards", cards);
			/*
			 * 生成二维码 a:会员id b:买卡id g:gym t : card_type
			 * 
			 */
			String str = mem_id + "," + id + "," + gym + "," + card_type + "," + System.currentTimeMillis();
			this.obj.put("str", str);
		} else {
			throw new Exception("未查看卡详情");
		}
		String logo_url = "app/images/" + cust_name + "/card_logo.png";
		File file = new File(logo_url);
		if (!file.exists()) {
			logo_url = "app/images/card_logo.png";
		}
		this.obj.put("logo_url", logo_url);
	}
}
