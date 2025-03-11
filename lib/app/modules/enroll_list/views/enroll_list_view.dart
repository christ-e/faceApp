import 'package:facerecognition_flutter/app/modules/enroll_list/controllers/enroll_list_controller.dart';
import 'package:facerecognition_flutter/utils/app_size_box.dart';
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
                  sizedHeight(10),
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
                  sizedHeight(10),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: controller.employees.length,
                    separatorBuilder: (context, index) => sizedHeight(6),
                    itemBuilder: (context, index) {
                      final employee = controller.employees[index];

                      return Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(employee.imageUrl),
                            radius: 40.r,
                          ),
                          title: Text(
                            employee.name,
                            style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.blackColor),
                          ),
                          subtitle: Text(
                            employee.empId,
                            style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textColorgrey),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (employee.enroll)
                                SvgPicture.asset(
                                  height: 22.h,
                                  width: 18.w,
                                  ImageContants.verfiedUser,
                                ),
                              sizedWidth(10),
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
                    fontSize: 12.sp,
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
          height: 33.h,
          decoration: BoxDecoration(
              color: selectedStatus.value == "Filter"
                  ? AppColors.whiteColor
                  : AppColors.blueColor,
              border: Border.all(color: AppColors.boderColorgrey2),
              borderRadius: BorderRadius.circular(4.r)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 8.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selectedStatus.value,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: selectedStatus.value == "Filter"
                        ? Colors.black
                        : AppColors.whiteColor,
                  ),
                ),
                sizedWidth(5),
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
