import 'dart:async';

import 'package:flutter/material.dart';

import 'package:safety/Pages/Home/homepage.dart';
import 'package:safety/Pages/Home/passwordlist.dart';
import 'package:safety/Settings/themes.dart';
import 'package:safety/Settings/texts.dart';
import 'package:safety/custom_icons_icons.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  bool appear = true;
  bool fade = false;
  bool circle = false;
  bool settings = true;
  bool add1 = false;
  bool add2 = false;

  double top = 0;
  double left = 0;
  double right = 0;

  AnimationController rotateController;

  void initState() {
    super.initState();

    setState(() {
      top = size.height * 0.8;
    });

    rotateController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        fade = true;
      });
    });

    Future.delayed(Duration(milliseconds: 700), () {
      setState(() {
        appear = false;
        fade = false;
      });
    });

    Future.delayed(Duration(milliseconds: 2000), () {
      setState(() {
        circle = true;
      });
    });

    Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        top = MediaQuery.of(context).size.height * 0.8;
      });

      if (page == 0) {
        pageController.animateToPage(0,
            duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
        rotateController.forward();

        setState(() {
          settings = true;
          add1 = false;
          add2 = false;

          left = 0;
        });
      }

      if (page == 1) {
        pageController.animateToPage(1,
            duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
        rotateController.reverse();

        setState(() {
          settings = false;
          add1 = true;
          add2 = false;

          left = size.width * 0.6;
        });
      }

      if (page == 2) {
        pageController.animateToPage(2,
            duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
        rotateController.reverse();

        setState(() {
          settings = false;
          add1 = false;
          add2 = true;
        });
      }
    });
  }

  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    Size size1 = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            height: size.height,
            width: size.width,
            color: Color.fromRGBO(230, 230, 230, 1),
          ),
          Container(
            height: size.height,
            width: size1.width,
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: pageController,
              children: <Widget>[
                HomePage(),
                PasswordList(),
              ],
            ),
          ),
          AnimatedPositioned(
            top: top,
            left: left,
            right: right,
            duration: Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: circle ? 1 : 0,
              child: Container(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      height: size.width * 0.25,
                      width: size.width * 0.25,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            bottomLeftColor[theme].withOpacity(0.5),
                            topRightColor[theme].withOpacity(0.5)
                          ],
                        ),
                        borderRadius:
                            BorderRadius.circular(size.width * 0.25 / 2),
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      height: size.width * 0.2,
                      width: size.width * 0.2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            bottomLeftColor[theme],
                            topRightColor[theme]
                          ],
                        ),
                        borderRadius:
                            BorderRadius.circular(size.width * 0.2 / 2),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print('tapped');
                      },
                      child: Container(
                        height: size.width * 0.25,
                        width: size.width * 0.25,
                        color: Colors.transparent,
                        alignment: Alignment.center,
                        child: RotationTransition(
                          turns: Tween(begin: 0.0, end: -0.5)
                              .animate(rotateController),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                  child: AnimatedOpacity(
                                duration: Duration(milliseconds: 400),
                                opacity: settings ? 1 : 0,
                                child: Icon(
                                  CustomIcons.cog,
                                  size: size.width * 0.1,
                                  color: Colors.white,
                                ),
                              )),
                              Container(
                                  child: AnimatedOpacity(
                                duration: Duration(milliseconds: 400),
                                opacity: (add1 || add2) ? 1 : 0,
                                child: Icon(
                                  CustomIcons.plus,
                                  size: size.width * 0.1,
                                  color: Colors.white,
                                ),
                              )),
                            ],
                          ),
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
                  opacity: fade ? 0 : 1,
                  child: Container(
                    height: size.height,
                    width: size.width,
                    color: Colors.white,
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
