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
import com.mingsokj.fitapp.m.FitUser;
import com.mingsokj.fitapp.utils.ExcelUtils;

public class 商品Excel导入 extends BasicAction {

	public static String[] cardTypes = new String[] { "天数卡", "次卡" };

	/**
	 * 商品导入
	 * 
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	@Route(value = "/ws-import-excel-goods", conn = true, m = HttpMethod.POST)
	public void importGoods() throws Exception {
		String u = this.getParameter("url");
		boolean confirmed = Utils.isTrue(this.getParameter("confirm"));
		FitUser user = (FitUser) this.getSessionUser();
		if (user == null) {
			throw new Exception("登录失效，请重新登录");
		}
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
		 * 第1列表示:商品分类*<br/>
		 * 第2列表示:门店名称<br/>
		 * 第3列表示:仓库名称<br/>
		 * 第4列表示:商品名称*<br/>
		 * 第5列表示:条形码*<br/>
		 * 第6列表示:商品库存*<br/>
		 * 第7列表示:单价*<br/>
		 * 第8列表示:描述<br/>
		 */
		/// 商品分类* 商品名称* 条形码* 商品库存* 单价* 描述
		String typecodeId = null;
		int rowIndex = 0;
		boolean flag = false;
		for (int i = 0; i < st.getLastRowNum(); i++) {
			Row row = st.getRow(i);
			if (row != null) {
				String type = ExcelUtils.getValue(row.getCell(0));
				String gymName = ExcelUtils.getValue(row.getCell(1));
				String storeName = ExcelUtils.getValue(row.getCell(2));
				String name = ExcelUtils.getValue(row.getCell(3));
				String barcode = ExcelUtils.getValue(row.getCell(4));
				String remains = ExcelUtils.getValue(row.getCell(5));
				String price = ExcelUtils.getValue(row.getCell(6));
				String remark = ExcelUtils.getValue(row.getCell(7));
				if (type.equals("商品分类") && gymName.equals("门店名称") && storeName.equals("仓库名称") && name.equals("商品名称")
						&& barcode.equals("条形码") && remains.equals("商品库存") && price.equals("单价")
						&& remark.equals("描述")) {
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
