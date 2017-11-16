<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="popup popup-addInteract">
	<header class="bar bar-nav">
        <i onclick="showInteract()" class="pull-left icon icon-left"></i>
		<h1 class="title">发布圈圈</h1>
		<button class="color-basic pull-right button font-85" onclick="saveInteract(event)"
			 style="background: transparent;z-index: 20;height: 2.2rem;
    				top: 0;border: 0;outline: none;">
			发布
		</button>
	</header>
	<div class="content">
		<textarea class="color-fff font-75 content-bg"  id="i_content"
			style="width: 100%;height: 8rem;padding: 0.2rem;border: 0;resize: none;"
			placeholder="说点儿什么吧"></textarea>
		<div style="margin-top: 0.5rem;padding: 0.5rem;" class="content-bg" >
			<div id="image_quanquan_div">
			32132132
			</div>
			<input type="hidden" id="interact_pics" />
			<button onclick="uploadQuan()" style="margin: 0 0.5rem 0.5rem 0;width: 4rem;height: 4rem;text-align: center;padding: 0;font-size: 2rem;border-radius: 0;border: 1px solid #ccc;background: #242537;" class="color-fff">+</button>
		</div>
		<div class="list-block">
			<ul>
				<li class="item-content item-link" onclick="changeAuthType()">
					<div class="item-media"><i class="icon icon-earth"></i></div>
					<div class="item-inner">
						<div class="item-title">可见范围</div>
						<div class="item-after color-fff" id="interact_auth_text">所有人</div>
						<input type="hidden" id="interact_auth_type" value="001"/>
					</div>
				</li>
			</ul>
		</div>
	</div>
</div>
<script type="text/javascript">

	function changeAuthType(){
		
		var buttons1 = [
	        {
	          text: '可见范围',
	          label: true
	        },
	        {
	          text: '所有人',
	          onClick: function() {
	            $("#interact_auth_type").val("001");
	            $("#interact_auth_text").text("所有人");
	          }
	        },
	        {
	          text: '仅自己',
	          onClick: function() {
		            $("#interact_auth_type").val("002");
		            $("#interact_auth_text").text("仅自己");
	          }
	        }
	      ];
	      var buttons2 = [
	        {
	          text: '取消',
	          bg: 'danger'
	        }
	      ];
	      var groups = [buttons1, buttons2];
	      $.actions(groups);
	}
	
	function saveInteract(event){
		event.stopPropagation();
		event.preventDefault();
		var interact_content = $("#i_content").val();
		var interact_pics = $("#interact_pics").val();
		var interact_auth_type = $("#interact_auth_type").val();
		if((!interact_content && !interact_pics) || (interact_content.length <= 0 && interact_pics.length <= 0)){
			$.toast("说点儿什么吧");
			$("#i_content").focus();
			return false;
		}
		var pics = $("#interact_pics").val();
		
	    var localIds = pics.split(",");
	    var serverId = "";
	    if (pics != null && pics.length > 0) {
	            wx.ready(function() {
	                var i = 0;
	                var length = localIds.length;
	                var upload = function() {
	                    wx.uploadImage({
	                        localId: localIds[i],
	                        success: function(res) {
	                            serverId += res.serverId + ',';
	                            // 如果还有照片，继续上传
	                            i++;
	                            if (i < length && i <=3) {
	                                upload();
	                            } else {
	                            	$.ajax({
	                        			type : "POST",
	                        			url : "fit-app-action-saveInteract",
	                        			data : {
	                        				cust_name : cust_name,
	                        				gym : gym,
	                        				user_id : id,
	                        				content : interact_content,
	                        				pics : interact_pics,
	                        				user_name : nickname,
	                        				auth_type : interact_auth_type,
	                        				serverId : serverId
	                        			},
	                        			dataType : "json",
	                        			success : function(data) {
	                        				$.hideIndicator();
	                        				if (data.rs == "Y") {
	                        					$.toast("发布成功"); 
	                        					$("#i_content").val("");
	                        					$("#interact_auth_type").val("001");
	                        					closePopup(".popup-addInteract");
	                        					showInteract();
	                        				} else {
	                        					$.toast(data.rs);
	                        				}
	                        			},
	                        			error : function(){
	                        				$.alert("啊哦，网络繁忙，请稍后再试");
	                        			}
	                        		});
	                            }
	                        }
	                    });
	                };
	                upload();

	            });
	
	}else{
		$.ajax({
			type : "POST",
			url : "fit-app-action-saveInteract",
			data : {
				cust_name : cust_name,
				gym : gym,
				user_id : id,
				content : interact_content,
				pics : interact_pics,
				user_name : nickname,
				auth_type : interact_auth_type,
				serverId : serverId
			},
			dataType : "json",
			success : function(data) {
				$.hideIndicator();
				if (data.rs == "Y") {
					$.toast("发布成功"); 
					$("#i_content").val("");
					$("#interact_auth_type").val("001");
					closePopup(".popup-addInteract");
					showInteract();
				} else {
					$.toast(data.rs);
				}
			},
			error : function(){
				$.alert("啊哦，网络繁忙，请稍后再试");
			}
		});
	}
	}
</script>
