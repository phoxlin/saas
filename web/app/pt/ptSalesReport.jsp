<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
#ptSalesReportDiv .col-30{
	padding-left: 1rem;
}
#ptSalesReportDiv .row{
	text-align: center;
	padding-top: 0.3rem;
	padding-bottom: 0.3rem;
}

</style>

<div class="popup popup-ptSalesReport">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-ptSalesReport');"></a>
		<h1 class="title" id="ptSalesReportTitle">我的报表</h1>
	</header>
	<div class="content" id="ptSalesReport" style="margin-top: 0px;margin-bottom: 0px">
		<div class="list-block" style="margin-top: 0px;margin-bottom: 0px">
		    <ul>
		      <li>
		        <div class="item-content">
		          <div class="item-media"><i class="icon icon-form-name"></i></div>
		          <div class="item-inner">
		            <div class="item-title label color-999">日期</div>
		            <div class="item-input">
		              <input type="text" class="color-fff" id="ptReportDate" readonly="readonly">
		            </div>
		          </div>
		        </div>
		      </li>
		     </ul> 
		</div>
		<div class="content-padded grid-demo content-bg" id="ptSalesReportDiv"  style="margin-top: 0.5rem;margin-left:0px;margin-right:0px;">
		    <div class="row">
		      <div class="col-30" style="text-align: center">项目</div>
		      <div class="col-20" id="date_day">天</div>
		      <div class="col-20" id="date_month">月</div>
		      <div class="col-20">总共</div>
		    </div>
		    <div class="row">
		      <div class="col-30">私教售课</div>
		      <div class="col-20"></div>
		      <div class="col-20"></div>
		      <div class="col-20"></div>
		    </div>
		    <div class="row">
		      <div class="col-30">私教售额</div>
		      <div class="col-20"></div>
		      <div class="col-20"></div>
		      <div class="col-20"></div>
		    </div>
		    <div class="row">
		      <div class="col-30">私教消课</div>
		      <div class="col-20"></div>
		      <div class="col-20"></div>
		      <div class="col-20"></div>
		    </div>
		    <div class="row">
		      <div class="col-30">学员维护</div>
		      <div class="col-20"></div>
		      <div class="col-20"></div>
		      <div class="col-20"></div>
		    </div>
		</div>
		
		
	</div>
</div>

<script type="text/javascript">
var now = new Date().Format("yyyy-MM-dd");
$("#ptReportDate").calendar({
    value: [now]
});
$("#ptReportDate").val(now);
</script>

<script type="text/html" id="ptSalesReportTpl">
 			<div class="row">
		      <div class="col-30" style="text-align: center">项目</div>
		      <div class="col-20" id="date_day"><#=new Date(date).Format("MM-dd")#></div>
		      <div class="col-20" id="date_month"><#=new Date(date).Format("MM")+"月"#></div>
		      <div class="col-20">总共</div>
		    </div>
		    <div class="row">
		      <div class="col-30">私教售课</div>
		      <div class="col-20" style="color:green;"><#=getSalesTimes(dayInfos,'006')#></div>
		      <div class="col-20" style="color:green;"><#=getSalesTimes(monthInfos,'006')#></div>
		      <div class="col-20" style="color:green;"><#=getSalesTimes(allInfos,'006')#></div>
		    </div>                             
		    <div class="row">
		      <div class="col-30">私教售额</div>
		      <div class="col-20" style="color:green;"><#=getSalesAmt(dayInfos,'006')#></div>
		      <div class="col-20" style="color:green;"><#=getSalesAmt(monthInfos,'006')#></div>
		      <div class="col-20" style="color:green;"><#=getSalesAmt(allInfos,'006')#></div>
		    </div>
		    <div class="row">
		      <div class="col-30">私教消次</div>
		      <div class="col-20" style="color:red;"><#=getPtReportNumber(reduceClass,'day')#></div>
		      <div class="col-20" style="color:red;"><#=getPtReportNumber(reduceClass,'month')#></div>
		      <div class="col-20" style="color:red;"><#=getPtReportNumber(reduceClass,'all')#></div>
		    </div>
		    <div class="row">
			  <div class="col-30">团课消次</div>
		      <div class="col-20" style="color:green;"><#=getPtReportNumber(reduceGClass,'day')#></div>
		      <div class="col-20" style="color:green;"><#=getPtReportNumber(reduceGClass,'month')#></div>
		      <div class="col-20" style="color:green;"><#=getPtReportNumber(reduceGClass,'all')#></div>
			</div>
		    </div>
		    <div class="row">
		      <div class="col-30">学员维护</div>
		      <div class="col-20" style="color:red;"><#=getPtReportNumber(maintainInfos,'day')#></div>
		      <div class="col-20" style="color:red;"><#=getPtReportNumber(maintainInfos,'month')#></div>
		      <div class="col-20" style="color:red;"><#=getPtReportNumber(maintainInfos,'all')#></div>
			<%-- 
			  <div class="col-20" style="color:red;"><#=getMemNumber(maintainInfos,'pt','day')#></div>
		      <div class="col-20" style="color:red;"><#=getMemNumber(maintainInfos,'pt','month')#></div>
		      <div class="col-20" style="color:red;"><#=getMemNumber(maintainInfos,'pt','all')#></div>  --%>
		    </div>
</script>


