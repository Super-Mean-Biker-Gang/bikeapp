import 'package:bikeapp/styles/color_gradients.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:bikeapp/screens/end_ride_screen.dart';

class TimerScreen extends StatefulWidget {
  static const routeName = "timer_screen";
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  // Timer adapted from source: https://stackoverflow.com/questions/54610121/flutter-countdown-timer
  final interval = const Duration(seconds: 1);

  final int timerMaxSeconds = 28800; //Number of seconds in 8 hours
  final int banTimerSeconds = 86400; //Number of seconds in 24 hours

  int currentSeconds = 0;
  int currentBanSeconds = 0;

  var ban = false;

  Timer bikeTimer;
  Timer banTimer;

  @override
  void initState() {
    startBikeTimeout();
    startBanTimeout();
    super.initState();
  }

  @override
  void dispose() {
    bikeTimer.cancel();
    banTimer.cancel();
    super.dispose();
  }

  String get timerText =>
      '${(((timerMaxSeconds - currentSeconds) ~/ 60) ~/ 60).toString().padLeft(2, '0')}:${(((timerMaxSeconds - currentSeconds) ~/ 60) % 60).toString().padLeft(2, '0')}:${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

  startBikeTimeout([int milliseconds]) {
    var duration = interval;
    bikeTimer = Timer.periodic(duration, (timer) {
      setState(() {
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) {
          bikeTimer.cancel();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  "Times up!",
                  textAlign: TextAlign.center,
                ),
                content: Text(
                    'Please find a good location and check the bike back in for others to use.'),
                actions: <Widget>[
                  TextButton(
                    child: Text("Okay"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        }
      });
    });
  }

  startBanTimeout() {
    var duration = interval;
    banTimer = Timer.periodic(duration, (timer) {
      setState(() {
        currentBanSeconds = timer.tick;
        if (timer.tick >= banTimerSeconds) {
          banTimer.cancel();
          ban = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Container(
      height: queryData.size.height * 1,
      width: queryData.size.width * 1,
      decoration: decoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: timerBody(context),
      ),
    );
  }

  Widget timerBody(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    if (ban == false) {
      return SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: queryData.size.height * .10),
              child: Center(
                child: Text(
                  'Time Remaining: ',
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: queryData.size.height * .10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.timer,
                  size: 80,
                  color: Colors.white,
                ),
                SizedBox(width: 5),
                Text(
                  timerText,
                  style: TextStyle(fontSize: 70, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: queryData.size.height * .10),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                  'Bikes may only be used for up to 8 hours before they must be checked in.\n \nIf the bike is not checked in within 24 hours, your account will be forfeit.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, color: Colors.white)),
            ),
            SizedBox(height: queryData.size.height * .10),
            checkInButton(context),
            SizedBox(height: 20)
          ],
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: queryData.size.height * .10),
              child: Center(
                child: Text(
                  'Account Locked',
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: queryData.size.height * .10),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                  'Your account has been locked due to a violation of the Terms of Service. \n \n Bikes checked out by a user must be returned within 24 hours of checkout.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, color: Colors.white)),
            ),
            SizedBox(height: 20)
          ],
        ),
      );
    }
  }

  Widget checkInButton(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return SizedBox(
      width: queryData.size.width * .75,
      height: 50,
      child: ElevatedButton(
        child: Text(
          'Check in bike',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: queryData.textScaleFactor * 25,
          ),
        ),
        onPressed: () {
          // Navigator.pushNamed(context, EndRideScreen.routeName);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => EndRideScreen()));
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.cyan[500]),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
              side: BorderSide(
                color: Colors.cyanAccent,
                width: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
