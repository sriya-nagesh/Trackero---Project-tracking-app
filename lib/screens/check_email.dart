//Sriya Nagesh (SUKD1902368) BIT-UCLAN
import 'package:trackero/export.dart';

class CheckEmail extends StatefulWidget {
  const CheckEmail({Key? key}) : super(key: key);

  @override
  State<CheckEmail> createState() => _CheckEmailState();
}

class _CheckEmailState extends State<CheckEmail> {
  bool isEmailChecked = false;
  bool resend = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    isEmailChecked = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailChecked) {
      sendVerification();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkIfVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

//check of user has verified
  Future checkIfVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailChecked = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailChecked) timer?.cancel();
  }

//send verification to users email
  Future sendVerification() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => resend = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => resend = true);
    } catch (e) {
      alertDialog(e.toString());
    }
  }

  @override
  //display dashboard if user has verfied email
  Widget build(BuildContext context) => isEmailChecked
      ? const Dashboard()
      : SafeArea(
          child: Stack(
            children: [
              const Background(
                image: 'assets/images/screens/login.png',
              ),
              Scaffold(
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 250,
                            ),
                            const Center(
                              child: Text(
                                  "A verification email has been sent to your registered email, please verify your account!",
                                  style: defaultText),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              width: double.infinity,
                              height: 60,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(107, 151, 202, 1),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  if (resend == true) {
                                    sendVerification;
                                  }
                                },
                                child: const Text('Resend Email',
                                    style: defaultText),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              width: double.infinity,
                              height: 60,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(107, 151, 202, 1),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: TextButton(
                                onPressed: () =>
                                    FirebaseAuth.instance.signOut(),
                                child: const Text('Back to Login page',
                                    style: defaultText),
                              ),
                            )
                          ]),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
}
