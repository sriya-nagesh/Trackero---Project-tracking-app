//Sriya Nagesh (SUKD1902368) BIT-UCLAN
import 'package:trackero/export.dart';

//personal dashboard
class DashboardPersonal extends StatefulWidget {
  const DashboardPersonal({Key? key, required this.passdocID})
      : super(key: key);
  final String passdocID;

  @override
  State<DashboardPersonal> createState() => _DashboardPersonalState();
}

class _DashboardPersonalState extends State<DashboardPersonal> {
  passDocToDashboardID() {
    return PersonalDashboard(
      docID: widget.passdocID,
    );
  }

  passDocToTasksID() {
    return PersonalTasks(
      docID: widget.passdocID,
    );
  }

  passDocToIssuesID() {
    return PersonalIssues(
      docID: widget.passdocID,
    );
  }

  passDocToRisksID() {
    return PersonalRisks(
      docID: widget.passdocID,
    );
  }

  int currentindex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentindex,
        children: [
          passDocToDashboardID(),
          passDocToTasksID(),
          passDocToIssuesID(),
          passDocToRisksID(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromRGBO(239, 242, 241, 1),
        selectedItemColor: const Color.fromRGBO(64, 89, 173, 1),
        unselectedItemColor: const Color.fromRGBO(151, 216, 196, 1),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 40,
        currentIndex: currentindex,
        onTap: (index) => setState(() => currentindex = index),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(CommunityMaterialIcons.home_analytics),
              label: "dashboard",
              backgroundColor: Colors.grey),
          BottomNavigationBarItem(
              icon: Icon(CommunityMaterialIcons.fountain_pen_tip),
              label: "tasks",
              backgroundColor: Colors.grey),
          BottomNavigationBarItem(
              icon: Icon(CommunityMaterialIcons.alert_circle_outline),
              label: "issues",
              backgroundColor: Colors.grey),
          BottomNavigationBarItem(
              icon: Icon(CommunityMaterialIcons.alert_outline),
              label: "risks",
              backgroundColor: Colors.grey),
        ],
      ),
    );
  }
}
