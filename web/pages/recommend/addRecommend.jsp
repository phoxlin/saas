<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>新增访客</title>
<%
	FitUser user = (FitUser)SystemUtils.getSessionUser(request, response);
	if (user == null) {
		request.getRequestDispatcher("/").forward(request, response);
	}
	String cust_name = user.getCust_name();
	String gym = user.getViewGym();
	String fk_user_id = request.getParameter("fk_user_id");
%>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">

<link rel="stylesheet" type="text/css" href="public/sb_admin2/bower_components/bootstrap/dist/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="partial/css/addMem.css">
<link rel="stylesheet" type="text/css" href="public/fit/css/btn.css">
<script src="public/js/store.js"></script>
<script src="partial/js/cashier.js"></script>
<script src="public/sb_admin2/bower_components/jquery/dist/jquery.min.js"></script>
<script type="text/javascript" charset="utf-8" src="public/js/template.js"></script>
<script type="text/javascript">
</script>
</head>
<style>
.col-xs-10{
	height:18px;
}
.select-card-form>.input-panel {
    margin-bottom: 20px;
/*     text-align: center; */
}
.nav {
    padding-left: 0;
    margin-bottom: 0;
    list-style: none;
}

.nav-tabs {
    margin-left: 0;
    -webkit-padding-start: 0;
    font-size: 14px;
}
.nav-tabs>li{
	background: transparent;
}
.nav-tabs>li>a{
	color: #337ab7 !important;
}
</style>
<link rel="stylesheet" media="all"
	href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/public/css/bootstrap.min.css" />
<body >


   <div class="container">
		<form id="form1" style="overflow-y: auto; padding-right: 30px;" onsubmit="return false;"
			class="select-card-form">
			
			<div class="input-panel">
				<label>电话号码</label>
				<input type="text" id="visitor_phoneNum"  onkeyup="search_recommend();" style="width:300px" name="f_mem__phone"  placeholder="电话号码"  />
			</div>
			
			<div class="input-panel">
				<label>姓&emsp;&emsp;名</label>
				<input type="text" id="visitor_name" style="width:300px" name="f_mem__mem_name"  placeholder="姓名"  />
			</div>
			
			<div class="input-panel" >
				<label>性&emsp;&emsp;别</label>
				<select id = "f_mem__sex" style="width:300px">
					<option value="male">男</option>
					<option value="female">女</option>
				</select>
			</div>
			<div class="input-panel">
				<label>生&emsp;&emsp;日</label>
				<input type="date" id="f_mem__birthday" style="width:300px" name="f_mem__birthday"  placeholder="生日"  />
			</div>
			
			
			
			<div class="input-panel">
				<label>身&nbsp;&nbsp;份&nbsp;证</label>
				<input type="number" id="visitor_idNum" style="width:300px" name="f_mem__id_card"  placeholder="身份证"  />
			</div>
			
			<div class="input-panel">
				<label>会&emsp;&emsp;籍</label>
 			<div class="bind" style="width: 300px">
					<div class="col-xs-10" onclick="getemps('sales')">
						<span style="vertical-align: super;" id="salesName">点击选择会籍</span> <input type="hidden" name="f_mem__mc_id" id="sales"> <span class="sub-title"></span>
					</div>
					<div class="col-xs-2">
						<button onclick="Unbundled('sales')">解绑</button>
					</div>
				</div>
			</div>
			
			<div class="input-panel">
				<label>教&emsp;&emsp;练</label>
			<div class="bind" style="width: 300px">
					<div class="col-xs-10" onclick="getemps('coach')">
						<span style="vertical-align: super;" id="coachName">点击选择教练</span> <input type="hidden" id="coach" name="f_mem__pt_names"> <span class="sub-title"></span>
					</div>
					<div class="col-xs-2">
						<button onclick="Unbundled('coach')">解绑</button>
					</div>
				</div>
			</div>
			<div class="input-panel">
					<label>推荐会员 </label>
					<div class="bind" style="width:300px">
						<div class="col-xs-10" onclick="getMem('mem')">
							<span style="vertical-align: super;" id="memName">点击选择会员</span> 
							<span class="sub-title">会员</span>
							<input type="hidden" id="mem_id" name="mem_id" value="">
						</div>
						<div class="col-xs-2">
							<button>解绑</button>
						</div>
					</div>
				</div>
			<div class="input-panel">
				<textarea rows="1" cols="50"id="remark" style="width:388px" name="f_mem__remark" placeholder="备注"></textarea>
			</div>
			
	     </form>
	     <button onclick="addVisitor()" class="btn btn-primary-plain" style="margin-left: 280px;">保存新增推荐</button>
      </div>
</body>
<script type="text/javascript">

function getemps(type) {
	var typeName = "员工";
	if ("sales" == type) {
		typeName = "会籍";
	} else if ("coach" == type) {
		typeName = "教练";
	}
	top.dialog(
					{
						url : "partial/chioceEmp.jsp?userType=" + type,
						title : "选择" + typeName,
						width : 820,
						height : 550,
						okValue : "确定",
						ok : function() {
							var iframe = $(window.parent.document)
									.contents()
									.find("[name="+ $(this)[0].id + "]")[0].contentWindow;
							iframe.saveId(this);
							var sales = store.getJson("sales");
							if (sales && typeof sales.name !='undefined') {
								$("#salesName").html(sales.name);
								$("#sales").val(sales.id);
							}
							store.set('sales', {});
							var coach = store.getJson("coach");
							if (coach && typeof coach.name !='undefined') {
								$("#coachName").html(coach.name);
								$("#coach").val(coach.id);
							}
							store.set('coach', {});
							return false;
						},
						cancelValue : "取消",
						cancel : function() {
							return true;
						}
					}).showModal();
}

function getMem(type){
	  var typeName="会员";
	 top.dialog({
	        url: "partial/chioceMem.jsp?gym="+'<%=gym%>',
	        title: "选择"+typeName,
	        width: 920,
	        height: 430,
	        okValue: "确定",
	        ok: function() {
	        	var iframe = $(window.parent.document).contents().find("[name=" + top.dialog.getCurrent().id + "]")[0].contentWindow;
	            iframe.saveId(this);
	           var mem = store.getJson("mem");
	        	   $("#memName").html(mem.name);
	        	   $("#mem_id").val(mem.id);
	           store.set('mem',{});
	            return false;
	        },
	        cancelValue:"取消",
	        cancel:function(){
	        	return true;
	        }
	    }).showModal();
}

function Unbundled(type) {
	if ("sales" == type) {
		$("#salesName").html("");
		$("#sales").val();
	}
	if ("coach" == type) {
		$("#coachName").html("");
		$("#coach").val();
	}
	if ("mem" == type) {
		$("#memName").html("");
		$("#mem_id").val();
	}
}

function select_pt(){
	var op = $("#pt").val();
	var ops = $("#pt option");
	for(var i=0;i<ops.length;i++){
		var o = ops[i];
		if(op == $(o).val()){
			$("#f_mem___pt_names").val($(o).text());
		}
	}
}
$.fn.serializeObject = function() {
    var json = {};
    var arrObj = this.serializeArray();
    $.each(arrObj, function() {
      if (json[this.name]) {
           if (!json[this.name].push) {
            json[this.name] = [ json[this.name] ];
           }
           json[this.name].push(this.value || '');
      } else {
           json[this.name] = this.value || '';
      }
    });
    return json;
};
function addVisitor(){
	  var name = document.getElementById('visitor_name');
      var phone = document.getElementById('visitor_phoneNum');
      var idNum = document.getElementById('visitor_idNum');
      var mc = document.getElementById('sales');
      var pt = document.getElementById('coach');
      var mem_id = document.getElementById('mem_id');
      var remark = document.getElementById('remark');
      var mem_sex = document.getElementById('f_mem__sex');
      var f_mem__birthday = document.getElementById('f_mem__birthday');
      mem_sex = $(mem_sex).val();
      name = $(name).val();
      phone = $(phone).val();
      f_mem__birthday = $(f_mem__birthday).val();
      idNum = $(idNum).val();
      mem_id = $(mem_id).val();
      
     // var sales_name = $(mc).find("option:selected").text();
      mc = $(mc).val();
      pt = $(pt).val();
      remark = $(remark).val();
      
  	  var phoneRegex = /^1[3|4|5|7|8]\d{9}$/;
      if (name == undefined || name.length == 0) {
          error("姓名不能为空");
          return false;
      }
      if (mem_id == undefined || mem_id.length == 0) {
          error("推荐人不能为空");
          return false;
      }
      if (f_mem__birthday == undefined || f_mem__birthday.length == 0) {
          error("生日不能为空");
          return false;
      }
      if (phone == undefined || phone.length == 0) {
    	  error("电话号码不能为空");
          return false;	
      } else if(!phoneRegex.test(phone)) {
    	  error("请检查电话号码是否正确!");
  		return false;
      }
      
      var data = $("#form1").serializeObject();
      $.ajax({
    		type : 'POST',
			url : "mem-add-traveler?mem_sex="+mem_sex,
			dataType : 'json',
			data : data,
			success : function(data) {
				if(data.rs == "Y"){
					 dialog({
							content:"添加成功",
							button: [
								{
									value: '确定',
									callback: function () {
									location.reload();
									}
								}
							]
					 }).show();
				}else{
					error(data.rs);
				}
			}
      });
      
   
}

</script>
</html>