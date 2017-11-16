package com.mingsokj.fitapp.utils;

import org.apache.poi.ss.usermodel.Cell;

public class ExcelUtils {

	/**
	 * 单元格内容
	 * 
	 * @param hssfCell
	 * @return
	 */
	public static String getValue(Cell hssfCell) {
		String val = "";
		if (hssfCell == null) {
			return val;
		}
		if (hssfCell.getCellType() == Cell.CELL_TYPE_BOOLEAN) {
			hssfCell.setCellType(Cell.CELL_TYPE_STRING);
			val = String.valueOf(hssfCell.getStringCellValue());
		} else if (hssfCell.getCellType() == Cell.CELL_TYPE_NUMERIC) {
			hssfCell.setCellType(Cell.CELL_TYPE_STRING);
			val = String.valueOf(hssfCell.getStringCellValue());
		} else if (hssfCell.getCellType() == Cell.CELL_TYPE_STRING) {
			val = String.valueOf(hssfCell.getStringCellValue());
		} else {
			hssfCell.setCellType(Cell.CELL_TYPE_STRING);
			val = String.valueOf(hssfCell.getStringCellValue());
		}
		val = val.trim();
		if (val.length() > 0) {
			val = val.replace("*", "");
		}
		return val;
	}
}
