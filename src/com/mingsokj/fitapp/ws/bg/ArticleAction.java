package com.mingsokj.fitapp.ws.bg;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.json.JSONArray;
import org.json.JSONObject;

import com.jinhua.server.BasicAction;
import com.jinhua.server.Route;
import com.jinhua.server.db.Entity;
import com.jinhua.server.db.impl.EntityImpl;
import com.jinhua.server.m.ContentType;
import com.jinhua.server.m.HttpMethod;
import com.jinhua.server.tools.Utils;
import com.mingsokj.fitapp.utils.DateUtils;

public class ArticleAction extends BasicAction {

	@Route(value = "fit-app-article-init", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void query_articles() throws Exception {
		String cust_name = request.getParameter("cust_name");
		String gym = request.getParameter("gym");

		// 查询类型
		Entity art = new EntityImpl("f_generic_type", this);
		int s = art.executeQuery("select * from f_generic_type where cust_name =? and gym = ? and table_name = ?", new Object[] { cust_name, gym, "f_article" });
		if (s > 0) {
			Entity en = new EntityImpl("f_article", this);
			String[] types = new String[s + 2];
			types[0] = cust_name;
			types[1] = gym;
			for (int i = 0; i < s; i++) {
				types[i + 2] = art.getStringValue("id", i);
			}
			// 查询文章
			int ss = en.executeQuery("select * from f_article where cust_name = ? and gym = ? and art_type in (" + Utils.getListString("?", s) + ")", types);
			JSONArray arr = new JSONArray();
			if (ss > 0) {
				// 有文章
				for (int i = 0; i < s; i++) {
					String type_id = art.getStringValue("id", i);
					String type_name = art.getStringValue("type", i);
					JSONObject obj = new JSONObject();
					obj.put("type_id", type_id);
					obj.put("type_name", type_name);
					JSONArray arts = new JSONArray();
					obj.put("arts", arts);
					int num = 0;
					for (int j = 0; j < ss; j++) {
						String art_type = en.getStringValue("art_type", j);
						if (type_id.equals(art_type)) {
							num++;
							arts.put(en.getValues().get(j));
							if (num == 3) {// 只需要3条
								break;
							}
						}
					}
					if (arts.length() != 0) {
						arr.put(obj);
					}
				}
			}
			this.obj.put("list", arr);
		}
	}

	@Route(value = "fit-app-article-init2", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void query_articles2() throws Exception {
		String cust_name = request.getParameter("cust_name");
		String gym = request.getParameter("gym");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		// 查询类型
		Entity types = new EntityImpl("f_generic_type", this);
		int s = types.executeQuery("select * from f_generic_type where cust_name =? and gym = ? and table_name = ? and state ='001' union all select * from f_generic_type where (other = 's2' or other = 's3') and table_name = ?  and state ='001' order by sort desc", new Object[] { cust_name, gym, "f_article","f_article" });
		if (s == 0) {
			// 初始化3个专题
			initFitArticles(cust_name, gym);
		}
		
		Entity en = new EntityImpl("f_article", this);
		JSONArray arr = new JSONArray();
		for (int i = 0; i < s; i++) {
			String type = types.getStringValue("id", i);
			String type_name = types.getStringValue("type", i);
			String other = types.getStringValue("other", i);
			String _cust_name = types.getStringValue("cust_name",i);
			String _gym = types.getStringValue("gym",i);
			if (other == null || "".equals(other)) {
				// 没有设置显示样式
				continue;
			}
			JSONObject obj = new JSONObject();
			obj.put("type_id", type);
			obj.put("style", other);
			obj.put("type_name", type_name);
			String sql = "select * from f_article where cust_name = ? and gym = ? and art_type = ? and state='Y' and release_time < ? order by release_time desc";
			int ss = 0;
			if ("s1".equals(other)) {
				ss = en.executeQuery(sql, new Object[] { _cust_name, _gym, type, sdf.format(new Date()) });
			} else {
				ss = en.executeQuery(sql, new Object[] { _cust_name, _gym, type, sdf.format(new Date()) }, 1, 3);
			}
			if (ss > 0) {
				for (int j = 0; j < ss; j++) {
					String release_time = en.getValues().get(j).get("release_time").toString();
					release_time = DateUtils.toStringDate2(release_time);
					en.getValues().get(j).put("release_time", release_time);
				}
				obj.put("arts", en.getValues());
				arr.put(obj);
			}
		}
		this.obj.put("list", arr);
		
	}

	@Route(value = "fit-app-article-init3", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void query_articles3() throws Exception {
		String cust_name = request.getParameter("cust_name");
		String gym = request.getParameter("gym");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		// 查询类型
		Entity types = new EntityImpl("f_generic_type", this);
		int s = types.executeQuery("select * from f_generic_type where cust_name =? and gym = ? and table_name = ? order by sort desc", new Object[] { cust_name, gym, "f_article" });
		if (s == 0) {
			// 初始化3个专题
			initFitArticles(cust_name, gym);
		}
		Entity en = new EntityImpl("f_article", this);
		JSONArray arr = new JSONArray();
		for (int i = 0; i < s; i++) {
			String type = types.getStringValue("id", i);
			String type_name = types.getStringValue("type", i);
			String other = types.getStringValue("other", i);
			if (other == null || "".equals(other)) {
				// 没有设置显示样式
				continue;
			}
			JSONObject obj = new JSONObject();
			obj.put("type_id", type);
			obj.put("style", other);
			obj.put("type_name", type_name);
			String sql = "select * from f_article where cust_name = ? and gym = ? and art_type = ? and state='Y' and release_time < ? order by release_time desc";
			int ss = en.executeQuery(sql, new Object[] { cust_name, gym, type, sdf.format(new Date()) }, 1, 3);
			if (ss > 0) {
				for (int j = 0; j < ss; j++) {
					String release_time = en.getValues().get(j).get("release_time").toString();
					release_time = DateUtils.toStringDate2(release_time);
					en.getValues().get(j).put("release_time", release_time);
				}
				obj.put("arts", en.getValues());
				arr.put(obj);
			}
		}
		this.obj.put("list", arr);
	}

	@Route(value = "fit-app-article-more", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void fit_app_article_more() throws Exception {
		String cust_name = request.getParameter("cust_name");
		String gym = request.getParameter("gym");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String type = request.getParameter("type");
		String start_str = request.getParameter("start");
		int start = 0;
		try {
			start = Integer.parseInt(start_str);
		} catch (Exception e) {
		}
		Entity t = new EntityImpl("f_generic_type",this);
		int s = t.executeQuery("select * from f_generic_type where id = ?",new Object[]{type});
		if(s <=0){
			throw new Exception("文章不存在了,请刷新一下");
		}
		String _cust_name = t.getStringValue("cust_name");
		String _gym = t.getStringValue("gym");
		// 查询3条
		Entity en = new EntityImpl("f_article", this);
		int ss = en.executeQuery("select * from f_article where cust_name = ? and gym = ? and art_type = ? and state='Y' and release_time < ? order by release_time desc", new Object[] { _cust_name, _gym, type, sdf.format(new Date()) }, start + 1, start + 3);
		if (ss > 0) {
			for (int j = 0; j < ss; j++) {
				String release_time = en.getValues().get(j).get("release_time").toString();
				release_time = DateUtils.toStringDate2(release_time);
				en.getValues().get(j).put("release_time", release_time);
			}
			this.obj.put("list", en.getValues());
		}
	}

	@Route(value = "fit-app-article-detail", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void fit_app_article_detail() throws Exception {
		// String cust_name = request.getParameter("cust_name");
		// String gym = request.getParameter("gym");
		// SimpleDateFormat sdf =new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		String art_id = request.getParameter("art_id");
		if (art_id != null && !"".equals(art_id)) {
			Entity en = new EntityImpl("f_article", this);
			en.setValue("id", art_id);
			int s = en.search();
			if (s > 0) {
				this.obj.put("art", en.getValues().get(0));
			}
		}
	}

	@Route(value = "fit-app-article-list", conn = true, m = HttpMethod.POST, type = ContentType.JSON)
	public void fit_app_article_list() throws Exception {
		String cust_name = request.getParameter("cust_name");
		String gym = request.getParameter("gym");
		String start = request.getParameter("start");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		int s = 0;
		try {
			s = Integer.parseInt(start);
		} catch (Exception e) {
		}
		// int pageSize = 10;
		String sql = "select id,title,summary,pic_url,num,release_time from f_article where cust_name = ? and gym = ?  and state='Y' and release_time < ? order by release_time desc";
		Entity en = new EntityImpl(this);
		int x = en.executeQuery(sql, new Object[] { cust_name, gym, sdf.format(new Date()) }, s + 1, s + 10);
		if (x > 0) {
			this.obj.put("list", en.getValues());
		}
	}

	/**
	 * 初始化健身专题
	 * 
	 * @throws Exception
	 */
	public void initFitArticles(String cust_name, String gym) throws Exception {
		// 类型
		Entity en = new EntityImpl("f_generic_type", this);
		en.setValue("cust_name", cust_name);
		en.setValue("gym", gym);
		en.setValue("type", "健身专题");
		en.setValue("table_name", "f_article");
		en.setValue("sort", 99999);
		en.setValue("state", "001");
		en.setValue("other", "s1");
		String type_id = en.create();
		String newer = "<div class=\"content-listblock-text\"> <p> <br /> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"> 首语：不少健身爱好初学者，在刚刚涉足这个领域时，会遇到不少关于健身的实操问题，现在为大家罗列一些健身的关键原则，希望能帮助到您！ </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"><br /> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"> <b> 第一：坚持基本训练</b> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"><br /> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"> 用最简单直接的大重量自由负重来训练大块头，千万不要忽略基本动作，如硬拉等复合动作对肌肉的生长是最好的，在每一次训练应该把最有效的复合动作放在最前面，做完大重量的复合动作之后，再用孤立动作或器械来完善肌肉，使其达到深度力歇 </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"><br /> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"> <b> 第二：蛋白质</b> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"><br /> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"> 不要限制蛋白质的摄入量，蛋白摄入量越多，肌肉就长得越快，一般健身标准蛋白摄入量是平均每磅体重最少要一克蛋白质，为了更好促进肌肉的生长，应该把蛋白质的日常摄入量增加到每磅体重1.5---2克 </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"><br /> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"> <b> 第三：碳水化合物</b> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"><br /> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"> 碳水化合物是增加肌肉体积的主要食物，但过多摄入碳水化合物会增加身体的脂肪含量，所以要注意碳水化合物的摄入量，一般健身标准的摄入量是每磅体重至少需2克碳水化合物以上，所以有必要把摄入量增加到每磅体重摄入2。5---3克的碳水化合物，但不可以再多，不然只会把消化不了的食物变为脂肪，最好的安排就是在训练日把碳水保持在3克左右，特别是训练强度比较大的时候，这个量是必须的，如果是在训练小肌群或者休息日的时候，可以把碳水稍微减少，但也不可以少于2，5克，低过这个摄入量的话很难发挥肌肉的全部生长潜力。 </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"><br /> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"> <b> 第四：必修课</b> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"><br /> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"> 应该为每一个肌肉部位准备一项杠铃练习，如果缺少大负重的杠铃训练的话，肌肉体积和力量势必下降，只有使用大负荷训练才能使肌肉不断的生长和进步。 </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"><br /> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"> <b> 第五：围度</b> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"><br /> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"> 无论如果都要把肌肉体积和发达程度放在第一位，在还没练就超级发达的肌肉之前，没有必要太过讲究肌肉的线条和匀称，因为这样做会减慢肌肉的发展，如果肌肉已经有了理想的体积和围度之后，再来修复肌肉的线条和匀称程度，肌肉大小才是重点。 </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"><br /> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"> <b> 第六：标准的姿势保持正确的训练姿势</b> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"><br /> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"> 无论是力量举或者是健身训练，保持最标准的动作才是最重要的，特别是在做力量举的时候，就算负荷再大，难度越高，也要保证高质量的训练动作，幅度要够大，但绝不能借力，把负荷都施加在锻炼的目标上，不然的话，只会提高受伤的危险性。 </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"><br /> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"> <b> 第七：在进行健身训练的时候，负荷并不是最重要</b> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"><br /> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"> 健身训练与力量举不同，力量举只在乎用正确的姿势来推起更大的负重，而健身训练的真正意义在于肌肉的疲劳程度，负重虽然重要，但更重要的是在训练中感受肌肉的伸展和挤压，在每两个动作之间不应停顿过久，最多是两秒，否则只会给肌肉喘息的机会，然而达不到训练的目的。 </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"><br /> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"> <b> 第八：次数效果</b> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"><br /> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"> 需要了解各种次数产生训练效果，用不同的次数来进行训练就会产生不同的效果，1---5之间的锻炼次数主要是发展肌肉的整体力量，这种次数只适合大重量的自由负重训练，如卧推，深蹲，硬拉等等。虽然对肌肉力量的发展极好，但也有他的不足之处，就是如果使用这种训练手段对肌肉的体积并不明显，真正发展肌肉的标准次数是8---12和6---8之间，这两种锻炼次数对肌肉的发展是最好的，但对肌肉的力量没有1---5次之间的训练来得快，15次以上的训练次数主要是改善肌肉的线条，增加肌肉的分离度，但对肌肉体积和力量作用极小，对于初学者来说不应该采用这种训练法，因为初学者在刚进行健身训练的时候体积较小，应该把肌肉体积达到一定的程度之后再进行线条训练。 </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"><br /> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"> <b> 第九：组间休息</b> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"><br /> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"> 需要了解各种训练次数锻炼的组间休息时间，如果运用不当的话，训练效果必定大打折扣。1---5之间的大负重训练的休息时间不应过短，因为现在主要目的是推起更大的重量而不是对肌肉的刺激程度，所以不必当心在组间休息过长，只要能推起更大的重量就可以了，这就叫做力量举，虽然说可以休息得更久，但必须把休息时间控制在3分钟之内，如果休息得太久的话，会导致体温下降，这意味着大大增加受伤的危险性，健身训练的组间休息必须控制在1---1。5分之内，如果多于这个时间的话，肌肉就会得不到深度的刺激，因为我各人认为应该不断给训练区有强烈的刺激和肌肉的燃烧感，因为这个时候主要是发展肌肉的体积并且让他达到深度力歇，如果可以的话，还可以休息得更少，一般对于复合动作来说可以休息得更长，组间休息可以达到1。5分钟，因为复合动作的消耗非常大，所以恢复得更慢，所以可以比孤立动作休息得更多，但千万不要多于1。5分钟，而对于孤立动作来说主要是在最后使肌肉完全疲劳，所以不能让他休息得过久，但为了保持中等次数，所以每组有1分钟的休息时间就足够了。如果你采用每一组的次数都在15次以上的训练方案的话，应该把休息时间大大的减少，因为这时候主要是锻炼肌肉的耐力和线条，所有每组之间有半分钟的休息时间就已经足够了，不然就不能达到锻炼的目的。 </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"><br /> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"> <b> 第十：健身的主要饮食无论你使用多么有效的营养补剂，也不能代替日常膳食</b> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"><br /> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"> 我每天都吃大量的牛肉和鸡胸肉虽然补剂吃得也不少。我每天要吃上九次，其中光只吃补剂餐的只有两顿，而食物占七顿，有两顿食物餐各含有一杯蛋白粉和牛奶的混合饮料，补剂服用总计一天有四次，食物餐有共有七顿，总的来说，健身爱好者一天最少要吃六顿以上的健身食物，这已经是最低的要求我自己很清楚的知道，如果用补剂来代替日常膳食的话，那么我的肌肉会很快就失去质量和状态，甚至会削减掉肌肉的块头。 </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"><br /> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"> <b> 第十一：学会如何克服平台期</b> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"><br /> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"> (1)所谓的平台期就是指肌肉在训练一段时间后生长变得缓慢或者处于停滞状态，在这个时候必须要学会怎样让肌肉继续增长，一般出现平台期大多是因为长期使用同一个训练课程或训练动作，所以在训练一段时间后应该有规律的改变某块肌肉的训练动作和作顺序。 </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"><br /> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"> (2)改变一下训练次数也是一种很好的方法，不要让肌肉完全适应现在所用的训练次数，在常规训练一到两个月后使用一下平时很少使用的训练次数，这样可以使肌肉得到终极震撼，比如你在训练两个月后，采用这种方式，如果你平时练小腿提踵的时候使用每组25次左右的次数而现在你为了让他继续生长，你可以使用每组6---8次的高负荷低次数或者每一组都做上100次这会让你的小腿有一种前所未有的全新感觉，让它感到无比的陌生，促进他不停的生长。 </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"><br /> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"> (3)高强度的训练法则是克服平台期的最好办法，这种训练方法能把你的肌肉推向极限疲劳，疲劳的程度越深，肌肉就长得越快，这种高强度训练虽然对肌肉的生长非常有效，但不可以使用过多，否则只会使肌肉组织破碎，停止肌肉的生长，一个月左右使用一次这种高强度训练就已经足够了，但以上这些训练手段不适合训练时间在一年之内的健身初学者，初学者们只要有正确的饮食计划和训练计划就已经是足够了，一般是不会发生平台期等情况的。 </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"><br /> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"> <b> 第十二：训练过度</b> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"><br /> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"> 训练过度是许多健身运动员所最容易犯的错误，一旦肌肉的疲劳过度的话，他的力量将会被减弱肌肉生长将会停滞不前，身体的免疫力会大幅度的降低，为了避免这种情况的发生，必须要合理的安排训练和休息，肌肉是在健身房外面生长的，我在训练的时候不会可怜自己，我会让肌钎维不断的破损，而在健身房外面我会给他最好的爱护，我会供给它充足的营养和让他好好的休息对于我来说，一个星期之内对同一个部位训练两次以上的话，这个训练量实在是太多了，每个星期练一次相同部位是最好的，至少对于我来说是这样的，无论是训练大肌群或是小肌群，我不会在同一个星期内训练两次，你只要在健身房给他足够的刺激和强度，然后就让他慢慢的生长就行了。 </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"><br /> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"> <b> 第十三：伸展的重要性</b> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"><br /> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"> 这种伸展动作对于健身运动员来说是非常的重要，他可以大大减低训练时受伤的危险性，而且还有助于提高训练强度，有很多个原因使我非常的重视他 </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"><br /> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"> (1)最初被它吸引的原因是因为他可以有效的提高我的力量举能力，确实我在开始大量的伸展运动之后负重能力有所提高。 </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"> (2)最主要的是伸展运动可以有效的避免因柔韧性不够而受伤的事件，柔韧性在训练的时候是至关重要的特别是在训练肩部和背部训练的时候，如果柔韧性不够的话，很有可能会导致你做不到全程动作。 </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"> (3)它可以提高你的训练强度，而且可以减少肌肉在训练后累积的乳酸，让你在下一组做更多的次数在训练时，我会利用组间休息的时候在训练部位上做伸展运动，这可以让训练区更好的充满血液要知道，血液对肌肉的发展是很重要的，而伸展运动可以帮助你达到这一点。 </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"><br /> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"> <b> 第十四：刻苦训练</b> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"><br /> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"> 无论你拥有多么完美的训练计划和饮食计划，如果你不能长年累月的坚持下去的话，你将永远也不不可能有成功的一天，\"刻苦训练\"这四个字里面饱满了很多意义，并不是说你在训练时练得够多就能取得成功，无论是饮食，训练，和一些合理的安排，你必须做到半点不漏，要做到以上几点，你必定会牺牲很多时间和乐趣，比如说今天是训练日，你必须整天呆在家里按时吃健身饮食，你必须为今天的功课做好准备，你不能出去玩，不能吃对肌肉没帮助的食物，你为了要有更多的体力精神来应付高强度的训练，你必须要拒绝和朋友们出去玩耍的乐趣，而且还不能上过多的网，看太多的电视节目。 </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"><br /> </p> <p style=\"color:#555555;font-size:15px;text-align:justify;font-family:\" background-color:#ffffff;\"=\"\"> 不要小看以上几个方面，这些小细节将导致你无法在健身这项运动上全力以赴，如果做不到上面这几点的话，你将不能成为一个真正的职业选手。本论是本人所有哲学中最至高无上的一条健身原则，一直以来我为了遵守这项运动的原则，不知道牺牲了多少东西才能达到以上这些要求，而这些都是我自己在健身中领悟出来的，要健身就要全心全意的投入进去，否则就不可能达到你的最终目的。 </p> <p> <br /> </p> <p> <br /> </p> </div>";
		String yingyang = "<p> <span> <p style=\"font-size:16px;color:#333333;text-align:justify;font-family:arial;background-color:#FFFFFF;\"> 在健身领域有这么一句话，“三分练，七分吃”，这是健身达人们结合自身经验的总结，从科学的角度讲也是站得住脚的。在不受外力刺激的情况下，人的体型以及健康状况都是由吃什么、怎么吃决定的。而在健身期间，这一点显得更加重要。 </p> <div class=\"img-container\" style=\"font-family:arial;background-color:#FFFFFF;\"> <img class=\"large\" src=\"https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=303180549,4013872487&amp;fm=173&amp;s=2C04ED161DF67790C2ECD1FC0300C021&amp;w=640&amp;h=383&amp;img.JPEG\" style=\"width:537px;\" /> </div> <p style=\"font-size:16px;color:#333333;text-align:justify;font-family:arial;background-color:#FFFFFF;\"> 遗憾的是，不少健身者对吃并不重视，当健身对健身效果不满意时，他们首先是从训练方法上找原因，很少对自己的饮食习惯做怀疑。阿妹在这里郑重告诫大家：比起练，吃更重要，无论你是为了增肌还是减脂。阿妹建议，大家最好制定属于自己的饮食计划，把吃什么、怎么吃写的清清楚楚。 </p> <div class=\"img-container\" style=\"font-family:arial;background-color:#FFFFFF;\"> <img class=\"large\" src=\"https://ss1.baidu.com/6ONXsjip0QIZ8tyhnq/it/u=213506644,3492798903&amp;fm=173&amp;s=D0846EBE4A213680563B41610300B06B&amp;w=640&amp;h=334&amp;img.JPEG\" style=\"width:537px;\" /> </div> <p style=\"font-size:16px;color:#333333;text-align:justify;font-family:arial;background-color:#FFFFFF;\"> 说起健身餐，大家的第一反应可能是牛肉啊、鸡蛋啊、绿色蔬菜这些东西，这是狭隘的理解。其实健身餐包括很多种饮食，还包括进食的时间，这也是阿妹今天和大家探讨的主要问题。 </p> <div class=\"img-container\" style=\"font-family:arial;background-color:#FFFFFF;\"> <img class=\"large\" src=\"https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=3238059692,3130290837&amp;fm=173&amp;s=0CA3D5175E317E13870A54EF0300A02A&amp;w=640&amp;h=329&amp;img.JPEG\" style=\"width:537px;\" /> </div> <p style=\"font-size:16px;color:#333333;text-align:justify;font-family:arial;background-color:#FFFFFF;\"> 从营养含量来讲，健身餐应该涵盖碳水化合物、蛋白质、脂肪这三个部分。有人会说，这不白说呢，这不就是最常见的三类营养吗？这一点阿妹不否认，但阿妹要强调的是怎么搭配的问题，科学的搭配才能充分配合你的健身计划。此外，一些必要的微生物和矿物质也是要补充的。 </p> <p style=\"font-size:16px;color:#333333;text-align:justify;font-family:arial;background-color:#FFFFFF;\"> 营养的搭配 </p> <div class=\"img-container\" style=\"font-family:arial;background-color:#FFFFFF;\"> <img class=\"normal\" width=\"500px\" src=\"https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=3670336565,3236511808&amp;fm=173&amp;s=D5869EF70C53EAC6449618B80300C049&amp;w=500&amp;h=310&amp;img.JPEG\" /> </div> <p style=\"font-size:16px;color:#333333;text-align:justify;font-family:arial;background-color:#FFFFFF;\"> 针对不同的身体条件，对三大营养要素要求的比例也不尽相同，阿妹建议在5：4：1（碳水化合物：蛋白质：脂肪）这个比例下根据自身情况做适当的调整。这里要注意，即便你的目标是减脂，适量的脂肪还是可以摄入的，毕竟这是维持机体新陈代谢的必需，但要注意，不要摄入太多低品质脂肪。 </p> <p style=\"font-size:16px;color:#333333;text-align:justify;font-family:arial;background-color:#FFFFFF;\"> 蛋白质的摄入 </p> <div class=\"img-container\" style=\"font-family:arial;background-color:#FFFFFF;\"> <img class=\"large\" src=\"https://ss1.baidu.com/6ONXsjip0QIZ8tyhnq/it/u=2721461341,2207283800&amp;fm=173&amp;s=00BB7797003271881E349CF00300F031&amp;w=640&amp;h=389&amp;img.JPEG\" style=\"width:537px;\" /> </div> <p style=\"font-size:16px;color:#333333;text-align:justify;font-family:arial;background-color:#FFFFFF;\"> 健身的人都知道蛋白质的重要性，它给肌纤维的撕裂和重建提供了物质补给，不同的体重对蛋白质要求摄入量不同，以60KG的人为参考，理论上，每天摄入100g左右的的蛋白质就可以了。蛋白质来源主要有牛肉、鸡脯肉、鱼虾还有鸡蛋牛奶，这些食物的蛋白质含量都在20%上下。另外也可以专门食用优质蛋白粉。 </p> <p style=\"font-size:16px;color:#333333;text-align:justify;font-family:arial;background-color:#FFFFFF;\"> 碳水化合物的摄入 </p> <div class=\"img-container\" style=\"font-family:arial;background-color:#FFFFFF;\"> <img class=\"normal\" width=\"400px\" src=\"https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=3500360234,2101600408&amp;fm=173&amp;s=5FCE27D26AE14E84168E79740300C06A&amp;w=400&amp;h=247&amp;img.JPEG\" /> </div> <p style=\"font-size:16px;color:#333333;text-align:justify;font-family:arial;background-color:#FFFFFF;\"> 碳水化合物是身体能量的最主要来源，它的摄入途径有很多，大米、面条以及一些常见的水果蔬菜里面都有足量的碳水化合物。一般来讲，碳水化合物的摄入不会缺乏，不过大家要注意，不要依靠单一的来源，要讲究多种食物的搭配。 </p> </span> </p> <p> <strong><span></span></strong> </p>";
		String fit = "<p style=\"color:#333333;font-family:-apple-system, &quot;font-size:medium;background-color:#FFFFFF;\"> <p style=\"color:#333333;font-family:-apple-system, &quot;font-size:medium;background-color:#FFFFFF;\"> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span style=\"font-weight:700;\">No.1 饭后1小时内不能健身锻炼</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>许多健身锻炼者为了赶时间</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>饭后立即到健身房锻炼</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>这样容易引起消化不良</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <img src=\"http://img.mp.itc.cn/upload/20161024/9652472c7117499c82db90ccc20292e0.jpeg\" style=\"height:auto;\" /> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>进食后的一段时间内</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>胃肠道中食物充盈</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>横隔上顶</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>影响呼吸</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>不利锻炼</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <img src=\"http://img.mp.itc.cn/upload/20161024/ccb575dddf0340638de0dff5abe38f2f_th.jpeg\" style=\"height:auto;\" /> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>容易出现头晕</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>脸色苍白</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>呕吐等不适反应</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>一般较小强度的健身运动</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>如散步，快走等有益的健身运动</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>最少要在饭后半小时之后进行</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span style=\"font-weight:700;\">建议做法</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>饭后静卧10-30分钟</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <img src=\"http://img.mp.itc.cn/upload/20161024/e8c58ed25a1c4e7cbe720835e7c61c20_th.jpeg\" style=\"height:auto;\" /> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span style=\"font-weight:700;\">No.2 健身锻炼后不能立即吃饭</span><span></span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> 健身锻炼后 </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>血液循环没有恢复正常</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>血液多集中在运动的器官</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>如肢体肌肉和呼吸系统等处</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <img src=\"http://img.mp.itc.cn/upload/20161024/819bbe97befb4141aec507affaa22455.jpeg\" style=\"height:auto;\" /> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>而消化器官胃部的血液相对较少</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>消化吸收能力差</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>所以健身锻炼后不宜马上就餐</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <img src=\"http://img.mp.itc.cn/upload/20161024/7349cdb6076b457eb9192982f86d687d_th.jpeg\" style=\"height:auto;\" /> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span style=\"font-weight:700;\">建议做法</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>健身锻炼后最少要30分钟方可进餐</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <img src=\"http://img.mp.itc.cn/upload/20161024/9ea87bf573a643aeaa27c9acde5d3600_th.jpeg\" style=\"height:auto;\" /> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span style=\"font-weight:700;\">No. 3 感冒时不能锻炼</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>人患上感冒后</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>免疫力相对较低</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>这种情况下进行健身锻炼</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span><span>就会</span><span>导致</span></span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>脑部、心脏、肺、肝、肾</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>等组织器官的</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>营养严重不足</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>这样会使免疫系统功能</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>显著下降</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>使病情加重或引发其他疾病</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <img src=\"http://img.mp.itc.cn/upload/20161024/7cac294e4fa64791881dfeebcffbcf0f_th.jpeg\" style=\"height:auto;\" /> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span style=\"font-weight:700;\">建议做法</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>感冒时应多补充维生素</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>卧床休息</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <img src=\"http://img.mp.itc.cn/upload/20161024/7c9e9f9e01f04c3586393850626ab11a_th.jpeg\" style=\"height:auto;\" /> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span style=\"font-weight:700;\">No. 4 酒后不能锻炼</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>由子大脑皮层对酒精极为敏感</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>酒后大脑皮层出现短时间的</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>兴奋状态</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>当转入较长时间的抑制后</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>大脑功能处于不稳定状态</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>身体控制能力不降</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>如果在种情况下锻炼</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>大脑皮层强作努力</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>就会有损大脑功能</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <img src=\"http://img.mp.itc.cn/upload/20161024/3f83fdda7d6b45b597b2720624d34021_th.jpeg\" style=\"height:auto;\" /> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>其次</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>酒精可以促使肌肉疲劳</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>肌肉工作时</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>需要大最的血液</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>氧气供应</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>后锻炼往往因氧气供应不足</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>肌肉产生的乳酸增多引起疲劳</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <img src=\"http://img.mp.itc.cn/upload/20161024/e3f2f2faf24c426a97861a65b256347a_th.jpeg\" style=\"height:auto;\" /> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>此外</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>酒精会加速</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>乳酸在肌肉里的产生和积累</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>减慢乳酸的消除</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>不利于身体恢复</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>以致影响肌肉生长</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <img src=\"http://img.mp.itc.cn/upload/20161024/3fbb3562ce784156a9f5f0dd15dac780_th.jpeg\" style=\"height:auto;\" /> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span style=\"font-weight:700;\">建议做法</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>不论健身前还是健身后</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>都不要喝酒</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <img src=\"http://img.mp.itc.cn/upload/20161024/81e647fa5f8641028b2ce07d73944e71.jpeg\" style=\"height:auto;\" /> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span><span style=\"font-weight:700;\"><span>No.5 健身后不要立刻洗操</span></span><span style=\"font-weight:700;\"></span><span style=\"font-weight:700;\"></span></span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>健身锻炼时</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>体温急聚上升</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>肌体就会自然调节</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>使体表毛孔打开</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>及时地散热排汗</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <img src=\"http://img.mp.itc.cn/upload/20161024/484a854efd0f4219b751181576a112fe_th.jpeg\" style=\"height:auto;\" /> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>这时如果你洗澡</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>由于水温的刺激</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>体表毛孔收缩</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>阻碍汗液毒素</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>废气的排出</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>染体内内脏器官的生态环境</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>造成免疫力下降而发生疾病</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <img src=\"http://img.mp.itc.cn/upload/20161024/ab0f39f91b0f4c0ca8dbc7af1d52e44f_th.jpeg\" style=\"height:auto;\" /> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>而且有可能</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>会导致肌肉和皮肤的血管扩张</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>会使流向肌肉和皮肤的血液持续增加</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <img src=\"http://img.mp.itc.cn/upload/20161024/bd29edcb355d4db6879863781e7db847_th.jpeg\" style=\"height:auto;\" /> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>这时</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>剩余的血液</span><span>不足以供应共其他器官</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>尤其是心脏和脑部的需要</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>使心跳加速</span><span>引起脑部缺氧</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>轻者头晕眼花，</span><span>重者则休克</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <img src=\"http://img.mp.itc.cn/upload/20161024/d49af6a5fe574c4db223f5e7e2d4c5a5_th.jpeg\" style=\"height:auto;\" /> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span style=\"font-weight:700;\">建</span><span style=\"font-weight:700;\">议做法</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>健身锻炼结束后至少半个小时再洗澡</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <img src=\"http://img.mp.itc.cn/upload/20161024/d9cc87c6c70f49e1b81eb2e4a504ec31_th.jpeg\" style=\"height:auto;\" /> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span><span style=\"font-weight:700;\"><span>No. 6 状态不好不要锻炼</span></span><span style=\"font-weight:700;\"></span></span><span></span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>许多狂热的健美健身爱好者</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>在状态低迷的情况下仍坚持锻炼</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>精神可佳</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <img src=\"http://img.mp.itc.cn/upload/20161024/b95f161a0b354fd5a6b201cf6d4dfd53.jpeg\" style=\"height:auto;\" /> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>但是</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>这样会引起身体过度疲劳</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>或运动损伤</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>既影响锻炼质量</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>也不利于身体恢复和肌肉生长</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>达不到健身锻炼的目的</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <img src=\"http://img.mp.itc.cn/upload/20161024/cecf898f2a67473ea3fda9aca5f25d69_th.jpeg\" style=\"height:auto;\" /> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span style=\"font-weight:700;\">建议做法</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>休息几天</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>使身心得到放松和恢复</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <img src=\"http://img.mp.itc.cn/upload/20161024/22c9fed1c53a4e859d61d37d5dedc13c_th.jpeg\" style=\"height:auto;\" /> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span style=\"font-weight:700;\">No. 7 情绪不佳忌讳做力量训练</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>有人认为</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>情绪不佳到健身房</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>做力量训练</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>举杠铃、哑铃宣泄</span><span>情绪就会转好</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>特不知</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>带着不良的情绪锻炼</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>会容易出现运动伤害</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <img src=\"http://img.mp.itc.cn/upload/20161024/e8c94efb32444d9b893a6480c863e596_th.jpeg\" style=\"height:auto;\" /> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span style=\"font-weight:700;\">建议做法</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>参加一些团体课程</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>如瑜珈、有氧健身操、动感单车</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <img src=\"http://img.mp.itc.cn/upload/20161024/7fdad8b63c174d40b1f46d6ce7811bf9_th.jpeg\" style=\"height:auto;\" /> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span style=\"font-weight:700;\">No.8 锻炼后不要大量饮水</span><span></span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> 锻炼后大量饮水 </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>对身体健康有不良影响</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>因为这时体内血液</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>集中在四肢肌肉和体表</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>而消化道的血管处于收缩状态</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>吸收能力较弱</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <img src=\"http://img.mp.itc.cn/upload/20161024/07d4d08e4f244858bb378b09e9c82b08_th.jpeg\" style=\"height:auto;\" /> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>如果大量水分再进人消化道</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>会增加胃肠蠕动</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>甚至引起胃痉挛</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <img src=\"http://img.mp.itc.cn/upload/20161024/779e97e58a8947658494a170c7be5ecf_th.jpeg\" style=\"height:auto;\" /> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span style=\"font-weight:700;\">建议做法</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>应少量</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>多次喝些淡盐水</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <span>或是选择运动饮料</span> </p> <p style=\"font-size:16px;color:#191919;font-family:&quot;background-color:#FFFFFF;\"> <img src=\"http://img.mp.itc.cn/upload/20161024/a0fe966945474da6a488b72afb97ad47_th.jpeg\" style=\"height:auto;\" /> </p> <div> <br /> </div> </p> </p>";
		// 文章
		for (int i = 0; i < 3; i++) {
			en = new EntityImpl("f_article", this);
			en.setValue("cust_name", cust_name);
			en.setValue("gym", gym);
			en.setValue("art_type", type_id);
			en.setValue("pic_url", "app/images/temp/club1.jpg");
			en.setValue("state", "Y");
			en.setValue("num", "0");
			en.setValue("create_time", new Date());
			en.setValue("release_time", new Date());
			en.setValue("emp_id", "admin");
			if (i == 0) {
				en.setValue("title", "新手必看");
				en.setValue("summary", "健身入门须知");
				en.setValue("content", newer);
			} else if (i == 1) {
				en.setValue("pic_url", "app/images/temp/club2.jpg");
				en.setValue("title", "饮食营养");
				en.setValue("summary", "吃有时比练还重要");
				en.setValue("content", yingyang);
			} else {
				en.setValue("title", "科学健身");
				en.setValue("summary", "不能做的8件事");
				en.setValue("content", fit);
			}
			en.create();
		}

	}

}
