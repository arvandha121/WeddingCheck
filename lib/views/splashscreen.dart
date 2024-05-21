import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weddingcheck/app/provider/provider.dart';
import 'package:weddingcheck/views/auth/loginscreen.dart';
import 'package:weddingcheck/views/homepage.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  double opacityLevel = 0.0;
  Timer? _timer1;
  Timer? _timer2;

  @override
  void initState() {
    super.initState();
    _timer1 = Timer(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          opacityLevel = 1.0;
        });
      }
    });
    _timer2 = Timer(Duration(seconds: 4), () async {
      if (mounted) {
        await Provider.of<UiProvider>(context, listen: false).initStorage();
        final bool rememberMe =
            Provider.of<UiProvider>(context, listen: false).rememberMe;
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(seconds: 2),
            pageBuilder: (_, __, ___) =>
                rememberMe ? const HomePage() : const Login(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer1?.cancel();
    _timer2?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedOpacity(
        duration: Duration(seconds: 2),
        opacity: opacityLevel,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/assets/image/welcome.png'),
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
    );
  }
}
