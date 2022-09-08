import 'package:flutter/material.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:my_dog_app/services/log_service.dart';

class InterceptorService implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    // debugPrint(data.url.toString());
    LogService.i(data.url.toString());
    LogService.i(data.method.toString());
    LogService.i(data.headers.toString());
    LogService.i(data.params.toString());
    LogService.i(data.body.toString());
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    LogService.v(data.statusCode.toString());
    LogService.wtf(data.body.toString());
    return data;
  }
}