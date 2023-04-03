//Sriya Nagesh (SUKD1902368) BIT-UCLAN
import 'package:trackero/export.dart';

class CompletedProjects extends StatefulWidget {
  const CompletedProjects({Key? key}) : super(key: key);

  @override
  State<CompletedProjects> createState() => _CompletedProjectsState();
}

class _CompletedProjectsState extends State<CompletedProjects> {
  String teamprojectname = "";
  TextEditingController teamProjectNamecontroller = TextEditingController();
  TextEditingController updateTeamProjectNamecontroller =
      TextEditingController();
  final CollectionReference teamproject =
      FirebaseFirestore.instance.collection('teamproject');
  final user = FirebaseAuth.instance.currentUser!;
  String personalprojectname = "";
  TextEditingController personalProjectNamecontroller = TextEditingController();
  TextEditingController updatePersonalProjectNamecontroller =
      TextEditingController();
  final CollectionReference personalproject = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser.toString())
      .collection('personalproject');

  @override
  void dispose() {
    teamProjectNamecontroller.dispose();
    updateTeamProjectNamecontroller.dispose();
    personalProjectNamecontroller.dispose();
    updatePersonalProjectNamecontroller.dispose();
    super.dispose();
  }

//update personal project
  Future<void> updatePersonal([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      personalprojectname = documentSnapshot['personalProjName'];
    }
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              "Edit Project Name",
              style: lightblue,
            ),
          ),
          content: Container(
            height: 50,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 205, 205, 205),
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              controller: updatePersonalProjectNamecontroller
                ..text = personalprojectname,
              onChanged: (String value) {
                personalprojectname = value;
              },
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 40),
                border: InputBorder.none,
                hintStyle: textbox,
              ),
              style: textbox,
              textInputAction: TextInputAction.done,
            ),
          ),
          actions: [
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(107, 151, 202, 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () {
                  final String name = updatePersonalProjectNamecontroller.text;
                  try {
                    personalproject
                        .doc(documentSnapshot!.id)
                        .update({"personalProjName": name});
                  } on FirebaseAuthException catch (e) {
                    if (kDebugMode) {
                      print(e);
                    }
                  }
                  Navigator.of(context).pop();
                },
                child: const Text('Confirm', style: defaultText),
              ),
            ),
          ],
        );
      },
    );
  }

//update team project
  Future<void> updateTeam([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      teamprojectname = documentSnapshot['teamProjName'];
    }
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              "Edit Project Name",
              style: lightblue,
            ),
          ),
          content: Container(
            height: 50,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 205, 205, 205),
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              controller: updateTeamProjectNamecontroller
                ..text = teamprojectname,
              onChanged: (String value) {
                teamprojectname = value;
              },
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                border: InputBorder.none,
                hintStyle: textbox,
              ),
              style: textbox,
              textInputAction: TextInputAction.done,
            ),
          ),
          actions: [
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(107, 151, 202, 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () {
                  final String name = updateTeamProjectNamecontroller.text;
                  try {
                    teamproject
                        .doc(documentSnapshot!.id)
                        .update({"teamProjName": name});
                  } on FirebaseAuthException catch (e) {
                    if (kDebugMode) {
                      print(e);
                    }
                  }
                  Navigator.of(context).pop();
                },
                child: const Text('Confirm', style: defaultText),
              ),
            ),
          ],
        );
      },
    );
  }

//delete personal project
  Future<void> deletePersonal(String personalprojectID) async {
    var snapshots = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection('personalproject')
        .doc(personalprojectID)
        .collection("goals")
        .get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
    var snapshots1 = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection('personalproject')
        .doc(personalprojectID)
        .collection("issues")
        .get();
    for (var doc in snapshots1.docs) {
      await doc.reference.delete();
    }
    var snapshots2 = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection('personalproject')
        .doc(personalprojectID)
        .collection("tasks")
        .get();
    for (var doc in snapshots2.docs) {
      await doc.reference.delete();
    }
    var snapshots3 = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection('personalproject')
        .doc(personalprojectID)
        .collection("risks")
        .get();
    for (var doc in snapshots3.docs) {
      await doc.reference.delete();
    }
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection('personalproject')
        .doc(personalprojectID)
        .delete();

    alertDialog("You have successfully deleted a project");
  }

//delete team project
  Future<void> deleteTeam(String teamprojectID) async {
    await teamproject
        .doc(teamprojectID)
        .collection("files")
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        for (var i = 0; i < value.docs.length; i++) {
          String name = value.docs[i]["filename"];
          String id = value.docs[i]["projectID"];

          if (id == "" && name == "") {
          } else {
            final ref = storageRef.child('${teamprojectID}_$name');
            await ref.delete();
          }
        }
      } else {}
    });

    var snapshots =
        await teamproject.doc(teamprojectID).collection("goals").get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
    var snapshots1 =
        await teamproject.doc(teamprojectID).collection("issues").get();
    for (var doc in snapshots1.docs) {
      await doc.reference.delete();
    }
    var snapshots2 =
        await teamproject.doc(teamprojectID).collection("tasks").get();
    for (var doc in snapshots2.docs) {
      await doc.reference.delete();
    }
    var snapshots3 =
        await teamproject.doc(teamprojectID).collection("risks").get();
    for (var doc in snapshots3.docs) {
      await doc.reference.delete();
    }
    var snapshots4 =
        await teamproject.doc(teamprojectID).collection("chatbox").get();
    for (var doc in snapshots4.docs) {
      await doc.reference.delete();
    }
    var snapshots5 =
        await teamproject.doc(teamprojectID).collection("files").get();
    for (var doc in snapshots5.docs) {
      await doc.reference.delete();
    }
    await teamproject.doc(teamprojectID).delete();

    alertDialog("You have successfully deleted a project");
  }

//leave if you are a member
  Future<void> leave(String teamprojectID) async {
    await FirebaseFirestore.instance
        .collection('teamproject')
        .doc(teamprojectID)
        .update({
      "members": FieldValue.arrayRemove([user.email]),
    });
    alertDialog("You have left the group!");
  }

//push to project ID to personal dashbaord
  Future<void> passDocID(String personalprojectID) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              DashboardPersonal(passdocID: personalprojectID)),
    );
  }

//push to project ID to team member dashbaord
  Future<void> passDocIDMember(String teamprojectID) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DashboardTeamMember(passdocID: teamprojectID)),
    );
  }

//push to project ID to team dashbaord
  Future<void> passDocIDTeam(String personalprojectID) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DashboardTeam(passdocID: personalprojectID)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final CollectionReference personalproject = FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection('personalproject');

    final Stream<QuerySnapshot> projects = FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection('personalproject')
        .where('done', isEqualTo: true)
        .snapshots();

    final Stream<QuerySnapshot> teamprojects = FirebaseFirestore.instance
        .collection('teamproject')
        .where('ownerID', isEqualTo: user.uid)
        .where('done', isEqualTo: true)
        .snapshots();

    final Stream<QuerySnapshot> teamprojectsMember = FirebaseFirestore.instance
        .collection('teamproject')
        .where('members', arrayContains: user.email)
        .where('done', isEqualTo: true)
        .snapshots();

    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: const Color.fromRGBO(64, 89, 173, 1),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      const Header(
                        text: "Completed Projects",
                        color: Colors.black,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      const Header(
                        text: "Personal Projects",
                        color: Color.fromRGBO(107, 151, 202, 1),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      StreamBuilder(
                        stream: projects,
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                          if (streamSnapshot.hasData) {
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: streamSnapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                final DocumentSnapshot documentSnapshot =
                                    streamSnapshot.data!.docs[index];

                                return Card(
                                  elevation: 5,
                                  color: const Color.fromRGBO(239, 242, 241, 1),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40)),
                                  child: InkWell(
                                    onLongPress: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(40)),
                                            content: Container(
                                              padding: const EdgeInsets.only(
                                                  left: 60, right: 60),
                                              height: 50,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                    icon:
                                                        const Icon(Icons.edit),
                                                    iconSize: 30,
                                                    color: const Color.fromRGBO(
                                                        151, 216, 196, 1),
                                                    onPressed: () =>
                                                        updatePersonal(
                                                            documentSnapshot),
                                                  ),
                                                  const SizedBox(
                                                    width: 15,
                                                  ),
                                                  IconButton(
                                                      icon: const Icon(
                                                          Icons.delete),
                                                      iconSize: 30,
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              201,
                                                              78,
                                                              100),
                                                      onPressed: () =>
                                                          deletePersonal(
                                                              documentSnapshot
                                                                  .id)),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: ListTile(
                                      leading: Checkbox(
                                        checkColor: Colors.white,
                                        activeColor: const Color.fromRGBO(
                                            151, 216, 196, 1),
                                        value: documentSnapshot['done'],
                                        onChanged: (value) async {
                                          await personalproject
                                              .doc(documentSnapshot.id)
                                              .update({"done": value});

                                          alertDialog(
                                              "Project moved to ongoing");
                                        },
                                      ),
                                      title: Text(
                                        documentSnapshot['personalProjName'],
                                        style: const TextStyle(
                                            color:
                                                Color.fromRGBO(64, 89, 173, 1),
                                            fontSize: 15),
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(
                                            Icons.arrow_forward_ios_rounded),
                                        iconSize: 20,
                                        onPressed: () {
                                          passDocID(documentSnapshot.id);
                                        },
                                        color: const Color.fromRGBO(
                                            64, 89, 173, 1),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }

                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Header(
                        text: "Team Projects",
                        color: Color.fromRGBO(107, 151, 202, 1),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      StreamBuilder(
                        stream: teamprojects,
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                          if (streamSnapshot.hasData) {
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: streamSnapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                final DocumentSnapshot documentSnapshot =
                                    streamSnapshot.data!.docs[index];

                                return Card(
                                  elevation: 5,
                                  color: const Color.fromRGBO(239, 242, 241, 1),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40)),
                                  child: InkWell(
                                    onLongPress: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(40)),
                                            content: Container(
                                              padding: const EdgeInsets.only(
                                                  left: 60, right: 60),
                                              height: 50,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                    icon:
                                                        const Icon(Icons.edit),
                                                    iconSize: 30,
                                                    color: const Color.fromRGBO(
                                                        151, 216, 196, 1),
                                                    onPressed: () => updateTeam(
                                                        documentSnapshot),
                                                  ),
                                                  const SizedBox(
                                                    width: 15,
                                                  ),
                                                  IconButton(
                                                      icon: const Icon(
                                                          Icons.delete),
                                                      iconSize: 30,
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              201,
                                                              78,
                                                              100),
                                                      onPressed: () =>
                                                          deleteTeam(
                                                              documentSnapshot
                                                                  .id)),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: ListTile(
                                      leading: Checkbox(
                                        checkColor: Colors.white,
                                        activeColor: const Color.fromRGBO(
                                            151, 216, 196, 1),
                                        value: documentSnapshot['done'],
                                        onChanged: (value) async {
                                          await teamproject
                                              .doc(documentSnapshot.id)
                                              .update({"done": value});

                                          alertDialog(
                                              "Project moved to ongoing");
                                        },
                                      ),
                                      title: Text(
                                        documentSnapshot['teamProjName'],
                                        style: const TextStyle(
                                            color:
                                                Color.fromRGBO(64, 89, 173, 1),
                                            fontSize: 15),
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(
                                            Icons.arrow_forward_ios_rounded),
                                        iconSize: 20,
                                        onPressed: () {
                                          passDocIDTeam(documentSnapshot.id);
                                        },
                                        color: const Color.fromRGBO(
                                            64, 89, 173, 1),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }

                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                      StreamBuilder(
                        stream: teamprojectsMember,
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                          if (streamSnapshot.hasData) {
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: streamSnapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                final DocumentSnapshot documentSnapshot =
                                    streamSnapshot.data!.docs[index];

                                return Card(
                                  elevation: 5,
                                  color: const Color.fromRGBO(239, 242, 241, 1),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40)),
                                  child: InkWell(
                                    onLongPress: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(40)),
                                            content: Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                children: [
                                                  const Text("Leave group?"),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  CircleAvatar(
                                                    radius: 25,
                                                    backgroundColor:
                                                        const Color.fromRGBO(
                                                            239, 242, 241, 1),
                                                    child: IconButton(
                                                        icon: const Icon(
                                                            CommunityMaterialIcons
                                                                .exit_run),
                                                        iconSize: 30,
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 201, 78, 100),
                                                        onPressed: () {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (context) =>
                                                                    AlertDialog(
                                                              title: const Text(
                                                                  "Are you sure you want to leave this project?",
                                                                  style:
                                                                      darkblue,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center),
                                                              actions: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            50,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: const Color.fromRGBO(
                                                                              107,
                                                                              151,
                                                                              202,
                                                                              1),
                                                                          borderRadius:
                                                                              BorderRadius.circular(20),
                                                                        ),
                                                                        child:
                                                                            TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            leave(documentSnapshot.id);
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child: const Text(
                                                                              'yes',
                                                                              style: defaultText),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            50,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: const Color.fromRGBO(
                                                                              107,
                                                                              151,
                                                                              202,
                                                                              1),
                                                                          borderRadius:
                                                                              BorderRadius.circular(20),
                                                                        ),
                                                                        child:
                                                                            TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child: const Text(
                                                                              'cancel',
                                                                              style: defaultText),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: ListTile(
                                      title: Row(
                                        children: [
                                          const CircleAvatar(
                                            radius: 20,
                                            backgroundColor: Color.fromRGBO(
                                                151, 216, 196, 1),
                                            child: Icon(
                                              CommunityMaterialIcons
                                                  .account_supervisor_circle,
                                              color: Color.fromRGBO(
                                                  239, 242, 241, 1),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            documentSnapshot['teamProjName'],
                                            style: const TextStyle(
                                                color: Color.fromRGBO(
                                                    64, 89, 173, 1),
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(
                                            Icons.arrow_forward_ios_rounded),
                                        iconSize: 20,
                                        onPressed: () {
                                          passDocIDMember(documentSnapshot.id);
                                        },
                                        color: const Color.fromRGBO(
                                            64, 89, 173, 1),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }

                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
