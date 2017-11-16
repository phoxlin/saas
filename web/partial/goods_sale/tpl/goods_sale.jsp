<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<script type="text/html" id="goodsListTpl">
					<ul class="nav nav-tabs nav-tabs-custom" role="tablist">
                        <#if(goodsType){
                          for(var i =0;i<goodsType.length;i++){
                              var d = goodsType[i];
                              var xx = d.id;
                              var _class="";
                            if(d.id ==tab_id){
                              _class= "active";
                            }else{
                              _class= "";
                              }
                          #>
                           <li role="presentation " class="<#=_class#>" onclick="showGoods('<#=d.id#>')" >
							<a href="#<#=xx#>"  aria-controls="home" role="tab" data-toggle="tab">
								<span class="nav-tabs-left"></span>
								<span class="nav-tabs-text"><#=d.type_name#></span>
								<span class="nav-tabs-right"></span>
							</a>
					   	</li>
                        <#}}#>
					 </ul>
					
					<div class="tab-content" style="margin-top: 20px;padding: 0 20px;">
                        <#if(goodsType){
                             
                          for(var i =0;i<goodsType.length;i++){
                              var g = goodsType[i];
                              var xx = g.id;
                             var _class="";
                            if(xx ==tab_id){
                              _class= "active";
                            }else{
                              _class= "";
                              }
                         #>
						<div role="tabpanel" class="tab-pane tab-good-pane <#=_class#>" id="<#=xx#>">
							<div class="row">
                               <# if(all){
                                       var len = all.length;
                                 for(var j = 0;j<all.length;j++){
                                    var d = all[j];
                                  if(g.id == d.type){
                                  var pic =d.pic_url;
                                    pic = pic !=undefined?pic:"partial/goods_sale/images/default_goods.jpg";
                                #>
								<div class="col-md-3 goods-block" style="margin-top:10px" onclick="showGoodsInList(this)" data-id='<#=JSON.stringify(d) #>'>
									<div class="col-md-4">
										<img src="<#=pic#>" style="width:80px;height:80px;" />
									</div>
									<div class="col-md-8 goods-info">
										<div class="line-one" title="<#=d.goods_name#>"><#=d.goods_name#></div>
										<div><span><#=d.version#></span></div>
										<div><span>库存<#=d.num#></span><span><font style="color: #dd0000;">￥<#=d.goods_price/100#></font></span></div>
									</div>
								</div>
                                <# }else if(xx == "all"){
                                  var pic =d.pic_url;
                                    pic = pic !=undefined?pic:"partial/goods/images/default_goods.jpg";
                                  #>
                                <div class="col-md-3 goods-block" style="margin-top:10px"  onclick="showGoodsInList(this)" data-id='<#=JSON.stringify(d) #>'>
									<div class="col-md-4">
										<img src="<#=pic#>" style="width:80px;height:80px;" />
									</div>
									<div class="col-md-8 goods-info">
										<div class="line-one" title="<#=d.goods_name#>"><#=d.goods_name#></div>
										<div><span><#=d.version#></span></div>
										<div><span>库存<#=d.num#></span><span><font color='#dd0000'>￥<#=d.goods_price/100#></font></span></div>
									</div>
								</div>
                                  <# }}#>
                                
							</div>
                               <nav aria-label="Page navigation" style="text-align:right;">
								  <ul class="pagination">
                                      <#  
										var pageLen = (totalSize % 8) == 0 ?(totalSize/8):(totalSize/8+1);
                                         for(var k = 1;k<=pageLen;k++){
                                      #>
								   			<li><a onclick="showGoods('<#=tab_id#>','<#=k#>')"><#=k#></a></li>
                                       <#}#>
								  </ul>
								</nav>
						</div>
                        <#}}}#>
					</div>
    </script>
    
    <script type="text/html" id="goodsTR">
	<#
		var price = g.goods_price / 100;
		var emp_price = g.emp_price / 100;
		if(emp) {
			var oprice = g.goods_price;
			var emp_percent = g.emp_percent;
			if(emp_percent && emp_percent > 0 && emp_percent <= 100) {
				price = Math.round(oprice * emp_percent / 100) / 100;
			}
		}
	#>

  <tr id="<#=g.id#>" data-exsit="true">
	<#var f = $("#is_emp_price").is(":checked");#>
     <td id="<#=g.id#>__name" style="width:20%"><#=g.goods_name+"("+g.version+")"#></td>
     <td style="width:10%">￥&nbsp;
	<span id="<#=g.id#>__price" <#if(f){#>style="display:none"<#}#>><#=price#></span>
	<span id="<#=g.id#>__emp_price" <#if(!f){#>style="display:none"<#}#>><#=emp_price#></span>
	</td>
     <td style="width:46%">
     	<div class="row">
			<div class="col-xs-6">
				<div class="btn-group">
				  <button type="button" class="btn btn-default" style="" onclick="reduceNum('<#=g.id#>')">&nbsp;&nbsp;-&nbsp;&nbsp;</button>
				  <input type="number" id="<#=g.id#>__num" onkeyup="checkGoodsStoreNum('<#=g.id#>',this.value)" value="0" class="form-control goods-num" style="float:left;width:100px;text-align:center">
				  <button type="button" class="btn btn-default" style="" onclick="addNum('<#=g.id#>')">&nbsp;&nbsp;+&nbsp;&nbsp;</button>
				</div>
			</div>
			<div id="<#=g.id#>__store_num_div" class="col-xs-5" style="line-height:2.6;">
				库存:<span id="<#=g.id#>__store_num"><#=g.num#></span><span id="<#=g.id#>__warn_msg" style="color:red;margin-left:5px;"></span>
			</div>
		</div>
  	</td>
    <td style="width:12%">
    	￥&nbsp;<span id="<#=g.id#>__total_ca">0</span>
  	</td>
    <td style="width:12%">
    	￥&nbsp;<span id="<#=g.id#>__total_mem" <#if(f){#>style="display:none"<#}#> >0</span><span id="<#=g.id#>__total_emp" <#if(!f){#>style="display:none"<#}#>>0</span>
  	</td>
  </tr>
</script>