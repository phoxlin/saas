<%@page import="java.math.BigDecimal"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% 
	String rtotal="1000";
	String id=request.getParameter("id");
	String is_fit=request.getParameter("is_fit");
	String user_id=request.getParameter("user_id");
	String isExists=null;
	if(user_id==null||user_id.length()<=0){
		is_fit="Y";
	}
	String price=request.getParameter("price");
	String fk_customer_spend_id=request.getParameter("fk_customer_spend_id");
	String paytype=request.getParameter("paytype");
	String card_type=request.getParameter("card_type");
	if(card_type==null||card_type.length()<=0){
		card_type=(String)request.getAttribute("card_type");
	}
	String fk_to_card_id=request.getParameter("fk_to_card_id");
%>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">

<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<link href="public/jQuery/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css" />

<link rel="stylesheet" type="text/css" href="public/jQuery/easyui/css/easyui.css">
<link rel="stylesheet" type="text/css" href="public/jQuery/easyui/css/icon.css">

<script src="public/sb_admin2/bower_components/jquery/dist/jquery.min.js"></script>
<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/easyui-1.4.4/jquery.easyui.min.js"></script>
<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/easyui-1.4.4/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/easyui-1.4.4/myValidate.js"></script>




<script type="text/javascript">
<!--
var webRoot='${pageContext.request.contextPath}';

//-->
</script>

<meta charset="UTF-8">
<script type="text/javascript">
	var types=["cash","card","bank_card","voucher","grant"];
	var total='<%=rtotal%>';
	var is_fit='<%=is_fit%>';
	$(document).ready(function() {
		//初始化
		init();
		//内容变化
		$("#cash_amount").numberbox({  
			onChange: function(newValue,oldValue){
	        	  account('cash',newValue);
            }
			 
		});  
		$("#card_amount").numberbox({  
			onChange: function(newValue,oldValue){
	        	  account('card',newValue);
            }
			 
		});  
		$("#bank_card_amount").numberbox({  
			onChange: function(newValue,oldValue){
	        	  account('bank_card',newValue);
            }
			 
		});  
		$("#voucher_amount").numberbox({  
			onChange: function(newValue,oldValue){
	        	  account('voucher',newValue);
            }
			 
		});  
		$("#grant_amount").numberbox({  
			onChange: function(newValue,oldValue){
	        	  account('grant',newValue);
            }
			 
		});  
		//是否打印票和和发送短信
		
		initPrintMsg();
		
	});
	

	function init(){
		if(is_fit=='N'){
			$("#card").attr("checked","checked");
			formatShow('card');
		}else{
			$("#cash").attr("checked","checked");
			formatShow('cash');
		}
	}
	
	//初始化显示
	function formatShow(param){
		for(var i=0;i<types.length;i++){
			if(types[i]==param||"all"==param){
				$("#"+types[i]+"_amount").numberbox("enable");
				if(param!="all"){
					$("#"+types[i]+"_amount").numberbox("setValue",total);	
					account(param,total);
				}
					
			}else{
				$("#"+types[i]+"_amount").numberbox("setValue","0.00");	
				$("#"+types[i]+"_amount").numberbox("disable");	
			}
		}
		if(is_fit!="N"){
			$("#card_amount").numberbox("setValue","0.00");	
			$("#card_amount").numberbox("disable");
			$("#card").attr("disabled",true);
		} 
		
	}
	
	function account(type,param){
		var sum=0;
		for(var i=0;i<types.length;i++){
			var price=$("#"+types[i]+"_amount").numberbox("getValue");
			if(type==types[i]){
				price=param;
			}			
			sum=sum+parseFloat(price);	
		}
		$("#customer_pay").val(sum);
		var temp=parseFloat(sum)-parseFloat(total);
		var remain=formatFloat(temp,2);
		$("#remain").html(remain);
	}
	
	//结账
	function save(){
		 
		if($("#print").attr("checked")=="checked"){
			$("#ma_customer_spend_info__is_print_note").val("Y");
		}else{
			$("#ma_customer_spend_info__is_print_note").val("N");
		}
		if($("#phone").attr("checked")=="checked"){
			$("#ma_customer_spend_info__is_send_msg").val("Y");
		}else{
			$("#ma_customer_spend_info__is_send_msg").val("N");
		}
		if($("#free_note").attr("checked")=="checked"){
			$("#ma_customer_spend_info__is_free").val("Y");
		}else{
			$("#ma_customer_spend_info__is_free").val("N");
		}
		var customer_pay=$("#customer_pay").val();
		var card_pwd=$("#card_pwd").val();
		var remain=$("#remain").html();
		
		$('#ma_pro_infoFormObj').form('submit', {
			url:"fw?controller=com.action.foreground.MainAction&method=pay&paytype=<%=paytype%>&card_pwd="+card_pwd+"&card_type=<%=card_type%>&fk_to_card_id=<%=fk_to_card_id%>",
			timeout: 2000,
			onSubmit: function(data){
				var isValid = $(this).form('validate');
				if (!isValid){
					$.messager.progress('close');
				}
				return isValid;
			},
			success: function(data){
				$.messager.progress('close');
				data = eval('(' + data + ')');
		    	var result=data.result;
		    	
		    	if("Y"==result){
		    		is_fit=data.is_fit;
		    		var smsTip=data.smsTip;
		    		if( smsTip!=null&& smsTip!=undefined&& smsTip.length>0&&smsTip!="成功"){
		    			alert(smsTip);
		    		}
		    		$("#btn").linkbutton("disable");
		    		var account_balance=data.account_balance;
		    		var obj= art.dialog.open.origin;//来源页面
		    		obj.goSuccess(total,customer_pay,remain,is_fit,account_balance );
		    		art.dialog.close();
		    		
		    	}else{
		    		error("保存失败",result);	
		    	}
			}
		});
		}
	
	function exit(){
		var obj= art.dialog.open.origin;//来源页面
		obj.refreshMain();
		art.dialog.close();
	}
	//关闭窗口
	function closeWin(){
		art.dialog.close();
	}
	
</script>
</head>
<body style="padding: 10px;">
  <form class="l-form" id="ma_pro_infoFormObj" method="post">
  	<input type="hidden" name="customer_pay"  id="customer_pay" />
  	<input type="hidden" name="ma_customer_spend_info__id"  id="ma_customer_spend_info__id" value='<%=fk_customer_spend_id %>' />
  	<input type="hidden" name="ma_customer_spend_info__is_fit"  id="ma_customer_spend_info__is_fit" value='<%=is_fit %>' />
  	<input type="hidden" name="ma_customer_spend_info__fk_customer_id"  id="ma_customer_spend_info__fk_customer_id" value='<%=user_id %>' />
  	<input type="hidden" name="ma_customer_spend_info__status"  id="ma_customer_spend_info__status" value='pay' />
  	<input type="hidden" name="ma_customer_spend_info__is_free"  id="ma_customer_spend_info__is_free" />
  	
  	<input type="hidden" name="ma_customer_spend_info__is_print_note"  id="ma_customer_spend_info__is_print_note" />
  	<input type="hidden" name="ma_customer_spend_info__is_send_msg"  id="ma_customer_spend_info__is_send_msg" />
  	
 
    <ul style="padding-top: 10px;">
      <li style="width: 150px; text-align: left;">应收金额：</li>
      <li style="width: 130px; text-align: left;color: red;"><%=new BigDecimal(rtotal).setScale(2, BigDecimal.ROUND_HALF_UP) %>
      </li>
      <li style="width: 40px;">元</li>
     </ul>
    <ul style="padding-top: 10px;">
      <li style="width: 150px; text-align: left;">现金付款：</li>
      <li style="width: 130px; text-align: left;">
        <div class="l-text" style="width: 168px;">
          <input class="easyui-numberbox" style="width: 124px;text-align:right;" type="text" name="ma_customer_spend_info__cash_amount" id="cash_amount" data-options="precision:2,required:false"  value='0.00' />
          <div class="l-text-l"></div>
          <div class="l-text-r"></div>
        </div>
      </li>
      <li style="width: 40px;">元</li>
    </ul>
    <ul style="padding-top: 10px;">
      <li style="width: 150px; text-align: left;">储值卡付款：</li>
      <li style="width: 130px; text-align: left;">
        <div class="l-text" style="width: 168px;">
<input class="easyui-numberbox" style="width: 124px;text-align:right;" type="text" name="ma_customer_spend_info__card_amount" id="card_amount" data-options="precision:2,required:false"  value='0.00'/>
          <div class="l-text-l"></div>
          <div class="l-text-r"></div>
        </div>
      </li>
      <li style="width: 40px;">元</li>
    </ul>
    <ul style="padding-top: 10px;">
      <li style="width: 150px; text-align: left;">银行卡付款：</li>
      <li style="width: 130px; text-align: left;">
        <div class="l-text" style="width: 168px;">
        <input class="easyui-numberbox" style="width: 124px;text-align:right;" type="text" name="ma_customer_spend_info__bank_card_amount" id="bank_card_amount" data-options="precision:2,required:false"  value='0.00'/>
          <div class="l-text-l"></div>
          <div class="l-text-r"></div>
        </div>
      </li>
      <li style="width: 40px;">元</li>
    </ul>
    <ul style="padding-top: 10px;">
      <li style="width: 150px; text-align: left;">代金券付款：</li>
      <li style="width: 130px; text-align: left;">
        <div class="l-text" style="width: 168px;">
                <input class="easyui-numberbox" style="width: 124px;text-align:right;" type="text" name="ma_customer_spend_info__voucher_amount" id="voucher_amount" data-options="precision:2,required:false"  value='0.00'/>
          <div class="l-text-l"></div>
          <div class="l-text-r"></div>
        </div>
      </li>
      <li style="width: 40px;">元</li>
    </ul>
    <ul style="padding-top: 10px;">
      <li style="width: 150px; text-align: left;">赠金付款：</li>
      <li style="width: 130px; text-align: left;">
        <div class="l-text" style="width: 168px;">
        <input class="easyui-numberbox" style="width: 124px;text-align:right;" type="text" name="ma_customer_spend_info__grant_amount" id="grant_amount" data-options="precision:2,required:false"  value='0.00'/>
          <div class="l-text-l"></div>
          <div class="l-text-r"></div>
        </div>
      </li>
      <li style="width: 40px;">元</li>
    </ul>
    
    <ul style="padding-top: 10px;">
      <li style="width: 150px; text-align: left;">应该找零：</li>
      <li style="width: 130px; text-align: left;color: red;"><span id="remain">0.00</span>
      </li>
      <li style="width: 40px;">元</li>
     </ul>
     <%if(!"".equals(isExists) && null != isExists){ %>
    <ul style="padding-top: 10px;">
      <li style="width: 150px; text-align: left;">消费密码：</li>
      <li style="width: 130px; text-align: left;">
        <div class="l-text" style="width: 168px;">
        <input class="easyui-validatebox" style="width: 124px;text-align:right;" type="password" onfocus="this.type='password'" autocomplete="off" name="card_pwd" id="card_pwd" data-options="precision:2,required:true"/>
          <div class="l-text-l"></div>
          <div class="l-text-r"></div>
        </div>
      </li>
      <li style="width: 40px;"></li>
    </ul>
     <%} %>
    <br/>
<!--     付款方式 -->
	<ul style="padding-top: 10px;">
		<li style="width: 80px; text-align: left;"><input  type="radio" name="ma_customer_spend_info__pay_type" id="cash" value='cash' onclick="formatShow('cash');" /> <label for="cash">现金(F1)</label></li>
		<li style="width: 90px; text-align: left;"><input  type="radio" name="ma_customer_spend_info__pay_type" id="card" value="card" onclick="formatShow('card');" /> <label for="card">储值卡(F2)</label></li>
		<li style="width: 90px; text-align: left;"><input  type="radio" name="ma_customer_spend_info__pay_type" id="bank_card" value="bank_card" onclick="formatShow('bank_card');" /> <label for="bank_card">银行卡(F3)</label></li>
		<li style="width: 90px; text-align: left;"><input  type="radio" name="ma_customer_spend_info__pay_type" id="voucher" value="voucher" onclick="formatShow('voucher');" /> <label for="voucher">代金券(F4)</label></li>
		<li style="width: 80px; text-align: left;"><input  type="radio" name="ma_customer_spend_info__pay_type" id="grant" value="grant" onclick="formatShow('grant');" /> <label for="grant">赠金(F5)</label></li>
		<li style="width: 100px; text-align: left;"><input  type="radio" name="ma_customer_spend_info__pay_type" id="all" value="all" onclick="formatShow('all');" /> <label for="all">联合结账(F6)</label></li>
	</ul>
	
	<ul style="padding-top: 10px;">
		<li style="width: 100px; text-align: left;">
		<input type="checkbox" id="free_note"/><label for="free_note">免单</label> 
		</li>
		
		<li style="width: 100px; text-align: left;">
		<input type="checkbox" id="print" checked="checked"/><label for="print">打印小票</label> 
		</li>
		
		<li style="width: 100px; text-align: left;">
		<input type="checkbox" id="phone" checked="checked"/><label for="phone">发送短信</label> 
		</li>
		<li style="text-align: right;">
			<a id="btn" href="JavaScript:;" onclick="save();" class="easyui-linkbutton" >确定</a>
			<a id="back" href="JavaScript:;" onclick="exit();" class="easyui-linkbutton" >退出</a>
		</li>
	</ul>
	
  </form>
</body>
</html>
