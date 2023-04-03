import 'package:trackero/export.dart';

CollectionReference personalprojectCollection = FirebaseFirestore.instance
    .collection("users")
    .doc(currentuser.uid)
    .collection("personalproject");
final currentuser = FirebaseAuth.instance.currentUser!;

class PersonalProjectModel {
  String? personalProjID;
  String? personalProjName;
  DateTime? created;
  String? userID;
  String? vision;
  String? mission;
  bool? done;

  PersonalProjectModel(
      {this.personalProjID,
      this.personalProjName,
      this.created,
      this.userID,
      this.vision,
      this.mission,
      this.done});

  factory PersonalProjectModel.fromMap(map) {
    return PersonalProjectModel(
      personalProjID: map['personalProjID'],
      personalProjName: map['personalProjName'],
      created: map['created'],
      userID: map['userID'],
      vision: map['vision'],
      mission: map['mission'],
      done: map['done'],
    );
  }

  factory PersonalProjectModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return PersonalProjectModel(
      personalProjName: data?['personalProjName'],
      created: data?['created'].toDate(),
      userID: data?['userID'],
      vision: data?['vision'],
      mission: data?['mission'],
      done: data?['done'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (personalProjName != null) "personalProjName": personalProjName,
      if (created != null) "created": created,
      if (userID != null) "userID": userID,
      if (vision != null) "vision": vision,
      if (mission != null) "mission": mission,
      if (done != null) "done": done,
    };
  }

  PersonalProjectModel.fromSnapshot(snapshot)
      : personalProjID = snapshot.data()['personalProjID'],
        personalProjName = snapshot.data()['personalProjName'],
        created = snapshot.data()['created'].toDate(),
        userID = snapshot.data()['userID'],
        vision = snapshot.data()['vision'],
        mission = snapshot.data()['mission'],
        done = snapshot.data()['done'];
}

//function to create personal project
class PersonalProject {
  Future createPersonalProject(
      String personalProjName, created, userID, vision, mission, done) async {
    var project = await personalprojectCollection.add({
      "personalProjName": personalProjName,
      "created": created,
      "userID": userID,
      "vision": vision,
      "mission": mission,
      "done": done,
    });
    await addPersonalSubCollections(id: project.id);
  }
}

//add subcollections for personal project
Future addPersonalSubCollections({String? id}) async {
  personalprojectCollection.doc(id).collection('goals').add({
    'projectID': "123",
  });

  personalprojectCollection.doc(id).collection('tasks').add({
    'projectID': "123",
  });

  personalprojectCollection.doc(id).collection('risks').add({
    'projectID': "123",
  });

  personalprojectCollection.doc(id).collection('issues').add({
    'projectID': "123",
  });
}
