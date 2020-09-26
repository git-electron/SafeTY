import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:safety/Settings/texts.dart';
import 'package:safety/Settings/themes.dart';
import 'package:safety/functions.dart';
import 'package:safety/main.dart';

class SetTheme extends StatefulWidget {
  @override
  _SetThemeState createState() => _SetThemeState();
}

class _SetThemeState extends State<SetTheme> {
  bool first = true;
  bool second = false;
  bool third = false;

  bool selection = false;

  int lang = 1;

  int t = 0;

  double width;

  void initState() {
    super.initState();

    getLangState().then((value) {
      if (value != null) {
        setState(() {
          lang = value;
        });
      }
    });

    getThemeState().then((value) {
      if (value != null) {
        setState(() {
          t = value;
        });
      }
    });

    Future.delayed(Duration(milliseconds: 1500), () {
      setState(() {
        second = true;
        first = false;
      });
    });

    Future.delayed(Duration(milliseconds: 2000), () {
      setState(() {
        third = true;
        width = MediaQuery.of(context).size.width * 0.8;
      });
    });

    Future.delayed(Duration(milliseconds: 2700), () {
      setState(() {
        selection = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: size.height * 0.05,
          width: size.width,
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          height: second ? 0 : size.height * 0.25,
        ),
        Container(
          child: Text(
            nice[lang],
            style: Theme.of(context)
                .primaryTextTheme
                .headline1
                .copyWith(fontSize: ScreenUtil().setSp(size.width * 0.12)),
          ),
        ),
        AnimatedContainer(
          alignment: Alignment.center,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          height: second ? size.height * 0.15 : 0,
          child: AnimatedOpacity(
            opacity: first ? 0 : 1,
            duration: Duration(milliseconds: 500),
            child: Text(
              first ? '' : nowSetTheme[lang],
              style: Theme.of(context)
                  .primaryTextTheme
                  .headline1
                  .copyWith(fontSize: ScreenUtil().setSp(size.width * 0.095)),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        AnimatedContainer(
          alignment: Alignment.center,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          height: third ? size.height * 0.45 : 0,
          child: AnimatedOpacity(
            opacity: selection ? 1 : 0,
            duration: Duration(milliseconds: 300),
            child: Container(
              height: size.width * 0.8,
              width: size.width * 0.8,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: third ? 1 : 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: (t == 5 || t == 4)
                          ? size.width * 0.3
                          : size.width * 0.2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: size.width * 0.04,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (selection) {
                                setState(() {
                                  t = 5;
                                  theme = 5;
                                });
                                saveThemeState(5);
                                print(theme);
                              }
                            },
                            child: AnimatedContainer(
                              height: (t == 5)
                                  ? size.width * 0.3
                                  : size.width * 0.2,
                              width: (t == 5)
                                  ? size.width * 0.3
                                  : size.width * 0.2,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular((t == 5)
                                    ? size.width * 0.3 / 2
                                    : size.width * 0.2 / 2),
                                border:
                                    Border.all(color: Colors.white, width: 3),
                                gradient: LinearGradient(
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                    colors: [
                                      bottomLeftColor[5],
                                      topRightColor[5]
                                    ]),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (selection) {
                                setState(() {
                                  t = 4;
                                  theme = 4;
                                });
                                saveThemeState(4);
                                print(theme);
                              }
                            },
                            child: AnimatedContainer(
                              height: (t == 4)
                                  ? size.width * 0.3
                                  : size.width * 0.2,
                              width: (t == 4)
                                  ? size.width * 0.3
                                  : size.width * 0.2,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular((t == 4)
                                    ? size.width * 0.3 / 2
                                    : size.width * 0.2 / 2),
                                border:
                                    Border.all(color: Colors.white, width: 3),
                                gradient: LinearGradient(
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                    colors: [
                                      bottomLeftColor[4],
                                      topRightColor[4]
                                    ]),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.width * 0.04,
                          ),
                        ],
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: (t == 0 || t == 3)
                          ? size.width * 0.3
                          : size.width * 0.2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              if (selection) {
                                setState(() {
                                  t = 0;
                                  theme = 0;
                                });
                                saveThemeState(0);
                                print(theme);
                              }
                            },
                            child: AnimatedContainer(
                              height: (t == 0)
                                  ? size.width * 0.3
                                  : size.width * 0.2,
                              width: (t == 0)
                                  ? size.width * 0.3
                                  : size.width * 0.2,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular((t == 0)
                                    ? size.width * 0.3 / 2
                                    : size.width * 0.2 / 2),
                                border:
                                    Border.all(color: Colors.white, width: 3),
                                gradient: LinearGradient(
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                    colors: [
                                      bottomLeftColor[0],
                                      topRightColor[0]
                                    ]),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (selection) {
                                setState(() {
                                  t = 3;
                                  theme = 3;
                                });
                                saveThemeState(3);
                                print(theme);
                              }
                            },
                            child: AnimatedContainer(
                              height: (t == 3)
                                  ? size.width * 0.3
                                  : size.width * 0.2,
                              width: (t == 3)
                                  ? size.width * 0.3
                                  : size.width * 0.2,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular((t == 3)
                                    ? size.width * 0.3 / 2
                                    : size.width * 0.2 / 2),
                                border:
                                    Border.all(color: Colors.white, width: 3),
                                gradient: LinearGradient(
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                    colors: [
                                      bottomLeftColor[3],
                                      topRightColor[3]
                                    ]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: (t == 1 || t == 2)
                          ? size.width * 0.3
                          : size.width * 0.2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: size.width * 0.04,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (selection) {
                                setState(() {
                                  t = 1;
                                  theme = 1;
                                });
                                saveThemeState(1);
                                print(theme);
                              }
                            },
                            child: AnimatedContainer(
                              height: (t == 1)
                                  ? size.width * 0.3
                                  : size.width * 0.2,
                              width: (t == 1)
                                  ? size.width * 0.3
                                  : size.width * 0.2,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular((t == 1)
                                    ? size.width * 0.3 / 2
                                    : size.width * 0.2 / 2),
                                border:
                                    Border.all(color: Colors.white, width: 3),
                                gradient: LinearGradient(
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                    colors: [
                                      bottomLeftColor[1],
                                      topRightColor[1]
                                    ]),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (selection) {
                                setState(() {
                                  t = 2;
                                  theme = 2;
                                });
                                saveThemeState(2);
                                print(theme);
                              }
                            },
                            child: AnimatedContainer(
                              height: (t == 2)
                                  ? size.width * 0.3
                                  : size.width * 0.2,
                              width: (t == 2)
                                  ? size.width * 0.3
                                  : size.width * 0.2,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular((t == 2)
                                    ? size.width * 0.3 / 2
                                    : size.width * 0.2 / 2),
                                border:
                                    Border.all(color: Colors.white, width: 3),
                                gradient: LinearGradient(
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                    colors: [
                                      bottomLeftColor[2],
                                      topRightColor[2]
                                    ]),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.width * 0.04,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          height: size.height * 0.2,
          width: size.width,
        ),
      ],
    );
  }
}
