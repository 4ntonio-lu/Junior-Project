import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:junior_project_three/button.dart';
import 'package:junior_project_three/theme.dart';
import 'package:junior_project_three/theme_services.dart';
import 'package:junior_project_three/ToDoTile.dart';
import 'package:junior_project_three/utilities.dart';
import 'dialog_box.dart';
import 'main.dart';
import 'notifications.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final textController = TextEditingController();
  List<Reminder> reminders = [];

  void loadReminders() async {
    //WriteReminders(SampleReminders());
    reminders = await readReminders();
  }

  void saveReminders() async {
    writeReminders(reminders);
    printReminders(reminders);
  }

  void checkBoxChanged(bool value, int index) {
    setState(() {
      reminders[index].isComplete = !reminders[index].isComplete;
      saveReminders();
    });
  }

  void saveNewReminder() {
    setState(() {
      reminders.add(Reminder(
          name: textController.text,
          isComplete: false,
          priority: Priority.none,
          description: '',
          dateTime: '',
          repeat: Repeat.never));
      textController.clear();
      saveReminders();
    });
    Navigator.of(context).pop();
  }

  // create a new task
  void createNewReminder() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
            controller: textController,
            onSave: saveNewReminder,
            onCancel: () => Navigator.of(context).pop()
        );
      },
    );
  }

  void deleteReminder(int index) {
    setState(() {
      reminders.removeAt(index);
      saveReminders();
    });
  }

  @override
  void initState() {
    super.initState();
    loadReminders();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                title: const Text('Allow Notifications'),
                content:
                const Text('Our app would like to send notifications.'),
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
                ]));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      // add task button
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(5.0),
        child: FloatingActionButton(
            onPressed: createNewReminder,
            backgroundColor: Get.isDarkMode?Colors.deepPurpleAccent:Colors.deepPurple,
            foregroundColor: Colors.white,
            child: const Icon(Icons.add)
        ),
      ),
      body: ListView.builder(
          itemCount: reminders.length,
          itemBuilder: (context, index) {
            return ToDoTile(
              reminderName: reminders[index].name,
              reminderCompleted: reminders[index].isComplete,
              onChanged: (value) => checkBoxChanged,
              deleteFunction: (context) => deleteReminder(index),
            );
          }),
      // bottom nave bar, contains two icons, one for immediate notification, one for a scheduled notification
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: context.theme.backgroundColor,
        shape: CircularNotchedRectangle(),
        notchMargin: 3,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // immediate notification icon and text label
            Container(
              padding: EdgeInsets.only(left: 30),
              child: Row(
              children: [
                Text("Now", style: TextStyle(color: Get.isDarkMode ? Colors.deepPurpleAccent[50] : Colors.deepPurple,),),
                IconButton(
                  icon: Icon(
                    Icons.doorbell_outlined,
                    color: Get.isDarkMode ? Colors.deepPurpleAccent[50] : Colors.deepPurple,

                ),
                onPressed: createNotification
              )
                ],
              ),
            ),
            // scheduled notification icon and text label
            Container(
              padding: EdgeInsets.only(right: 30),
              child: Row(
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.doorbell_outlined,
                        color: Get.isDarkMode ? Colors.deepPurpleAccent[50] : Colors.deepPurple,

                      ),
                      onPressed: () async {
                        NotificationWeekAndTime? pickedSchedule =
                        await pickSchedule(context);

                        if (pickedSchedule != null) {
                          createReminderNotification(pickedSchedule);
                        }
                      }
                  ),
                  Text("Later", style: TextStyle(color: Get.isDarkMode ? Colors.deepPurpleAccent[50] : Colors.deepPurple,),),
                ],
              ),
            ),
          ]
        ),
      ),
    );
  }

  _addButtonBar() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 150,
              height: 70,
              child: Container(
                margin: const EdgeInsets.all(10),
                child:
                const MyButton(label: "Notify Me Now", onTap: createNotification),
              ),
            ),
            SizedBox(
                width: 150,
                height: 70,
                child: Container(
                    margin: const EdgeInsets.all(10),
                    child: MyButton(
                      label: "Notify Me Later",
                      onTap: () async {
                        NotificationWeekAndTime? pickedSchedule =
                        await pickSchedule(context);

                        if (pickedSchedule != null) {
                          createReminderNotification(pickedSchedule);
                        }
                      },
                    )))
          ],
        ));
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text(
                "Today",
                style: headingStyle,
              )
            ],
          ),
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          ThemeServices().switchTheme();
        },
        child: Icon(
            Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
            size: 20,
            color: Get.isDarkMode ? Colors.deepPurpleAccent[50] : Colors.deepPurple),
      ),
      title: Text("Ri-min-der", style: headingTitleStyle),
      centerTitle: true,
    );
  }
}
