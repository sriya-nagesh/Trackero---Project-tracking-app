//Sriya Nagesh (SUKD1902368) BIT-UCLAN
import 'package:trackero/export.dart';

class TeamRisksModel {
  String? teamRiskID;
  String? teamRiskName;
  DateTime created;
  String? projectID;
  String? probability;
  String? severity;

  TeamRisksModel({
    this.teamRiskID,
    this.teamRiskName,
    required this.created,
    this.projectID,
    this.probability,
    this.severity,
  });
}

//function to create risk in team project
class AddTeamRisks {
  Future createTeamRisksModel(
      String teamRiskName, created, projectID, probability, severity) async {
    await teamproject.doc(projectID).collection('risks').add({
      "teamRiskName": teamRiskName,
      "created": created,
      "projectID": projectID,
      "probability": probability,
      "severity": severity,
    });
  }
}
