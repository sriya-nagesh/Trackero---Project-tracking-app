//Sriya Nagesh (SUKD1902368) BIT-UCLAN
import 'package:trackero/export.dart';

class PersonalRisks extends StatefulWidget {
  const PersonalRisks({Key? key, required this.docID}) : super(key: key);
  final String docID;
  @override
  State<PersonalRisks> createState() => _PersonalRisksState();
}

class _PersonalRisksState extends State<PersonalRisks> {
  final user = FirebaseAuth.instance.currentUser!;
  final updateRiskNameTextfield = TextEditingController();
  final riskNameTextfield = TextEditingController();
  String risknametext = "";

  List<String> probability = <String>['1', '2', '3', '4', '5'];
  List<String> severity = <String>['1', '2', '3', '4', '5'];
  String dropdownValuep = "1";
  String dropdownValues = "1";
  // String udropdownValuep = "1";
  // String udropdownValues = "1";

  String riskName = "";
  String riskProbability = "";
  String riskSeverity = "";
  late final documentID = widget.docID;
  CollectionReference personalRiskCollection = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.toString())
      .collection("personalproject");

//update risk
  Future<void> update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      riskName = documentSnapshot['personalRiskName'];
      riskProbability = documentSnapshot['probability'];
      riskSeverity = documentSnapshot['severity'];
    }
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Edit risk name",
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
                      controller: updateRiskNameTextfield..text = riskName,
                      onChanged: (String value) {
                        riskName = value;
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
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(107, 151, 202, 1),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: const Text(
                            "Probability",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(239, 242, 241, 1),
                                fontSize: 15),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(107, 151, 202, 1),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: const Text(
                            "Severity",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(239, 242, 241, 1),
                                fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(236, 236, 236, 1),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              icon: const Icon(
                                CommunityMaterialIcons.chevron_down,
                                color: Color.fromRGBO(107, 151, 202, 1),
                              ),
                              iconSize: 50,
                              dropdownColor: Colors.white,
                              value: riskProbability,
                              onChanged: (String? newValueprobability) {
                                setState(
                                  () {
                                    riskProbability = newValueprobability!;
                                  },
                                );
                              },
                              items: probability.map<DropdownMenuItem<String>>(
                                (String valueup) {
                                  return DropdownMenuItem<String>(
                                    value: valueup,
                                    child: Center(
                                      child: Text(valueup),
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(236, 236, 236, 1),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              icon: const Icon(
                                CommunityMaterialIcons.chevron_down,
                                color: Color.fromRGBO(107, 151, 202, 1),
                              ),
                              iconSize: 50,
                              dropdownColor: Colors.white,
                              value: riskSeverity,
                              onChanged: (String? newValueseverity) {
                                setState(
                                  () {
                                    riskSeverity = newValueseverity!;
                                  },
                                );
                              },
                              items: severity.map<DropdownMenuItem<String>>(
                                (String valueus) {
                                  return DropdownMenuItem<String>(
                                    value: valueus,
                                    child: Center(
                                      child: Text(valueus),
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
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
                      if (updateRiskNameTextfield.text.isNotEmpty) {
                        final String name = updateRiskNameTextfield.text;
                        try {
                          await personalRiskCollection
                              .doc(documentID)
                              .collection("risks")
                              .doc(documentSnapshot!.id)
                              .update({"personalRiskName": name});

                          await personalRiskCollection
                              .doc(documentID)
                              .collection("risks")
                              .doc(documentSnapshot.id)
                              .update({"probability": riskProbability});

                          await personalRiskCollection
                              .doc(documentID)
                              .collection("risks")
                              .doc(documentSnapshot.id)
                              .update({"severity": riskSeverity});

                          alertDialog("Your risk has been updated!");
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
      },
    );
  }

//delete risk
  Future<void> delete(String riskID) async {
    try {
      await personalRiskCollection
          .doc(documentID)
          .collection("risks")
          .doc(riskID)
          .delete();

      alertDialog("Your issue has been deleted!");
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    if (!mounted) return;
    Navigator.of(context).pop;
  }

  Stream<QuerySnapshot<Object?>> riskOrder(String label, bool boolean) {
    Stream<QuerySnapshot> risks = FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection('personalproject')
        .doc(widget.docID)
        .collection("risks")
        .orderBy(label, descending: boolean)
        .where("projectID", isEqualTo: widget.docID)
        .snapshots();

    return risks;
  }

  final List<bool> _selections = List.generate(3, (_) => false);
  dynamic listOrder;

  @override
  void initState() {
    super.initState();
    setState(() {
      listOrder = riskOrder("created", true);
    });
  }

  @override
  void dispose() {
    updateRiskNameTextfield.dispose();
    riskNameTextfield.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      Column(children: [
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(107, 151, 202, 1),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: const Text(
                                "Risk",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color.fromRGBO(239, 242, 241, 1),
                                    fontSize: 18),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(top: 20),
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(236, 236, 236, 1),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: TextField(
                                  controller: riskNameTextfield,
                                  onChanged: (String valuern) {
                                    risknametext = valuern;
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
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(top: 10),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(107, 151, 202, 1),
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: const Text(
                                  "Probability",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromRGBO(239, 242, 241, 1),
                                      fontSize: 18),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(top: 10),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(107, 151, 202, 1),
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: const Text(
                                  "Severity",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromRGBO(239, 242, 241, 1),
                                      fontSize: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(236, 236, 236, 1),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    icon: const Icon(
                                      CommunityMaterialIcons.chevron_down,
                                      color: Color.fromRGBO(107, 151, 202, 1),
                                    ),
                                    iconSize: 50,
                                    dropdownColor: Colors.white,
                                    value: dropdownValuep,
                                    onChanged: (String? newValueprobability) {
                                      setState(
                                        () {
                                          dropdownValuep = newValueprobability!;
                                        },
                                      );
                                    },
                                    items: probability
                                        .map<DropdownMenuItem<String>>(
                                      (String valuep) {
                                        return DropdownMenuItem<String>(
                                          value: valuep,
                                          child: Center(
                                            child: Text(valuep),
                                          ),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(236, 236, 236, 1),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    icon: const Icon(
                                      CommunityMaterialIcons.chevron_down,
                                      color: Color.fromRGBO(107, 151, 202, 1),
                                    ),
                                    iconSize: 50,
                                    dropdownColor: Colors.white,
                                    value: dropdownValues,
                                    onChanged: (String? newValueseverity) {
                                      setState(
                                        () {
                                          dropdownValues = newValueseverity!;
                                        },
                                      );
                                    },
                                    items:
                                        severity.map<DropdownMenuItem<String>>(
                                      (String values) {
                                        return DropdownMenuItem<String>(
                                          value: values,
                                          child: Center(
                                            child: Text(values),
                                          ),
                                        );
                                      },
                                    ).toList(),
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
                          //add risk
                          onPressed: () async {
                            if (riskNameTextfield.text.isEmpty) {
                              alertDialog("Please fill in all fields!");
                            } else {
                              await AddPersonalRisks().createPersonalRisksModel(
                                  riskNameTextfield.text,
                                  DateTime.now(),
                                  widget.docID,
                                  dropdownValuep,
                                  dropdownValues);
                              riskNameTextfield.clear();

                              alertDialog("Your issue has been added!");
                            }
                          },
                        ),
                        const Header(
                          text: "Risks",
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
                          child: Column(
                            children: [
                              ToggleButtons(
                                isSelected: _selections,
                                onPressed: (int index) {
                                  setState(() {
                                    for (int i = 0;
                                        i < _selections.length;
                                        i++) {
                                      _selections[i] = i == index;
                                    }

                                    if (index == 0 && _selections[index]) {
                                      setState(() {
                                        listOrder = riskOrder("created", true);
                                      });
                                    }

                                    if (index == 1 && _selections[index]) {
                                      setState(() {
                                        listOrder =
                                            riskOrder("probability", true);
                                      });
                                    }

                                    if (index == 2 && _selections[index]) {
                                      setState(() {
                                        listOrder = riskOrder("severity", true);
                                      });
                                    }
                                  });
                                },
                                renderBorder: false,
                                constraints: const BoxConstraints(
                                  maxWidth: 120,
                                  minWidth: 50,
                                  minHeight: 40,
                                ),
                                disabledColor:
                                    const Color.fromRGBO(64, 89, 173, 1),
                                selectedColor: Colors.black,
                                fillColor: Colors.white,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 1),
                                    height: 35,
                                    width: 90,
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          151, 216, 196, 1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Center(
                                        child: Icon(Icons.replay_outlined)),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 1),
                                    height: 35,
                                    width: 90,
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          151, 216, 196, 1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Center(
                                        child: Text('Probability')),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 1),
                                    height: 35,
                                    width: 90,
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          151, 216, 196, 1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child:
                                        const Center(child: Text('Severity')),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              StreamBuilder(
                                stream: listOrder,
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot>
                                        streamSnapshot) {
                                  if (streamSnapshot.hasData) {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount:
                                          streamSnapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        final DocumentSnapshot
                                            documentSnapshot =
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
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        40)),
                                                    content: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 60,
                                                              right: 60),
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          IconButton(
                                                            icon: const Icon(
                                                                Icons.edit),
                                                            iconSize: 30,
                                                            color: const Color
                                                                    .fromRGBO(
                                                                151,
                                                                216,
                                                                196,
                                                                1),
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
                                                                    .fromARGB(
                                                                255,
                                                                201,
                                                                78,
                                                                100),
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
                                                      'personalRiskName'],
                                                  style: offwhite,
                                                ),
                                              ),
                                              subtitle: Column(
                                                children: [
                                                  Center(
                                                    child: Text(
                                                      "severity: "
                                                      '${documentSnapshot['severity']}',
                                                      style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              223,
                                                              223,
                                                              223),
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      "probability: "
                                                      '${documentSnapshot['probability']}',
                                                      style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              223,
                                                              223,
                                                              223),
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ],
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
                      ])
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
