var isSequenceComplete = true;


$(document).ready(function(){
	showTips();
});

function showTips(){
	if(isSequenceComplete === false) return true;
	isSequenceComplete = false;
	
	if (typeof (tips) == "undefined") {
		tips=[];
	}
	var showAfter=500;
	// {querystr:'',text:'',angle:'',distance:'',showAfter:'',hideAfter:''}
	for(var i=0;i<tips.length;i++){
		var t=tips[i];
			var angle=60;
			var distance=50;
			
			var hideAfter=3500;
			if(t.angle&&t.angle.length>0){
				angle=t.angle;
			}
			if(t.angle&&t.angle.length>0){
				angle=t.angle;
			}
			if(t.distance&&t.distance.length>0){
				distance=t.distance;
			}
			
			if(i==tips.length-1){
				$(''+t.querystr).grumble({
							text: t.text,
							angle: angle,
							distance: distance,
							showAfter: showAfter,
							hideAfter: hideAfter,
							onHide: function(){
								isSequenceComplete = true;
							}
						});
			}else{
				$(''+t.querystr).grumble({
							text: t.text,
							angle: t.angle,
							distance: distance,
							showAfter: showAfter,
							hideAfter: hideAfter
						});
			}
		
		showAfter+=hideAfter;
	}
}

