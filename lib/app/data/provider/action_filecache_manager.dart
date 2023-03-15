import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ActionFileCacheManager {
  static const key = 'actionCache';

  static CacheManager instance = CacheManager(Config(
    key,
    stalePeriod: Duration(days: 7),
    
  ),);
}
