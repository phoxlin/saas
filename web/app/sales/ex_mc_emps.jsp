<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="popup popup-ex-pt-emps" id="popup-ex-pt-emps">
	<header class="bar bar-nav">
			<a class="icon icon-left pull-left" onclick="closePopup('.popup-ex-pt-emps')"></a>
			<h1 class="title">会籍管理</h1>
	</header>
	<div class="bar bar-header-secondary">
					<div class="searchbar">
						<div class="search-input">
							<label class="icon icon-search" for="search"></label> <input type="search" id="empReportName" placeholder="姓名">
						</div>
					</div>
				</div>
	<div class="content native-scroll">
		<div class="list-block" style="margin-top: 0px;margin-bottom: 0px">
	        <ul>
	          <!-- Text inputs -->
	          <!-- <li>
				<div class="item-content">
	              <div class="item-inner">
	                <div class="item-title label">日期</div>
	               		 <div class="item-input">
							<input type="text" id="empReportDate" onchange="searchExPtEmps(this.value)" placeholder="请选择日期" readonly="">
	              	 	 </div>
	        		</div>  
	        	</div>  
	       	 </li> 
	          <li>
				<div class="item-content">
	              <div class="item-inner">
	                <div class="item-title label">姓名</div>
	               		 <div class="item-input">
							<input type="text" style="width: 80%;float: left" id="empReportName" onchange="" placeholder="姓名">
							<label class="icon icon-search" onclick="searchExEmps()" style="margin-top: 0.5rem" for="search"></label>
	              	 	 </div>
	        		</div>  
	        	</div> 
		       	 
	       	 </li>  -->
	       	 </ul>
        </div>  
		<div class="list-block media-list border-list" style="margin-top: 0px;margin-bottom: 0px">
		    <ul id="ex-pt-empsList">
		    
		    </ul>
	  </div>
	</div>
</div>   
<script type="text/javascript">
 $('#empReportName').on('input propertychange', function() {
	     var search = $("#empReportName").val();
	    	 searchExEmps();
	});

</script>
 
<script type="text/html" id="ex-pt-empsTpl">
<#if(list && list.length>0){#>
	<#for(var i=0;i<list.length;i++){
		var emp = list[i];
	#>
		<li onclick="showMcOp('<#=emp.id#>','<#=emp.name#>')">
        <a href="#" class="item-link item-content">
		  <div class="item-media"><img src="<#=emp.headurl ||emp.pic_url || "app/images/head/default.png"#>" style='width: 2.2rem;height: 2.2rem;' class="head"></div>
          <div class="item-inner">
            <div class="item-title-row">
              <div class="item-title font-75 color-basic"><#=emp.name#></div>
              <div class="item-after"></div>
            </div>
            <div class="item-subtitle font-70 color-ccc"><#=emp.phone || "无电话"#></div>
            <!-- <div class="item-text">此处是文本内容...</div> -->
          </div>
        </a>
      </li>
	<#}#>
<#}else{#>
<div class="none-info font-90">暂无下属员工</div>
<#}#>
	 
</script>
<script type="text/html" id="showMemsByEmpsTpl">
<#if(list && list.length>0){#>
	<#for(var i=0;i<list.length;i++){
		var emp = list[i];
	#>
		<li onclick="showMcMemsById('<#=emp.id#>')">
        <a href="#" class="item-link item-content">
		  <div class="item-media"><img src="<#=emp.pic_url || "app/images/head/default.png"#>" style='width: 2.2rem;height: 2.2rem;' class="head"></div>
          <div class="item-inner">
            <div class="item-title-row">
              <div class="item-title font-75 color-333"><#=emp.name#></div>
              <div class="item-after"></div>
            </div>
            <div class="item-subtitle font-70 color-666"><#=emp.phone || "无电话"#></div>
            <!-- <div class="item-text">此处是文本内容...</div> -->
          </div>
        </a>
      </li>
	<#}#>
<#}else{#>
<div class="none-info font-90">暂无数据</div>
<#}#>
	 
</script>

<script type="text/javascript">
$("#empReportDate").calendar({
    value: [new Date().Format("yyyy-MM-dd")]
});
$("#empReportDate").val(new Date().Format("yyyy-MM-dd"));
</script>