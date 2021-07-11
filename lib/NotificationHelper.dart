import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'model/network/http/VaccineFinderHttpHelper.dart';

class NotificationHelper {
  static final NotificationHelper _notificationHelper = NotificationHelper._internal();

  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  factory NotificationHelper() => _notificationHelper;

  NotificationHelper._internal() {
    _initializeNotification();
  }

  Future<void> showNotification(String notMessage) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const IOSNotificationDetails iOSPlatformChannelSpecifics =
    IOSNotificationDetails();
    const MacOSNotificationDetails macOSPlatformChannelSpecifics =
    MacOSNotificationDetails();

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics, macOS: macOSPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
        1, notMessage, notMessage, platformChannelSpecifics);
  }

  void requestPermission() async {
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _initializeNotification() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final initSettingsAndroid = AndroidInitializationSettings('app_icon');
    final initSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    final MacOSInitializationSettings initSettingsMacOS = MacOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    final initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
      macOS: initSettingsMacOS,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
    );
  }
}