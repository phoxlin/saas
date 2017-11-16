package com.mingsokj.fitapp.ws.login;

import java.util.ArrayList;
import java.util.List;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.RandomValidateCode;
import com.jinhua.server.tools.SystemUtils;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.m.FitUser;

public class LoginAction extends BasicAction {
	/**
	 * 后台登录
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-login-backend", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void loginBackend() throws Exception {
		String inputStr = request.getParameter("Uvalidate");
		String validateStr = SystemUtils.getSessionAttr("USER_LOGIN", RandomValidateCode.RANDOMCODEKEY, request, response).toString();
		if (null == validateStr || !validateStr.equalsIgnoreCase(inputStr)) {
			throw new Exception("验证码错误");
		}
		String name = this.getParameter("name");
		String pwd = this.getParameter("pwd");
		if (name == null || name.length() <= 0 || pwd == null || pwd.length() <= 0 || "-1".equals(name)) {
			throw new Exception("用户名或者密码为空");
		}
		FitUser u = new FitUser();
		try {
			u.validite(name, Utils.getMd5(pwd), this);
		} catch (Exception e) {
			throw e;
		}

	}

	/**
	 * 后台门店切换
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-exchange-gym", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void exchangeGym() throws Exception {
		FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
		String gym = this.getParameter("gym");
		String cust_name = user.getCust_name();
		user.setViewGym(gym);
		// 查询权限
		Entity en = new EntityImpl(this);
		List<String> auths = new ArrayList<String>();
		int s = en.executeQuery("select auth from f_emp_auth where cust_name = ? and gym = ? and emp_id = ?", new Object[] { cust_name,gym,user.getId() });
		if (s > 0) {
			for (int i = 0; i < s; i++) {
				String auth = en.getStringValue("auth",i);
				auths.add(auth);
			}
		}
		user.setCds(auths);
		SystemUtils.setSessionUser(user, request, response);
	}

	/**
	 * 修改密码
	 * 
	 * @throws Exception
	 */
	@Route(value = "/self_change_pwd", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void updatePassword() throws Exception {
		String f_emp__old_pwd = this.getParameter("f_emp__old_pwd");
		String f_emp__new_pwd = this.getParameter("f_emp__new_pwd");
		String f_emp__new_again_pwd = this.getParameter("f_emp__new_again_pwd");

		FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);

		if (Utils.isNull(f_emp__old_pwd)) {
			throw new Exception("旧密码不正确,请重试");
		}

		if (Utils.isNull(f_emp__new_pwd) || !f_emp__new_pwd.equals(f_emp__new_again_pwd)) {
			throw new Exception("两次输入密码不一致");
		}

		Entity en = new EntityImpl("f_emp", this);
		en.setValue("id", user.getId());
		int s = en.search();
		if (s > 0) {
			String pwd = en.getStringValue("pwd");
			String oldmd5Pwd = Utils.getMd5(f_emp__old_pwd);
			if (oldmd5Pwd.equals(pwd)) {
				en.setValue("pwd", Utils.getMd5(f_emp__new_pwd));
				en.update();
			} else {
				throw new Exception("旧密码不正确,请重试");
			}
		} else {
			throw new Exception("未知错误");
		}

	}

}
