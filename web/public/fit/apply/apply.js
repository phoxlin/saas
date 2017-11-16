//申请试用
function Apply(data){
    BasisLibrary.call(this,data);    //对象冒充继承

    this.listIndex = {
        provincial : 0,
        citys : 0,
        county : 0
    }

}

//通过寄生组合继承 来实现继承
create(BasisLibrary,Apply);


//生成省列表
Apply.prototype.provincial = function(){
    var self = this;

    var provincial = "";
    for(var i = 0; provincesdata[i]; i++){
        provincial += "<li class=\"down-box-li\"><a href=\"javascript:void (0);\">"+provincesdata[i].name+"</a></li>";
    }

    //生成省列表
    $(".provincial").find(".down-box-ul").html("");
    $(".provincial").find(".down-box-ul").html(provincial);

    //点击选择省
    $(".provincial").find(".down-box-ul").find("li").each(function(itm){
        $(this).off("click").on("click",function(){
            $(".provincial").find(".bm-nr-webkit").find(".cd-nr").text(provincesdata[itm].name);
            self.listIndex.provincial = itm;
            $(".provincial").find(".bm-nr-webkit").find(".cd-nr").css("color","#2c2c2c");
            $(this).parents(".div-style").find(".drop-down-box").css('display','none');
            //生成市列表
            self.citys();
        });
    });
};

//生成市列表
Apply.prototype.citys = function(itm){
    var self = this;

    var provincialIndex = self.listIndex.provincial;

    var data = provincesdata[provincialIndex].city;

    var citys = "";
    for(var i = 0; data[i]; i++){
        citys += "<li class=\"down-box-li\"><a href=\"javascript:void (0);\">"+data[i].name+"</a></li>";
    }

    //生成市列表
    $(".city").find(".down-box-ul").html("");
    $(".city").find(".down-box-ul").html(citys);
    $(".city").find(".bm-nr-webkit").find(".cd-nr").text(data[0].name);

    $(".city").find(".bm-nr-webkit").off("click").on("click",function(){
        $(".drop-down-box").css('display','none');
        //展开列表
        $(this).parents(".div-style").find(".drop-down-box").css("display","block");
    });

    //点击选择市
    $(".city").find(".down-box-ul").find("li").each(function(itm){
        $(this).off("click").on("click",function(){
            $(".city").find(".bm-nr-webkit").find(".cd-nr").text(data[itm].name);
            $(".city").find(".bm-nr-webkit").find(".cd-nr").css("color","#2c2c2c");
            self.listIndex.citys = itm;
            $(this).parents(".div-style").find(".drop-down-box").css('display','none');
            self.countyt();
        });
    });
};

//生成县列表
Apply.prototype.countyt = function(){
    var self = this;
    var provincialIndex = self.listIndex.provincial;
    var citys = self.listIndex.citys;

    var data = provincesdata[provincialIndex].city[citys].area;

    var county = "";

    for(var i = 0; data[i]; i++){
        county += "<li class=\"down-box-li\"><a href=\"javascript:void (0);\">"+data[i]+"</a></li>";
    };

    //生成县列表
    $(".county").find(".down-box-ul").html("");
    $(".county").find(".down-box-ul").html(county);
    $(".county").find(".bm-nr-webkit").find(".cd-nr").text(data[0]);

    $(".county").find(".bm-nr-webkit").off("click").on("click",function(){
        $(".drop-down-box").css('display','none');
        //展开列表
        $(this).parents(".div-style").find(".drop-down-box").css("display","block");
    });

    //点击选择县
    $(".county").find(".down-box-ul").find("li").each(function(itm){
        $(this).off("click").on("click",function(){
            $(".county").find(".bm-nr-webkit").find(".cd-nr").text(data[itm]);
            $(".county").find(".bm-nr-webkit").find(".cd-nr").css("color","#2c2c2c");
            self.listIndex.county = itm;
            $(this).parents(".div-style").find(".drop-down-box").css('display','none');
        });
    });

};

//选择俱乐部地址
Apply.prototype.linkage = function(){
    var self = this;
    //生成省列表
    self.provincial();

    $(".provincial").find(".bm-nr-webkit").off("click").on("click",function(){
        $(".drop-down-box").css('display','none');
        //展开列表
        $(this).parents(".div-style").find(".drop-down-box").css("display","block");
    });

};


Apply.prototype.initialization = function(){
    var self = this;

    //选择俱乐部地址
    self.linkage();
    //提交数据
};


jQuery.fn.ApplyFun = function(object,data){
    var self = object;
    var data = data;
    self.initialization();
};