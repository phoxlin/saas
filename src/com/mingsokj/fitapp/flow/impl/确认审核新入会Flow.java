package com.mingsokj.fitapp.flow.impl;

import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.flow.Flow;
import com.mingsokj.fitapp.ws.bg.set.SysSet;

/**
* @author liul
* 2017年8月18日上午10:38:38
*/
public class 确认审核新入会Flow extends Flow {

	@Override
	public void beforeData() throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void saveData() throws Exception {
		String id = this.getFormDataVal("id");
		String gym = this.getFormDataVal("gym");
		String cust_name = this.getFormDataVal("cust_name");
		String emp_id = this.getFormDataVal("emp_id");
		String card_type = this.getFormDataVal("card_type");
		String caPrice = Integer.parseInt(this.getFormDataVal("caPrice")) * 100 +"";
		Entity entity = new EntityImpl("f_user_card",this.getAct().getConnection());
		Entity en = new EntityImpl("f_user_card",this.getAct().getConnection());
		entity.setTablename("f_user_card_"+gym);
		en.setTablename("f_user_card_"+gym);
		//拿到应收价格
		en.setValue("id", id);
		int size = en.search();
		if (size > 0) {
			String ca_amt = en.getStringValue("ca_amt");
			String card_state = en.getStringValue("buy_for_app");//拿到开卡的方式
			entity.setValue("ca_amt", ca_amt);
			entity.setValue("state", card_state);
		}
		setPayEntityInfo(entity, caPrice);
		entity.setValue("id", id);
		entity.setValue("examine_emp_id", emp_id);
		entity.setValue("buy_for_app", "N");
		
		try {
			entity.update();
		} catch (Exception e) {
			entity.updateAll();
		}
		getAct().obj.put("contractType", card_type);
		getAct().obj.put("buy_id", id);
		
		//是否打印合同
		String printContract = SysSet.getValues(cust_name, gym, "set_xiao_print", "printContract", this.getAct().getConnection());
		if(Utils.isNull(printContract)){
			printContract = "ok";
		}
		this.getAct().obj.put("printContract", printContract);
	}

	@Override
	public String getSmsWords() throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String getSmsPhoneNumber() throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

}
