<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-saAddMemRecommend">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-saAddMemRecommend')"></a>
		<h1 class="title">会员推荐</h1>
	</header>
	<div class="content" id = "zhuan_mem">
  <div class="list-block" style="margin-top: 0;">
    <ul>
      <!-- Text inputs -->
      <li>
        <div class="item-content">
          <div class="item-inner">
          <div class="item-media color-warn" style="width: 0.5rem;">*</div>
           <div class="item-title label font-75 color-999" style="width:20%;">姓名</div>
            <div class="item-input">
              <input type="text" class="font-75 color-fff" id="sa_mem_name_recommend" placeholder="姓名">
            </div>
          </div>
        </div>
      </li>
      <li>
        <div class="item-content">
          <div class="item-inner">
          <div class="item-media color-warn" style="width: 0.5rem;">*</div>
            <div class="item-title label font-75 color-999" style="width:20%;">电话号码</div>
            <div class="item-input">
              <input type="text" class="font-75 color-fff" id="sa_phone_recommend" placeholder="电话">
            </div>
          </div>
        </div>
      </li>
      <li>
		<div class="item-content">
			<div class="item-inner">
				<div class="item-media color-warn" style="width: 0.5rem;"></div>
				<div class="item-title label font-75 color-999" style="width: 20%">性别</div>
				<div class="item-input">
					<select id="sa_sex_recommend" class="font-75 color-fff">
						<option value="">请选择</option>
						<option value="male">男</option>
						<option value="female">女</option>
					</select>
				</div>
			</div>
		</div>
	 </li>
      <li>
        <div class="item-content">
          <div class="item-inner">
          <div class="item-media color-warn" style="width: 0.5rem;"></div>
            <div class="item-title label font-75 color-999" style="width:20%;">身份证</div>
            <div class="item-input">
              <input type="text" class="font-75 color-fff" id="sa_id_card" placeholder="身份证" >
            </div>
          </div>
        </div>
      </li>
      <li>
        <div class="item-content">
          <div class="item-inner">
          <div class="item-media color-warn" style="width: 0.5rem;"></div>
            <div class="item-title label font-75 color-999" style="width:20%;">教练</div>
            <div class="item-input">
            <div onclick="sa_choice_mc('PT')">
              <input type="text" class="font-75 color-fff" placeholder="点击选择教练" id="sa_choice_pt_name"  disabled="disabled" style="width:130px;">
              </div>
              <input type="hidden"  id="sa_choice_pt_id" disabled="disabled" style="width:130px;">
            </div>
            <div class="item-after">
              <span  class="button button-fill custom-btn-primary" style="width: 55px;" onclick="saCancelEmp('mc')">解绑 </span>
            </div>
          </div>
        </div>
      </li>
      <li>
       <div class="item-content">
          <div class="item-inner">
          <div class="item-media color-warn" style="width: 0.5rem;">*</div>
            <div class="item-title label font-75 color-999" style="width:20%;">推荐人</div>
            <div class="item-input">
            	<div onclick="sales_add_mem_choice_mem(10)">
              		<input type="text" class="font-75 color-fff" class="font-75" placeholder="点击选择推荐会员"  disabled="disabled" id="sales_new_mem_choice_mem_name"  style="width:130px;">
              	</div>
              	<input type="hidden"  id="sales_new_mem_choice_mem_id" name="new_mem_choice_mem_id" style="width:130px;">
            </div>
            <div class="item-after">
              <span  class="button button-fill custom-btn-primary" style="width: 55px;" onclick="saCancelEmp('mem')">解绑 </span>
            </div>
          </div>
        </div>
      </li>
      <!-- Date -->
      <!-- Switch (Checkbox) -->
      <li class="align-top">
        <div class="item-content">
          <div class="item-inner">
          <div class="item-media color-warn" style="width: 0.5rem;"></div>
            <div class="item-title label font-75 color-999" style="width:20%;">备注</div>
            <div class="item-input">
              <textarea id="sa_content_recommed" class="font-75 color-fff"></textarea>
            </div>
          </div>
        </div>
      </li>
    </ul>
  </div>
  <div class="content-block">
    <div class="row">
      <div class="col-50"><a href="#" onclick="closePopup('.popup-saAddMemRecommend')" class="button button-big button-fill button-default">取消</a></div>
      <div class="col-50"><a href="#" onclick="sa_add_recommend()" class="button button-big button-fill custom-btn-primary">提交</a></div>
    </div>
  </div>
</div>
</div>
