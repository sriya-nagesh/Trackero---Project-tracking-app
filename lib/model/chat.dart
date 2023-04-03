//Sriya Nagesh (SUKD1902368) BIT-UCLAN
import 'package:trackero/export.dart';

class TeamChatModel {
  String? assigned;
  String? message;
  DateTime sent;

  TeamChatModel({
    this.assigned,
    this.message,
    required this.sent,
  });
}

//function to create chat
class AddTeamChat {
  Future createTeamChatModel(String assigned, message, sent, projectID) async {
    await teamproject.doc(projectID).collection('chatbox').add({
      "assigned": assigned,
      "message": message,
      "sent": sent,
    });
  }
}
