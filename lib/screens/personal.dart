//Sriya Nagesh (SUKD1902368) BIT-UCLAN
import 'package:trackero/export.dart';

//main dashboard - personal
class Personal extends StatefulWidget {
  const Personal({Key? key}) : super(key: key);

  @override
  State<Personal> createState() => _PersonalState();
}

class _PersonalState extends State<Personal> {
// text fields' controllers
  String personalprojectname = "";
  TextEditingController personalProjectNamecontroller = TextEditingController();
  TextEditingController updatePersonalProjectNamecontroller =
      TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;
  UserModel userModel = UserModel();

  Future<void> update([DocumentSnapshot? documentSnapshot]) async {
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
                  final String name = updatePersonalProjectNamecontroller.text;
                  if (updatePersonalProjectNamecontroller.text.isNotEmpty) {
                    try {
                      FirebaseFirestore.instance
                          .collection("users")
                          .doc(user.uid)
                          .collection('personalproject')
                          .doc(documentSnapshot!.id)
                          .update({"personalProjName": name});
                    } on FirebaseAuthException catch (e) {
                      if (kDebugMode) {
                        print(e);
                      }
                    }
                    Navigator.of(context).pop();
                  } else {
                    alertDialog("Please enter a name fr your project!");
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

  Future<void> delete(String personalprojectID) async {
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

  Future<void> passDocID(String personalprojectID) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              DashboardPersonal(passdocID: personalprojectID)),
    );
  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection("users").doc(user.uid).get().then(
        (value) => setState(() => userModel = UserModel.fromMap(value.data())));
  }

  @override
  void dispose() {
    personalProjectNamecontroller.dispose();
    updatePersonalProjectNamecontroller.dispose();

    super.dispose();
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
        .where('done', isEqualTo: false)
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
                        text: "Personal Projects",
                        color: Colors.black,
                      ),
                      const SizedBox(
                        height: 25,
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
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              201,
                                                              78,
                                                              100),
                                                      onPressed: () => delete(
                                                          documentSnapshot.id)),
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
                                              "Project moved to completed!");
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
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Center(
                        child: Text(
                          "Add a Personal Project",
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
                          controller: personalProjectNamecontroller,
                          onChanged: (String value) {
                            personalprojectname = value;
                          },
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
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
                            onPressed: () async {
                              if (personalProjectNamecontroller
                                  .text.isNotEmpty) {
                                await PersonalProject().createPersonalProject(
                                    personalprojectname,
                                    DateTime.now(),
                                    user.uid,
                                    "",
                                    "",
                                    false);
                                personalProjectNamecontroller.clear();
                                if (!mounted) return;
                                Navigator.of(context).pop();
                              } else {
                                alertDialog(
                                    "Please enter a name for your project!");
                              }
                            },
                            child: const Text('Add', style: defaultText),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              backgroundColor: const Color.fromRGBO(107, 151, 202, 1),
              child: const Icon(
                Icons.add,
                color: Color.fromRGBO(151, 216, 196, 1),
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
