//Sriya Nagesh (SUKD1902368) BIT-UCLAN
import 'package:trackero/export.dart';

class PersonalDashboard extends StatefulWidget {
  const PersonalDashboard({Key? key, required this.docID}) : super(key: key);
  final String docID;

  @override
  State<PersonalDashboard> createState() => _PersonalDashboardState();
}

class _PersonalDashboardState extends State<PersonalDashboard> {
  final user = FirebaseAuth.instance.currentUser!;
  String personalgoalname = "";
  late TextEditingController updatemission = TextEditingController();
  late TextEditingController updatevision = TextEditingController();
  late TextEditingController mission = TextEditingController();
  late TextEditingController vision = TextEditingController();
  late TextEditingController goal = TextEditingController();
  late TextEditingController updategoal = TextEditingController();
  late final documentID = widget.docID.toString();
  String missiontext = '';
  String visiontext = '';
  String goaltext = "";

  List<String> items = <String>['CSV', 'PDF'];
  String dropdownValue = 'CSV';

//update goal
  Future<void> update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      personalgoalname = documentSnapshot['personalGoalName'];
    }
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              "Edit Goal",
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
              controller: updategoal..text = personalgoalname,
              onChanged: (String value) {
                personalgoalname = value;
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
              //update goal name
              child: TextButton(
                onPressed: () async {
                  final String name = updategoal.text;
                  if (updategoal.text.isNotEmpty) {
                    try {
                      await personalGoalCollection
                          .doc(documentID)
                          .collection("goals")
                          .doc(documentSnapshot!.id)
                          .update({"personalGoalName": name});

                      alertDialog("Your goal has been updated!");
                    } on FirebaseException catch (e) {
                      if (kDebugMode) {
                        print(e);
                      }
                    }
                    if (!mounted) return;
                    Navigator.of(context).pop();
                  } else {
                    alertDialog("Please fill in the textfield");
                  }
                },
                child: const Text('Confirm', style: defaultText),
              ),
            ),
          ],
        );
      },
    );
  }

//delete goal
  Future<void> delete(String goalID) async {
    try {
      await personalGoalCollection
          .doc(documentID)
          .collection("goals")
          .doc(goalID)
          .delete();

      alertDialog("Your goal has been deleted!");
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    if (!mounted) return;
    Navigator.of(context).pop();
  }

//get mission, vision and project name into project database
  Future getName() async {
    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('personalproject')
        .doc(widget.docID)
        .withConverter(
          fromFirestore: PersonalProjectModel.fromFirestore,
          toFirestore: (PersonalProjectModel personalProjectModel, _) =>
              personalProjectModel.toFirestore(),
        );
    final docSnap = await ref.get();
    final personalProjectModel = docSnap.data();
    if (personalProjectModel != null) {
      return personalProjectModel.personalProjName;
    } else {}
  }

  Future getMission() async {
    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('personalproject')
        .doc(widget.docID)
        .withConverter(
          fromFirestore: PersonalProjectModel.fromFirestore,
          toFirestore: (PersonalProjectModel personalProjectModel, _) =>
              personalProjectModel.toFirestore(),
        );
    final docSnap = await ref.get();
    final personalProjectModel = docSnap.data();
    if (personalProjectModel != null) {
      return personalProjectModel.mission;
    } else {}
  }

  Future getVision() async {
    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('personalproject')
        .doc(widget.docID)
        .withConverter(
          fromFirestore: PersonalProjectModel.fromFirestore,
          toFirestore: (PersonalProjectModel personalProjectModel, _) =>
              personalProjectModel.toFirestore(),
        );
    final docSnap = await ref.get();
    final personalProjectModel = docSnap.data();
    if (personalProjectModel != null) {
      return personalProjectModel.vision;
    } else {}
  }

  Future countOngoing() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('personalproject')
        .doc(widget.docID)
        .collection("tasks")
        .where('projectID', isEqualTo: widget.docID)
        .where("done", isEqualTo: false)
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        ongoing = 0;
      } else {
        ongoing = value.docs.length;
      }
    });
  }

  Future countCompleted() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('personalproject')
        .doc(widget.docID)
        .collection("tasks")
        .where('projectID', isEqualTo: widget.docID)
        .where("done", isEqualTo: true)
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        completed = 0;
      } else {
        completed = value.docs.length;
      }
    });
  }

  countIssues() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('personalproject')
        .doc(widget.docID)
        .collection("issues")
        .where('projectID', isEqualTo: widget.docID)
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        issues = 0;
      } else {
        issues = value.docs.length;
      }
    });
  }

  Timestamp myTimeStamp = Timestamp.fromDate(DateTime.now());

  countOverdue() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('personalproject')
        .doc(widget.docID)
        .collection("tasks")
        .where('projectID', isEqualTo: widget.docID)
        .where('dueDate', isLessThanOrEqualTo: myTimeStamp)
        .where("done", isEqualTo: false)
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        overdue = 0;
      } else {
        overdue = value.docs.length;
      }
    });
  }

  String projectname = "", projectmission = "", projectvision = "";
  int ongoing = 0, completed = 0, issues = 0, overdue = 0;

  @override
  void initState() {
    super.initState();
    getName().then((value) {
      setState(() {
        projectname = value.toString();
      });
    });
    getMission().then((value) {
      setState(() {
        projectmission = value.toString();
      });
    });
    getVision().then((value) {
      setState(() {
        projectvision = value.toString();
      });
    });
    countOngoing();
    countCompleted();
    countIssues();
    countOverdue();
  }

  @override
  void dispose() {
    updatemission.dispose();
    updatevision.dispose();
    mission.dispose();
    vision.dispose();
    goal.dispose();
    updategoal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (projectname.isEmpty) {
      projectname = "Personal Project";
    }
    String uida = FirebaseAuth.instance.currentUser!.uid;
    final goalsRefresh = FirebaseFirestore.instance
        .collection('users')
        .doc(uida)
        .collection('personalproject')
        .doc(widget.docID)
        .collection('goals')
        .where("projectID", isEqualTo: widget.docID);
    late final documentID = widget.docID;

    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: const Color.fromRGBO(64, 89, 173, 1),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            alignment: Alignment.topLeft,
                            icon: const Icon(
                              CommunityMaterialIcons.arrow_left_drop_circle,
                              color: Color.fromRGBO(239, 242, 241, 1),
                            ),
                            iconSize: 60,
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Center(
                                      child: Text(
                                        "Add a goal",
                                        style: darkblue,
                                      ),
                                    ),
                                    content: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            236, 236, 236, 1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: TextField(
                                        controller: goal,
                                        onChanged: (String value) {
                                          goaltext = value;
                                        },
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 20),
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
                                          color: const Color.fromRGBO(
                                              107, 151, 202, 1),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        //add goal
                                        child: TextButton(
                                          onPressed: () async {
                                            if (goal.text.isEmpty) {
                                              alertDialog(
                                                  "Please fill in a goal name");
                                              Navigator.of(context).pop;
                                            } else {
                                              await AddPersonalGoals()
                                                  .createPersonalGoalsModel(
                                                      goal.text,
                                                      DateTime.now(),
                                                      widget.docID);
                                              goal.clear();

                                              alertDialog(
                                                  "Your goal has been added!");
                                              if (!mounted) return;
                                              Navigator.of(context).pop();
                                            }
                                          },
                                          child: const Text('Add',
                                              style: defaultText),
                                        ),
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                            alignment: Alignment.topRight,
                            icon:
                                const Icon(CommunityMaterialIcons.plus_circle),
                            color: const Color.fromRGBO(151, 216, 196, 1),
                            iconSize: 60,
                          ),
                        ],
                      ),
                      Header(
                        text: projectname,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color.fromRGBO(250, 247, 240, 1),
                              ),
                              child: Center(
                                child: Column(
                                  children: [
                                    const Text(
                                      "Ongoing Tasks",
                                      style: TextStyle(
                                          color: Color.fromRGBO(64, 89, 173, 1),
                                          fontSize: 11),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      ongoing.toString(),
                                      style: black,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color.fromRGBO(205, 252, 246, 1),
                              ),
                              child: Center(
                                child: Column(
                                  children: [
                                    const Text(
                                      "Finished Tasks",
                                      style: TextStyle(
                                          color: Color.fromRGBO(64, 89, 173, 1),
                                          fontSize: 11),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      completed.toString(),
                                      style: black,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color.fromRGBO(188, 206, 248, 1),
                              ),
                              child: Center(
                                child: Column(
                                  children: [
                                    const Text(
                                      "Current Issues",
                                      style: TextStyle(
                                          color: Color.fromRGBO(64, 89, 173, 1),
                                          fontSize: 11),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      issues.toString(),
                                      style: black,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color.fromRGBO(152, 168, 248, 1),
                              ),
                              child: Center(
                                child: Column(
                                  children: [
                                    const Text(
                                      "Overdue Tasks",
                                      style: TextStyle(
                                          color: Color.fromRGBO(64, 89, 173, 1),
                                          fontSize: 11),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      overdue.toString(),
                                      style: black,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(236, 236, 236, 1),
                        ),
                        width: double.infinity,
                        child: Column(
                          children: [
                            const Header(
                              text: "Mission",
                              color: Color.fromRGBO(107, 151, 202, 1),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Center(
                                            child: Text(
                                              "Edit mission",
                                              style: lightblue,
                                            ),
                                          ),
                                          content: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 205, 205, 205),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: TextField(
                                              controller: updatemission
                                                ..text = missiontext,
                                              decoration: const InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                border: InputBorder.none,
                                                hintStyle: textbox,
                                              ),
                                              style: textbox,
                                              textInputAction:
                                                  TextInputAction.done,
                                            ),
                                          ),
                                          actions: [
                                            Container(
                                              width: double.infinity,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: const Color.fromRGBO(
                                                    107, 151, 202, 1),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              //update mission
                                              child: TextButton(
                                                onPressed: () async {
                                                  if (updatemission
                                                      .text.isNotEmpty) {
                                                    await personalGoalCollection
                                                        .doc(documentID)
                                                        .update({
                                                      "mission":
                                                          updatemission.text
                                                    });

                                                    await getMission()
                                                        .then((value) {
                                                      setState(() {
                                                        projectmission =
                                                            value.toString();
                                                      });
                                                    });

                                                    alertDialog(
                                                        "Your mission has been updated!");
                                                    if (!mounted) return;
                                                    Navigator.of(context).pop();
                                                  } else {
                                                    alertDialog(
                                                        "Please fill in the textfield");
                                                  }
                                                },
                                                child: const Text('Confirm',
                                                    style: defaultText),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                      CommunityMaterialIcons.plus_circle),
                                  iconSize: 60,
                                  color: const Color.fromRGBO(151, 216, 196, 1),
                                ),
                                Expanded(
                                  child: Text(
                                    projectmission,
                                    style: textbox,
                                  ),
                                ),
                              ],
                            ),
                            const Header(
                              text: "Vision",
                              color: Color.fromRGBO(107, 151, 202, 1),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Center(
                                            child: Text(
                                              "Edit vision",
                                              style: lightblue,
                                            ),
                                          ),
                                          content: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 205, 205, 205),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: TextField(
                                              controller: updatevision
                                                ..text = visiontext,
                                              decoration: const InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                border: InputBorder.none,
                                                hintStyle: textbox,
                                              ),
                                              style: textbox,
                                              textInputAction:
                                                  TextInputAction.done,
                                            ),
                                          ),
                                          actions: [
                                            Container(
                                              width: double.infinity,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: const Color.fromRGBO(
                                                    107, 151, 202, 1),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              //update vision
                                              child: TextButton(
                                                onPressed: () async {
                                                  if (updatevision
                                                      .text.isNotEmpty) {
                                                    await personalGoalCollection
                                                        .doc(documentID)
                                                        .update({
                                                      "vision":
                                                          updatevision.text
                                                    });

                                                    await getVision()
                                                        .then((value) {
                                                      setState(() {
                                                        projectvision =
                                                            value.toString();
                                                      });
                                                    });

                                                    alertDialog(
                                                        "Your vision has been updated!");
                                                    if (!mounted) return;
                                                    Navigator.of(context).pop();
                                                  } else {
                                                    alertDialog(
                                                        "Please fill in the textfield");
                                                  }
                                                },
                                                child: const Text('Confirm',
                                                    style: defaultText),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                      CommunityMaterialIcons.plus_circle),
                                  iconSize: 60,
                                  color: const Color.fromRGBO(151, 216, 196, 1),
                                ),
                                Expanded(
                                  child: Text(
                                    projectvision,
                                    style: textbox,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            StreamBuilder(
                              stream: goalsRefresh.snapshots(),
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
                                        color: const Color.fromRGBO(
                                            151, 216, 196, 1),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        child: InkWell(
                                          onLongPress: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40)),
                                                  content: Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 60,
                                                            right: 60),
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        IconButton(
                                                          icon: const Icon(
                                                              Icons.edit),
                                                          iconSize: 30,
                                                          color: const Color
                                                                  .fromRGBO(
                                                              151, 216, 196, 1),
                                                          onPressed: () => update(
                                                              documentSnapshot),
                                                        ),
                                                        const SizedBox(
                                                          width: 15,
                                                        ),
                                                        IconButton(
                                                          icon: const Icon(
                                                              Icons.delete),
                                                          iconSize: 30,
                                                          color: const Color
                                                                  .fromARGB(255,
                                                              201, 78, 100),
                                                          onPressed: () => delete(
                                                              documentSnapshot
                                                                  .id),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: ListTile(
                                            title: Center(
                                              child: Text(
                                                documentSnapshot[
                                                    'personalGoalName'],
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
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
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 90),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  icon: const Icon(
                                    CommunityMaterialIcons.chevron_down,
                                    color: Color.fromRGBO(107, 151, 202, 1),
                                  ),
                                  iconSize: 40,
                                  dropdownColor: Colors.white,
                                  value: dropdownValue,
                                  onChanged: (String? newValue) {
                                    setState(
                                      () {
                                        dropdownValue = newValue!;
                                      },
                                    );
                                  },
                                  items: items.map<DropdownMenuItem<String>>(
                                    (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Center(
                                          child: Text(
                                            value,
                                            style: lightblue,
                                          ),
                                        ),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 50),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text(
                                        "Are you sure you want to export this project?",
                                        style: darkblue,
                                        textAlign: TextAlign.center),
                                    actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: const Color.fromRGBO(
                                                    107, 151, 202, 1),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  if (dropdownValue == "CSV") {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ExportPersonal(
                                                                choice: "CSV",
                                                                projectID:
                                                                    widget
                                                                        .docID,
                                                                name:
                                                                    projectname,
                                                              )),
                                                    );
                                                  }
                                                  if (dropdownValue == "PDF") {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ExportPersonal(
                                                                choice: "PDF",
                                                                projectID:
                                                                    widget
                                                                        .docID,
                                                                name:
                                                                    projectname,
                                                              )),
                                                    );
                                                  }
                                                },
                                                child: const Text('yes',
                                                    style: defaultText),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: const Color.fromRGBO(
                                                    107, 151, 202, 1),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('cancel',
                                                    style: defaultText),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(
                                  CommunityMaterialIcons.file_download_outline),
                              iconSize: 40,
                              color: const Color.fromRGBO(236, 236, 236, 1),
                            ),
                          ),
                        ],
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
