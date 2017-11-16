package com.mingsokj.fitapp.ws.app;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Random;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.log.Logger;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.Resources;
import com.jinhua.server.wx.Wx;
import com.mingsokj.fitapp.m.MemInfo;
import com.mingsokj.fitapp.utils.MemUtils;

/**
 * @author liul 2017年8月15日下午4:06:05
 */
public class 修改个人信息 extends BasicAction {
	/**
	 * 判断是员工还是会员
	 * 
	 * @Title: showJour
	 * @author: liul
	 * @date: 2017年8月15日下午5:53:20
	 * @throws Exception
	 */
	@Route(value = "/fit-ws-app-isEmp", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void showJour() throws Exception {
		String id = request.getParameter("id");
		String cust_name = request.getParameter("cust_name");
		MemInfo info = MemUtils.getMemInfo(id, cust_name, L, true, this.getConnection());
		String isEmp = info.isEmp() ? "Y" : "N";
		this.obj.put("isEmp", isEmp);
		List<MemInfo> list = new ArrayList<>();
		list.add(info);
		this.obj.put("list", list);
		// 查询会员修改时间
		Entity entity = new EntityImpl("f_mem", this);

		int size = entity.executeQuery("select * from f_mem_" + cust_name + " where id=?", new String[] { id });
		if (size > 0) {
			Date upDate = entity.getDateValue("update_time");
			if (upDate == null) {
				this.obj.put("isUpdate", "Y");
			} else {
				long time = (new Date().getTime() - upDate.getTime()) / 1000 / 60;
				if (time > 10) {
					this.obj.put("isUpdate", "N");
				} else {
					this.obj.put("isUpdate", "Y");
				}
			}
		}
	}

	/**
	 * 修改员工信息
	 * 
	 * @Title: editMsg
	 * @author: liul
	 * @date: 2017年8月15日下午5:47:55
	 * @throws Exception
	 */
	@Route(value = "/fit-ws-app-editMsg", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void editMsg() throws Exception {
		String id = request.getParameter("id");
		String gym = request.getParameter("gym");
		String openId = request.getParameter("openId");
		String emp_name = request.getParameter("emp_name");
		String emp_labels = request.getParameter("emp_labels");
		String emp_content = request.getParameter("emp_content");
		String serverId = this.getParameter("serverId");
		String edit_mem_sex = request.getParameter("edit_mem_sex");
		String birthday = request.getParameter("birthday");
		String edit_mem_name = request.getParameter("edit_mem_name");
		String edit_id_card = request.getParameter("edit_id_card");
		String pics2 = this.getParameter("pics2");
		String cust_name = request.getParameter("cust_name");
		Logger.error("serverId------------------------------>" + serverId);
		Logger.error("type------------------------------>" + request.getParameter("type"));
		Logger.error("pics2------------------------------>" + pics2);
		Entity entity = new EntityImpl("f_emp", this);
		Entity en = new EntityImpl("f_wx_cust", this);
		entity.setValue("id", id);
		if (!"".equals(emp_labels) && emp_labels != null) {

			entity.setValue("labels", emp_labels);
		}
		if (!"".equals(emp_name) && emp_name != null) {
			en.executeUpdate("update f_wx_cust_" + cust_name + " set nickname=? where wx_open_id=?", new String[] { emp_name, openId });
		}
		if (!"".equals(emp_content) && emp_content != null) {

			entity.setValue("summary", emp_content);
		}
		List<String> urlList = new ArrayList<String>();
		String appId = Resources.getProperty("wx." + cust_name + ".appId", "");
		String appSecret = Resources.getProperty("wx." + cust_name + ".appSecret", "");
		if (serverId != null && serverId != "") {
			String[] urls = serverId.split(",");
			Wx wx = new Wx(appId, appSecret, L);
			for (String url : urls) {
				// 需要AppID，appsecret
				String picurl = wx.downMedia(url);
				urlList.add(picurl);

			}
		}
		Logger.error("picurl------------------------------>" + urlList);
		if (urlList != null && urlList.size() > 0) {
			if (!"".equals(pics2) && pics2 != null) {
				// 拿到头像的图片
				en.executeUpdate("update f_wx_cust_" + cust_name + " set headurl=? where wx_open_id=?", new String[] { urlList.get(0), openId });
				if (urlList.size() > 1) {
					for (int i = 1; i < urlList.size(); i++) {
						entity.setValue("pic" + i, urlList.get(i));

					}
				}
			} else {
				for (int i = 0; i < urlList.size(); i++) {
					entity.setValue("pic" + (i + 1), urlList.get(i));
				}
			}
		}
		try {
			entity.update();
		} catch (Exception e) {
			// TODO: handle exception
		}
		MemInfo info = new MemInfo();
		info.setMem_name(edit_mem_name);
		info.setBirthday(birthday);
		info.setIdCard(edit_id_card);
		info.setSex(edit_mem_sex);
		info.setId(id);
		info.setGym(gym);
		info.setGym(cust_name);
		info.update(this.getConnection(), true);

		// 修改后更新修改时间
		Entity updateTime = new EntityImpl("f_mem", this);
		int size = updateTime.executeQuery("select * from f_mem_" + cust_name + " where id=?", new String[] { id });
		if (size > 0) {
			String update_time = updateTime.getStringValue("update_time");
			boolean flag = ("".equals(update_time) || update_time == null) ? true : false;
			if (flag) {
				updateTime.setTablename("f_mem_" + cust_name);
				updateTime.setValue("id", id);
				updateTime.setValue("update_time", new Date());
				updateTime.update();
			}
		}
	}

	/**
	 * 修改会员信息
	 * 
	 * @Title: editMemMsg
	 * @author: liul
	 * @date: 2017年8月16日上午11:16:59
	 * @throws Exception
	 */
	@Route(value = "/fit-ws-app-editMemMsg", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void editMemMsg() throws Exception {
		String id = request.getParameter("id");
		String gym = request.getParameter("gym");
		String openId = request.getParameter("openId");
		String cust_name = request.getParameter("cust_name");
		String mem_name = request.getParameter("mem_name");
		String mem_addr = request.getParameter("mem_addr");
		String edit_mem_sex = request.getParameter("edit_mem_sex");
		String birthday = request.getParameter("birthday");
		String edit_mem_name = request.getParameter("edit_mem_name");
		String edit_id_card = request.getParameter("edit_id_card");
		String serverId = this.getParameter("serverId");
		Logger.error("serverId------------------------------>" + serverId);
		Logger.error("type------------------------------>" + id);
		Entity entity = new EntityImpl("f_mem", this);
		Entity en = new EntityImpl("f_mem", this);
		entity.setTablename("f_mem_" + cust_name);
		StringBuffer sql = new StringBuffer("update f_mem_" + cust_name);
		if (!"".equals(birthday) && birthday != null) {
			entity.setValue("birthday", birthday);
			sql.append(" set birthday ='" + birthday + "'");
		}
		if (!"".equals(mem_name) && mem_name != null) {

			en.executeUpdate("update f_wx_cust_" + cust_name + " set nickname=? where wx_open_id=?", new String[] { mem_name, openId });
		}
		if (!"".equals(mem_addr) && mem_addr != null) {
			sql.append(" ,addr='" + mem_addr + "'");
		}
		List<String> urlList = new ArrayList<String>();
		String appId = Resources.getProperty("wx." + cust_name + ".appId", "");
		String appSecret = Resources.getProperty("wx." + cust_name + ".appSecret", "");
		if (serverId != null && serverId != "") {
			String[] urls = serverId.split(",");
			Wx wx = new Wx(appId, appSecret, L);
			for (String url : urls) {

				// 需要AppID，appsecret
				String picurl = wx.downMedia(url);
				urlList.add(picurl);

			}
			en.executeUpdate("update f_wx_cust_" + cust_name + " set headurl=? where wx_open_id=?", new String[] { urlList.get(0), openId });
		}
		sql.append(" ,mem_name='" + edit_mem_name + "'");
		sql.append(" ,id_card='" + edit_id_card + "'");
		sql.append(" ,sex='" + edit_mem_sex + "'");
		sql.append(" where id=?");

		entity.executeUpdate(sql.toString(), new String[] { id });

		MemInfo info = new MemInfo();
		info.setMem_name(edit_mem_name);
		info.setBirthday(birthday);
		info.setIdCard(edit_id_card);
		info.setSex(edit_mem_sex);
		info.setId(id);
		info.setGym(gym);
		info.setGym(cust_name);
		info.update(this.getConnection(), false);
		// 修改后更新修改时间
		Entity updateTime = new EntityImpl("f_mem", this);
		int size = updateTime.executeQuery("select * from f_mem_" + cust_name + " where id=?", new String[] { id }, 1, 1);
		if (size > 0) {
			String update_time = updateTime.getStringValue("update_time");
			boolean flag = ("".equals(update_time) || update_time == null) ? true : false;
			if (flag) {
				updateTime.setTablename("f_mem_" + cust_name);
				updateTime.setValue("id", id);
				updateTime.setValue("update_time", new Date());
				updateTime.update();
			}
		}
	}

	/**
	 * 文件上传
	 * 
	 * @Title: uploadPic
	 * @author: liul
	 * @date: 2017年8月17日上午9:34:58
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws java.io.IOException
	 */
	@SuppressWarnings("unchecked")
	public void uploadPic(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		response.setContentType("text/html;charset=utf-8");
		request.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		// 1.检查下请求是否有文件提交过来
		boolean isMultipart = ServletFileUpload.isMultipartContent(request);
		if (isMultipart) {
			// 创建一个基于磁盘的文件项目工程
			DiskFileItemFactory factory = new DiskFileItemFactory();
			// 创建一个新的文件上传处理程序
			ServletFileUpload upload = new ServletFileUpload(factory);
			// Parse the request
			List<FileItem> items = null;
			try {
				items = upload.parseRequest(request);
				// 遍历次集合
				for (FileItem fileItem : items) {
					// 如果是普通的字符串表单
					if (fileItem.isFormField()) {
						// 拿到名字
						System.out.println(fileItem.getFieldName() + ":" + fileItem.getString());
					} else {
						String nodepath = this.getClass().getClassLoader().getResource("/").getPath();
						// 项目的根目录路径
						String path = nodepath.substring(1, nodepath.length() - 16);
						// 如果是文件，先拿到路劲
						// String path =
						// this.getServletContext().getRealPath("/");
						File filePath = new File(path + "upload/");
						// 如果文件不存在就去创建
						if (!filePath.exists()) {
							filePath.mkdirs();
						}
						Random random = new Random();
						String fileName = filePath + "/" + new Date().getTime() + random.nextInt(1000) + fileItem.getName();
						File uploadFile = new File(fileName);
						// 把文件放入到服务器upload里
						fileItem.write(uploadFile);
					}

				}

			} catch (FileUploadException e) {
				System.out.println("获取请求失败");
				e.printStackTrace();
			} catch (Exception e) {
				System.out.println("文件上传失败");
				e.printStackTrace();
			} finally {
				out.close();
			}
		}

	}
}
