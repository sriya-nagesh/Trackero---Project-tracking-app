//Sriya Nagesh (SUKD1902368) BIT-UCLAN
import 'package:trackero/export.dart';

class PersonalTasks extends StatefulWidget {
  const PersonalTasks({Key? key, required this.docID}) : super(key: key);
  final String docID;
  @override
  State<PersonalTasks> createState() => _PersonalTasksState();
}

class _PersonalTasksState extends State<PersonalTasks> {
  DateTime now = DateTime.now();
  final user = FirebaseAuth.instance.currentUser!;
  List<String> items = <String>['High', 'Low'];
  String priority = 'High';
  DateTime dateTime = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, DateTime.now().hour, DateTime.now().minute);
  DateTime dateTimeUpdate = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, DateTime.now().hour, DateTime.now().minute);
  late dynamic taskDate;
  String taskName = "";
  final updateTaskNameTextfield = TextEditingController();
  String taskDescription = "";
  final updateDescriptionTextfield = TextEditingController();
  final taskNameTextfield = TextEditingController();
  final taskDescriptionTextfield = TextEditingController();
  String tasknametext = "";
  String taskdescriptiontext = "";
  late final documentID = widget.docID;

//pick time and date for task
  Future pickDateTime() async {
    DateTime? date = await pickDate();
    if (date == null) return;

    TimeOfDay? time = await pickTime();
    if (time == null) return;

    final dateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    setState(() => this.dateTime = dateTime);
  }

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );

  Future<TimeOfDay?> pickTime() => showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
      );

//Update tasks time and date
  Future pickDateTimeUpdate() async {
    DateTime? date = await pickDate();
    if (date == null) return;

    TimeOfDay? time = await pickTime();
    if (time == null) return;

    final dateTimeUpdate =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    setState(() => this.dateTimeUpdate = dateTimeUpdate);

    return dateTimeUpdate;
  }

  Future<DateTime?> pickDateUpdate() => showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );

  Future<TimeOfDay?> pickTimeUpdate() => showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
      );

//update task
  Future<void> update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      taskName = documentSnapshot['personalTaskName'];
      taskDescription = documentSnapshot['personalTaskDescription'];
      taskDate = documentSnapshot['dueDate'].toDate();
      priority = documentSnapshot['priority'];
    }
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
                content: SingleChildScrollView(
                  child: Column(
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
                          controller: updateTaskNameTextfield..text = taskName,
                          onChanged: (String value) {
                            taskName = value;
                          },
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                            border: InputBorder.none,
                            hintStyle: textbox,
                          ),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
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
                            ..text = taskDescription,
                          onChanged: (String value1) {
                            taskDescription = value1;
                          },
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                            border: InputBorder.none,
                            hintStyle: textbox,
                          ),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Edit due date",
                        style: darkblue,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 205, 205, 205),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                formatDate(taskDate, [
                                  dd,
                                  '/',
                                  mm,
                                  '/',
                                  yyyy,
                                  ' ',
                                  HH,
                                  ':',
                                  nn
                                ]).toString(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              CommunityMaterialIcons.calendar_account_outline,
                              color: Color.fromRGBO(151, 216, 196, 1),
                            ),
                            iconSize: 35,
                            onPressed: () {
                              pickDateTimeUpdate().then(
                                (value) => setState(
                                  () {
                                    if (value != null) {
                                      taskDate = value;
                                    } else {
                                      taskDate = DateTime.now();
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Priority",
                        style: darkblue,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 205, 205, 205),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            icon: const Icon(
                              CommunityMaterialIcons.chevron_down,
                              color: Color.fromRGBO(107, 151, 202, 1),
                            ),
                            iconSize: 50,
                            dropdownColor: Colors.white,
                            value: priority,
                            onChanged: (String? newValue) {
                              setState(
                                () {
                                  priority = newValue!;
                                },
                              );
                            },
                            items: items.map<DropdownMenuItem<String>>(
                              (String valueup) {
                                return DropdownMenuItem<String>(
                                  value: valueup,
                                  child: Text(valueup),
                                );
                              },
                            ).toList(),
                          ),
                        ),
                      ),
                    ],
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
                        if (updateTaskNameTextfield.text.isNotEmpty &&
                            updateDescriptionTextfield.text.isNotEmpty) {
                          try {
                            final String name = updateTaskNameTextfield.text;
                            await personalTaskCollection
                                .doc(documentID)
                                .collection("tasks")
                                .doc(documentSnapshot!.id)
                                .update({"personalTaskName": name});

                            final String description =
                                updateDescriptionTextfield.text;
                            await personalTaskCollection
                                .doc(documentID)
                                .collection("tasks")
                                .doc(documentSnapshot.id)
                                .update(
                                    {"personalTaskDescription": description});

                            await personalTaskCollection
                                .doc(documentID)
                                .collection("tasks")
                                .doc(documentSnapshot.id)
                                .update({"dueDate": taskDate});

                            await personalTaskCollection
                                .doc(documentID)
                                .collection("tasks")
                                .doc(documentSnapshot.id)
                                .update({"priority": priority});

                            alertDialog("Your task has been updated!");
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
                ]);
          },
        );
      },
    );
  }

//delete task
  Future<void> delete(String taskID) async {
    try {
      await personalTaskCollection
          .doc(documentID)
          .collection("tasks")
          .doc(taskID)
          .delete();

      alertDialog("Your task has been deleted!");
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Stream<QuerySnapshot<Object?>> taskOrder(String label, bool boolean) {
    Stream<QuerySnapshot> tasks = FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection('personalproject')
        .doc(widget.docID)
        .collection("tasks")
        .orderBy(label, descending: boolean)
        .where('done', isEqualTo: false)
        .where("projectID", isEqualTo: widget.docID)
        .snapshots();

    return tasks;
  }

  final List<bool> _selections = List.generate(3, (_) => false);
  dynamic listOrder;

  @override
  void initState() {
    super.initState();
    setState(() {
      listOrder = taskOrder("created", true);
    });
  }

  @override
  void dispose() {
    updateTaskNameTextfield.dispose();
    updateDescriptionTextfield.dispose();
    taskNameTextfield.dispose();
    taskDescriptionTextfield.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> completedTasks = FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection('personalproject')
        .doc(widget.docID)
        .collection("tasks")
        .where('projectID', isEqualTo: widget.docID)
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
                            text: "Task Name",
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
                                    controller: taskNameTextfield,
                                    onChanged: (String valuetn) {
                                      tasknametext = valuetn;
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
                            text: "Task Description",
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
                                    controller: taskDescriptionTextfield,
                                    onChanged: (String valuetd) {
                                      taskdescriptiontext = valuetd;
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
                            text: "Due Date",
                            color: Color.fromRGBO(107, 151, 202, 1),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: Text(
                                    '${dateTime.day}/${dateTime.month}/${dateTime.year}   ${dateTime.hour}.${dateTime.minute}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  CommunityMaterialIcons
                                      .calendar_account_outline,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                iconSize: 35,
                                onPressed: pickDateTime,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Header(
                        text: "Priority",
                        color: Color.fromRGBO(107, 151, 202, 1),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(236, 236, 236, 1),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            icon: const Icon(
                              CommunityMaterialIcons.chevron_down,
                              color: Color.fromRGBO(107, 151, 202, 1),
                            ),
                            iconSize: 50,
                            dropdownColor: Colors.white,
                            value: priority,
                            onChanged: (String? newValue) {
                              setState(
                                () {
                                  priority = newValue!;
                                },
                              );
                            },
                            items: items.map<DropdownMenuItem<String>>(
                              (String valueup) {
                                return DropdownMenuItem<String>(
                                  value: valueup,
                                  child: Text(valueup),
                                );
                              },
                            ).toList(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          CommunityMaterialIcons.plus_circle,
                          color: Color.fromRGBO(151, 216, 196, 1),
                        ),
                        iconSize: 50,
                        //add task
                        onPressed: () async {
                          if (taskNameTextfield.text.isEmpty &&
                              taskDescriptionTextfield.text.isEmpty) {
                            alertDialog("Please fill in name and description!");
                          } else {
                            await AddPersonalTasks().createPersonalTasksModel(
                                taskNameTextfield.text,
                                DateTime.now(),
                                widget.docID,
                                taskDescriptionTextfield.text,
                                dateTime,
                                false,
                                "",
                                0,
                                priority);
                            taskNameTextfield.clear();
                            taskDescriptionTextfield.clear();

                            alertDialog("Your task has been added!");
                          }
                        },
                      ),
                      const Header(
                        text: "Tasks",
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
                                  for (int i = 0; i < _selections.length; i++) {
                                    _selections[i] = i == index;
                                  }

                                  if (index == 0 && _selections[index]) {
                                    setState(() {
                                      listOrder = taskOrder("created", true);
                                    });
                                  }

                                  if (index == 1 && _selections[index]) {
                                    setState(() {
                                      listOrder = taskOrder("dueDate", false);
                                    });
                                  }

                                  if (index == 2 && _selections[index]) {
                                    setState(() {
                                      listOrder = taskOrder("priority", false);
                                    });
                                  }
                                });
                              },
                              renderBorder: false,
                              constraints: const BoxConstraints(
                                maxWidth: 180,
                                minWidth: 50,
                                minHeight: 40,
                              ),
                              disabledColor:
                                  const Color.fromRGBO(64, 89, 173, 1),
                              selectedColor: Colors.black,
                              fillColor: Colors.white,
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 1),
                                  height: 35,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(151, 216, 196, 1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Center(
                                      child: Icon(Icons.replay_outlined)),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 1),
                                  height: 35,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(151, 216, 196, 1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Center(child: Text('Due date')),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 1),
                                  height: 35,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(151, 216, 196, 1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Center(child: Text('Priority')),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(236, 236, 236, 1),
                              ),
                              child: StreamBuilder(
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
                                              trailing: Column(children: [
                                                if (documentSnapshot[
                                                        'priority'] ==
                                                    "High") ...[
                                                  Icon(
                                                    Icons.priority_high_rounded,
                                                    color: Colors.red.shade200,
                                                  )
                                                ] else ...[
                                                  const Icon(
                                                    Icons.circle,
                                                    color: Color.fromRGBO(
                                                        151, 216, 196, 1),
                                                  )
                                                ],
                                              ]),
                                              leading: Checkbox(
                                                checkColor: Colors.white,
                                                activeColor:
                                                    const Color.fromRGBO(
                                                        151, 216, 196, 1),
                                                value: documentSnapshot['done'],
                                                onChanged: (value) async {
                                                  DateTime dateTimeCreatedAt =
                                                      documentSnapshot[
                                                              'created']
                                                          .toDate();

                                                  int time = DateTime.now()
                                                      .difference(
                                                          dateTimeCreatedAt)
                                                      .inMinutes;
                                                  await personalTaskCollection
                                                      .doc(documentID)
                                                      .collection("tasks")
                                                      .doc(documentSnapshot.id)
                                                      .update({"done": value});

                                                  await personalTaskCollection
                                                      .doc(documentID)
                                                      .collection("tasks")
                                                      .doc(documentSnapshot.id)
                                                      .update({
                                                    "completed": DateTime.now()
                                                  });

                                                  await personalTaskCollection
                                                      .doc(documentID)
                                                      .collection("tasks")
                                                      .doc(documentSnapshot.id)
                                                      .update({"time": time});

                                                  alertDialog(
                                                      "Task completed!");
                                                },
                                              ),
                                              title: Center(
                                                child: Text(
                                                  documentSnapshot[
                                                      'personalTaskName'],
                                                  style: offwhite,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              subtitle: Column(
                                                children: [
                                                  Center(
                                                    child: Text(
                                                      documentSnapshot[
                                                          'personalTaskDescription'],
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              223,
                                                              223,
                                                              223),
                                                          fontSize: 14),
                                                    ),
                                                  ),
                                                  Column(children: [
                                                    if (documentSnapshot[
                                                            'dueDate']
                                                        .toDate()
                                                        .isBefore(DateTime
                                                            .now())) ...[
                                                      Text(
                                                        formatDate(
                                                            documentSnapshot[
                                                                    'dueDate']
                                                                .toDate(),
                                                            [
                                                              dd,
                                                              '/',
                                                              mm,
                                                              '/',
                                                              yyyy,
                                                              '   ',
                                                              HH,
                                                              ':',
                                                              nn
                                                            ]).toString(),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    172,
                                                                    47,
                                                                    38),
                                                            fontSize: 16),
                                                      ),
                                                    ] else ...[
                                                      Text(
                                                        formatDate(
                                                            documentSnapshot[
                                                                    'dueDate']
                                                                .toDate(),
                                                            [
                                                              dd,
                                                              '/',
                                                              mm,
                                                              '/',
                                                              yyyy,
                                                              '   ',
                                                              HH,
                                                              ':',
                                                              nn
                                                            ]).toString(),
                                                        style: const TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    223,
                                                                    223,
                                                                    223),
                                                            fontSize: 16),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ]
                                                  ]),
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
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Header(
                        text: "Completed Tasks",
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
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(236, 236, 236, 1),
                              ),
                              child: StreamBuilder(
                                stream: completedTasks,
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
                                              trailing: Column(children: [
                                                if (documentSnapshot[
                                                        'priority'] ==
                                                    "High") ...[
                                                  Icon(
                                                    Icons.priority_high_rounded,
                                                    color: Colors.red.shade200,
                                                  )
                                                ] else ...[
                                                  const Icon(
                                                    Icons.circle,
                                                    color: Color.fromRGBO(
                                                        151, 216, 196, 1),
                                                  )
                                                ],
                                              ]),
                                              leading: Checkbox(
                                                checkColor: Colors.white,
                                                activeColor:
                                                    const Color.fromRGBO(
                                                        151, 216, 196, 1),
                                                value: documentSnapshot['done'],
                                                onChanged: (value) async {
                                                  await personalTaskCollection
                                                      .doc(documentID)
                                                      .collection("tasks")
                                                      .doc(documentSnapshot.id)
                                                      .update({"done": value});

                                                  await personalTaskCollection
                                                      .doc(documentID)
                                                      .collection("tasks")
                                                      .doc(documentSnapshot.id)
                                                      .update(
                                                          {"completed": ""});

                                                  await personalTaskCollection
                                                      .doc(documentID)
                                                      .collection("tasks")
                                                      .doc(documentSnapshot.id)
                                                      .update({"time": 0});

                                                  alertDialog(
                                                      "Task moved to ongoing");
                                                },
                                              ),
                                              title: Center(
                                                child: Text(
                                                  documentSnapshot[
                                                      'personalTaskName'],
                                                  style: offwhite,
                                                ),
                                              ),
                                              subtitle: Center(
                                                child: Text(
                                                  "Done in ${documentSnapshot['time']} minutes",
                                                  style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 223, 223, 223),
                                                      fontSize: 14),
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
