+ function($) {
    "use strict";

    $.fn.tooltips = function(params, callback){
    	var t = this;
    	var m = $(this).offset().left;
    	var d = document,x = $(t).offset().left+$(t).width()/3,y = $(t).offset().top+$(t).height();
    	var c,v;
    	if(params && params.content){
    		c = params.content;
    	}
    	var value = $(t).text();
    	if(value && value.length > 0){
    		v = value;
    	}
    	var f=d.createElement("div");
    	f.setAttribute("class","tooltips-layer");
    	f.setAttribute("style","top: " + (y) +"px");

    	t.close = function(){
    		$(".tooltips-layer").remove();
    	}
    	t.close();
    	
    	if("object" == typeof c){
    		var xx = m-10;
    		if(xx < 0){
    			xx = m;
    		}
    		var w = $(window).width();
    		var html = "<div class='arrow-up' style='left: "+ x +"px'></div>";
    		if(w - x < 50){
    			html += "<ul class='font-70 color-333' style='right: 10px;'>";
    		} else {
    			html += "<ul class='font-70 color-333' style='left: "+xx+"px;'>";
    		}
    		for(var i=0; i<c.length; i++){
    			var item = c[i];
    			if(v && v.length > 0 && v== item){
    				html += "<li class='active'>"+item+"</li>";
    			} else {
    				html += "<li>"+item+"</li>";
    			}
    		}
    		html += "</ul>";
    		f.innerHTML = html;
    		document.body.appendChild(f);
    	}
    	
    	$(f).find("li").on("click",function(){
    		var v = $(this).text();
    		t.close();
    		$(t).text(v);
    		
    		if(callback && "function" == typeof callback){
    			callback();
    		}
    	});
    	
    	$(document).bind("click", function(e){
    		if(!$(e.target).hasClass("tooltips-link")){
    			t.close();
    		}
    	});
    };
    $.fn.tooltips2 = function(params, callback){
    	var t = this;
    	var m = $(this).offset().left;
    	var d = document,x = $(t).offset().left+$(t).width()/3,y = $(t).offset().top+$(t).height();
    	var c,v;
    	if(params && params.content){
    		c = params.content;
    	}
    	var value = $(t).text();
    	if(value && value.length > 0){
    		v = value;
    	}
    	var f=d.createElement("div");
    	f.setAttribute("class","tooltips-layer");
    	f.setAttribute("style","top: " + (y) +"px");
    	
    	t.close = function(){
    		$(".tooltips-layer").remove();
    	}
    	t.close();
    	
    	if("object" == typeof c){
    		var xx = m-10;
    		if(xx < 0){
    			xx = m;
    		}
    		var w = $(window).width();
    		var html = "<div class='arrow-up' style='left: "+ x +"px'></div>";
    		if(w - x < 50){
    			html += "<ul class='font-70 color-333' style='right: 5px;'>";
    		} else {
    			html += "<ul class='font-70 color-333' style='left: "+xx+"px;'>";
    		}
    		for(var i=0; i<c.length; i++){
    			var item = c[i];
    			if(v && v.length > 0 && v== item){
    				html += "<li class='active' onclick='"+item.click+"'>"+item.text+"</li>";
    			} else {
    				html += "<li onclick='"+item.click+"'>"+item.text+"</li>";
    			}
    		}
    		html += "</ul>";
    		f.innerHTML = html;
    		document.body.appendChild(f);
    	}
    	
    	$(document).bind("click", function(e){
    		if(!$(e.target).hasClass("tooltips-link")){
    			t.close();
    		}
    	});
    };
}(Zepto);

