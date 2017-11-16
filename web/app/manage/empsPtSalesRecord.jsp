<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-empsPtPrivateSalesRecord" id="popup-empsPtPrivateSalesRecord">
	<header class="bar bar-nav">
			<a class="icon icon-left pull-left" onclick="closePopup('.popup-empsPtPrivateSalesRecord')"></a>
			<h1 class="title" id="mepsPtHeaderTitle">私教销售记录</h1>
	</header>
	<div class="content native-scroll">
		<div class="list-block" style="margin-top: 0px;margin-bottom: 0px">
        <ul>
          <!-- Text inputs -->
          <li>
		<div class="item-content">
              <div class="item-inner" style="text-align: center;display: block;">
                <div class="item-input tooltips-link tooltips-link2" style="width: 3.5rem;display: inline-block;">
					<input type="text" style="width: 3.5rem;" class="font-75" id="empsPtPrivateSalesDay" placeholder="请选择时间" readonly="">
                </div>
        	</div>  
        	</div>  
       	 </li>
       	 </ul>
        </div>    
		<div class="list-block media-list" style="margin-top: 0px">
		    <ul id="empsPtPrivateSalesUl">
		      
		    </ul>
	    </div>
	</div>

</div>    
<script type="text/javascript">
var now = new Date().Format("yyyy-MM-dd");
$("#empsPtPrivateSalesDay").calendar({
    value: [now]
});
</script>