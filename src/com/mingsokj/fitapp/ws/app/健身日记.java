package com.mingsokj.fitapp.ws.app;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

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
* @author liul
* 2017年8月2日下午6:03:29
*/
public class 健身日记 extends BasicAction {
	/**
	 * map 排序方法
	 * @author liul
	 *
	 * 2017年8月2日
	 */
	static class MapComparatorAsc implements Comparator<Map<String, Object>> {
        @Override
        public int compare(Map<String, Object> m1, Map<String, Object> m2) {
            Long v1 = Long.valueOf(m1.get("times").toString());
            Long v2 = Long.valueOf(m2.get("times").toString());
            if(v1 != null){
                return v2.compareTo(v1);
            }
            return 0;
        }
  
    }
	
	@Route(value = "fit-ws-app-showJour", conn = true,  m = HttpMethod.POST, type = ContentType.JSON)
	public void showJour() throws Exception {
		String cust_name = request.getParameter("cust_name");
		String gym = request.getParameter("gym");
		String id = request.getParameter("id");
		int cur = Integer.parseInt(request.getParameter("cur"));
		int size = 0;
		List<Map<String, Object>> list = new ArrayList<>();
		List<Map<String, Object>> listFina = new ArrayList<>();
		List<Map<String, Object>> listCheck = new ArrayList<>();
		List<Map<String, Object>> listCheckOut = new ArrayList<>();
		List<Map<String, Object>> listCard = new ArrayList<>();
		List<Map<String, Object>> listOther = new ArrayList<>();
		List<Map<String, Object>> listFlow = new ArrayList<>();
		List<Map<String, Object>> listLevel = new ArrayList<>();
		Entity en = new EntityImpl(this);
		//入场记录
		size = en.executeQuery("SELECT CHECKIN_TIME as op_time, CHECKIN_FEE as free,CHECKOUT_TIME,CHECKIN_CARD_NAME as op_name from f_checkin_"+gym+" WHERE MEM_ID=? order by op_time desc", new String[] { id });
		if (size > 0) {
			listCheck = en.getValues();
			for (int i = 0; i < listCheck.size(); i++) {
				Date date = en.getDateValue("op_time",i);
				long times = date.getTime();
				listCheck.get(i).put("times", times);
				listCheck.get(i).put("name", "入场");
				//判断是否支付，如果支付将价格封装到list中
				String free = en.getStringValue("free",i);
				if ("".equals(free)) {
					listCheck.get(i).put("free", "0");
				}
				
			}
			list.addAll(listCheck);
		}
		//出场
		size = en.executeQuery("SELECT CHECKOUT_TIME as op_time ,CHECKIN_CARD_NAME as op_name from f_checkin_"+gym+" WHERE MEM_ID=? AND CHECKOUT_TIME is not null order by op_time desc", new String[] { id });
		if (size > 0) {
			listCheckOut = en.getValues();
			for (int i = 0; i < listCheckOut.size(); i++) {
				Date date = en.getDateValue("op_time",i);
				long times = date.getTime();
				listCheckOut.get(i).put("times", times);
				listCheckOut.get(i).put("name", "出场");
				listCheckOut.get(i).put("free", "0");
				
			}
			list.addAll(listCheckOut);
		}
		
		//购卡记录
		size = en.executeQuery("SELECT a.BUY_TIME as op_time,a.REAL_AMT as free,c.CARD_NAME as op_name FROM f_user_card_"+gym+" a,f_mem_" + cust_name + " b,f_card c WHERE a.CARD_ID=c.ID AND b.ID=a.MEM_ID AND MEM_ID=? order by op_time desc", new String[] { id });
		if (size > 0) {
			listCard = en.getValues();
			for (int i = 0; i < listCard.size(); i++) {
				Date date = en.getDateValue("op_time",i);
				long times = date.getTime();
				listCard.get(i).put("times", times);
				listCard.get(i).put("name", "购卡");
				
			}
			list.addAll(listCard);
		}
		//其他支付记录
		size = en.executeQuery("SELECT pay_time as op_time,pay_type as op_name,REAL_AMT as free from f_other_pay_"+gym+" WHERE mem_id=? order by op_time desc", new String[] { id });
		if (size > 0) {
			listOther = en.getValues();
			for (int i = 0; i < listOther.size(); i++) {
				Date date = en.getDateValue("op_time",i);
				long times = date.getTime();
				listOther.get(i).put("times", times);
				listOther.get(i).put("name", "其他支付");
				
			}
			list.addAll(listOther);
		}
		//流水记录
		size = en.executeQuery("SELECT op_time,flow_type as op_name from f_flow_"+gym+" WHERE mem_id=? order by op_time desc", new String[] { id });
		if (size > 0) {
			listFlow = en.getValues();
			for (int i = 0; i < listFlow.size(); i++) {
				Date date = en.getDateValue("op_time",i);
				long times = date.getTime();
				listFlow.get(i).put("times", times);
				listFlow.get(i).put("name", "流水记录");
				listFlow.get(i).put("free", "0");
				
			}
			list.addAll(listFlow);
		}
		//请假记录
		size = en.executeQuery("SELECT pay_time as op_time,REAL_AMT as free from f_leave WHERE MEM_ID=? order by op_time desc", new String[] { id });
		if (size > 0) {
			listLevel = en.getValues();
			for (int i = 0; i < listLevel.size(); i++) {
				Date date = en.getDateValue("op_time",i);
				long times = date.getTime();
				listLevel.get(i).put("times", times);
				listLevel.get(i).put("name", "请假记录");
				listLevel.get(i).put("op_name", "请假");
				//判断是否支付，如果支付将价格封装到list中
				String free = en.getStringValue("free",i);
				if ("".equals(free)) {
					listLevel.get(i).put("free", "0");
				}
				
			}
			list.addAll(listLevel);
		}
		MemInfo m = MemUtils.getMemInfo(id, cust_name);
		String userGym = m.getGym();
		//打卡记录
		size = en.executeQuery("SELECT sign_time as op_time,remark,'打卡' name from f_sign_month_"+userGym+" WHERE user_id=? order by sign_time asc", new String[] { id });
		if (size > 0) {
			for (int i = 0; i < en.getValues().size(); i++) {
				String remark = en.getStringValue("remark",i);
				en.getValues().get(i).put("op_name", "第"+(i+1)+"天."+remark);
				Date date = en.getDateValue("op_time",i);
				long times = date.getTime();
				en.getValues().get(i).put("times", times);
				//判断是否支付，如果支付将价格封装到list中
				en.getValues().get(i).put("free", "0");
			}
			list.addAll(en.getValues());
		}
		//对list进行时间排序
		Collections.sort(list, new MapComparatorAsc());
		String state = "";
		if (list.size() >=cur) {
			state = "Y";
			for (int i = 0; i < cur; i++) {
				listFina.add(list.get(i));
			}
		}else{
			state = "N";
			for (int i = 0; i < list.size(); i++) {
				listFina.add(list.get(i));
			}
		}
		
		Set<String> dates = new LinkedHashSet<String>();
		for(int i=0; i<listFina.size(); i++){
			String op_time = listFina.get(i).get("op_time").toString();
			String date = Utils.parseData(Utils.parse2Date(op_time, "yyyy-MM-dd"), "yyyy-MM-dd");
			dates.add(date);
		}
		this.obj.put("list", listFina);
		this.obj.put("state", state);
		this.obj.put("dates", dates);
	}
	
}
