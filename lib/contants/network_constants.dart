/// 网络请求相关常量
class NetworkConstants {
  // 基础URL
  static const String baseUrl = 'http://localhost:8080';

  // 超时时间 (单位: 秒)
  static const int connectTimeout = 10;
  static const int receiveTimeout = 10;
  static const int sendTimeout = 10;

  // 内容类型
  static const String contentType = 'application/json;charset=utf-8';

  // 默认文件名
  static const String defaultFileName = 'file';

  // 默认文件键名
  static const String defaultFileKey = 'file';

  // 默认长度头
  static const String defaultLengthHeader = 'content-length';

  // 取消请求的消息
  static const String cancelRequestMessage = '所有请求已取消';

  // HTTP头相关
  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer ';

  // 初始token值
  static const String initialToken = '';
}

/// HTTP状态码常量
class HttpStatus {
  // 成功
  static const int ok = 200;
  static const int created = 201;
  static const int noContent = 204;

  // 客户端错误
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int methodNotAllowed = 405;

  // 服务器错误
  static const int internalServerError = 500;
  static const int badGateway = 502;
  static const int serviceUnavailable = 503;
  static const int gatewayTimeout = 504;
}

/// 业务错误码常量（与后端Java ErrorCode枚举对应）
class ErrorCode {
  // 成功
  static const int success = 0;

  // 客户端错误
  static const int paramsError = 40000;
  static const int notLoginError = 40100;
  static const int noAuthError = 40101;
  static const int repeatError = 40200;
  static const int forbiddenError = 40300;
  static const int notFoundError = 40400;

  // 服务器错误
  static const int systemError = 50000;
  static const int operationError = 50001;
  static const int apiRequestError = 50010;
}

/// 错误消息常量
class ErrorMessage {
  // 网络错误
  static const String connectionTimeout = '连接超时';
  static const String sendTimeout = '发送超时';
  static const String receiveTimeout = '接收超时';
  static const String badCertificate = '证书错误';
  static const String connectionError = '网络连接错误';
  static const String unknownError = '未知错误';
  static const String canceled = '请求被取消';

  // HTTP错误
  static const String badRequest = '请求参数错误';
  static const String unauthorized = '未授权，请重新登录';
  static const String forbidden = '拒绝访问';
  static const String notFound = '请求的资源不存在';
  static const String methodNotAllowed = '请求方法不允许';
  static const String internalServerError = '服务器内部错误';
  static const String badGateway = '网关错误';
  static const String serviceUnavailable = '服务不可用';
  static const String gatewayTimeout = '网关超时';
  static const String serverError = '服务器错误';
  static const String requestFailed = '请求失败';

  // 业务错误（与后端Java ErrorCode枚举对应）
  static const String success = 'ok';
  static const String paramsError = '请求参数错误';
  static const String notLoginError = '未登录';
  static const String noAuthError = '无权限';
  static const String repeatError = '参数重复';
  static const String forbiddenError = '禁止访问';
  static const String notFoundError = '请求数据不存在';
  static const String systemError = '系统内部异常';
  static const String operationError = '操作失败';
  static const String apiRequestError = '接口调用失败';
}
