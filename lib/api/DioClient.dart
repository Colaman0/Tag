import 'dart:io';

import 'package:tag/util/UserManager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class DioClient {

  // 正式域名
  static final String _baseUrl = "https://m.hyqfx.com/";

  // 测试域名
  static final String _testBaseUrl = "http://wkt.t.api.hyqfx.com/customer/";

  static Dio _dio;

  DioClient._();

  static Dio getInstance() {
    if (_dio == null) {
      _dio = Dio();
      BaseOptions options = new BaseOptions(baseUrl: _testBaseUrl, receiveTimeout: 20000, connectTimeout: 20000);
      options.responseType = ResponseType.json;
      _dio.options = options;
      _dio.interceptors.add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
        var platFormType = Platform.isAndroid ? "2" : "1";
        // 添加deviceTpye
        options.headers["device_type"] = platFormType;
//        options.headers["Authorization"] = "Bearer " + await UserManager.getInstance().getToken();
      }, onResponse: (Response response) {
        print(" request = ${response.request.uri}\n response = ${response.data}");
      }));
    }
    return _dio;
  }
}
