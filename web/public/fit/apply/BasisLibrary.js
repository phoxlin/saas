
//基础函数
//临时中转函数
function obj(o){        //将要传递进入的对象
    function F(){}      //临时新建的对象用来存储传递过来的对象
    F.prototype = o;    //将o对象实例赋值给F构造的原型对象
    return new F();     //返回这个得到传递过来对象的对象实例
}

//寄生函数 父类 要继承的子类
function create(parent,subclass){
    var f = obj(parent.prototype);
    f.constructor = subclass;   //调整原型构造指针
    subclass.prototype = f;
}

function BasisLibrary(data){
    this.ua = window.navigator.userAgent.toLowerCase();
    this.data = data;
    this._events = {};
    //是否在app中打开
    if(typeof this.isApp != 'function'){
        BasisLibrary.prototype.isApp = function(){
            var isApp = null;
            var ua = this.ua;
            var user = this.data.comparePrice;
            var users = eval("/"+ user +"/i");
            if(ua.match(users) == user) {//判断是否在app中打开
                isApp = true;
            }else{
                isApp = false;
            }
            return isApp;
        }
    };
    //是否在移动端打开
    if(typeof this.isMobile != 'function'){
        BasisLibrary.prototype.isMobile = function(){
            var isMobile = null;
            var ua = navigator.userAgent;
            if(!!ua.match(/AppleWebKit.*Mobile.*/)){
                isMobile = true;
            }else{
                isMobile = false;
            }
            return isMobile;
        }
    };
    //是否在微信中打开
    if(typeof this.isWeixin != 'function'){
        BasisLibrary.prototype.isWeixin = function(){
            var ua = this.ua;
            if(ua.match(/MicroMessenger/i) == "micromessenger") {
                return true;
            } else {
                return false;
            }
        }
    };
    //浏览器类型
    if(typeof this.webType != 'function'){
        BasisLibrary.prototype.webType = function(){
            var webType = null;
            var ua = navigator.userAgent;

            //是否是安卓
            if(ua.indexOf('Android') > -1 || ua.indexOf('Linux') > -1){
                webType = 'android';
            }else if(!!ua.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/)){ //是否是ios
                if(ua.indexOf('iPad') > -1){
                    webType = 'iPad';
                }else{
                    webType = 'ios';
                }
            }else{
                webType = 'pc';
            }
            return webType;
        }
    };
    
    //生成下载链接
    if(typeof this.download != 'function'){

        BasisLibrary.prototype.download = function(doms){
            var doms = $(doms);
            if(this.webType() == 'ios' || this.webType() == 'iPad'){
                if(this.isWeixin()){
                    doms.prop('href',this.data.downloadUrl.iosWeChat);
                }else{
                    doms.prop('href',this.data.downloadUrl.ios);
                }
            }else if(this.webType() == 'android'){
                if(this.isWeixin()){
                    doms.prop('href',this.data.downloadUrl.androidWeChat);
                }else{
                    doms.prop('href',this.data.downloadUrl.android);
                }
            }else{
                doms.prop('href',this.data.downloadUrl.android);
            }
        }
    };
    //图片加载完成后执行
    if(typeof this.imgLoading != 'function'){
        BasisLibrary.prototype.imgLoading = function(imgs,fun){
            var _function = fun;
            var t_img; // 定时器
            var isLoad = true; // 控制变量
            // 判断图片加载状况，加载完成后回调
            isImgLoad(function(){
                // 图片加载完成
                if(_function != undefined){
                    _function();
                }
            });
            // 判断图片加载的函数
            function isImgLoad(callback){
                // 注意我的图片类名都是cover，因为我只需要处理cover。其它图片可以不管。
                // 查找所有封面图，迭代处理
                $(imgs).each(function(){
                    // 找到为0就将isLoad设为false，并退出each
                    if(this.height === 0){
                        isLoad = false;
                        return false;
                    }
                });
                // 为true，没有发现为0的。加载完毕
                if(isLoad){
                    clearTimeout(t_img); // 清除定时器
                    // 回调函数
                    callback();
                    // 为false，因为找到了没有加载完成的图，将调用定时器递归
                }else{
                    isLoad = true;
                    t_img = setTimeout(function(){
                        isImgLoad(callback); // 递归扫描
                    },100); // 我这里设置的是500毫秒就扫描一次，可以自己调整
                };
            };
        }
    };
    //解决输入法挡住textarea
    if(typeof this.textareaOr != 'function'){
        BasisLibrary.prototype.textareaOr = function(){
            $('.textareaText').each(function(){
                var offsetTop = $(this).offset().top;
                $(this).focus(function(){
                    $("html,body").animate({
                        scrollTop:$(this).offset().top
                    },500);
                }).blur(function(){
                    $("html,body").animate({
                        scrollTop:offsetTop
                    },500);
                });
            });
        }
    }
    //时间转换
    if(typeof this.format != 'function'){
        BasisLibrary.prototype.format = function(format) {
            var date = {
                "M+": this.getMonth() + 1,
                "d+": this.getDate(),
                "h+": this.getHours(),
                "m+": this.getMinutes(),
                "s+": this.getSeconds(),
                "q+": Math.floor((this.getMonth() + 3) / 3),
                "S+": this.getMilliseconds()
            };
            if (/(y+)/i.test(format)) {
                format = format.replace(RegExp.$1, (this.getFullYear() + '').substr(4 - RegExp.$1.length));
            }
            for (var k in date) {
                if (new RegExp("(" + k + ")").test(format)) {
                    format = format.replace(RegExp.$1, RegExp.$1.length == 1
                        ? date[k] : ("00" + date[k]).substr(("" + date[k]).length));
                }
            }
            return format;
        }
    }
    //秒转小时分的方法
    if(typeof this.formatSeconds != 'function'){
        BasisLibrary.prototype.formatSeconds = function(value){
            var theTime = parseInt(value);// 秒
            var theTime1 = 0;// 分
            var theTime2 = 0;// 小时
            if(theTime > 60) {
                theTime1 = parseInt(theTime/60);
                theTime = parseInt(theTime%60);
                if(theTime1 > 60) {
                    theTime2 = parseInt(theTime1/60);
                    theTime1 = parseInt(theTime1%60);
                }
            }
            var result = parseInt(theTime2)+"小时"+parseInt(theTime1)+"分"+parseInt(theTime)+"秒";
            /*if(theTime1 > 0) {
                result = ""+parseInt(theTime1)+"分"+result;
            }
            if(theTime2 > 0) {
                result = ""+parseInt(theTime2)+"小时"+result;
            }*/
            return result;
        }
    }
    //弹出框居中
    if(typeof this.centerLine != 'function'){
        BasisLibrary.prototype.centerLine = function(){
            var winWidth = $(window).outerWidth();
            var winHeight = $(window).outerHeight();
            var cenWidth = $('.center-line').outerWidth();
            var cenHeight = $('.center-line').outerHeight();
            this.imgLoading('img',function(){
                $('.center-line').css({'marginTop':-(cenHeight)/2+'px','marginLeft':-(cenWidth)/2+'px'});
            });
            $(window).resize(function(){
                $('.center-line').css({'marginTop':-(cenHeight)/2+'px','marginLeft':-(cenWidth)/2+'px'});
            });

        };
    }
    //初始化时间对象
    if(typeof this.Timedata != 'function'){
        BasisLibrary.prototype.Timedata = function(){
            var myDate = new Date();
            return myDate;
        };
    }
    //移动端touch事件
    if(typeof  this.bindtouch != 'function'){
        BasisLibrary.prototype.bindtouch = function(src, cb){
            $(src).unbind();
            var isTouchDevice = 'ontouchstart' in window || navigator.msMaxTouchPoints;
            if (isTouchDevice) {
                $(src).on("touchstart", function(event) {
                    $(this).data("touchon", true);
                    $(this).addClass("pressed");
                });
                $(src).on("touchend", function() {
                    $(this).removeClass("pressed");
                    if ($(this).data("touchon")) {
                        //cb.bind(this)();
                        cb();
                    }
                    $(this).data("touchon", false);
                });
                $(src).on("touchmove", function() {
                    $(this).data("touchon", false);
                    $(this).removeClass("pressed");
                });
            } else {
                $(src).on("mousedown", function() {
                    $(this).addClass("pressed");
                    $(this).data("touchon", true);
                });
                $(src).on("mouseup", function() {
                    $(this).removeClass("pressed");
                    $(this).data("touchon", false);
                    //cb.bind(this)();
                    cb();
                });
            }
        };
    }
    //注册事件监听
    if(typeof  this.on != 'function'){
        BasisLibrary.prototype.on = function(eventName,callback){
            if(this._events[eventName]){ //已经订阅过了
                this._events[eventName].push(callback);
            }else{
                this._events[eventName] = [callback];
            }
        };
    }
    //发射事件
    if(typeof  this.emit != 'function'){
        BasisLibrary.prototype.emit = function(eventName){
            var args = Array.prototype.slice.call(arguments,1);
            var callbacks = this._events[eventName];
            var self = this;
            callbacks.forEach(function(callback){
                callback.apply(self,args);
            });
        };
    }
}

//扩展Data方法 format('yyyy-MM-dd h:m:s')
Date.prototype.format = function(format) {
    var date = {
        "M+": this.getMonth() + 1,
        "d+": this.getDate(),
        "h+": this.getHours(),
        "m+": this.getMinutes(),
        "s+": this.getSeconds(),
        "q+": Math.floor((this.getMonth() + 3) / 3),
        "S+": this.getMilliseconds()
    };
    if (/(y+)/i.test(format)) {
        format = format.replace(RegExp.$1, (this.getFullYear() + '').substr(4 - RegExp.$1.length));
    }
    for (var k in date) {
        if (new RegExp("(" + k + ")").test(format)) {
            format = format.replace(RegExp.$1, RegExp.$1.length == 1
                ? date[k] : ("00" + date[k]).substr(("" + date[k]).length));
        }
    }
    return format;
}
//扩展Number方法将秒转换成分秒
Number.prototype.formatTime=function(){
    // 计算
    var h=0,i=0,s=parseInt(this);
    if(s>59){
        i=parseInt(s/59);
        s=parseInt(s%59);
        if(i > 59) {
            h=parseInt(i/59);
            i = parseInt(i%59);
        }
    }
    // 补零
    var zero=function(v){
        return (v>>0)<10?"0"+v:v;
    };
    return [/*zero(h),*/zero(i),zero(s)].join(":");
};

Number.prototype.formatTime2 = function() {
    var theTime = parseInt(this);// 秒
    var theTime1 = 0;// 分
    var theTime2 = 0;// 小时
    if(theTime > 60) {
        theTime1 = parseInt(theTime/60);
        theTime = parseInt(theTime%60);
        if(theTime1 > 60) {
            theTime2 = parseInt(theTime1/60);
            theTime1 = parseInt(theTime1%60);
        }
    }
    var result = ""+parseInt(theTime)+"秒";
    if(theTime1 > 0) {
        result = ""+parseInt(theTime1)+"分"+result;
    }
    if(theTime2 > 0) {
        result = ""+parseInt(theTime2)+"小时"+result;
    }
    return result;
}

//扩展String方法添加去掉字符串前后空格功能
String.prototype.trim=function() {
    return this.replace(/(^\s*)|(\s*$)/g,'');
}

//jquery绑定touch代替click事件

$.fn.bindtouch = function(cb) {
    function attachEvent(src, cb) {
        $(src).unbind();
        var isTouchDevice = 'ontouchstart' in window || navigator.msMaxTouchPoints;
        if (isTouchDevice) {
            $(src).on("touchstart", function(event) {
                $(this).data("touchon", true);
                $(this).addClass("pressed");
            });
            $(src).on("touchend", function() {
                $(this).removeClass("pressed");
                if ($(this).data("touchon")) {
                    //cb.bind(this)();
                    cb();
                }
                $(this).data("touchon", false);
            });
            $(src).on("touchmove", function() {
                $(this).data("touchon", false);
                $(this).removeClass("pressed");
            });
        } else {
            $(src).on("mousedown", function() {
                $(this).addClass("pressed");
                $(this).data("touchon", true);
            });
            $(src).on("mouseup", function() {
                $(this).removeClass("pressed");
                $(this).data("touchon", false);
                //cb.bind(this)();
                cb();
            });
        };
    }
    attachEvent($(this), cb);
};

function setCookie(c_name, value, expiredays){
    var exdate=new Date();
    exdate.setDate(exdate.getDate() + expiredays);
    document.cookie=c_name+ "=" + escape(value) + ((expiredays==null) ? "" : ";expires="+exdate.toGMTString());

}

function getCookie(name){
    /* 获取浏览器所有cookie将其拆分成数组 */
    var arr=document.cookie.split('; ');

    for(var i=0;i<arr.length;i++)    {
        /* 将cookie名称和值拆分进行判断 */
        var arr2=arr[i].split('=');
        if(arr2[0]==name){
            return arr2[1];
        }
    }
    return '';
}

function removeCookie(name){
    /* -1 天后过期即删除 */
    setCookie(name, 1, -1);
}