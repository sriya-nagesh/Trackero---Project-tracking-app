//Sriya Nagesh (SUKD1902368) BIT-UCLAN
import 'package:trackero/export.dart';

//project managers dashboard
class DashboardTeam extends StatefulWidget {
  const DashboardTeam({Key? key, required this.passdocID}) : super(key: key);
  final String passdocID;

  @override
  State<DashboardTeam> createState() => _DashboardTeamState();
}

class _DashboardTeamState extends State<DashboardTeam> {
  passDocToDashboardID() {
    return TeamDashboard(
      docID: widget.passdocID,
    );
  }

  passDocToMembersID() {
    return TeamMembers(
      docID: widget.passdocID,
    );
  }

  passDocToTasksID() {
    return TeamTasks(
      docID: widget.passdocID,
    );
  }

  passDocToIssuesID() {
    return TeamIssues(
      docID: widget.passdocID,
    );
  }

  passDocToRisksID() {
    return TeamRisks(
      docID: widget.passdocID,
    );
  }

  passDocToAnalyticsID() {
    return TeamAnalytics(
      docID: widget.passdocID,
    );
  }

  passDocToChatID() {
    return Chat(
      docID: widget.passdocID,
    );
  }

  passDocToFileID() {
    return TeamFiles(
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
          passDocToMembersID(),
          passDocToTasksID(),
          passDocToIssuesID(),
          passDocToRisksID(),
          passDocToAnalyticsID(),
          passDocToChatID(),
          passDocToFileID(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromRGBO(239, 242, 241, 1),
        selectedItemColor: const Color.fromRGBO(64, 89, 173, 1),
        unselectedItemColor: const Color.fromRGBO(151, 216, 196, 1),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 35,
        currentIndex: currentindex,
        onTap: (index) => setState(() => currentindex = index),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(CommunityMaterialIcons.home_analytics),
              label: "dashboard",
              backgroundColor: Colors.grey),
          BottomNavigationBarItem(
              icon: Icon(CommunityMaterialIcons.account_group),
              label: "members",
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
          BottomNavigationBarItem(
              icon: Icon(CommunityMaterialIcons.google_analytics),
              label: "analytics",
              backgroundColor: Colors.grey),
          BottomNavigationBarItem(
              icon: Icon(CommunityMaterialIcons.chat),
              label: "chat",
              backgroundColor: Colors.grey),
          BottomNavigationBarItem(
              icon: Icon(CommunityMaterialIcons.file_import),
              label: "files",
              backgroundColor: Colors.grey),
        ],
      ),
    );
  }
}
