package com.mingsokj.fitapp.ws.bg;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.m.FitUser;
import com.mingsokj.fitapp.utils.PinYin2Letter;

/**
 * 商品类
 * 
 * @author hu
 *
 */
public class GoodsAction extends BasicAction {
	/**
	 * 前台商品销售查询
	 * 
	 * @throws Exception
	 */
	@Route(value = "fit-ws-cashier-searchGoods", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void fit_ws_cashier_searchGoods() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		if (user == null) {
			request.getRequestDispatcher("/").forward(request, response);
		}
		String cust_name = user.getCust_name();
		String gym = user.getViewGym();

		String type_id = request.getParameter("id");
		String num = request.getParameter("num");

		String condition = request.getParameter("condition");
		/*
		 * sell_repertory_id:all goods_barcode: goods_letter:
		 */

		int page = 1;
		int pageSize = 8;
		if (num != null && !"".equals(num)) {
			try {
				page = Integer.parseInt(num);
			} catch (Exception e) {
			}
		}

		Entity en = new EntityImpl(this);
		// 查询分类
		int s = en.executeQuery("select * from f_goods_type where cust_name = ? and gym = ? and state='001' order by sort desc", new Object[] { cust_name, gym });
		if (s > 0) {
			Map<String, Object> all = new HashMap<>();
			all.put("id", "all");
			all.put("type_name", "全部");
			List<Map<String, Object>> list = new ArrayList<>();
			list.add(all);
			list.addAll(en.getValues());
			this.obj.put("goodsType", list);
		}
		// 查询有无子分类
		/*
		 * Boolean hasSon = false; s = en.executeQuery(
		 * "select id from f_goods_type where pid = ?",new Object[]{type_id});
		 * List<String> types = new ArrayList<>(); if(s > 0){ for(int
		 * i=0;i<s;i++){ types.add(en.getStringValue("id",i)); }
		 * types.add(type_id); hasSon = true; }
		 */
		// 查询商品
		StringBuilder sql = new StringBuilder();
		sql.append("select b.goods_name,b.type,b.pic_url,b.labels,b.first_letter,a.* from f_good_version a left join f_goods b on a.goods_id = b.id where a.cust_name = ? and a.gym = ? and  b.state='sale'");
		List<Object> params = new ArrayList<>();
		params.add(cust_name);
		params.add(gym);
		if ("all".equals(type_id)) {
			// 查全部
		} else {
			// 按类型查询

			/*
			 * if(hasSon){ sql.append(" and b.type in ("
			 * +Utils.getListString("?", types.size())+")");
			 * params.addAll(types); }else{
			 */
			sql.append(" and b.type = ?");
			params.add(type_id);
			/* } */
		}
		// 附带条件
		if (condition != null && !"".equals(condition)) {
			if (condition.matches("[a-zA-Z]+")) {
				// 首字母搜索 无法区分
			} else {
				// 商品名称或条形码
			}
			sql.append(" and (b.first_letter like ?");
			params.add("%" + condition.toUpperCase() + "%");
			sql.append(" or b.goods_name like ? or a.bar_code like ?)");
			params.add("%" + condition + "%");
			params.add("%" + condition + "%");
		}
		int size = en.executeQuery(sql.toString(), params.toArray());
		if (size > 0) {
			this.obj.put("total_size", size);
			sql.append(" limit ?,?");
			params.add((page - 1) * pageSize);
			params.add(pageSize);

			s = en.executeQuery(sql.toString(), params.toArray());
			if (s > 0) {
				this.obj.put("goods", en.getValues());
			}
		}
	}

	/**
	 * 商品及规格 保存
	 * 
	 * @throws Exception
	 */
	@Route(value = "fit-goods-save", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void fit_goods_save() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		if (user == null) {
			request.getRequestDispatcher("/").forward(request, response);
		}
		String e = request.getParameter("e");
		Entity f_goods = this.getEntityFromPage(e);
		f_goods.setValue("goods_price", Utils.toPriceLong(f_goods.getStringValue("goods_price")));
		f_goods.setValue("goods_bprice", Utils.toPriceLong(f_goods.getStringValue("goods_bprice")));
		f_goods.setValue("emp_price", Utils.toPriceLong(f_goods.getStringValue("emp_price")));
		f_goods.setValue("first_letter", PinYin2Letter.cn2py(f_goods.getStringValue("goods_name")));
		String goods_id = f_goods.create();

		String[] version = request.getParameterValues("f_good_version__version");
		if (version != null) {
			for (int i = 0; i < version.length; i++) {
				Entity en = this.getEntityFromPage("f_good_version", i);
				en.setValue("goods_id", goods_id);
				en.setValue("sales_num", 0);
				en.setValue("goods_price", Utils.toPriceLong(en.getStringValue("goods_price")));
				en.setValue("goods_bprice", Utils.toPriceLong(en.getStringValue("goods_bprice")));
				en.setValue("emp_price", Utils.toPriceLong(en.getStringValue("emp_price")));
				en.create();
			}
		}
	}

	/**
	 * 商品及规格 修改
	 * 
	 * @throws Exception
	 */
	@Route(value = "fit-goods-edit", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void fit_goods_edit() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		if (user == null) {
			request.getRequestDispatcher("/").forward(request, response);
		}
		String cust_name = user.getCust_name();
		String gym = user.getViewGym();
		String e = request.getParameter("e");
		Entity f_goods = this.getEntityFromPage(e);
		String goods_id = request.getParameter("f_goods__id");
		f_goods.setValue("goods_price", Utils.toPriceLong(f_goods.getStringValue("goods_price")));
		f_goods.setValue("goods_bprice", Utils.toPriceLong(f_goods.getStringValue("goods_bprice")));
		f_goods.setValue("emp_price", Utils.toPriceLong(f_goods.getStringValue("emp_price")));
		f_goods.setValue("first_letter", PinYin2Letter.cn2py(f_goods.getStringValue("goods_name")));
		f_goods.update();
		// 查询已有规格
		Entity has_good_versions = new EntityImpl("f_good_version", this);
		int s = has_good_versions.executeQuery("select * from f_good_version where cust_name = ? and gym = ? and goods_id = ?", new Object[] { cust_name, gym, goods_id });

		String[] version = request.getParameterValues("f_good_version__version");
		if (version != null) {
			for (int i = 0; i < version.length; i++) {
				Entity en = this.getEntityFromPage("f_good_version", i);
				String version_id = en.getStringValue("id");
				if (version_id == null || "".equals(version_id)) {
					en.setValue("goods_id", f_goods.getStringValue("id"));
					en.setValue("sales_num", 0);
					en.setValue("goods_price", Utils.toPriceLong(en.getStringValue("goods_price")));
					en.setValue("goods_bprice", Utils.toPriceLong(en.getStringValue("goods_bprice")));
					en.setValue("emp_price", Utils.toPriceLong(en.getStringValue("emp_price")));
					en.create();
				} else {
					long goods_price = Utils.toPriceLong(en.getStringValue("goods_price"));
					long goods_bprice = Utils.toPriceLong(en.getStringValue("goods_bprice"));
					long emp_price = Utils.toPriceLong(en.getStringValue("emp_price"));
					en.setValue("goods_price", goods_price);
					en.setValue("goods_bprice", goods_bprice);
					en.setValue("emp_price", emp_price);
					// en.setValue("id", version_id);
					en.update();
					if (s > 0) {
						// 检查价格是否有变动
						for (int x = 0; x < s; x++) {
							String version_id_bd = has_good_versions.getStringValue("id", x);
							if (version_id.equals(version_id_bd)) {
								Long bprice = has_good_versions.getLongValue("goods_bprice", x);
								Long gprice = has_good_versions.getLongValue("goods_price", x);
								Long eprice = has_good_versions.getLongValue("emp_price", x);
								if (bprice.longValue() != goods_bprice || gprice.longValue() != goods_price || eprice.longValue() != emp_price) {
									// 有价格变动
									Entity goods_price_change = new EntityImpl("f_goods_price_change", this);
									goods_price_change.setValue("cust_name", cust_name);
									goods_price_change.setValue("gym", gym);
									goods_price_change.setValue("goods_id", goods_id);
									goods_price_change.setValue("version_id", version_id);

									goods_price_change.setValue("before_bprice", bprice);
									goods_price_change.setValue("after_bprice", goods_bprice);
									goods_price_change.setValue("before_price", gprice);
									goods_price_change.setValue("after_price", goods_price);
									goods_price_change.setValue("before_emp_price", eprice);
									goods_price_change.setValue("after_emp_price", emp_price);

									goods_price_change.setValue("op_time", new Date());
									goods_price_change.setValue("op_id", user.getId());
									goods_price_change.create();
								}
							}
						}
					}
				}
			}
		}
	}

	/**
	 * 商品规格删除
	 * 
	 * @throws Exception
	 */
	@Route(value = "fit-goods-version-del", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void fit_goods_version_del() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		if (user == null) {
			request.getRequestDispatcher("/").forward(request, response);
		}

		String version_id = request.getParameter("version_id");

		if (version_id != null && !"".equals(version_id)) {
			new EntityImpl(this).executeUpdate("delete from f_good_version where id = ?", new String[] { version_id });
		}
	}

	/**
	 * 出入库
	 * 
	 * @throws Exception
	 */
	@Route(value = "fit-good_version-rec-save", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void fit_good_version_rec_save() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		if (user == null) {
			request.getRequestDispatcher("/").forward(request, response);
		}
		String cust_name = user.getCust_name();
		String gym = user.getViewGym();

		String[] vs = this.getParameterValues("f_store_rec__goods_version_id");
		String rec_no = this.getParameter("f_store_rec__rec_no");
		String remark = this.getParameter("f_store_rec__remark");

		Entity goods = new EntityImpl(this);
		if (vs != null && vs.length > 0) {
			for (int i = 0; i < vs.length; i++) {
				Entity rec = this.getEntityFromPage("f_store_rec", i);
				String goods_version_id = rec.getStringValue("goods_version_id");
				int s = goods.executeQuery("select num,goods_id,store_id from f_good_version where id = ?", new Object[] { goods_version_id });
				if (s > 0) {

					Integer version_num = goods.getIntegerValue("num");
					String version_store_id = goods.getStringValue("store_id");
					String goods_id = goods.getStringValue("goods_id");

					Integer add = rec.getIntegerValue("nums_in");
					Integer reduce = rec.getIntegerValue("nums_out");
					if (add == null) {
						add = 0;
					}
					if (reduce == null) {
						reduce = 0;
					}
					if (add == 0 && reduce == 0) {
						continue;
					}
					if (version_num + add - reduce < 0) {
						throw new Exception("出库后商品规格的总库存不能小于0，请检查后修正");
					}
					// 更新商品数量
					goods.executeUpdate("update f_good_version set num = num + ? - ? where id = ?", new Object[] { add, reduce, goods_version_id });
					// 生成出入库记录
					rec.setTablename("f_store_rec_" + gym);
					rec.setValue("cust_name", cust_name);
					rec.setValue("gym", gym);
					rec.setValue("store_id", version_store_id);
					rec.setValue("goods_version_id", goods_version_id);
					rec.setValue("rec_no", rec_no);
					if (reduce == 0) {
						rec.setValue("type", "001");
					} else if (add == 0) {
						rec.setValue("type", "002");
					} else {
						rec.setValue("type", "005");
					}
					rec.setValue("rec_no", rec_no);
					rec.setValue("goods_id", goods_id);
					rec.setValue("total_nums", version_num);
					rec.setValue("nums_in", add);
					rec.setValue("nums_out", reduce);
					rec.setValue("after_total_nums", version_num + add - reduce);
					rec.setValue("emp_id", user.getId());
					rec.setValue("op_id", user.getId());
					rec.setValue("op_time", new Date());
					rec.setValue("remark", remark);
					rec.setValue("confirm", "N");
					rec.create();
				}
			}
		}
	}

	/**
	 * 商品规格盘点
	 * 
	 * @throws Exception
	 */
	@Route(value = "fit-good_version-rec-check", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void fit_good_version_rec_check() throws Exception {

		FitUser user = (FitUser) this.getSessionUser();
		if (user == null) {
			request.getRequestDispatcher("/").forward(request, response);
		}
		String cust_name = user.getCust_name();
		String gym = user.getViewGym();

		String goods_id = request.getParameter("goods_id");

		if (goods_id == null || "".equals(goods_id)) {
			throw new Exception("非法操作");
		}

		String[] vs = request.getParameterValues("f_store_rec__goods_version_id");
		Entity version = new EntityImpl("f_good_version", this);

		if (vs != null && vs.length > 0) {
			for (int i = 0; i < vs.length; i++) {
				Entity en = this.getEntityFromPage("f_store_rec", i);
				String goods_version_id = en.getStringValue("goods_version_id");
				Integer total_nums = en.getIntegerValue("total_nums");
				Integer after_total_nums = en.getIntegerValue("after_total_nums");
				String type = en.getStringValue("type");

				if (after_total_nums == null || after_total_nums == -1) {
					continue;
				}
				int s = version.executeQuery("select * from f_good_version where id = ?", new Object[] { goods_version_id });
				if (s == 0) {
					throw new Exception("规格已不存在");
				}
				Integer num = version.getIntegerValue("num");
				String store_id = version.getStringValue("store_id");
				String version_id = version.getStringValue("id");
				if (total_nums.intValue() != num.intValue()) {
					throw new Exception("商品数量在刚刚被其他操作改动过了,请重新盘点");
				} else if (num == after_total_nums) {
					throw new Exception("商品数量没有变化,无需盘点");
				}

				en.setTablename("f_store_rec_" + gym);
				en.setValue("cust_name", cust_name);
				en.setValue("store_id", store_id);
				en.setValue("gym", gym);
				en.setValue("goods_id", goods_id);
				int inOrout = after_total_nums - num;
				if ("003".equals(type) && inOrout > 0) {
					throw new Exception("报损后的数量不能比之前还多哦");
				}
				if (inOrout > 0) {
					en.setValue("nums_in", inOrout);
					en.setValue("nums_out", 0);
				} else {
					en.setValue("nums_in", 0);
					en.setValue("nums_out", Math.abs(inOrout));
				}
				en.setValue("emp_id", user.getId());
				en.setValue("op_id", user.getId());
				en.setValue("op_time", new Date());
				en.setValue("confirm", "002");// 未确认
				en.create();
				// 更新商品规格数量
				version.setValue("id", version_id);
				version.setValue("num", after_total_nums);
				version.update();
			}
		}

	}

	/**
	 * 出入库详情
	 * 
	 * @throws Exception
	 */
	@Route(value = "fit-bg-store-rec-detail", conn = true, m = HttpMethod.GET, type = ContentType.Forward)
	public void fit_bg_store_rec_detail() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();

		String id = this.getParameter("id");
		Entity en = new EntityImpl("f_store_rec", this);
		String sql = "select * from f_store_rec_" + gym + " where id=?";
		int size = en.executeQuery(sql, new Object[] { id });
		if (size > 0) {
			request.setAttribute("f_store_rec", en);
			this.obj.put("nextpage", "pages/f_store_rec/f_store_rec_edit.jsp");
		}

	}

	/**
	 * 出入库记录编辑
	 * 
	 * @throws Exception
	 */
	@Route(value = "fit-bg-store-rec-edit", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void fit_bg_store_rec_edit() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		String gym = user.getViewGym();

		Entity f_store_rec = this.getEntityFromPage("f_store_rec");

		String goods_version_id = f_store_rec.getStringValue("goods_version_id");
		String goods_id = f_store_rec.getStringValue("goods_id");
		Entity en = new EntityImpl(this);
		int s = en.executeQuery("select * from f_good_version where id = ? and goods_id = ?", new Object[] { goods_version_id, goods_id });
		if (s == 0) {
			throw new Exception("商品与规格不匹配哦,请确认在提交");
		}

		f_store_rec.setTablename("f_store_rec_" + gym);
		f_store_rec.update();

	}

	/**
	 * 通过商品ID查询规格
	 * 
	 * @throws Exception
	 */
	@Route(value = "fit-bg-good-version-query-by-goodsId", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void fit_bg_good_version_query_by_goodsId() throws Exception {
		String goods_id = request.getParameter("goods_id");
		Entity en = new EntityImpl("f_good_version", this);
		if (goods_id == null || "".equals(goods_id)) {
			throw new Exception("查询规格失败,没有告知程序要查哪种商品");
		}
		en.setValue("goods_id", goods_id);
		int s = en.search();
		if (s > 0) {
			this.obj.put("list", en.getValues());
		}
	}

	/**
	 * 上下架
	 * 
	 * @throws Exception
	 */
	@Route(value = "fit-ws-bg-goods-put-upOrDown", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void fit_ws_bg_goods_put_upOrDown() throws Exception {
		String goods_id = request.getParameter("goods_id");
		String state = request.getParameter("state");
		Entity en = new EntityImpl(this);
		en.executeUpdate("update f_goods set state = ? where id = ?", new Object[] { state, goods_id });
	}

	/**
	 * 删除出入库记录
	 * 
	 * @throws Exception
	 */
	@Route(value = "fit-bg-store-rec-del", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void fit_bg_store_rec_del() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		if (user == null) {
			request.getRequestDispatcher("/").forward(request, response);
		}
		String gym = user.getViewGym();

		String rec_id = request.getParameter("id");

		if (rec_id != null && !"".equals(rec_id)) {
			new EntityImpl(this).executeUpdate("delete from f_store_rec_" + gym + " where id = ?", new String[] { rec_id });
		}
	}

	/**
	 * 保存销售
	 * 
	 * @throws Exception
	 */
	@Route(value = "fit-ws-goods-saveSell", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void fit_ws_goods_saveSell() throws Exception {
		FitUser user = (FitUser) this.getSessionUser();
		if (user == null) {
			request.getRequestDispatcher("/").forward(request, response);
		}

		String goods_str = request.getParameter("goods");
		String isemp = request.getParameter("isemp");
		JSONObject goods = null;
		try {
			goods = new JSONObject(goods_str);
		} catch (Exception e) {
			throw new Exception("非法操作");
		}
		Entity en = new EntityImpl("f_good_version", this);

		Float total_price = 0f;
		for (String id : goods.keySet()) {
			JSONObject good = goods.getJSONObject(id);
			Integer sale_num = good.getInt("num");
			if (sale_num <= 0) {
				throw new Exception("非法操作");
			}
			int s = en.executeQuery("select * from f_good_version where id = ?", new Object[] { id });
			if (s == 0) {
				throw new Exception("商品规格" + good.getString("name") + "不存在了");
			}
			Integer num = en.getIntegerValue("num");
			if (num - good.getInt("num") < 0) {
				throw new Exception("商品规格" + good.getString("name") + "的库存数量不足,目前剩余" + good.getInt("num"));
			}
			float goods_price = Float.parseFloat(Utils.toPriceFromLongStr(en.getStringValue("goods_price")));
			float emp_price = Float.parseFloat(Utils.toPriceFromLongStr(en.getStringValue("emp_price")));
			if ("true".equals(isemp)) {
				total_price += emp_price * sale_num;
			} else {
				total_price += goods_price * sale_num;
			}
		}
		this.obj.put("total_price", total_price);
		this.obj.put("goods", goods);
	}

}
