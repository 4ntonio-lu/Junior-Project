import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:junior_project_three/button.dart';
import 'package:junior_project_three/theme.dart';
import 'package:junior_project_three/theme_services.dart';
import 'package:junior_project_three/utilities.dart';
import 'notifications.dart';

class MyHomePage extends StatefulWidget{
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

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
      appBar: _appBar(),
      body: Stack(
        children: [
          _addDateBar(),
          _addButtonBar(),
        ],
      ),
    );
  }

  _addButtonBar(){
    return Align(
      alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 150, height: 70,
              child: Container(margin:  const EdgeInsets.all(10),
                child:  MyButton(label: "Notify Me Now", onTap: createNotification),),),
            SizedBox(width: 150, height: 70,
                child: Container(margin: const EdgeInsets.all(10),
                    child: MyButton(label: "Notify Me Later", onTap: () async {
                      NotificationWeekAndTime? pickedSchedule =
                      await pickSchedule(context);

                      if (pickedSchedule != null) {
                        createReminderNotification(pickedSchedule);
                      }
                    },))
            )
          ],
        )
    );
  }


  _addDateBar(){
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            //margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text("Today",
                  style: headingStyle,
                )
              ],
            ),
          ),
          //MyButton(label: "+ Add Task", onTap: ()=>null,)
        ],
      ),
    );
  }

  _appBar(){
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: (){
          var switchTheme = ThemeServices().switchTheme();
          },
          child: Icon(Get.isDarkMode ? Icons.wb_sunny_outlined:Icons.nightlight_round,
            size: 20,
            color: Get.isDarkMode ? Colors.deepPurpleAccent[50]:Colors.deepPurple
          ),
      ),
      title: Text("Ri-min-der", style: headingTitleStyle),
      centerTitle: true,
    );
  }

}
