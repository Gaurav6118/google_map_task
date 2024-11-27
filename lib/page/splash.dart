import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_map_task/help/app_config.dart' as config;

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SplashPage());
  }

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/GoogleMapPage', (route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: config.AppColors().accentColor(1),
      body: SizedBox(
        height: config.AppConfig(context).appHeight(100),
        child: Center(
          child: Image.asset(
            'assets/img/logo.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
