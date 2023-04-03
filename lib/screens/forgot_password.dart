//Sriya Nagesh (SUKD1902368) BIT-UCLAN
import 'package:trackero/export.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
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
                        height: 250,
                      ),
                      const Center(
                        child: Text("Enter your email to reset your password",
                            style: defaultText),
                      ),
                      const SizedBox(
                        height: 30,
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
                          onPressed: () {
                            if (emailController.text.isNotEmpty) {
                              resetPassword();
                            } else {
                              alertDialog("Please enter your email!");
                            }
                          },
                          child:
                              const Text('Reset Password', style: defaultText),
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

//function to reset users password
  Future resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      alertDialog('An email has been sent!');
      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        alertDialog('Email address entered is not a valid format.');
        emailController.clear();
      } else if (e.code == 'user-not-found') {
        alertDialog('There is no user with this email!');
        emailController.clear();
      }
    }
  }
}
