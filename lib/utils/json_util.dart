// JSON 工具类

import 'dart:convert';

class JsonUtil {
  /// 从JSON字符串解析为Map<String, dynamic>
  static Map<String, dynamic> parse(String jsonString) {
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  /// 将任意对象转换为JSON字符串
  static String stringify(Object obj) {
    return jsonEncode(obj);
  }
}
