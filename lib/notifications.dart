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