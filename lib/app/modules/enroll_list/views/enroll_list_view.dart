import 'package:facerecognition_flutter/app/modules/enroll_list/controllers/enroll_list_controller.dart';
import 'package:facerecognition_flutter/utils/color_const.dart';
import 'package:facerecognition_flutter/utils/image_const.dart';
import 'package:facerecognition_flutter/widgets/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class EnrollListView extends GetView<EnrollListController> {
  const EnrollListView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(248, 248, 248, 1),
        body: Column(
          children: [
            CommonAppbar(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      // sizedWidth(10),
                      Text(
                        "Enroll List",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.blackColor),
                      ),
                      Spacer(),
                      dropDown(context)
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: controller.employees.length,
                    separatorBuilder: (context, index) => SizedBox(height: 6),
                    itemBuilder: (context, index) {
                      final employee = controller.employees[index];

                      return Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(employee.imageUrl),
                            radius: 40,
                          ),
                          title: Text(
                            employee.name,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: AppColors.blackColor),
                          ),
                          subtitle: Text(
                            employee.empId,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textColorgrey),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (employee.enroll)
                                SvgPicture.asset(
                                  height: 22,
                                  width: 18,
                                  ImageContants.verfiedUser,
                                ),
                              SizedBox(width: 10),
                              SvgPicture.asset(employee.enroll
                                  ? ImageContants.editUser
                                  : ImageContants.enrollUser),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            )
          ],
        ));
  }

  Widget dropDown(BuildContext context) {
    RxString selectedStatus = "Filter".obs;
    return Obx(() {
      return GestureDetector(
        onTap: () {
          showMenu(
            color: Colors.white,
            context: context,
            position: RelativeRect.fromLTRB(100, 100, 0, 0),
            items: [
              PopupMenuItem(
                enabled: false,
                child: Text(
                  "Filter sales by Status",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(113, 113, 122, 1),
                  ),
                ),
              ),
              PopupMenuItem(
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RadioListTile<String>(
                          title: Text(
                            "Pending",
                            style: TextStyle(color: AppColors.blackColor),
                          ),
                          value: "Pending",
                          groupValue: selectedStatus.value,
                          onChanged: (value) {
                            selectedStatus.value = value!;

                            Get.back(closeOverlays: true);
                          },
                        ),
                        RadioListTile<String>(
                          title: Text(
                            "Enroll",
                            style: TextStyle(color: AppColors.blackColor),
                          ),
                          value: "Enroll",
                          groupValue: selectedStatus.value,
                          onChanged: (value) {
                            selectedStatus.value = value!;

                            Get.back(closeOverlays: true);
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
        child: Container(
          height: 33,
          decoration: BoxDecoration(
              color: selectedStatus.value == "Filter"
                  ? AppColors.whiteColor
                  : AppColors.blueColor,
              border: Border.all(color: AppColors.boderColorgrey2),
              borderRadius: BorderRadius.circular(4)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selectedStatus.value,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: selectedStatus.value == "Filter"
                        ? Colors.black
                        : AppColors.whiteColor,
                  ),
                ),
                SizedBox(width: 5),
                SvgPicture.asset(
                  "assets/svg/down-arrow.svg",
                  colorFilter: ColorFilter.mode(
                      selectedStatus.value == "Filter"
                          ? Colors.grey
                          : Colors.white,
                      BlendMode.srcIn),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
