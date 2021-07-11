import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vaccine_finder/NotificationHelper.dart';

import 'VaccineFinderPage.dart';

void main() {
  NotificationHelper();
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vaccine Finder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VaccineFinderPage(),
    );
  }
}

