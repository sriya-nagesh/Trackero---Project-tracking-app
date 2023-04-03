//Sriya Nagesh (SUKD1902368) BIT-UCLAN
import 'package:trackero/export.dart';

CollectionReference personalTaskCollection = FirebaseFirestore.instance
    .collection("users")
    .doc(user.uid)
    .collection("personalproject");

class PersonalTasksModel {
  String? personalTaskID;
  String? personalTaskName;
  DateTime created;
  String? projectID;
  String? personalTaskDescription;
  DateTime? dueDate;
  bool? done;
  DateTime? completed;
  double? time;
  String? priority;

  PersonalTasksModel({
    this.personalTaskID,
    this.personalTaskName,
    required this.created,
    this.projectID,
    this.personalTaskDescription,
    this.dueDate,
    this.done,
    this.completed,
    this.time,
    this.priority,
  });
}

//function to create task in personal project
class AddPersonalTasks {
  Future createPersonalTasksModel(String personalTaskName, created, projectID,
      personalTaskDescription, dueDate, done, completed, time, priority) async {
    await personalTaskCollection.doc(projectID).collection('tasks').add({
      "personalTaskName": personalTaskName,
      "created": created,
      "projectID": projectID,
      "personalTaskDescription": personalTaskDescription,
      "dueDate": dueDate,
      "done": done,
      "completed": completed,
      "time": time,
      "priority": priority,
    });
  }
}
