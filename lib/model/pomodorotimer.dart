//Sriya Nagesh (SUKD1902368) BIT-UCLAN
import 'package:trackero/export.dart';

enum Status {
  work,
  rest,
}

class Pomodoro {
  Status status;
  int count;

  Pomodoro({
    required this.status,
    required this.count,
  });

//function to set status
  void setParam({Status? status}) {
    this.status = status!;
  }
}

class PomodoroTimer {
  int? workTime;
  int? breakTime;
  int? count;
  String? userID;
  int? minutes;
  String? workText;
  String? breakText;

  PomodoroTimer({
    this.workTime,
    this.breakTime,
    this.count,
    this.userID,
    this.minutes,
    this.workText,
    this.breakText,
  });

//send
  Map<String, dynamic> toMap() {
    return {
      'workTime': workTime,
      'breakTime': breakTime,
      'count': count,
      'userID': userID,
      'minutes': minutes,
      'workText': workText,
      'breakText': breakText,
    };
  }

  factory PomodoroTimer.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return PomodoroTimer(
      workTime: data?['workTime'],
      breakTime: data?['breakTime'],
      count: data?['count'],
      userID: data?['userID'],
      minutes: data?['minutes'],
      workText: data?['workText'],
      breakText: data?['breakText'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (workTime != null) "workTime": workTime,
      if (breakTime != null) "breakTime": breakTime,
      if (count != null) "count": count,
      if (userID != null) "userID": userID,
      if (minutes != null) "minutes": minutes,
      if (workText != null) "workText": workText,
      if (breakText != null) "breakText": breakText,
    };
  }
}
