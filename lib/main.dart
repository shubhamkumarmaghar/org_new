import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:partypeoplebusiness/views/organization/dashboard/organisation_dashboard.dart';
import 'package:partypeoplebusiness/views/splash_screen/splash_screen_view.dart';
import 'package:sizer/sizer.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  FlutterLocalNotificationsPlugin pluginInstance =
  FlutterLocalNotificationsPlugin();
  var init = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/launcher_icon')
  );
  pluginInstance.initialize(init);
  AndroidNotificationDetails androidSpec = const AndroidNotificationDetails(
    'ch_id',
    'ch_name',
    importance: Importance.high,
    priority: Priority.high,
    playSound: true,
  );
  NotificationDetails platformSpec =

  NotificationDetails(android: androidSpec);

  await pluginInstance.show(
      0, message.data['title'], message.data['body'], platformSpec);

  //return;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  GetStorage.init();

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin pluginInstance =
      FlutterLocalNotificationsPlugin();
  var init = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/launcher_icon'));
  pluginInstance.initialize(init);

  NotificationSettings settings = await messaging.requestPermission();

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else {
    print('User declined permission');
  }
  messaging.getToken().then((value) {
    print('Firebase Messaging Token : ${value}');
  });
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print(message.messageType);
    print(message.data);
    AndroidNotificationDetails androidSpec = const AndroidNotificationDetails(
      'ch_id',
      'ch_name',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    NotificationDetails platformSpec =
        NotificationDetails(android: androidSpec);

    await pluginInstance.show(
        0, message.data['title'], message.data['body'], platformSpec);
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    print(GetStorage().read('loggedIn'));
    print('user Token');
    print(GetStorage().read('token'));
    print(GetStorage().read('onboarding'));
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
            title: 'Party People Business',
            theme: ThemeData(
              primarySwatch: Colors.red,
            ),
            home:  SplashScreenMain());
      },
    );
  }
}
