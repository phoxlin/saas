package com.mingsokj.fitapp.utils;

import com.jinhua.server.ActionMail;
import com.mingsokj.fitapp.m.FitUser;

public class FitAppActionMail extends ActionMail {

	@Override
	public String getTitle() {
		StringBuilder sb = new StringBuilder();
		if (this.getUser() != null) {
			try {
				sb.append("用户【");
				sb.append(this.getUser().getId());
				sb.append("-");
				sb.append(this.getUser().getLoginName());
				sb.append("】");
			} catch (Exception e) {
			}
		}
		sb.append("执行系统--超过【");
		sb.append(this.getEs());
		sb.append("】");
		return sb.toString();
	}

	@Override
	public String getContent() {
		StringBuilder sb = new StringBuilder("执行系统超过【" + this.getEs() + "ms】,怀疑有性能缺陷请检查：<br/>");
		try {
			sb.append("当前服务器:" + request.getServletContext().getServerInfo() + "<br/>");
			sb.append("当前服务器IP:" + request.getLocalAddr() + "<br/>");
			sb.append("当前服务器端口:" + request.getLocalPort() + "<br/>");
			sb.append("当前服务器getPathInfo:" + request.getPathInfo() + "<br/>");
		} catch (Exception e) {
		}
		try {
			FitUser user = (FitUser) this.getUser();
			sb.append("当前客户代码:" + user.getCust_name() + "<br/>");
			sb.append("当前门店代码:" + user.getViewGym() + "<br/>");
			sb.append("当前用户name:" + user.getMemInfo().getName() + "<br/>");
			sb.append("当前用户phone:" + user.getMemInfo().getPhone() + "<br/>");
			sb.append("当前用户nickname:" + user.getMemInfo().getNickname() + "<br/>");
			sb.append("当前用户Id:" + user.getId() + "<br/>");
		} catch (Exception e) {
		}
		for (int i = 0; i < this.getContentList().size(); i++) {
			sb.append(this.getContentList().get(i));
			sb.append("<br/>");
		}
		return sb.toString();
	}

	@Override
	public boolean isSend() {
		return false;
	}

}
