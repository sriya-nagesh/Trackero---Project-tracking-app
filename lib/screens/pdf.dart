//Sriya Nagesh (SUKD1902368) BIT-UCLAN
import 'package:trackero/export.dart';
import 'package:pdf/widgets.dart' as pw;

//export project to PDF format
class PdfApi {
  static Future<Future<Object>> generateTeam(
      String projectName,
      List issues,
      List risks,
      List goals,
      List tasks,
      List members,
      String projectManager) async {
    final pdf = pw.Document();

    goals.removeAt(0);
    tasks.removeAt(0);
    issues.removeAt(0);
    risks.removeAt(0);
    members.removeAt(0);

    pdf.addPage(
      pw.MultiPage(
          build: (context) => <pw.Widget>[
                pdfTitle(projectName),
                pdfTitle('Project Manager: $projectManager'),
                pw.Table(children: [
                  pw.TableRow(children: [
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Divider(thickness: 1),
                          pw.Text("MEMBERS",
                              style: const pw.TextStyle(fontSize: 10)),
                          pw.Divider(thickness: 1)
                        ]),
                  ]),
                  for (var i = 0; i < members.length; i++)
                    pw.TableRow(children: [
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(members[i][0],
                                style: const pw.TextStyle(fontSize: 10)),
                          ]),
                    ])
                ]),
                pw.SizedBox(height: 20),
                pw.Table(children: [
                  pw.TableRow(children: [
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Divider(thickness: 1),
                          pw.Text("GOALS",
                              style: const pw.TextStyle(fontSize: 10)),
                          pw.Divider(thickness: 1)
                        ]),
                  ]),
                  for (var i = 0; i < goals.length; i++)
                    pw.TableRow(children: [
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(goals[i][0],
                                style: const pw.TextStyle(fontSize: 10)),
                          ]),
                    ])
                ]),
                pw.SizedBox(height: 20),
                pw.Table(children: [
                  pw.TableRow(children: [
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Divider(thickness: 1),
                          pw.Text("TASK NAME",
                              style: const pw.TextStyle(fontSize: 10)),
                          pw.Divider(thickness: 1)
                        ]),
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Divider(thickness: 1),
                          pw.Text("TASK DESCRIPTION",
                              style: const pw.TextStyle(fontSize: 10)),
                          pw.Divider(thickness: 1)
                        ]),
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Divider(thickness: 1),
                          pw.Text("ASSIGNED",
                              style: const pw.TextStyle(fontSize: 10)),
                          pw.Divider(thickness: 1)
                        ]),
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Divider(thickness: 1),
                          pw.Text("TASK DUE DATE",
                              style: const pw.TextStyle(fontSize: 10)),
                          pw.Divider(thickness: 1)
                        ]),
                  ]),
                  for (var i = 0; i < tasks.length; i++)
                    pw.TableRow(children: [
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(tasks[i][0],
                                style: const pw.TextStyle(fontSize: 10)),
                          ]),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(tasks[i][1],
                                style: const pw.TextStyle(fontSize: 10)),
                          ]),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(tasks[i][2],
                                style: const pw.TextStyle(fontSize: 10)),
                          ]),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(tasks[i][3],
                                style: const pw.TextStyle(fontSize: 10)),
                          ]),
                    ])
                ]),
                pw.SizedBox(height: 20),
                pw.Table(children: [
                  pw.TableRow(children: [
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Divider(thickness: 1),
                          pw.Text("ISSUE NAME",
                              style: const pw.TextStyle(fontSize: 10)),
                          pw.Divider(thickness: 1)
                        ]),
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Divider(thickness: 1),
                          pw.Text("ISSUE DESCRIPTION",
                              style: const pw.TextStyle(fontSize: 10)),
                          pw.Divider(thickness: 1)
                        ]),
                  ]),
                  for (var i = 0; i < issues.length; i++)
                    pw.TableRow(children: [
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(issues[i][0],
                                style: const pw.TextStyle(fontSize: 10)),
                          ]),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(issues[i][1],
                                style: const pw.TextStyle(fontSize: 10)),
                          ]),
                    ])
                ]),
                pw.SizedBox(height: 20),
                pw.Table(children: [
                  pw.TableRow(children: [
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Divider(thickness: 1),
                          pw.Text("RISK NAME",
                              style: const pw.TextStyle(fontSize: 10)),
                          pw.Divider(thickness: 1)
                        ]),
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Divider(thickness: 1),
                          pw.Text("PROBABILITY",
                              style: const pw.TextStyle(fontSize: 10)),
                          pw.Divider(thickness: 1)
                        ]),
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Divider(thickness: 1),
                          pw.Text("SEVERITY",
                              style: const pw.TextStyle(fontSize: 10)),
                          pw.Divider(thickness: 1)
                        ]),
                  ]),
                  for (var i = 0; i < risks.length; i++)
                    pw.TableRow(children: [
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(risks[i][0],
                                style: const pw.TextStyle(fontSize: 10)),
                          ]),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(risks[i][1],
                                style: const pw.TextStyle(fontSize: 10)),
                          ]),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(risks[i][2],
                                style: const pw.TextStyle(fontSize: 10)),
                          ]),
                    ])
                ]),
                pw.SizedBox(height: 20),
              ]),
    );

    return saveDocument(pdf: pdf, name: projectName);
  }

  static Future<Future<Object>> generatePersonal(
      String projectName,
      List issues,
      List risks,
      List goals,
      List tasks,
      String projectManager) async {
    final pdf = pw.Document();

    goals.removeAt(0);
    tasks.removeAt(0);
    issues.removeAt(0);
    risks.removeAt(0);

    pdf.addPage(
      pw.MultiPage(
          build: (context) => <pw.Widget>[
                pdfTitle(projectName),
                pdfTitle('Project Manager: $projectManager'),
                pw.Table(children: [
                  pw.TableRow(children: [
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Divider(thickness: 1),
                          pw.Text("GOALS",
                              style: const pw.TextStyle(fontSize: 10)),
                          pw.Divider(thickness: 1)
                        ]),
                  ]),
                  for (var i = 0; i < goals.length; i++)
                    pw.TableRow(children: [
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(goals[i][0],
                                style: const pw.TextStyle(fontSize: 10)),
                          ]),
                    ])
                ]),
                pw.SizedBox(height: 20),
                pw.Table(children: [
                  pw.TableRow(children: [
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Divider(thickness: 1),
                          pw.Text("TASK NAME",
                              style: const pw.TextStyle(fontSize: 10)),
                          pw.Divider(thickness: 1)
                        ]),
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Divider(thickness: 1),
                          pw.Text("TASK DESCRIPTION",
                              style: const pw.TextStyle(fontSize: 10)),
                          pw.Divider(thickness: 1)
                        ]),
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Divider(thickness: 1),
                          pw.Text("TASK DUE DATE",
                              style: const pw.TextStyle(fontSize: 10)),
                          pw.Divider(thickness: 1)
                        ]),
                  ]),
                  for (var i = 0; i < tasks.length; i++)
                    pw.TableRow(children: [
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(tasks[i][0],
                                style: const pw.TextStyle(fontSize: 10)),
                          ]),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(tasks[i][1],
                                style: const pw.TextStyle(fontSize: 10)),
                          ]),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(tasks[i][2],
                                style: const pw.TextStyle(fontSize: 10)),
                          ]),
                    ])
                ]),
                pw.SizedBox(height: 20),
                pw.Table(children: [
                  pw.TableRow(children: [
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Divider(thickness: 1),
                          pw.Text("ISSUE NAME",
                              style: const pw.TextStyle(fontSize: 10)),
                          pw.Divider(thickness: 1)
                        ]),
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Divider(thickness: 1),
                          pw.Text("ISSUE DESCRIPTION",
                              style: const pw.TextStyle(fontSize: 10)),
                          pw.Divider(thickness: 1)
                        ]),
                  ]),
                  for (var i = 0; i < issues.length; i++)
                    pw.TableRow(children: [
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(issues[i][0],
                                style: const pw.TextStyle(fontSize: 10)),
                          ]),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(issues[i][1],
                                style: const pw.TextStyle(fontSize: 10)),
                          ]),
                    ])
                ]),
                pw.SizedBox(height: 20),
                pw.Table(children: [
                  pw.TableRow(children: [
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Divider(thickness: 1),
                          pw.Text("RISK NAME",
                              style: const pw.TextStyle(fontSize: 10)),
                          pw.Divider(thickness: 1)
                        ]),
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Divider(thickness: 1),
                          pw.Text("PROBABILITY",
                              style: const pw.TextStyle(fontSize: 10)),
                          pw.Divider(thickness: 1)
                        ]),
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Divider(thickness: 1),
                          pw.Text("SEVERITY",
                              style: const pw.TextStyle(fontSize: 10)),
                          pw.Divider(thickness: 1)
                        ]),
                  ]),
                  for (var i = 0; i < risks.length; i++)
                    pw.TableRow(children: [
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(risks[i][0],
                                style: const pw.TextStyle(fontSize: 10)),
                          ]),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(risks[i][1],
                                style: const pw.TextStyle(fontSize: 10)),
                          ]),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(risks[i][2],
                                style: const pw.TextStyle(fontSize: 10)),
                          ]),
                    ])
                ]),
                pw.SizedBox(height: 20),
              ]),
    );

    return saveDocument(pdf: pdf, name: projectName);
  }

  static pw.Widget pdfTitle(String projectname) => pw.Header(
        child: pw.Center(
          child: pw.Text(
            projectname,
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
          ),
        ),
        padding: const pw.EdgeInsets.all(4),
        decoration: const pw.BoxDecoration(color: PdfColors.blueGrey),
      );

//saves generated PDF file
  static Future<Object> saveDocument(
      {required String name, required pw.Document pdf}) async {
    final bytes = await pdf.save();
    Directory donwloadPath = Directory("/storage/emulated/0/Download");
    DateTime exportDate = DateTime.now();
    String date = formatDate(exportDate, [dd, '_', mm, '_', yyyy, '_', HH]);
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (status.isGranted == true) {
        final pdfFile =
            await (File('${donwloadPath.path}/${name}_${date}export.pdf')
                .create());

        await pdfFile.writeAsBytes(bytes);
        return pdfFile;
      } else {
        await Permission.storage.request();
      }
    }
    return Container();
  }
}
