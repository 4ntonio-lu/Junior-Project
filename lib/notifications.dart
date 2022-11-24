import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:junior_project_three/utilities.dart';



Future<void> createNotification() async{
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 4, //call that one utilities function here? But error.
  channelKey: 'basic_channel',
  title: '${Emojis.money_dollar_banknote + Emojis.transport_air_rocket + Emojis.moon_crescent_moon} This stock is to the moon!!',
  body: 'This is the body text.',
 // bigPicture: can include a photo here, like in the assets folder.
  notificationLayout: NotificationLayout.BigText
    ),
  );
}

Future<void> createANotification({required String title, required String body}) async{
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
        id: 4, //call that one utilities function here? But error.
        channelKey: 'basic_channel',
        title: title,
        body: body,
        // bigPicture: can include a photo here, like in the assets folder.
        notificationLayout: NotificationLayout.BigText
    ),
  );
}

Future<void> createReminderNotification(
NotificationWeekAndTime notificationSchedule) async {
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'schedule_channel',
        title: '${Emojis.wheater_droplet} Add some water to your plant!',
        body: 'Water your plant regularly to keep it healthy.',
        notificationLayout: NotificationLayout.Default,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'MARK_DONE',
          label: 'Mark Done',
        ),
      ],
    schedule: NotificationCalendar(
      weekday: notificationSchedule.dayOfTheWeek,
      hour: notificationSchedule.timeOfDay.hour,
      minute: notificationSchedule.timeOfDay.minute,
      second: 0,
      millisecond: 0,
      repeats: true,
    )
  );




}