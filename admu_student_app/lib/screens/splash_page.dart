import 'dart:async';

import 'package:flutter/material.dart';

import 'package:admu_student_app/constants/app_colors.dart';
import 'package:admu_student_app/models/user_cache.dart';
import 'package:admu_student_app/screens/login_page.dart';
import 'package:admu_student_app/screens/main_app.dart';
import 'package:admu_student_app/screens/onboarding_page.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StartState();
}

class StartState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return initScreen(context);
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    var duration = Duration(seconds: 5);
    return new Timer(duration, route);
  }

  route() {
    if (UserCache.login) {
      UserCache.login = false;
      UserCache.save();

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ));
    } else if (UserCache.onboarding) {
      UserCache.onboarding = false;
      UserCache.save();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => OnboardingPage()),
      );
    } else
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => MainPage()),
      );
  }

  initScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.PRIMARY_MAIN,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(bottom: 150.0)),
            Expanded(
              child: Align(
                alignment: FractionalOffset.center,
                child: Container(
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    //container can be changed to:
                    //backgroundImage: NetworkImage("photo url"),
                  ),
                ),
              ),
              //For icon, change to Image.asset("assets/Splash.png"),
            ),
            Padding(padding: EdgeInsets.only(top: 50.0)),
            Expanded(
                child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Text(
                "Beadle",
                style: TextStyle(
                    letterSpacing: 1,
                    fontSize: 40.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.white),
              ),
            )),
            Padding(padding: EdgeInsets.only(top: 50.0)),
          ],
        ),
      ),
    );
  }
}
