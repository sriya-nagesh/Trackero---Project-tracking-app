//Sriya Nagesh (SUKD1902368) BIT-UCLAN
import 'package:trackero/export.dart';

class TeamGoalsModel {
  String? teamGoalID;
  String? teamGoalName;
  DateTime created;
  String? projectID;

  TeamGoalsModel(
      {this.teamGoalID,
      this.teamGoalName,
      required this.created,
      this.projectID});
}

//function to create goal in team project
class AddTeamGoals {
  Future createTeamGoalsModel(String teamGoalName, created, projectID) async {
    await teamproject.doc(projectID).collection('goals').add({
      "teamGoalName": teamGoalName,
      "created": created,
      "projectID": projectID,
    });
  }
}
