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
import 'notifications.dart';
import 'dialog_box.dart';


class MyHomePage extends StatefulWidget{
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final textcontroller = TextEditingController();
  int _counter = 0;
  List toDoList = [
    ["Example!", false],
    ["Second!", false],
  ];

  void checkBoxChanged(bool value, int index) {
    setState(() {
      toDoList[index][1] = !toDoList[index][1];
    });
  }

  void saveNewTask()
  {
    setState(() {
      toDoList.add([textcontroller.text, false]); //obviously false, if saving you haven't finished the task
      textcontroller.clear();
    });
    Navigator.of(context).pop();
  }

  // create a new task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: textcontroller,
        onSave: saveNewTask,
        onCancel: () => Navigator.of(context).pop(),
        //  controller: _controller,
        /////  onSave: saveNewTask,
        //  onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }
  void deleteTask(int index) {
    setState(() {
      toDoList.removeAt(index);
    });
   // db.updateDataBase();
  }

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


    floatingActionButton: FloatingActionButton(
    onPressed: createNewTask,
    child: Icon(Icons.add),


    ),

      body: ListView.builder(

          itemCount: toDoList.length,
          itemBuilder: (context, index) {
            return ToDoTile(

              taskName: toDoList[index][0],
              taskCompleted: toDoList[index][1],
              onChanged: (value) => checkBoxChanged,
             deleteFunction: (context) => deleteTask(index),

    );
          }



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
