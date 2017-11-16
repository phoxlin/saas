package com.mingsokj.fitapp.ws.bg.cashier;

import java.util.Random;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;

public class 自动生成卡号 extends BasicAction {

	/**
	 * 会员出入场记录
	 * 
	 * @throws Exception
	 */
	@Route(value = "/fit-cashier-createCardNo", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void rechargeinfo() throws Exception {
		String allChar = "0123456789";
		StringBuffer sb = new StringBuffer();
		Random random = new Random();
		for (int i = 0; i < 1; i++) {
			sb.append(allChar.charAt(random.nextInt(10)));
		}
		String st = sb.toString() + getUnixTime();
		st = st + getBankCardCheckCode(st);
		this.obj.put("code", st);
	}

	private static int i = 0;

	/***
	 * 获取当前系统时间戳 并截取
	 * 
	 * @return
	 */
	private synchronized static String getUnixTime() {
		try {
			Thread.sleep(10);// 线程同步执行，休眠10毫秒 防止卡号重复
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		i++;
		i = i > 100 ? i % 10 : i;
		return ((System.currentTimeMillis() / 100) + "").substring(1) + (i % 10);
	}

	/**
	 * 校验银行卡卡号
	 * 
	 * @param cardId
	 * @return
	 */
	public static boolean checkBankCard(String cardId) {
		char bit = getBankCardCheckCode(cardId.substring(0, cardId.length() - 1));
		if (bit == 'N') {
			return false;
		}
		return cardId.charAt(cardId.length() - 1) == bit;
	}

	/**
	 * 从不含校验位的银行卡卡号采用 Luhm 校验算法获得校验位
	 * 
	 * @param nonCheckCodeCardId
	 * @return
	 */
	public static char getBankCardCheckCode(String nonCheckCodeCardId) {
		if (nonCheckCodeCardId == null || nonCheckCodeCardId.trim().length() == 0 || !nonCheckCodeCardId.matches("\\d+")) {
			// 如果传的不是数据返回N
			return 'N';
		}
		char[] chs = nonCheckCodeCardId.trim().toCharArray();
		int luhmSum = 0;
		for (int i = chs.length - 1, j = 0; i >= 0; i--, j++) {
			int k = chs[i] - '0';
			if (j % 2 == 0) {
				k *= 2;
				k = k / 10 + k % 10;
			}
			luhmSum += k;
		}
		return (luhmSum % 10 == 0) ? '0' : (char) ((10 - luhmSum % 10) + '0');
	}
}
