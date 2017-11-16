package com.mingsokj.fitapp.ws.app.sales;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;

public class 销售报表 extends BasicAction {

	/**
	 * 员工在当前会所的销售记录
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-app-action-mcSalesReport", conn = true,  m = HttpMethod.POST, type = ContentType.JSON)
	public void mcSalesReportr() throws Exception {
		String curGym = request.getParameter("curGym");
		String cust_name = request.getParameter("cust_name");
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
		//销售信息
		Entity en = new EntityImpl(this);
		StringBuilder sql = new StringBuilder();
		sql.append("select sum(cast(a.real_amt as UNSIGNED INTEGER)) total_amt")
			.append(",sum(cast(a.buy_times as UNSIGNED INTEGER)) total_times")
			.append(",count(a.id) sales_num")
			.append(",b.card_type")
			.append(" from f_user_card_" + curGym +" a,f_card b where a.card_id = b.id and a.mc_id = ?");
		//总共
		String allSql = sql.toString() +" and a.state!='010' group by b.card_type";
		int s= en.executeQuery(allSql,new Object[]{emp_id});
		if(s >0){
			this.obj.put("allInfo",en.getValues());
		}
		//当月
		String monthSql = sql.toString() +" and a.state!='010' and a.pay_time between ? and ? group by b.card_type";
		s= en.executeQuery(monthSql,new Object[]{emp_id,first_day,last_day});
		if(s >0){
			this.obj.put("monthInfo",en.getValues());
		}
		
		//当天
		String dateSql = sql.toString() +" and a.state!='010' and TO_DAYS(a.pay_time) = TO_DAYS(?) group by b.card_type";
		s = en.executeQuery(dateSql,new Object[]{emp_id,date});
		if(s >0){
			this.obj.put("dayInfo",en.getValues());
		}
		//会员信息
		en = new EntityImpl(this);
		//添加会员 添加潜客
		StringBuilder memSql = new StringBuilder();
		memSql.append("select count(id) num,state,'all' type from f_mem_"+cust_name+" where gym = '"+curGym+"' and state in('001','003','004') and mc_id = ? group by state")
					.append(" union select count(id),state,'month'   from f_mem_"+cust_name+" where gym = '"+curGym+"' and state in('001','003','004') and mc_id = ? and create_time between ? and ?  group by state ")
					.append(" union select count(id),state,'day'   from f_mem_"+cust_name+" where gym = '"+curGym+"' and state in('001','003','004') and mc_id = ? and TO_DAYS(?) = TO_DAYS(create_time)  group by state");
		s = en.executeQuery(memSql.toString(),new Object[]{emp_id,emp_id,first_day,last_day,emp_id,date});
		if(s >0){
			this.obj.put("memInfo", en.getValues());
		}
		//维护会员 维护潜客
		en = new EntityImpl(this);
		StringBuilder maintainSql = new StringBuilder();
		/*maintainSql.append("select count(a.id) num,b.state,'all' type from f_mem_maintain_"+curGym+" a left join  f_mem_"+curGym+" b on a.mem_id = b.id where (a.type='mc' or a.type='qmc')  and b.state in('001','003') and a.op_id = ? GROUP BY b.state")
						.append(" union all select count(a.id),b.state,'month' type from f_mem_maintain_"+curGym+" a left join  f_mem_"+curGym+" b on a.mem_id = b.id where (a.type='mc' or a.type='qmc') and b.state in('001','003') and a.op_id = ? and a.op_time between ? and ? GROUP BY b.state")
						.append(" union all select count(a.id),b.state,'day' type from f_mem_maintain_"+curGym+" a left join  f_mem_"+curGym+" b on a.mem_id = b.id where (a.type='mc' or a.type='qmc') and b.state in('001','003') and a.op_id = ? and TO_DAYS(a.op_time) = TO_DAYS(?)  GROUP BY b.state");
		*/
		maintainSql.append("select count(a.id) num,a.type state,'all' type from f_mem_maintain_"+curGym+" a where  (a.type='mc' or a.type='pt') and a.op_id = ?  group by a.type")
		.append(" union all select count(a.id),a.type state,'month' type from f_mem_maintain_"+curGym+" a where  (a.type='mc' or a.type='pt')  and a.op_id = ? and a.op_time between ? and ?   group by a.type")
		.append(" union all select count(a.id),a.type state,'day' type from f_mem_maintain_"+curGym+" a  where  (a.type='mc' or a.type='pt') and a.op_id = ?  and TO_DAYS(a.op_time) = TO_DAYS(?)   group by a.type")
		.append(" union all select count(a.id) num,a.type state ,'all' type from f_mem_maintain_"+curGym+" a where  (a.type='qmc' or a.type='qpt') and a.op_id = ?   group by a.type")
		.append(" union all select count(a.id),a.type state,'month' type from f_mem_maintain_"+curGym+" a where  (a.type='qmc' or a.type='qpt') and a.op_id = ?  and a.op_time between ? and ?   group by a.type")
		.append(" union all select count(a.id),a.type state,'day' type from f_mem_maintain_"+curGym+" a  where  (a.type='qmc' or a.type='qpt') and a.op_id = ?  and TO_DAYS(a.op_time) = TO_DAYS(?)  group by a.type");
	
		
		s = en.executeQuery(maintainSql.toString(),new Object[]{emp_id,emp_id,first_day,last_day,emp_id,date,emp_id,emp_id,first_day,last_day,emp_id,date});
		
		if(s >0){
			this.obj.put("maintainInfo", en.getValues());
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}
