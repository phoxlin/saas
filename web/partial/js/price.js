String.prototype.trim = function(x) {
	return this.replace(/^\s+|\s+$/gm, '');
}

function toChinesePrice(price) { // 如输入123.45可得到 壹百贰拾叁元肆角伍分
	var AA = new Array("零", "壹", "贰", "叁", "肆", "伍", "陆", "柒", "捌", "玖");
	var BB = new Array("", "拾", "百", "千", "万", "亿", "", "");
	var CC = new Array("角", "分", "");
	var num=Math.abs(price);
	var a = ("" + num).replace(/(^0*)/g, "").split("."), k = 0, re = "";

	for (var i = a[0].length - 1; i >= 0; i--) {
		switch (k) {
		case 0:
			re = BB[7] + re;
			break;
		case 4:
			if (!new RegExp("0{4}//d{" + (a[0].length - i - 1) + "}$")
					.test(a[0]))
				re = BB[4] + re;
			break;
		case 8:
			re = BB[5] + re;
			BB[7] = BB[5];
			k = 0;
			break;
		}
		if (k % 4 == 2 && a[0].charAt(i + 2) != 0 && a[0].charAt(i + 1) == 0)
			re = AA[0] + re;
		if (a[0].charAt(i) != 0)
			re = AA[a[0].charAt(i)] + BB[k % 4] + re;
		k++;
	}
	if (re.trim().length > 0) {
		re += "元";
	}

	if (a.length > 1) { // 加上小数部分(如果有小数部分)
		re += BB[6];
		for (var i = 0; i < CC.length; i++) {
			re += AA[a[1].charAt(i)] + CC[i];
		}
	}
	if(price<0){
		re="负"+re;
	}
	
	return re;
}
// 格式化输入数字，并保留指定位小数
// amount为原数字，_pow_为需要保留小数位数
function toPrice(amount, _pow_) {
	if (isNaN(amount)) {
		alert(amount + '必须为数字');
		return;
	}
	if (isNaN(_pow_)) {
		_pow_=2;
	}
	return amount.toFixed(_pow_)
}

function toPriceFromLong(longPrice){
	var yuan = Math.round(longPrice);
	yuan=Math.abs(yuan);
    yuan = yuan.toString()
    console.log(yuan);
    var before = yuan.substr(0, yuan.length - 2);
    if(before.length<=0){
    	before="0";
    }
    console.log(before);
    var end = yuan.substr(yuan.length - 2, 2);
    yuan = before + "." + end;
    var re = /(-?\d+)(\d{3})/;
    while (re.test(yuan)) {
        yuan = yuan.replace(re, "$1,$2")
    }
    if(longPrice<0){
    	yuan="-"+yuan;
    }
    return yuan;
}

function toLongPrice(amount) {
	var amount_bak = amount;
	var base = 10;
	if (isNaN(amount)) {
		alert(amount + '必须为数字');
		return;
	}
	var temp=amount*100;
	return parseInt(temp);
}