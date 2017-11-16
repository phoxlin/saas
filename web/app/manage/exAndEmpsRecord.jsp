<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
<!--
#exAndEmpsRecordDiv:first-child .col-25:first-child{
}
#exAndEmpsRecordDiv .row{
	text-align: center;
	padding-top: 0.3rem;
	padding-bottom: 0.3rem;
}
-->
</style>
<div class="popup popup-exAndEmpsRecord" id="popup-exAndEmpsRecord">
	<header class="bar bar-nav">
			<a class="icon icon-left pull-left" onclick="closePopup('.popup-exAndEmpsRecord')"></a>
			<h1 class="title" id="exAndEmpsRecordTitile">我和下属的报表</h1>
	</header>
	<div class="content native-scroll">
		<div class="list-block" style="margin-top: 0px;margin-bottom: 0px">
		    <ul>
		      <li>
		        <div class="item-content">
		          <div class="item-media"><i class="icon icon-form-name"></i></div>
		          <div class="item-inner">
		            <div class="item-title label">日期</div>
		            <div class="item-input">
		              <input type="text" class="color-fff" id="exAndEmpsRecordDay" readonly="readonly">
		            </div>
		          </div>
		        </div>
		      </li>
		     </ul> 
		</div>
		<div class="content-bg" id="exAndEmpsRecordDiv"  style="margin-top: 0.5rem;margin-left:0px;margin-right:0px;">
		</div>
	</div>

</div>    
<script type="text/javascript">
var now = new Date().Format("yyyy-MM-dd");
$("#exAndEmpsRecordDay").calendar({
    value: [now]
});
</script>

<script type="text/html" id="exAndEmpsRecordTpl">
			<h3 style="text-align:center;">销售统计</h3>
 			<div class="row">
		      <div class="col-25" style="text-align: center">项目</div>
		      <div class="col-15" id="date_day"><#=new Date(date).Format("dd")+"日"#></div>
		      <div class="col-20" id="date_week">本周</div>
		      <div class="col-20" id="date_month"><#=new Date(date).Format("MM")+"月"#></div>
		      <div class="col-20">总共</div>
		    </div>
<#if(role !='pt'){#>
		    <div class="row">
		      <div class="col-25">时间售卡</div>
			  <div class="col-15" style="color:red;"><#=getSalesNum(dayInfos,'001')#></div>
			  <div class="col-20" style="color:red;"><#=getSalesNum(weekInfos,'001')#></div>
		      <div class="col-20" style="color:red;"><#=getSalesNum(monthInfos,'001')#></div>
		      <div class="col-20" style="color:red;"><#=getSalesNum(allInfos,'001')#></div>
		    </div>
<#}#>
<#if(role !='mc'){#>
			<div class="row">
		      <div class="col-25">私教售课</div>
		      <div class="col-15" style="color:red;"><#=getSalesTimes(dayInfos,'006')#></div>
		      <div class="col-20" style="color:red;"><#=getSalesTimes(weekInfos,'006')#></div>
		      <div class="col-20" style="color:red;"><#=getSalesTimes(monthInfos,'006')#></div>
		      <div class="col-20" style="color:red;"><#=getSalesTimes(allInfos,'006')#></div>
		    </div>
<#}#>
<#if(role !='pt'){#>
		    <div class="row">
		      <div class="col-25">次卡售次</div>
		      <div class="col-15" style="color:red;"><#=getSalesTimes(dayInfos,'003')#></div>
		      <div class="col-20" style="color:red;"><#=getSalesTimes(weekInfos,'003')#></div>
		      <div class="col-20" style="color:red;"><#=getSalesTimes(monthInfos,'003')#></div>
		      <div class="col-20" style="color:red;"><#=getSalesTimes(allInfos,'003')#></div>
		    </div>
		    <div class="row">
		      <div class="col-25">储值售额</div>
		      <div class="col-15" style="color:red;"><#=getSalesAmt(dayInfos,'002')#></div>
		      <div class="col-20" style="color:red;"><#=getSalesAmt(weekInfos,'002')#></div>
		      <div class="col-20" style="color:red;"><#=getSalesAmt(monthInfos,'002')#></div>
		      <div class="col-20" style="color:red;"><#=getSalesAmt(allInfos,'002')#></div>
		    </div>
		    <div class="row">
		      <div class="col-25">时间售额</div>
		      <div class="col-15" style="color:red;"><#=getSalesAmt(dayInfos,'001')#></div>
		      <div class="col-20" style="color:red;"><#=getSalesAmt(weekInfos,'001')#></div>
		      <div class="col-20" style="color:red;"><#=getSalesAmt(monthInfos,'001')#></div>
		      <div class="col-20" style="color:red;"><#=getSalesAmt(allInfos,'001')#></div>
		    </div>
<#}#>		    
<#if(role !='mc'){#>
		    <div class="row">
		      <div class="col-25">私教售额</div>
		      <div class="col-15" style="color:red;"><#=getSalesAmt(dayInfos,'006')#></div>
		      <div class="col-20" style="color:red;"><#=getSalesAmt(weekInfos,'006')#></div>
		      <div class="col-20" style="color:red;"><#=getSalesAmt(monthInfos,'006')#></div>
		      <div class="col-20" style="color:red;"><#=getSalesAmt(allInfos,'006')#></div>
		    </div>
<#}#>
<#if(role !='pt'){#>
		    <div class="row">
		      <div class="col-25">次卡售额</div>
		      <div class="col-15" style="color:red;"><#=getSalesAmt(dayInfos,'003')#></div>
		      <div class="col-20" style="color:red;"><#=getSalesAmt(weekInfos,'003')#></div>
		      <div class="col-20" style="color:red;"><#=getSalesAmt(monthInfos,'003')#></div>
		      <div class="col-20" style="color:red;"><#=getSalesAmt(allInfos,'003')#></div>
		    </div>
<#}#>
<#if(role =='boss'){#>
		    <div class="row">
		      <div class="col-25">转卡售额</div>
		      <div class="col-15" style="color:green;"><#=getSalesAmt2(otherInfos,'转卡手续费','day')#></div>
		      <div class="col-20" style="color:green;"><#=getSalesAmt2(otherInfos,'转卡手续费','week')#></div>
		      <div class="col-20" style="color:green;"><#=getSalesAmt2(otherInfos,'转卡手续费','month')#></div>
		      <div class="col-20" style="color:green;"><#=getSalesAmt2(otherInfos,'转卡手续费','all')#></div>
		    </div>
		    <div class="row">
		      <div class="col-25">请假售额</div>
		      <div class="col-15" style="color:green;"><#=getSalesAmt(leaveInfos,'day')#></div>
		      <div class="col-20" style="color:green;"><#=getSalesAmt(leaveInfos,'week')#></div>
		      <div class="col-20" style="color:green;"><#=getSalesAmt(leaveInfos,'month')#></div>
		      <div class="col-20" style="color:green;"><#=getSalesAmt(leaveInfos,'all')#></div>
		    </div>
 			<div class="row">
		      <div class="col-25">租柜售额</div>
		      <div class="col-15" style="color:green;"><#=getSalesAmt2(otherInfos,'租柜费用','day')#></div>
		      <div class="col-20" style="color:green;"><#=getSalesAmt2(otherInfos,'租柜费用','week')#></div>
		      <div class="col-20" style="color:green;"><#=getSalesAmt2(otherInfos,'租柜费用','month')#></div>
		      <div class="col-20" style="color:green;"><#=getSalesAmt2(otherInfos,'租柜费用','all')#></div>
		    </div>
 			<div class="row">
		      <div class="col-25">商品售额</div>
		      <div class="col-15" style="color:green;"><#=getSalesAmt(goodsInfos,'day')#></div>
		      <div class="col-20" style="color:green;"><#=getSalesAmt(goodsInfos,'week')#></div>
		      <div class="col-20" style="color:green;"><#=getSalesAmt(goodsInfos,'month')#></div>
		      <div class="col-20" style="color:green;"><#=getSalesAmt(goodsInfos,'all')#></div>
		    </div>
 			<div class="row">
		      <div class="col-25">散客售额</div>
		      <div class="col-15" style="color:green;"><#=getSalesAmt(fitInfos,'day')#></div>
		      <div class="col-20" style="color:green;"><#=getSalesAmt(fitInfos,'week')#></div>
		      <div class="col-20" style="color:green;"><#=getSalesAmt(fitInfos,'month')#></div>
		      <div class="col-20" style="color:green;"><#=getSalesAmt(fitInfos,'all')#></div>
		    </div>
<#}#>

<#if(role == 'boss' || role =='pt'){#>
				<h3 style="text-align:center;">消课(费)统计</h3>
<#}#>			
<#if(role == 'boss'){#>
			<div class="row">
			  <div class="col-25">出入场数</div>
		      <div class="col-15" style="color:green;"><#=getPtReportNumber(checkinInfos,'day')#></div>
		      <div class="col-20" style="color:green;"><#=getPtReportNumber(checkinInfos,'week')#></div>
		      <div class="col-20" style="color:green;"><#=getPtReportNumber(checkinInfos,'month')#></div>
		      <div class="col-20" style="color:green;"><#=getPtReportNumber(checkinInfos,'all')#></div>
			</div>
<#}#>
<#if(role != 'mc'){#>
			<div class="row">
			  <div class="col-25">私教消课</div>
		      <div class="col-15" style="color:green;"><#=getPtReportNumber(reduceClass,'day')#></div>
		      <div class="col-20" style="color:green;"><#=getPtReportNumber(reduceClass,'week')#></div>
		      <div class="col-20" style="color:green;"><#=getPtReportNumber(reduceClass,'month')#></div>
		      <div class="col-20" style="color:green;"><#=getPtReportNumber(reduceClass,'all')#></div>
			</div>
<#}#>
<#if(role == 'boss'){#>
			<div class="row">
			  <div class="col-25">次卡消次</div>
		      <div class="col-15" style="color:green;"><#=getPtReportNumber(reduceTimesCard,'day')#></div>
		      <div class="col-20" style="color:green;"><#=getPtReportNumber(reduceTimesCard,'week')#></div>
		      <div class="col-20" style="color:green;"><#=getPtReportNumber(reduceTimesCard,'month')#></div>
		      <div class="col-20" style="color:green;"><#=getPtReportNumber(reduceTimesCard,'all')#></div>
			</div>
<#}#>
			<h3 style="text-align:center;">会员统计</h3>
			<div class="row">
		      <div class="col-25">新增会员</div>
		      <div class="col-15" style="color:green;"><#=getMemNumber(memInfos,'day','001')#></div>
		      <div class="col-20" style="color:green;"><#=getMemNumber(memInfos,'week','001')#></div>
		      <div class="col-20" style="color:green;"><#=getMemNumber(memInfos,'month','001')#></div>
		      <div class="col-20" style="color:green;"><#=getMemNumber(memInfos,'all','001')#></div>
		    </div>
		    <div class="row">
		      <div class="col-25">会员维护</div>
		      <div class="col-15" style="color:green;"><#=getMemNumber(maintainInfos,'day','001')#></div>
		      <div class="col-20" style="color:green;"><#=getMemNumber(maintainInfos,'week','001')#></div>
		      <div class="col-20" style="color:green;"><#=getMemNumber(maintainInfos,'month','001')#></div>
		      <div class="col-20" style="color:green;"><#=getMemNumber(maintainInfos,'all','001')#></div>
		    </div>
		    <div class="row">
		      <div class="col-25">新增潜客</div>
		      <div class="col-15" style="color:#FF6100;"><#=getMemNumber(memInfos,'day','003')+ (role=="boss"?getMemNumber(memInfos,'day','004'):0)#></div>
		      <div class="col-20" style="color:#FF6100;"><#=getMemNumber(memInfos,'week','003')+(role=="boss"?getMemNumber(memInfos,'week','004'):0)#></div>
		      <div class="col-20" style="color:#FF6100;"><#=getMemNumber(memInfos,'month','003')+(role=="boss"?getMemNumber(memInfos,'month','004'):0)#></div>
		      <div class="col-20" style="color:#FF6100;"><#=getMemNumber(memInfos,'all','003')+(role=="boss"?getMemNumber(memInfos,'all','004'):0)#></div>
		    </div>
		    <div class="row">
		      <div class="col-25">潜客维护</div>
		      <div class="col-15" style="color:#FF6100;"><#=getMemNumber(maintainInfos,'day','004')#></div>
		      <div class="col-20" style="color:#FF6100;"><#=getMemNumber(maintainInfos,'week','004')#></div>
		      <div class="col-20" style="color:#FF6100;"><#=getMemNumber(maintainInfos,'month','004')#></div>
		      <div class="col-20" style="color:#FF6100;"><#=getMemNumber(maintainInfos,'all','004')#></div>
		    </div>
</script>