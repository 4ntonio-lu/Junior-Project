import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'notifications.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:junior_project_three/utilities.dart';


void main() async {
  AwesomeNotifications().initialize(null, [
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
  PrintReminders(await ReadReminders());
}

List<Reminder> SampleReminders() {
  Reminder r1 = Reminder(isComplete: false,
      priority: Priority.low,
      name: "do laundry",
      description: "idk",
      dateTime: DateTime.utc(2022, 6, 6).toString(),
      repeat: Repeat.weekly);
  Reminder r2 = Reminder(isComplete: true,
      priority: Priority.medium,
      name: "do homework",
      description: "CST Homework",
      dateTime: DateTime.utc(1944, 7, 9).toString(),
      repeat: Repeat.daily);
  return [r1, r2];
}

void PrintReminders(List<Reminder> reminders) {
  for (var r in reminders) {
    print('${r.isComplete}   Todo: ${r.name}   Priority:${r.priority.name}   Date and Time:${r.dateTime}   Repeat:${r.repeat.name}');
  }
}

Future<List<Reminder>> ReadReminders() async {
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

Future<void> WriteReminders(List<Reminder> reminders) async {
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
    return MaterialApp(
      title: 'Project Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        //scaffoldBackgroundColor: Colors.deepPurpleAccent,


        scaffoldBackgroundColor: const Color(0xFFa7a6ba),
       // primaryColor: Colors.yellow[700],

        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(title: 'Queue Me'),

    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                title: const Text('Allow Notifications'),
                content: const Text('Our app would like to send notifications.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Don\'t allow',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () => AwesomeNotifications()
                          .requestPermissionToSendNotifications()
                          .then((_) => Navigator.pop(context)),
                      child: const Text('Allow',
                          style: TextStyle(
                            color: Colors.teal,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )))
                ]
            )
        );
      }
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              SizedBox(width: 120, height: 80,
              child: Container(margin: const EdgeInsets.all(10),
                child: ElevatedButton(
                    onPressed: createNotification,
                    // tooltip: 'Notify',
                    child: Icon(Icons.add)
                ),
              ),
              ),

              SizedBox(width: 120, height: 80,
              child: Container(margin: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () async {
                    NotificationWeekAndTime? pickedSchedule =
                    await pickSchedule(context);

                    if (pickedSchedule != null) {
                      createReminderNotification(pickedSchedule);
                    }
                  },  child: Icon(Icons.add),

                ),
              )
              ),


             ],
          ),
       ),
    );
  }
}
