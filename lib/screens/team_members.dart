//Sriya Nagesh (SUKD1902368) BIT-UCLAN
import 'package:trackero/export.dart';

class TeamMembers extends StatefulWidget {
  const TeamMembers({Key? key, required this.docID}) : super(key: key);
  final String docID;
  @override
  State<TeamMembers> createState() => _TeamMembersState();
}

class _TeamMembersState extends State<TeamMembers> {
  final memberTextfield = TextEditingController();
  String memberEmail = "";

  final user = FirebaseAuth.instance.currentUser!;

  Future<int> checkEmail(String email) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    return result.docs.length;
  }

  List memberList = [];

//get members in the project from members array and add owner email into the list as well
  Future getList() async {
    await teamproject.doc(widget.docID).get().then((value) {
      setState(() {
        if (memberList.contains(value['ownerEmail'])) {
        } else {
          memberList.add(value['ownerEmail']);
        }
        for (var value in List.from(value['members'])) {
          dynamic data = value;
          memberList.add(data);
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    memberList.clear();
    getList();
  }

  @override
  void dispose() {
    memberTextfield.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final memberReference = teamproject.doc(widget.docID);
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
                            text: "Add Member",
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
                                    controller: memberTextfield,
                                    onChanged: (String value) {
                                      memberEmail = value.trim().toLowerCase();
                                    },
                                    autofocus: false,
                                    textInputAction: TextInputAction.done,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      border: InputBorder.none,
                                      hintStyle: textbox,
                                      hintText: "Add members email",
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                  icon: const Icon(
                                    CommunityMaterialIcons.plus_circle,
                                    color: Color.fromRGBO(151, 216, 196, 1),
                                  ),
                                  iconSize: 50,
                                  onPressed: () async {
                                    if (memberTextfield.text == '') {
                                      alertDialog("Please add a members email");
                                    } else {
                                      //check if this email exists in the database
                                      checkEmail(memberEmail).then(((value) {
                                        if (value > 0) {
                                          if (memberList
                                              .contains(memberEmail)) {
                                            //check if email entered is the users own email
                                            alertDialog(
                                                "User is already in this project");
                                          } else {
                                            if (memberEmail == user.email) {
                                              alertDialog(
                                                  "You are already in this project!");
                                              memberTextfield.clear();
                                            } else {
                                              memberReference.update({
                                                "members":
                                                    FieldValue.arrayUnion(
                                                        [memberEmail]),
                                              });

                                              setState(() {
                                                memberList.add(memberEmail);
                                              });

                                              final emailSnapshot =
                                                  memberEmail.toString();
                                              String email =
                                                  emailSnapshot.replaceAll(
                                                      RegExp(r'[^\w\s]+'), '');
                                              final data = {email: 0};
                                              teamproject
                                                  .doc(widget.docID)
                                                  .collection('tasks')
                                                  .doc('durationmembers')
                                                  .set(data,
                                                      SetOptions(merge: true));

                                              alertDialog(
                                                  "New member has been added!");
                                              memberTextfield.clear();
                                            }
                                          }
                                        } else {
                                          alertDialog(
                                              "This user does not exist in the database");
                                        }
                                      }));
                                    }

                                    memberTextfield.clear();
                                  }),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Header(
                        text: "MEMBERS",
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(236, 236, 236, 1),
                        ),
                        child: Column(
                          children: [
                            const Header(
                              text: "Members in Project",
                              color: Color.fromRGBO(107, 151, 202, 1),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: memberList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  color: const Color.fromRGBO(236, 236, 236, 1),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40)),
                                  child: ListTile(
                                    title: Center(
                                        child: Text(
                                      memberList[index],
                                      style: const TextStyle(
                                          color: Color.fromRGBO(14, 30, 43, 1),
                                          fontSize: 12),
                                    )),
                                    trailing: Column(
                                      children: [
                                        if (memberList[index] !=
                                            user.email) ...[
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete_rounded,
                                              color: Color.fromARGB(
                                                  255, 255, 122, 112),
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: const Text(
                                                      "Are you sure you want to delete this member?",
                                                      style: darkblue,
                                                      textAlign:
                                                          TextAlign.center),
                                                  actions: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                            height: 50,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: const Color
                                                                      .fromRGBO(
                                                                  107,
                                                                  151,
                                                                  202,
                                                                  1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                            ),
                                                            child: TextButton(
                                                              onPressed: () {
                                                                if (memberList[
                                                                        index] !=
                                                                    user.email) {
                                                                  memberReference
                                                                      .update({
                                                                    "members":
                                                                        FieldValue
                                                                            .arrayRemove([
                                                                      memberList[
                                                                          index]
                                                                    ]),
                                                                  });
                                                                  getList();

                                                                  setState(() {
                                                                    memberList
                                                                        .removeAt(
                                                                            index);
                                                                  });

                                                                  alertDialog(
                                                                      "Member has been removed!");
                                                                } else {
                                                                  alertDialog(
                                                                      "The project manager cannot delete themself from the group!");
                                                                }

                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: const Text(
                                                                  'yes',
                                                                  style:
                                                                      defaultText),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            height: 50,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: const Color
                                                                      .fromRGBO(
                                                                  107,
                                                                  151,
                                                                  202,
                                                                  1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                            ),
                                                            child: TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: const Text(
                                                                  'cancel',
                                                                  style:
                                                                      defaultText),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ]
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
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
}
