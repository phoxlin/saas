package com.mingsokj.fitapp.ws.app.mem;

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
* @author liul
* 2017年9月19日下午4:42:19
*/
public class 预约私教 extends BasicAction {
	
	/**
	 * 会员预约私教
	 * @Title: queryBodyDataListByMemId
	 * @author: liul
	 * @date: 2017年9月19日下午4:42:47
	 * @throws Exception
	 */
	@Route(value = "/fit-ws-app-memPrivateOrder", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void memPrivateOrder() throws Exception {
		String gym = this.getParameter("gym");
		String cust_name = this.getParameter("cust_name");
		String mem_id = this.getParameter("mem_id");
		String start_time = this.getParameter("start_time");
		String end_time = this.getParameter("end_time");
		String pt_id = this.getParameter("pt_id");
		String role = this.getParameter("role");
		String date = this.getParameter("date");
		Entity en = new EntityImpl("f_private_order",this);
		/*List<Map<String, Object>> memCards = MemUtils.getMemCards(mem_id, cust_name, gym);
		boolean flag = true;
		for (Map<String, Object> map : memCards) {
			String card_type = map.get("card_type")+"";
			if ("006".equals(card_type)) {
				flag = false;
			}
		}
		if (flag) {
			throw new Exception("预约教练需要私教卡");
		}*/
		if (Utils.isNull(start_time) || Utils.isNull(end_time)) {
			throw new Exception("请填写上课时间");
		}
		//int size = en.executeQuery("select * from f_private_order_"+gym+" where mem_id=? and emp_id=? and start_time < ? and end_time > ?", new String[]{mem_id,pt_id,end_time,start_time});
		int size =en.executeQuery("select id from f_private_order_"+gym+" where emp_id = ?  and TO_DAYS(?) = TO_DAYS(start_time) and (start_time = ? or (start_time < ? and end_time > ?) or (start_time < ? and end_time > ?))",new Object[]{pt_id,date,start_time,start_time,start_time,end_time,end_time});

		if (size > 0) {
			throw new Exception("该时段已被预约,请重新选择.");
		}
		en = new EntityImpl("f_private_order",this);
		en.setTablename("f_private_order_"+gym);
		en.setValue("gym", gym);
		en.setValue("cust_name", cust_name);
		en.setValue("mem_id", mem_id);
		en.setValue("emp_id", pt_id);
		en.setValue("start_time", start_time);
		en.setValue("end_time", end_time);
		en.setValue("create_time", new Date());
		en.setValue("op_id", mem_id);
		en.setValue("is_update", "Y");//是否可以修改
		if("pt".equals(role)){
			en.setValue("state", "002");//002已确认
		}else{
			en.setValue("state", "001");//001待确认

		}
		en.create();
	}
	
	/**
	 * 查询预约的私教
	 * @Title: queryPrivateOrder
	 * @author: liul
	 * @date: 2017年9月19日下午5:22:13
	 * @throws Exception
	 */
	@Route(value = "/fit-ws-app-queryPrivateOrder", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void queryPrivateOrder() throws Exception {
		String gym = this.getParameter("gym");
		String cust_name = this.getParameter("cust_name");
//		String mem_id = this.getParameter("mem_id");
		String pt_id = this.getParameter("pt_id");
		String start_time = this.getParameter("start_time");//查询的时间
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date startDate = sdf.parse(start_time);
//		String startTime = sdf.format(startDate);
		Entity en = new EntityImpl("f_private_order",this);
	    //int s = en.executeQuery("select * from f_private_order_"+gym+" where  emp_id=? and START_TIME like ?", new String[]{pt_id,"%"+startTime+"%"});
	    int s = en.executeQuery("select * from f_private_order_"+gym+" where  emp_id=? and TO_DAYS(?) = TO_DAYS(start_time)", new String[]{pt_id,start_time});
	    if(s >0){
	    	List<Map<String, Object>> list = en.getValues();
	    	for(int i=0;i<s;i++){
	    		MemInfo mem = MemUtils.getMemInfo(en.getStringValue("mem_id",i), cust_name);
	    		if(mem!=null){
	    			list.get(i).put("mem_name", mem.getName());
	    			list.get(i).put("headurl", mem.getWxHeadUrl());
	    		}
	    	}
	    	this.obj.put("list", list);
	    }
	    MemInfo pt = MemUtils.getMemInfo(pt_id, cust_name);
	    if(pt!=null){
	    	this.obj.put("pt",pt.toTitleMap());
	    }
	    
	}
	
	/**
	 * 会员取消私教预约
	 * @Title: cancelPrivateOrder
	 * @author: liul
	 * @date: 2017年9月20日上午11:27:31
	 * @throws Exception
	 */
	@Route(value = "/fit-ws-app-memCancelPrivateOrder", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void cancelPrivateOrder() throws Exception {
		String gym = this.getParameter("gym");
//		String mem_id = this.getParameter("mem_id");
//		String pt_id = this.getParameter("pt_id");
		String order_id = this.getParameter("order_id");//拿到预约的id
		Entity en = new EntityImpl("f_private_order",this);
		en.setTablename("f_private_order_"+gym);
		en.setValue("id", order_id);
		en.delete();
	}
	
	/**
	 * 修改预约详情
	 * @Title: updatePrivateOrder
	 * @author: liul
	 * @date: 2017年9月20日上午11:38:08
	 * @throws Exception
	 */
	@Route(value = "/fit-ws-app-updatePrivateOrder", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void updatePrivateOrder() throws Exception {
		String gym = this.getParameter("gym");
//		String cust_name = this.getParameter("cust_name");
//		String mem_id = this.getParameter("mem_id");
		String start_time = this.getParameter("start_time");
		String end_time = this.getParameter("end_time");
		String pt_id = this.getParameter("pt_id");
		String date = this.getParameter("date");
		String order_id = this.getParameter("order_id");//拿到预约的id
		if (Utils.isNull(start_time) || Utils.isNull(end_time)) {
			throw new Exception("请填写上课时间");
		}
		Entity en = new EntityImpl("f_private_order",this);
		int size =en.executeQuery("select id from f_private_order_"+gym+" where emp_id = ?  and TO_DAYS(?) = TO_DAYS(start_time) and (start_time = ? or (start_time < ? and end_time > ?) or (start_time < ? and end_time > ?))",new Object[]{pt_id,date,start_time,start_time,start_time,end_time,end_time});
		if(size>0){
			if(!order_id.equals(en.getStringValue("id"))){
				throw new Exception("该时间段已被预约,请重新选择.");
			}
		}
		
		en.setTablename("f_private_order_"+gym);
		en.setValue("id", order_id);
		en.setValue("start_time", start_time);
		en.setValue("end_time", end_time);
		en.setValue("pt_id", pt_id);
		en.update();
	}
	
	/**
	 * 教练确认预约
	 * @Title: isOkPrivateOrder
	 * @author: liul
	 * @date: 2017年9月20日下午2:13:55
	 * @throws Exception
	 */
	@Route(value = "/fit-ws-app-isOkPrivateOrder", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void isOkPrivateOrder() throws Exception {
		String gym = this.getParameter("gym");
//		String cust_name = this.getParameter("cust_name");
//		String mem_id = this.getParameter("mem_id");
		String start_time = this.getParameter("start_time");
		String end_time = this.getParameter("end_time");
//		String pt_id = this.getParameter("pt_id");
		String order_id = this.getParameter("order_id");//拿到预约的id
		if (Utils.isNull(start_time) || Utils.isNull(end_time)) {
			//throw new Exception("请填写上课时间");
		}
		Entity en = new EntityImpl("f_private_order",this);
		en.setTablename("f_private_order_"+gym);
		en.setValue("id", order_id);
		en.setValue("state", "002");//状态002，教练确认预约
		en.update();
	}
}
