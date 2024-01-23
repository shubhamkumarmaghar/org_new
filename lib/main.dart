import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:partypeoplebusiness/services/myhttp_overrides.dart';
import 'package:partypeoplebusiness/views/organization/dashboard/organisation_dashboard.dart';
import 'package:partypeoplebusiness/views/splash_screen/splash_screen_view.dart';
import 'package:sizer/sizer.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  FlutterLocalNotificationsPlugin pluginInstance =
  FlutterLocalNotificationsPlugin();
  var init = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/launcher_icon'));
  pluginInstance.initialize(init);
  AndroidNotificationDetails androidSpec = const AndroidNotificationDetails(
    'ch_id',
    'ch_name',
    importance: Importance.high,
    priority: Priority.high,
    playSound: true,
  );
  NotificationDetails platformSpec = NotificationDetails(android: androidSpec);

  await pluginInstance.show(
      0, message.data['title'], message.data['body'], platformSpec);
  log('A background msg just showed ${message.data}');
  //return;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
 // final PendingDynamicLinkData? initialLink =
  //await FirebaseDynamicLinks.instance.getInitialLink();

  //log('deeplink from initialLink :: ${initialLink?.link}');
 // Get.put(SplashController());

//  analytics = await FirebaseAnalytics.instance;
 // FirebaseAnalyticsObserver observer =
 // FirebaseAnalyticsObserver(analytics: analytics);
  await GetStorage.init();
//  logCustomEvent(eventName: splash, parameters: {'name': 'splash'});

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin pluginInstance =
  FlutterLocalNotificationsPlugin();
  var init = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/launcher_icon'));
  pluginInstance.initialize(init);
  NotificationSettings settings = await messaging.requestPermission();
  AndroidNotificationDetails androidSpec = const AndroidNotificationDetails(
    'ch_id',
    'ch_name',
    importance: Importance.high,
    priority: Priority.high,
    playSound: true,
  );
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
    NotificationDetails platformSpec =
    NotificationDetails(android: androidSpec);
    await pluginInstance.show(
        0, message.data['title'], message.data['body'], platformSpec);
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
            title: 'Party People Business',
            debugShowCheckedModeBanner: false,
            builder: (context,child){
              return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 0.9), child: child ?? Text(''));
            },
            theme: ThemeData(
              primarySwatch: Colors.red,
              fontFamily:'PlusJakartaSans'
            ),
            home:  SplashScreenMain());
      },
    );
  }
}
