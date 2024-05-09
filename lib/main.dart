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
            // if rememberme is true goto home and not show me login screen, otherwise go to login
            home: notifier.rememberMe ? const HomePage() : const Splash(),
          );
        },
      ),
    );
  }
}
