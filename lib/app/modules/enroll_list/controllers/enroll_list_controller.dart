import 'package:get/get.dart';

class EnrollListController extends GetxController {
  var employees = <Employee>[].obs;

  @override
  void onInit() {
    super.onInit();
    employees.addAll(Employee.getDummyData());
  }
}

class Employee {
  int id;
  String name;
  String empId;
  bool enroll;
  String imageUrl;

  Employee({
    required this.id,
    required this.name,
    required this.empId,
    required this.enroll,
    required this.imageUrl,
  });

  static List<Employee> getDummyData() {
    return [
      Employee(
          id: 1,
          name: "Alice Johnson",
          empId: "E1001",
          enroll: true,
          imageUrl:
              "https://images.unsplash.com/photo-1499952127939-9bbf5af6c51c?w=600&auto=format&fit=crop&q=60"),
      Employee(
          id: 2,
          name: "Bob Smith",
          empId: "E1002",
          enroll: false,
          imageUrl:
              "https://plus.unsplash.com/premium_photo-1689977968861-9c91dbb16049?w=600&auto=format&fit=crop&q=60"),
      Employee(
          id: 3,
          name: "Charlie Brown",
          empId: "E1003",
          enroll: true,
          imageUrl:
              "https://images.unsplash.com/flagged/photo-1570612861542-284f4c12e75f?w=600&auto=format&fit=crop&q=60"),
      Employee(
          id: 4,
          name: "David Williams",
          empId: "E1004",
          enroll: false,
          imageUrl:
              "https://plus.unsplash.com/premium_photo-1671656349322-41de944d259b?w=600&auto=format&fit=crop&q=60"),
    ];
  }
}
