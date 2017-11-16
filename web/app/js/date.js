Date.prototype.Format = function(fmt)   
{ // author: meizz
  var o = {   
    "M+" : this.getMonth()+1,                 // 月份
    "d+" : this.getDate(),                    // 日
    "h+" : this.getHours(),                   // 小时
    "m+" : this.getMinutes(),                 // 分
    "s+" : this.getSeconds(),                 // 秒
    "q+" : Math.floor((this.getMonth()+3)/3), // 季度
    "S"  : this.getMilliseconds()             // 毫秒
  };   
  if(/(y+)/.test(fmt)) {
	  fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));   
  } 
  for(var k in o) {
	  if(new RegExp("("+ k +")").test(fmt)) {
		  fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));   
	  }  
  }
  return fmt;   
} 

Date.prototype.weekDate = function(){
	var str = "";
	
	//昨天的时间
	var day1 = new Date();
	day1.setTime(day1.getTime()-24*60*60*1000);
	var s1 = day1.getFullYear()+"-" + (day1.getMonth()+1) + "-" + day1.getDate();
	var x = this.Format("yyyy-M-dd");
	if(s1 == x){
		str = "昨天";
	}
	//今天的时间
	var day2 = new Date();
	day2.setTime(day2.getTime());
	var s2 = day2.getFullYear()+"-" + (day2.getMonth()+1) + "-" + day2.getDate();
	if(s2 == x){
		str = "今天";
	}
	//明天的时间
	var day3 = new Date();
	day3.setTime(day3.getTime()+24*60*60*1000);
	var s3 = day3.getFullYear()+"-" + (day3.getMonth()+1) + "-" + day3.getDate();
	if(s3 == x){
		str = "明天";
	}
	//后天的时间
	var day4 = new Date();
	day4.setTime(day4.getTime()+2*24*60*60*1000);
	var s4 = day4.getFullYear()+"-" + (day4.getMonth()+1) + "-" + day4.getDate();
	if(s4 == x){
		str = "后天";
	}
	if(str == null || str.length <= 0){
		if(this.getDay()==0){ str="周日"}
		if(this.getDay()==1){ str="周一"}
		if(this.getDay()==2){ str="周二"}
		if(this.getDay()==3){ str="周三"}
		if(this.getDay()==4){ str="周四"}
		if(this.getDay()==5){ str="周五"}
		if(this.getDay()==6){ str="周六"}
	}
	return str;
	
}