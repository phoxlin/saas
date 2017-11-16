package com.mingsokj.fitapp.ws.bg.mem;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.QiniuUtils;
import com.mingsokj.fitapp.m.FitUser;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.utils.MemUtils;

public class 上传头像 extends BasicAction {
	@Route(value = "fit-bg-mem-save-header", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void user_save_head() throws Exception {
		String mem_id = request.getParameter("mem_id");
//		String mem_gym = request.getParameter("mem_gym");
		// 获取当前用户
		FitUser user = (FitUser) this.getSessionUser();
		if (user == null) {
			throw new Exception("当前用户信息已经失效,请重新登录");
		}
		// 图片是一串base64编码的字符串
		String pic = request.getParameter("imgData");
		// String imgData1 = request.getParameter("imgData1");
		// String imgData2 = request.getParameter("imgData2");
		if (null == pic || pic.length() <= 0) {
			throw new Exception("图片上传失败");
		}
		// 解码
		byte[] bs = java.util.Base64.getDecoder().decode(pic.getBytes());
		// 生成头像文件名
		String fileName = mem_id + ".jpg";
		// 上传图片至七牛服务器
		String path = QiniuUtils.upload(bs, fileName);
		// 保存图片路径到对呀健身房的数据库
		MemInfo memInfo = MemUtils.getMemInfo(mem_id, user.getCust_name(), L);
		memInfo.setPicUrl(path);
		memInfo.update(this.getConnection(), false);
		// json响应图片路径
		this.obj.put("path", path);
	}

	@Route(value = "fit-bg-mem-save-header-imgPath", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void user_save_head_img() throws Exception {
		String mem_id = request.getParameter("mem_id");
		String mem_gym = request.getParameter("mem_gym");
		String imgPath = request.getParameter("imgPath");

		MemInfo memInfo = new MemInfo();
		memInfo.setId(mem_id);
		memInfo.setGym(mem_gym);
		memInfo.setPicUrl(imgPath);
		memInfo.update(this.getConnection(), false);
	}
}
