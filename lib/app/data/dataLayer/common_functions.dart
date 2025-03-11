import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:facerecognition_flutter/app/data/dataLayer/authentication.dart';
import 'package:facerecognition_flutter/app/data/dataLayer/database.dart';
import 'package:facerecognition_flutter/utils/gloabl_vaiables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

dynamic rVal(dynamic d) {
  try {
    if (d is int) {
      return d;
    } else if (d is double) {
      return d;
    } else if (d is String) {
      String s = d;
      s = s.replaceAll(",", "");
      if (s.contains('.')) {
        return double.parse(s);
      } else {
        return int.parse(s);
      }
    }
  } catch (e) {
    return 0;
  }
  return 0;
}

String rStr(dynamic d) {
  try {
    if (d is int) {
      return (d).toString();
    } else if (d is double) {
      return (d).toString();
    } else if (d is String) {
      String s = d;
      return s;
    }
  } catch (e) {
    return "";
  }
  return "";
}

num rVal2(var val) {
  if (val == null || val.isEmpty) {
    return 0;
  } else if (val.runtimeType is String) {
    return num.parse(val);
  } else if (val.runtimeType is int ||
      val.runtimeType is double ||
      val.runtimeType is num) {
    return num.parse(val);
  } else {
    return 0;
  }
}

dynamic rDynamicMap(json) {
  return (json as List).map((e) => e as Map<dynamic, dynamic>).toList();
}

List join(l1, l2, String on1, String on2, String al1, String al2,
    [List<String>? colFilter]) {
  List lRet = [];
  if (al1.isNotEmpty) {
    al1 = "${al1}_";
  }
  if (al2.isNotEmpty) {
    al2 = "${al2}_";
  }
  if (l1 != null && l2 != null) {
    for (int i = 0; i < l1.length; i++) {
      var l1r = l1[i];
      List l1k = l1r.keys.toList();
      for (int j = 0; j < l2.length; j++) {
        var l2r = l2[j];
        List l2k = l2r.keys.toList();
        if (l1r[on1] == l2r[on2]) {
          var r = {};
          for (int x = 0; x < l1k.length; x++) {
            if (colFilter == null) {
              r.addAll({al1 + l1k[x]: l1r[l1k[x]]});
            } else {
              if (colFilter.contains(al1 + l1k[x])) {
                r.addAll({al1 + l1k[x]: l1r[l1k[x]]});
              }
            }
          }
          for (int x = 0; x < l2k.length; x++) {
            if (colFilter == null) {
              r.addAll({al2 + l2k[x]: l2r[l2k[x]]});
            } else {
              if (colFilter.contains(al2 + l2k[x])) {
                r.addAll({al2 + l2k[x]: l2r[l2k[x]]});
              }
            }
          }
          lRet.add(r);
        }
      }
    }
  }
  return lRet;
}

//This function will remove the duplicate maps inside a
List<Map<String, dynamic>> removeDuplicateMaps(
    List<Map<String, dynamic>> list) {
  List<Map<String, dynamic>> uniqueList = [];
  Set<String> uniqueKeys = <String>{};

  for (var map in list) {
    String mapString = map.toString(); // Convert map to string for comparison
    if (!uniqueKeys.contains(mapString)) {
      uniqueList.add(map);
      uniqueKeys.add(mapString);
    }
  }

  return uniqueList;
}

// int r3DateToNum(String date) {
//   try {
//     DateTime startDate = DateTime(1900, 1, 1);
//     DateTime endDate = DateTime.parse(date);
//     int differenceInDays = endDate.difference(startDate).inDays + 4;
//     return differenceInDays;
//   } catch (e) {
//     return -1;
//   }
// }

DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

Future<String?> getDeviceInfo(context) async {
  try {
    if (Theme.of(context).platform == TargetPlatform.android) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      log("DeviceID:  ${androidInfo.id.toString()}");
      // await prefs?.setString('DeviceId', androidInfo.id);
      return androidInfo.id;
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      log(iosInfo.identifierForVendor.toString());
      // await prefs?.setString(
      //     'DeviceId', iosInfo.identifierForVendor.toString());
      return iosInfo.identifierForVendor;
    }
    // deviceID = deviceID;
    log("DEVICE ID : $deviceID");
    return deviceID;
  } catch (e) {
    log('Error : $e');
  }
  return null;
}

int r3DateToNum(String date) {
  try {
    DateTime startDate = DateTime.utc(1900, 1, 1);

    DateTime endDate = DateTime.parse(date);

    int differenceInDays = endDate.difference(startDate).inDays + 3;
    return differenceInDays;
  } catch (e) {
    return -1;
  }
}

String formatDate(String dateString, {String divider = ' '}) {
  DateTime parsedDate = DateTime.parse(dateString);
  DateFormat formatter = DateFormat('dd${divider}MMM${divider}yyyy');
  String formattedDate = formatter.format(parsedDate);
  return formattedDate;
}

Future<List<dynamic>> getPrevilege(int typeID, int isFormType) async {
  try {
    var params = [
      {"Name": "TYPEID", "Value": typeID},
      {"Name": "ISFORMTYPE", "Value": isFormType}
    ];
    dynamic result = await getR3Data(
      'a4b0699e-bd93-4145-a1c3-63b3a6ccb0e9',
      params,
    );
    if (result['status'] == 200) {
      return result['data'];
    } else {
      return [];
    }
  } catch (e) {
    log('Error $e');
    return [];
  }
}

String? getSessionGuid() {
  return prefs?.getString('LoginGuid');
}

int? getLoginUserID() {
  return prefs?.getInt('LoginUserID');
}

String? getUserName() {
  return prefs?.getString('EmpName');
}

String? getEmployeImageGuid() {
  return prefs?.getString('EmpImgGuid');
}

String? getDeviceid() {
  return prefs?.getString('device_id');
}

int? getEmpID() {
  return prefs?.getInt('EmpID');
}

int? getBranchID() {
  return prefs?.getInt('BranchID');
}

String? convertDateTimeTargetFormat(String inputDate) {
  try {
    final DateFormat inputFormat = DateFormat("dd-MMM-yyyy h:mm a");
    final DateFormat outputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime parsedDate = inputFormat.parse(inputDate);
    return outputFormat.format(parsedDate);
  } catch (e) {
    log('Error while Converting date fomat : $e');
    return null;
  }
}

dynamic getDocNo({
  required num formTypeId,
  required int docDate,
  int? branchID,
}) async {
  try {
    var params = [
      {"Name": "FORMTYPEID", "Value": formTypeId},
      {"Name": "BRANCHID", "Value": branchID},
      {"Name": "DOCDATE", "Value": docDate},
    ];
    debugPrint('DOC DATE PARAMS : $params');
    final result =
        await getR3Data('61649287-60dd-424a-aff0-bbe680f9982e', params);
    if (result != null && result["status"] == 200) {
      return result["data"];
    } else {
      return null;
    }
  } catch (e) {
    log('Error : $e');
  }
}

String? formatDateForInt(String date) {
  DateFormat inputFormat = DateFormat("dd-MMM-yyyy");
  DateFormat outputFormat = DateFormat("yyyy-MM-dd");

  DateTime parsedDate = inputFormat.parse(date);

  String formattedDate = outputFormat.format(parsedDate);

  return formattedDate;
}

Future<bool> getR3PDFView(
  String guid,
  String reqGUID,
  int docEntityID,
  String qs,
) async {
  try {
    String url =
        '${DB.dbR3Url}/$r3UrlGetPDFData${DB.dbR3MS}?RequestID=$reqGUID&GUID=$guid&EntityID=$docEntityID&QS=$qs';

    final response = await dio.get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );

    if (response.statusCode == 200 && response.data != null) {
      debugPrint('PDF data fetched successfully.');

      final tempDir = await getTemporaryDirectory();
      final tempFilePath = '${tempDir.path}/Payslip$docEntityID.pdf';
      final tempFile = File(tempFilePath);

      await tempFile.writeAsBytes(response.data!);

      // await OpenFile.open(tempFilePath);

      return true;
    } else {
      debugPrint(
          'Failed to fetch PDF with status code: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    debugPrint('Error: $e');
    return false;
  }
}

Future<bool> getR3PDFData(
  String guid,
  String reqGUID,
  int docEntityID,
  String qs,
  int emp,
  String folderName,
) async {
  try {
    if (await Permission.manageExternalStorage.request().isGranted) {
      if (kDebugMode) {
        print("Manage External Storage Permission Granted");
      }
    } else {
      if (kDebugMode) {
        print("Manage External Storage Permission Denied");
      }
    }
  } catch (e) {
    log(e.toString());
  }
  try {
    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.isGranted) {
        if (kDebugMode) {
          print("Manage External Storage Permission Granted");
        }
      } else {
        PermissionStatus status =
            await Permission.manageExternalStorage.request();
        if (status.isGranted) {
          if (kDebugMode) {
            print("Permission Granted After Request");
          }
        } else {
          if (kDebugMode) {
            print("Permission Denied");
          }
          if (status.isPermanentlyDenied) {
            openAppSettings();
          }
        }
      }
    } else {
      if (kDebugMode) {
        print("This permission is only required on Android devices.");
      }
    }
  } catch (e) {
    log(e.toString());
  }
  try {
    Directory? directory;
    if (Platform.isAndroid) {
      directory =
          Directory('/storage/emulated/0/Download'); // Default Downloads folder
    } else if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory(); // For iOS
    }

    if (directory == null) {
      debugPrint('Directory not available.');
      return false;
    }

    String folderPath = '${directory.path}/$folderName';

    // Create the folder if it doesn't exist
    final folder = Directory(folderPath);
    if (!await folder.exists()) {
      await folder.create(recursive: true);
      debugPrint('Folder created at: $folderPath');
    }

    // Define the file path
    String filePath = '$folderPath/PaySlip$docEntityID.pdf';

    String url =
        '${DB.dbR3Url}/$r3UrlGetPDFData${DB.dbR3MS}?RequestID=$reqGUID&GUID=$guid&EntityID=$docEntityID&EMPID=$emp&QS=$qs';

    final response = await dio.download(url, filePath);
    if (response.statusCode == 200) {
      debugPrint('File downloaded successfully at: $filePath');
      return true;
    } else {
      debugPrint('Download failed with status code: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    debugPrint('Error: $e');
    return false;
  }
}
