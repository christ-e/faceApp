import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart' as dio_client;
import 'package:dio/dio.dart';
import 'package:facerecognition_flutter/utils/gloabl_vaiables.dart';
import 'package:flutter/material.dart';
import 'authentication.dart';

const String r3UrlGetCustomQData = "/MasterType/GetCustomQData/";
const String r3UrlSaveMasterObject = "/MasterType/SaveMasterObject/";
const String r3UrlSaveDocumentObject = "/Documents/SaveDocumentObject/";
const String r3UrlGetDDLList = "/MasterType/GetDDLList/";
const String r3UrlDeleteSubEntities = "/MasterType/Delete/";
const String r3UrlEncryptString = "/System/EncryptString/";
const String r3UrlIsValidSession = "/Login/IsValidSession/";
const String r3UrlGetPDFData = "MasterType/DownloadPDFReportFile/";

class DB {
  static String dbSessionCookie = "";
  static String dbUserName = "";
  static String dbPassword = "";
  static String dbCompanyGUID = "";
  static String dbUserGUID = "";

  static String dbR3Url = "";
  static String dbR3MS = "";
  static String dbR3ApiUrl = "";
  static String dbR3ApiToken = "";
  static String dbR3RoleTypeID = "";
}

// login to R3 **TESTED
Future<dynamic> r3Login(userName, password, companyGUID) async {
  var body = {
    'UserName': userName,
    'Password': password,
    'CompanyGUID': companyGUID
  };
  try {
    if (DB.dbR3Url.endsWith('/')) {
      DB.dbR3Url = DB.dbR3Url.substring(0, DB.dbR3Url.length - 1);
    }
    String url = DB.dbR3Url + r3LoginUrl;
    dio_client.Response response = await dio.post(url, queryParameters: body);
    dynamic d = jsonDecode(response.data);
    if (d["status"] == '200') {
      DB.dbR3MS = d["ModuleSessionGUID"] ?? "";
      DB.dbR3ApiToken = d["SessionID"] ?? "";
      await prefs?.setString('dbR3MS', d["ModuleSessionGUID"] ?? "");
      // read session cookie //Replaced with cookie jar
      String setCookie = response.headers.value("set-cookie") ?? "";
      int i = setCookie.indexOf(';');
      String sessionCookie = (i == -1) ? setCookie : setCookie.substring(0, i);
      DB.dbSessionCookie =
          sessionCookie; // sessionCookie.substring(sessionCookie.indexOf("=")+1).trim();
      return {'Status': 200, 'Data': null, 'Message': ''};
    } else {
      return {
        'Status': 404,
        'Data': null,
        'Message': 'r3Login()->authentication failed. ${d["result"]}'
      };
    }
  } catch (e) {
    log('r3Login()->api call failed.$e');
    return {
      'Status': 404,
      'Data': null,
      'Message': 'r3Login()->api call failed.'
    };
  }
}

Future<dynamic> getImageData({isReLogin = false}) async {
  try {
    String url =
        '${DB.dbR3Url}/DMS/GetThumbnailImage/${DB.dbR3MS}?GUID=b6a37b59-87a1-43b7-acf7-132f4cde92b3';
    //dynamic response = await dio.post(url,options: Options(responseType: ResponseType.stream));
    Response<ResponseBody> rs = await dio.post<ResponseBody>(
      url,
      options: Options(responseType: ResponseType.stream),
    );

    log('getImageData1>> ${rs.data?.stream.toList()}');
    // Uint8List bytesImage;
    // log('getImageData1>> ${response.data.stream}');
    // bytesImage = const Base64Decoder().convert(response);
    // log('getImageData2>> $bytesImage');
  } catch (e) {
    return;
  }
}

// get custom query data from R3 **TESTED
Future<dynamic> getR3Data(guid, params, {isReLogin = false}) async {
  params ??= [
    {"Name": "", "Value": ""}
  ];

  try {
    String url = '${DB.dbR3Url}$r3UrlGetCustomQData${DB.dbR3MS}?GUID=$guid';
    //debugPrint('URL $url');
    dynamic response = await dio.post(url, data: params);
    //log('getR3Data Session => ${dio.options.headers.keys.}');
    dynamic d;
    if (response.statusCode == 200) {
      try {
        d = response.data;
        if (d["status"] == 200) {
          if (d["data"] != "") {
            return {
              'status': 200,
              'data': jsonDecode(d["data"]),
              'message': ''
            };
          } else {
            return {'status': 404, 'data': '', 'message': 'No data found'};
          }
        } else {
          //Try re login if the session is expired and call the getR3Data() for one more time
          if (!isReLogin) {
            bool isValidMS = await isValidR3Session();
            if (!isValidMS) {
              dynamic d =
                  await r3Login(DB.dbUserName, DB.dbPassword, DB.dbCompanyGUID);
              if (d["Status"] == 200) {
                return await getR3Data(guid, params, isReLogin: true);
              }
            }
          }
          return {
            'status': 404,
            'data': '',
            'message':
                'getR3Data()->api call failed on GUID:($guid) ${d["error"]}'
          };
        }
      } catch (e) {
        throw ("Unable to decode the response. $e");
      }
    } else {
      return {
        'status': 404,
        'data': '',
        'message': 'getR3Data()->api call failed.${response.statusMessage}'
      };
    }
  } catch (e) {
    return {
      'status': 404,
      'data': '',
      'message':
          'getR3Data()->api call failed. GUID:$guid Params:${jsonEncode(params)}. $e'
    };
  }
}

// save entity data to R3
Future<dynamic> saveR3Data(objEntity, {isSaveSubEntities = true}) async {
  try {
    String url =
        '${DB.dbR3Url}$r3UrlSaveMasterObject${DB.dbR3MS}?IsSaveSubEntities=$isSaveSubEntities';
    dynamic response = await dio.post(url, data: objEntity);
    dynamic r;
    try {
      r = jsonDecode(response.data);

      if (r["status"] == '200') {
        log('d["Status"]= ${r["status"]}');
        return {
          'status': 200,
          'message': r["result"],
          'EntityID': r["EntityID"]
        };
      } else {
        return {
          'status': 404,
          'message': 'saveR3Data()->api call failed.${r["result"]}',
          'EntityID': 0,
        };
      }
    } catch (e) {
      throw ("Unable to decode the response.data. $e");
    }
  } catch (e) {
    return {
      'status': 404,
      'message':
          'saveR3Data()->api call failed. isSaveSubEntities:$isSaveSubEntities objEntity:${jsonEncode(objEntity)}. $e'
    };
  }
}

// delete entity data to R3
Future<dynamic> deleteR3Data(encriptedId, {String remarks = ''}) async {
  try {
    String url =
        '${DB.dbR3Url}$r3UrlDeleteSubEntities${DB.dbR3MS}?QS=$encriptedId';
    dynamic response = await dio.post(url, data: jsonEncode(remarks));
    dynamic r;
    try {
      r = jsonDecode(response.data);

      if (r["status"] == '200') {
        log('d["Status"]= ${r["status"]}');
        return {'status': 200, 'message': r["result"]};
      } else {
        return {
          'status': 404,
          'message': 'deleteR3Data()->api call failed.${r["result"]}'
        };
      }
    } catch (e) {
      throw ("Unable to decode the response.data. $e");
    }
  } catch (e) {
    return {
      'status': 404,
      'message':
          'deleteR3Data()->api call failed. objEntity:${jsonEncode(encriptedId)}. $e'
    };
  }
}

Future<dynamic> saveR3DocumentData(objDocument) async {
  try {
    String url = '${DB.dbR3Url}$r3UrlSaveDocumentObject${DB.dbR3MS}';
    dynamic response = await dio.post(url, data: objDocument);
    dynamic r;
    try {
      r = jsonDecode(response.data);

      if (r["status"].toString() == '200') {
        debugPrint('d["Status"]= ${r["status"]}');
        return {
          'status': 200,
          'message': r["result"],
          'EntityID': r["EntityID"]
        };
      } else {
        return {
          'status': 404,
          'message': 'Failed to upload ${r["result"]}',
          'EntityID': 0,
        };
      }
    } catch (e) {
      throw ("Unable to decode the response.data. $e");
    }
  } catch (e) {
    return {
      'status': 404,
      'message':
          'saveR3Document()->api call failed. objEntity:${jsonEncode(objDocument)}. $e'
    };
  }
}

// get DDList from mastertypes field from R3
Future<dynamic> getR3DDLList(searchString, masterTypeID, fieldID,
    {isListTableExists = true, params = ""}) async {
  var body = {
    "search": searchString ?? '',
    "MasterTypeID": masterTypeID,
    "FieldID": fieldID,
    "Params": params ?? '',
    "IsListTableExists": true,
  };

  try {
    String url = '${DB.dbR3Url}$r3UrlGetDDLList${DB.dbR3MS}';
    dynamic response = await dio.get(url, queryParameters: body);
    //log('getDdlisturl= ${response.data["results"]}');
    debugPrint('getDdlisturl= ${response.data["results"]}');

    dynamic d = response.data;
    if (d["results"] != []) {
      return {'Status': 200, 'Data': d["results"], 'Message': ''};
    } else {
      return {
        'Status': 404,
        'Data': null,
        'Message': 'r3Getddlist()->authentication failed. ${d["result"]}'
      };
    }
  } catch (e) {
    return {
      'Status': 404,
      'Data': null,
      'Message': 'r3Getddlist()->api call failed.$e'
    };
  }
}

// encrypt string from R3
Future<String> encryptR3String(strToEncrypt) async {
  String strRet = "";
  try {
    String url =
        '${DB.dbR3Url}$r3UrlEncryptString${DB.dbR3MS}?encodeURL=true&QS=${Uri.encodeComponent(strToEncrypt)}';
    dynamic response = await dio.get(url);
    if (response.statusCode == 200) {
      strRet = response.data;
    }
  } catch (e) {
    log('$e');
  }
  return strRet;
}

Future<bool> isValidR3Session() async {
  bool boolRet = false;
  try {
    String url = '${DB.dbR3Url}$r3UrlIsValidSession${DB.dbR3MS}';
    dynamic response = await dio.post(url);
    if (response.statusCode == 200) {
      boolRet = (response.toString() == "1");
    }
  } catch (e) {
    log('$e');
  }

  return boolRet;
}

Future<dynamic> getCompanyInfoByRSNID(int rsnID) async {
  //String url = '${DB.dbR3Url}$r3UrlGetCustomQData${DB.dbR3MS}?GUID=$guid';
  String url =
      'https://tpiservice.realsoft3.com/TPIRegistration/GetCompanyInfoByRSNID?ApiToken=C4093C85-5C57-4F5A-A676-34BA7C7A4898&RSNID=$rsnID';
  //debugPrint('URL $url');
  dynamic response = await dio.post(url);
  dynamic d;
  try {
    d = response.data;
    log('RESP :${response.data}');
    if (d["status"] == 200) {
      if (d["data"] != '') {
        return {'status': 200, 'data': jsonDecode(d["data"]), 'message': ''};
      } else {
        return {'status': 404, 'data': '', 'message': 'Invalid RSN ID'};
      }
    } else {
      return {
        'status': 404,
        'data': '',
        'message': 'Invalid RSN ID' //'Something went wrong${d["error"]}'
      };
    }
  } catch (e) {
    log('Error while fetching company details.$e');
  }
}
