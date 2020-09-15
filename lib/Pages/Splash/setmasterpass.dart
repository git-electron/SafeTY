import 'dart:async';

import 'package:flutter/material.dart';

import 'package:safety/Settings/texts.dart';
import 'package:safety/Settings/themes.dart';
import 'package:safety/Utils/fieldFocusChange.dart';
import 'package:safety/functions.dart';
import 'package:safety/custom_icons_icons.dart';

class SetMasterPass extends StatefulWidget {
  @override
  _SetMasterPassState createState() => _SetMasterPassState();
}

class _SetMasterPassState extends State<SetMasterPass> {
  bool first = true;
  bool second = false;
  bool third = false;
  bool field = false;
  bool active1 = false;
  bool active2 = false;
  bool obs1 = true;
  bool obs2 = true;

  int lang = 1;

  double width1;
  double width2;
  double height = size.height * 0.3;

  String text = '';

  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();

  final FocusNode _firstFocus = FocusNode();
  final FocusNode _secondFocus = FocusNode();

  Color color1 = Colors.white;
  Color color2 = Colors.white;

  void initState() {
    super.initState();

    getLangState().then((value) {
      setState(() {
        lang = value;
      });
    });

    Future.delayed(Duration(milliseconds: 1500), () {
      setState(() {
        second = true;
        first = false;

        height = size.height * 0.1;
      });
    });

    Future.delayed(Duration(milliseconds: 2500), () {
      setState(() {
        third = true;
      });
    });

    Future.delayed(Duration(milliseconds: 3000), () {
      setState(() {
        field = true;
        width1 = MediaQuery.of(context).size.width * 0.8;
        width2 = MediaQuery.of(context).size.width * 0.8;
      });
    });

    Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (startSetting) {
        setState(() {
          startSetting = false;
        });

        setMasterPass();
      }
    });
  }

  void setMasterPass() {
    if (_controller1.text != '') {
      if (_controller1.text == _controller2.text) {
        if (_controller1.text.length >= 8) {
          setState(() {
            text = '';
          });

          encryptPass(_controller1.text);
        } else {
          setState(() {
            text = less[lang];
            color1 = Colors.red;
          });
        }
      } else {
        setState(() {
          text = notEqual[lang];
          color1 = Colors.red;
          color2 = Colors.red;
        });
      }
    } else {
      setState(() {
        text = enterMasterPass[lang];
        color1 = Colors.red;
      });
    }

    print(text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          height: (text == '') ? height : size.height * 0.05,
        ),
        Container(
          child: Text(
            awesome[lang],
            style: Theme.of(context)
                .primaryTextTheme
                .headline1
                .copyWith(fontSize: size.width * 0.12),
          ),
        ),
        AnimatedContainer(
          alignment: Alignment.bottomCenter,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          height: second ? size.height * 0.15 : 0,
          child: AnimatedOpacity(
            opacity: first ? 0 : 1,
            duration: Duration(milliseconds: 300),
            child: Text(
              first ? '' : setPass[lang],
              style: Theme.of(context)
                  .primaryTextTheme
                  .headline1
                  .copyWith(fontSize: size.width * 0.087),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
        ),
        AnimatedContainer(
          alignment: Alignment.center,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          height: third ? size.height * 0.15 : 0,
          child: AnimatedOpacity(
            opacity: third ? 1 : 0,
            duration: Duration(milliseconds: 300),
            child: Text(
              first ? '' : aboutPass[lang],
              style: Theme.of(context)
                  .primaryTextTheme
                  .headline1
                  .copyWith(fontSize: size.width * 0.087),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
        ),
        AnimatedContainer(
          alignment: Alignment.center,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          height: third ? size.height * 0.12 : 0,
          child: AnimatedOpacity(
            opacity: third ? 1 : 0,
            duration: Duration(milliseconds: 300),
            child: AnimatedContainer(
              padding: EdgeInsets.only(
                  left: size.width * 0.05, right: size.width * 0.05),
              alignment: Alignment.centerLeft,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              height: size.height * 0.09,
              width: field ? width1 : size.height * 0.09,
              decoration: BoxDecoration(
                  color: color1.withOpacity(active1 ? 0.3 : 0.1),
                  borderRadius: BorderRadius.circular(size.height * 0.1 / 2),
                  border: Border.all(color: color1, width: 3)),
              child: TextField(
                controller: _controller1,
                autocorrect: false,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                focusNode: _firstFocus,
                obscureText: obs1,
                enabled: true,
                style: Theme.of(context)
                    .primaryTextTheme
                    .headline2
                    .copyWith(fontSize: size.width * 0.057),
                onTap: () {
                  setState(() {
                    active1 = true;
                    active2 = false;
                    width1 = size.width * 0.9;
                    width2 = size.width * 0.8;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    color1 = Colors.white;
                    color2 = Colors.white;

                    text = '';
                  });
                },
                onSubmitted: (value) {
                  setState(() {
                    active1 = false;
                    active2 = true;
                    width1 = size.width * 0.8;
                    width2 = size.width * 0.9;
                  });
                  fieldFocusChange(context, _firstFocus, _secondFocus);
                },
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      obs1 ? CustomIcons.eye_off : CustomIcons.eye,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        obs1 = !obs1;
                      });
                    },
                  ),
                  border: InputBorder.none,
                  hintText: masterPassField[lang],
                  hintStyle: Theme.of(context)
                      .primaryTextTheme
                      .headline2
                      .copyWith(
                          fontSize: size.width * 0.057,
                          color: Colors.white.withOpacity(0.6)),
                ),
              ),
            ),
          ),
        ),
        AnimatedContainer(
          alignment: Alignment.center,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          height: third ? size.height * 0.12 : 0,
          child: AnimatedOpacity(
            opacity: third ? 1 : 0,
            duration: Duration(milliseconds: 300),
            child: AnimatedContainer(
              padding: EdgeInsets.only(
                  left: size.width * 0.05, right: size.width * 0.05),
              alignment: Alignment.centerLeft,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              height: size.height * 0.09,
              width: field ? width2 : size.height * 0.09,
              decoration: BoxDecoration(
                  color: color2.withOpacity(active2 ? 0.3 : 0.1),
                  borderRadius: BorderRadius.circular(size.height * 0.1 / 2),
                  border: Border.all(color: color2, width: 3)),
              child: TextField(
                controller: _controller2,
                autocorrect: false,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                focusNode: _secondFocus,
                obscureText: obs2,
                enabled: true,
                style: Theme.of(context)
                    .primaryTextTheme
                    .headline2
                    .copyWith(fontSize: size.width * 0.057),
                onTap: () {
                  setState(() {
                    active2 = true;
                    active1 = false;
                    width2 = size.width * 0.9;
                    width1 = size.width * 0.8;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    color1 = Colors.white;
                    color2 = Colors.white;

                    text = '';
                  });
                },
                onSubmitted: (value) {
                  setState(() {
                    active2 = false;
                    width2 = size.width * 0.8;
                  });
                },
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      obs2 ? CustomIcons.eye_off : CustomIcons.eye,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        obs2 = !obs2;
                      });
                    },
                  ),
                  border: InputBorder.none,
                  hintText: repeatField[lang],
                  hintStyle: Theme.of(context)
                      .primaryTextTheme
                      .headline2
                      .copyWith(
                          fontSize: size.width * 0.057,
                          color: Colors.white.withOpacity(0.6)),
                ),
              ),
            ),
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: size.width,
          height: (text == '') ? size.height * 0.058 : size.height * 0.108,
          alignment: Alignment.center,
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 200),
            opacity: (text == '') ? 0 : 1,
            child: Container(
              padding: EdgeInsets.fromLTRB(size.width * 0.04,
                  size.height * 0.008, size.width * 0.04, size.height * 0.008),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(size.height)),
              child: Text(
                text,
                style: Theme.of(context).primaryTextTheme.headline2.copyWith(
                      fontSize: size.width * 0.047,
                      color: Colors.red,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
