//Sriya Nagesh (SUKD1902368) BIT-UCLAN
import 'package:trackero/export.dart';

CollectionReference personalRiskCollection = FirebaseFirestore.instance
    .collection("users")
    .doc(user.uid)
    .collection("personalproject");

class PersonalRisksModel {
  String? personalRiskID;
  String? personalRiskName;
  DateTime created;
  String? projectID;
  String? probability;
  String? severity;

  PersonalRisksModel({
    this.personalRiskID,
    this.personalRiskName,
    required this.created,
    this.projectID,
    this.probability,
    this.severity,
  });
}

//function to create risk in personal project
class AddPersonalRisks {
  Future createPersonalRisksModel(String personalRiskName, created, projectID,
      probability, severity) async {
    await personalRiskCollection.doc(projectID).collection('risks').add({
      "personalRiskName": personalRiskName,
      "created": created,
      "projectID": projectID,
      "probability": probability,
      "severity": severity,
    });
  }
}
