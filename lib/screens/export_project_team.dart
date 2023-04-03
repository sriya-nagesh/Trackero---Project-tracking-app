//Sriya Nagesh (SUKD1902368) BIT-UCLAN
import 'package:trackero/export.dart';

//export team project
List<List<String>> goalsListTeam = [],
    projectManager = [],
    issuesListTeam = [],
    tasksListTeam = [],
    risksListTeam = [],
    blankListTeam = [],
    projectNameTeam = [],
    teamMembersList = [];
String pm = '';

final user1 = FirebaseAuth.instance.currentUser!;

class ExportTeam extends StatefulWidget {
  const ExportTeam(
      {Key? key,
      required this.choice,
      required this.projectID,
      required this.name,
      required this.pm})
      : super(key: key);
  final String choice;
  final String projectID;
  final String name;

  final String pm;
  @override
  State<ExportTeam> createState() => _ExportTeamState();
}

class _ExportTeamState extends State<ExportTeam> {
  @override
  void initState() {
    super.initState();
    projectManager.clear();
    teamMembersList.clear();
    projectNameTeam.clear();
    goalsListTeam.clear();
    issuesListTeam.clear();
    tasksListTeam.clear();
    risksListTeam.clear();

    teamMembersList = [
      <String>["MEMBERS"]
    ];
    projectManager = [
      <String>["PROJECT MANAGER"]
    ];
    projectNameTeam = [
      <String>[widget.name]
    ];
    goalsListTeam = [
      <String>["GOALS"]
    ];
    issuesListTeam = [
      <String>["ISSUES", "DESCRIPTION"]
    ];
    tasksListTeam = [
      <String>["TASKS", "DESCRIPTION", "ASSIGNED", "DUE DATE"]
    ];
    risksListTeam = [
      <String>["RISKS", "PROBABILITY", "SEVERITY"]
    ];
    blankListTeam = [
      <String>[" "]
    ];
    getMembers();
  }

  Future getMembers() async {
    await teamproject.doc(widget.projectID).get().then((value) {
      for (var value in List.from(value['members'])) {
        dynamic data = value;
        teamMembersList.add(<String>[data]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final collectionTeam = FirebaseFirestore.instance
        .collection('teamproject')
        .doc(widget.projectID);
    final goals = collectionTeam
        .collection("goals")
        .where('projectID', isEqualTo: widget.projectID)
        .snapshots();
    final issues = collectionTeam
        .collection("issues")
        .where('projectID', isEqualTo: widget.projectID)
        .snapshots();
    final tasks = collectionTeam
        .collection("tasks")
        .where('projectID', isEqualTo: widget.projectID)
        .snapshots();
    final risks = collectionTeam
        .collection("risks")
        .where('projectID', isEqualTo: widget.projectID)
        .snapshots();
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: const Color.fromRGBO(64, 89, 173, 1),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
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
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              CommunityMaterialIcons.arrow_left_drop_circle,
                              color: Color.fromRGBO(239, 242, 241, 1),
                            ),
                            iconSize: 40,
                          ),
                          IconButton(
                            onPressed: () async {
                              if (widget.choice == "CSV") {
                                generateCSV();
                                alertDialog(
                                    "Your file has been exported in CSV format");
                              }

                              if (widget.choice == "PDF") {
                                await PdfApi.generateTeam(
                                    widget.name,
                                    issuesListTeam,
                                    risksListTeam,
                                    goalsListTeam,
                                    tasksListTeam,
                                    teamMembersList,
                                    widget.pm);

                                alertDialog(
                                    "Your file has been exported in PDF format");
                              }
                            },
                            icon: const Icon(
                              CommunityMaterialIcons.file_export,
                              color: Color.fromRGBO(239, 242, 241, 1),
                            ),
                            iconSize: 40,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Header(
                        text: widget.name,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Header(
                        text: "Goals",
                        color: Color.fromRGBO(107, 151, 202, 1),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(236, 236, 236, 1),
                        ),
                        child: StreamBuilder(
                          stream: goals,
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                            if (streamSnapshot.hasData) {
                              return GridView.builder(
                                shrinkWrap: true,
                                itemCount: streamSnapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final DocumentSnapshot documentSnapshot =
                                      streamSnapshot.data!.docs[index];
                                  goalsListTeam.add(<String>[
                                    documentSnapshot['teamGoalName']
                                  ]);
                                  debugPrint(goalsListTeam.toString());
                                  return Card(
                                    elevation: 5,
                                    color:
                                        const Color.fromRGBO(250, 247, 240, 1),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: ListTile(
                                      title: Center(
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                documentSnapshot[
                                                    'teamGoalName'],
                                                style: const TextStyle(
                                                    fontSize: 14),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                ),
                              );
                            }

                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Header(
                        text: "Tasks",
                        color: Color.fromRGBO(107, 151, 202, 1),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(236, 236, 236, 1),
                        ),
                        child: StreamBuilder(
                          stream: tasks,
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                            if (streamSnapshot.hasData) {
                              return GridView.builder(
                                shrinkWrap: true,
                                itemCount: streamSnapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final DocumentSnapshot documentSnapshot =
                                      streamSnapshot.data!.docs[index];
                                  tasksListTeam.add(<String>[
                                    documentSnapshot['teamTaskName'],
                                    documentSnapshot['teamTaskDescription'],
                                    documentSnapshot['assigned'],
                                    documentSnapshot['dueDate']
                                        .toDate()
                                        .toString()
                                  ]);
                                  debugPrint(tasksListTeam.toString());
                                  return Card(
                                    elevation: 5,
                                    color:
                                        const Color.fromRGBO(205, 252, 246, 1),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: ListTile(
                                      title: Center(
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                documentSnapshot[
                                                    'teamTaskName'],
                                                style: const TextStyle(
                                                    fontSize: 14),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                ),
                              );
                            }

                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Header(
                        text: "Issues",
                        color: Color.fromRGBO(107, 151, 202, 1),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(236, 236, 236, 1),
                        ),
                        child: StreamBuilder(
                          stream: issues,
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                            if (streamSnapshot.hasData) {
                              return GridView.builder(
                                shrinkWrap: true,
                                itemCount: streamSnapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final DocumentSnapshot documentSnapshot =
                                      streamSnapshot.data!.docs[index];
                                  issuesListTeam.add(<String>[
                                    documentSnapshot['teamIssueName'],
                                    documentSnapshot['teamIssueDescription']
                                  ]);
                                  debugPrint(issuesListTeam.toString());
                                  return Card(
                                    elevation: 5,
                                    color:
                                        const Color.fromRGBO(188, 206, 248, 1),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: ListTile(
                                      title: Center(
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                documentSnapshot[
                                                    'teamIssueName'],
                                                style: const TextStyle(
                                                    fontSize: 14),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                ),
                              );
                            }

                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Header(
                        text: "Risks",
                        color: Color.fromRGBO(107, 151, 202, 1),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(236, 236, 236, 1),
                        ),
                        child: StreamBuilder(
                          stream: risks,
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                            if (streamSnapshot.hasData) {
                              return GridView.builder(
                                shrinkWrap: true,
                                itemCount: streamSnapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final DocumentSnapshot documentSnapshot =
                                      streamSnapshot.data!.docs[index];
                                  risksListTeam.add(<String>[
                                    documentSnapshot['teamRiskName'],
                                    documentSnapshot['probability'],
                                    documentSnapshot['severity']
                                  ]);
                                  debugPrint(risksListTeam.toString());
                                  return Card(
                                    elevation: 5,
                                    color:
                                        const Color.fromRGBO(152, 168, 248, 1),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: ListTile(
                                      title: Center(
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                documentSnapshot[
                                                    'teamRiskName'],
                                                style: const TextStyle(
                                                    fontSize: 14),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                ),
                              );
                            }

                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
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

//function to create CSV file with the project data
  generateCSV() async {
    projectManager.add(<String>[widget.pm]);

    String csvData = const ListToCsvConverter().convert(projectNameTeam +
        blankListTeam +
        projectManager +
        blankListTeam +
        goalsListTeam +
        blankListTeam +
        tasksListTeam +
        blankListTeam +
        issuesListTeam +
        blankListTeam +
        risksListTeam +
        blankListTeam +
        teamMembersList);
    DateTime exportDate = DateTime.now();
    String date = formatDate(exportDate, [dd, '_', mm, '_', yyyy, '_', HH]);

    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (status.isGranted == true) {
        Directory donwloadPath = Directory("/storage/emulated/0/Download");
        final File file =
            await (File('${donwloadPath.path}/${widget.name}_$date.csv')
                .create());

        await file.writeAsString(csvData);
      } else {
        await Permission.storage.request();
      }
    }
  }
}
