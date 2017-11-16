$(function() {
    $(".cards-btn ").click(function() {
        $(".cards-btn").removeClass("active");
        $(this).addClass("active");
    });
    getsendCardMsg();
    getCardByType('001');
    if('<%=fk_user_id%>' != "null"){
    	getPreFee('<%=fk_user_id%>');
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
        $("#card_type_state").val("");
    } else {
        $("#timesDiv").css("display", "none");
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
            card_type: type
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
        url: "fit-ws-bg-Mem-getCard",
        data: {
            card_type: '006'
        },
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
	debugger;
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
            iframe.addCard(this,Cardtype, document, window);
            return false;
        }
    }).showModal();
}
function Unbundled(type) {
    if ("sales" == type) {
        $("#salesName").html("点击选择会籍");
        $("#sales").val("");
    }
    if ("coach" == type) {
        $("#coachName").html("点击选择教练");
        $("#coach").val("");
    }
    if ("mem" == type) {
    	$("#memName").html("点击选择会员");
    	$("#mem_id").val("");
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
                            content: "收取费卡押金(￥" + fee + ")",
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