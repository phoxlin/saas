function showGoods(id, num) {
	/*
	 * var sell_repertory_id = $("#sell_repertory_id").val(); var goods_barcode =
	 * $("#goods_barcode").val(); var goods_letter = $("#goods_letter").val();
	 */
	var condition = $("#goods_search_condition").val();
	$.ajax({
		url : "fit-ws-cashier-searchGoods",
		type : "POST",
		data : {
			id : id,
			num : num,
			condition : condition
		},
		dataType : "json",
		success : function(data) {
			if (data.rs == "Y") {
				$(".tab-good-pane").html("");
				var tpl = document.getElementById("goodsListTpl").innerHTML;
				var content = template(tpl, {
					all : data.goods,
					goodsType : data.goodsType,
					tab_id : id,
					totalSize : data.total_size
				});
				$("#goodsList").html(content);
			} else {
				error(data.rs);
			}
		},
		error : function() {
			error("网络错误,请刷新重试!");
		}
	});
}
function getGoodsByrepertory() {
	showGoods("all", "1");
}
function show_emp_price(){
	var is_emp = $("#is_emp_price").is(":checked");
	if(is_emp){
		//$(".goods-table span[id$=price]").hide();
		//$(".goods-table span[id$=emp_price]").show();
		$(".goods-table span[id$=total_mem]").hide();
		$(".goods-table span[id$=total_emp]").show();
		$("#goods-total-mem").hide();
		$("#goods-total-emp").show();
		
	}else{
		//$(".goods-table span[id$=price]").show();
		//$(".goods-table span[id$=emp_price]").hide();
		$(".goods-table span[id$=total_mem]").show();
		$(".goods-table span[id$=total_emp]").hide();
		$("#goods-total-mem").show();
		$("#goods-total-emp").hide();
	}
}

function onbarcodeInput() {
	var event = event || window.event;
	if (event.keyCode == 13) {
		showGoods("all","1");
	}	
}
var timestamp;
var ut;
function showGoodsInList(par) {
	var info = JSON.parse($(par).attr("data-id"));
	if(!timestamp) {
		timestamp = new Date().getTime();
	}
	var gid = info.id;
	if($("#" + gid).attr("data-exsit") == "true") {
		addNum(gid);
	} else {
		var h = template($("#goodsTR").html(), { g : info , emp : isEmp()});
		$("#goods-list").append(h);
		addNum(gid);
	}
}
function addNum(gid) {
	var num = Number($("#" + gid + "__num").val());
	var price = Number($("#" + gid + "__price").text());
	$("#" + gid + "__num").val(num + 1);
	$("#" + gid + "__num").change();
	reCalcPrice();
	checkGoodsStoreNum(gid, num + 1);
	
}

$(document).on("change", "#goods-list input", function(e) {
//		console.log(e);
	var input = $(e.target);
	var val = input.val();
	var	num = Number(val);
	if(num == 0) {
		$("#" + input.attr("id").split("__")[0]).remove();
	} else {
		if(isNaN(num)) {
			num = 0;
		}
		
		num = Math.floor(num);
		
		input.val(num);
	}
		reCalcPrice();
});

function reCalcPrice() {
	var goods = getGoods();
	var mem_id =$("#mem_id").val();
	var percent = 100;
	if(mem_id != ""){
		var count = $("#count").text();
		if(count !=""){
			percent = count; 
		}
	}
	var total_ca = 0;
	var total_mem =0;
	var total_emp = 0;
	if(goods) {
		for(var id in goods) {
			if(id && goods[id]) {
				var good = goods[id];
				var num = Number(good.num);
				var price = Number(good.price);
				var emp_price = Number(good.emp_price);
				
				var t_ca = num * price;
				var t_mem = num * price * (percent);
				var t_emp = num * emp_price;
				
				total_ca += t_ca * 100;
				total_mem += t_mem;
				total_emp += t_emp * 100;
				
				$("#" + id + "__total_ca").text(Math.round(t_ca *100)/100);
				$("#" + id + "__total_mem").text(Math.round(t_mem) / 100);
				$("#" + id + "__total_emp").text(Math.round(t_emp*100)/100);
			}
		}
	}
	
	$("#goods-total-ca").text(Math.round(total_ca) / 100);
	$("#goods-total-mem").text(Math.round(total_mem) / 100);
	$("#goods-total-emp").text(Math.round(total_emp) /100);
}

function isEmp() {
	return $("#select_userId").attr("data-emp") == "true";
	//return $("#is_emp_price:checked");
}

function reduceNum(gid) {
	var num = Number($("#" + gid + "__num").val());
	if(num) {
		var price = Number($("#" + gid + "__price").text());
		$("#" + gid + "__num").val(num - 1);
		$("#" + gid + "__num").change();
		checkGoodsStoreNum(gid, num - 1);
	}
	//更新价格
	reCalcPrice();
}

function clearTable() {
	ut = 0; timestamp = 0;
	$("#goods-list").html(" ");
	$("#goods-total").html("0");
}
function getGoods() {
	
	var names = $("*[id$='__name']");
	var prices = $("*[id$='__price']");
	var nums = $("*[id$='__num']");
	var emp_price = $("*[id$='__emp_price']");
	
	var goods = {};
	emp_price.each(function() {
		var id = $(this).attr("id").split("__")[0];
		var good = goods[id];
		if(!good) {
			good = {};
		} 
		good["emp_price"] = $(this).text();
		goods[id] = good;
	});
	names.each(function() {
		var id = $(this).attr("id").split("__")[0];
		var good = goods[id];
		if(!good) {
			good = {};
		} 
		good["name"] = $(this).text();
		goods[id] = good;
	});
	prices.each(function() {
		var id = $(this).attr("id").split("__")[0];
		var good = goods[id];
		if(!good) {
			good = {};
		} 
		good["price"] = $(this).text();
		goods[id] = good;
	});
	nums.each(function() {
		var id = $(this).attr("id").split("__")[0];
		var good = goods[id];
		if(!good) {
			good = {};
		} 
		good["num"] = $(this).val();
		goods[id] = good;
	});
	
	return goods;
}
function checkGoodsStoreNum(gid, sellNum) {
	var store_num = Number($("#" + gid + "__store_num").text());
	if(sellNum > store_num) {
		$("#" + gid + "__store_num_div").css("color", "red");
		$("#" + gid + "__warn_msg").text("库存不足!");
		
	} else {
		$("#" + gid + "__store_num_div").css("color", "black");
		$("#" + gid + "__warn_msg").text("");
	}
}

function showEmpPrice(){
	$("#mem_id").val("");
	$("#is_emp_price_label").show();
	$(".goods-table span[id$=total_mem]").hide();
	$(".goods-table span[id$=total_emp]").show();
	$("#goods-total-mem").hide();
	$("#goods-total-emp").show();
}
function showMemPrice(){
	$("#emp_id").val("");
	$("#is_emp_price_label").hide();
	$(".goods-table span[id$=total_mem]").show();
	$(".goods-table span[id$=total_emp]").hide();
	$("#goods-total-mem").show();
	$("#goods-total-emp").hide();
}
//
var temp_mem = "";
function cashierQuery(){
	var mem = $("#mem_info").val();
	
	var checked = $("#is_emp_price").is(":checked");
	if(mem != null&& mem!=""){
		$.ajax({
			url:"fit-ws-bg-mem-query",
			type:"GET",
			dataType:"JSON",
			data:{phone:mem},
			success:function(data){
				if(data.rs == "Y"){
					if(data.isEmp == "Y"){
						if(!checked){
							$("#is_emp_price").click();
						}
						showEmpPrice();
						$("#emp_id").val(data.emp.id);
						if(data.mem){
							$("#mem_id").val(data.mem.id);
							$("#mem_gym").val(data.mem.gym);
							$("#mem_name").text(data.mem_name);
							$("#mem_remain_amt").text(Number(data.mem.remain_amt)/100);
						}
					}else{
						if(checked){
							$("#is_emp_price").click();
						}
						 showMemPrice()
						if(data.mem){
							$("#mem_id").val(data.mem.id);
							$("#mem_gym").val(data.mem.gym);
							$("#mem_name").text(data.mem_name);
							$("#mem_remain_amt").text(Number(data.mem.remain_amt)/100);
							if(data.count!=100){
								$("#count").text(data.count);
								$("#card_name").text(data.card_name);
								$("#message").text("会员打折中");
							}else{
								$("#message").text("");
								$("#count").text("");
								$("#card_name").text("");
							}
						}
					}
				}else if(data.rs=="手机号码不存在"){
					//error(data.rs);
					$("#message").text("");
					$("#mem_id").val("");
					$("#mem_gym").val("");
					$("#mem_name").text("");
					$("#mem_remain_amt").text("");
					$("#count").text("");
					$("#card_name").text("");
					if(checked){
						$("#is_emp_price").click();
					}
					showMemPrice()
				}
			reCalcPrice();
			}
		});
	}else{
		if(checked){
			$("#is_emp_price").click();
		}
		showMemPrice();
		$("#message").text("");
		$("#mem_id").val("");
		$("#mem_gym").val("");
		$("#mem_name").text("");
		$("#mem_remain_amt").text("");
		$("#count").text("");
		$("#card_name").text("");
	}
}