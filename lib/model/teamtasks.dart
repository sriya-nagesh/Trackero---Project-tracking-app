//Sriya Nagesh (SUKD1902368) BIT-UCLAN
import 'package:trackero/export.dart';

class TeamTasksModel {
  String? assigned;
  String? teamTaskID;
  String? teamTaskName;
  DateTime created;
  String? projectID;
  String? teamTaskDescription;
  DateTime? dueDate;
  bool? done;
  DateTime? completed;
  double? time;
  String? priority;

  TeamTasksModel({
    this.assigned,
    this.teamTaskID,
    this.teamTaskName,
    required this.created,
    this.projectID,
    this.teamTaskDescription,
    this.dueDate,
    this.done,
    this.completed,
    this.time,
    this.priority,
  });
}

//function to create task in team project
class AddTeamTasks {
  Future createTeamTasksModel(String assigned, teamTaskName, created, projectID,
      teamTaskDescription, dueDate, done, completed, time, priority) async {
    await teamproject.doc(projectID).collection('tasks').add({
      "assigned": assigned,
      "teamTaskName": teamTaskName,
      "created": created,
      "projectID": projectID,
      "teamTaskDescription": teamTaskDescription,
      "dueDate": dueDate,
      "done": done,
      "completed": completed,
      "time": time,
      "priority": priority,
    });
  }
}
