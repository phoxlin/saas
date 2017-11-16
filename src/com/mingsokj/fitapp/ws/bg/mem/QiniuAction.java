package com.mingsokj.fitapp.ws.bg.mem;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.Set;

import com.jinhua.SFile;
import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.DBUtils;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.PicUtils;
import com.jinhua.server.tools.Resources;
import com.qiniu.common.Config;
import com.qiniu.common.QiniuException;
import com.qiniu.common.Zone;
import com.qiniu.storage.UploadManager;
import com.qiniu.util.Auth;

public class QiniuAction extends BasicAction {

	private static String accessKey = Resources.getProperty("qiniu.filesotre.accessKey");
	private static String secretKey = Resources.getProperty("qiniu.filesotre.secretKey");
	private static String bucketName = Resources.getProperty("qiniu.filesotre.bucketName");
	public static boolean configV1 = Resources.getBooleanProperty("qiniu.filesotre.v1");
	private static String bucketUrl = Resources.getProperty("qiniu.filesotre.bucketUrl", "http://oixty02vf.bkt.clouddn.com/");

	@Route(value = "/upload-qiniu-uptoken", conn = false, m = { HttpMethod.GET }, type = ContentType.JSON)
	public void uptoken() throws Exception {
		// 需要修改AK、SK、bucketName

		Auth auth = Auth.create(accessKey, secretKey);
		String key = DBUtils.oid();
		String token = auth.uploadToken(bucketName);
		this.obj.put("key", key);
		this.obj.put("uptoken", token);
	}

	@Route(value = "/getUploadPic/fid", conn = false, m = { HttpMethod.GET }, type = ContentType.JPG)
	public void getUploadPic(String fid) throws Exception {
		SFile file = null;
		if (fid != null) {
			if (fid.length() == 32) {
				file = new SFile(fid);
			} else if (fid.length() == 40) {
				file = SFile.createSFileByHashCode(fid);
			}
		}
		if (file == null) {
			throw new Exception("没有找到系统文件");
		}
		Set<String> keys = request.getParameterMap().keySet();
		File des = null;
		if (file.isPic()) {
			int width = 0;
			int height = 0;
			response.setContentType("image/jpeg; charset=UTF-8");
			for (String key : keys) {
				if (key.startsWith("imageView2")) {
					String[] ps = key.split("/");
					if (ps != null && ps.length > 0) {
						for (int i = 0; i < ps.length; i++) {
							if ("w".equalsIgnoreCase(ps[i])) {
								if (ps.length > i + 1) {
									try {
										width = Integer.parseInt(ps[i + 1]);
									} catch (Exception e) {
									}
								}
							} else if ("h".equalsIgnoreCase(ps[i])) {
								if (ps.length > i + 1) {
									try {
										height = Integer.parseInt(ps[i + 1]);
									} catch (Exception e) {
									}
								}
							}
						}
					}
					break;
				}
			}

			if (width > 0 && height > 0) {
				des = new File(file.getPath() + "." + width + "_" + height + "." + file.getExt());
				if (!des.exists()) {
					PicUtils.compressPic(file.getFile(), des, width, height);
				}
			} else {
				des = file.getFile();
			}
		} else {
			des = file.getFile();
		}

		response.setHeader("content-disposition", "attachment;fileName=" + URLEncoder.encode(file.getFileName(), "UTF-8"));
		InputStream reader = null;
		OutputStream out = null;
		byte[] bytes = new byte[1024];
		int len = 0;
		try {
			// 读取文件
			reader = new FileInputStream(des);
			out = response.getOutputStream();
			while ((len = reader.read(bytes)) > 0) {
				out.write(bytes, 0, len);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (reader != null) {
				reader.close();
			}
			if (out != null) {
				out.close();
			}
		}
	}

	public static void main(String[] args) throws QiniuException {
		File f = new File("D:/log4j.log");
		String url = QiniuAction.upload(f);
		System.out.println(url);
	}

	public static String upload(File filePath) throws QiniuException {
		try {
			if (configV1) {
				Config.zone = Zone.zone1();
			}
			Auth auth = Auth.create(accessKey, secretKey);
			String key = DBUtils.oid() + "_._" + filePath.getName();
			String token = auth.uploadToken(bucketName);
			// 调用put方法上传
			UploadManager uploadManager = new UploadManager();
			uploadManager.put(filePath, key, token);
			return bucketUrl + key;
		} catch (QiniuException e) {
			throw e;
		}
	}

}
