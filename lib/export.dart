//Sriya Nagesh (SUKD1902368) BIT-UCLAN
//core packages
export 'dart:async';
export 'dart:io';
export 'package:flutter/foundation.dart';
export 'package:flutter/material.dart';
export 'package:flutter/services.dart';

//external packages
//date formatting
export 'package:date_format/date_format.dart';
//text to speech
export 'package:flutter_tts/flutter_tts.dart';
//icons and fonts
export 'package:community_material_icon/community_material_icon.dart';
export 'package:google_fonts/google_fonts.dart';
//toast messages
export 'package:fluttertoast/fluttertoast.dart';
//onboarding
export 'package:smooth_page_indicator/smooth_page_indicator.dart';
//profile picture
export 'package:image_picker/image_picker.dart';
//export
export 'package:csv/csv.dart';
export 'package:permission_handler/permission_handler.dart';
export 'package:pdf/pdf.dart';
//import
export 'package:file_picker/file_picker.dart';

//database
//firebase & firestore
export 'package:firebase_auth/firebase_auth.dart';
export 'package:cloud_firestore/cloud_firestore.dart';
export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_storage/firebase_storage.dart';

//screens
//user auth
export 'package:trackero/main.dart';
export 'package:trackero/screens/forgot_password.dart';
export 'package:trackero/screens/login.dart';
export 'package:trackero/screens/register.dart';
export 'package:trackero/screens/check_email.dart';
//dashboards
export 'package:trackero/screens/dashboard.dart';
export 'package:trackero/screens/dashboard_personal_project.dart';
export 'package:trackero/screens/dashboard_team_project.dart';
export 'package:trackero/screens/dashboard_team_member_project.dart';
//personal project
export 'package:trackero/screens/personal.dart';
export 'package:trackero/screens/personal_issues.dart';
export 'package:trackero/screens/personal_risks.dart';
export 'package:trackero/screens/personal_tasks.dart';
export 'package:trackero/screens/personal_project_dashboard.dart';
export 'package:trackero/screens/export_project_personal.dart';
//team projects
export 'package:trackero/screens/team.dart';
export 'package:trackero/screens/team_issues.dart';
export 'package:trackero/screens/team_risks.dart';
export 'package:trackero/screens/team_tasks.dart';
export 'package:trackero/screens/team_members.dart';
export 'package:trackero/screens/team_analytics.dart';
export 'package:trackero/screens/team_project_dashboard.dart';
export 'package:trackero/screens/team_files.dart';
export 'package:trackero/screens/export_project_team.dart';
export 'package:trackero/screens/chatbox.dart';
//general
export 'package:trackero/screens/timer.dart';
export 'package:trackero/screens/completed_projects.dart';
export 'package:trackero/screens/pdf.dart';
export 'package:trackero/screens/onboarding.dart';
export 'package:trackero/screens/settings.dart';

//widgets
export 'package:trackero/widgets/background.dart';
export 'package:trackero/widgets/header.dart';
export 'package:trackero/widgets/palatte.dart';
export 'package:trackero/widgets/snackbar.dart';

//models
//general
export 'package:trackero/model/user.dart';
export 'package:trackero/model/pomodorotimer.dart';
//personal
export 'package:trackero/model/personalproject.dart';
export 'package:trackero/model/goals.dart';
export 'package:trackero/model/issues.dart';
export 'package:trackero/model/risks.dart';
export 'package:trackero/model/tasks.dart';
//team
export 'package:trackero/model/teamproject.dart';
export 'package:trackero/model/teamtasks.dart';
export 'package:trackero/model/teamgoals.dart';
export 'package:trackero/model/teamrisks.dart';
export 'package:trackero/model/teamissues.dart';
export 'package:trackero/model/chat.dart';
export 'package:trackero/model/file.dart';
