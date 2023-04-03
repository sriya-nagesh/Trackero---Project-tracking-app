//Sriya Nagesh (SUKD1902368) BIT-UCLAN
import 'package:trackero/export.dart';

class TeamAnalytics extends StatefulWidget {
  const TeamAnalytics({Key? key, required this.docID}) : super(key: key);
  final String docID;
  @override
  State<TeamAnalytics> createState() => _TeamAnalyticsState();
}

final user = FirebaseAuth.instance.currentUser!;
List<dynamic> memberList = <dynamic>[];

class _TeamAnalyticsState extends State<TeamAnalytics> {
  Future getList() async {
    memberList.clear();
    await teamproject.doc(widget.docID).get().then((value) {
      if (user.email == value['ownerEmail']) {
      } else {
        memberList.add(value['ownerEmail']);
      }
      for (var value in List.from(value['members'])) {
        memberList.add(value);
        debugPrint(memberList.toString());
      }
    });
    return memberList;
  }

  @override
  void initState() {
    super.initState();
    getList();
    if (memberList.contains(user.email)) {
    } else {
      memberList.add(user.email);
    }

    tasksList();

    durationList();
  }

  String tasksString = "";
  String durationString = "";
  List<Widget> memberTasks = <Widget>[];
  List<Widget> memberDuration = <Widget>[];
  int tasks = 0;
  int duration = 0;
  int calculatedDuration = 0;

  Future tasksList() async {
    for (var i = 0; i < memberList.length; i++) {
      await teamproject
          .doc(widget.docID)
          .collection("tasks")
          .where("assigned", isEqualTo: memberList[i])
          .get()
          .then((value) {
        if (value.docs.isEmpty) {
          tasks = 0;
        } else {
          tasks = value.docs.length;
        }
      });

      //for grammar
      if (tasks == 1) {
        tasksString = memberList[i] + "\n" + tasks.toString() + " task";
      } else {
        tasksString = memberList[i] + "\n" + tasks.toString() + " tasks";
      }

      memberTasks.add(Container(
        height: 70,
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Text(
            tasksString,
            style: darkblue,
            textAlign: TextAlign.center,
          ),
        ),
      ));
    }
  }

  Future durationList() async {
    for (var i = 0; i < memberList.length; i++) {
      await teamproject
          .doc(widget.docID)
          .collection("tasks")
          .where("assigned", isEqualTo: memberList[i])
          .where("done", isEqualTo: true)
          .get()
          .then((value) async {
        if (value.docs.isEmpty) {
          tasks = 0;
        } else {
          tasks = value.docs.length;

          final emailSnapshot = memberList[i];
          String email = emailSnapshot.replaceAll(RegExp(r'[^\w\s]+'), '');

          duration = await teamproject
              .doc(widget.docID)
              .collection("tasks")
              .doc("durationmembers")
              .get()
              .then((value) {
            return value[email];
          });
          double calculatedDuration = duration / tasks;

          durationString =
              memberList[i] + "\n" + calculatedDuration.toString() + " minutes";
          debugPrint(durationString.toString());
          memberDuration.add(Container(
            height: 70,
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Text(
                durationString,
                style: darkblue,
                textAlign: TextAlign.center,
              ),
            ),
          ));
        }
      });
    }
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
                margin: const EdgeInsets.only(top: 25),
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Header(
                        text: "Average time per task",
                        color: Color.fromRGBO(107, 151, 202, 1),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(children: memberDuration),
                      const SizedBox(
                        height: 20,
                      ),
                      const Header(
                        text: "Number of tasks",
                        color: Color.fromRGBO(107, 151, 202, 1),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(children: memberTasks),
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
