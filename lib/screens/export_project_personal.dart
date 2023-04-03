//Sriya Nagesh (SUKD1902368) BIT-UCLAN
import 'package:trackero/export.dart';

//export personal project
List<List<String>> goalsList = [],
    issuesList = [],
    tasksList = [],
    risksList = [],
    blankList = [],
    projectName = [];

class ExportPersonal extends StatefulWidget {
  const ExportPersonal(
      {Key? key,
      required this.choice,
      required this.projectID,
      required this.name})
      : super(key: key);
  final String choice;
  final String projectID;
  final String name;
  @override
  State<ExportPersonal> createState() => _ExportPersonalState();
}

class _ExportPersonalState extends State<ExportPersonal> {
  @override
  void initState() {
    super.initState();
    projectName.clear();
    goalsList.clear();
    issuesList.clear();
    tasksList.clear();
    risksList.clear();

    projectName = [
      <String>[widget.name]
    ];
    goalsList = [
      <String>["GOALS"]
    ];
    issuesList = [
      <String>["ISSUES", "DESCRIPTION"]
    ];
    tasksList = [
      <String>["TASKS", "DESCRIPTION", "DUE DATE"]
    ];
    risksList = [
      <String>["RISKS", "PROBABILITY", "SEVERITY"]
    ];
    blankList = [
      <String>[" "]
    ];
  }

  @override
  Widget build(BuildContext context) {
    final collectionPersonal = FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection('personalproject')
        .doc(widget.projectID);
    final goals = collectionPersonal
        .collection("goals")
        .where("projectID", isEqualTo: widget.projectID)
        .snapshots();
    final issues = collectionPersonal
        .collection("issues")
        .where("projectID", isEqualTo: widget.projectID)
        .snapshots();
    final tasks = collectionPersonal
        .collection("tasks")
        .where("projectID", isEqualTo: widget.projectID)
        .snapshots();
    final risks = collectionPersonal
        .collection("risks")
        .where("projectID", isEqualTo: widget.projectID)
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
                                await PdfApi.generatePersonal(
                                    widget.name,
                                    issuesList,
                                    risksList,
                                    goalsList,
                                    tasksList,
                                    user1.email!);

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
                                  goalsList.add(<String>[
                                    documentSnapshot['personalGoalName']
                                  ]);
                                  debugPrint(goalsList.toString());
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
                                                    'personalGoalName'],
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
                                  tasksList.add(<String>[
                                    documentSnapshot['personalTaskName'],
                                    documentSnapshot['personalTaskDescription'],
                                    documentSnapshot['dueDate']
                                        .toDate()
                                        .toString()
                                  ]);
                                  debugPrint(tasksList.toString());
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
                                                    'personalTaskName'],
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
                                  issuesList.add(<String>[
                                    documentSnapshot['personalIssueName'],
                                    documentSnapshot['personalIssueDescription']
                                  ]);
                                  debugPrint(issuesList.toString());
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
                                                    'personalIssueName'],
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
                                  risksList.add(<String>[
                                    documentSnapshot['personalRiskName'],
                                    documentSnapshot['probability'],
                                    documentSnapshot['severity']
                                  ]);
                                  debugPrint(risksList.toString());
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
                                                    'personalRiskName'],
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

  generateCSV() async {
    String csvData = const ListToCsvConverter().convert(projectName +
        blankList +
        goalsList +
        blankList +
        tasksList +
        blankList +
        issuesList +
        blankList +
        risksList);
    DateTime exportDate = DateTime.now();
    String date = formatDate(exportDate, [dd, '_', mm, '_', yyyy, '_', HH]);

    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (status.isGranted == true) {
        Directory donwloadPath = Directory("/storage/emulated/0/Download");
        final File csvFile =
            await (File('${donwloadPath.path}/${widget.name}_$date.csv')
                .create());

        await csvFile.writeAsString(csvData);
      } else {
        await Permission.storage.request();
      }
    }
  }
}
