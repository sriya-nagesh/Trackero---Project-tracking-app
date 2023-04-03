//Sriya Nagesh (SUKD1902368) BIT-UCLAN
import 'package:trackero/export.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final updateProfile = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid);

  final user = FirebaseAuth.instance.currentUser!;
  UserModel userModel = UserModel();

  String profilePicLink = "";
  //sets profile picture and saves picture to firebase storage
  void uploadImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 550,
      maxWidth: 550,
      imageQuality: 90,
    );
    String downloadURL;
    Reference ref =
        FirebaseStorage.instance.ref().child("${user.email!} profilepic.jpg");

    var upload = await ref.putFile(File(image!.path));

    downloadURL = await (upload).ref.getDownloadURL();

    setState(() {
      profilePicLink = downloadURL;
    });

    if (profilePicLink != "") {
      try {
        await updateProfile.update({'photoURL': profilePicLink});
        alertDialog("Your profile picture has been updated!");
        {
          setState(() {
            FirebaseFirestore.instance
                .collection("users")
                .doc(user.uid)
                .get()
                .then((value) => setState(
                    () => userModel = UserModel.fromMap(value.data())));
          });
        }
      } on FirebaseException catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    } else {
      alertDialog("An error occured , please try again!");
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection("users").doc(user.uid).get().then(
        (value) => setState(() => userModel = UserModel.fromMap(value.data())));
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
                      color: const Color.fromRGBO(107, 151, 202, 1),
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              CommunityMaterialIcons.arrow_left_drop_circle,
                              color: Color.fromRGBO(239, 242, 241, 1),
                            ),
                            iconSize: 40,
                          ),
                          const Expanded(
                            child: Text(
                              "EDIT PROFILE",
                              style: TextStyle(
                                fontSize: 40,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          uploadImage();
                        },
                        child: '${userModel.photoURL}'.isEmpty
                            ? const CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 255, 255, 255),
                                radius: 70,
                                child: Icon(
                                  Icons.photo_camera,
                                  color: Color.fromARGB(255, 72, 72, 72),
                                ),
                              )
                            : CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 70,
                                child: ClipOval(
                                    child: Image.network(
                                  '${userModel.photoURL}',
                                  errorBuilder:
                                      (context, exception, stackTrace) {
                                    return const Icon(
                                      Icons.photo_camera,
                                      color: Color.fromARGB(255, 72, 72, 72),
                                    );
                                  },
                                  width: 130,
                                  height: 130,
                                  fit: BoxFit.cover,
                                )),
                              ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          const Center(
                            child: Text("Email", style: defaultText),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 10),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 72, 72, 72),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                border: InputBorder.none,
                                hintText: user.email!,
                                hintStyle: offwhite,
                              ),
                              style: const TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 18,
                              ),
                              textInputAction: TextInputAction.done,
                              enabled: false,
                            ),
                          ),
                          const Center(
                            child: Text("Username", style: defaultText),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(236, 236, 236, 1),
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: TextField(
                                    controller: usernameController,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 20),
                                      border: InputBorder.none,
                                      hintText: userModel.displayName,
                                      hintStyle: lightblue,
                                    ),
                                    style: textbox,
                                    textInputAction: TextInputAction.done,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 8),
                                  width: double.infinity,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 84, 118, 157),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  //update username
                                  child: TextButton(
                                    onPressed: () {
                                      if (usernameController.text.isNotEmpty) {
                                        try {
                                          updateProfile.update({
                                            'displayName':
                                                usernameController.text
                                          });
                                          alertDialog(
                                              "you username has been updated!");
                                        } on FirebaseException catch (e) {
                                          if (kDebugMode) {
                                            print(e);
                                          }
                                        }
                                      } else {
                                        alertDialog(
                                            "Please fill in your username");
                                      }
                                    },
                                    child: const Text('Update',
                                        style: defaultText),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(107, 151, 202, 1),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: TextButton(
                              onPressed: () {
                                resetPassword();
                              },
                              child: const Text('Reset Password',
                                  style: defaultText),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 55, 76, 100),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            //logs user out of their account
                            child: TextButton(
                              onPressed: () {
                                FirebaseAuth.instance.signOut();
                                Navigator.pop(context);
                              },
                              child: const Text('Logout', style: defaultText),
                            ),
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

  //resets users password
  Future resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: user.email!);
      alertDialog("A link to reset your password has been sent to your email!");
      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        alertDialog('Email address entered format is not valid.');
      } else if (e.code == 'user-not-found') {
        alertDialog('There is not user with this email address!');
      }
    }
  }
}
