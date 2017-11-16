package com.mingsokj.fitapp.ws.app;

import java.util.ArrayList;
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

public class 收银记录 extends BasicAction {

	@Route(value = "/yp-ws-bg-moneyRecord", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void moneyRecord() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String cust_name = user.getCust_name();
		String gym = user.getViewGym();

		String type = request.getParameter("type");
		String cur = request.getParameter("cur");

		StringBuilder sb = new StringBuilder();
		List<String> params = new ArrayList<>();
		if ("timeCard".equals(type)) {
			// 时间卡、
			// sb.append("select a.*,b.mem_name,c.card_name from f_user_card_" +
			// gym + " a left join")
			sb.append("select a.*,b.phone,b.mem_name,c.card_name,c.card_type from f_user_card_" + gym + " a,f_mem_" + cust_name + " b,f_card c where a.mem_id = b.id and a.card_id = c.id and c.card_type ='001' and a.state != '010'");
		} else if ("moneyCard".equals(type)) {
			// 储值卡
			sb.append("select a.*,b.phone,b.mem_name,c.card_name,c.card_type from f_user_card_" + gym + " a,f_mem_" + cust_name + " b,f_card c where a.mem_id = b.id and a.card_id = c.id and c.card_type ='002' and a.state != '010'");
		} else if ("timesCard".equals(type)) {
			// 次卡
			sb.append("select a.*,b.phone,b.mem_name,c.card_name,c.card_type from f_user_card_" + gym + " a,f_mem_" + cust_name + " b,f_card c where a.mem_id = b.id and a.card_id = c.id and c.card_type ='003' and a.state != '010'");
		} else if ("privateCard".equals(type)) {
			// 私教卡
			sb.append("select a.*,b.phone,b.mem_name,c.card_name,c.card_type from f_user_card_" + gym + " a,f_mem_" + cust_name + " b,f_card c where a.mem_id = b.id and a.card_id = c.id and c.card_type ='006' and a.state != '010'");
		} else if ("onceCard".equals(type)) {
			// 散客购票
			sb.append("select a.*,b.card_name from  f_fit a,f_card b where a.card_id = b.id and a.cust_name = ? and a.gym = ?");
			params.add(cust_name);
			params.add(gym);
		} else if ("leave".equals(type)) {
			sb.append("select a.*,b.phone,b.mem_name from  f_leave a,f_mem_" + cust_name + " b where a.mem_id = b.id and a.cust_name = ? and a.gym = ?");
			params.add(cust_name);
			params.add(gym);
		} else if ("transCard".equals(type)) {
			sb.append("select a.*,b.phone,b.mem_name from  f_other_pay_" + gym + " a,f_mem_" + cust_name + " b where a.mem_id = b.id and a.pay_type = '转卡手续费'");
		} else if ("goods".equals(type)) {
			sb.append("select a.*,b.phone,b.mem_name,c.goods_name from f_store_rec_" + gym + " a left join f_mem_" + cust_name + " b on a.mem_id = b.id left join f_goods c on a.goods_id = c.id where a.type='004'");
		} else if ("box".equals(type)) {
			sb.append("select a.*,b.phone,b.mem_name from  f_other_pay_" + gym + " a,f_mem_" + cust_name + " b where a.mem_id = b.id and a.pay_type = '租柜费用'");
		} else if ("chargeInfo".equals(type)) {
			sb.append("select a.*,b.phone,b.mem_name from  f_other_pay_" + gym + " a,f_mem_" + cust_name + " b where a.mem_id = b.id and a.pay_type = '充值'");
		}else if("other".equals(type)){
			String otherPayType = request.getParameter("otherPayType");
			sb.append("select a.*,b.phone,b.mem_name from  f_other_pay_" + gym + " a,f_mem_" + cust_name + " b where a.mem_id = b.id ");
			if(!Utils.isNull(otherPayType)){
				sb.append(" and a.pay_type = '"+otherPayType+"'");
			}else{
				sb.append(" and a.pay_type not in ('充值','租柜费用','转卡手续费')");
			}
		}

		String start_time = request.getParameter("start_time");
		String end_time = request.getParameter("end_time");
		String mem_name = request.getParameter("mem_name");
		String mem_no = request.getParameter("mem_no");

		if (mem_name != null && !"".equals(mem_name)) {
			sb.append(" and b.mem_name like ?");
			params.add(mem_name);
		}

		if (mem_no != null && !"".equals(mem_no)) {
			if (mem_no.matches("^((13[0-9])|(15[0-9])|(17[0-9])|(18[0-9]))\\d{8}$")) {
				// 手机
				sb.append(" and b.phone = ?");
			} else {
				// 卡号
				sb.append(" and b.mem_no = ?");
			}
			params.add(mem_no);
		}

		if (start_time != null && !"".equals(start_time) && end_time != null && !"".equals(end_time)) {
			sb.append(" and a.pay_time between ? and ?");
			params.add(start_time + " 00:00:00");
			params.add(end_time + " 23:59:59");
		}
		sb.append(" order by a.pay_time desc");
		Entity en = new EntityImpl(this);

		int pageSize = 10;
		int curPage = Integer.parseInt(cur);
		int start = (curPage - 1) * pageSize + 1;
		int end = pageSize * curPage;

		en.executeQueryWithMaxResult(sb.toString(), params.toArray(), start, end);

		List<Map<String, Object>> list = en.getValues();
		// 价格处理
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> map = list.get(i);
			map.put("real_amt", Utils.toPriceFromLongStr(getValue(map, "real_amt") + ""));
			map.put("ca_amt", Utils.toPriceFromLongStr(getValue(map, "ca_amt") + ""));
			map.put("cash_amt", Utils.toPriceFromLongStr(getValue(map, "cash_amt") + ""));
			map.put("card_cash_amt", Utils.toPriceFromLongStr(getValue(map, "card_cash_amt") + ""));
			map.put("card_amt", Utils.toPriceFromLongStr(getValue(map, "card_amt") + ""));
			map.put("vouchers_amt", Utils.toPriceFromLongStr(getValue(map, "vouchers_amt") + ""));
			map.put("wx_amt", Utils.toPriceFromLongStr(getValue(map, "wx_amt") + ""));
			map.put("ali_amt", Utils.toPriceFromLongStr(getValue(map, "ali_amt") + ""));
		}

		int total = en.getMaxResultCount();
		int totalpage = 0;
		int temp = total / pageSize;
		totalpage = total % pageSize > 0 ? temp + 1 : temp > 0 ? temp : 1;

		this.obj.put("list", list);

		this.obj.put("total", total);
		this.obj.put("totalPage", totalpage);
		this.obj.put("curPage", curPage);
		this.obj.put("curSize", list.size());

	}

	public static String getValue(Map<String, Object> m, String key) {
		if (m.get(key) != null) {
			return m.get(key).toString();
		}
		return "0";
	}
}
