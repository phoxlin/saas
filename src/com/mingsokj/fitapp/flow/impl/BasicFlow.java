package com.mingsokj.fitapp.flow.impl;

import com.mingsokj.fitapp.flow.Flow;

public class BasicFlow extends Flow {

	public BasicFlow() {
		super();

	}

	// 保存前的数据检查，也可以先不做.
	@Override
	public void beforeData() throws Exception {

	}

	@Override
	public void saveData() throws Exception {

	}

	@Override
	public String getSmsWords() throws Exception {
		return null;
	}

	@Override
	public String getSmsPhoneNumber() throws Exception {
		return null;
	}

}
