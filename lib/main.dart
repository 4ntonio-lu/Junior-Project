import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:junior_project_three/my_home_page.dart';
import 'package:get_storage/get_storage.dart';
import 'package:junior_project_three/theme.dart';
import 'package:junior_project_three/theme_services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notification',
        channelDescription: 'hey',
        importance: NotificationImportance.High,
        channelShowBadge: true,
      ),
      NotificationChannel(
        channelKey: 'schedule_channel',
        channelName: 'Scheduled Notifications',
        defaultColor: Colors.red,
        channelDescription: 'timed',
        // channelShowBadge: true,
        locked: true,
        importance: NotificationImportance.High,
        //soundSource: 'resource://raw/res_custom_notification'
      ),
    ],
  );
  runApp(const MyApp());
  printReminders(await readReminders());
}

List<Reminder> sampleReminders() {
  Reminder r1 = Reminder(
      isComplete: false,
      priority: Priority.low,
      name: "do laundry",
      description: "idk",
      dateTime: DateTime.utc(2022, 6, 6).toString(),
      repeat: Repeat.weekly);
  Reminder r2 = Reminder(
      isComplete: true,
      priority: Priority.medium,
      name: "do homework",
      description: "CST Homework",
      dateTime: DateTime.utc(1944, 7, 9).toString(),
      repeat: Repeat.daily);
  return [r1, r2];
}

void printReminders(List<Reminder> reminders) {
  for (var r in reminders) {
    print(
        '${r.isComplete}   Todo: ${r.name}   Priority:${r.priority.name}   Date and Time:${r.dateTime}   Repeat:${r.repeat.name}');
  }
}

Future<List<Reminder>> readReminders() async {
  try {
    final file = await _localFile;
    Iterable l = json.decode(await file.readAsString());
    List<Reminder> reminders =
        List<Reminder>.from(l.map((model) => Reminder.fromJson(model)));
    return reminders;
  } catch (e) {
    print(e.toString());
    return List.empty();
  }
}

Future<void> writeReminders(List<Reminder> reminders) async {
  try {
    final file = await _localFile;
    file.writeAsString(jsonEncode(reminders));
  } catch (e) {
    print(e.toString());
    return;
  }
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/index.json');
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

enum Priority { none, low, medium, high }

enum Repeat { never, daily, weekly, monthly, yearly }

class Reminder {
  Reminder(
      {required this.isComplete,
      required this.priority,
      required this.name,
      required this.description,
      required this.dateTime,
      required this.repeat});

  bool isComplete;
  Priority priority;
  String name;
  String description;
  String dateTime;
  Repeat repeat;

  Reminder.fromJson(Map<String, dynamic> json)
      : isComplete = json['isComplete'],
        priority = Priority.values.byName(json['priority']),
        name = json['name'],
        description = json['description'],
        dateTime = json['dateTime'],
        repeat = Repeat.values.byName(json['repeat']);

  Map<String, dynamic> toJson() => {
        'isComplete': isComplete,
        'priority': priority.name,
        'name': name,
        'description': description,
        'dateTime': dateTime,
        'repeat': repeat.name
      };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Project Demo',
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,
      home: const MyHomePage(title: 'Ri-min-der'),
    );
  }
}
