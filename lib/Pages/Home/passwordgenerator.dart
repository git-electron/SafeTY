import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safety/Settings/texts.dart';
import 'package:safety/Settings/themes.dart';
import 'package:safety/Utils/generator.dart';
import 'package:safety/custom_icons_icons.dart';
import 'package:safety/functions.dart';

class PasswordGenerator extends StatefulWidget {
  createState() => PasswordGeneratorState();
}

class PasswordGeneratorState extends State<PasswordGenerator>
    with TickerProviderStateMixin {
  Generator _generator = Generator();

  int lang = 1;

  bool _letterCheckBool = false;
  bool _numCheckBool = false;
  bool _symCheckBool = false;
  double _sliderVal = 8.0;

  bool regenerate = false;

  bool height = true;

  FToast fToast;

  AnimationController rotateController;

  void initState() {
    super.initState();
    getLangState().then((value) {
      setState(() {
        lang = value;
      });
    });

    fToast = FToast();
    fToast.init(context);

    rotateController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  void generate() {
    _generator.generate(_sliderVal.round());

    setState(() {
      generated = _generator.getGeneratedValue();
      print(generated);
    });

    if (_generator.getGeneratedValue().length > 0) {
      setState(() {
        regenerate = true;
      });
    } else {
      setState(() {
        regenerate = false;
      });
    }
  }

  void letterCheck(bool value) {
    setState(() {
      _generator.checkLetterGen(value);
      _letterCheckBool = value;
    });

    generate();
  }

  void numCheck(bool value) {
    setState(() {
      _generator.checkNumGen(value);
      _numCheckBool = value;
    });

    generate();
  }

  void symCheck(bool value) {
    setState(() {
      _generator.checkSymGen(value);
      _symCheckBool = value;
    });

    generate();
  }

  void sliderChange(double value) {
    setState(() {
      _sliderVal = value;
    });

    generate();
  }

  void showToast(String text) {
    Widget toast = Container(
      padding: EdgeInsets.fromLTRB(size.width * 0.05, size.width * 0.02,
          size.width * 0.05, size.width * 0.02),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              bottomLeftColor[theme].withOpacity(0.4),
              topRightColor[theme].withOpacity(0.4)
            ]),
        borderRadius: BorderRadius.circular(size.height),
      ),
      child: Text(
        text,
        style: Theme.of(context)
            .primaryTextTheme
            .headline2
            .copyWith(fontSize: ScreenUtil().setSp(size.width * 0.057)),
      ),
    );

    fToast.showToast(
      child: toast,
      toastDuration: Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size1 = MediaQuery.of(context).size;

    return Column(
      children: <Widget>[
        Stack(
          alignment: FractionalOffset(0.5, 0.5),
          children: [
            ClipPath(
              clipper: TopClipper(),
              child: Container(
                height: size.height * 0.15,
                width: size1.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      topRightColor[theme].withOpacity(0.2),
                      bottomLeftColor[theme].withOpacity(0.2)
                    ],
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: size.width,
              padding: EdgeInsets.only(
                  left: size.width * 0.04, right: size.width * 0.04),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            page = 0;
                          });
                        },
                        child: Container(
                          height: size.width * 0.07,
                          width: size.width * 0.07,
                          color: Colors.transparent,
                          child: Icon(
                            CustomIcons.left_open,
                            color: buttonColor[theme],
                            size: size.width * 0.07,
                          ),
                        ),
                      ),
                      ShaderMask(
                          blendMode: BlendMode.srcATop,
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: [
                                bottomLeftColor[theme],
                                topRightColor[theme]
                              ],
                            ).createShader(bounds);
                          },
                          child: Text(
                            generator[lang],
                            style: Theme.of(context)
                                .primaryTextTheme
                                .headline2
                                .copyWith(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(size.width * 0.076),
                                ),
                          )),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(
                              text: _generator.getGeneratedValue()));

                          print('copied');
                          fToast.removeQueuedCustomToasts();
                          showToast(copied[lang]);
                        },
                        child: Container(
                          height: size.width * 0.07,
                          width: size.width * 0.07,
                          child: Icon(
                            CustomIcons.docs,
                            color: topRightColor[theme],
                            size: size.width * 0.07,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: size.height * 0.03,
        ),
        Container(
          height: size.height * 0.82,
          width: size1.width,
          child: ListView(
            children: <Widget>[
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.all(size.width * 0.06),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: <Widget>[
                    Container(
                      width: size1.width * 0.88,
                      height: size.height * 0.1,
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          rotateController.forward(from: 0.0);
                          generate();
                        },
                        child: Container(
                          height: size.width * 0.1,
                          width: size.width * 0.1,
                          color: Colors.transparent,
                          alignment: Alignment.center,
                          child: RotationTransition(
                            turns: Tween(begin: 0.0, end: 0.5)
                                .animate(rotateController),
                            child: Container(
                                child: Icon(
                              CustomIcons.arrows_cw,
                              size: size.width * 0.07,
                              color: blackWhiteColor[dark].withOpacity(0.6),
                            )),
                          ),
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      width:
                          regenerate ? size1.width * 0.75 : size1.width * 0.88,
                      height: _generator.getGeneratedValue().isEmpty
                          ? size.height * 0.1
                          : (_symCheckBool
                              ? size.height * 0.1 +
                                  size.width *
                                      0.06 *
                                      _generator.getGeneratedValue().length /
                                      15
                              : size.height * 0.1 +
                                  size.width *
                                      0.06 *
                                      _generator.getGeneratedValue().length /
                                      18),
                      alignment: Alignment.centerLeft,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: EdgeInsets.all(size.width * 0.04),
                      decoration: BoxDecoration(
                          color: (dark == 1)
                              ? Color.fromRGBO(30, 30, 30, 1)
                              : Colors.white,
                          borderRadius:
                              BorderRadius.circular(size.height * 0.02),
                          boxShadow: [
                            BoxShadow(
                                color: buttonBgColor[dark].withOpacity(0.1),
                                blurRadius: 25,
                                spreadRadius: 5,
                                offset: Offset(0, 5))
                          ]),
                      child: Text(
                        _generator.getGeneratedValue(),
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline2
                            .copyWith(
                                fontSize: ScreenUtil().setSp(size.width * 0.06),
                                color: blackWhiteColor[dark].withOpacity(0.6)),
                        overflow: TextOverflow.fade,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              CheckboxListTile(
                title: Text(
                  useLetters[lang],
                  style: Theme.of(context).primaryTextTheme.headline2.copyWith(
                      fontSize: ScreenUtil().setSp(size.width * 0.05),
                      color: blackWhiteColor[dark].withOpacity(0.6)),
                ),
                value: _letterCheckBool,
                activeColor: Colors.white,
                checkColor: topRightColor[theme],
                onChanged: (bool value) {
                  letterCheck(value);
                },
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              CheckboxListTile(
                title: Text(
                  useNumbers[lang],
                  style: Theme.of(context).primaryTextTheme.headline2.copyWith(
                      fontSize: ScreenUtil().setSp(size.width * 0.05),
                      color: blackWhiteColor[dark].withOpacity(0.6)),
                ),
                value: _numCheckBool,
                activeColor: Colors.white,
                checkColor: topRightColor[theme],
                onChanged: (bool value) {
                  numCheck(value);
                },
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              CheckboxListTile(
                title: Text(
                  useSymbols[lang],
                  style: Theme.of(context).primaryTextTheme.headline2.copyWith(
                      fontSize: ScreenUtil().setSp(size.width * 0.05),
                      color: blackWhiteColor[dark].withOpacity(0.6)),
                ),
                value: _symCheckBool,
                activeColor: Colors.white,
                checkColor: topRightColor[theme],
                onChanged: (bool value) {
                  symCheck(value);
                },
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Container(
                height: 30,
                child: Center(
                  child: Text(
                    symbolsCount[lang],
                    style: Theme.of(context)
                        .primaryTextTheme
                        .headline2
                        .copyWith(
                            fontSize: ScreenUtil().setSp(size.width * 0.057),
                            color: blackWhiteColor[dark].withOpacity(0.6)),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: SliderTheme(
                      data: SliderThemeData(
                          trackHeight: size.height * 0.022,
                          trackShape: RoundedRectSliderTrackShape(),
                          rangeTrackShape: RoundedRectRangeSliderTrackShape()),
                      child: Slider(
                        value: _sliderVal,
                        onChanged: (double value) {
                          sliderChange(value);
                        },
                        divisions: 100,
                        min: 8.0,
                        max: 100.0,
                        activeColor: (dark == 1) ? blackWhiteColor[dark] : Color.fromRGBO(60, 60, 60, 1),
                        inactiveColor: blackWhiteColor[dark].withOpacity(0.2),
                      ),
                    ),
                  ),
                  Container(
                    width: 50.0,
                    child: Text(
                      _sliderVal.round().toString(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .headline2
                          .copyWith(
                              fontSize: ScreenUtil().setSp(size.width * 0.044),
                              color: blackWhiteColor[dark]),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: size.height * 0.25,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TopClipper extends CustomClipper<Path> {
  @override
  getClip(Size s) {
    Path path = Path();

    path.lineTo(0, s.height);

    var controlPoint1 = Offset(s.width * 1 / 3 - 50, s.height * 0.7);
    var endPoint1 = Offset(s.width * 1 / 3, s.height * 0.7);

    path.quadraticBezierTo(
        controlPoint1.dx, controlPoint1.dy, endPoint1.dx, endPoint1.dy);

    var controlPoint2 = Offset(s.width * 1 / 3 + 50, s.height * 0.7);
    var endPoint2 = Offset(s.width, s.height);

    path.quadraticBezierTo(
        controlPoint2.dx, controlPoint2.dy, endPoint2.dx, endPoint2.dy);

    path.lineTo(s.width, 0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => false;
}
