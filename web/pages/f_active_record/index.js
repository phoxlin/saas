function f_active_record___f_active_recordHook(){
	var tr = $("tr");
	tr.each(function(){
		$(this).removeAttr("onDblClick");
	});
}