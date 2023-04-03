//Sriya Nagesh (SUKD1902368) BIT-UCLAN
import 'package:trackero/export.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key, required this.docID}) : super(key: key);
  final String docID;
  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final messageController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatRefresh = FirebaseFirestore.instance
        .collection('teamproject')
        .doc(widget.docID)
        .collection("chatbox")
        .orderBy("sent", descending: true);
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: const Color.fromRGBO(64, 89, 173, 1),
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: StreamBuilder(
                        stream: chatRefresh.snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                          if (streamSnapshot.hasData) {
                            return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              reverse: true,
                              itemCount: streamSnapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                //setting view for message display
                                final DocumentSnapshot documentSnapshot =
                                    streamSnapshot.data!.docs[index];
                                if (documentSnapshot['assigned'] ==
                                    user.email) {
                                  return Card(
                                    color:
                                        const Color.fromRGBO(107, 151, 202, 1),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 30),
                                      title: Text(
                                        documentSnapshot['assigned'],
                                        style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 223, 223, 223),
                                            fontSize: 14),
                                        textAlign: TextAlign.end,
                                      ),
                                      subtitle: Text(
                                        documentSnapshot['message'],
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 16),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  );
                                } else {
                                  return Card(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 30),
                                      title: Text(
                                        documentSnapshot['assigned'],
                                        style: const TextStyle(
                                            color:
                                                Color.fromRGBO(64, 89, 173, 1),
                                            fontSize: 14),
                                      ),
                                      subtitle: Text(
                                        documentSnapshot['message'],
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                    ),
                                  );
                                }
                              },
                            );
                          }

                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(236, 236, 236, 1),
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: TextField(
                                    controller: messageController,
                                    autofocus: false,
                                    textInputAction: TextInputAction.done,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      border: InputBorder.none,
                                      hintStyle: textbox,
                                      hintText: "Send a message!",
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              CircleAvatar(
                                radius: 25,
                                backgroundColor:
                                    const Color.fromRGBO(236, 236, 236, 1),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.send_rounded,
                                    color: Color.fromRGBO(151, 216, 196, 1),
                                  ),
                                  iconSize: 30,
                                  //add issue
                                  onPressed: () async {
                                    if (messageController.text == '') {
                                      alertDialog("There is no message!");
                                    } else {
                                      await AddTeamChat().createTeamChatModel(
                                          user.email.toString(),
                                          messageController.text,
                                          DateTime.now(),
                                          widget.docID);
                                      messageController.clear();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
