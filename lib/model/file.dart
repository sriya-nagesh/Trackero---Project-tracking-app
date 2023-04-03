//Sriya Nagesh (SUKD1902368) BIT-UCLAN
import 'package:trackero/export.dart';

class TeamFileModel {
  String? name;
  String? url;
  String? created;
  String? projectID;
  String? filename;

  TeamFileModel(
      {this.name,
      this.url,
      required this.created,
      this.projectID,
      this.filename});
}

//function to create file
class AddTeamFile {
  Future createTeamFileModel(
      String name, created, url, projectID, filename) async {
    await teamproject.doc(projectID).collection('files').add({
      "name": name,
      "created": created,
      "url": url,
      "projectID": projectID,
      "filename": filename,
    });
  }
}
