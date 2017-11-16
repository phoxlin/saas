package com.mingsokj.fitapp.relation;

public interface Intimacy {

	public void increase(String empId, String memId, String memGym, int score);

	public void reduce(String empId, String memId, String memGym, int score);
}
