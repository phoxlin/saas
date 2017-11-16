<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 文章页面和模板 -->
<jsp:include page="/app/tpl/articleTpl.jsp"></jsp:include>
<!-- 活动页面和模板 -->
<jsp:include page="/app/tpl/activeTpl.jsp"></jsp:include>
<!-- 课程页面 -->
<jsp:include page="/app/tpl/lessonTpl.jsp"></jsp:include>
<!-- 体验课程 -->
<jsp:include page="experienceLesson.jsp"></jsp:include>
<!-- 体验课程详情 -->
<jsp:include page="showLessonDetail.jsp"></jsp:include>
<!-- 课程表 -->
<jsp:include page="lessonPlanPopup.jsp"></jsp:include>

<!--我的会员卡  -->
<jsp:include page="myCards.jsp"></jsp:include>
<jsp:include page="mineCardDetailTpl.jsp"></jsp:include>

<!-- 修改个人信息 -->
<jsp:include page="../partial/editEmpMsg.jsp"></jsp:include>

<!-- 为你推荐(课程) -->
<jsp:include page="showLessonTop.jsp"></jsp:include>
<!-- 推荐课程 -->
<jsp:include page="lessonPlanPopupRecommend.jsp"></jsp:include>
<!-- 课程表详情 -->
<jsp:include page="lessonPlanDetailPopup.jsp"></jsp:include>
<jsp:include page="lessonPlanDetailPopup2.jsp"></jsp:include>
<!--私人教练 -->
<jsp:include page="EmpListPopup.jsp"></jsp:include>

<!-- 圈聊 -->
<jsp:include page="interactPopup.jsp"></jsp:include>
<!-- 健身圈模板 -->
<jsp:include page="../tpl/interactListTpl.jsp"></jsp:include>
<!-- 添加健身圈 -->
<jsp:include page="addInteractPopup.jsp"></jsp:include>
<!-- 我是老板首页 -->
<jsp:include page="../boss/boss_index.jsp"></jsp:include>
<!-- 我是老板--销售来源 -->
<jsp:include page="../boss/salesFromReport.jsp"></jsp:include>

<!-- 我是会籍首页 -->
<jsp:include page="../sales/sales_index.jsp"></jsp:include>
<!-- 我是教练首页 -->
<jsp:include page="../pt/pt_index.jsp"></jsp:include>
<!-- 我是教练管理员首页 -->
<jsp:include page="../manage/pt_manage_index.jsp"></jsp:include>
<!-- 我是会籍管理员首页 -->
<jsp:include page="../manage/mc_manage_index.jsp"></jsp:include>
<!-- 我是会籍主管--我的员工 -->
<jsp:include page="../sales/ex_mc_emps.jsp"></jsp:include>
<!-- 我是会籍主管--我的员工销售记录 -->
<jsp:include page="../manage/todaySalesCard.jsp"></jsp:include>

<!-- 我是会籍--销售记录 -->
<jsp:include page="../sales/sales_record.jsp"></jsp:include>
<!-- 我是会籍--我的报表 -->
<jsp:include page="../sales/mcSalesReport.jsp"></jsp:include>
<!-- 我是会籍--会员转介绍 -->
<jsp:include page="../sales/salesAddMemRecommend.jsp"></jsp:include>
<!-- 我是会籍--会员转介绍 -->
<jsp:include page="../sales/addNewMem.jsp"></jsp:include>
<!-- 我是会籍管理员--公共池 -->
<jsp:include page="../manage/potentialMCMemPool.jsp"></jsp:include>
<!-- 我是会籍管理员--今日新增 -->
<jsp:include page="../manage/mc_todayAdd.jsp"></jsp:include>
<!-- 我是会籍管理员--今日售额 -->
<jsp:include page="../manage/mc_today_price.jsp"></jsp:include>
<!-- 我是会籍管理员--会籍详情 -->
<jsp:include page="mcDetialPopup.jsp"></jsp:include>
<!-- 我是教练管理员--公共池 -->
<jsp:include page="../manage/potentialMemPool.jsp"></jsp:include>
<!-- 教练管理员--教练员工 -->
<jsp:include page="../manage/ptListPopup.jsp"></jsp:include>
<!-- 教练管理员--今日入场会员 -->
<jsp:include page="../manage/todayCheckinMen.jsp"></jsp:include>
<!-- 教练管理员--今日私教售课记录 -->
<jsp:include page="../manage/todayPrivateClassSales.jsp"></jsp:include>
<!-- 教练员工的销售记录 -->
<jsp:include page="../manage/empsPtSalesRecord.jsp"></jsp:include>
<!-- 教练详情 -->
<jsp:include page="EmpDetialPopup.jsp"></jsp:include>
<!-- 消课记录-->
<jsp:include page="../pt/reduce_class_record.jsp"></jsp:include>
<!-- 我是教练团操课 -->
<jsp:include page="../pt/pt_LessonPlanPopup.jsp"></jsp:include>
<!-- 我是教练团操课详情 -->
<jsp:include page="../pt/ptLessonPlanDetailPopup.jsp"></jsp:include>
<!-- 我是教练--学员列表 -->
<jsp:include page="../pt/mem_index.jsp"></jsp:include>
<!-- 我是教练--潜在会员 -->
<jsp:include page="../pt/potentialMem.jsp"></jsp:include>
<!-- 我是教练--潜在会员池 -->
<jsp:include page="../pt/potentialMemPool.jsp"></jsp:include>
<!-- 我是教练--销售记录 -->
<jsp:include page="../pt/sales_record.jsp"></jsp:include>
<!-- 我是教练--我的报表 -->
<jsp:include page="../pt/ptSalesReport.jsp"></jsp:include>
<!-- 我是管理--我和我的员工的报表 -->
<jsp:include page="../manage/exAndEmpsRecord.jsp"></jsp:include>
<!-- 我是管理--销售排行 -->
<jsp:include page="../manage/salesRankReport.jsp"></jsp:include>

<!-- 会员推荐 -->
<jsp:include page="memRecommend.jsp"></jsp:include>
<!-- 推荐排行 -->
<jsp:include page="recommendRaking.jsp"></jsp:include>

<jsp:include page="../pt/customerDetial.jsp"></jsp:include>
<!-- 添加推荐会员 -->
<jsp:include page="addMemRecommend.jsp"></jsp:include>
<!-- 会员维护首页 -->
<jsp:include page="../sales/mem_index.jsp"></jsp:include>
<!-- 会员详情 -->
<jsp:include page="../sales/customerDetial.jsp"></jsp:include>
<!-- 会员详情 --会员卡页面-->
<jsp:include page="../sales/customerCards.jsp"></jsp:include>
<!-- 会员详情 --充值记录页面-->
<jsp:include page="../sales/customerRechargeRecord.jsp"></jsp:include>
<!-- 会员详情 --签到记录页面-->
<jsp:include page="../sales/customerCheckInRecord.jsp"></jsp:include>
<!-- 潜在客户 -->
<jsp:include page="../sales/potentialCustomers.jsp"></jsp:include>
<!-- 潜客池 -->
<jsp:include page="../sales/potentialPool.jsp"></jsp:include>
<!-- 添加潜在客户 -->
<jsp:include page="../sales/potentialCustomersAdd.jsp"></jsp:include>
<!-- 健身日记-->
<jsp:include page="showJour.jsp"></jsp:include>
<!-- 我的订单-->
<jsp:include page="myIndentPopup.jsp"></jsp:include>
<!-- 我是会籍主管--我的员工会员 -->
<jsp:include page="../manage/showMcMemsById.jsp"></jsp:include>
<!-- 私教预约 -->
<jsp:include page="privateOrderPopup.jsp"></jsp:include>
<!-- 公共调用下级教练 -->
<jsp:include page="../publicPopup/ptListPopup.jsp"></jsp:include>
<!-- 公共调用下级会籍-->
<jsp:include page="../publicPopup/mcListPopup.jsp"></jsp:include>
<!-- 公共调用选择员工-->
<jsp:include page="../publicPopup/empListPopup.jsp"></jsp:include>
<!-- 公共调用选择会员-->
<jsp:include page="../publicPopup/memListPopup.jsp"></jsp:include>
<!-- 潜在客户详情 -->
<jsp:include page="../sales/PotentialCustomerDetial.jsp"></jsp:include>
<!-- 修改潜在客户详情-->
<jsp:include page="../sales/updatePotentialCustormer.jsp"></jsp:include>
<!-- 登陆页面-->
<jsp:include page="wxloginPopup.jsp"></jsp:include>
<!-- 图片浏览器-->
<jsp:include page="showPics.jsp"></jsp:include>
<!-- 健身计划-->
<jsp:include page="../pt/fit_plan.jsp"></jsp:include>
<!-- 提成记录-->
<%--jsp:include page="../pt/fit_plan.jsp"></jsp:include> --%>
<!-- 朋友-->
<jsp:include page="../popups/friend.jsp"></jsp:include>
<!-- 体测数据-->
<jsp:include page="../popups/bodyData.jsp"></jsp:include>
<!-- 设置页面-->
<jsp:include page="../popups/settingPopup.jsp"></jsp:include>
<!-- 意见反馈页面 -->
<jsp:include page="../popups/feedbackPopup.jsp"></jsp:include>
<!-- 提成记录页面-->
<jsp:include page="../popups/PercentRecortPopup.jsp"></jsp:include>
<!--买卡页面  -->
<jsp:include page="buyCard.jsp"></jsp:include>
<jsp:include page="cardDetialPopup.jsp"></jsp:include>
<!-- 圈圈图片放大 -->
<jsp:include page="swipePhoto.jsp"></jsp:include>
