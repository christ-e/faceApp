import 'package:facerecognition_flutter/app/modules/face_recognition/bindings/face_recognition_binding.dart';
import 'package:facerecognition_flutter/app/modules/face_recognition/views/face_recognition_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Recognition'),
        toolbarHeight: 70,
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 6,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: ElevatedButton.icon(
                      label: const Text('Enroll'),
                      icon: const Icon(
                        Icons.person_add,
                      ),
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          )),
                      onPressed: () {
                        controller.enrollPerson();
                      }),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 1,
                  child: ElevatedButton.icon(
                      label: const Text('Identify'),
                      icon: const Icon(
                        Icons.person_search,
                      ),
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          )),
                      onPressed: () {
                        Get.to(() => FaceRecognitionView(),binding: FaceRecognitionBinding());
                      }),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Expanded(
                child: Obx(() => ListView.builder(
                    itemCount: controller.personList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey[300],
                            backgroundImage:
                                controller.personList[index].faceJpg.isNotEmpty
                                    ? MemoryImage(
                                        controller.personList[index].faceJpg)
                                    : null,
                            child: controller.personList[index].faceJpg.isEmpty
                                ? Icon(Icons.person,
                                    size: 30, color: Colors.grey[700])
                                : null,
                          ),
                          title: Text(
                            controller.personList[index].name,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Employee ID: ${controller.personList[index].empid}",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey[700])),
                                SizedBox(height: 4),
                                Text(
                                    "Designation: ${controller.personList[index].designation}",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey[700])),
                              ],
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => controller.deletePerson(index),
                          ),
                        ),
                      );
                    }))),
            const SizedBox(
              height: 4,
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
