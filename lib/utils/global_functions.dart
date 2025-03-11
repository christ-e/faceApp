import 'dart:io';

import 'package:dio/dio.dart';
import 'package:facerecognition_flutter/app/data/dataLayer/authentication.dart';
import 'package:facerecognition_flutter/app/data/dataLayer/database.dart';

dioInjection() {
  dio = Dio()
    ..options.responseType = ResponseType.json
    ..interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
    ));
  // final cookieJar = CookieJar();
  // dio.interceptors.add(CookieManager(cookieJar));
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      options.headers['cookie'] = DB.dbSessionCookie;
      return handler.next(options);
    },
    onResponse: (response, handler) {
      response.headers.forEach((name, values) async {
        if (name == HttpHeaders.setCookieHeader) {
          final cookieMap = <String, String>{};
          for (var c in values) {
            var key = '';
            var value = '';
            key = c.substring(0, c.indexOf('='));
            value = c.substring(key.length + 1, c.indexOf(';'));
            cookieMap[key] = value;
          }
          var cookiesFormatted = '';
          cookieMap
              .forEach((key, value) => cookiesFormatted += '$key=$value; ');
          DB.dbSessionCookie = cookiesFormatted;
          return;
        }
      });
      return handler.next(response);
    },
  ));
}
