//Sriya Nagesh (SUKD1902368) BIT-UCLAN
import 'package:trackero/export.dart';

class TeamIssuesModel {
  String? teamIssueID;
  String? teamIssueName;
  DateTime created;
  String? projectID;
  String? teamIssueDescription;

  TeamIssuesModel(
      {this.teamIssueID,
      this.teamIssueName,
      required this.created,
      this.projectID,
      this.teamIssueDescription});
}

//function to create issue in team project
class AddTeamIssues {
  Future createTeamIssuesModel(
      String teamIssueName, created, projectID, teamIssueDescription) async {
    await teamproject.doc(projectID).collection('issues').add({
      "teamIssueName": teamIssueName,
      "created": created,
      "projectID": projectID,
      "teamIssueDescription": teamIssueDescription,
    });
  }
}
