//Sriya Nagesh (SUKD1902368) BIT-UCLAN
import 'package:trackero/export.dart';

CollectionReference personalGoalCollection = FirebaseFirestore.instance
    .collection("users")
    .doc(user.uid)
    .collection("personalproject");

class PersonalGoalsModel {
  String? personalGoalID;
  String? personalGoalName;
  DateTime created;
  String? projectID;

  PersonalGoalsModel(
      {this.personalGoalID,
      this.personalGoalName,
      required this.created,
      this.projectID});
}

//function to create goal in personal project
class AddPersonalGoals {
  Future createPersonalGoalsModel(
      String personalGoalName, created, projectID) async {
    await personalGoalCollection.doc(projectID).collection('goals').add({
      "personalGoalName": personalGoalName,
      "created": created,
      "projectID": projectID,
    });
  }
}
