import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_project/utils/toast_util.dart';
import '../contants/network_constants.dart';
import './base_response.dart';

class DioUtil {
  // 单例模式
  static final DioUtil _instance = DioUtil._internal();
  factory DioUtil() => _instance;
  static Dio? _dio;

  // 用于取消请求的CancelToken
  CancelToken _cancelToken = CancelToken();

  DioUtil._internal() {
    if (_dio == null) {
      // 初始化Dio
      BaseOptions options = BaseOptions(
        baseUrl: NetworkConstants.baseUrl, // 基础URL
        connectTimeout: Duration(
          seconds: NetworkConstants.connectTimeout,
        ), // 连接超时
        receiveTimeout: Duration(
          seconds: NetworkConstants.receiveTimeout,
        ), // 接收超时
        // Web平台上GET请求没有请求体时不能设置sendTimeout
        sendTimeout: !kIsWeb
            ? Duration(seconds: NetworkConstants.sendTimeout)
            : null, // 发送超时
        responseType: ResponseType.json, // 响应类型
      );

      _dio = Dio(options);

      // 添加请求拦截器
      _dio!.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            // 可以在这里添加token、修改请求头等
            String token = NetworkConstants.initialToken; // 从本地存储获取token
            if (token.isNotEmpty) {
              options.headers[NetworkConstants.authorizationHeader] =
                  '${NetworkConstants.bearerPrefix}$token';
            }

            if (options.method == 'POST') {
              options.headers[NetworkConstants.contentType] =
                  NetworkConstants.contentType;
            }

            // 打印请求信息
            if (kDebugMode) {
              print('请求URL: ${options.uri}');
              print('请求方法: ${options.method}');
              print('请求头: ${options.headers}');
              if (options.data != null) {
                print('请求参数: ${options.data}');
              }
            }

            return handler.next(options);
          },

          onResponse: (response, handler) {
            // 打印响应信息
            if (kDebugMode) {
              print('响应状态码: ${response.statusCode}');
              print('响应数据: ${response.data}');
            }

            if (response.statusCode == HttpStatus.ok) {
              // 请求成功
              // 处理api返回的数据 变为 BaseResponse<T>
              BaseResponse<dynamic> baseResponse = BaseResponse.fromJsonMap(
                response.data as Map<String, dynamic>,
              );
              if (baseResponse.code != ErrorCode.success) {
                // 可以在这里对错误进行统一处理
                // _handleError(response);
                String errorMsg = _handleServerError(baseResponse);
                debugPrint('Server error: $errorMsg');
              }
            } else {
              // 响应失败
              _handleError(
                DioException(requestOptions: response.requestOptions),
              );
            }

            return handler.next(response);
          },

          onError: (DioException e, handler) {
            // 统一处理错误
            _handleError(e);
            return handler.next(e);
          },
        ),
      );
    }
  }

  // 处理Dio错误
  void _handleError(DioException e) {
    String errorMsg = '';
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        errorMsg = ErrorMessage.connectionTimeout;
        break;
      case DioExceptionType.sendTimeout:
        errorMsg = ErrorMessage.sendTimeout;
        break;
      case DioExceptionType.receiveTimeout:
        errorMsg = ErrorMessage.receiveTimeout;
        break;
      case DioExceptionType.badCertificate:
        errorMsg = ErrorMessage.badCertificate;
        break;
      case DioExceptionType.cancel:
        errorMsg = ErrorMessage.canceled;
        break;
      case DioExceptionType.connectionError:
        errorMsg = ErrorMessage.connectionError;
        break;
      case DioExceptionType.unknown:
        errorMsg = ErrorMessage.unknownError;
        break;
      default:
        errorMsg = ErrorMessage.unknownError;
        break;
    }

    if (kDebugMode) {
      print('错误类型: ${e.type}');
      print('错误信息: $errorMsg');
      if (e.response != null) {
        print('错误响应: ${e.response?.data}');
      }
    }

    // 可以在这里添加全局错误提示
    // 注意：在拦截器中无法直接获取BuildContext，需要通过全局导航键或回调方式处理
    //例如：如果有全局导航键，可以使用 ToastUtil.showError(globalKey.currentContext, errorMsg);
    //当前仅记录日志，不显示UI提示
    debugPrint('Dio错误: $errorMsg');
  }

  // 处理服务器返回的错误
  String _handleServerError(BaseResponse? response) {
    if (response == null) return ErrorMessage.serverError;

    int? statusCode = response.code;
    dynamic data = response.data;

    String errorMsg = '';

    // 首先检查是否有业务错误码（来自后端Java ErrorCode枚举）
    if (data != null && data is Map<String, dynamic>) {
      int? businessCode = data['code'];
      if (businessCode != null) {
        // 根据业务错误码返回对应的错误消息
        switch (businessCode) {
          case ErrorCode.success:
            errorMsg = data['message'] ?? ErrorMessage.success;
          case ErrorCode.paramsError:
            errorMsg = data['message'] ?? ErrorMessage.paramsError;
          case ErrorCode.notLoginError:
            // 处理未登录，例如跳转到登录页
            errorMsg = data['message'] ?? ErrorMessage.notLoginError;
          case ErrorCode.noAuthError:
            errorMsg = data['message'] ?? ErrorMessage.noAuthError;
          case ErrorCode.repeatError:
            errorMsg = data['message'] ?? ErrorMessage.repeatError;
          case ErrorCode.forbiddenError:
            errorMsg = data['message'] ?? ErrorMessage.forbiddenError;
          case ErrorCode.notFoundError:
            errorMsg = data['message'] ?? ErrorMessage.notFoundError;
          case ErrorCode.systemError:
            errorMsg = data['message'] ?? ErrorMessage.systemError;
          case ErrorCode.operationError:
            errorMsg = data['message'] ?? ErrorMessage.operationError;
          case ErrorCode.apiRequestError:
            errorMsg = data['message'] ?? ErrorMessage.apiRequestError;
          default:
            errorMsg =
                data['message'] ??
                '${ErrorMessage.requestFailed}，业务错误码: $businessCode';
        }
      }
    }

    return errorMsg;
  }

  // GET请求
  Future<BaseResponse<dynamic>> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      Response response = await _dio!.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken ?? _cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return BaseResponse.fromJsonMap(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // POST请求
  Future<BaseResponse<dynamic>> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      Response response = await _dio!.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return BaseResponse.fromJsonMap(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // PUT请求
  Future<BaseResponse<dynamic>> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      Response response = await _dio!.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return BaseResponse.fromJsonMap(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // DELETE请求
  Future<BaseResponse<dynamic>> delete(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      Response response = await _dio!.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return BaseResponse.fromJsonMap(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // PATCH请求
  Future<BaseResponse<dynamic>> patch(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      Response response = await _dio!.patch(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return BaseResponse.fromJsonMap(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // 下载文件
  Future<BaseResponse<dynamic>> download(
    String urlPath,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    String lengthHeader = NetworkConstants.defaultLengthHeader,
    Object? data,
    Options? options,
  }) async {
    try {
      Response response = await _dio!.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        deleteOnError: deleteOnError,
        lengthHeader: lengthHeader,
        data: data,
        options: options,
      );
      return BaseResponse.fromJsonMap(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // 上传文件
  Future<BaseResponse<dynamic>> uploadFile(
    String url,
    String filePath, {
    String fileName = NetworkConstants.defaultFileName,
    String fileKey = NetworkConstants.defaultFileKey,
    Map<String, dynamic>? otherParams,
    ProgressCallback? onSendProgress,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        if (otherParams != null) ...otherParams,
        fileKey: await MultipartFile.fromFile(filePath, filename: fileName),
      });

      Response response = await _dio!.post(
        url,
        data: formData,
        onSendProgress: onSendProgress,
        options: options,
        cancelToken: cancelToken ?? _cancelToken,
      );
      return BaseResponse.fromJsonMap(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // 取消所有请求
  void cancelAllRequests() {
    if (!_cancelToken.isCancelled) {
      _cancelToken.cancel(NetworkConstants.cancelRequestMessage);
      // 创建新的CancelToken，以便后续请求可以正常发送
      _cancelToken = CancelToken();
    }
  }

  // 设置基础URL
  void setBaseUrl(String baseUrl) {
    _dio?.options.baseUrl = baseUrl;
  }

  // 获取当前Dio实例
  Dio get dioInstance => _dio!;
}
