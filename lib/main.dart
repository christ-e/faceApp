// ignore_for_file: depend_on_referenced_packages

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
import 'settings.dart';
import 'person.dart';
import 'personview.dart';
import 'facedetectionview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Face Recognition',
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
        ),
        home: MyHomePage(title: 'Face Recognition'));
  }
}

// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  final String title;
  var personList = <Person>[];

  MyHomePage({super.key, required this.title});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  String _warningState = "";
  bool _visibleWarning = false;

  final _facesdkPlugin = FacesdkPlugin();

  @override
  void initState() {
    super.initState();

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
    if (!mounted) return;

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

    setState(() {
      _warningState = warningState;
      _visibleWarning = visibleWarning;
      widget.personList = personList;
    });
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

    setState(() {
      widget.personList.add(person);
    });
  }

  Future<void> deleteAllPerson() async {
    final db = await createDB();
    await db.delete('person');

    setState(() {
      widget.personList.clear();
    });

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
        whereArgs: [widget.personList[index].name],
      );

      setState(() {
        widget.personList.removeAt(index);
      });

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
                        // color: Colors.white70,
                      ),
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          // foregroundColor: Colors.white70,
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          )),
                      onPressed: () {
                        enrollPerson(context);
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FaceRecognitionView(
                                    personList: widget.personList,
                                  )),
                        );
                      }),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Row(
            //   children: <Widget>[
            //     Expanded(
            //       flex: 1,
            //       child: ElevatedButton.icon(
            //           label: const Text('Settings'),
            //           icon: const Icon(
            //             Icons.settings,
            //           ),
            //           style: ElevatedButton.styleFrom(
            //               padding: const EdgeInsets.only(top: 10, bottom: 10),
            //               backgroundColor:
            //                   Theme.of(context).colorScheme.primaryContainer,
            //               shape: const RoundedRectangleBorder(
            //                 borderRadius:
            //                     BorderRadius.all(Radius.circular(12.0)),
            //               )),
            //           onPressed: () {
            //             Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) => SettingsPage(
            //                         homePageState: this,
            //                       )),
            //             );
            //           }),
            //     ),
            //     const SizedBox(width: 20),
            //   ],
            // ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
                child: Stack(
              children: [
                PersonView(
                  personList: widget.personList,
                  homePageState: this,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Visibility(
                        visible: _visibleWarning,
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          color: Colors.redAccent,
                          child: Center(
                            child: Text(
                              _warningState,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ))
                  ],
                )
              ],
            )),
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
