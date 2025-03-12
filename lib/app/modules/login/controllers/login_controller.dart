import 'dart:developer';

import 'package:facerecognition_flutter/utils/custom_flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../../../../utils/app_size_box.dart';
import '../../../../utils/color_const.dart';
import '../../../../utils/gloabl_vaiables.dart';
import '../../../data/dataLayer/authentication.dart';
import '../../../data/dataLayer/database.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final RxBool isPasswordHidden = true.obs;
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  void onInit() {
    loadRememberStatus();
    super.onInit();
  }

  //Rx Variables
  RxBool isPasswordVisible = true.obs;
  RxBool isLoading = false.obs;
  RxInt selectedCompanyIndex = 0.obs;
  RxBool rememberMe = false.obs;
  final FlutterSecureStorage userCredStorage = const FlutterSecureStorage();

/*< R3 Login Functions Starting>*/
  void rsnLogin({required String userName, required String password}) async {
    try {
      if (rememberMe.value == true) {
        await prefs?.setString('userName', userName);
        await prefs?.setString('passowrd', password);
      }
      isLoading.value = true;
      dynamic d = await loginRSN(userName, password);
      if (d["Status"] == '200') {
        rsnSessionID = d["Data"]["_SessionID"] ?? "";
        DB.dbCompanyGUID =
            d["Data"]["zHolder_SubCompanies"][0]["CompanyGUID"] ?? "";
        DB.dbUserGUID = d["Data"]["GUID"] ?? "";
        rsnEnterCompany(
          userName: userName,
          sessionID: rsnSessionID,
          companyGUID: DB.dbCompanyGUID,
          userGUID: DB.dbUserGUID,
        );
      } else {
        isLoading.value = false;
        showFlushBar(
          context: Get.context,
          title: d["Message"].toString(),
        );
      }
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future<void> saveUserLoginCredentials({
    required String userName,
    required String password,
  }) async {
    if (rememberMe.value == true) {
      await userCredStorage.write(key: 'userName', value: userName);
      await userCredStorage.write(key: 'password', value: password);
    } else {
      await userCredStorage.delete(key: 'userName');
      await userCredStorage.delete(key: 'password');
    }
  }

  Future<void> loadRememberStatus() async {
    String? userName = await userCredStorage.read(key: 'userName');
    String? password = await userCredStorage.read(key: 'password');
    if (userName != null || password != null) {
      rememberMe.value = true;
      userNameController.text = userName!;
      passwordController.text = password!;
    }
  }

  void rsnEnterCompany({
    String? userName,
    String? companyGUID,
    String? sessionID,
    String? userGUID,
  }) async {
    try {
      dynamic d =
          await enterCompany(userName, sessionID, companyGUID, userGUID);
      if (d["Status"] == '200') {
        rsnCollectRegId(
            apiToken: rsnSessionID, userGUID: d["Data"]["GUID"] ?? "");
      } else {
        showFlushBar(context: Get.context, title: d["Message"].toString());
      }
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  void rsnCollectRegId({String? apiToken, String? userGUID}) async {
    try {
      dynamic d = await collectRegInfo(apiToken, userGUID);
      if (d["Status"] == '200') {
        rsnCollectHandles(
            apiToken: rsnSessionID,
            relatedRegID: d["Data"]["RegID"].toString());
      } else {
        showFlushBar(context: Get.context, title: d["Message"].toString());
      }
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  void rsnCollectHandles({String? apiToken, String? relatedRegID}) async {
    try {
      dynamic d = await collectHandles(apiToken, relatedRegID);
      if (d["Status"] == '200') {
        isLoading.value = false;
        try {
          if (d["Data"] != null && d["Data"].isNotEmpty) {
            List avialableUsersList = d["Data"];
            log('Users List : $avialableUsersList');
            List systemUsersList = avialableUsersList
                .where((user) =>
                    (user["RoleTypeID"] == 1 && user["IsInternalUrl"] == 0))
                .toList();
            log('System List : $avialableUsersList');
            if (systemUsersList.length > 1) {
              Get.defaultDialog(
                  actions: [
                    GetX<LoginController>(
                      builder: (c) {
                        return c.isLoading.value
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () => Get.back(),
                                    child: Container(
                                      height: 40,
                                      width: 80,
                                      decoration: const BoxDecoration(
                                        color: AppColors.whiteColor,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(
                                            color: AppColors.blackColor,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  sizedWidth(20),
                                  GestureDetector(
                                    onTap: () {
                                      Get.back();
                                      showDialog(
                                        context: Get.context!,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return Dialog(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  CircularProgressIndicator(),
                                                  SizedBox(width: 16),
                                                  Text("Loading..."),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                      callR3Login(d["Data"]
                                          [selectedCompanyIndex.value]);
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 80,
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFF5660BF),
                                            Color(0xFF55C2D8),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'OK',
                                          style: TextStyle(
                                            color: AppColors.whiteColor,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                      },
                    ),
                  ],
                  title: 'Choose a Company :',
                  titleStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  content: showCompanyListDialog(d["Data"]));
            } else {
              callR3Login(systemUsersList[selectedCompanyIndex.value]);
            }
          }
        } catch (e) {
          rethrow;
        }
      } else {
        showFlushBar(context: Get.context, title: d["Message"].toString());
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  void callR3Login(d) async {
    DB.dbUserName = d["R3UserName"] ?? "";
    DB.dbPassword = d["R3Password"] ?? "";
    DB.dbCompanyGUID = d["R3GrpCompanyGUID"] ?? "";
    DB.dbR3Url = d["R3Url"] ?? "";

    //R3 MS will be captured later
    DB.dbR3ApiToken = d["R3APIToken"] ?? "";
    DB.dbR3ApiUrl = d["R3APIUrl"] ?? "";
    DB.dbR3RoleTypeID = d["RoleTypeID"].toString();

    await prefs?.setString('R3RoleTypeID', d["RoleTypeID"].toString());
    await prefs?.setString('R3Url', d["R3Url"] ?? "");
    await prefs?.setString('R3UserName', d["R3UserName"] ?? "");
    await prefs?.setString('R3Password', d["R3Password"] ?? "");
    await prefs?.setString('dbCompanyGUID', d["R3GrpCompanyGUID"] ?? "");

    r3RSNLogin(DB.dbUserName, DB.dbPassword, DB.dbCompanyGUID);
  }

  void r3RSNLogin(r3UserName, r3Password, r3CompanyGUID) async {
    isLoading.value = true;
    dynamic d = await r3Login(r3UserName, r3Password, r3CompanyGUID);
    if (d["Status"] == 200) {
      prefs?.setBool('isLoggedIn', true);
      prefs?.setString('r3UserName', r3UserName);
      isLoggedIn = true;
      await saveUserLoginCredentials(
        userName: userNameController.text,
        password: passwordController.text,
      );
      Get.offAllNamed(Routes.PUNCH_SCREEN);
    } else {
      isLoading.value = false;
      prefs?.setBool('isLoggedIn', false);
      showFlushBar(context: Get.context, title: d["Message"].toString());
    }
  }

  Widget showCompanyListDialog(data) {
    return GetX<LoginController>(
      builder: (controller) {
        return Container(
          height: Get.height * .5,
          width: Get.width * 0.8,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: ListView(
            children: data
                .map<Widget>(
                  (e) => GestureDetector(
                    onTap: () =>
                        controller.selectedCompanyIndex.value = data.indexOf(e),
                    child: (e["IsInternalUrl"] == 0 && e['RoleTypeID'] == 1)
                        ? Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 50,
                                  width: 20,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 7),
                                  decoration: BoxDecoration(
                                    color: selectedCompanyIndex.value ==
                                            data.indexOf(e)
                                        ? Color(0xFF5660BF)
                                        : Colors.white,
                                    border: Border.all(color: Colors.black),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: Get.width * 0.6,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: RichText(
                                          overflow: TextOverflow.fade,
                                          strutStyle:
                                              const StrutStyle(fontSize: 20),
                                          text: TextSpan(
                                            style: TextStyle(
                                              fontSize: 20,
                                              color:
                                                  selectedCompanyIndex.value ==
                                                          data.indexOf(e)
                                                      ? Color(0xFF5660BF)
                                                      : AppColors.blackColor,
                                            ),
                                            text: "${e["ProfileName"]}",
                                          ),
                                        ),
                                      ),
                                    ),
                                    sizedHeight(5),
                                    RichText(
                                      overflow: TextOverflow.ellipsis,
                                      strutStyle:
                                          const StrutStyle(fontSize: 14),
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: selectedCompanyIndex.value ==
                                                  data.indexOf(e)
                                              ? Colors.black87
                                              : AppColors.greenColor,
                                        ),
                                        text: e["_RoleTypeName"] ?? '',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
