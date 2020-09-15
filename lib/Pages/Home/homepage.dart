import 'package:flutter/material.dart';

import 'package:safety/Settings/themes.dart';
import 'package:safety/Settings/texts.dart';
import 'package:safety/functions.dart';
import 'package:safety/custom_icons_icons.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool clip = true;
  bool container = true;

  int lang = 1;

  Color color1 = Colors.transparent;
  Color color2 = Colors.transparent;

  void initState() {
    super.initState();

    getLangState().then((value) {
      setState(() {
        lang = value;
      });
    });

    if(first){
      setState(() {
        clip = false;
        container = false;

        first = false;
      });
    }

    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        container = true;
      });
    });

    Future.delayed(Duration(milliseconds: 1600), () {
      setState(() {
        clip = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size1 = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Stack(
          alignment: FractionalOffset(0.5, 0.7),
          children: [
            AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: clip ? 1 : 0,
              child: ClipPath(
                clipper: TopClipper(),
                child: Container(
                  height: size.height * 0.3,
                  width: size1.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        bottomLeftColor[theme].withOpacity(0.2),
                        topRightColor[theme].withOpacity(0.2)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: size.height * 0.08,
              child: ShaderMask(
                blendMode: BlendMode.srcATop,
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [bottomLeftColor[theme], topRightColor[theme]],
                  ).createShader(bounds);
                },
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
        AnimatedContainer(
          alignment: Alignment.topCenter,
          duration: Duration(milliseconds: 700),
          curve: Curves.easeInOut,
          height: container ? size.height * 0.7 : size.height * 0.1,
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 500),
            opacity: clip ? 1 : 0,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: size.height * 0.15,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      color1 = Colors.black12;

                      page = 1;
                    });

                    Future.delayed(Duration(milliseconds: 200), () {
                      setState(() {
                        color1 = Colors.transparent;
                      });
                    });
                  },
                  onLongPressStart: (details){
                    setState(() {
                      color1 = Colors.black12;
                    });
                  },
                  onLongPressEnd: (details){
                    setState(() {
                      color1 = Colors.transparent;
                    });
                  },
                  onTapDown: (details){
                    setState(() {
                      color1 = Colors.black12;
                    });
                  },
                  child: AnimatedContainer(
                    color: color1,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    height: size.height * 0.1,
                    width: size1.width,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(
                        left: size.width * 0.08, right: size.width * 0.08),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          CustomIcons.key,
                          size: size.width * 0.07,
                          color: buttonColor[theme],
                        ),
                        SizedBox(
                          width: size.width * 0.04,
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
                            manager[lang],
                            style: Theme.of(context)
                                .primaryTextTheme
                                .headline2
                                .copyWith(
                                    color: buttonColor[theme],
                                    fontSize: size.height * 0.037),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      color2 = Colors.black12;
                    });

                    Future.delayed(Duration(milliseconds: 200), () {
                      setState(() {
                        color2 = Colors.transparent;
                      });
                    });
                  },
                  onLongPressStart: (details){
                    setState(() {
                      color2 = Colors.black12;
                    });
                  },
                  onLongPressEnd: (details){
                    setState(() {
                      color2 = Colors.transparent;
                    });
                  },
                  onTapDown: (details){
                    setState(() {
                      color2 = Colors.black12;
                    });
                  },
                  child: AnimatedContainer(
                    color: color2,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    height: size.height * 0.1,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(
                        left: size.width * 0.065, right: size.width * 0.08),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          CustomIcons.perspective_dice_random,
                          size: size.width * 0.1,
                          color: buttonColor[theme],
                        ),
                        SizedBox(
                          width: size.width * 0.025,
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
                                    color: buttonColor[theme],
                                    fontSize: size.height * 0.037),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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

    path.lineTo(0, s.height * 0.5);

    var controlPoint1 = Offset(s.width * 1 / 3 - 50, s.height);
    var endPoint1 = Offset(s.width * 1 / 3, s.height);

    path.quadraticBezierTo(
        controlPoint1.dx, controlPoint1.dy, endPoint1.dx, endPoint1.dy);

    var controlPoint2 = Offset(s.width * 1 / 3 + 50, s.height);
    var endPoint2 = Offset(s.width, s.height * 0.5);

    path.quadraticBezierTo(
        controlPoint2.dx, controlPoint2.dy, endPoint2.dx, endPoint2.dy);

    path.lineTo(s.width, 0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => false;
}