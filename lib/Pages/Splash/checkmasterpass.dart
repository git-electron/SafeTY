import 'dart:async';

import 'package:flutter/material.dart';

import 'package:safety/Settings/texts.dart';
import 'package:safety/Settings/themes.dart';
import 'package:safety/functions.dart';
import 'package:safety/custom_icons_icons.dart';

class CheckMasterPass extends StatefulWidget {
  @override
  _CheckMasterPassState createState() => _CheckMasterPassState();
}

class _CheckMasterPassState extends State<CheckMasterPass> {
  bool first = true;
  bool second = false;
  bool third = false;
  bool field = false;
  bool active = false;

  int lang = 1;

  bool obs = true;

  String text = '';

  final _controller = TextEditingController();

  Color color = Colors.white;

  double width;

  void initState() {
    super.initState();

    getLangState().then((value) {
      setState(() {
        lang = value;
      });
    });

    Future.delayed(Duration(milliseconds: 4000), () {
      setState(() {
        second = true;
        first = false;
        third = true;
      });
    });

    Future.delayed(Duration(milliseconds: 4500), () {
      setState(() {
        field = true;
        width = MediaQuery.of(context).size.width * 0.8;
      });
    });

    Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (startChecking) {
        setState(() {
          startChecking = false;
        });

        checkMasterPass();
      }
    });
  }

  void checkMasterPass() {
    if (_controller.text != '') {
      decryptPass(_controller.text).then((value) {
        if (value) {
          print('Success');
          setState(() {
            text = '';

            transition = true;
          });
        } else {
          setState(() {
            text = incorrectPass[lang];
            color = Colors.red;
          });
        }
      });
    } else {
      setState(() {
        text = enterMasterPass[lang];
        color = Colors.red;
      });
    }

    print(text);
  }

  @override
  Widget build(BuildContext context) {

    Size size1 = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          height: second ? size.height * 0.2 : size.height * 0.4,
          width: size.width,
        ),
        Container(
          child: AnimatedOpacity(
            opacity: first ? 1 : 0,
            duration: Duration(milliseconds: 300),
            child: Text(
              hello[lang],
              style: Theme.of(context).primaryTextTheme.headline1,
            ),
          ),
        ),
        AnimatedContainer(
          alignment: Alignment.center,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          height: second ? size.height * 0.15 : 0,
          child: AnimatedOpacity(
            opacity: first ? 0 : 1,
            duration: Duration(milliseconds: 300),
            child: Text(
              first ? '' : enterPass[lang],
              style: Theme.of(context)
                  .primaryTextTheme
                  .headline1
                  .copyWith(fontSize: size1.height * 0.046),
              textAlign: TextAlign.center,
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
            child: AnimatedContainer(
              padding: EdgeInsets.only(
                  left: size.width * 0.05, right: size.width * 0.05),
              alignment: Alignment.centerLeft,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              height: size.height * 0.09,
              width: field ? width : size.height * 0.09,
              decoration: BoxDecoration(
                  color: color.withOpacity(active ? 0.3 : 0.1),
                  borderRadius: BorderRadius.circular(size.height * 0.1 / 2),
                  border: Border.all(color: color, width: 3)),
              child: TextField(
                controller: _controller,
                autocorrect: false,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                obscureText: obs,
                enabled: true,
                style: Theme.of(context)
                    .primaryTextTheme
                    .headline2
                    .copyWith(fontSize: 25),
                onTap: () {
                  setState(() {
                    active = true;
                    width = size.width * 0.9;
                  });
                },
                onChanged: (value) {
                  color = Colors.white;

                  text = '';
                },
                onSubmitted: (value) {
                  setState(() {
                    active = false;
                    width = size.width * 0.8;
                  });
                },
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      obs ? CustomIcons.eye_off : CustomIcons.eye,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        obs = !obs;
                      });
                    },
                  ),
                  border: InputBorder.none,
                  hintText: masterPassField[lang],
                  hintStyle: Theme.of(context)
                      .primaryTextTheme
                      .headline2
                      .copyWith(
                          fontSize: size1.height * 0.03, color: Colors.white.withOpacity(0.6)),
                ),
              ),
            ),
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          height: (text == '') ? size.height * 0.14 : size.height * 0.07,
          alignment: Alignment.center,
          child: FlatButton(
            onPressed: (){
              saveEncryptedPass(null);
            },
            color: Colors.white30,
            child: Text(
              '[Temporary]\nClear password',
              style: Theme.of(context)
                  .primaryTextTheme
                  .headline2
                  .copyWith(fontSize: 22),
              textAlign: TextAlign.center,
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
                      fontSize: 22,
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
