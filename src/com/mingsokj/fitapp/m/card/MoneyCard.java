package com.mingsokj.fitapp.m.card;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONObject;

import com.jinhua.User;
import com.jinhua.server.Action;

/**
 * 储值卡
 * 
 * @author terry
 *
 */
public class MoneyCard extends ICard {

	@Override
	public void checkOut(Action act, JSONObject obj) throws Exception {

	}

	@Override
	public void autoCheckin(Action act, User emp, HttpServletRequest request, JSONObject obj) throws Exception {
		// TODO Auto-generated method stub

	}

}