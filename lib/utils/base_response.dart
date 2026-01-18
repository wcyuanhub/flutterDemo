import 'dart:convert';
import '../contants/network_constants.dart';

/// 通用响应类
/// 与后端Java BaseResponse<T>对应
class BaseResponse<T> {
  int code;
  T? data;
  String message;

  /// 全参构造函数
  BaseResponse({required this.code, this.data, required this.message});

  /// 只包含code和data的构造函数
  BaseResponse.data({required this.code, this.data}) : message = '';

  /// 接收ErrorCode的构造函数
  BaseResponse.error(int errorCode)
    : code = errorCode,
      data = null,
      message = ErrorMessage.systemError;

  /// 从JSON字符串创建BaseResponse实例
  factory BaseResponse.fromJson(String jsonString) {
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return BaseResponse.fromJsonMap(jsonMap);
  }

  /// 从JSON Map创建BaseResponse实例
  factory BaseResponse.fromJsonMap(Map<String, dynamic> json) {
    return BaseResponse(
      code: json['code'] as int,
      data: json['data'],
      message: json['message'] as String? ?? '',
    );
  }

  /// 将BaseResponse实例转换为JSON字符串
  String toJson() {
    final Map<String, dynamic> json = {
      'code': code,
      'data': data,
      'message': message,
    };
    return jsonEncode(json);
  }

  /// 将BaseResponse实例转换为JSON Map
  Map<String, dynamic> toJsonMap() {
    return {'code': code, 'data': data, 'message': message};
  }

  /// 判断是否请求成功
  bool get isSuccess => code == ErrorCode.success;
}
