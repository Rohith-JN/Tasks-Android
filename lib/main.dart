import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasks/controllers/bindings/Bindings.dart';
import 'package:tasks/services/notification.service.dart';
import 'package:tasks/utils/global.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tasks/view/AuthScreen.dart';
import 'package:tasks/view/MainScreen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/services.dart';
Future main() async {
  tz.initializeTimeZones();
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: Binding(),
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Tasks',
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: const AppBarTheme(color: Colors.black)),
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                color: primaryColor,
              )
            );
            } else if (snapshot.hasError) {
              return Center(
                  child: Text("Something went wrong!", style: heading(Colors.white)));
            } else if (snapshot.hasData) {
              return const MainScreen();
            } else {
              return const AuthScreen();
            }
          }
        ),
    );
  }
}
