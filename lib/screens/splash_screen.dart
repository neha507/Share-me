import 'dart:async';
import 'dart:math' show Random, pi;
import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_me/global.dart' as rout;
import 'package:flutter_svg/svg.dart';
import 'package:share_me/providers/user.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    );
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(seconds: 3), () {
          getPrefsAndPushHome();
        });
      }
    });
    animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  void getPrefsAndPushHome() async {
    var pref = await rout.Prefs.getPrefs();
    rout.getP<User>().nickName = pref.getString(rout.Prefs.nickName) ??
        "User_" + Random().nextInt(1000).toString();
    Navigator.of(context).pushReplacementNamed(rout.Router.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: CircularRevealAnimation(
        animation: animation,
        centerAlignment: Alignment.center,
        child: Container(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SvgPicture.asset(
                  'images/1.svg',
                  height: 200,
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            gradient: SweepGradient(
              startAngle: 0,
              endAngle: 2 * pi,
              transform: GradientRotation(-pi / 7),
              colors: <Color>[
                Colors.indigoAccent[200],
                Colors.indigoAccent[200],
                Colors.blue[500],
                Colors.lightBlue,
                Colors.lightBlue,
                Colors.blue[500],
                Colors.indigoAccent[200],
                Colors.indigoAccent[200],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
