//Sriya Nagesh (SUKD1902368) BIT-UCLAN
import 'package:trackero/export.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();
  final registerUsernameController = TextEditingController();
  final registerEmailController = TextEditingController();
  final registerConfirmPasswordController = TextEditingController();
  final registerPasswordController = TextEditingController();

  @override
  void dispose() {
    registerUsernameController.dispose();
    registerEmailController.dispose();
    registerConfirmPasswordController.dispose();
    registerPasswordController.dispose();
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
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      color: const Color.fromRGBO(107, 151, 202, 1),
                      child: const Center(
                        child: Image(
                          image: AssetImage('assets/images/screens/logo.png'),
                          height: 100,
                          width: 100,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          const Center(
                            child: Text("Username", style: defaultText),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(236, 236, 236, 1),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: TextField(
                              controller: registerUsernameController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                border: InputBorder.none,
                                hintText: 'Enter your username here',
                                hintStyle: textbox,
                              ),
                              style: textbox,
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          const Center(
                            child: Text("Email", style: defaultText),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(236, 236, 236, 1),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: TextField(
                              controller: registerEmailController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                border: InputBorder.none,
                                hintText: 'Enter your email here',
                                hintStyle: textbox,
                              ),
                              style: textbox,
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          const Center(
                            child: Text("Password", style: defaultText),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(236, 236, 236, 1),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: TextField(
                              controller: registerPasswordController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                border: InputBorder.none,
                                hintText: 'Enter your password here',
                                hintStyle: textbox,
                              ),
                              obscureText: true,
                              style: textbox,
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          const Center(
                            child: Text("Confirm Password", style: defaultText),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(236, 236, 236, 1),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: TextField(
                              controller: registerConfirmPasswordController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                border: InputBorder.none,
                                hintText: 'Confirm password',
                                hintStyle: textbox,
                              ),
                              obscureText: true,
                              style: textbox,
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Container(
                            margin: const EdgeInsets.all(15.0),
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(107, 151, 202, 1),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: TextButton(
                              onPressed: () {
                                if (registerEmailController.text.isNotEmpty &&
                                    registerUsernameController
                                        .text.isNotEmpty &&
                                    registerPasswordController
                                        .text.isNotEmpty &&
                                    registerConfirmPasswordController
                                        .text.isNotEmpty) {
                                  if (registerConfirmPasswordController.text ==
                                      registerPasswordController.text) {
                                    signUp();
                                  } else {
                                    alertDialog("Passwords dont match");
                                    registerConfirmPasswordController.clear();
                                    registerPasswordController.clear();
                                  }
                                } else {
                                  alertDialog("Please fill in all fields");
                                }
                              },
                              child: const Text('Register', style: defaultText),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //redirect to login page
                              TextButton(
                                child: const Text('Click to Login!',
                                    style: defaultText),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Login()),
                                  );
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

//Register
  Future signUp() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: registerEmailController.text.trim().toLowerCase(),
            password: registerPasswordController.text.trim(),
          )
          .then((value) => {
                postDetailsToFirestore(),
              });
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
      alertDialog('You have successfully registered!');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        alertDialog('Email address entered format is not valid.');
      } else if (e.code == 'email-already-in-use') {
        alertDialog('This email is already in use!');
      } else if (e.code == 'weak-password') {
        alertDialog(
            'Weak password, make sure your password is more than 6 characters!');
      }
    }
  }

//Map details into users table
  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    UserModel userModel = UserModel();
    PomodoroTimer pomodoroTimer = PomodoroTimer();

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.displayName = registerUsernameController.text;
    userModel.photoURL = "";

    pomodoroTimer.breakTime = 5;
    pomodoroTimer.workTime = 25;
    pomodoroTimer.count = 0;
    pomodoroTimer.userID = user.uid;
    pomodoroTimer.minutes = 0;
    pomodoroTimer.workText = "Continue work";
    pomodoroTimer.breakText = "Take a break";

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());

    PersonalProject()
        .createPersonalProject("Get Started!", "", user.uid, "", "", false);

    await firebaseFirestore
        .collection("timer")
        .doc(user.uid)
        .set(pomodoroTimer.toMap());

    alertDialog("Account created");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => const Dashboard()),
        (route) => false);
  }
}
