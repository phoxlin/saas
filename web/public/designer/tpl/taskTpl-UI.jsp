<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script type="text/html" id="msOldUploadTpl">
<#
	var defaultVal=data.defaultValue;
	var controlName=name;
	var ext="";
	var count=1; try{ count=data.number; }catch(e){}
#>
		<input type="button" value="上传文件"  <# if("yes"!=isfinish){#>onclick="uploadFiles('<#=controlName#>','<#=ext#>',<#=count#>,false)"<#}#> />
		<input class="easyui-validatebox" style="width:0px;height:0px;border:0px;" readonly="readonly" type="text" name="<#=controlName#>"  id="<#=controlName#>"  data-options="required:<#=!data.nullable#>" value='<#=defaultVal#>'/>
		<span id="desc_<#=controlName#>" style="display: inline;">
		
		<#

			if(defaultVal!=null){
var id ;
var fileName;
if($.type(defaultVal)=="object"){
$.each(defaultVal,function(name,value) {
if(name=="id")
 id=value;
else if(name=="name")
fileName=value;
});
}
if (id!=undefined){
					#>
					<a id='<#=id#>_1' href='public/pub/file_upload/down.jsp?id=<#=id#>'><#=fileName#></a>
					<img id='<#=id#>_2' style='cursor:pointer' src='public/jQuery/easyui/css/images/tabs_close.gif' onclick="deleteFile('<#=id#>','<#=fileName#>')" >
					<#
			
}
}
		#>
		</span>
</script>


<script type="text/html" id="msNiuUploadTpl">
<#
	var defaultVal=data.defaultValue;
	var controlTitle=data.placeholder;
	var controlName=name+"__"+data.name;
	var onelineFlag="N";
	var width=data.width;
	var oneline = data.oneline;
	if(oneline){
		width="98%";
	}
	var ext="*"; try{ext=data.ext; if(ext=='undefined'||ext==undefined){ext="*";}  }catch(e){}
	var count=1;try{count=data.count;if(count=='undefined'||count==undefined){count=1;}}catch(e){}
	
	var pics=['jpg','gif','png'];
	var defaultView="";
	if(defaultVal!=null&&defaultVal.length>0){
		var dvals=defaultVal.split(',');
		if(dvals.length>0){
			
			for(var i=0;i<dvals.length;i++){
				var d=dvals[i];
				if(d.length>0){
				var fileExt=d.fileExt();
				var urls=d.split('_._');
				var fileName=urls[urls.length-1];
				var isPic=false;
				for(var k=0;k<pics.length;k++){
					if(fileExt==pics[k]){
						isPic=true;
						break;
					}
				}
				if(isPic){
					defaultView+="<a href='"+d+"' target='_blank'><img src='"+d+"?imageView2/1/w/50/h/50'></a>";
				}else{
					defaultView+="<a href='"+d+"' target='_blank'>"+fileName+"</a>";
				}
				}
			}
		}
	}
	
#>
	<input id="<#=controlName#>" name="<#=controlName#>" type="hidden" value="<#=defaultVal#>">
	<a href="javascript:uploadFile('<#=controlName#>','<#=ext#>','<#=count#>');" class="btn btn-xs btn-default btn-block" style="width: 100px;margin-left: 33.4%">上传文件</a>
	<div id="_<#=controlName#>" name="_<#=controlName#>"><#:=defaultView#></div>	
</script>
<script type="text/html" id="upload_result_tpl">
		<#
			for(var i=0;i<info.length;i++){
				var file=info[i];
				var url=file.url;
				var filename=file.filename;
				var baseId=field_name+"_"+i;
				var id=field_name+"_"+i+"_1";
				var id2=field_name+"_"+i+"_2";
				#>
				
				<a id='<#=id#>' href='<#=url#>' ><#=filename#></a>
				<img id='<#=id2#>' style='cursor:pointer' src='public/sb_admin2/bower_components/qiniu/images/del.png' onclick="deleteFile('<#=baseId#>','<#=field_name#>')" >
				<#
			}
		#>
</script>
<script type="text/html" id="msEditorTpl">
	<#
		var name = name+"__"+data.name;;
		var defaultVal=data.defaultValue;
		var required = !data.nullable;
	#>
		<textarea id="textarea_<#=name#>" name="textarea_<#=name#>" style=visibility:hidden;"><#=defaultVal#></textarea>
		<input type="<#=required ? "text" : "hidden"#>" style="width:0px;height:0px;" readonly="readonly" name="<#=name#>" id="<#=name#>" class="easyui-validatebox col-xs-6" data-options="required:<#=required#>" />
	<script>
		var <#=name#>_editor;
			<#=name#>_editor = KindEditor.create('textarea[name="textarea_<#=name#>"]', 
			{	uploadJson : 'public/js/kindeditor/upload.jsp',	
				allowImageUpload : true,
				items : ['fontname', 'fontsize', 'forecolor', 'hilitecolor', 'bold', 'underline','removeformat','justifyleft', 'justifycenter', 'justifyright', 'insertorderedlist','insertunorderedlist', 'emoticons', 'image', 'link','table', 'source'],
				afterChange : function() {	
					$('#<#=name#>').val(this.html());
				}
			})
	&lt;/script&gt;
</script>
<script type="text/html" id="msPasswordTpl">
<#
	var defaultVal=data.defaultValue;
	var controlTitle=data.placeholder;
	var controlName=name+"__"+data.name;
	var width="60%";
	var oneline = data.oneline;
	if(oneline){
		width="98%";
	}
	
	if(data.name=='id'){
#>
	<input type="hidden" id="<#=controlName#>" name="<#=controlName#>" value="<#=defaultVal#>">
<#
	}else{
#>
	<input type="password" id="<#=controlName#>" name="<#=controlName#>" 
		style="width:<#=width#>" class="form-control easyui-validatebox input-sm col-xs-6" 
		data-options="required:<#=!data.nullable#>"  placeholder="<#=controlTitle#>" value="<#=defaultVal#>">

<#
	}
#>
</script>
<script type="text/html" id="msTextareaTpl">
<#

	var controlTitle=data.placeholder;
	var controlName=name;
	var defaultVal=val;
	var onelineFlag="N";
	var width=data.width;
	var oneline = data.oneline;
	if(oneline){
		width="98%";
	}

#>
	<textarea type="text" id="<#=controlName#>" name="<#=controlName#>" data-options="required:false,"  data-onlineValue="<#=onelineFlag#>"
		style="width:<#=width#>;height:<#=data.height#>;resize:none;background-color:#DBE5F1" class="easyui-validatebox form-control col-xs-6 input-sm" 
		data-options="required:<#=!data.nullable#>"  placeholder="<#=controlTitle#>"><#=defaultVal#></textarea>
</script>
<!-- //validType:'length[0,300]' -->
<script type="text/html" id="msEasyui-timespinnerTpl">
<#
	var defaultVal=data.defaultValue;
	var controlTitle=data.placeholder;
	var controlName=name+"__"+data.name;
	var onelineFlag="N";
	var width=data.width;
	var oneline = data.oneline;
	if(oneline){
		width="98%";
	}
#>
	<input type="text" id="<#=controlName#>" name="<#=controlName#>" data-onlineValue="<#=onelineFlag#>"
		style="width:<#=width#>;height:<#=data.height#>;" class="form-control easyui-timespinner" 
		data-options="required:<#=!data.nullable#>, showSeconds:false,value:'<#=defaultVal#>'"  placeholder="<#=controlTitle#>">
</script>
<script type="text/html" id="msNumberSpinnerTpl">
<#
	var defaultVal=data.defaultValue;
	var controlTitle=data.placeholder;
	var controlName=name+"__"+data.name;
	var onelineFlag="N";
	var width=data.width;
	var oneline = data.oneline;
	if(oneline){
		width="98%";
	}
	var hasMin=false;
	if(data.min>0){
		hasMin=true;
	}

	var hasPresision=false;
	if(data.precision>0){
		hasPresision=true;
	}
	
	var hasMax=false;
	
	if(data.max>0){
		hasMax=true;
	}
#>
	<input type="text" id="<#=controlName#>" name="<#=controlName#>" data-onlineValue="<#=onelineFlag#>"
		style="width:<#=width#>;height:<#=data.height#>;" class="form-control easyui-numberspinner" 
		data-options="required:<#=!data.nullable#>,<#if(hasMin){#>min:<#=data.min#>,<#}#><#if(hasPresision){#>precision:<#=data.precision#>,<#}#><#if(hasMax){#>max:<#=data.max#><#}#>"  placeholder="<#=controlTitle#>">
</script>

<script type="text/html" id="msEasyui-dateboxTpl">
<#
	var defaultVal=data.defaultValue;
	var controlTitle=data.placeholder;
	var controlName=name+"__"+data.name;
	var oneline = data.oneline;
#>
	<input name="<#=controlName#>" id="<#=controlName#>" type="text" class="easyui-datebox" value="<#=defaultVal#>" data-options="required:<#=!data.nullable#>">
</script>

<script type="text/html" id="msEasyui-datetimeboxTpl">
<#
	var defaultVal=val;
	var controlTitle=data.placeholder;
	var controlName=name;
	var oneline = data.oneline;
	var isOver="";
		if("yes"==isfinish)
				isOver="readonly:true,";
#>
	<input name="<#=controlName#>" id="<#=controlName#>" editable=false  type="text" class="easyui-datetimebox" value="<#=defaultVal#>" data-options="required:<#=!data.nullable#>,<#=isOver#>">
</script>



<script type="text/html" id="processEasyui-comboboxTpl">
<#
	var defaultVal=val;
	var controlTitle=data.placeholder;
	var dataFetchType=data.dataFetchType;
	console.log(data);
	var oneline = data.oneline;
	var isOver="";
		if("yes"==isfinish)
				isOver="readonly:true,";
#>
	<select class="col-xs-<#=fieldColumn#> easyui-combobox input-sm <#=column_clz#>" name="<#=name#>" 
	id="<#=name#>" style="background-image: none;border: 1px solid #ccc;height:30px;  <#=column_style#>" 
	data-options="editable:false,<#=isOver#>validType:'myRequired[<#=data.nullable?0:1#>]'">
		
		<option value="" >请选择</option>
		<#
			for(var i=0;i<data.options.length;i++){
				var db=data.options[i];
				var code=db.code;
				var note=db.note;
				var eq="";
				if(code==defaultVal){
					eq="selected='selected'";
				}
				#>
		<option value="<#=code#>" <#=eq#>><#=note#></option>		
				<#
			}
		#>
	</select>
</script>





<script type="text/html" id="bootstrap_select">
<#	var defaultVal=val;
	var controlTitle=data.placeholder;
	var dataFetchType=data.dataFetchType;
	var oneline = data.oneline;
	var isOver="";
		if("yes"==isfinish)
				isOver="disabled='disabled'";
	var needChange=data.otherset;
	var changed=data.change;
	var click=data.click;
	var changedStr="";
	if(data.change&&data.change.length>0){
		changedStr=data.change+"('"+name+"');";
	}
	var edit_code = defaultVal;
#>

     <div class="col-xs-<#=fieldColumn#> input-group <#=column_clz#>" >
        <select name="bootstrap_select_<#=name#>" onchange="selectComboxValueChanged('<#=name#>');<#=changedStr#>" id="bootstrap_select_<#=name#>" <#=isOver#> class="selectpicker show-tick form-control bs-select-hidden"  style="margin-left:0.5%;">
		<option value="" >请选择</option>
		<#	
			
			for(var i=0;i<data.options.length;i++){
				var db=data.options[i];
				var code=db.code;
				var note=db.note;
				var eq="";
				if(code==defaultVal){
					eq="selected='selected'";
					edit_code = code;
				}
				#>
			<option value="<#=code#>" <#=eq#>><#=note#></option>		
				<#
			}
		#>       
 	</select>
      </div>

		<input type="text" id="<#=name#>" name="<#=name#>" readonly="readonly" value="<#=edit_code#>"  data-options="required:<#=!data.nullable#>" style="width:0px;height:0px;margin-left:-5px;padding-bottom:0px" class="easyui-validatebox validatebox-text"/>
</script>


<script  type="text/html" id="bootstrap_datetime">
<#
var defaultVal=val;
var controlTitle=data.placeholder;
var controlName=name;
var oneline = data.oneline;
var isOver="";
	if("yes"==isfinish)
			isOver="readonly:true,";
#>
 		<div class="">
                <div class="input-group date form_datetime col-xs-<#=fieldColumn#>" data-date-format="yyyy-mm-dd hh:ii" data-link-field="<#=name#>">
                    <input class="form-control"   style="background-color:#EAF1DD" size="16" type="text"  readonly value="<#=defaultVal#>">
					<span class="input-group-addon"><span class="glyphicon glyphicon-th"></span></span>
                </div>
				<input type="hidden" id="<#=name#>"   name="<#=name#>"  value="<#=defaultVal#>" /><br/>
          </div>
</script>
<!-- -

 <div class="form-group">
                <label for="dtp_input1" class="col-md-2 control-label">DateTime Picking</label>
                <div class="input-group date form_datetime col-md-5" data-date="1979-09-16T05:25:07Z" data-date-format="dd MM yyyy - HH:ii p" data-link-field="dtp_input1">
                    <input class="form-control" size="16" type="text" value="" readonly>
                    <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
					<span class="input-group-addon"><span class="glyphicon glyphicon-th"></span></span>
                </div>
				<input type="hidden" id="dtp_input1" value="" /><br/>
          </div>
 -->
<script type="text/html" id="processEasyui-validateboxTpl">

<#
	var defaultVal=val;
	var controlTitle=data.placeholder;
	var dataFetchType=data.dataFetchType;
	var placeholder=data.placeholder;
	var oneline = data.oneline;
	var title =　"";
	if(data.otherset&&data.otherset!=""){
		var json = $.parseJSON(data.otherset);
		 title = json['title'];
	}
	var isOver="";
		if("yes"==isfinish){
				isOver="readOnly ";
		}
#>
	<input type="text" id="<#=name#>" name="<#=name#>" <#  if(title&&title!=""){ #> data-toggle="tooltip"  title="<#=title#>" data-placement="top" <#}#><#=isOver#> 
		style="background-image: none;border: 1px solid #ccc; <#=column_style#>" class="col-xs-<#=fieldColumn#> easyui-validatebox input-sm <#=column_clz#>" 
		data-options="required:<#=!data.nullable#>,validType:'length[0,<#=data.length#>]'"  placeholder="<#=placeholder#>" value="<#=defaultVal#>">
</script>

<script type="text/html" id="msEasyui-numberboxTpl">
<#
	var defaultVal=val;
	var controlTitle=data.placeholder;
	var controlName=name+"__"+data.name;
	var width="60%";
	var oneline = data.oneline;
	if(oneline){
		width="98%";
	}
	
	var hasPresision=false;
	if(data.precision>0){
		hasPresision=true;
	}
	
	var hasMax=false;
	
	if(data.max>0){
		hasMax=true;
	}
	
#>
	<input type="text" id="<#=controlName#>" name="<#=controlName#>" 
		style="width:<#=width#>" class="form-control easyui-numberbox input-sm" 
		data-options="required:<#=!data.nullable#>,min:<#=data.min#>,<#if(hasPresision){#>precision:<#=data.precision#>,<#}#><#if(hasMax){#>max:<#=data.max#><#}#>"  placeholder="<#=controlTitle#>" value="<#=defaultVal#>">
</script>