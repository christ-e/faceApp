import 'package:facerecognition_flutter/controller/main_screen_controller.dart';
import 'package:flutter/material.dart';
import 'person.dart';
import 'main.dart';

// ignore: must_be_immutable
class PersonView extends StatefulWidget {
  final List<Person> personList;
  final MyHomePageState homePageState;

  const PersonView(
      {super.key, required this.personList, required this.homePageState});

  @override
  _PersonViewState createState() => _PersonViewState();
}

class _PersonViewState extends State<PersonView> {
  deletePerson(int index) async {
    await widget.homePageState.deletePerson(context, index);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.personList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4, // Adds shadow effect
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[300],
                backgroundImage: widget.personList[index].faceJpg.isNotEmpty
                    ? MemoryImage(widget.personList[index].faceJpg)
                    : null,
                child: widget.personList[index].faceJpg.isEmpty
                    ? Icon(Icons.person, size: 30, color: Colors.grey[700])
                    : null,
              ),
              title: Text(
                widget.personList[index].name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Employee ID: ${widget.personList[index].empid}",
                        style:
                            TextStyle(fontSize: 14, color: Colors.grey[700])),
                    SizedBox(height: 4),
                    Text("Designation: ${widget.personList[index].designation}",
                        style:
                            TextStyle(fontSize: 14, color: Colors.grey[700])),
                  ],
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => deletePerson(index),
              ),
            ),
          );

          // SizedBox(
          //     height: 200,
          //     child: Card(
          //         child: Row(
          //       children: [
          //         const SizedBox(
          //           width: 16,
          //         ),
          //         ClipRRect(
          //           borderRadius: BorderRadius.circular(28.0),
          //           child: Image.memory(
          //             widget.personList[index].faceJpg,
          //             width: 56,
          //             height: 56,
          //           ),
          //         ),
          //         const SizedBox(
          //           width: 16,
          //         ),
          //         Column(
          //           children: [
          //             Text(widget.personList[index].empid),
          //             SizedBox(
          //               height: 10,
          //             ),
          //             Text(widget.personList[index].name),
          //             SizedBox(
          //               height: 10,
          //             ),
          //             Text(widget.personList[index].designation),
          //           ],
          //         ),
          //         const Spacer(),
          // IconButton(
          //   icon: const Icon(Icons.delete),
          //   onPressed: () => deletePerson(index),
          // ),
          //         const SizedBox(
          //           width: 8,
          //         )
          //       ],
          //     )));
        });
  }
}
