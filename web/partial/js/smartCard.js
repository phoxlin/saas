
var clearCardno;
var cardNoTemp;

function clearCardNoTemp(){
	cardNoTemp = null;
}

function readCard(){
	try {
		var path = require("path");  
		var execPath = path.dirname(process.execPath);//nw.exe运行地址    
		var cwdPath = process.cwd();  
		cwdPath = cwdPath.replace("/","\\");
		const exec = require('child_process').exec;//产生exec，同时传入.bat文件
		exec(execPath + '\\smart_card_model\\M1RwCMD.exe read 00 ffffffffffff', (err, stdout, stderr) => {
		  if (stderr) {
		  console.log(err.message);
		  }
			if(stdout){
				var obj = JSON.parse(stdout);
				if(obj.RS=='Y'){
						var data = obj.Block01;//卡号
						var cardNo = "";
						if(data.length>0){
							for(var i = 0;i<data.length;i+=2){
								var x = data.substring(i,i+2);
								var assii = parseInt(x,16)
								cardNo += String.fromCharCode(assii);
							}
						}
						cardNo = cardNo.replace(/(^\s*)|(\s*$)/g, "");
						//alert(cardNo);
						if(cardNoTemp == cardNo){
							//与上次卡号一样 不管他
						}else{
							/*if(clearCardno){
								clearTimeout(clearCardno);
							}
							clearCardno = setTimeout("clearCardNoTemp();",5000);*/
							cardNoTemp = cardNo;
						}
						readcallBack(cardNo);
				}else{
					//alert('读卡失败');
					console.log(obj.ErrMsg);
				}
			}
			if($("#mem_info").is(":focus")){
				readCard();
			}
		  console.log(stdout);
		});
	} catch (e) {
		console.log(e);
		//alert('读卡失败');
	}
}

function writeCard(cardNo){
	//Read  00 FFFFFFFFFFFFFFFF 读0扇区
    //Write 01 FFFFFFFFFFFFFFFF 00112233445566778899AABBCCDDEEFF 
    //Write 01 FFFFFFFFFFFFFFFF 00112233445566778899AABBCCDDEEFF 00112233445566778899AABBCCDDEEFF
    //Write 01 FFFFFFFFFFFFFFFF 00112233445566778899AABBCCDDEEFF 00112233445566778899AABBCCDDEEFF00112233445566778899AABBCCDDEEFF
try {
	var path = require("path");  
	var execPath = path.dirname(process.execPath);//nw.exe运行地址    
	var cwdPath = process.cwd();  
	cwdPath = cwdPath.replace("/","\\");
	const exec = require('child_process').exec;//产生exec，同时传入.bat文件
	var Block01 = "";
	if(cardNo==""){
		//alert("不能输入空卡号");
		return;
	}
	for(var i = 0;i<cardNo.length;i++){
		var code = cardNo.charAt(i);
		var assii = code.charCodeAt();
		var assii_16 = assii.toString(16);
		if(assii_16.length == 1){
			assii_16 = "0"+""+assii_16;
		}
		Block01 += assii_16;
	}
	if(Block01.length < 32){
		for(var i = Block01.length;i<32;i+=2){
			Block01 = "20".toString(16) + Block01;
		}
	}else if(Block01.length>32){
		alert("最多不能超过16位长度");
		return;
	}
	
	var str =Block01;
	
	exec(execPath + '\\smart_card_model\\M1RwCMD.exe Write 01 FFFFFFFFFFFF '+str, (err, stdout, stderr) => {
	  if (stderr) {
	  console.log(err.message);
	  }
		if(stdout){
			var obj = JSON.parse(stdout);
			if(obj.RS=='Y'){
					var data = obj.Block01;//卡号
					successMsg("写卡成功");
			}else{
				errorMsg("写卡失败");
				console.log(obj.ErrMsg);
			}
		}	
	  console.log(stdout);
	});
} catch (e) {
	console.log(e);
	errorMsg("请使用客户端写卡");
	//alert('请使用也跑浏览器');
}
}


function successMsg(msg){
	Messenger().post(msg);
};
function errorMsg(msg){
	Messenger().post({
		  message: msg,
		  type: 'error',
		  showCloseButton: true
		});
};


function writeCard2(cardNo){
	//Read  00 FFFFFFFFFFFFFFFF 读0扇区
    //Write 01 FFFFFFFFFFFFFFFF 00112233445566778899AABBCCDDEEFF 
    //Write 01 FFFFFFFFFFFFFFFF 00112233445566778899AABBCCDDEEFF 00112233445566778899AABBCCDDEEFF
    //Write 01 FFFFFFFFFFFFFFFF 00112233445566778899AABBCCDDEEFF 00112233445566778899AABBCCDDEEFF00112233445566778899AABBCCDDEEFF
	var result = "N";
try {
	var path = require("path");  
	var execPath = path.dirname(process.execPath);//nw.exe运行地址    
	var cwdPath = process.cwd();  
	cwdPath = cwdPath.replace("/","\\");
	const exec = require('child_process').exec;//产生exec，同时传入.bat文件
	var Block01 = "";
	if(cardNo==""){
		//alert("不能输入空卡号");
		return;
	}
	for(var i = 0;i<cardNo.length;i++){
		var code = cardNo.charAt(i);
		var assii = code.charCodeAt();
		var assii_16 = assii.toString(16);
		if(assii_16.length == 1){
			assii_16 = "0"+""+assii_16;
		}
		Block01 += assii_16;
	}
	if(Block01.length < 32){
		for(var i = Block01.length;i<32;i+=2){
			Block01 = "20".toString(16) + Block01;
		}
	}else if(Block01.length>32){
		alert("最多不能超过16位长度");
		return;
	}
	
	var str =Block01;
	
	exec(execPath + '\\smart_card_model\\M1RwCMD.exe Write 01 FFFFFFFFFFFF '+str, (err, stdout, stderr) => {
	  if (stderr) {
	  console.log(err.message);
	  }
		if(stdout){
			var obj = JSON.parse(stdout);
			result = obj.RS;
			if(obj.RS=='Y'){
				var data = obj.Block01;//卡号
				successMsg("卡号:"+cardNo+"写卡成功");
			}else{
				errorMsg("卡号:"+cardNo+"写卡失败,请重新查询会员后补卡");
			}
		}	
	  console.log(stdout);
	});
	return result;
} catch (e) {
	console.log(e);
	errorMsg("请使用客户端写卡");
	//alert('请使用也跑浏览器');
}
}
