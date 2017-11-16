package com.mingsokj.fitapp.ws.app;

import java.util.ArrayList;
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
import com.mingsokj.fitapp.m.FitUser;
import com.mingsokj.fitapp.utils.MemUtils;

public class 卡种管理 extends BasicAction {
	@Route(value = "/fit-ws-bg-Mem-getCardDetial", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void getCardDetial() throws Exception {
		String card_id = this.getParameter("card_id");
		String sql = "select id,card_name,days,fee,amt,times,leave_days,card_type,is_fanmily from f_card where  id=?";
		Entity en = new EntityImpl(this);
		int size = en.executeQuery(sql, new Object[] { card_id });
		if (size > 0) {
			this.obj.put("data", en.getValues().get(0));
			// 查询可见会所
			en = new EntityImpl(this);
			size = en.executeQuery("select view_gym from f_card_gym where fk_card_id = ?", new Object[] { card_id });
			if (size > 0) {
				this.obj.put("view_gym", en.getValues());
			}
		} else {
			throw new Exception("没有查询到相关信息，请刷新页面后重试");
		}

	}

	@Route(value = "/fit-ws-bg-Mem-getCard006", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void getCard006() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = this.getParameter("gym");
		if ("".equals(gym) || gym == null) {
			gym = user.getViewGym();
		}
		String sql = "select a.id,a.card_name from f_card a where a.card_type='006' and a.gym='" + gym
				+ "'  and a.state='001' GROUP BY a.id";
		Entity en = new EntityImpl(this);
		en.executeQuery(sql);
		this.obj.put("data", en.getValues());

	}

	@Route(value = "/fit-ws-bg-Mem-getCard", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void getCard() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = this.getParameter("gym");
		String cust_name = "";
		if (user != null) {
			cust_name = user.getCust_name();
		} else {
			cust_name = this.getParameter("cust_name");
		}
		String fk_user_id = this.getParameter("fk_user_id");
		if ("".equals(gym) || gym == null) {
			gym = user.getViewGym();
		}
		String card_type = this.getParameter("card_type");
		String sql = "select a.id,a.card_name,a.IS_FANMILY from f_card a ,f_card_gym b  where  a.id = b.FK_CARD_ID  ";

		if (card_type != null && !"".equals(card_type)) {
			sql += " and b.view_gym= '" + gym + "' and a.card_type=? ";
			Entity en = new EntityImpl(this);
			// 如果客户未购买会员卡，查询可以单独购买的私教卡
			if (fk_user_id != null && !"null".equals(fk_user_id) && !"".equals(fk_user_id) && "006".equals(card_type)) {
				List<Map<String, Object>> cardList = MemUtils.getMemCards(fk_user_id, cust_name, gym);
				if (cardList.size() > 0) {
					ArrayList<String> cardTypeList = new ArrayList<>();
					for (int i = 0; i < cardList.size(); i++) {
						Map<String, Object> card = cardList.get(i);
						String user_card_type = card.get("card_type") + "";
						cardTypeList.add(user_card_type);
					}

					if (cardTypeList.contains("001") || cardTypeList.contains("002") || cardTypeList.contains("003")) {

					} else {
						sql += " and a.is_lession_only='Y' ";
					}
				} else {
					if ("006".equals(card_type)) {
						sql += " and a.is_lession_only='Y' ";
					}
				}
			} else {
				if ("006".equals(card_type)) {
					sql += " and a.is_lession_only='Y' ";
				}
			}
			sql += " and a.state='001'";
			en = new EntityImpl(this);
			en.executeQuery(sql + " GROUP BY a.id", new Object[] { card_type });
			this.obj.put("data", en.getValues());
		} else {
			Entity en = new EntityImpl(this);
			en.executeQuery(sql, new Object[] { gym });
			this.obj.put("data", en.getValues());
		}

	}

	@Route(value = "/fit-ws-bg-Mem-getCard-list-detail", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void getCardListDetail() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String card_type = this.getParameter("card_type");
		String sql = "";
		if (card_type != null && !"".equals(card_type)) {
			sql = "select * from f_card where gym=? and card_type=?";
			Entity en = new EntityImpl(this);
			en.executeQuery(sql, new Object[] { user.getViewGym(), card_type });
			List<Map<String, Object>> list = en.getValues();
			for (Map<String, Object> map : list) {
				map.remove("content");
			}
			this.obj.put("data", list);
		} else {
			sql = "select * from f_card where gym=?";
			Entity en = new EntityImpl(this);
			en.executeQuery(sql, new Object[] { user.getViewGym() });
			List<Map<String, Object>> list = en.getValues();
			for (Map<String, Object> map : list) {
				map.remove("content");
			}
			this.obj.put("data", list);
		}

	}

	/**
	 * 会员管理-添加卡种
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-ws-bg-Mem-addDaysCard", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void addMem() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();

		String f_card__show_app = this.getParameter("f_card__show_app");
		String f_card__app_amt = this.getParameter("f_card__app_amt");
		String f_card__is_share = this.getParameter("f_card__is_share");
		String f_card__count = this.getParameter("f_card__count");
		String f_card__is_lession_only = this.getParameter("f_card__is_lession_only");
		String f_card__labels = this.getParameter("f_card__labels");
		String f_card__checkin_fee = this.getParameter("f_card__checkin_fee");
		String f_card__summary = this.getParameter("f_card__summary");

		String card_type = this.getParameter("card_type");
		String card_name = this.getParameter("card_name");
		String card_days = this.getParameter("card_days");
		String card_times = this.getParameter("card_times");
		String card_amt = this.getParameter("card_amt");
		String is_fanmily = this.getParameter("is_fanmily");
		// String share = this.getParameter("share");
		String card_fee = this.getParameter("card_fee");
		String card_leave_free_times = this.getParameter("card_leave_free_times");
		String card_leave_unit = this.getParameter("card_leave_unit");
		String card_leave_unit_price = this.getParameter("card_leave_unit_price");
		// String checkin_fee = this.getParameter("checkin_fee");
		String viewGyms = this.getParameter("viewGym");
		// String card_leave_days = this.getParameter("card_leave_days");
		Entity en = new EntityImpl("f_card", this);
		en.setValue("cust_name", user.getCust_name());
		en.setValue("gym", user.getViewGym());
		if (card_days != null && !"".equals(card_days)) {
			en.setValue("days", card_days);
		}
		if (card_times != null && !"".equals(card_times)) {
			en.setValue("times", card_times);
			// en.setValue("is_share", share);
		}
		if (card_amt != null && !"".equals(card_amt)) {
			en.setValue("amt", card_amt);
			// en.setValue("is_share", share);
		}

		en.setValue("fee", card_fee);
		en.setValue("card_name", card_name);
		en.setValue("card_type", card_type);
		en.setValue("leave_free_times", card_leave_free_times);
		en.setValue("leave_unit", card_leave_unit);
		en.setValue("leave_unit_price", card_leave_unit_price);
		en.setValue("op_time", new Date());
		en.setValue("op_user_id", user.getId());
		en.setValue("state", "001");
		en.setValue("show_app", "N");
		en.setValue("is_fanmily", is_fanmily);
		en.setValue("summary", f_card__summary);
		if (Utils.isNull(f_card__show_app)) {
			f_card__show_app = "N";
		}
		en.setValue("show_app", f_card__show_app);
		en.setValue("app_amt", f_card__app_amt);
		en.setValue("is_share", f_card__is_share);
		en.setValue("count", f_card__count);
		en.setValue("is_lession_only", f_card__is_lession_only);
		en.setValue("labels", f_card__labels);
		en.setValue("checkin_fee", f_card__checkin_fee);

		String fk_card_id = en.create();

		if (viewGyms != null && !"".equals(viewGyms)) {
			String[] viewGym = viewGyms.split(",");
			for (String vg : viewGym) {
				en = new EntityImpl("f_card_gym", this);
				en.setValue("cust_name", user.getCust_name());
				en.setValue("gym", user.getViewGym());
				en.setValue("fk_card_id", fk_card_id);
				en.setValue("view_gym", vg);
				en.create();
			}

		} else {

			en = new EntityImpl("f_card_gym", this);
			en.setValue("cust_name", user.getCust_name());
			en.setValue("gym", user.getViewGym());
			en.setValue("fk_card_id", fk_card_id);
			en.setValue("view_gym", user.getViewGym());
			en.create();
		}

	}

	/**
	 * 在线购卡-添加卡种
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-ws-bg-add-card-online", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void addCard() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		if (user == null) {
			request.getRequestDispatcher("/").forward(request, response);
		}

		String cust_name = user.getCust_name();
		String gym = user.getViewGym();

		String e = request.getParameter("e");
		Entity card = this.getEntityFromPage(e);

		String card_id = null;
		// 添加可见会所
		String type = this.getParameter("m");
		if ("add".equals(type)) {
			card_id = card.create();
		} else {
			card_id = card.getStringValue("id");
			card.update();
		}

		if (user.is系统管理员() && user.hasPower("sm_buycards")) {
			Entity en = new EntityImpl("f_card_gym", this);
			en.executeUpdate("delete from f_card_gym where fk_card_id = ?", new Object[] { card_id });
			String[] viewGym = this.getParameterValues("viewGym");
			if (viewGym != null && viewGym.length > 0) {
				for (int i = 0; i < viewGym.length; i++) {
					en = new EntityImpl("f_card_gym", this);
					en.setValue("cust_name", cust_name);
					en.setValue("gym", gym);
					en.setValue("fk_card_id", card_id);
					en.setValue("view_gym", viewGym[i]);
					en.create();
				}
			} else {
				en.setValue("cust_name", cust_name);
				en.setValue("gym", gym);
				en.setValue("fk_card_id", card_id);
				en.setValue("view_gym", gym);
				en.create();
			}
		}

	}
}
