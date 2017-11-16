package com.mingsokj.fitapp.alipay;

import org.json.JSONObject;

import com.alipay.api.AlipayClient;
import com.alipay.api.DefaultAlipayClient;
import com.alipay.api.request.AlipayTradePrecreateRequest;
import com.alipay.api.response.AlipayTradePrecreateResponse;

public class QRPay {

	public String createQR(String out_trade_no, String subject, String amt, String AppId, String privareKey,String seller_id) throws Exception {
		AlipayClient alipayClient = new DefaultAlipayClient("https://openapi.alipay.com/gateway.do", AppId, privareKey, "json", "GBK", "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDI6d306Q8fIfCOaTXyiUeJHkrIvYISRcc73s3vF1ZT7XN8RNPwJxo8pWaJMmvyTn9N4HQ632qJBVHf8sxHi/fEsraprwCtzvzQETrNRwVxLO5jVmRGi60j8Ue1efIlzPXV9je9mkjzOmdssymZkh2QhUrCmZYI/FCEa3/cNMW0QIDAQAB");
		AlipayTradePrecreateRequest request = new AlipayTradePrecreateRequest();
		JSONObject alip_pars = new JSONObject();
		alip_pars.put("out_trade_no", out_trade_no);
		alip_pars.put("seller_id", seller_id);
		alip_pars.put("total_amount", amt);
		alip_pars.put("subject", subject + ",订单号[" + out_trade_no + "]");
		alip_pars.put("body", subject + ",订单号[" + out_trade_no + "]");
		alip_pars.put("timeout_express", "90m");

		request.setBizContent(alip_pars.toString());
		AlipayTradePrecreateResponse response = alipayClient.execute(request);

		if (response.isSuccess()) {
			return response.getQrCode();
		} else {
			throw new Exception(response.getMsg());
		}
	}
}
