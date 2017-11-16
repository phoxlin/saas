<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="popup popup-fit-plan dark" id="popup-fit-plan">
	<header class="bar bar-nav">
			<a class="icon icon-left pull-left" onclick="closePopup('.popup-fit-plan')"></a>
			<h1 class="title">健身计划(我的学员)</h1>
	</header>
	<input type ="hidden" id="fit_plan_pt_id">
	
	<div class="bar bar-header-secondary">
		<div class="searchbar" style="background: #242537;">
			<div class="search-input" >
				<input  type="search" style="width:85%;float:left" id="fit_plan_ptsMem_search" placeholder="搜索会员姓名/手机号">
				<div style="padding-left: 0.5rem">
					<a onclick="queryPtMems(false);" style="margin-left: 0.5rem;" class="color-basic">搜搜</a>
				</div>
			</div>
		</div>
	</div>
	<div class="content native-scroll">
		<div class="list-block" style="margin-top: 0px;margin-bottom: 0px" id="fit_plan_ptsMem">
			
		</div>
	</div>

</div>    

<div class="popup popup-fit-plan-mem dark" id="popup-fit-plan">
	<header class="bar bar-nav">
			<a class="icon icon-left pull-left" onclick="closePopup('.popup-fit-plan-mem')"></a>
			<h1 class="title">健身计划</h1>
	</header>
	<div class="content native-scroll">
		<input type="hidden" id="fit_plan_mem_id">
		<input type="hidden" id="fit_plan_mem_gym">
		<input type="hidden" id="fit_plan_pt_id">
		<div class="list-block media-list" style="margin-top: 0px;margin-bottom: 0px">
        <ul>
       	 <li>
	        <div class="item-content">
	          <div class="item-media"><img src="" id="fitPlanMemHead" style='width: 2.2rem;'></div>
	          <div class="item-inner">
	            <div class="item-title-row">
	              <div class="item-title" id="fitPlanMemName">学员姓名</div>
	              <div class="item-subtitle"><a onclick="addNewFitPlan()"  class="color-basic">新增计划</a></div>
	            </div>
	            <div class="item-subtitle"></div>
	          </div>
	        </div>
	      </li>
	     </ul>
	    </div>
	    <!-- 已有计划 -->
	     <div class="list-block" style="margin-top: 0px;margin-bottom: 0px">
        <ul>
          <li style="display: none">
			<div class="item-content">
              <div class="item-inner">
                <div class="item-input" style="width: 40%">
                  <input class="color-fff" type="text" placeholder="开始时间" id="fit_plan_start_time" onchange="queryHasPlan()" readonly="">
                </div>
                <div class="item-input" style="width: 40%">
                  <input class="color-fff" type="text" placeholder="结束时间" id="fit_plan_end_time" onchange="queryHasPlan()"readonly="">
                </div>
                <label class="icon icon-search"  onclick="queryHasPlan()" for="search"></label>
              </div>
        	</div>  
       	 </li>
          <li>
			<div class="item-content">
              <div class="item-inner">
                <div class="item-input" style="width: 40%">
                  <input class="color-fff" type="text" placeholder="选择月份" id="fit_plan_month" readonly="">
                </div>
                <label class="icon icon-search"  onclick="queryHasPlan()" for="search"></label>
              </div>
        	</div>  
       	 </li>
       	 </ul>
       	 </div>
	    <div class="" id="memHasFitPlan" style="margin-top: 0px;margin-bottom: 0px">
	    
		 </div>
	</div>
</div>    

<script type="text/javascript">
/* var firstDay = new Date().Format("yyyy-MM")+"-01";
$("#fit_plan_start_time").calendar({
    value: [firstDay]
});
$("#fit_plan_start_time").val(firstDay);
$("#fit_plan_end_time").calendar({
    value: [now]
});
$("#fit_plan_end_time").val(now); */
/*$("#fit_plan_ptsMem_search").on('input propertychange', function() {
	queryPtMems(false);
});*/
var plan_month = getPickerMonths(2);
$("#fit_plan_month").picker({
	  toolbarTemplate: '<header class="bar bar-nav">\<button class="button button-link pull-right close-picker">确定</button>\<h1 class="title">选择月份</h1>\</header>',
		  cols: [
		    {
		      textAlign: 'center',
		      values:plan_month
		    }
		  ], onClose :function(v){
	    	  queryHasPlan();  
	      } 
		});
$("#fit_plan_month").val(now.substring(0,7));
</script>
<script type="text/html" id="fit_plan_pt_mems">
<#if(list && list.length>0){#>
	 <ul>
	<#for(var i=0;i<list.length;i++){
		var mem = list[i];
	#>
      <li>
        <a href="#" class="item-link item-content">
          <div class="item-media"><img src="<#=mem.headurl || mem.pic1 ||"app/images/head/default.png"#>" style='width: 2.2rem;'></div>
          <div class="item-inner">
            <div class="item-title-row">
              <div class="item-title"><#=mem.name#></div>
            </div>
            <div class="item-subtitle" onclick="makeFitPlan('<#=mem.id#>','<#=mem.headurl || mem.pic1 || "app/images/head/default.png"#>','<#=mem.name#>','<#=mem.gym#>','<#=pt_id#>')">查看计划</div>
          </div>
        </a>
      </li>
	<#}#>
    </ul>
<#}else{#>
<div class="none-info font-90">暂无学员</div>
<#}#>


</script>
<!-- 编辑计划 -->
<script type="text/html" id="fit_plan_pt_readyPlanTpl">
<#
if(list && list.length>0){
#>
	<#for(var i=0;i<list.length;i++){
		var plan = list[i];
		var details = list[i].plans;
	#>
	<div class="card">
        <div class="card-header content-bg"><input class="content-bg" style="border:0px" id="<#=plan.id#>title" type="text" value="<#=plan.title#>" readonly>
		<#if("pt" == userType){#>
			<a href="javascript:void(0)" class="color-basic" onclick="ptEditFitPlan('<#=plan.id#>',this)">编辑</a>
		<#}#>
		</div>
   	    <div class="card-content">
			<div class="list-block">
			<ul>
				<li>
       			   <div class="item-content">
       			   <div class="item-media"><i class="icon icon-form-name"></i></div>
         		   <div class="item-inner">
           		      <div class="item-title label color-999">开始时间</div>
          		  	  <div class="item-input">
         		     <input type="text" class="color-fff" placeholder="日期" id="<#=plan.id#>start_time" readonly value="<#=plan.start_time.substring(0,10)#>" id="hasFitPlanStartTime">
         		   </div>
        		   </div>
        		   </div>
               </li>
 				<li>
       			 <div class="item-content">
       			   <div class="item-media"><i class="icon icon-form-name"></i></div>
      			    <div class="item-inner">
       			     <div class="item-title label color-999">结束时间</div>
       			     <div class="item-input">
       			       <input type="text" class="color-fff" placeholder="日期" id="<#=plan.id#>end_time" readonly value="<#=plan.end_time.substring(0,10)#>" id="hasFitPlanEntTime">
        		    </div>
     		     </div>
     		   </div>
   			   </li>
			</ul>
			</div>

<#if(details && details.length >0){#>
		<div class="list-block  media-list">
	 	   <ul>
		  <#for(var j=0;j<details.length;j++){
			var detail = details[j];
		  #>
	      <li>
	          <div class="item-inner" style="padding-left: 1.5rem;">
	            <div class="item-title-row">
	              <div class="item-title color-999">第<#=detail.num#>节课</div>
	              <div class="item-after color-fff">
						<#if(userType =="pt" && detail.mem_confirm != 'Y'){#>
							<button class="custom-btn custom-btn-primary font-75" onclick="showEditFitPlanDetail('<#=JSON.stringify(detail)#>','<#=plan.mem_gym#>')">编辑</button>
						<#}#>
						&nbsp;
						<#if(detail.plan_content || userType=="pt"){#>
							<button class="custom-btn custom-btn-primary font-75" onclick="showFitPlanDetail('<#=plan.id#>','<#=detail.id#>','<#=userType#>','<#=plan.mem_gym#>')">查看</button>
						<#}else{#>
							请等待
						<#}#>
				  </div>
	            </div>
	            <div class="item-subtitle"><#=detail.mem_confirm == "Y"?"会员:已确认":"会员:未确认"#>
					&nbsp;内容安排:<#=detail.plan_content || "暂无"#>
				</div>
	          </div>
	      </li>
			<#}#>
	  </ul>
		</div>
<#}else{#>
暂无计划详情
<#}#>
		</div>
       <div class="card-footer content-bg">
			<#if(userType =="pt"){#>
				<div class="content-block" id="<#=plan.id#>edit" style="width:100%;display:none">
    				<div class="row">
     					<div class="col-50"><a href="javascript:void(0)" onclick="deleteFitPlan('<#=plan.id#>','<#=plan.mem_gym#>')" class="button button-big button-fill button-danger">删除</a></div>
      					<div class="col-50"><a href="javascript:void(0)" onclick="saveEditFitPlan('<#=plan.id#>')" class="button button-big button-fill button-success">保存 </a></div>
    				</div>
	   			</div>
			<#}else{#>

			<#}#>
		</div>
</div>
	<#}#>
<#}else{#>
<div class="none-info font-90">暂无计划安排</div>
<#}#>
</script>

<script type="text/html" id="memHasFitPlanTpl">
<#
var has =0;
if(list && list.length>0){
#>
 <ul>
	<#for(var i=0;i<list.length;i++){
		var mem = list[i];
		if(!mem.plan_content || mem.plan_content==""){
			continue;
		}
		has ++;
	#>
 			<li onclick="showFitPlanDetail('<#=mem.id#>','<#="mem"==type ?"mem":"pt"#>')">
		        <a href="#" class="item-link item-content">
		          <div class="item-inner">
		            <div class="item-title-row">
		              <div class="item-title"><#=mem.pt_name || "未知教练"#></div>
		              <div class="item-after"><#=mem.start_time.substring(0,10)#></div>
		            </div>
		            <div class="item-subtitle"><#=mem.plan_content#></div>
		          </div>
		        </a>
		      </li>
	<#}#>
</ul>
<#}if(has == 0){#>
<div class="none-info font-90"><#if("mem" == type){#>还没有任何计划噢<#}else{#>该会员还没有计划,快快行动起来<#}#></div>
<#
$("#memHasFitPlan").prev().hide();
}
else{$("#memHasFitPlan").prev().show();}#>
</script>








<!-- --------------------------------会员查看计划--------------------------------------- -->

<!-- 新增计划 -->
<div class="popup popup-fit-plan-add-new dark" id="popup-fit-plan-add-new">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-fit-plan-add-new')"></a>
		<h1 class="title">新增健身计划</h1>
	</header>
	<div class="content native-scroll">
	    <div class="list-block" style="">
        <ul>
       	 <li>
        <div class="item-content">
          <div class="item-inner">
            <div class="item-title label">计划课数</div>
            <div class="item-input">
              <input type="number" class="color-fff" id="fitPlanNumber" placeholder="数量" >
            </div>
          </div>
        </div>
      	</li>
       	 <li>
        <div class="item-content">
          <div class="item-inner">
            <div class="item-title label">计划标题</div>
            <div class="item-input">
              <input type="text" class="color-fff" id="fitPlanTitle"  placeholder="标题" >
            </div>
          </div>
        </div>
      	</li>
       	 <li>
        <div class="item-content">
          <div class="item-inner">
            <div class="item-title label">开始时间</div>
            <div class="item-input">
              <input type="text" class="color-fff" id="fitPlanStartTime" readonly="readonly" placeholder="日期" >
            </div>
          </div>
        </div>
      	</li>
       	 <li>
        <div class="item-content">
          <div class="item-inner">
            <div class="item-title label">结束时间</div>
            <div class="item-input">
              <input type="text" class="color-fff" id="fitPlanEndTime" readonly="readonly" placeholder="日期" >
            </div>
          </div>
        </div>
      	</li>
      	</ul>
      	</div>
         <div class="list-block" style="margin-top: 0px;margin-bottom: 0px">
          <ul>
      	<li>
      		 <div class="row">
		      <div class="col-50"><a href="#" onclick="closePopup('.popup-fit-plan-add-new')" class="button button-big button-fill button-danger">取消</a></div>
		      <div class="col-50"><a href="#" onclick="createPlan()" class="button button-big button-fill button-success">保存</a></div>
		    </div>
      	</li>
       	 </ul>
        </div>  
	
	</div>
</div>

<script type="text/javascript">
var now = new Date().Format("yyyy-MM-dd");
$("#fitPlanStartTime").calendar({
    value: [now]
});
$("#fitPlanEndTime").calendar({
	value: [now]
});
</script>

<div class="popup popup-fit-plan-mem-my dark" id="popup-fit-plan">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-fit-plan-mem-my')"></a>
		<h1 class="title">我的健身计划</h1>
	</header>
	<div class="content native-scroll">
	    <!-- 已有计划 -->
	     <div class="list-block" style="margin-top: 0px;margin-bottom: 0px">
        <ul>
          <li style="display: none">
			<div class="item-content">
              <div class="item-inner">
                <div class="item-input" style="width: 40%">
                  <input type="text" placeholder="开始时间" id="my_fit_plan_start_time" onchange="showMemFitPlan()" readonly="">
                </div>
                <div class="item-input" style="width: 40%">
                  <input type="text" placeholder="结束时间" id="my_fit_plan_end_time" onchange="showMemFitPlan()" readonly="">
                </div>
                <label class="icon icon-search"  onclick="showMemFitPlan()" for="search"></label>
              </div>
        	</div>  
       	 </li>
       	 <li>
       	 	<div class="item-content">
              <div class="item-inner">
                <div class="item-input" style="width: 40%">
                  <input type="text" placeholder="选择月份" id="my_fit_plan_month" readonly="">
                </div>
                <label class="icon icon-search"  onclick="showMemFitPlan()" for="search"></label>
              </div>
        	</div>  
       	 </li>
       	 </ul>
       	 </div>
	    <div class="list-block" id="myFitPlanlist" style="margin-top: 0px;margin-bottom: 0px">
		   
		 </div>
        
	</div>
</div>    


<script type="text/javascript">
/* var firstDay = new Date().Format("yyyy-MM")+"-01";
$("#my_fit_plan_start_time").calendar({
    value: [firstDay]
});
$("#my_fit_plan_start_time").val(firstDay);
$("#my_fit_plan_end_time").calendar({
    value: [now]
});
$("#my_fit_plan_end_time").val(now);
 */
 var plan_month = getPickerMonths(2);
 $("#my_fit_plan_month").picker({
 	  toolbarTemplate: '<header class="bar bar-nav">\<button class="button button-link pull-left">按钮</button>\<button class="button button-link pull-right close-picker">确定</button>\<h1 class="title">选择月份</h1>\</header>',
 		  cols: [
 		    {
 		      textAlign: 'center',
 		      values:plan_month
 		    }
 		  ], onClose :function(v){
 			 showMemFitPlan();  
 	      } 
 		});
 $("#my_fit_plan_month").val(now.substring(0,7));
</script>


<div class="popup popup-fit-plan-mem-detial dark" id="">
	<input type="hidden" id="fit_plan_detail_id">
	<input type="hidden" id="fit_plan_detail_mem_gym">
	<input type="hidden" id="fit_plan_type">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-fit-plan-mem-detial')"></a>
		<h1 class="title" id="">计划详情</h1>
	</header>
	<div class="content native-scroll" id="fit_plan_detail_div">
	</div>
</div>

<script type="text/html" id="fitPlanDetailTpl">
<#if(fit_plan && detail){#>
 <div class="list-block">
    		<ul>
 <li>
        <div class="item-content">
          <div class="item-media"><i class="icon icon-form-name"></i></div>
          <div class="item-inner">
            <div class="item-title label">第<#=detail.num#>节</div>
            <div class="item-input">
             <#=detail.start?detail.start.substring(0,16):"--"#>&nbsp;到&nbsp; <#=detail.end?detail.end.substring(10,16):"--"#>
            </div>
          </div>
        </div>
      </li>
			 <li>
        <div class="item-content">
          <div class="item-media"><i class="icon icon-form-name"></i></div>
          <div class="item-inner">
            <div class="item-title label">教练</div>
            <div class="item-input">
              <#=fit_plan.name#>
            </div>
          </div>
        </div>
      </li>
 <li>
        <div class="item-content">
          <div class="item-media"><i class="icon icon-form-name"></i></div>
          <div class="item-inner">
            <div class="item-title label">学员</div>
            <div class="item-input">
             <#=fit_plan.mem_name#>
            </div>
          </div>
        </div>
      </li>
    		<li class="align-top">
		        <div class="item-content">
		          <div class="item-media"><i class="icon icon-form-comment"></i></div>
		          <div class="item-inner">
		            <div class="item-title label">内容详情</div>
		            <div class="item-input">
		              <textarea readonly="readonly"><#=detail.plan_content ||  "暂无健身安排"#></textarea>
		            </div>
		          </div>
		        </div>
		      </li>
 <li>
        <div class="item-content">
          <div class="item-media"><i class="icon icon-form-name"></i></div>
          <div class="item-inner">
            <div class="item-title label">会员结课确认</div>
            <div class="item-input">
				<#if(detail.plan_content){#> 
             		<input type="checkbox" onchange="plan_detail_confirm(this,'<#=detail.id#>','<#=fit_plan.mem_gym#>','<#=type#>')"  id="mem_confirm_checkbox" <#if(detail.mem_confirm =='Y'){#> checked <#}#> <#if(type !="mem" || detail.mem_confirm =="Y"){#> disabled <#}#>>
					&nbsp;<#=detail.mem_confirm_time?detail.mem_confirm_time.substring(0,16):""#>
				<#}else{#>
				暂无健身安排,无法确认
				<#}#>
            </div>
          </div>
        </div>
      </li>
 <li>
        <div class="item-content">
          <div class="item-media"><i class="icon icon-form-name"></i></div>
          <div class="item-inner">
            <div class="item-title label">教练结课确认</div>
            <div class="item-input">
			<#if(detail.plan_content){#> 
              <input type="checkbox" onchange="plan_detail_confirm(this,'<#=detail.id#>','<#=fit_plan.mem_gym#>','<#=type#>')" id="pt_confirm_checkbox" <#if(detail.pt_confirm =='Y'){#> checked <#}#> <#if(type !="pt" || detail.pt_confirm =="Y"){#> disabled <#}#>>
			 	<#=detail.pt_confirm_time?detail.pt_confirm_time.substring(0,16):""#>
			<#}else{#>
				暂无健身安排,无法确认
			<#}#>
            </div>
          </div>
        </div>
      </li>
				<#if(detail.mem_say){#>
 				<li class="align-top">
		        <div class="item-content">
		          <div class="item-media"><i class="icon icon-form-comment"></i></div>
		          <div class="item-inner">
		            <div class="" style="width: 35%;-webkit-flex-shrink: 0;-ms-flex: 0 0 auto; -webkit-flex-shrink: 0; flex-shrink: 0;/* margin: 1rem 0; */ padding-right: 0.5rem;">
					<#="mem"==type?"我":fit_plan.mem_name#>的评论</div>
		            <div class="item-input">
		              <textarea readonly><#=detail.mem_say#></textarea>
		            </div>
		          </div>
		        </div>
		      </li>
				<#}#>
				<#if(detail.pt_say){#>
 				<li class="align-top">
		        <div class="item-content">
		          <div class="item-media"><i class="icon icon-form-comment"></i></div>
		          <div class="item-inner">
		             <div class="" style="width: 35%;-webkit-flex-shrink: 0;-ms-flex: 0 0 auto; -webkit-flex-shrink: 0; flex-shrink: 0;/* margin: 1rem 0; */ padding-right: 0.5rem;">
					<#="pt"==type?"我":fit_plan.mem_name#>的评论</div>
		            <div class="item-input">
		              <textarea readonly><#=detail.pt_say#></textarea>
		            </div>
		          </div>
		        </div>
		      </li>
				<#}#>

				<#if((!detail.mem_say && "mem"==type)|| (!detail.pt_say && "pt"==type)){#>
		      <li class="align-top">
		        <div class="item-content">
		          <div class="item-media"><i class="icon icon-form-comment"></i></div>
		          <div class="item-inner">
		            <div class="item-title label">我要评论</div>
		            <div class="item-input">
		              <textarea id="fit_plan_my_speak" placeholder="说说你的感受吧"></textarea>
		            </div>
		          </div>
		        </div>
		      </li>
				<#}#>

    		</ul>
       	</div>
		<#if((!detail.mem_say && "mem"==type)|| (!detail.pt_say && "pt"==type)){#>
       	<div class="content-block">
		    <div class="row">
		      <div class="col-100"><a href="#" 
			<#if(detail.plan_content){#> 
				onclick="submitMySay('<#=detail.id#>','<#=fit_plan.mem_gym#>','<#=type#>')" class="button button-big button-fill button-success"  
			<#}else{#>
				class="button button-big button-fill button-dark"
			<#}#>
			 >发表评论</a></div>
		    </div>
		  </div>
		<#}#>
<#}else{#>
记录消失在未知空间了
<#}#>
</script>

<div class="popup popup-fit-plan-detail-list dark" id="popup-fit-plan-detail-list">
	<header class="bar bar-nav">
			<a class="icon icon-left pull-left" onclick="closePopup('.popup-fit-plan-detail-list')"></a>
			<h1 class="title">会员的计划</h1>
	</header>
	
	<div class="content native-scroll">
		<div class="list-block  media-list">
	 	   <ul>
	      <li>
	        <div class="item-content">
	          <div class="item-media"><i class="icon icon-form-name"></i></div>
	          <div class="item-inner">
	            <div class="item-input">
	              <input type="text" id="edit_fit_plan_title" placeholder="标题">
	            </div>
	          </div>
	        </div>
	      </li>
	      <li>
	        <a href="#" class="item-link item-content">
	          <div class="item-inner">
	            <div class="item-title-row">
	              <div class="item-title">Facebook</div>
	              <div class="item-after">17:14</div>
	            </div>
	            <div class="item-subtitle">子标题</div>
	          </div>
	        </a>
	      </li>
	     </ul>
	    </div>
	</div>
	
</div>

<script type="text/html" id="popup-fit-plan-detail-listTpl">
<#if(mem){#>
	<header class="bar bar-nav">
			<a class="icon icon-left pull-left" onclick="closePopup('.popup-fit-plan-detail-list')"></a>
			<h1 class="title">[<#=mem.mem_name#>]的计划详情</h1>
	</header>
<#}#>


</script>


<div class="popup popup-fit-plan-edit dark" id="">
	<header class="bar bar-nav">
			<a class="icon icon-left pull-left" onclick="closePopup('.popup-fit-plan-edit')"></a>
			<h1 class="title">编辑计划内容</h1>
	</header>
	<div class="content native-scroll">
		<input type="hidden" id="edit_fit_detail_id">
		<input type="hidden" id="detail_gym">
		<div class="list-block">
 	   <ul>
 	     <li>
	        <div class="item-content">
	          <div class="item-media"><i class="icon icon-form-name"></i></div>
	          <div class="item-inner">
	            <div class="item-title label">日期</div>
	            <div class="item-input">
	              <input type="text" id="edit_fit_plan_date" placeholder="请选择">
	            </div>
	          </div>
	        </div>
	      </li>
	       <li>
	        <div class="item-content">
	          <div class="item-media"><i class="icon icon-form-name"></i></div>
	          <div class="item-inner">
	            <div class="item-title label">开始时间</div>
	            <div class="item-input">
	              <input type="text" id="edit_fit_plan_start" placeholder="请选择">
	            </div>
	          </div>
	        </div>
	      </li>
	       <li>
	        <div class="item-content">
	          <div class="item-media"><i class="icon icon-form-name"></i></div>
	          <div class="item-inner">
	            <div class="item-title label">结束时间</div>
	            <div class="item-input">
	              <input type="text" id="edit_fit_plan_end" placeholder="请选择">
	            </div>
	          </div>
	        </div>
	      </li>
			<!-- <li>----------------------------------</li>  
	      <li>
	        <div class="item-content">
	          <div class="item-media"><i class="icon icon-form-name"></i></div>
	          <div class="item-inner">
	            <div class="item-title label">开始时间</div>
	            <div class="item-input">
	              <input type="text" id="edit_fit_plan_start_time" placeholder="请选择">
	            </div>
	          </div>
	        </div>
	      </li>
	      <li>
	        <div class="item-content">
	          <div class="item-media"><i class="icon icon-form-name"></i></div>
	          <div class="item-inner">
	            <div class="item-title label">结束时间</div>
	            <div class="item-input">
	              <input type="text" id="edit_fit_plan_end_time" placeholder="请选择">
	            </div>
	          </div>
	        </div>
	      </li> -->
	      <li class="align-top">
	        <div class="item-content">
	          <div class="item-media"><i class="icon icon-form-comment"></i></div>
	          <div class="item-inner">
	            <div class="item-title label">计划详情</div>
	            <div class="item-input">
	              <textarea placeholder="在这里写噢" id="edit_fit_plan_content"></textarea>
	            </div>
	          </div>
	        </div>
	      </li>
		</ul>
		<div class="content-block">
	    <div class="row">
	      <div class="col-50"><a href="#" onclick="closePopup('.popup-fit-plan-edit')" class="button button-big button-fill button-danger">取消</a></div>
	      <div class="col-50"><a href="#" onclick="saveFitPlanDetail()" class="button button-big button-fill button-success">提交</a></div>
	    </div>
	  </div>
	</div>

	</div>    
</div>
<script type="text/javascript">

</script>