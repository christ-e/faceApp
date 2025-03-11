import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart' as dio_client;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

late Dio dio;

//URLs for RSN authentication reading handles
const String rsnApiToken = "4dedd8b2-fcf0-4295-abd8-a5360553a558";

const String rsnApiUrl = 'https://tpiservice.realsoft3.com';

const String rsnLoginUrl = "$rsnApiUrl/Security/API_ValidateControlLogin";

const String rsnEnterCompanyUrl = "$rsnApiUrl/Security/API_EnterCompany";

const String rsnCollectUserRegInfoUrl =
    "$rsnApiUrl/TPIRegistration/API_CollectRSNRegInfo";

const String rsnCollectHandlesUrl =
    "$rsnApiUrl/TPIBusinessProfile/API_CollectHandlesOrSubscription";

//URL for r3 authentication
const String r3LoginUrl = "/Login/R3RSNAutoLogin";
String rsnSessionID = "";

//1) login to rsn
Future<dynamic> loginRSN(userName, password) async {
  var body = {
    'APIToken': rsnApiToken,
    'UserName': userName,
    'Password': password
  };
  try {
    dio_client.Response response =
        await dio.post(rsnLoginUrl, queryParameters: body);
    log('loginResponse=> ${response.data}');
    return jsonDecode(response.data);
  } catch (e) {
    log('loginRSN()->api call failed.$e');
    return {
      'Status': 404,
      'Data': null,
      'Message': 'loginRSN()->api call failed.'
    };
  }
}

//2) enter to specific company in rsn
Future<dynamic> enterCompany(userName, sessionID, companyGUID, userGUID) async {
  var body = {
    'APIToken': sessionID,
    'UserName': userName,
    'SessionID': sessionID,
    'CompanyGUID': companyGUID,
    'UserGUID': userGUID,
  };

  try {
    dio_client.Response response =
        await dio.post(rsnEnterCompanyUrl, queryParameters: body);
    log('enterCompanyResponse=> ${response.data}');
    return jsonDecode(response.data);
  } catch (e) {
    return {
      'Status': 404,
      'Data': null,
      'Message': 'enterCompany()->api call failed.$e'
    };
  }
}

//3) read the registration info of the logged in user from rsn
Future<dynamic> collectRegInfo(apiToken, userGUID) async {
  var body = {
    "APIToken": apiToken,
    "UserGUID": userGUID,
  };

  try {
    dio_client.Response response =
        await dio.post(rsnCollectUserRegInfoUrl, queryParameters: body);
    log('collectRegInfoResponse=> ${response.data}');
    return jsonDecode(response.data);
  } catch (e) {
    return {
      'Status': 404,
      'Data': null,
      'Message': 'collectRegInfo()->api call failed.$e'
    };
  }
}

//4) read the possible handles of the user from rsn
Future<dynamic> collectHandles(apiToken, relatedRegID) async {
  var body = {
    "APIToken": apiToken,
    "RelatedRegID": relatedRegID,
  };

  try {
    dio_client.Response response =
        await dio.post(rsnCollectHandlesUrl, queryParameters: body);
    debugPrint("collectHandlesResponse=> ${response.data}");
    return jsonDecode(response.data);
  } catch (e) {
    return {
      'Status': 404,
      'Data': null,
      'Message': 'collectHandles()->api call failed.$e'
    };
  }
}
