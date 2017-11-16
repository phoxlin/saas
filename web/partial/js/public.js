function callback_info(msg, fun) {
	dialog(msg, function() {
		eval(fun());
	});
}
