import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:provider/provider.dart';
import 'package:weddingcheck/app/provider/provider.dart';
import 'package:weddingcheck/views/auth/loginscreen.dart';
import 'package:weddingcheck/views/homepage.dart';
import 'package:weddingcheck/views/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UiProvider()..initStorage(),
      child: Consumer<UiProvider>(
        builder: (
          context,
          UiProvider notifier,
          child,
        ) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              // Light theme settings
              brightness: Brightness.light,
              primaryColor: Colors.blue,
              scaffoldBackgroundColor: Colors.white,
              textTheme: TextTheme(
                bodyText1: TextStyle(color: Colors.black),
                bodyText2: TextStyle(color: Colors.black),
              ),
            ),
            darkTheme: ThemeData(
              // Dark theme settings
              brightness: Brightness.dark,
              primaryColor: Colors.blueGrey,
              scaffoldBackgroundColor: Colors.black,
              textTheme: TextTheme(
                bodyText1: TextStyle(color: Colors.white),
                bodyText2: TextStyle(color: Colors.white),
              ),
            ),
            themeMode: notifier.darkMode ? ThemeMode.dark : ThemeMode.light,
            // if rememberme is true goto home and not show me login screen, otherwise go to login
            home: notifier.rememberMe ? const HomePage() : const Splash(),
          );
        },
      ),
    );
  }
}
