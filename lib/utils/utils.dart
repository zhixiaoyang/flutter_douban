class Utils {
  // 计算是否上映
  static computeIsBeOn(pubdate){
    return  pubdate.isEmpty ? true : DateTime.now().isAfter(DateTime(DateTime.parse(pubdate).year, DateTime.parse(pubdate).month, DateTime.parse(pubdate).day));
  }

  // 获取豆瓣api  jsonp 接口
  static getJsonpApiUrl(type){
    return 'https://m.douban.com/rexxar/api/v2/subject_collection/$type/items?os=ios&for_mobile=1&callback=jsonp1&start=0&count=18&loc_id=0&_=1571041012653';
  }
}


