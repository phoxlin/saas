<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
function fill_add_new_mem(){
	var phone = $("#phone").val();
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
	            	   $("#mem_name").val(list[0].mem_name);
	            	   $("#birthday").val(list[0].birthday);
	            	   $("#id_card").val(list[0].id_card);
	            	   var salesName = list[0].mc_name;
	                    var coachName = list[0].pt_name;
	                    var refer_mem_name = list[0].refer_mem_name;
		            	   var refer_mem_id = list[0].refer_mem_id;
	                    if(salesName != undefined && salesName.length>0){
	                    	 $("#salesName").html(list[0].mc_name);
	                    }
	                    if(coachName != undefined && coachName.length>0){
	                    $("#coachName").html(list[0].pt_name);
	                  
	                    }
	                    if(refer_mem_id != undefined && refer_mem_id.length>0){
	                    $("#mem_id").html(refer_mem_id);
	                  
	                    }
	                    if(refer_mem_name != undefined && refer_mem_name.length>0){
	                    $("#memName").html(refer_mem_name);
	                  
	                    }
	            	   var mc_id = list[0].mc_id;
	            	   var pt_id = list[0].pt_names;
	            	   var refer_mem_phone = list[0].refer_mem_phone;
	            	  
	            	   if(mc_id !=undefined){
	            		   $("#sales_id").val(mc_id);
	            	   }
	            	   if(pt_id !=undefined){
	            		   $("#coach_id").val(pt_id);
	            	   }
	            	   
	               }
	                
	            } else {
	                alert(data.rs);
	            }
	            $("#remark").val("");
	        }
	    });
}

function getHeadPic(){
	getPicture("takePhotoOver");
}

function takePhotoOver(imgPath){
	$("#pic1").val(imgPath);
}

</script>
<script type="text/javascript" src="partial/js/cashier.js"></script>
<script type="text/javascript" src="partial/js/takePhoto.js"></script>

<!-- 消息样式 -->
<link rel="stylesheet" type="text/css" href="public/message/css/messenger.css">
<link rel="stylesheet" type="text/css" href="public/message/css/messenger-theme-future.css">
<link rel="stylesheet" type="text/css" href="public/message/css/messenger-theme-ice.css">
<!-- 消息js -->
<script src="public/message/js/messenger.min.js"></script>
<script src="public/message/js/messenger-theme-future.js"></script>

<div class="user-basic-info">
		<div class="container">
			<div class="col-xs-6">
				<span class="need">*</span>
				<div class="col-xs-8" style="padding: 0;">
					<div class="input-panel">
						<label>联系电话</label>
						<input type="text" id="phone" onkeyup="fill_add_new_mem()" style="width: calc(100% - 105px);"/>
					</div>
				</div>
				<div class="col-xs-4 input-panel" style="padding: 0;padding-left: 0;">
					<select style="width: 86%;" id="sex">
						<option value="male">男</option>
						<option value="female">女</option>
					</select>
				</div>
			</div>
			
			<div class="col-xs-6">
				<span class="need">*</span>
				<div class="input-panel">
					<label>生&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 日</label>
					<input type="date" placeholder="如：1980年01月01日" id="birthday"/>
				</div>
			</div>
			<div class="col-xs-6">
				<span class="need">*</span>
				<div class="input-panel">
					<label>会员姓名</label>
					<input type="text" id="mem_name" onkeyup="new_mem_search_recommend();" />
					
				</div>
			</div>
			
			<div class="col-xs-6">
				<div class="input-panel">
					<label>推荐会员</label>
					<div class="bind">
						<div class="col-xs-10" onclick="getMem('mem')">
							<span style="vertical-align: super;" id="memName">点击选择会员</span> 
							<span class="sub-title">会员</span>
							<input type="hidden" id="mem_id" name="mem_id" value="">
						</div>
						<div class="col-xs-2">
							<button onclick="Unbundled('mem')">解绑</button>
						</div>
					</div>
				</div>
			</div>
			
			<div class="col-xs-6">
				<div class="input-panel">
					<label>证件类型</label>
					<select>
						<option>身份证</option>
					</select>
				</div>
			</div>
			<div class="col-xs-6">
				<div class="input-panel">
					<label>健身目的</label>
					<input type="text" id="fit_purpose"/>
				</div>
			</div>
			<div class="col-xs-6">
				<div class="input-panel">
					<label>证件号码</label>
					<input type="text" id="id_card"/>
				</div>
			</div>
			<div class="col-xs-6">
				<div class="input-panel">
					<label class="photo" onclick="getHeadPic()">头像地址</label>
					<input type="text" id="pic1"/>
				</div>
			</div>
<!-- 			<div class="col-xs-6"> -->
<!-- 				<div class="input-panel"> -->
<!-- 					<label style="padding: 0 3px;">&nbsp;&nbsp;&nbsp;推&nbsp;荐&nbsp;人&nbsp;&nbsp;</label> -->
<!-- 					<input type="text" placeholder="推荐人电话号码"/> -->
<!-- 				</div> -->
<!-- 			</div> -->
		</div>
	</div>
	