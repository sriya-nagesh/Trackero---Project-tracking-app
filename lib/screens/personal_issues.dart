//Sriya Nagesh (SUKD1902368) BIT-UCLAN
import 'package:trackero/export.dart';

class PersonalIssues extends StatefulWidget {
  const PersonalIssues({Key? key, required this.docID}) : super(key: key);
  final String docID;
  @override
  State<PersonalIssues> createState() => _PersonalIssuesState();
}

class _PersonalIssuesState extends State<PersonalIssues> {
  String issueName = "";
  final updateIssueNameTextfield = TextEditingController();
  String issueDescription = "";
  final updateDescriptionTextfield = TextEditingController();
  final issueNameTextfield = TextEditingController();
  final issueDescriptionTextfield = TextEditingController();
  String issuenametext = "";
  String issuedescriptiontext = "";
  late final documentID = widget.docID;
  CollectionReference personalIssueCollection = FirebaseFirestore.instance
      .collection("users")
      .doc(user.uid)
      .collection("personalproject");

//update issue
  Future<void> update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      issueName = documentSnapshot['personalIssueName'];
      issueDescription = documentSnapshot['personalIssueDescription'];
    }
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Edit name",
                style: darkblue,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 205, 205, 205),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: updateIssueNameTextfield..text = issueName,
                  onChanged: (String value) {
                    issueName = value;
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
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Edit description",
                style: darkblue,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 205, 205, 205),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: updateDescriptionTextfield
                    ..text = issueDescription,
                  onChanged: (String value1) {
                    issueDescription = value1;
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
            ],
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
                onPressed: () async {
                  if (updateIssueNameTextfield.text.isNotEmpty &&
                      updateDescriptionTextfield.text.isNotEmpty) {
                    final String name = updateIssueNameTextfield.text;
                    try {
                      await personalIssueCollection
                          .doc(documentID)
                          .collection("issues")
                          .doc(documentSnapshot!.id)
                          .update({"personalIssueName": name});

                      final String description =
                          updateDescriptionTextfield.text;
                      await personalIssueCollection
                          .doc(documentID)
                          .collection("issues")
                          .doc(documentSnapshot.id)
                          .update({"personalIssueDescription": description});

                      alertDialog("Your issue has been updated!");
                    } on FirebaseException catch (e) {
                      if (kDebugMode) {
                        print(e);
                      }
                    }
                    if (!mounted) return;
                    Navigator.of(context).pop();
                  } else {
                    alertDialog("Please fill in all textfields");
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

//delete issue
  Future<void> delete(String issueID) async {
    try {
      await personalIssueCollection
          .doc(documentID)
          .collection("issues")
          .doc(issueID)
          .delete();

      alertDialog("Your issue has been deleted!");
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    updateIssueNameTextfield.dispose();
    updateDescriptionTextfield.dispose();
    issueNameTextfield.dispose();
    issueDescriptionTextfield.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String uida = FirebaseAuth.instance.currentUser!.uid;
    final issuesRefresh = FirebaseFirestore.instance
        .collection("users")
        .doc(uida)
        .collection('personalproject')
        .doc(widget.docID)
        .collection("issues")
        .where("projectID", isEqualTo: widget.docID);
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
                      Column(
                        children: [
                          const SizedBox(
                            height: 40,
                          ),
                          const Header(
                            text: "Issue Name",
                            color: Color.fromRGBO(107, 151, 202, 1),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(236, 236, 236, 1),
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: TextField(
                                    controller: issueNameTextfield,
                                    onChanged: (String valuetn) {
                                      issuenametext = valuetn;
                                    },
                                    autofocus: false,
                                    textInputAction: TextInputAction.done,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      border: InputBorder.none,
                                      hintStyle: textbox,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Header(
                            text: "Description",
                            color: Color.fromRGBO(107, 151, 202, 1),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(236, 236, 236, 1),
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: TextField(
                                    controller: issueDescriptionTextfield,
                                    onChanged: (String valueid) {
                                      issuedescriptiontext = valueid;
                                    },
                                    autofocus: false,
                                    textInputAction: TextInputAction.done,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      border: InputBorder.none,
                                      hintStyle: textbox,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          IconButton(
                            icon: const Icon(
                              CommunityMaterialIcons.plus_circle,
                              color: Color.fromRGBO(151, 216, 196, 1),
                            ),
                            iconSize: 50,
                            //add issue
                            onPressed: () async {
                              if (issueNameTextfield.text == '' &&
                                  issueDescriptionTextfield.text == '') {
                                alertDialog(
                                    "Please fill in name and description!");
                              } else {
                                await AddPersonalIssues()
                                    .createPersonalIssuesModel(
                                        issueNameTextfield.text,
                                        DateTime.now(),
                                        widget.docID,
                                        issueDescriptionTextfield.text);
                                issueNameTextfield.clear();
                                issueDescriptionTextfield.clear();

                                alertDialog("Your issue has been added!");
                              }
                            },
                          ),
                          const Header(
                            text: "Issues",
                            color: Colors.black,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(236, 236, 236, 1),
                            ),
                            child: StreamBuilder(
                              stream: issuesRefresh.snapshots(),
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
                                            107, 151, 202, 1),
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
                                                    'personalIssueName'],
                                                style: offwhite,
                                              ),
                                            ),
                                            subtitle: Center(
                                              child: Text(
                                                documentSnapshot[
                                                    'personalIssueDescription'],
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 223, 223, 223),
                                                    fontSize: 16),
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
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
