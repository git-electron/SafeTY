import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safety/Database/password.dart';
import 'package:safety/Settings/texts.dart';
import 'package:safety/Settings/themes.dart';
import 'package:safety/custom_icons_icons.dart';
import 'package:safety/functions.dart';
import 'package:url_launcher/url_launcher.dart';

class PasswordView extends StatefulWidget {
  @override
  _PasswordViewState createState() => _PasswordViewState();
}

class _PasswordViewState extends State<PasswordView> {
  int lang = 1;

  bool firstField = true;
  bool secondField = true;
  bool thirdField = true;
  bool forthField = true;

  final _titleController = TextEditingController();
  final _passController = TextEditingController();
  final _usernameController = TextEditingController();
  final _linkController = TextEditingController();

  bool obs = true;

  FToast fToast;

  Password cell;
  List<String> decryptedCell;

  void initState() {
    super.initState();

    getLangState().then((value) {
      setState(() {
        lang = value;
      });
    });

    fToast = FToast();
    fToast.init(context);

    setState(() {
      obs = obscure;

      cell = passData;
      id = cell.id;

      _titleController.text = cell.title;
    });

    List<String> cellToDecrypt = [cell.title, cell.pass, cell.name, cell.link];

    decryptCell(cellToDecrypt).then((decrypted) {
      decryptedCell = [decrypted[0], decrypted[1], decrypted[2], decrypted[3]];

      setState(() {
        _titleController.text = decryptedCell[0];
        _passController.text = decryptedCell[1];
        _usernameController.text = decryptedCell[2];
        _linkController.text = decryptedCell[3];
      });
    });

    Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (obs != obscure) {
        setState(() {
          obs = obscure;
        });
      }
      if (cell != passData) {
        print('password was updated');

        setState(() {
          cell = passData;
          id = cell.id;

          _titleController.text = cell.title;
        });

        List<String> cellToDecrypt = [
          cell.title,
          cell.pass,
          cell.name,
          cell.link
        ];

        decryptCell(cellToDecrypt).then((decrypted) {
          decryptedCell = [
            decrypted[0],
            decrypted[1],
            decrypted[2],
            decrypted[3]
          ];

          setState(() {
            _titleController.text = decryptedCell[0];
            _passController.text = decryptedCell[1];
            _usernameController.text = decryptedCell[2];
            _linkController.text = decryptedCell[3];
          });
          print('form updated');
        });
      }
      if (page != 4 && page != 3) {
        timer.cancel();
      }
    });
  }

  void close() {
    setState(() {
      page = 1;
    });

    print(page);
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
            .copyWith(fontSize: size.width * 0.057),
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

    return Stack(
      children: [
        ClipPath(
          clipper: TopClipper(),
          child: Container(
            height: size.height * 0.2,
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
        Container(
          height: size.height,
          width: size1.width,
          padding: EdgeInsets.fromLTRB(size.width * 0.04, size.width * 0.08,
              size.width * 0.04, size.width * 0.08),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ShaderMask(
                    blendMode: BlendMode.srcATop,
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [bottomLeftColor[theme], topRightColor[theme]],
                      ).createShader(bounds);
                    },
                    child: Text(
                      viewPass[lang],
                      style: Theme.of(context)
                          .primaryTextTheme
                          .headline1
                          .copyWith(fontSize: size.width * 0.11),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      close();
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Icon(
                        CustomIcons.cross,
                        size: size.width * 0.1,
                        color: topRightColor[theme],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              AnimatedOpacity(
                duration: Duration(milliseconds: 200),
                opacity: firstField ? 1 : 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      titleField[lang],
                      style: Theme.of(context)
                          .primaryTextTheme
                          .headline1
                          .copyWith(
                              fontSize: size.width * 0.08, color: Colors.black),
                    ),
                    Stack(
                      alignment: FractionalOffset(0.5, 0.95),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              height: size.height * 0.002,
                              width: size.width * 0.46,
                              //color: Colors.white,
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              height: size.height * 0.002,
                              width: size.width * 0.46,
                              //color: Colors.white,
                            ),
                          ],
                        ),
                        TextField(
                          controller: _titleController,
                          enabled: false,
                          style: Theme.of(context)
                              .primaryTextTheme
                              .headline2
                              .copyWith(
                                  fontSize: size.width * 0.057,
                                  color: Colors.black.withOpacity(0.6)),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              AnimatedOpacity(
                duration: Duration(milliseconds: 200),
                opacity: secondField ? 1 : 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      passField[lang],
                      style: Theme.of(context)
                          .primaryTextTheme
                          .headline1
                          .copyWith(
                              fontSize: size.width * 0.08, color: Colors.black),
                    ),
                    Stack(
                      alignment: FractionalOffset(0.5, 0.95),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              height: size.height * 0.002,
                              width: size.width * 0.46,
                              //color: Colors.white,
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              height: size.height * 0.002,
                              width: size.width * 0.46,
                              //color: Colors.white,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: size.width * 0.7,
                              child: TextField(
                                controller: _passController,
                                enabled: false,
                                obscureText: obs,
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline2
                                    .copyWith(
                                        fontSize: size.width * 0.057,
                                        color: Colors.black.withOpacity(0.6)),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  obs = !obs;
                                  obscure = obs;
                                });
                              },
                              child: Container(
                                width: size.width * 0.1,
                                child: Icon(
                                  obs ? CustomIcons.eye_off : CustomIcons.eye,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(
                                    ClipboardData(text: _passController.text));

                                print('copied');
                                fToast.removeQueuedCustomToasts();
                                showToast(copied[lang]);
                              },
                              child: Container(
                                width: size.width * 0.1,
                                child: Icon(
                                  CustomIcons.docs,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              AnimatedOpacity(
                duration: Duration(milliseconds: 200),
                opacity: thirdField ? 1 : 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      usernameField[lang],
                      style: Theme.of(context)
                          .primaryTextTheme
                          .headline1
                          .copyWith(
                              fontSize: size.width * 0.08, color: Colors.black),
                    ),
                    Stack(
                      alignment: FractionalOffset(0.5, 0.95),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              height: size.height * 0.002,
                              width: size.width * 0.46,
                              //color: Colors.white,
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              height: size.height * 0.002,
                              width: size.width * 0.46,
                              //color: Colors.white,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: size.width * 0.8,
                              child: TextField(
                                controller: _usernameController,
                                enabled: false,
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline2
                                    .copyWith(
                                        fontSize: size.width * 0.057,
                                        color: Colors.black.withOpacity(0.6)),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(ClipboardData(
                                    text: _usernameController.text));

                                print('copied');
                                fToast.removeQueuedCustomToasts();
                                showToast(copied[lang]);
                              },
                              child: Container(
                                width: size.width * 0.1,
                                child: Icon(
                                  CustomIcons.docs,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              AnimatedOpacity(
                duration: Duration(milliseconds: 200),
                opacity: forthField ? 1 : 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      linkField[lang],
                      style: Theme.of(context)
                          .primaryTextTheme
                          .headline1
                          .copyWith(
                              fontSize: size.width * 0.08, color: Colors.black),
                    ),
                    Stack(
                      alignment: FractionalOffset(0.5, 0.95),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              height: size.height * 0.002,
                              width: size.width * 0.46,
                              //color: Colors.white,
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              height: size.height * 0.002,
                              width: size.width * 0.46,
                              //color: Colors.white,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: size.width * 0.8,
                              child: TextField(
                                controller: _linkController,
                                enabled: false,
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline2
                                    .copyWith(
                                        fontSize: size.width * 0.057,
                                        color: Colors.black.withOpacity(0.6)),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                String url = _linkController.text;

                                if(url != ''){
                                  if (!url.startsWith('http')) {
                                    setState(() {
                                      url = 'http://' + url;
                                    });
                                  }

                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    fToast.removeQueuedCustomToasts();
                                    showToast(launchException[lang]);
                                  }
                                } else {
                                  fToast.removeQueuedCustomToasts();
                                  showToast(emptyUrlException[lang]);
                                }
                              },
                              child: Container(
                                width: size.width * 0.1,
                                child: Icon(
                                  CustomIcons.link_ext,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
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

    path.lineTo(0, s.height * 0.75);

    var controlPoint1 = Offset(s.width * 2 / 3 - 50, s.height);
    var endPoint1 = Offset(s.width * 2 / 3, s.height);

    path.quadraticBezierTo(
        controlPoint1.dx, controlPoint1.dy, endPoint1.dx, endPoint1.dy);

    var controlPoint2 = Offset(s.width * 2 / 3 + 50, s.height);
    var endPoint2 = Offset(s.width, s.height * 0.75);

    path.quadraticBezierTo(
        controlPoint2.dx, controlPoint2.dy, endPoint2.dx, endPoint2.dy);

    path.lineTo(s.width, 0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => false;
}
