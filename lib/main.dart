import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'package:safety/Pages/Splash/checkmasterpass.dart';
import 'package:safety/Pages/Splash/setlanguage.dart';
import 'package:safety/Pages/Splash/settheme.dart';
import 'package:safety/Pages/Splash/setmasterpass.dart';

import 'package:safety/Pages/Home/home.dart';
import 'file:///E:/Programs/Flutter/Projects/Developing/safety/lib/Cloud/auth.dart';
import 'package:safety/Utils/scrollConfig.dart';
import 'package:safety/functions.dart';
import 'package:safety/Settings/texts.dart';
import 'package:safety/Settings/themes.dart';
import 'package:safety/custom_icons_icons.dart';

import 'dart:async';

void main() async {
  InAppPurchaseConnection.enablePendingPurchase;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashAnim(),
      theme: lightTheme,
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: child,
        );
      },
    ),
  );
}

class SplashAnim extends StatefulWidget {
  @override
  _SplashAnimState createState() => _SplashAnimState();
}

class _SplashAnimState extends State<SplashAnim> with TickerProviderStateMixin {
  bool big = true;
  bool circle = false;
  bool transparent = true;
  bool canSwitch = false;
  bool registered = true;
  bool appear = false;
  bool fade = false;

  double top = 0;
  double left = 0;
  double right = 0;

  Color color1 = bottomLeftColor[theme];
  Color color2 = topRightColor[theme];

  String page = 'checkMasterPass';

  AnimationController animationController;
  Animation<double> animation;

  PageController pageController = PageController();
  AnimationController rotateController;
  AnimationController logoController;

  Future<void> initPlatformState() async {
    await FlutterStatusbarManager.setTranslucent(true);

    return;
  }

  void initState() {
    super.initState();

    initPlatformState();

    getEncryptedPass().then((value) {
      print(value);

      if (value != null) {
        setState(() {
          page = 'checkMasterPass';
        });

        print('This user is already registered');
      } else {
        setState(() {
          registered = false;
          page = 'setLanguage';
        });

        print('This user is not registered yet');
      }
    });

    getThemeState().then((value) {
      print(value);

      if (value != null) {
        setState(() {
          theme = value;
        });
      }
    });

    getDarkThemeState().then((value) {
      print(value);

      if (value != null) {
        setState(() {
          dark = value;
        });
      } else {
        setState(() {
          dark = 0;
        });
      }
    });

    loadTheme();

    setState(() {
      lightTheme = ThemeData(
        primaryColor: Color.fromRGBO(230, 230, 230, 1),
        primaryTextTheme: TextTheme(
          headline1: TextStyle(
            color: Colors.white,
            fontSize: size.height * 0.062,
          ),
          headline2: TextStyle(
              color: Colors.white,
              fontSize: size.height * 0.037,
              fontWeight: FontWeight.w500),
        ),
      );
    });

    rotateController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    logoController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );

    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    );

    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        top = MediaQuery.of(context).size.height * 0.6 -
            MediaQuery.of(context).size.width * 0.25;
      });

      if (size == Size.zero) {
        size = MediaQuery.of(context).size;
      }
    });

    Future.delayed(Duration(milliseconds: 150), () {
      ScreenUtil.init(context, width: size.width, height: size.height, allowFontScaling: false);
    });

    Future.delayed(Duration(milliseconds: 1500), () {
      setState(() {
        top = MediaQuery.of(context).size.height * 0.5 -
            MediaQuery.of(context).size.width * 0.25;
        transparent = false;
      });

      logoController.forward(from: 0.1);
    });

    Future.delayed(Duration(milliseconds: 2000), () {
      setState(() {
        big = false;
        top = MediaQuery.of(context).size.height * 0.8;
      });
    });

    Future.delayed(Duration(milliseconds: 2428), () {
      animationController.forward();
    });

    Future.delayed(Duration(milliseconds: 2500), () {
      setState(() {
        circle = true;
      });
    });

    Future.delayed(Duration(milliseconds: 5000), () {
      Timer.periodic(Duration(milliseconds: 500), (timer) {
        setState(() {
          top = MediaQuery.of(context).size.height * 0.8;
        });

        if (fade) {
          timer.cancel();
        }
      });
    });

    Future.delayed(Duration(milliseconds: 8000), () {
      setState(() {
        canSwitch = true;
      });
    });

    Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        color1 = bottomLeftColor[theme];
        color2 = topRightColor[theme];
      });

      if (transition) {
        setState(() {
          appear = true;
          transition = false;
        });

        Future.delayed(Duration(milliseconds: 100), () {
          setState(() {
            fade = true;
          });
        });

        Future.delayed(Duration(milliseconds: 600), () {
          timer.cancel();

          Navigator.pushReplacement(context,
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) => Home(),
              transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 1000),
            ),);
        });
      }
    });
  }

  void dispose() {
    super.dispose();

    pageController.dispose();
    logoController.dispose();
    rotateController.dispose();
  }

  void nextPage(int p) {
    pageController.animateToPage(p,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    rotateController.forward(from: 0.0);

    if (p == 1) {
      getLangState().then((value) {
        if (value == null) {
          saveLangState(1);
        }
      });

      setState(() {
        page = 'middle';
      });

      Future.delayed(Duration(seconds: 4), () {
        setState(() {
          page = 'setTheme';
        });
      });
    }
    if (p == 2) {
      getThemeState().then((value) {
        if (value == null) {
          saveThemeState(0);
        }
      });

      setState(() {
        page = 'middle';
      });

      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          page = 'setMasterPass';
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size1 = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomPadding: true,
      backgroundColor: bgColor[dark],
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          CircularRevealAnimation(
            animation: animation,
            centerAlignment: FractionalOffset(0.5, 0.867),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 700),
              height: size.height,
              width: size1.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [bottomLeftColor[theme], topRightColor[theme]],
                ),
              ),
            ),
          ),
          CircularRevealAnimation(
            animation: animation,
            centerAlignment: FractionalOffset(0.5, 0.867),
            child: Container(
                height: size.height,
                width: size1.width,
                color: Colors.transparent,
                child: registered
                    ? ListView(
                        children: <Widget>[CheckMasterPass()],
                      )
                    : PageView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: pageController,
                        children: <Widget>[
                          ListView(
                            children: <Widget>[
                              SetLanguage(),
                            ],
                          ),
                          ListView(
                            children: <Widget>[
                              SetTheme(),
                            ],
                          ),
                          ListView(
                            children: <Widget>[
                              SetMasterPass(),
                            ],
                          ),
                        ],
                      )),
          ),
          AnimatedPositioned(
            top: top,
            left: left,
            right: right,
            duration: Duration(milliseconds: 500),
            curve: big ? Curves.easeOut : Curves.easeIn,
            child: Container(
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 400),
                curve: Curves.easeOut,
                opacity: transparent ? 0 : 1,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: circle ? 0 : 500),
                      curve: Curves.easeInOut,
                      height: big ? size1.width * 0.5 : size.width * 0.25,
                      width: big ? size1.width * 0.5 : size.width * 0.25,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            circle
                                ? Colors.white.withOpacity(0.5)
                                : bottomLeftColor[theme].withOpacity(0.5),
                            circle
                                ? Colors.white.withOpacity(0.5)
                                : topRightColor[theme].withOpacity(0.5)
                          ],
                        ),
                        borderRadius: BorderRadius.circular(big
                            ? size1.width * 0.5 / 2
                            : size.width * 0.25 / 2),
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: circle ? 0 : 500),
                      curve: Curves.easeInOut,
                      height: big ? size1.width * 0.45 : size.width * 0.2,
                      width: big ? size1.width * 0.45 : size.width * 0.2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            circle ? Colors.white : bottomLeftColor[theme],
                            circle ? Colors.white : topRightColor[theme]
                          ],
                        ),
                        borderRadius: BorderRadius.circular(big
                            ? size1.width * 0.45 / 2
                            : size.width * 0.2 / 2),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (page == 'checkMasterPass') {
                          setState(() {
                            startChecking = true;
                          });
                        }
                        if (page == 'setLanguage') {
                          if (canSwitch) {
                            nextPage(1);
                          }
                        }
                        if (page == 'setTheme') {
                          nextPage(2);
                        }
                        if (page == 'setMasterPass') {
                          setState(() {
                            startSetting = true;
                          });
                        }
                      },
                      child: Container(
                        height: size.width * 0.25,
                        width: size.width * 0.25,
                        color: Colors.transparent,
                        alignment: Alignment.center,
                        child: RotationTransition(
                          turns: Tween(begin: 0.0, end: 1.0)
                              .animate(rotateController),
                          child: Container(
                              child: circle
                                  ? AnimatedOpacity(
                                      duration: Duration(milliseconds: 300),
                                      opacity: circle ? 1 : 0,
                                      child: Icon(
                                        CustomIcons.right_open,
                                        size: size.width * 0.1,
                                        color: buttonColor[theme],
                                      ),
                                    )
                                  : AnimatedOpacity(
                                      duration: Duration(milliseconds: 300),
                                      opacity: big ? 1 : 0,
                                      child: RotationTransition(
                                        turns: Tween(begin: 0.1, end: -0.2)
                                            .animate(logoController),
                                        child: Container(
                                          height: size.width,
                                          width: size.width,
                                          decoration: BoxDecoration(
                                            //color: Colors.black45,
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/s.png'),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          appear
              ? AnimatedOpacity(
                  duration: Duration(milliseconds: 500),
                  opacity: fade ? 1 : 0,
                  child: Container(
                    height: size.height,
                    width: size.width,
                    color: bgColor[dark],
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
