import 'package:facerecognition_flutter/person.dart';
import 'package:facerecognition_flutter/settings.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:facesdk_plugin/facesdk_plugin.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;
import 'package:get/get.dart';

class MainScreenController extends GetxController {
  RxString title = 'Face Recognition'.obs;
  var personList = <Person>[];
  RxString warningState = "".obs;
  RxBool visibleWarning = false.obs;

  final _facesdkPlugin = FacesdkPlugin();

  @override
  void onInit() {
    super.onInit();

    init();
  }

  Future<void> init() async {
    int facepluginState = -1;
    String warningstate = "";
    bool visiblewarning = false;

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

    List<Person> personlist = await loadAllPersons();
    await SettingsPageState.initSettings();

    final prefs = await SharedPreferences.getInstance();
    int? livenessLevel = prefs.getInt("liveness_level");

    try {
      await _facesdkPlugin
          .setParam({'check_liveness_level': livenessLevel ?? 0});
    } catch (e) {}

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    // if (!mounted) return;

    if (facepluginState == -1) {
      warningstate = "Invalid license!";
      visiblewarning = true;
    } else if (facepluginState == -2) {
      warningstate = "License expired!";
      visiblewarning = true;
    } else if (facepluginState == -3) {
      warningstate = "Invalid license!";
      visiblewarning = true;
    } else if (facepluginState == -4) {
      warningstate = "No activated!";
      visiblewarning = true;
    } else if (facepluginState == -5) {
      warningstate = "Init error!";
      visiblewarning = true;
    }

    warningState.value = warningstate;
    visibleWarning.value = visiblewarning;
    personList = personlist;
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

  // A method that retrieves all the dogs from the dogs table.
  Future<List<Person>> loadAllPersons() async {
    // Get a reference to the database.
    final db = await createDB();

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('person');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Person.fromMap(maps[i]);
    });
  }

  Future<void> insertPerson(Person person) async {
    // Get a reference to the database.
    final db = await createDB();

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
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

  Future<void> deletePerson(BuildContext context, int index) async {
    // Show confirmation dialog before deleting
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this person?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Cancel
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(true), // Confirm Delete
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    // If user cancels, do nothing
    if (confirmDelete == null || !confirmDelete) return;

    try {
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
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error deleting person!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future enrollPerson(BuildContext context) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController designationController = TextEditingController();
    TextEditingController empIdController = TextEditingController();

    // Show an AlertDialog to enter the employee details
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
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
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    designationController.text.isNotEmpty &&
                    empIdController.text.isNotEmpty) {
                  Navigator.of(context).pop({
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
        );
      },
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
