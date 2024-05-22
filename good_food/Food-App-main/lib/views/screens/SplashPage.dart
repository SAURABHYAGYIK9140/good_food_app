import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/splash_controller/SplashController.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}
class _SplashPageState extends State<SplashPage> {
  static const _backgroundColor = Colors.white;

  static const _colors = [
    Color(0xfff7e7ff),
    Color(0xFF6f2e8e),
  ];

  static const _durations = [
    5000,
    4000,
  ];

  static const _heightPercentages = [
    0.65,
    0.68,
  ];

  @override
  void initState() {
    super.initState();
    Get.find<SplashController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                'Welcome',
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6f2e8e)),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(bottom: 60.0),
          child: Container(
            alignment: Alignment.bottomCenter,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ]),
    );
  }

  @override
  void dispose() {
    /* SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]); */
    super.dispose();
  }
}
