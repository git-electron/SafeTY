import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safety/Functions.dart';

import 'package:safety/Settings/texts.dart';
import 'package:safety/Settings/themes.dart';

class SetLanguage extends StatefulWidget {
  @override
  _SetLanguageState createState() => _SetLanguageState();
}

class _SetLanguageState extends State<SetLanguage>
    with SingleTickerProviderStateMixin {
  bool first = true;
  bool second = false;
  bool third = false;
  bool thirdtext = false;
  bool rus = false;
  bool buttons = false;

  int lang = 1;

  void initState() {
    super.initState();

    getLangState().then((value) {
      if (value != null) {
        setState(() {
          lang = value;
        });

        if (value == 0) {
          setState(() {
            rus = true;
          });
        }
      }
    });

    Future.delayed(Duration(milliseconds: 4000), () {
      setState(() {
        first = false;
      });
    });

    Future.delayed(Duration(milliseconds: 4500), () {
      setState(() {
        second = true;
      });
    });

    Future.delayed(Duration(milliseconds: 6000), () {
      setState(() {
        third = true;
      });
    });

    Future.delayed(Duration(milliseconds: 6500), () {
      setState(() {
        thirdtext = true;
      });
    });

    Future.delayed(Duration(milliseconds: 7500), () {
      setState(() {
        buttons = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: size.width * 0.1,
          width: size.width,
        ),
        Container(
          height: size.height * 0.4,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedOpacity(
                opacity: first ? 1 : 0,
                duration: Duration(milliseconds: 300),
                child: Center(
                  child: Text(
                    hello[lang],
                    style: Theme.of(context)
                        .primaryTextTheme
                        .headline1
                        .copyWith(fontSize: ScreenUtil().setSp(size.width * 0.12)),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedOpacity(
                    opacity: second ? 1 : 0,
                    duration: Duration(milliseconds: 300),
                    child: Center(
                      child: Text(
                        greetings[lang],
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline1
                            .copyWith(fontSize: ScreenUtil().setSp(size.width * 0.095)),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment.bottomCenter,
                    height: third ? size.height * 0.15 : 0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    child: AnimatedOpacity(
                      opacity: thirdtext ? 1 : 0,
                      duration: Duration(milliseconds: 300),
                      child: Text(
                        setLanguage[lang],
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline1
                            .copyWith(fontSize: ScreenUtil().setSp(size.width * 0.095)),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: buttons ? 1 : 0,
          child: Container(
            height: size.height * 0.28,
            width: size.width,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    if (buttons) {
                      setState(() {
                        rus = false;
                        lang = 1;
                        saveLangState(lang);
                      });
                    }
                  },
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        height: size.height * 0.09,
                        width: !rus ? size.width * 0.8 : size.height * 0.085,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(size.height * 0.1 / 2),
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        height: size.height * 0.09,
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white, width: !rus ? 4 : 2),
                          borderRadius:
                              BorderRadius.circular(size.height * 0.1 / 2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: size.height * 0.09,
                              width: size.height * 0.085,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      size.height * 0.1 / 2),
                                  color: Colors.white,
                                  image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/english.png'),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            SizedBox(
                              width: size.width * 0.05,
                            ),
                            Text('English',
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline1
                                    .copyWith(
                                        fontSize: ScreenUtil().setSp(size.width * 0.095),
                                        fontWeight: !rus
                                            ? FontWeight.w300
                                            : FontWeight.w200))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                GestureDetector(
                  onTap: () {
                    if (buttons) {
                      setState(() {
                        rus = true;
                        lang = 0;
                        saveLangState(lang);
                      });
                    }
                  },
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        height: size.height * 0.09,
                        width: rus ? size.width * 0.8 : size.height * 0.085,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(size.height * 0.1 / 2),
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        height: size.height * 0.09,
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white, width: rus ? 4 : 2),
                          borderRadius:
                              BorderRadius.circular(size.height * 0.1 / 2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: size.height * 0.09,
                              width: size.height * 0.085,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      size.height * 0.1 / 2),
                                  color: Colors.white,
                                  image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/russian.png'),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            SizedBox(
                              width: size.width * 0.05,
                            ),
                            Text('Русский',
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline1
                                    .copyWith(
                                        fontSize: ScreenUtil().setSp(size.width * 0.095),
                                        fontWeight: rus
                                            ? FontWeight.w300
                                            : FontWeight.w200))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: size.width * 0.25,
        ),
      ],
    );
  }
}
