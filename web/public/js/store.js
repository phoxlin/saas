/**
 * 本地存储工具类，提供本地数据的存储、获取、删除和清理本地存储等功能
 */
window.store = {
	get : function(key) {// 根据指定的key获取本地存储中的字符串内容
		return window.localStorage.getItem(key);
	},
	getJson : function(key) {// 根据指定的key从本地获取对应的JS对象
		var content = this.get(key);
		if (content) {// 将字符串内容转换为JS对象
			if (content == 'no') {
				return content;
			} else {
				return JSON.parse(content);
			}
		} else {
			return null;
		}
	},
	set : function(key, value) {// 将指定的内容保存到本地存储中
		if (typeof value === "object") {// 将JS对象转换为JSON字符串
			window.localStorage.setItem(key, JSON.stringify(value));
		} else {
			window.localStorage.setItem(key, value);
		}
		return this;
	},
	del : function(key) {// 删除本地存储中的内容
		window.localStorage.removeItem(key);
		return this;
	},
	clear : function() {// 清理本地存储中的所有内容
		return window.localStorage.clear();
	}
};