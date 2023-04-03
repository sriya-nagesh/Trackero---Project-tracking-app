//Sriya Nagesh (SUKD1902368) BIT-UCLAN
import 'package:trackero/export.dart';

class TeamProjectModel {
  String? ownerID;
  String? ownerEmail;
  List<String>? members;
  String? teamProjID;
  String? teamProjName;
  DateTime? created;
  String? vision;
  String? mission;
  bool? done;

  TeamProjectModel(
      {this.ownerID,
      this.ownerEmail,
      this.members,
      this.teamProjID,
      this.teamProjName,
      this.created,
      this.vision,
      this.mission,
      this.done});

  factory TeamProjectModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return TeamProjectModel(
      ownerID: data?['ownerID'],
      ownerEmail: data?['ownerEmail'],
      members:
          data?['members'] is Iterable ? List.from(data?['members']) : null,
      teamProjName: data?['teamProjName'],
      created: data?['created'].toDate(),
      vision: data?['vision'],
      mission: data?['mission'],
      done: data?['done'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (ownerID != null) "ownerID": ownerID,
      if (ownerEmail != null) "owneremail": ownerEmail,
      if (members != null) "members": members,
      if (teamProjName != null) "teamProjName": teamProjName,
      if (created != null) "created": created,
      if (vision != null) "vision": vision,
      if (mission != null) "mission": mission,
      if (done != null) "done": done,
    };
  }

  TeamProjectModel.fromSnapshot(snapshot)
      : ownerID = snapshot.data()['ownerID'],
        ownerEmail = snapshot.data()['ownerEmail'],
        teamProjID = snapshot.data()['teamProjID'],
        teamProjName = snapshot.data()['teamProjName'],
        created = snapshot.data()['created'].toDate(),
        vision = snapshot.data()['vision'],
        mission = snapshot.data()['mission'],
        done = snapshot.data()['done'];
}

//function to create team project
class TeamProject {
  Future createTeamProject(String ownerID, ownerEmail, teamProjName, created,
      vision, mission, done) async {
    var project = await teamproject.add({
      "ownerID": ownerID,
      "ownerEmail": ownerEmail,
      "members": [],
      "teamProjName": teamProjName,
      "created": created,
      "vision": vision,
      "mission": mission,
      "done": done,
    });
    await addTeamSubCollections(id: project.id);
  }
}

//create subcollections for team project
Future addTeamSubCollections({String? id}) async {
  teamproject.doc(id).collection('goals').add({
    'projectID': "123",
  });

  final emailSnapshot = user.email.toString();
  String email = emailSnapshot.replaceAll(RegExp(r'[^\w\s]+'), '');
  teamproject.doc(id).collection('tasks').doc('durationmembers').set({
    email: 0,
  });

  teamproject.doc(id).collection('risks').add({
    'projectID': "123",
  });

  teamproject.doc(id).collection('issues').add({
    'projectID': "123",
  });

  teamproject.doc(id).collection('chatbox').add({
    'assigned': user.email,
    'message': "Team chatroom has been created!",
    'sent': DateTime.now(),
  });

  teamproject.doc(id).collection('files').add({
    'filename': "",
    'projectID': "",
  });
}
