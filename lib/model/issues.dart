//Sriya Nagesh (SUKD1902368) BIT-UCLAN
import 'package:trackero/export.dart';

CollectionReference personalIssueCollection = FirebaseFirestore.instance
    .collection("users")
    .doc(user.uid)
    .collection("personalproject");

class PersonalIssuesModel {
  String? personalIssueID;
  String? personalIssueName;
  DateTime created;
  String? projectID;
  String? personalIssueDescription;

  PersonalIssuesModel(
      {this.personalIssueID,
      this.personalIssueName,
      required this.created,
      this.projectID,
      this.personalIssueDescription});
}

//function to create issue in personal project
class AddPersonalIssues {
  Future createPersonalIssuesModel(String personalIssueName, created, projectID,
      personalIssueDescription) async {
    await personalIssueCollection.doc(projectID).collection('issues').add({
      "personalIssueName": personalIssueName,
      "created": created,
      "projectID": projectID,
      "personalIssueDescription": personalIssueDescription,
    });
  }
}
