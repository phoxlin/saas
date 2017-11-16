//打开popup统一调用方法
var popups = new Array();
var lastestTime=new Date().getTime();
function openPopup(tag) {
	var now=new Date().getTime();
	if(now-lastestTime<1200){
		return;
	}
	if (tag) {
		popups.push(tag);
		lastestTime=now;
		$.popup(tag);
	}
}

Array.prototype.remove = function(val) {
    var index = this.indexOf(val);
    if (index > -1) {
        this.splice(index, 1);
    }
};

function closePopup(name2) {
	if (undefined == name2) {
		var name = popups.pop();
		if (undefined != name) {
			$.closeModal(name);
		}
	} else {
		popups.remove(name2);
		$.closeModal(name2);
	}
	//需要关闭图片浏览器
	$('.slide').remove();
    $('.slide_box').hide();
}

function formatPhone(phone){
	if(phone && phone.length > 3){
		phone = "*" + phone.substring(phone.length - 3, phone.length);
	}
	return phone;
}