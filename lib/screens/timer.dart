//Sriya Nagesh (SUKD1902368) BIT-UCLAN
import 'package:trackero/export.dart';

Duration restT = const Duration(minutes: 0);
Duration workT = const Duration(minutes: 0);

class PTimer extends StatefulWidget {
  const PTimer({Key? key}) : super(key: key);

  @override
  State<PTimer> createState() => _PTimerState();
}

class _PTimerState extends State<PTimer> {
  String breaktext = "", worktext = "";
  int w = 0, mins = 0;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  PomodoroTimer pomodoroTimer = PomodoroTimer();
  FlutterTts flutterTts = FlutterTts();
  late Stopwatch stopwatch;
  late Timer timer;
  final updatework = TextEditingController();
  final updatebreak = TextEditingController();
  final updateworktext = TextEditingController();
  final updatebreaktext = TextEditingController();
  Duration timeRemaining = const Duration();
  Duration newTimeRemaining = const Duration();
  final Pomodoro pomodoro = Pomodoro(status: Status.work, count: 0);
  final user = FirebaseAuth.instance.currentUser!;

//TTS for alarm
  Future speak(String text) async {
    await flutterTts.setLanguage("en-AU");
    await flutterTts.setPitch(0.5);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }

  Future getWorkTime() async {
    final ref = FirebaseFirestore.instance
        .collection('timer')
        .doc(user.uid)
        .withConverter(
          fromFirestore: PomodoroTimer.fromFirestore,
          toFirestore: (PomodoroTimer pomodoroTimer, _) =>
              pomodoroTimer.toFirestore(),
        );
    final docSnap = await ref.get();
    final pomodoroTimer = docSnap.data();
    if (pomodoroTimer != null) {
      return pomodoroTimer.workTime;
    } else {}
  }

  Future getBreakTime() async {
    final ref = FirebaseFirestore.instance
        .collection('timer')
        .doc(user.uid)
        .withConverter(
          fromFirestore: PomodoroTimer.fromFirestore,
          toFirestore: (PomodoroTimer pomodoroTimer, _) =>
              pomodoroTimer.toFirestore(),
        );
    final docSnap = await ref.get();
    final pomodoroTimer = docSnap.data();
    if (pomodoroTimer != null) {
      return pomodoroTimer.breakTime;
    } else {}
  }

  Future getMinutes() async {
    final ref = FirebaseFirestore.instance
        .collection('timer')
        .doc(user.uid)
        .withConverter(
          fromFirestore: PomodoroTimer.fromFirestore,
          toFirestore: (PomodoroTimer pomodoroTimer, _) =>
              pomodoroTimer.toFirestore(),
        );
    final docSnap = await ref.get();
    final pomodoroTimer = docSnap.data();
    if (pomodoroTimer != null) {
      return pomodoroTimer.minutes;
    } else {}
  }

  Future getBreakText() async {
    final ref = FirebaseFirestore.instance
        .collection('timer')
        .doc(user.uid)
        .withConverter(
          fromFirestore: PomodoroTimer.fromFirestore,
          toFirestore: (PomodoroTimer pomodoroTimer, _) =>
              pomodoroTimer.toFirestore(),
        );
    final docSnap = await ref.get();
    final pomodoroTimer = docSnap.data();
    if (pomodoroTimer != null) {
      return pomodoroTimer.breakText;
    } else {}
  }

  Future getWorkText() async {
    final ref = FirebaseFirestore.instance
        .collection('timer')
        .doc(user.uid)
        .withConverter(
          fromFirestore: PomodoroTimer.fromFirestore,
          toFirestore: (PomodoroTimer pomodoroTimer, _) =>
              pomodoroTimer.toFirestore(),
        );
    final docSnap = await ref.get();
    final pomodoroTimer = docSnap.data();
    if (pomodoroTimer != null) {
      return pomodoroTimer.workText;
    } else {}
  }

  @override
  void initState() {
    super.initState();
    getWorkTime().then((value) {
      setState(() {
        workT = Duration(minutes: value);
        w = value;
      });
    });
    getBreakTime().then((value) {
      setState(() {
        restT = Duration(minutes: value);
      });
    });
    getMinutes().then((value) {
      setState(() {
        mins = value;
      });
    });
    getWorkText().then((value) {
      setState(() {
        worktext = value.toString();
      });
    });
    getBreakText().then((value) {
      setState(() {
        breaktext = value.toString();
      });
    });

    if (breaktext.isEmpty) {
      breaktext = "Take a break";
    }

    if (worktext.isEmpty) {
      worktext = "Start your work";
    }

    // pomodoro.time = workTime;
    stopwatch = Stopwatch();
    timer = Timer.periodic(const Duration(milliseconds: 50), _callback);
  }

  @override
  void dispose() {
    timer.cancel();

    super.dispose();
  }

  Duration pass = workT;
  //switches status
  void _callback(Timer timer) {
    if (pomodoro.status == Status.rest) {
      pass = restT;
    } else {
      pass = workT;
    }
    if (stopwatch.elapsed > pass) {
      setState(() {
        _changeNextStatus();
      });
      return;
    }

    if (pomodoro.status == Status.rest) {
      newTimeRemaining = restT - stopwatch.elapsed;
    }
    if (pomodoro.status == Status.work) {
      newTimeRemaining = workT - stopwatch.elapsed;
    }
    if (newTimeRemaining.inSeconds != timeRemaining.inSeconds) {
      setState(() {
        timeRemaining = newTimeRemaining;
      });
    }
  }

  Future<void> _changeNextStatus() async {
    stopwatch.stop();
    stopwatch.reset();

    if (pomodoro.status == Status.work) {
      pomodoro.count++;
      await FirebaseFirestore.instance.collection("timer").doc(user.uid).update(
        {"count": FieldValue.increment(1)},
      );

      await FirebaseFirestore.instance.collection("timer").doc(user.uid).update(
        {"minutes": FieldValue.increment(w)},
      );
      getMinutes().then((value) {
        setState(() {
          mins = value;
        });
      });
      pomodoro.setParam(status: Status.rest);
      Clipboard.setData(const ClipboardData());
      HapticFeedback.heavyImpact();
      speak(breaktext);
    } else {
      pomodoro.setParam(status: Status.work);
      Clipboard.setData(const ClipboardData());
      HapticFeedback.heavyImpact();
      speak(worktext);
    }
  }

  void reset() {
    if (!stopwatch.isRunning) {
      setState(
        () {
          stopwatch.reset();
        },
      );
    }
  }

  void pause() {
    setState(
      () {
        if (stopwatch.isRunning) {
          stopwatch.stop();
        }
      },
    );
  }

  void start() {
    if (!stopwatch.isRunning) {
      setState(
        () {
          stopwatch.start();
        },
      );
    }
  }

//displays remaining time to users
  Widget displayTime() {
    String minutes = (timeRemaining.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (timeRemaining.inSeconds % 60).toString().padLeft(2, '0');

    return Text(
      "$minutes:$seconds",
      style: const TextStyle(
        fontSize: 50,
        color: Color.fromRGBO(64, 89, 173, 1),
      ),
      textAlign: TextAlign.center,
    );
  }

//switches status text
  Widget pomodoroStatus() {
    String text;
    if (pomodoro.status == Status.work) {
      text = 'WORK';
    } else {
      text = 'BREAK';
    }
    return Text(text,
        style: const TextStyle(fontSize: 30, color: Colors.white));
  }

//switches progress bar colour
  Color progressBarColour() {
    if (pomodoro.status == Status.work) {
      return const Color.fromRGBO(107, 151, 202, 1);
    } else if (pomodoro.status == Status.rest) {
      return const Color.fromRGBO(141, 221, 88, 1);
    } else {
      return const Color.fromRGBO(242, 255, 0, 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (workT == const Duration(minutes: 0)) {
      getWorkTime().then((value) {
        setState(() {
          workT = Duration(minutes: value);
          w = value;
        });
      });
    }
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: const Color.fromRGBO(64, 89, 173, 1),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor:
                                const Color.fromRGBO(107, 151, 202, 1),
                            child: IconButton(
                              icon: const Icon(
                                CommunityMaterialIcons.timer_outline,
                                color: Color.fromRGBO(239, 242, 241, 1),
                              ),
                              iconSize: 40,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Container(
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        255, 205, 205, 205),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: TextField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    inputFormatters: <
                                                        TextInputFormatter>[
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                    ],
                                                    controller: updatework
                                                      ..text = workT.inMinutes
                                                          .toString(),
                                                    decoration: const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        20),
                                                        border:
                                                            InputBorder.none,
                                                        hintStyle: defaultText,
                                                        hintText:
                                                            "Change work duration(minutes)"),
                                                    style: textbox,
                                                    textInputAction:
                                                        TextInputAction.done,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: IconButton(
                                                    onPressed: () async {
                                                      if (updatework.text
                                                              .isNotEmpty &&
                                                          updatework.text !=
                                                              "0") {
                                                        num workt = int.parse(
                                                            updatework.text);

                                                        await firebaseFirestore
                                                            .collection("timer")
                                                            .doc(user.uid)
                                                            .update({
                                                          "workTime": workt
                                                        });
                                                        if (!mounted) return;
                                                        Navigator.of(context)
                                                            .pop();

                                                        getWorkTime()
                                                            .then((value) {
                                                          setState(() {
                                                            workT = Duration(
                                                                minutes: value);
                                                            w = value;
                                                          });
                                                        });

                                                        alertDialog(
                                                            "Your work time has been updated!");
                                                      } else {
                                                        alertDialog(
                                                            "Fill in the textbox with a valid number");
                                                      }
                                                    },
                                                    icon: const CircleAvatar(
                                                        radius: 30,
                                                        backgroundColor:
                                                            Color.fromRGBO(107,
                                                                151, 202, 1),
                                                        child: Icon(
                                                            Icons.update))),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Container(
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        255, 205, 205, 205),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: TextField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    inputFormatters: <
                                                        TextInputFormatter>[
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                    ],
                                                    controller: updatebreak
                                                      ..text = restT.inMinutes
                                                          .toString(),
                                                    decoration: const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        20),
                                                        border:
                                                            InputBorder.none,
                                                        hintStyle: defaultText,
                                                        hintText:
                                                            "Change break duration(minutes)"),
                                                    style: textbox,
                                                    textInputAction:
                                                        TextInputAction.done,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: IconButton(
                                                    onPressed: () async {
                                                      if (updatebreak.text
                                                              .isNotEmpty &&
                                                          updatebreak.text !=
                                                              "0") {
                                                        num restt = int.parse(
                                                            updatebreak.text);

                                                        await firebaseFirestore
                                                            .collection("timer")
                                                            .doc(user.uid)
                                                            .update({
                                                          "breakTime": restt
                                                        });

                                                        getBreakTime()
                                                            .then((value) {
                                                          setState(() {
                                                            restT = Duration(
                                                                minutes: value);
                                                          });
                                                        });

                                                        alertDialog(
                                                            "Your break time has been updated!");

                                                        if (!mounted) return;
                                                        Navigator.of(context)
                                                            .pop();
                                                      } else {
                                                        alertDialog(
                                                            "Fill in the textbox with a valid number");
                                                      }
                                                    },
                                                    icon: const CircleAvatar(
                                                        radius: 30,
                                                        backgroundColor:
                                                            Color.fromRGBO(107,
                                                                151, 202, 1),
                                                        child: Icon(
                                                            Icons.update))),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Container(
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        255, 205, 205, 205),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: TextField(
                                                    controller: updateworktext
                                                      ..text = worktext,
                                                    decoration: const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        20),
                                                        border:
                                                            InputBorder.none,
                                                        hintStyle: defaultText,
                                                        hintText:
                                                            "Change text for work alarm"),
                                                    style: textbox,
                                                    textInputAction:
                                                        TextInputAction.done,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: IconButton(
                                                    onPressed: () async {
                                                      if (updateworktext
                                                          .text.isNotEmpty) {
                                                        await firebaseFirestore
                                                            .collection("timer")
                                                            .doc(user.uid)
                                                            .update({
                                                          "workText":
                                                              updateworktext
                                                                  .text
                                                        });
                                                        if (!mounted) return;
                                                        Navigator.of(context)
                                                            .pop();

                                                        getWorkText()
                                                            .then((value) {
                                                          setState(() {
                                                            worktext = value;
                                                          });
                                                        });

                                                        alertDialog(
                                                            "Your work text has been updated");
                                                      } else {
                                                        alertDialog(
                                                            "The textbox is empty");
                                                      }
                                                    },
                                                    icon: const CircleAvatar(
                                                        radius: 30,
                                                        backgroundColor:
                                                            Color.fromRGBO(107,
                                                                151, 202, 1),
                                                        child: Icon(
                                                            Icons.update))),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Container(
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        255, 205, 205, 205),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: TextField(
                                                    controller: updatebreaktext
                                                      ..text = breaktext,
                                                    decoration: const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        20),
                                                        border:
                                                            InputBorder.none,
                                                        hintStyle: defaultText,
                                                        hintText:
                                                            "Change text for break alarm"),
                                                    style: textbox,
                                                    textInputAction:
                                                        TextInputAction.done,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: IconButton(
                                                    onPressed: () async {
                                                      if (updatebreaktext
                                                          .text.isNotEmpty) {
                                                        await firebaseFirestore
                                                            .collection("timer")
                                                            .doc(user.uid)
                                                            .update({
                                                          "breakText":
                                                              updatebreaktext
                                                                  .text
                                                        });
                                                        if (!mounted) return;
                                                        Navigator.of(context)
                                                            .pop();

                                                        getBreakText()
                                                            .then((value) {
                                                          setState(() {
                                                            breaktext = value;
                                                          });
                                                        });

                                                        alertDialog(
                                                            "Your break text has been updated");
                                                      } else {
                                                        alertDialog(
                                                            "The textbox is empty");
                                                      }
                                                    },
                                                    icon: const CircleAvatar(
                                                        radius: 30,
                                                        backgroundColor:
                                                            Color.fromRGBO(107,
                                                                151, 202, 1),
                                                        child: Icon(
                                                            Icons.update))),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(236, 236, 236, 1),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  " Minutes worked: $mins",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text(
                                              "Are you sure you want to restart tracking?",
                                              style: darkblue,
                                              textAlign: TextAlign.center),
                                          actions: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromRGBO(
                                                              107, 151, 202, 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: TextButton(
                                                      onPressed: () async {
                                                        try {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'timer')
                                                              .doc(user.uid)
                                                              .update({
                                                            "minutes": 0
                                                          });

                                                          getMinutes()
                                                              .then((value) {
                                                            setState(() {
                                                              mins = value;
                                                            });
                                                          });
                                                          alertDialog(
                                                              "Your tracking has restarted");
                                                          speak(
                                                              "Your tracking has restarted");
                                                        } on FirebaseException catch (e) {
                                                          if (kDebugMode) {
                                                            print(e);
                                                          }
                                                        }
                                                        if (!mounted) return;
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text('yes',
                                                          style: defaultText),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromRGBO(
                                                              107, 151, 202, 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text(
                                                          'cancel',
                                                          style: defaultText),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.replay_outlined,
                                      color: Color.fromARGB(255, 244, 115, 115),
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 38,
                      ),
                      Stack(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: const ShapeDecoration(
                              color: Color.fromRGBO(239, 242, 241, 1),
                              shape: CircleBorder(),
                            ),
                            child: SizedBox(
                              width: 200,
                              height: 200,
                              child: CircularProgressIndicator(
                                value: pomodoro.status == Status.rest
                                    ? (newTimeRemaining.inSeconds /
                                        restT.inSeconds)
                                    : (newTimeRemaining.inSeconds /
                                        workT.inSeconds),
                                color: progressBarColour(),
                                strokeWidth: 8,
                              ),
                            ),
                          ),
                          Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              top: 0,
                              child: Center(
                                child: displayTime(),
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      pomodoroStatus(),
                      Text(
                        "Count: ${pomodoro.count}",
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Ink(
                                decoration: const ShapeDecoration(
                                  color: Color.fromARGB(255, 224, 145, 100),
                                  shape: CircleBorder(),
                                ),
                                child: IconButton(
                                    icon: Icon(stopwatch.isRunning
                                        ? null
                                        : Icons.refresh),
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    iconSize: 30,
                                    onPressed: () => reset())),
                            Ink(
                              decoration: const ShapeDecoration(
                                color: Color.fromARGB(255, 145, 203, 107),
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                icon: Icon(stopwatch.isRunning
                                    ? null
                                    : Icons.play_arrow),
                                color: const Color.fromARGB(255, 255, 255, 255),
                                iconSize: 30,
                                onPressed: () => start(),
                              ),
                            ),
                            Ink(
                              decoration: const ShapeDecoration(
                                color: Color.fromRGBO(107, 151, 202, 1),
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                icon: Icon(stopwatch.isRunning
                                    ? Icons.pause
                                    : Icons.pause),
                                color: const Color.fromARGB(255, 255, 255, 255),
                                iconSize: 30,
                                onPressed: () => pause(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
