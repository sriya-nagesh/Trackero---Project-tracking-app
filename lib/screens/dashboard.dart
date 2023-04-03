//Sriya Nagesh (SUKD1902368) BIT-UCLAN
import 'package:trackero/export.dart';

//main dashboard
class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentindex = 0;
  final screens = [
    const Personal(),
    const Team(),
    const CompletedProjects(),
    const PTimer(),
    const UserSettings(),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        body: IndexedStack(
          index: currentindex,
          children: screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color.fromRGBO(239, 242, 241, 1),
          selectedItemColor: const Color.fromRGBO(64, 89, 173, 1),
          unselectedItemColor: const Color.fromRGBO(151, 216, 196, 1),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          iconSize: 60,
          currentIndex: currentindex,
          onTap: (index) => setState(() => currentindex = index),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "personal",
                backgroundColor: Colors.grey),
            BottomNavigationBarItem(
                icon: Icon(Icons.supervisor_account),
                label: "team",
                backgroundColor: Colors.grey),
            BottomNavigationBarItem(
                icon: Icon(Icons.done),
                label: "completed projects",
                backgroundColor: Colors.grey),
            BottomNavigationBarItem(
                icon: Icon(Icons.watch_later_outlined),
                label: "timer",
                backgroundColor: Colors.grey),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: "settings",
                backgroundColor: Colors.grey),
          ],
        ),
      );
}
