class Utils {
  // 计算是否上映
  static computeIsBeOn(pubdate){
    return  pubdate.isEmpty ? true : DateTime.now().isAfter(DateTime(DateTime.parse(pubdate).year, DateTime.parse(pubdate).month, DateTime.parse(pubdate).day));
  }
}