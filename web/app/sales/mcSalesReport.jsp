<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
#mcSalesReportDiv .col-30{
	padding-left: 1rem;
}
#mcSalesReportDiv .row{
	text-align: center;
	padding-top: 0.3rem;
	padding-bottom: 0.3rem;
}

</style>
<div class="popup popup-mcSalesReport">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-mcSalesReport');"></a>
		<h1 class="title" id="mcSalesReportTitle">我的报表</h1>
	</header>
	<div class="content" id="mcSalesReport" style="margin-top: 0px;margin-bottom: 0px">
		<div class="list-block" style="margin-top: 0px;margin-bottom: 0px">
		    <ul>
		      <li>
		        <div class="item-content">
		          <div class="item-media"><i class="icon icon-form-name"></i></div>
		          <div class="item-inner">
		            <div class="item-title label color-999">日期</div>
		            <div class="item-input">
		              <input type="text" class="color-fff" id="reportDate" readonly="readonly">
		            </div>
		          </div>
		        </div>
		      </li>
		     </ul> 
		</div>
		<div class="content-padded grid-demo content-bg" id="mcSalesReportDiv"  style="margin-top: 0.5rem;margin-left:0px;margin-right:0px;">
		    <div class="row">
		      <div class="col-30" style="text-align: center">项目</div>
		      <div class="col-20" id="date_day">天</div>
		      <div class="col-20" id="date_month">月</div>
		      <div class="col-20">总共</div>
		    </div>
		    <div class="row">
		      <div class="col-30">新增会员</div>
		      <div class="col-20"></div>
		      <div class="col-20"></div>
		      <div class="col-20"></div>
		    </div>
		    <div class="row">
		      <div class="col-30">会员维护</div>
		      <div class="col-20"></div>
		      <div class="col-20"></div>
		      <div class="col-20"></div>
		    </div>
		    <div class="row">
		      <div class="col-30">新增潜客</div>
		      <div class="col-20"></div>
		      <div class="col-20"></div>
		      <div class="col-20"></div>
		    </div>
		    <div class="row">
		      <div class="col-30">潜客维护</div>
		      <div class="col-20"></div>
		      <div class="col-20"></div>
		      <div class="col-20"></div>
		    </div>
		    <div class="row">
		      <div class="col-30">时间售卡</div>
		      <div class="col-20"></div>
		      <div class="col-20"></div>
		      <div class="col-20"></div>
		    </div>
		    <div class="row">
		      <div class="col-30">时间售额</div>
		      <div class="col-20"></div>
		      <div class="col-20"></div>
		      <div class="col-20"></div>
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
		      <div class="col-30">次卡售次</div>
		      <div class="col-20"></div>
		      <div class="col-20"></div>
		      <div class="col-20"></div>
		    </div>
		    <div class="row">
		      <div class="col-30">次卡售额</div>
		      <div class="col-20"></div>
		      <div class="col-20"></div>
		      <div class="col-20"></div>
		    </div>
		    <div class="row">
		      <div class="col-30">储值售额</div>
		      <div class="col-20"></div>
		      <div class="col-20"></div>
		      <div class="col-20"></div>
		    </div>
		</div>
		
		
	</div>
</div>

<script type="text/javascript">
var now = new Date().Format("yyyy-MM-dd");
$("#reportDate").calendar({
    value: [now]
});
$("#reportDate").val(now);
</script>

<script type="text/html" id="mcSalesReportTpl">
 			<div class="row">
		      <div class="col-30" style="text-align: center">项目</div>
		      <div class="col-20" id="date_day"><#=new Date(date).Format("MM-dd")#></div>
		      <div class="col-20" id="date_month"><#=new Date(date).Format("MM")+"月"#></div>
		      <div class="col-20">总共</div>
		    </div>
		    <div class="row">
		      <div class="col-30">新增会员</div>
		      <div class="col-20" style="color:green;"><#=getMemNumber(memInfos,'day','001')#></div>
		      <div class="col-20" style="color:green;"><#=getMemNumber(memInfos,'month','001')#></div>
		      <div class="col-20" style="color:green;"><#=getMemNumber(memInfos,'all','001')#></div>
		    </div>
		    <div class="row">
		      <div class="col-30">会员维护</div>
		      <div class="col-20" style="color:green;"><#=getMemNumber(maintainInfos,'day','mc')#></div>
		      <div class="col-20" style="color:green;"><#=getMemNumber(maintainInfos,'month','mc')#></div>
		      <div class="col-20" style="color:green;"><#=getMemNumber(maintainInfos,'all','mc')#></div>
		    </div>
		    <div class="row">
		      <div class="col-30">新增潜客</div>
		      <div class="col-20" style="color:#FF6100;"><#=getMemNumber(memInfos,'day','003')#></div>
		      <div class="col-20" style="color:#FF6100;"><#=getMemNumber(memInfos,'month','003')#></div>
		      <div class="col-20" style="color:#FF6100;"><#=getMemNumber(memInfos,'all','003')#></div>
		    </div>
		    <div class="row">
		      <div class="col-30">潜客维护</div>
			<div class="col-20" style="color:red;"><#=getMemNumber(maintainInfos,'day','qmc')#></div>
		      <div class="col-20" style="color:red;"><#=getMemNumber(maintainInfos,'month','qmc')#></div>
		      <div class="col-20" style="color:red;"><#=getMemNumber(maintainInfos,'all','qmc')#></div>
			<%-- 
		      <div class="col-20" style="color:#FF6100;"><#=getMemNumber(maintainInfos,'day','003')#></div>
		      <div class="col-20" style="color:#FF6100;"><#=getMemNumber(maintainInfos,'month','003')#></div>
		      <div class="col-20" style="color:#FF6100;"><#=getMemNumber(maintainInfos,'all','003')#></div>
		    --%>
		    </div>
		    <div class="row">
		      <div class="col-30">时间售卡</div>
			  <div class="col-20" style="color:red;"><#=getSalesNum(dayInfos,'001')#></div>
		      <div class="col-20" style="color:red;"><#=getSalesNum(monthInfos,'001')#></div>
		      <div class="col-20" style="color:red;"><#=getSalesNum(allInfos,'001')#></div>
		    </div>
		    <div class="row">
		      <div class="col-30">时间售额</div>
		      <div class="col-20" style="color:red;"><#=getSalesAmt(dayInfos,'001')#></div>
		      <div class="col-20" style="color:red;"><#=getSalesAmt(monthInfos,'001')#></div>
		      <div class="col-20" style="color:red;"><#=getSalesAmt(allInfos,'001')#></div>
		    </div>
		    <div class="row">
		      <div class="col-30">私教售课</div>
		      <div class="col-20" style="color:red;"><#=getSalesTimes(dayInfos,'006')#></div>
		      <div class="col-20" style="color:red;"><#=getSalesTimes(monthInfos,'006')#></div>
		      <div class="col-20" style="color:red;"><#=getSalesTimes(allInfos,'006')#></div>
		    </div>
		    <div class="row">
		      <div class="col-30">私教售额</div>
		      <div class="col-20" style="color:red;"><#=getSalesAmt(dayInfos,'006')#></div>
		      <div class="col-20" style="color:red;"><#=getSalesAmt(monthInfos,'006')#></div>
		      <div class="col-20" style="color:red;"><#=getSalesAmt(allInfos,'006')#></div>
		    </div>
		    <div class="row">
		      <div class="col-30">次卡售次</div>
		      <div class="col-20" style="color:red;"><#=getSalesTimes(dayInfos,'003')#></div>
		      <div class="col-20" style="color:red;"><#=getSalesTimes(monthInfos,'003')#></div>
		      <div class="col-20" style="color:red;"><#=getSalesTimes(allInfos,'003')#></div>
		    </div>
		    <div class="row">
		      <div class="col-30">次卡售额</div>
		      <div class="col-20" style="color:red;"><#=getSalesAmt(dayInfos,'003')#></div>
		      <div class="col-20" style="color:red;"><#=getSalesAmt(monthInfos,'003')#></div>
		      <div class="col-20" style="color:red;"><#=getSalesAmt(allInfos,'003')#></div>
		    </div>
		    <div class="row">
		      <div class="col-30">储值售额</div>
		      <div class="col-20" style="color:red;"><#=getSalesAmt(dayInfos,'002')#></div>
		      <div class="col-20" style="color:red;"><#=getSalesAmt(monthInfos,'002')#></div>
		      <div class="col-20" style="color:red;"><#=getSalesAmt(allInfos,'002')#></div>
		    </div>
</script>