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
import com.mingsokj.fitapp.utils.ExcelUtils;

public class 卡类型Excel导入 extends BasicAction {

	public static String[] cardTypes = new String[] { "天数卡", "次卡" };
	public static String[] cardStates = new String[] { "启用", "停用" };

	/**
	 * 导入卡类型
	 * 
	 * @throws Exception
	 */
	@Route(value = "/ws-import-excel-cards", conn = true, m = HttpMethod.POST)
	public void importCards() throws Exception {
		String u = this.getParameter("url");
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
			is = conn.getInputStream(); // "G:/项目/004健身房/也跑基础数据表/03卡类型.xlsx"
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
		 * 第1列表示:卡类型*<br/>
		 * 第2列表示:卡名称*<br/>
		 * 第3列表示:有效次数(次卡必填)<br/>
		 * 第4列表示:有效天数*<br/>
		 * 第5列表示:办卡费用<br/>
		 * 第6列表示:状态*<br/>
		 * 第7列表示:可用门店<br/>
		 * 第8列表示:通店组别<br/>
		 */

		int rowIndex = 0;
		boolean flag = false;
		for (int i = 0; i < st.getLastRowNum(); i++) {
			Row row = st.getRow(i);
			if (row != null) {
				String cardtype = ExcelUtils.getValue(row.getCell(0));
				String typename = ExcelUtils.getValue(row.getCell(1));
				String times = ExcelUtils.getValue(row.getCell(2));
				String days = ExcelUtils.getValue(row.getCell(3));
				String fee = ExcelUtils.getValue(row.getCell(4));
				String state = ExcelUtils.getValue(row.getCell(5));
				String gyms = ExcelUtils.getValue(row.getCell(6));
				String generalStoreLevel = ExcelUtils.getValue(row.getCell(7));
				if (cardtype.equals("卡类型") && typename.equals("卡名称") && times.equals("有效次数(次卡必填)")
						&& days.equals("有效天数") && fee.equals("办卡费用") && state.equals("状态") && gyms.equals("可用门店")
						&& generalStoreLevel.equals("通店组别")) {
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
