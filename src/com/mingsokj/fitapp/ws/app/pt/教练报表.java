package com.mingsokj.fitapp.ws.app.pt;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;

public class 教练报表 extends BasicAction{

	/**
	 * 员工在当前会所的销售记录
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-app-action-ptSalesReport", conn = true, slave = true , m = HttpMethod.POST, type = ContentType.JSON)
	public void ptSalesReportr() throws Exception {
		String curGym = request.getParameter("curGym");
//		String cust_name = request.getParameter("cust_name");
		String emp_id = request.getParameter("emp_id");
		String date = request.getParameter("date");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

		Date time = sdf.parse(date);
		String first_day = "";
		String last_day = "";

		Calendar cDay = Calendar.getInstance();
		cDay.setTime(time);
		cDay.set(Calendar.DAY_OF_MONTH, cDay.getActualMinimum(Calendar.DAY_OF_MONTH));
		first_day = sdf.format(cDay.getTime()) + " 00:00:00";
		cDay.set(Calendar.DAY_OF_MONTH, cDay.getActualMaximum(Calendar.DAY_OF_MONTH));
		last_day = sdf.format(cDay.getTime()) + " 23:59:59";
		
		
		//私教售课次数和售额
		Entity en = new EntityImpl(this);
		StringBuilder sql = new StringBuilder();
		sql.append("select sum(cast(a.real_amt as UNSIGNED INTEGER)) total_amt")
		.append(",sum(cast(a.buy_times as UNSIGNED INTEGER)) total_times")
		.append(",count(a.id) sales_num")
		.append(",b.card_type")
		.append(" from f_user_card_" + curGym +" a,f_card b where a.card_id = b.id and a.pt_id = ? and card_type ='006'");
		//总共
		int s= en.executeQuery(sql.toString(),new Object[]{emp_id});
		if(s >0){
			this.obj.put("allInfo",en.getValues());
		}
		//当月
		String monthSql = sql.toString() +"   and a.pay_time between ? and ?";
		s= en.executeQuery(monthSql,new Object[]{emp_id,first_day,last_day});
		if(s >0){
			this.obj.put("monthInfo",en.getValues());
		}
		
		//当天
		String dateSql = sql.toString() +"  and TO_DAYS(a.pay_time) = TO_DAYS(?)";
		s = en.executeQuery(dateSql,new Object[]{emp_id,date});
		if(s >0){
			this.obj.put("dayInfo",en.getValues());
		}
		StringBuilder sb = new StringBuilder();
		
		//团课消课
		sb.append("select sum(cast(a.MEM_NUMS as UNSIGNED INTEGER)) num,'all' type from f_class_record_" +curGym+" a,f_plan b where a.pt_id = ? and a.plan_id=b.id and b.card_names is not null")
		   .append(" union all select sum(cast(c.MEM_NUMS as UNSIGNED INTEGER)),'month' from f_class_record_" +curGym+" c,f_plan d where c.pt_id = ?  and c.end_time between ? and ? and c.plan_id=d.id and d.card_names is not null")
		   .append(" union all select sum(cast(e.MEM_NUMS as UNSIGNED INTEGER)),'day' from f_class_record_" +curGym+" e,f_plan f where e.pt_id = ?  and TO_DAYS(end_time) = TO_DAYS(?) and e.plan_id=f.id and f.card_names is not null");
		
		s = en.executeQuery(sb.toString(),new Object[]{emp_id,emp_id,first_day,last_day,emp_id,date});
		if(s >0){
			this.obj.put("reduceGClass", en.getValues());
		}
		
		//消课记录
		sb = new StringBuilder();
		sb.append("select count(id) num,'all' type from f_private_record_" +curGym+" where pt_id = ? and state = 'end'")
		.append(" union all select count(id),'month' from f_private_record_" +curGym+" where pt_id = ? and state = 'end' and end_time between ? and ?")
		.append(" union all select count(id),'day' from f_private_record_" +curGym+" where pt_id = ? and state = 'end' and TO_DAYS(end_time) = TO_DAYS(?)");
		
		s = en.executeQuery(sb.toString(),new Object[]{emp_id,emp_id,first_day,last_day,emp_id,date});
		if(s >0){
			this.obj.put("reduceClass", en.getValues());
		}
		
		//教练维护
		 sb = new StringBuilder();
		 sb.append("select count(id) num,'all' type from f_mem_maintain_"+curGym +" where (type = 'pt' or type='qpt') and op_id = ?")
		 	.append(" union all select count(id) ,'month' from f_mem_maintain_"+curGym +" where (type = 'pt' or type='qpt') and op_id = ? and op_time between ? and ?")
		 	.append(" union all select count(id) ,'day' from f_mem_maintain_"+curGym +" where (type = 'pt' or type='qpt') and op_id = ? and TO_DAYS(op_time) = TO_DAYS(?)");
		 s = en.executeQuery(sb.toString(),new Object[]{emp_id,emp_id,first_day,last_day,emp_id,date});
		 if(s >0){
				this.obj.put("maintainInfo", en.getValues());
			}
			
	}
}
