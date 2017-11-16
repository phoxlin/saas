<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style type="text/css">
.slide_box{
    display: block;
    position: fixed;
    left: 0;
    top: 0;
    z-index: 8;
    width: 100%;
    height: 100%;
    background-color: #000;
}
.slide{
    position: absolute;
    left: 0;
    top: 0;
    bottom: 0;
    width:100%;
    overflow: hidden;
}
.slide:after{
    content: '';
    display: block;
    width: 100%;
    padding-top: 100%;
}
.slide ul{
    position: absolute;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    margin-top: 0;
}
.slide li{
    list-style: none;
    position: absolute;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
}
/* 解决js阻塞页面显示首屏 */
.slide li:first-child{
    z-index: 1;
}
.slide li>div{
    display: table-cell;
    vertical-align: middle;
    text-align: center;
}
.slide li img{
	display: block;
    max-width: 100%;
    max-height: 100%;
    width: auto;
    height: auto;
    margin: 0 auto;
    border: none;
    vertical-align: middle;
}
.num_box{
    position: absolute;    z-index: 999;
    left: 0;
    bottom: 0;
    width: 100%;
    height: 2.2rem;
    line-height: 2.2rem;
    color: #fff;
    text-align: center;
    font-size: 0.8rem;
}
</style>

<div class="popup popup-swipePhoto">
	<div class="content">
		<!-- 这里是页面内容区 -->
		<div class="slide_box" onclick="closeSwipePhoto()">
		    <div class="num_box">
		        <span class="num"></span>/<span class="sum"></span>
		    </div>
		</div>
	</div>
</div>
<script>
function closeSwipePhoto(){
	$('.slide').remove();
    $('.slide_box').hide();
	closePopup(".popup-swipePhoto");
}
</script>