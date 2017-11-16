package com.mingsokj.fitapp.alipay;

import org.json.JSONObject;

import com.alipay.api.AlipayClient;
import com.alipay.api.DefaultAlipayClient;
import com.alipay.api.request.AlipayTradeQueryRequest;
import com.alipay.api.response.AlipayTradeQueryResponse;

public class QuerOrder {
	public void queryOrder(String out_trade_no, String partner, String privareKey) throws Exception {
		AlipayClient alipayClient = new DefaultAlipayClient("https://openapi.alipay.com/gateway.do", partner,
				privareKey, "json", "GBK",
				"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDI6d306Q8fIfCOaTXyiUeJHkrIvYISRcc73s3vF1ZT7XN8RNPwJxo8pWaJMmvyTn9N4HQ632qJBVHf8sxHi/fEsraprwCtzvzQETrNRwVxLO5jVmRGi60j8Ue1efIlzPXV9je9mkjzOmdssymZkh2QhUrCmZYI/FCEa3/cNMW0QIDAQAB");
		AlipayTradeQueryRequest request = new AlipayTradeQueryRequest();
		JSONObject query_pars = new JSONObject();
		query_pars.put("out_trade_no", out_trade_no);
		request.setBizContent(query_pars.toString());
		AlipayTradeQueryResponse response = alipayClient.execute(request);
		String trade_status = response.getTradeStatus();
		if ("TRADE_SUCCESS".equals(trade_status)) {
			// 成功
		} else if ("WAIT_BUYER_PAY".equals(trade_status)) {
			throw new Exception("等待买家付款");
		} else if ("TRADE_CLOSED".equals(trade_status)) {
			throw new Exception("未付款交易超时关闭，或支付完成后全额退款");
		} else if ("TRADE_FINISHED".equals(trade_status)) {
			throw new Exception("交易结束，不可退款");
		} else {
			throw new Exception("支付宝，未付款");
		}
	}
}
