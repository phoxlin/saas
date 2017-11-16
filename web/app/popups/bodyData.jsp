<%@page language="java" pageEncoding="UTF-8"%>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);
%>

<div class="popup bodyData">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.bodyData');"></a>
		<h1 class="title">体测数据</h1>
	</header>
	<div class="content" id="popup-sets-scroll" style="">
		<div class="content-padded grid-demo content-bg" style="text-align: center;margin: 0;padding:0.5rem">
		    <div class="row color-fff">
		      <div class="col-25" id="bodyHeightLast">0</div>
		      <div class="col-25" id="bodyWeightLast">0</div>
		      <div class="col-25" id="bodyBMILast">0</div>
		      <div class="col-25" id="bodyFatLast"><font>0</font></div>
		    </div>
		    <div class="row" style="color: darkgray;font-size: 0.6rem;">
		      <div class="col-25">身高</div>
		      <div class="col-25">体重</div>
		      <div class="col-25">BMI</div>
		      <div class="col-25">体脂</div>
		    </div>
		  </div>
		   <div class="content-block" style="margin: 0.5rem;padding: 0">
		    <p style="margin: 0.5rem">
		    	<input type="hidden" id="bodyDataMemId">
		    	<a href="#" class="custom-btn custom-btn-primary button-fill" style="background: white;height: 2rem;" onclick="openBodyDataDetail()">
		    		录入体测
		    	</a>
		    </p>
		  </div>
		  <div style="color: darkgray;font-size: 0.6rem" >
			      历史数据
		  </div>
			  <div class="list-block contacts-block" style="margin-top: 0px;font-size: 0.8rem;">
			    <div class="list-group">
			      <ul id="bodyDataListUl">
					<!-- <li onclick="openBodyDataDetail()">
						<a href="#" class="item-link item-content">
			          <div class="item-inner">
			            <div class="item-title-row">
			              <div class="item-title">2017年09月18号</div>
			            </div>
			          </div>
			        </a>
					</li>
					<li onclick="openBodyDataDetail()">
						<a href="#" class="item-link item-content">
			          <div class="item-inner">
			            <div class="item-title-row">
			              <div class="item-title">2017年09月18号</div>
			            </div>
			          </div>
			        </a>
					</li> -->
				  </ul>
			  </div>
		</div>
	</div>
</div>

<script type="text/html" id="bodyDataListTpl">
<#if(list && list.length>0){
	for(var i=0;i<list.length;i++){
		var item = list[i];
#>
					<li onclick="openBodyDataDetail('<#=item.id#>')">
						<a href="#" class="item-link item-content">
			          <div class="item-inner">
			            <div class="item-title-row">
			              <div class="item-title"><#=item.create_time.substring(0,10)#></div>
			            </div>
			          </div>
			        </a>
					</li>


<#}#>
<#}else{#>
<div class="none-info font-90">暂无体测数据</div>
<#}#>
</script>


<div class="popup bodyDataDetail">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.bodyDataDetail');"></a>
		<h1 class="title">录入体测数据</h1>
	</header>
	<div class="content">
		<div class="list-block media-list" style="margin: 0.5rem 0;">
	    <ul>
	      <li>
	      	<input type="hidden" id="bodyDataId">
	      	<input type="hidden" id="bodyDataDetailMemId">
	        <a href="#" class="item-link item-content">
	          <div class="item-inner">
	            <div class="item-title-row">
	              <div class="item-title">体测日期</div>
	              <div class="item-after"><input class="content-bg color-fff" id="bodyDataDate" style=" border:none;text-align: right;"></div>
	            </div>
	          </div>
	        </a>
	      </li>
	    </ul>
	  </div>
	  <div class="list-block media-list" style="margin: 0.5rem 0">
	    <div class="list-group">
	      <ul>
	        <li class="list-group-title" style="padding-left: 1rem;background: #242537;">基础数据</li>
	       <li>
	          <div class="item-inner">
	            <div class="item-title-row">
	              <div class="item-title color-ccc" style="padding-left: 1rem;">身高(cm)</div>
	              <div class="item-after"><input class="color-fff" id="bodyHight" type="number" style=" border:none;text-align: right;padding-right: 0.5rem;height: 1.5rem;" value="0"></div>
	            </div>
	          </div>
	      </li>
	       <li>
	          <div class="item-inner">
	            <div class="item-title-row">
	              <div class="item-title color-ccc" style="padding-left: 1rem;">体重(kg)</div>
	              <div class="item-after"><input class="color-fff" id="bodyWeight" type="number" style=" border:none;text-align: right;padding-right: 0.5rem;height: 1.5rem;"  value="0"></div>
	            </div>
	          </div>
	      </li>
	       <li>
	          <div class="item-inner">
	            <div class="item-title-row">
	              <div class="item-title color-ccc" style="padding-left: 1rem;">BMI(kg/m^2)</div>
	              <div class="item-after"><input class="color-fff" id="bodyBMI" type="number" style=" border:none;text-align: right;padding-right: 0.5rem;height: 1.5rem;"  value="0"></div>
	            </div>
	          </div>
	      </li>
	       <li>
	          <div class="item-inner">
	            <div class="item-title-row">
	              <div class="item-title color-ccc" style="padding-left: 1rem;">体脂(%)</div>
	              <div class="item-after"><input class="color-fff" id="bodyFat" type="number" style=" border:none;text-align: right;padding-right: 0.5rem;height: 1.5rem;"  value="0"></div>
	            </div>
	          </div>
	      </li>
	      <li class="list-group-title" style="background-color: #242537;padding-left: 1rem">身体围度</li>
	      <li>
	          <div class="item-inner">
	            <div class="item-title-row">
	              <div class="item-title color-ccc" style="padding-left: 1rem;">上臂左围(cm)</div>
	              <div class="item-after"><input class="color-fff" id="bodyUpperArm" type="number" style=" border:none;text-align: right;padding-right: 0.5rem;height: 1.5rem;"  value="0"></div>
	            </div>
	          </div>
	      </li>
	      <li>
	          <div class="item-inner">
	            <div class="item-title-row">
	              <div class="item-title color-ccc" style="padding-left: 1rem;">上臂右围(cm)</div>
	              <div class="item-after"><input class="color-fff" id="bodyLowerArm" type="number" style=" border:none;text-align: right;padding-right: 0.5rem;height: 1.5rem;"  value="0"></div>
	            </div>
	          </div>
	      </li>
	      <li>
	          <div class="item-inner">
	            <div class="item-title-row">
	              <div class="item-title color-ccc" style="padding-left: 1rem;">胸围(cm)</div>
	              <div class="item-after"><input class="color-fff" id="bodyBust" type="number" style=" border:none;text-align: right;padding-right: 0.5rem;height: 1.5rem;"  value="0"></div>
	            </div>
	          </div>
	      </li>
	      <li>
	          <div class="item-inner">
	            <div class="item-title-row">
	              <div class="item-title color-ccc" style="padding-left: 1rem;">腰围(cm)</div>
	              <div class="item-after"><input class="color-fff" id="bodyWaist" type="number" style=" border:none;text-align: right;padding-right: 0.5rem;height: 1.5rem;"  value="0"></div>
	            </div>
	          </div>
	      </li>
	      <li>
	          <div class="item-inner">
	            <div class="item-title-row">
	              <div class="item-title color-ccc" style="padding-left: 1rem;">臂围(cm)</div>
	              <div class="item-after"><input class="color-fff" id="bodyButtocks" type="number" style=" border:none;text-align: right;padding-right: 0.5rem;height: 1.5rem;"  value="0"></div>
	            </div>
	          </div>
	      </li>
	      <li>
	          <div class="item-inner">
	            <div class="item-title-row">
	              <div class="item-title color-ccc" style="padding-left: 1rem;">大腿围左(cm)</div>
	              <div class="item-after"><input class="color-fff" id="bodyLeftThigh" type="number" style=" border:none;text-align: right;padding-right: 0.5rem;height: 1.5rem;"  value="0"></div>
	            </div>
	          </div>
	      </li>
	      <li>
	          <div class="item-inner">
	            <div class="item-title-row">
	              <div class="item-title color-ccc" style="padding-left: 1rem;">大腿围右(cm)</div>
	              <div class="item-after"><input class="color-fff" id="bodyRightThigh" type="number" style=" border:none;text-align: right;padding-right: 0.5rem;height: 1.5rem;"  value="0"></div>
	            </div>
	          </div>
	      </li>
	      <li>
	          <div class="item-inner">
	            <div class="item-title-row">
	              <div class="item-title color-ccc" style="padding-left: 1rem;">小腿围左(cm)</div>
	              <div class="item-after"><input class="color-fff" id="bodyLeftShank" type="number" style=" border:none;text-align: right;padding-right: 0.5rem;height: 1.5rem;"  value="0"></div>
	            </div>
	          </div>
	      </li>
	      <li>
	          <div class="item-inner">
	            <div class="item-title-row">
	              <div class="item-title color-ccc" style="padding-left: 1rem;">小腿围右(cm)</div>
	              <div class="item-after"><input class="color-fff" id="bodyRightShank" type="number" style=" border:none;text-align: right;padding-right: 0.5rem;height: 1.5rem;"  value="0"></div>
	            </div>
	          </div>
	      </li>
	       <li class="list-group-title" style="background-color: #242537;padding-left: 1rem;">体测图片</li>
	      <li>
	      	 <div style="margin-top: 0.5rem;padding: 0.5rem;" class="content-bg">
				<div id="image_tice_div"></div>
				<input type="hidden" id="image_tice_div_hid">
				<input type="hidden" id="hasUploadImgs">
				<button onclick="uploadTiCe()" style="margin: 0 0.5rem 0.5rem 0;width: 4rem;height: 4rem;text-align: center;padding: 0;font-size: 2rem;border-radius: 0;border: 1px solid #999;background: #e6e6e6;" class="color-666">+</button>
			</div>
	       
	       </ul>
	      </div>
	    </div>
	     <div class="content-block">
		    <div class="row">
		      <div class="col-50"><a href="#" id="deleteBodyDataButton" onclick="deleteBodyDataById()" class="button button-big button-fill button-danger">删除</a></div>
		      <div class="col-50"><a href="#" onclick="saveBodyData()" class="button button-big button-fill button-success">保存</a></div>
		    </div>
		  </div>
	</div>
</div>

<script type="text/html" id="bodyDataImageTpl">
<#if(list){
#>
	<div class="row">
	<#if(list.pic1 != undefined && list.pic1 != ""){#>
	<img src="<#=list.pic1#>" style="width: 30%; height: 5.62rem;margin-left: 3px;" onclick="showAllPics('0',this)">				
	<#}#>
	<#if(list.pic2 != undefined && list.pic2 != ""){#>
	<img src="<#=list.pic2#>" style="width: 30%; height: 5.62rem;margin-left: 3px;" onclick="showAllPics('1',this)">				
	<#}#>
	<#if(list.pic3 != undefined && list.pic3 != ""){#>
	<img src="<#=list.pic3#>" style="width: 30%; height: 5.62rem;margin-left: 3px;" onclick="showAllPics('2',this)">				
	<#}#>
	<#if(list.pic4 != undefined && list.pic4 != ""){#>
	<img src="<#=list.pic4#>" style="width: 30%; height: 5.62rem;margin-left: 3px;" onclick="showAllPics('3',this)">				
	<#}#>
	<#if(list.pic5 != undefined && list.pic5 != ""){#>
	<img src="<#=list.pic5#>" style="width: 30%; height: 5.62rem;margin-left: 3px;" onclick="showAllPics('4',this)">				
	<#}#>
	<#if(list.pic6 != undefined && list.pic6 != ""){#>
	<img src="<#=list.pic6#>" style="width: 30%; height: 5.62rem;margin-left: 3px;" onclick="showAllPics('5',this)">				
	<#}#>
	<#if(list.pic7 != undefined && list.pic7 != ""){#>
	<img src="<#=list.pic7#>" style="width: 30%; height: 5.62rem;margin-left: 3px;" onclick="showAllPics('6',this)">				
	<#}#>
	<#if(list.pic8 != undefined && list.pic8 != ""){#>
	<img src="<#=list.pic8#>" style="width: 30%; height: 5.62rem;margin-left: 3px;" onclick="showAllPics('7',this)">				
	<#}#>
	<#if(list.pic9 != undefined && list.pic9 != ""){#>
	<img src="<#=list.pic9#>" style="width: 30%; height: 5.62rem;margin-left: 3px;" onclick="showAllPics('8',this)">				
	<#}#>
</div>
<#}#>



</script>

<script type="text/javascript">
var bodyDataDate = $("#bodyDataDate").val();
if(!bodyDataDate){
	var now = new Date().Format("yyyy-MM-dd");
	$("#bodyDataDate").calendar({
		value:[now]
	});
	$("#bodyDataDate").val(now);
}else{
	$("#bodyDataDate").calendar({
		value:[bodyDataDate]
	});
}
</script>