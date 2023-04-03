//Sriya Nagesh (SUKD1902368) BIT-UCLAN
//login page

import 'package:trackero/export.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                        height: 50,
                      ),
                      const Center(
                        child: Image(
                          image: AssetImage('assets/images/screens/logo.png'),
                          height: 140,
                          width: 140,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
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
                          controller: emailController,
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
                        height: 30,
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
                          controller: passwordController,
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
                        height: 30,
                      ),
                      Container(
                        //log into to account
                        margin: const EdgeInsets.all(15.0),
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(107, 151, 202, 1),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: TextButton(
                          onPressed: signIn,
                          child: const Text('Login', style: defaultText),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ForgotPassword()),
                          );
                        },
                        child:
                            const Text('Forgot Password?', style: defaultText),
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //redirect to register page
                          TextButton(
                            child: const Text('Click to Register!',
                                style: defaultText),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Register()),
                              );
                            },
                          )
                        ],
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

//Login
  Future signIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: ((context) => const Center(
            child: CircularProgressIndicator(),
          )),
    );

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          )
          .then((uid) => {});
      alertDialog("You have successfully logged in!");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        alertDialog('Email address entered is not valid.');
      } else if (e.code == 'wrong-password') {
        alertDialog('Wrong password entered!');
      } else if (e.code == 'user-not-found') {
        alertDialog('There is no user with this email!');
      }
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
