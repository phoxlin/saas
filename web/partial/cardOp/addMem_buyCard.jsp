<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="com.mingsokj.fitapp.utils.MemUtils"%>
<%@page import="com.mingsokj.fitapp.m.MemInfo"%>
<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
<%
	FitUser user = (FitUser)SystemUtils.getSessionUser(request, response);
	if (user == null) {
		request.getRequestDispatcher("/").forward(request, response);
	}
	String cust_name = user.getCust_name();
	String gym = user.getViewGym();
	String fk_user_id = request.getParameter("fk_user_id");
	 String mem_no  ="";
	if(!Utils.isNull(fk_user_id)){
    MemInfo	mem = MemUtils.getMemInfo(fk_user_id, cust_name);
     mem_no  = mem.getMem_no();
	}
%>
$(function() {
    $(".cards-btn ").click(function() {
        $(".cards-btn").removeClass("active");
        $(this).addClass("active");
    });
    getsendCardMsg();
    getCardByType('001');
    var card_cash_int = $("#card_cash_int").val();
    
    if('<%=fk_user_id%>' != "null"){
    	getPreFee('<%=fk_user_id%>');
    }
    if("<%=mem_no%>" != null && '<%=mem_no%>' != "null"&& '<%=mem_no%>' != "" && '<%=mem_no%>'.length> 0 ){
    	$("#cardNum").attr("disabled","disabled");
    	$("#cardNumBtn").attr("disabled","disabled");
    }else{
    	$("#cardNum").removeAttr("disabled");
    	$("#cardNumBtn").removeAttr("disabled");
    }
    
});
 
function getCardByType(type) {
	
	
    if (type == "002") {
        $("#giveTitle").html("赠送金额");
        $("#amtDiv").css("display", "block")
        $("#card_type_state").val("");
    } else {
        $("#amtDiv").css("display", "none")
    }
    if (type == "003" || type == "006") {
        $("#giveTitle").html("赠送次数");
        $("#timesDiv").css("display", "block")
        $("#timesDiv2").css("display", "block")
        $("#card_type_state").val("");
    } else {
        $("#timesDiv").css("display", "none");
        $("#timesDiv2").css("display", "none");
    }
    if (type == "001") {
        $("#giveTitle").html("赠送天数");
        $("#card_type_state").val("");
    }
    if (type == "006") {
        $("#card_type_state").val(type);
    }
    Cardtype = type;
    $.ajax({
        type: "POST",
        url: "fit-ws-bg-Mem-getCard",
        data: {
            card_type: type,
            fk_user_id : '<%=fk_user_id%>'
        },
        dataType: "json",
        async: false,
        success: function(data) {
            if (data.rs == "Y") {
                var partialBuyCard_CardTpl = document.getElementById('partialBuyCard_CardTpl').innerHTML;
                var partialBuyCard_CardTplHtml = template(partialBuyCard_CardTpl, {
                    list: data.data
                });
                $('#partialBuyCard_CardTplDiv').html(partialBuyCard_CardTplHtml);
            } else {
                alert(data.rs);
            }
        }
    });
    
    if(type=="006"){
		//私教可编辑次数
		$("#times").removeAttr("readonly");
		$("#price").removeAttr("readonly");
		$('#times').bind('input propertychange', function() {  
			var onePrice = $("#single_price").val();
			if($(this).val() <1){
				$(this).val(1);
				$("#price").val(onePrice);
			}else{
			    var allPrice = Number(onePrice) * Number($(this).val());
			    $("#price").val(Math.round(allPrice * 100) / 100  );
			}
		});
		$("#price").bind('input propertychange', function() {  
			var total = $(this).val();
			var times = $("#times").val();
			if(total<=0){
				 $(this).val(0);
			}
			var sign_price = Number(total)/Number(times);
			$("#single_price").val(Math.floor(sign_price * 100) / 100  );
		});	
	}else{
		$("#times").attr("readonly","readonly");
		$("#price").attr("readonly","readonly");
		$('#times').unbind('input propertychange');
		$('#price').unbind('input propertychange');
	}
}
function getPreFee(fk_user_id){
	 $.ajax({
	        type: "POST",
	        url: "fit-ws-bg-getPreFeeById",
	        data: {
	        	fk_user_id : fk_user_id
	        },
	        dataType: "json",
	        async: false,
	        success: function(data) {
	            if (data.rs == "Y") {
	                var card = data.data;
	                var option = "<option value='0'>--请选择--</option>";
	                for (var i = 0; i < card.length; i++) {
	                    option += "<option value='" + card[i].id+"_"+  card[i].user_amt+ "'>" + card[i].name + "</option>";
	                }
	                $("#preFee").html(option);
	            } else {
	            	alert(data.rs);
	            }
	        }
	    });
	
}
function getsendCardMsg() {
    $.ajax({
        type: "POST",
        url: "fit-ws-bg-Mem-getCard006",
        data: {},
        dataType: "json",
        async: false,
        success: function(data) {
            if (data.rs == "Y") {
                var card = data.data;
                var option = "<option value='0'>--请选择--</option>";
                for (var i = 0; i < card.length; i++) {
                    option += "<option value='" + card[i].id + "'>" + card[i].card_name + "</option>";
                }
                $("#sendCard").html(option);
            } else {
            	alert(data.rs);
            }
        }
    });
}

function showActiveTime() {
    var activate_type = $("#activate_type").val();
    if ("003" == activate_type) {
        $("#activeTimeDiv").css("display", "block")
    } else {
        $("#activeTimeDiv").css("display", "none")
    }
}
function getemps(type) {
    var typeName = "员工";
    if ("sales" == type) {
        typeName = "会籍";
    } else if ("coach" == type) {
        typeName = "教练";
    }
    top.dialog({
        url: "partial/chioceEmp.jsp?userType=" + type,
        title: "选择" + typeName,
        width: 820,
        height: 550,
        okValue: "确定",
        ok: function() {
            var iframe = $(window.parent.document).contents().find("[name=" + top.dialog.getCurrent().id + "]")[0].contentWindow;
            iframe.saveId(this);
            var sales = store.getJson("sales");
            var salesid = sales.id;
            if (salesid) {
                $("#salesName").html(sales.name);
                $("#sales_id").val(sales.id);
            }
            store.set('sales', {});
            var coach = store.getJson("coach");
            var coachid = coach.id;
            if (coachid) {
                $("#coachName").html(coach.name);
                $("#coach_id").val(coach.id);
            }
            store.set('coach', {});

            return false;
        },
        cancelValue: "取消",
        cancel: function() {
            return true;
        }
    }).showModal();
}
function getMem(type){
	  var typeName="会员";
	 top.dialog({
	        url: "partial/chioceMem.jsp?gym="+'<%=gym%>',
	        title: "选择"+typeName,
	        width: 920,
	        height: 430,
	        okValue: "确定",
	        ok: function() {
	        	var iframe = $(window.parent.document).contents().find("[name=" + top.dialog.getCurrent().id + "]")[0].contentWindow;
	            iframe.saveId(this);
	           var mem = store.getJson("mem");
	        	   $("#memName").html(mem.name);
	        	   $("#mem_id").val(mem.id);
	           store.set('mem',{});
	            return false;
	        },
	        cancelValue:"取消",
	        cancel:function(){
	        	return true;
	        }
	    }).showModal();
}
function showCardDetial(id) {
    $.ajax({
        type: "POST",
        url: "fit-ws-bg-Mem-getCardDetial",
        data: {
            card_id: id
        },
        dataType: "json",
        async: false,
        success: function(data) {
            if (data.rs == "Y") {
                var price = data.data.fee;
                var days = data.data.days;
                var times = data.data.times;
                $("#cardName").val(data.data.card_name);
                $("#price").val(price);
                if (days == undefined) {
                    days = "永久有效";
                }
                $("#day").val(days);
                $("#times").val(times);
                $("#amt").val(data.data.amt);
                $("#single_price").val(price/times);
                if ("Y" == data.data.is_fanmily) {
                    $("#cardNumDiv1").css("display", "block");
                    $("#cardNumDiv2").css("display", "block");
                    $("#cardNumDiv3").css("display", "block");
                } else {
                    $("#cardNumDiv1").css("display", "none");
                    $("#cardNumDiv2").css("display", "none");
                    $("#cardNumDiv3").css("display", "none");
                }
            } else {
            	alert(data.rs);
            }
        }
    });
}
function toDecimal(x) { 
    var f = parseFloat(x); 
    if (isNaN(f)) { 
      return 0; 
    } 
    f= parseFloat(f.toFixed(2));
    return f; 
  } 
var Cardtype = '001';
function addCard() {
    var url = "";
    var title = "";
    if (Cardtype == '001') {
        url = "partial/cardOp/addCard/addDaysCard.jsp";
        title = "添加天数卡";
    } else if (Cardtype == "002") {
        url = "partial/cardOp/addCard/addMoneyCard.jsp";
        title = "添加储值卡";
    } else if (Cardtype == "003") {
        url = "partial/cardOp/addCard/addTimesCard.jsp";
        title = "添加次数卡";
    } else if (Cardtype == "006") {
        url = "partial/cardOp/addCard/addClassCard.jsp";
        title = "添加私教卡";
    }
    top.dialog({
        url: url,
        title: title,
        width: 800,
        height: 550,
        okValue: "确定",
        ok: function() {
            var iframe = $(window.parent.document).contents().find("[name=" + top.dialog.getCurrent().id + "]")[0].contentWindow;
            iframe.addCard(this, document, window);
            return false;
        }
    }).showModal();
}
function Unbundled(type) {
    if ("sales" == type) {
        $("#salesName").html("点击选择会籍");
        $("#sales_id").val("");
    }
    if ("coach" == type) {
        $("#coachName").html("点击选择教练");
        $("#coach").val("");
    }
    if ("mem" == type) {
        $("#coachName").html("点击选择会员");
        $("#coach_id").val("");
    }
}
function createCardNo(id) {
    $.ajax({
        type: "POST",
        url: "fit-cashier-createCardNo",
        data: {},
        dataType: "json",
        async: false,
        success: function(data) {
            if (data.rs == "Y") {
                $("#" + id).val(data.code);
            } else {
            	alert(data.rs);
            }
        }
    });
}
function getCardCashInt() {
    var card_cash_int = $("#card_cash_int").val();
  
    if ("Y" == card_cash_int) {
        $.ajax({
            type: "POST",
            url: "fit-cashier-getCardCashInt",
            data: {},
            dataType: "json",
            async: false,
            success: function(data) {
                if (data.rs == "Y") {
                    var fee = data.fee;
                    $("#card_cash_fee").val(fee);
                    if (fee > 0) {
                        top.dialog({
                            title: "提示",
                            content: "收取费卡押金 ￥" + fee + " /张",
                            okValue: "确定",
                            ok: function() {}
                        }).showModal();
                    }
                } else {
                    error(data.rs);
                }
            }
        });
    } else {
        $("#card_cash_fee").val(0);

    }
}
function edit(name,id,card_name) {
	var instance_id = $("#instance_id").val();
	var my_title = card_name;
	var nextpage = "pages/f_card/f_card_edit.jsp";
	var my_entity = "f_card";
	var myHeight = 600;
	var myWidth = 800;
		top.dialog({url:"task-cq-detail?entity=" + my_entity + "&id=" + id
				+ "&nextpage=" + nextpage + "&type=edit&instance_id="
				+ instance_id,
			title : '修改' + my_title,
			width : myWidth,
			height : myHeight,
			okValue : "修改",
			ok : function() {
				var iframe = $(window.parent.document).contents().find("[name=" + $(this)[0].id + "]")[0].contentWindow;
				iframe.savaEditDialog(this, document, my_entity, name);
				return false;
			},
			cancelValue : "关闭",
			cancel : function() {
				return true;
			}
		}).showModal();

}

//查找会员的推荐人
function new_mem_search_recommend(){
	var phone = $("#mem_name").val();
	if(phone.length !=11){
		return;
	}
	 $.ajax({
	        type: "POST",
	        url: "fit-cashier-search_recommend",
	        dataType: "json",
	        data : {
	        	phone : phone
	        },
	        success: function(data) {
	            if (data.rs == "Y") {
	               var list = data.list;
	               if(list.length > 0){
	            	   var memName = list[0].refer_mem_name;
	            	   var salesName = list[0].mc_name;
	            	   var coachName = list[0].pt_name;
	            	   if(memName !=undefined && memName != ""){
	            		   $("#memName").html(memName);
	            	   }
	            	   if(salesName !=undefined && salesName != ""){
	            		   $("#salesName").html(salesName);
	            	   }
	            	   if(coachName !=undefined && coachName != ""){
	            		   $("#coachName").html(coachName);
	            	   }
	            	   var mc_id = list[0].mc_id;
	            	   var pt_id = list[0].pt_names;
	            	   var refer_mem_id = list[0].refer_mem_id;
	            	   if(mc_id !=undefined && mc_id != ""){
	            		   $("#sales_id").val(mc_id);
	            	   }
	            	   if(pt_id !=undefined && pt_id != ""){
	            		   $("#coach_id").val(pt_id);
	            	   }
	            	   if(refer_mem_id !=undefined && refer_mem_id != ""){
	            		   $("#mem_id").val(refer_mem_id);
	            	   }
	               }
	                
	            } else {
	                alert(data.rs);
	            }
	            $("#remark").val("");
	        }
	    });
	
}
</script>
<style>
.col-xs-10{
	height:18px;
}
</style>
<!-- 会员买卡信息 -->
<div class="user-buy-card">
	<input type="hidden" id="card_type_state"/>
	<ul class="nav nav-tabs" style="width: 91%;">
		<li role="presentation" class="cards-btn days-btn active">
			<a href="javascript: void(0);" onclick="getCardByType('001')">时间卡</a>
		</li>
		<li role="presentation" class="cards-btn lesson-btn">
			<a href="javascript: void(0);" onclick="getCardByType('006')">私教卡</a>
		</li>
		<li role="presentation" class="cards-btn times-btn">
			<a href="javascript: void(0);" onclick="getCardByType('003')">次卡</a>
		</li>
		<li role="presentation" class="cards-btn amt-btn">
			<a href="javascript: void(0);" onclick="getCardByType('002')">储值卡</a>
		</li>
	</ul>
	<div class="container" style="border: 1px solid #ddd;border-top: 0;width: 91%;margin-left: 40px;">
		
		<script type="text/html" id="partialBuyCard_CardTpl">
                  <# if(list){
                      for(var i = 0;i<list.length;i++){
                  #>
                          <div class="card-panel" >
                              <input type="radio" onclick="showCardDetial('<#=list[i].id#>')"  name="cards" value="<#=list[i].id#>" id="<#=list[i].id#>"> 
                              <label for="<#=list[i].id#>">
                              	<span></span>
                              	<b><#=list[i].card_name#></b>
                              </label>
							  <i class="icon-edit" onclick="edit('f_card___f_card','<#=list[i].id#>','<#=list[i].card_name#>')"></i>
                           </div>
                  <# }}#>
               </script>
		<div id="partialBuyCard_CardTplDiv" style="display: inline-block;"></div>
		<button class="add-card-btn" onclick="addCard()">+ 添加卡种并设置</button>
	</div>
</div>
<!-- 卡信息 -->
<div class="buy-card-info">
	<div class="container">
		<div class="col-xs-6">
			<span class="need">*</span>
			<div class="input-panel">
				<label>卡种名称</label> <input type="text" id="cardName" readonly="readonly" />
			</div>
		</div>
		<div class="col-xs-6">
			<span class="need">*</span>
			<div class="input-panel">
				<label>金&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;额</label> <input type="number" id="price" readonly="readonly"/>
			</div>
		</div>
		<div class="col-xs-6">
			<span class="need">*</span>
			<div class="input-panel">
				<label>天&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;数</label> <input type="text" id="day" readonly="readonly" />
			</div>
		</div>
		<div class="col-xs-6" id="timesDiv" style="display: none;">
			<span class="need">*</span>
			<div class="input-panel">
				<label>次&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;数</label> <input type="number" id="times" readonly="readonly" />
			</div>
		</div>
		<div class="col-xs-6" id="timesDiv2" style="display: none;">
			<span class="need">*</span>
			<div class="input-panel">
				<label>单&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;价</label> <input type="text" id="single_price" readonly="readonly" />
			</div>
		</div>
		<div class="col-xs-6" id="amtDiv" style="display: none;">
			<span class="need">*</span>
			<div class="input-panel">
				<label>储值金额</label> <input type="text" id="amt" readonly="readonly" />
			</div>
		</div>
		<div class="col-xs-6">
			<span class="need">*</span>
			<div class="input-panel">
				<label>激活类型</label> <select onchange="showActiveTime()" id="activate_type">
					<option value="001">立即激活</option>
<!-- 					<option value="002">首次刷卡开卡</option> -->
					<option value="003">指定日期开卡</option>
				</select>
			</div>
		</div>
		<div class="col-xs-6" id="activeTimeDiv" style="display: none;">
			<span class="need">*</span>
			<div class="input-panel">
				<label>激活时间</label> <input type="date" id="active_time" />
			</div>
		</div>
		<!-- 			<div class="col-xs-6"> -->
		<!-- 				<div class="input-panel"> -->
		<!-- 					<label>优&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;惠</label> <select> -->
		<!-- 						<option>下拉选择价格或优惠类型</option> -->
		<!-- 					</select> -->
		<!-- 				</div> -->
		<!-- 			</div> -->
		<div class="col-xs-6">
<!-- 			<span class="need">*</span> -->
			<div class="input-panel">
				<label>合同编号</label>
				<div class="bind">
					<div class="col-xs-10">
						<input type="text" placeholder="选填，若不输入则系统自动生成" id="contract_no" style="width: 100%" />
					</div>
					<div class="col-xs-2">
						<button class="xx-btn" onclick="createCardNo('contract_no')">生成</button>
					</div>
				</div>
			</div>
		</div>
		<div class="col-xs-6">
			<span class="need">*</span>
			<div class="input-panel">
				<label>所属会籍</label>
				<div class="bind">
					<div class="col-xs-10" onclick="getemps('sales')">
						<span style="vertical-align: super;" id="salesName">点击选择会籍</span> 
						<input type="hidden" id="sales_id"> <span class="sub-title"></span>
					</div>
					<div class="col-xs-2">
						<button onclick="Unbundled('sales')">解绑</button>
					</div>
				</div>
			</div>
		</div>
		<div class="col-xs-6">
			<div class="input-panel">
				<label>所属教练</label>
				<div class="bind">
					<div class="col-xs-10" onclick="getemps('coach')">
						<span style="vertical-align: super;" id="coachName">点击选择教练</span> 
						<input type="hidden" id="coach_id"> <span class="sub-title"></span>
					</div>
					<div class="col-xs-2">
						<button onclick="Unbundled('coach')">解绑</button>
					</div>
				</div>
			</div>
		</div>
		<div class="col-xs-6">
			<div class="input-panel">
				<label>业绩来源</label> <select id="source">
					<option value="1">WI-到访</option>
					<option value="2">APPT-电话邀约</option>
					<option value="3">BR-转介绍</option>
					<option value="4">TI-电话咨询</option>
					<option value="5">DI-拉访</option>
					<option value="6">POS</option>
					<option value="7">场开</option>
					<option value="8">体测</option>
					<option value="9">续费</option>
				</select>
			</div>
		</div>
		<div class="col-xs-6">
			<span class="need">*</span>
			<div class="input-panel">
				<label>立即发卡</label> <select onchange="getCardCashInt()" id="card_cash_int">
					<option value="N">否</option>
					<option value="Y">是</option>
				</select> <input type="hidden" id="card_cash_fee" value="0" />
			</div>
		</div>
		<div class="col-xs-6" id="cardNumDiv">
			<div class="input-panel">
				<label>主&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;卡</label>
				<div class="bind">
					<div class="col-xs-10">
						<input type="text" placeholder="自动生成卡号" id="cardNum" style="width: 100%" />
					</div>
					<div class="col-xs-2">
						<button class="xx-btn" id="cardNumBtn" onclick="createCardNo('cardNum')">生成</button>
					</div>
				</div>
			</div>
		</div>
		<div class="col-xs-6" id="cardNumDiv1" style="display: none;">
			<div class="input-panel">
				<label>副&nbsp;卡(一)</label>
				<div class="bind">
					<div class="col-xs-10">
						<input type="text" placeholder="自动生成卡号" id="cardNum1" style="width: 100%" />
					</div>
					<div class="col-xs-2">
						<button class="xx-btn" onclick="createCardNo('cardNum1')">生成</button>
					</div>
				</div>
			</div>
		</div>
		<div class="col-xs-6"  id="cardNumDiv2" style="display: none;">
			<div class="input-panel">
				<label>副&nbsp;卡(二)</label>
				<div class="bind">
					<div class="col-xs-10">
						<input type="text" placeholder="自动生成卡号" id="cardNum2" style="width: 100%" />
					</div>
					<div class="col-xs-2">
						<button class="xx-btn" onclick="createCardNo('cardNum2')">生成</button>
					</div>
				</div>
			</div>
		</div>
		<div class="col-xs-6"  id="cardNumDiv3" style="display: none;">
			<div class="input-panel">
				<label>副&nbsp;卡(三)</label>
				<div class="bind">
					<div class="col-xs-10">
						<input type="text" placeholder="自动生成卡号" id="cardNum3" style="width: 100%" />
					</div>
					<div class="col-xs-2">
						<button class="xx-btn" onclick="createCardNo('cardNum3')">生成</button>
					</div>
				</div>
			</div>
		</div>

		<div class="col-xs-12">
			<div class="card-panel" style="color: #ff0000;">注:如果选择的是时间卡 则赠送时间 ,如果选择的是次卡或者私教卡则赠送次数,如果选择的是储值卡则赠送月余额</div>
		</div>
		<div class="col-xs-6">
			<div class="input-panel">
				<label id="giveTitle"></label> <input type="text" id="give_days" value="0" />
			</div>
		</div>
		<div class="col-xs-6">
			<div class="input-panel">
				<label>赠送私课</label> <select id="sendCard"></select> 
			</div>
		</div>
		<div class="col-xs-6">
			<div class="input-panel">
				<label>赠私课数&nbsp;</label><input type="text" id="give_times" value="0" >
			</div>
		</div>
		<div class="col-xs-12">
			<div class="input-panel">
				<label>备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注</label>
				<input type="text" id="remark"/>
			</div>
		</div>
		<div class="col-xs-12">
			<div class="card-panel" style="color: #ff0000;">注:定金只能抵扣卡的价格，发卡押金不能抵扣</div>
		</div>
		<div class="col-xs-6">
			<div class="input-panel">
				<label>定金抵扣</label> <select id="preFee">
				</select>
			</div>
		</div>
	</div>
</div>

