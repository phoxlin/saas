<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%

	FitUser user=(FitUser)SystemUtils.getSessionUser(request, response);
	if(user==null){ request.getRequestDispatcher("/").forward(request, response);}
	
	String cust_name = user.getCust_name();
	String gym = user.getViewGym();
	
	String taskcode = "f_goods_price_change";
	String taskname = "商品价格变动记录";
	String sId = request.getParameter("sid");
	String sql = "select * from f_goods_price_change where cust_name = '"+cust_name+"' and gym ='"+gym+"'";

%>
<!DOCTYPE html>
<html>
<head>
<title><%=taskname%></title>
<jsp:include page="/public/base.jsp" />
<script type="text/javascript">
var f_goods_price_change___f_goods_price_change_params={sql:"<%=sql %>"};

//data-grid配置开始
///////////////////////////////////////////(1).f_goods_price_change___f_goods_price_change开始///////////////////////////////////////////
	//搜索配置
	var f_goods_price_change___f_goods_price_change_filter=[
		{"rownum":1,"compare":"=","colnum":3,"label":"商品","type":"text","columnname":"goods_id","bindType":"sql","bindData":"select id code,goods_name note from f_goods where cust_name ='<%=cust_name%>' and gym = '<%=gym%>'"},
		{"rownum":1,"compare":"=","colnum":4,"label":"规格","type":"text","columnname":"version_id","bindType":"sql","bindData":"select id code,version note from f_good_version where cust_name ='<%=cust_name%>' and gym = '<%=gym%>'"},														
		{"rownum":1,"compare":">=","colnum":5,"label":"起始时间(包含)","type":"datetime","columnname":"op_time"},														
		{"rownum":1,"compare":"<","colnum":6,"label":"结束时间(不包含)","type":"datetime","columnname":"op_time"}								

				      	 ];
	//编辑页面弹框标题配置
	var f_goods_price_change___f_goods_price_change_dialog_title='商品价格变动记录';
	//编辑页面弹框宽度配置
	var f_goods_price_change___f_goods_price_change_dialog_width=700;
	//编辑页面弹框高度配置
	var f_goods_price_change___f_goods_price_change_dialog_height=500;
	//IndexGrid数据加载提示配置
	var f_goods_price_change___f_goods_price_change_loading=true;
	//编辑页面弹框宽度配置
	var f_goods_price_change___f_goods_price_change_entity="f_goods_price_change";
	//编辑页面路径配置
	var f_goods_price_change___f_goods_price_change_nextpage="pages/f_goods_price_change/f_goods_price_change_edit.jsp";
///////////////////////////////////////////(1).f_goods_price_change___f_goods_price_change结束///////////////////////////////////////////

//data-grid配置结束

</script>
<script type="text/javascript" charset="utf-8" src="pages/f_goods_price_change/index.js"></script>
<script type="text/javascript" charset="utf-8" src="pages/f_goods_price_change/f_goods_price_change.js"></script>

<script type="text/javascript">
	$(document).ready(function() {
		showTaskView('<%=taskcode%>','<%=sId%>','N');
		setTimeout(() => {
			$("#f_goods_price_change___f_goods_price_change_goods_id_search_0").change(function(){
				var goods_id = $(this).val();
				if(goods_id == ""){
					return;
				}
				$.ajax({
					url:"fit-bg-good-version-query-by-goodsId",
					type:"POST",
					dataType:"JSON",
					async:false,
					data:{goods_id:goods_id},
					success:function(data){
						if(data.rs == "Y"){
							var html = "<option value=''>规格</option>";							
							if(data.list){
								for(var i = 0;i<data.list.length;i++){
									var version = data.list[i];
									html +="<option value='"+version.id+"'>"+version.version+"</option>";
								}
							}
							$("#f_goods_price_change___f_goods_price_change_version_id_search_1").html(html);
							
						}else{
							error(data.rs);
						}
					}
				});
			});
		}, 1000);
	});
</script>
</head>
<div class="">
		<div class="">
			<div class="main2">
				<div class="row">
					<div class="col-lg-12 col-md-12 col-xs-12">
						<div id="<%=taskcode%>_jh_process_page"> </div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>