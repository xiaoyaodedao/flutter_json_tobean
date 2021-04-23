import 'package:dio/dio.dart';
import 'package:first_flutter/beans/bean.dart';

import 'api.dart';

enum Method { GET, POST }
///数据请求状态
enum ResourceStatus { ERROR, SUCCESS }
///数据包装
class Resource<T> {
  ResourceStatus status;
  String message;
  T data;

  Resource.success(T data) {
    this.data = data;
    this.status = ResourceStatus.SUCCESS;
  }

  Resource.error(String message) {
    this.message = message;
    this.status = ResourceStatus.ERROR;
  }
}

class HttpManager {
  static HttpManager _instance;
  Dio _dio;

  HttpManager._newInstance() {
    BaseOptions options = new BaseOptions(
      baseUrl: Api.baseUrl, //基础地址
      connectTimeout: 5000, //连接服务器超时时间，单位是毫秒
      receiveTimeout: 3000, //读取超时
    );
    _dio = new Dio(options);
  }

  factory HttpManager.getInstance() {
    if (_instance == null) {
      _instance = HttpManager._newInstance();
    }
    return _instance;
  }

  ///请求对象返回object的
  Future<Resource<T>> requestObject<T extends Decoder>(String path, T object,
      {Method method = Method.GET}) async {
    try {
      Response response = await _requestResponse(path, method);
      print(response.data.runtimeType);
      return Resource.success(BaseBean<T>().fromJson(response.data, object));
    } on DioError catch (e) {
      return Resource.error(_dioErrorTypeToMessage(e));
    } catch (e) {
      return Resource.error("unKnow error");
    }
  }

  ///请求对象为List的
  Future<Resource<List<T>>> requestList<T extends Decoder>(
      String path, T object,
      {Method method = Method.GET}) async {
    try {
      Response response = await _requestResponse(path, method);
      return Resource.success(
          BaseListBean<T>().fromJson(response.data, object));
    } on DioError catch (e) {
      return Resource.error(_dioErrorTypeToMessage(e));
    } catch (e) {
      return Resource.error("unKnow error");
    }
  }

  Future<Response> _requestResponse(String path, Method method) async {
    Response response;
    try {
      if (method == Method.POST) {
        response = await _dio.post(path, options: Options(method: "POST"));
      } else {
        response = await _dio.get(path, options: Options(method: "GET"));
      }
      return response;
    } on DioError catch (e) {
      throw e;
    } catch (e) {
      throw e;
    }
  }

  String _dioErrorTypeToMessage(DioError dioError) {
    String message = "UnKnow Error";
    if (dioError == null || dioError.type == null) {
      return message;
    }
    switch (dioError.type) {
      case DioErrorType.connectTimeout:
        message = "connect timeout";
        break;
      case DioErrorType.sendTimeout:
        message = "send timeout";
        break;
      case DioErrorType.receiveTimeout:
        message = "receive timeout";
        break;
      case DioErrorType.response:
        message = "When the server response, but with a incorrect status,such as 404, 503...";
        break;
      case DioErrorType.cancel:
        message = "cancle error";
        break;
      case DioErrorType.other:
        break;
    }
  }
}
