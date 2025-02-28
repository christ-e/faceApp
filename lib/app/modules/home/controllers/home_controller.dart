// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:facerecognition_flutter/app/data/person_model.dart';
import 'package:facerecognition_flutter/app/modules/settings/controllers/settings_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:facesdk_plugin/facesdk_plugin.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class HomeController extends GetxController {
  final _facesdkPlugin = FacesdkPlugin();
  var personList = <Person>[].obs;
  var warningState = "".obs;
  var visibleWarning = false.obs;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    int facepluginState = -1;
    String warningState = "";
    bool visibleWarning = false;

    try {
      if (Platform.isAndroid) {
        await _facesdkPlugin
            .setActivation(
                "j63rQnZifPT82LEDGFa+wzorKx+M55JQlNr+S0bFfvMULrNYt+UEWIsa11V/Wk1bU9Srti0/FQqp"
                "UczeCxFtiEcABmZGuTzNd27XnwXHUSIMaFOkrpNyNE4MHb7HBm5kU/0J/SAMfybICCWyFajuZ4fL"
                "agozJV5DPKj22oFVaueWMjO/9fMvcps4u1AIiHH2rjP4mEYfiAE8nhHBa1Ou3u/WkXj6jdDafyJo"
                "AFtQHYJYKDU+hcbtCZ3P1f8y1JB5JxOf92ItK4euAt6/OFG9jGfKpo/Fs2mAgwxH3HoWMLJQ16Iy"
                "u2K6boMyDxRQtBJFTiktuJ+ltlay+dVqIi3Jpg==")
            .then((value) => facepluginState = value ?? -1);
      } else {
        await _facesdkPlugin
            .setActivation(
                "nWsdDhTp12Ay5yAm4cHGqx2rfEv0U+Wyq/tDPopH2yz6RqyKmRU+eovPeDcAp3T3IJJYm2LbPSEz"
                "+e+YlQ4hz+1n8BNlh2gHo+UTVll40OEWkZ0VyxkhszsKN+3UIdNXGaQ6QL0lQunTwfamWuDNx7Ss"
                "efK/3IojqJAF0Bv7spdll3sfhE1IO/m7OyDcrbl5hkT9pFhFA/iCGARcCuCLk4A6r3mLkK57be4r"
                "T52DKtyutnu0PDTzPeaOVZRJdF0eifYXNvhE41CLGiAWwfjqOQOHfKdunXMDqF17s+LFLWwkeNAD"
                "PKMT+F/kRCjnTcC8WPX3bgNzyUBGsFw9fcneKA==")
            .then((value) => facepluginState = value ?? -1);
      }

      if (facepluginState == 0) {
        await _facesdkPlugin
            .init()
            .then((value) => facepluginState = value ?? -1);
      }
    } catch (e) {}

    List<Person> personList = await loadAllPersons();
    await SettingsController.initSettings();

    final prefs = await SharedPreferences.getInstance();
    int? livenessLevel = prefs.getInt("liveness_level");

    try {
      await _facesdkPlugin
          .setParam({'check_liveness_level': livenessLevel!});
    } catch (e) {}

    if (facepluginState == -1) {
      warningState = "Invalid license!";
      visibleWarning = true;
    } else if (facepluginState == -2) {
      warningState = "License expired!";
      visibleWarning = true;
    } else if (facepluginState == -3) {
      warningState = "Invalid license!";
      visibleWarning = true;
    } else if (facepluginState == -4) {
      warningState = "No activated!";
      visibleWarning = true;
    } else if (facepluginState == -5) {
      warningState = "Init error!";
      visibleWarning = true;
    }

    this.warningState.value = warningState;
    this.visibleWarning.value = visibleWarning;
    this.personList.value = personList;
  }

  Future<Database> createDB() async {
    final database = openDatabase(join(await getDatabasesPath(), 'person.db'),
        version: 2, onCreate: (db, version) {
      return db.execute('''
        CREATE TABLE person (
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          name TEXT, 
          empid TEXT, 
          designation TEXT, 
          faceJpg BLOB, 
          templates BLOB
        )
        ''');
    }, onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute("ALTER TABLE person ADD COLUMN empid TEXT");
        await db.execute("ALTER TABLE person ADD COLUMN designation TEXT");
      }
    });

    return database;
  }

  Future<List<Person>> loadAllPersons() async {
    final db = await createDB();
    final List<Map<String, dynamic>> maps = await db.query('person');
    return List.generate(maps.length, (i) {
      return Person.fromMap(maps[i]);
    });
  }

  Future<void> insertPerson(Person person) async {
    final db = await createDB();
    await db.insert(
      'person',
      person.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    personList.add(person);
  }

  Future<void> deleteAllPerson() async {
    final db = await createDB();
    await db.delete('person');

    personList.clear();

    Fluttertoast.showToast(
        msg: "All person deleted!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<void> deletePerson(int index) async {
    final db = await createDB();
    await db.delete(
      'person',
      where: 'name=?',
      whereArgs: [personList[index].name],
    );

    personList.removeAt(index);

    Fluttertoast.showToast(
      msg: "Person removed!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  Future enrollPerson() async {
    TextEditingController nameController = TextEditingController();
    TextEditingController designationController = TextEditingController();
    TextEditingController empIdController = TextEditingController();

    await Get.dialog(
      AlertDialog(
        title: Text("Enter Employee Details"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(hintText: "Employee Name"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: designationController,
              decoration: InputDecoration(hintText: "Designation"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: empIdController,
              decoration: InputDecoration(hintText: "Employee ID"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  designationController.text.isNotEmpty &&
                  empIdController.text.isNotEmpty) {
                Get.back(result: {
                  'name': nameController.text,
                  'designation': designationController.text,
                  'empId': empIdController.text,
                });
              } else {
                Fluttertoast.showToast(
                  msg: "Please fill all fields!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                );
              }
            },
            child: Text("OK"),
          ),
        ],
      ),
    ).then((enteredData) async {
      if (enteredData == null) return;

      try {
        final image = await ImagePicker().pickImage(source: ImageSource.camera);
        if (image == null) return;

        var rotatedImage =
            await FlutterExifRotation.rotateImage(path: image.path);

        final faces = await _facesdkPlugin.extractFaces(rotatedImage.path);
        for (var face in faces) {
          Person person = Person(
            name: enteredData['name'],
            designation: enteredData['designation'],
            empid: enteredData['empId'],
            faceJpg: face['faceJpg'],
            templates: face['templates'],
          );
          insertPerson(person);
        }

        Fluttertoast.showToast(
          msg: faces.isEmpty ? "No face detected!" : "Person enrolled!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: faces.isEmpty ? Colors.red : Colors.green,
          textColor: Colors.white,
        );
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Error enrolling person!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    });
  }
}