package com.mingsokj.fitapp.ws.dx;

import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.utils.ExcelUtils;

public class 员工Excel导入 extends BasicAction {

	private static String[] levels = new String[] { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" };

	/**
	 * 员工导入
	 * 
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Route(value = "/ws-import-excel-employee", conn = true, m = HttpMethod.POST)
	public void importEmployees() throws Exception {
		String u = this.getParameter("url");
		boolean confirmed = Utils.isTrue(this.getParameter("confirm"));
		HttpURLConnection conn = null;
		InputStream is = null;
		URL url = null;

		Workbook wb = null;
		Sheet st = null;
		try {
			url = new URL(u);
			conn = (HttpURLConnection) url.openConnection();
			conn.setDoInput(true);
			conn.setRequestMethod("GET");
			is = conn.getInputStream();
			wb = new XSSFWorkbook(is);
			st = wb.getSheetAt(0);
		} catch (Exception e) {
			throw e;
		} finally {
			try {
				if (conn != null) {
					conn.disconnect();
				}
			} catch (Exception e) {
			}
			try {
				if (wb != null) {
					wb.close();
				}
			} catch (Exception e) {
			}
			try {
				if (is != null) {
					is.close();
				}
			} catch (Exception e) {
			}
		}

		/**
		 * 第1列表示:姓名*<br/>
		 * 第2列表示:手机号码*<br/>
		 * 第3列表示:职位(角色)*<br/>
		 * 第4列表示:上级经理(手机号)<br/>
		 * 第5列表示:工号*<br/>
		 * 第6列表示:性别*<br/>
		 * 第7列表示:生日*<br/>
		 * 第8列表示:身份证<br/>
		 * 第9列表示:等级(1-10)<br/>
		 * 第10列表示:入职时间<br/>
		 * 第11列表示:基本工资<br/>
		 * 第12列表示:所属门店<br/>
		 * 第13列表示:可见门店<br/>
		 */

		int rowIndex = 0;
		boolean flag = false;
		for (int i = 0; i < st.getLastRowNum(); i++) {
			Row row = st.getRow(i);
			if (row != null) {
				String name = ExcelUtils.getValue(row.getCell(0));
				String phone = ExcelUtils.getValue(row.getCell(1));
				String role = ExcelUtils.getValue(row.getCell(2));
				String pPhone = ExcelUtils.getValue(row.getCell(3));
				String userno = ExcelUtils.getValue(row.getCell(4));
				String sex = ExcelUtils.getValue(row.getCell(5));
				String birday = ExcelUtils.getValue(row.getCell(6));
				String idcard = ExcelUtils.getValue(row.getCell(7));
				String userLevel = ExcelUtils.getValue(row.getCell(8));
				String comingDate = ExcelUtils.getValue(row.getCell(9));
				String basicMoney = ExcelUtils.getValue(row.getCell(10));
				String begym = ExcelUtils.getValue(row.getCell(11));
				String canGoGym = ExcelUtils.getValue(row.getCell(12));
				if (name.equals("姓名") && phone.equals("手机号码") && role.equals("职位(角色)") && pPhone.equals("上级经理(手机号)")
						&& userno.equals("工号") && sex.equals("性别") && birday.equals("生日") && idcard.equals("身份证")
						&& userLevel.equals("等级(1-10)") && comingDate.equals("入职时间") && basicMoney.equals("基本工资")
						&& begym.equals("所属门店") && canGoGym.equals("可见门店")) {
					rowIndex = i + 1;
					flag = true;
					break;
				}
			}
		}

		if (!flag) {
			throw new Exception("模板内容不对");
		}

	}

}
