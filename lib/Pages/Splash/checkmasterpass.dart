import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safety/Cloud/auth.dart';

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

  final AuthService _auth = AuthService();

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

  void checkMasterPass() async {
    if(_controller.text != ''){
      getEmail().then((emails) async {
        int i = 0;

        String result = await _auth.signIn(emails[i], _controller.text);

        while(i < emails.length){
          try {
            result = result.split(']')[1].substring(1);
            print('[AUTH] result is: ' + result);

            setState(() {
              text = result;
              color = Colors.red;
              loadingState = false;
            });
          } catch (e) {
            if (result == '!emailVerified') {
              print(e.toString());
              print('[AUTH] result is: ' + result);

              setState(() {
                text = verifyEmail[lang];
                loadingState = false;
              });

              User user = await _auth.getUser();
              user.sendEmailVerification();
            } else {
              print(e.toString());
              print('[AUTH] result is: ' + result);

              User user = await _auth.getUser();

              saveLoginState(true);
              saveEmail([user.email]);

              generateKeyFromPassword(_controller.text);

              print(
                  '\n\n[AUTH] Logged in:\nEmail: ${user.email}\nPassword: secured\n\n');

              setState(() {
                loadingState = false;
              });

              return;
            }
          }

          i++;
        }
      });
    } else {
      setState(() {
        text = enterPass[lang];
        color = Colors.red;
        loadingState = false;
      });
    }


    print(text);
  }

  @override
  Widget build(BuildContext context) {
    Size size1 = MediaQuery.of(context).size;
    ScreenUtil.init(context,
        height: size.height, width: size.width, allowFontScaling: false);

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
              style: Theme.of(context)
                  .primaryTextTheme
                  .headline1
                  .copyWith(fontSize: ScreenUtil().setSp(size.width * 0.12)),
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
                  .copyWith(fontSize: ScreenUtil().setSp(size.width * 0.087)),
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
                    .copyWith(fontSize: ScreenUtil().setSp(size.width * 0.057)),
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
                          fontSize: ScreenUtil().setSp(size.width * 0.057),
                          color: Colors.white.withOpacity(0.6)),
                ),
              ),
            ),
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          height: (text == '') ? size.height * 0.14 : size.height * 0.07,
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: size1.width * 0.95,
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
                      fontSize: ScreenUtil().setSp(size.width * 0.047),
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
