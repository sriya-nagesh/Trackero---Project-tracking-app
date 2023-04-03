//Sriya Nagesh (SUKD1902368) BIT-UCLAN
import 'package:trackero/export.dart';

class TeamFiles extends StatefulWidget {
  const TeamFiles({Key? key, required this.docID}) : super(key: key);
  final String docID;
  @override
  State<TeamFiles> createState() => _TeamFilesState();
}

class _TeamFilesState extends State<TeamFiles> {
  final user = FirebaseAuth.instance.currentUser!;
  TextEditingController fileName = TextEditingController();
  PlatformFile? uploaded;
  var name = "";
  String projectID = '';

  @override
  void initState() {
    super.initState();
    fileNames.clear();
    projectID = widget.docID;
  }

  List<String> fileNames = <String>[];

//delete file from collection and firebase storage
  Future<void> delete(String fileID, file) async {
    try {
      final ref = storageRef.child(file);
      await ref.delete();

      await teamproject
          .doc(widget.docID)
          .collection("files")
          .doc(fileID)
          .delete();

      alertDialog("Your file has been deleted!");
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void dispose() {
    fileName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final files = teamproject
        .doc(projectID)
        .collection("files")
        .where('projectID', isEqualTo: widget.docID)
        .where('created', isEqualTo: user.email)
        .snapshots();

    final teamFiles = teamproject
        .doc(projectID)
        .collection("files")
        .where('projectID', isEqualTo: widget.docID)
        .where('created', isNotEqualTo: user.email)
        .snapshots();
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: const Color.fromRGBO(64, 89, 173, 1),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const Expanded(
                            child: Header(
                              text: "Your uploaded files",
                              color: Color.fromRGBO(107, 151, 202, 1),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          IconButton(
                            icon: const Icon(
                              CommunityMaterialIcons.plus_circle,
                              color: Color.fromRGBO(151, 216, 196, 1),
                            ),
                            iconSize: 50,
                            onPressed: () async {
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(builder:
                                      (BuildContext context,
                                          StateSetter setState) {
                                    return AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            "Add file description",
                                            style: darkblue,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 205, 205, 205),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: TextField(
                                              controller: fileName,
                                              onChanged: (String value) {},
                                              decoration: const InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                border: InputBorder.none,
                                                hintStyle: textbox,
                                              ),
                                              style: textbox,
                                              textInputAction:
                                                  TextInputAction.done,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Center(
                                            child: Column(
                                              children: [
                                                if (PickedFile != null) ...[
                                                  SizedBox(
                                                    height: 50,
                                                    child: Center(
                                                        child: Text(
                                                      name,
                                                      style: green,
                                                    )),
                                                  ),
                                                ]
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        Container(
                                          width: double.infinity,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                                107, 151, 202, 1),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: TextButton(
                                            onPressed: () async {
                                              final chosenFile =
                                                  await FilePicker.platform
                                                      .pickFiles();
                                              if (chosenFile == null) return;

                                              setState(() {
                                                uploaded =
                                                    chosenFile.files.first;
                                                name = uploaded!.name;
                                              });
                                            },
                                            child: const Text('Pick File',
                                                style: defaultText),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          width: double.infinity,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                                107, 151, 202, 1),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: TextButton(
                                            onPressed: () async {
                                              final fileUploaded =
                                                  File(uploaded!.path!);

                                              String name = uploaded!.name;
                                              String downloadURL;
                                              if (fileName.text.isNotEmpty) {
                                                if (fileNames
                                                    .contains(uploaded!.name)) {
                                                  alertDialog(
                                                      "You cannot upload a file with the same name as another file in your project!");
                                                  Navigator.pop(context);
                                                } else {
                                                  Reference ref = FirebaseStorage
                                                      .instance
                                                      .ref()
                                                      .child(
                                                          '${widget.docID}_${uploaded!.name}');

                                                  if (fileUploaded
                                                      .existsSync()) {
                                                    setState(
                                                      () async {
                                                        UploadTask upload =
                                                            ref.putFile(File(
                                                                fileUploaded
                                                                    .path));

                                                        downloadURL =
                                                            await (await upload)
                                                                .ref
                                                                .getDownloadURL();

                                                        await AddTeamFile()
                                                            .createTeamFileModel(
                                                                fileName.text,
                                                                user.email,
                                                                downloadURL,
                                                                widget.docID,
                                                                name);

                                                        fileNames.add(name);
                                                        fileName.clear();
                                                        alertDialog(
                                                            "Your file has been uploaded!");
                                                        if (!mounted) return;
                                                        Navigator.pop(context);
                                                      },
                                                    );
                                                  }
                                                }
                                              } else {
                                                alertDialog(
                                                    "Enter a file description!");
                                              }
                                            },
                                            child: const Text('Upload File',
                                                style: defaultText),
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            width: double.infinity,
                            color: const Color.fromRGBO(239, 242, 241, 1),
                            child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(236, 236, 236, 1),
                              ),
                              child: StreamBuilder(
                                stream: files,
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot>
                                        streamSnapshot) {
                                  if (streamSnapshot.hasData) {
                                    return GridView.builder(
                                      shrinkWrap: true,
                                      itemCount:
                                          streamSnapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        final DocumentSnapshot
                                            documentSnapshot =
                                            streamSnapshot.data!.docs[index];
                                        fileNames
                                            .add(documentSnapshot['filename']);
                                        var extention =
                                            documentSnapshot['filename']
                                                .substring(
                                                    documentSnapshot['filename']
                                                            .length -
                                                        3);
                                        return Card(
                                          elevation: 5,
                                          color: const Color.fromRGBO(
                                              250, 247, 240, 1),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: InkWell(
                                            onLongPress: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        40)),
                                                    content: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 60,
                                                              right: 60),
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: Center(
                                                        child: IconButton(
                                                            icon: const Icon(
                                                                Icons.delete),
                                                            iconSize: 30,
                                                            color: const Color
                                                                    .fromARGB(
                                                                255,
                                                                201,
                                                                78,
                                                                100),
                                                            onPressed: () {
                                                              delete(
                                                                  documentSnapshot
                                                                      .id,
                                                                  '${documentSnapshot["projectID"]}_${documentSnapshot["filename"]}');

                                                              Navigator.of(
                                                                      context)
                                                                  .pop;
                                                            }),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: ListTile(
                                              title: Column(
                                                children: [
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  if (extention == "pdf") ...[
                                                    const Icon(
                                                        Icons
                                                            .picture_as_pdf_rounded,
                                                        color: Color.fromARGB(
                                                            255,
                                                            250,
                                                            115,
                                                            105)),
                                                  ],
                                                  if (extention == "png" ||
                                                      extention == "peg" ||
                                                      extention == 'jpg') ...[
                                                    const Icon(Icons.image,
                                                        color: Color.fromARGB(
                                                            255, 246, 187, 99)),
                                                  ],
                                                  if (extention == "csv" ||
                                                      extention == "lsx" ||
                                                      extention == 'xls') ...[
                                                    const Icon(
                                                        Icons
                                                            .table_chart_rounded,
                                                        color: Color.fromARGB(
                                                            255, 155, 249, 158))
                                                  ],
                                                  if (extention == "doc" ||
                                                      extention == "ocx") ...[
                                                    const Icon(
                                                        Icons
                                                            .document_scanner_rounded,
                                                        color: Color.fromARGB(
                                                            255, 140, 203, 255))
                                                  ],
                                                  if (extention == "mp4") ...[
                                                    const Icon(Icons.video_file,
                                                        color: Color.fromARGB(
                                                            255, 239, 145, 255))
                                                  ],
                                                  if (extention == "mp3") ...[
                                                    const Icon(Icons.audio_file,
                                                        color: Color.fromARGB(
                                                            255, 255, 246, 169))
                                                  ],
                                                  if (extention == "ppt" ||
                                                      extention == "ptx") ...[
                                                    const Icon(
                                                        Icons
                                                            .pause_presentation_rounded,
                                                        color: Color.fromARGB(
                                                            255, 255, 167, 196))
                                                  ],
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      documentSnapshot['name'],
                                                      style: const TextStyle(
                                                          fontSize: 15),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Expanded(
                                                    child: Center(
                                                      child: Text(
                                                        documentSnapshot[
                                                            'filename'],
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () async {
                                                      if (Platform.isAndroid) {
                                                        var status =
                                                            await Permission
                                                                .storage.status;
                                                        if (status.isGranted ==
                                                            true) {
                                                          downloadFile(
                                                              documentSnapshot[
                                                                  'url'],
                                                              '${widget.docID}_${documentSnapshot['filename']}');

                                                          if (!mounted) return;
                                                          Navigator.pop(
                                                              context);
                                                        } else {
                                                          await Permission
                                                              .storage
                                                              .request();
                                                        }
                                                      }
                                                    },
                                                    icon: const Icon(
                                                      Icons.download_rounded,
                                                      color: Color.fromRGBO(
                                                          151, 216, 196, 1),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 5,
                                        mainAxisSpacing: 5,
                                      ),
                                    );
                                  }

                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Header(
                            text: "Your teams files",
                            color: Color.fromRGBO(107, 151, 202, 1),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: double.infinity,
                            color: const Color.fromRGBO(239, 242, 241, 1),
                            child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(236, 236, 236, 1),
                              ),
                              child: StreamBuilder(
                                stream: teamFiles,
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot>
                                        streamSnapshot) {
                                  if (streamSnapshot.hasData) {
                                    return GridView.builder(
                                      shrinkWrap: true,
                                      itemCount:
                                          streamSnapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        final DocumentSnapshot
                                            documentSnapshot =
                                            streamSnapshot.data!.docs[index];
                                        fileNames
                                            .add(documentSnapshot['filename']);
                                        var extention =
                                            documentSnapshot['filename']
                                                .substring(
                                                    documentSnapshot['filename']
                                                            .length -
                                                        3);
                                        return Card(
                                          elevation: 5,
                                          color: const Color.fromRGBO(
                                              250, 247, 240, 1),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: ListTile(
                                            title: Column(
                                              children: [
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                if (extention == "pdf") ...[
                                                  const Icon(
                                                      Icons
                                                          .picture_as_pdf_rounded,
                                                      color: Color.fromARGB(
                                                          255, 250, 115, 105)),
                                                ],
                                                if (extention == "png" ||
                                                    extention == "peg" ||
                                                    extention == 'jpg') ...[
                                                  const Icon(Icons.image,
                                                      color: Color.fromARGB(
                                                          255, 246, 187, 99)),
                                                ],
                                                if (extention == "csv" ||
                                                    extention == "lsx" ||
                                                    extention == 'xls') ...[
                                                  const Icon(
                                                      Icons.table_chart_rounded,
                                                      color: Color.fromARGB(
                                                          255, 155, 249, 158))
                                                ],
                                                if (extention == "doc") ...[
                                                  const Icon(
                                                      Icons
                                                          .document_scanner_rounded,
                                                      color: Color.fromARGB(
                                                          255, 140, 203, 255))
                                                ],
                                                if (extention == "mp4") ...[
                                                  const Icon(Icons.video_file,
                                                      color: Color.fromARGB(
                                                          255, 239, 145, 255))
                                                ],
                                                if (extention == "mp3") ...[
                                                  const Icon(Icons.audio_file,
                                                      color: Color.fromARGB(
                                                          255, 255, 246, 169))
                                                ],
                                                if (extention == "ppt" ||
                                                    extention == "ptx") ...[
                                                  const Icon(
                                                      Icons
                                                          .pause_presentation_rounded,
                                                      color: Color.fromARGB(
                                                          255, 255, 167, 196))
                                                ],
                                                Center(
                                                  child: Text(
                                                    documentSnapshot['name'],
                                                    style: const TextStyle(
                                                        fontSize: 14),
                                                    textAlign: TextAlign.center,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      documentSnapshot[
                                                          'filename'],
                                                      style: const TextStyle(
                                                          fontSize: 12),
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () async {
                                                    if (Platform.isAndroid) {
                                                      var status =
                                                          await Permission
                                                              .storage.status;
                                                      if (status.isGranted ==
                                                          true) {
                                                        downloadFile(
                                                            documentSnapshot[
                                                                'url'],
                                                            '${widget.docID}_${documentSnapshot['filename']}');
                                                      } else {
                                                        await Permission.storage
                                                            .request();
                                                      }
                                                    }
                                                  },
                                                  icon: const Icon(
                                                    Icons.download_rounded,
                                                    color: Color.fromRGBO(
                                                        151, 216, 196, 1),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 5,
                                        mainAxisSpacing: 5,
                                      ),
                                    );
                                  }

                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      )
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

  Future<String> downloadFile(String url, String fileName) async {
    HttpClient httpClient = HttpClient();
    File file;
    String filePath = '';
    String myUrl = '';
    try {
      myUrl = url;
      var request = await httpClient.getUrl(Uri.parse(myUrl));
      var response = await request.close();
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        Directory donwloadPath = Directory("/storage/emulated/0/Download");
        filePath = '${donwloadPath.path}/$fileName';

        file = File(filePath);
        await file.writeAsBytes(bytes);

        alertDialog("Your file has been downloaded!");
      } else {
        debugPrint('${response.statusCode}');
      }
    } catch (ex) {
      debugPrint(ex.toString());
    }

    return filePath;
  }
}
