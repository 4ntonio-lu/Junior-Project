import 'package:awesome_notifications/awesome_notifications.dart';
//import 'package:json_annotation/json_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
//import 'dart:developer';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'notifications.dart';


//part 'index.g.dart';

void main() async {
  AwesomeNotifications().initialize(
      null,
      [
      NotificationChannel(
      channelKey: 'basic_channel',
      channelName: 'Basic notif',
  channelDescription: 'hey',
      importance: NotificationImportance.High,
      channelShowBadge: true,
  )
  ]
  );
      runApp(MyApp());
  print("ok");
  String reminders = await idk();
  print(reminders);
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/index.json');
}

Future<String> writeAndRead() async {
  try {
    final file = await _localFile;
    file.writeAsString('okokokokokokook');
    return file.readAsString();
  }
  catch (e) {
    return "no";
  }
}

Future<String> idk() async {
  try {
    final file = await _localFile;
    Reminder r = Reminder(isComplete: false,
        priority: 3,
        name: "do laundry",
        description: "idk",
        dateTime: DateTime.utc(1944, 6, 6).toString(),
        repeat: "Daily");
    print(jsonEncode(r.toJson()));
    file.writeAsString(jsonEncode(r));
    print("maybe");
    final s = await file.readAsString();
    return s;
  } catch (e) {
    // If encountering an error, return 0
    return "no";
  }
}

Future<List<Reminder>> getReminders() async {
  try {
    final file = await _localFile;
    Reminder r = Reminder(isComplete: false, priority: 3, name: "do laundry", description: "idk", dateTime: DateTime.utc(1944, 6, 6).toString(), repeat: "Daily");

    file.writeAsString(jsonEncode(r.toJson()));
    final jsonString = await file.readAsString();

    Iterable l = json.decode(jsonString);
    List<Reminder> reminders = List<Reminder>.from(l.map((model) => Reminder.fromJson(model)));

    return reminders;
  } catch (e) {
    // If encountering an error, return 0
    return List.empty();
  }
}

class Reminder {
  Reminder({required this.isComplete, required this.priority, required this.name, required this.description, required this.dateTime, required this.repeat});
  bool isComplete;
  int priority;
  String name;
  String description;
  String dateTime;
  String repeat;
  Reminder.fromJson(Map<String, dynamic> json)
      : isComplete = json['isComplete'],
        priority = json['priority'],
        name = json['name'],
        description = json['description'],
        dateTime = json['dateTime'],
        repeat = json['repeat'];
  Map<String, dynamic> toJson() => {
    'isComplete': isComplete,
    'priority': priority,
    'name': name,
    'description': description,
    'dateTime': dateTime,
    'repeat': repeat
  };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
        showDialog(context: context,
            builder: (context) =>
                AlertDialog(title: Text('Allow Notifications'),
                    content: Text('Our app would like to send notifications.'),
                    actions: [TextButton(onPressed: () {
                      Navigator.pop(context);
                    }, child: Text(
                      'Dont allow',
                      style: TextStyle(color: Colors.amber, fontSize: 18,
                      ),
                    ),
                    ),
                      TextButton(
                          onPressed: () =>
                              AwesomeNotifications()
                                  .requestPermissionToSendNotifications()
                                  .then((_) => Navigator.pop(context)),
                          child: Text(
                              'Allow',
                              style: TextStyle(color: Colors.teal, fontSize: 18,
                                fontWeight: FontWeight.bold,)
                          ))
                    ]
                ));
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

    child: Column(

    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
    const Text(
    'This is the notification button page!',
    ),
    Text(
    '$_counter',
    style: Theme
        .of(context)
        .textTheme
        .headline4,
    ),
    ],
    ),
    ),


    floatingActionButton: FloatingActionButton(
    onPressed: createNotification, //_incrementCounter,
    tooltip: 'Increment',
    child: const Icon(Icons.add),
    )
    );
  }
}
