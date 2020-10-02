import 'dart:async';
import 'dart:math';

import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safety/Database/DBHelper.dart';
import 'package:safety/Database/password.dart';

import 'package:safety/Pages/Home/homepage.dart';
import 'package:safety/Pages/Home/passwordgenerator.dart';
import 'package:safety/Pages/Home/passwordlist.dart';
import 'package:safety/Pages/Home/passwordview.dart';
import 'package:safety/Settings/settings.dart';
import 'package:safety/Settings/themes.dart';
import 'package:safety/Settings/texts.dart';
import 'package:safety/Utils/fieldFocusChange.dart';
import 'package:safety/Utils/generator.dart';
import 'package:safety/custom_icons_icons.dart';
import 'package:safety/functions.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  bool appear = true;
  bool fade = false;
  bool circle = false;

  bool settings = true;
  bool edit = false;
  bool add1 = false;
  bool add2 = false;
  bool addPassword = false;
  bool updatePassword = false;
  bool settingsState = false;
  bool settingsPage = false;
  bool canSave = false;

  bool active1 = false;
  bool active2 = false;
  bool active3 = false;
  bool active4 = false;

  bool firstField = false;
  bool secondField = false;
  bool thirdField = false;
  bool forthField = false;

  bool obs = true;

  bool animate = false;

  bool logo = true;
  bool managerButton = true;
  bool generatorButton = true;

  double top = 0;
  double left = 0;
  double right = 0;

  double alignment = 0.8;

  int lang = 1;

  Animation<Color> colorAnimation;
  AnimationController colorController;

  AnimationController animationController;
  Animation<double> animation;

  AnimationController rotateController;

  final _titleController = TextEditingController();
  final _passController = TextEditingController();
  final _usernameController = TextEditingController();
  final _linkController = TextEditingController();

  final FocusNode _titleFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _linkFocus = FocusNode();

  String titleHint = '';
  String passHint = '';

  Color color1 = Colors.white;
  Color color2 = Colors.white;

  var db = DBHelper();

  final Settings _settings = Settings();

  void initState() {
    super.initState();

    getLangState().then((value) {
      setState(() {
        lang = value;

        titleHint = titleField[lang];
        passHint = passField[lang];
      });
    });

    setState(() {
      top = size.height * 0.8;
    });

    rotateController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    );

    colorController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    colorAnimation = ColorTween(begin: Colors.white, end: buttonColor[theme])
        .animate(colorController);

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
        if (!settingsState) {
          top = MediaQuery.of(context).size.height * 0.8;
        }
      });

      if (page == 0) {
        pageController.animateToPage(0,
            duration: Duration(milliseconds: 400), curve: Curves.easeInOut);

        if (!settingsState) {
          rotateController.forward();
        }

        setState(() {
          alignment = 0.8;

          settings = true;
          edit = false;
          add1 = false;
          add2 = false;
          addPassword = false;

          left = 0;
        });
      }

      if (page == 1) {
        pageController.animateToPage(1,
            duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
        rotateController.reverse();

        setState(() {
          alignment = 0.8;

          settings = false;
          edit = false;
          add1 = true;
          add2 = false;
          addPassword = false;

          left = size.width * 0.6;
        });
      }

      if (page == 2) {
        pageController.animateToPage(1,
            duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
        rotateController.reverse();

        setState(() {
          alignment = 0.5;

          settings = false;
          edit = false;
          add1 = false;
          add2 = true;
          addPassword = false;
        });
      }

      if (page == 4) {
        pageController.animateToPage(3,
            duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
        rotateController.reverse();

        setState(() {
          alignment = 0.8;

          settings = false;
          edit = true;
          add1 = false;
          add2 = false;
          addPassword = false;
        });
      }

      if (page == 5) {
        rotateController.forward(from: 0.0);

        colorAnimation =
            ColorTween(begin: Colors.white, end: buttonColor[theme])
                .animate(colorController);

        getLangState().then((value) {
          setState(() {
            lang = value;

            titleHint = titleField[lang];
            passHint = passField[lang];
          });
        });

        setState(() {
          page = 0;

          settings = true;
          edit = false;
          add1 = false;
          add2 = false;
          addPassword = false;
          settingsPage = false;

          logo = true;
        });

        Future.delayed(Duration(milliseconds: 200), () {
          setState(() {
            managerButton = true;
          });
        });

        Future.delayed(Duration(milliseconds: 300), () {
          setState(() {
            generatorButton = true;
          });
        });

        Future.delayed(Duration(milliseconds: 500), () {
          setState(() {
            settingsState = false;
          });
        });
      }
    });
  }

  void addPassFromList() {
    setState(() {
      _titleController.text = '';
      _passController.text = '';
      _usernameController.text = '';
      _linkController.text = '';
    });

    animationController.forward();
    rotateController.forward();
    colorController.forward();

    setState(() {
      animate = true;
      addPassword = true;

      page = 3;
      left = 0;
    });

    Future.delayed(Duration(milliseconds: 800), () {
      setState(() {
        firstField = true;
      });
    });
    Future.delayed(Duration(milliseconds: 900), () {
      setState(() {
        secondField = true;
      });
    });
    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        thirdField = true;
      });
    });
    Future.delayed(Duration(milliseconds: 1100), () {
      setState(() {
        forthField = true;
      });
    });

    Future.delayed(Duration(milliseconds: 700), () {
      setState(() {
        canSave = true;
      });
    });
  }

  void addPassFromGenerator() {
    animationController.forward();
    rotateController.forward();
    colorController.forward();

    setState(() {
      animate = true;
      addPassword = true;

      _passController.text = generated;

      page = 3;
      left = 0;
    });

    Future.delayed(Duration(milliseconds: 800), () {
      setState(() {
        firstField = true;
      });
    });
    Future.delayed(Duration(milliseconds: 900), () {
      setState(() {
        secondField = true;
      });
    });
    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        thirdField = true;
      });
    });
    Future.delayed(Duration(milliseconds: 1100), () {
      setState(() {
        forthField = true;
      });
    });

    Future.delayed(Duration(milliseconds: 700), () {
      setState(() {
        canSave = true;
      });
    });
  }

  void editPassFromView() {
    animationController.forward();
    rotateController.forward();
    colorController.forward();

    final cell = passData;

    List<String> cellToDecrypt = [cell.title, cell.pass, cell.name, cell.link];
    List<String> decryptedCell = [];

    decryptCell(cellToDecrypt, false).then((decrypted) {
      decryptedCell = [decrypted[0], decrypted[1], decrypted[2], decrypted[3]];

      setState(() {
        _titleController.text = decryptedCell[0];
        _passController.text = decryptedCell[1];
        _usernameController.text = decryptedCell[2];
        _linkController.text = decryptedCell[3];
      });
    });

    setState(() {
      animate = true;
      updatePassword = true;

      obs = obscure;

      page = 3;
      left = 0;
    });

    setState(() {
      firstField = true;
      secondField = true;
      thirdField = true;
      forthField = true;
    });

    Future.delayed(Duration(milliseconds: 700), () {
      setState(() {
        canSave = true;
      });
    });
  }

  void openSettings() {
    rotateController.reverse(from: 1.0);

    setState(() {
      settingsState = true;
      top = size.height;
    });

    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        generatorButton = false;
      });
    });

    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        managerButton = false;
      });
    });

    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        logo = false;
      });
    });

    Future.delayed(Duration(milliseconds: 700), () {
      setState(() {
        settingsPage = true;
      });
    });
  }

  void close(bool update, bool noChanges) {
    animationController.reverse();
    rotateController.reverse();
    colorController.reverse();

    if(list){
      setState(() {
        alignment = 0.8;

        left = size.width * 0.6;

        obscure = obs;
      });

      if (update) {
        setState(() {
          page = 4;
        });
      } else {
        setState(() {
          page = 1;
        });
      }
    } else {
      if(!noChanges){
        setState(() {
          alignment = 0.8;

          left = size.width * 0.6;

          list = true;

          page = 1;
        });
      }
    }

    Future.delayed(Duration(milliseconds: 700), () {
      setState(() {
        animate = false;
        addPassword = false;
        updatePassword = false;
        canSave = false;

        titleHint = titleField[lang];
        passHint = passField[lang];

        color1 = Colors.white;
        color2 = Colors.white;

        active1 = false;
        active2 = false;
        active3 = false;
        active4 = false;

        _titleController.text = '';
        _passController.text = '';
        _usernameController.text = '';
        _linkController.text = '';
      });
    });

    if (!update) {
      setState(() {
        firstField = false;
      });
      Future.delayed(Duration(milliseconds: 100), () {
        setState(() {
          secondField = false;
        });
      });
      Future.delayed(Duration(milliseconds: 200), () {
        setState(() {
          thirdField = false;
        });
      });
      Future.delayed(Duration(milliseconds: 300), () {
        setState(() {
          forthField = false;
        });
      });
    }
  }

  void savePass() {
    checkPass().then((value) {
      print(value);

      if (value) {
        List<String> cell = [
          _titleController.text,
          _passController.text,
          _usernameController.text,
          _linkController.text
        ];

        encryptCell(cell).then((encryptedCell) async {
          var now = DateTime.now();
          var db = DBHelper();

          var password = Password(encryptedCell[0], encryptedCell[1],
              encryptedCell[2], encryptedCell[3], now.toString());
          await db.savePass(password);
          print('saved');

          close(false, false);
        });
      }
    });
  }

  void editPass() {
    checkPass().then((value) {
      print(value);

      if (value) {
        List<String> cell = [
          _titleController.text,
          _passController.text,
          _usernameController.text,
          _linkController.text
        ];

        encryptCell(cell).then((encryptedCell) async {
          var now = DateTime.now();
          var db = DBHelper();

          var password = Password(encryptedCell[0], encryptedCell[1],
              encryptedCell[2], encryptedCell[3], now.toString());
          password.setPassId(id);
          await db.updatePass(password);
          print('updated');

          setState(() {
            passData = password;

            _titleController.text = cell[0];
            _passController.text = cell[1];
            _usernameController.text = cell[2];
            _linkController.text = cell[3];
          });

          close(true, false);
        });
      }
    });
  }

  Future<bool> checkPass() async {
    bool save = false;

    if (_titleController.text != '') {
      if (_passController.text != '') {
        setState(() {
          save = true;
        });
      } else {
        setState(() {
          passHint = emptyPass[lang];
          color2 = Colors.red;
        });
      }
    } else {
      if (_passController.text == '') {
        setState(() {
          passHint = emptyPass[lang];
          color2 = Colors.red;
        });
      }
      setState(() {
        titleHint = emptyTitle[lang];
        color1 = Colors.red;
      });
    }

    return save;
  }

  Future<bool> back() async {
    if(page == 1){
      setState(() {
        page = 0;
      });
    }
    if(page == 2){
      setState(() {
        page = 0;
      });
    }
    if(page == 3){
      if(list){
        setState(() {
          page = 1;
        });
        if (updatePassword) {
          close(true, false);
        } else {
          close(false, false);
        }
      } else {
        setState(() {
          page = 2;
        });
        close(false, true);
      }
    }
    if(page == 4){
      setState(() {
        page = 1;
      });
    }
    if(settings){
      setState(() {
        page = 5;
      });
    }
    return false;
  }

  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    Size size1 = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: back,
      child: Scaffold(
        backgroundColor: bgColor[dark],
        body: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              height: size.height,
              width: size.width,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 700),
                height: size.height,
                width: size.width,
                color: bgColor[dark],
              ),
            ),
            Container(
              height: size.height,
              width: size1.width,
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: pageController,
                children: <Widget>[
                  ListView(
                    children: [
                      HomePage(),
                    ],
                  ),
                  ListView(
                    children: [
                      (list) ? PasswordList() : PasswordGenerator(),
                    ],
                  ),
                  ListView(
                    children: [
                      PasswordView(),
                    ],
                  ),
                ],
              ),
            ),
            settingsState
                ? Stack(
                    children: [
                      ListView(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              AnimatedOpacity(
                                duration: Duration(milliseconds: 300),
                                opacity: logo ? 0 : 1,
                                child: Container(
                                  height: settingsState ? size.height * 0.45 : 0,
                                  width: size1.width,
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 700),
                                    height: size.height * 0.45,
                                    width: size1.width,
                                    color: bgColor[dark],
                                  ),
                                ),
                              ),
                              AnimatedOpacity(
                                duration: Duration(milliseconds: 300),
                                opacity: managerButton ? 0 : 1,
                                child: Container(
                                  height: settingsState ? size.height * 0.1 : 0,
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 700),
                                    height: size.height * 0.1,
                                    width: size1.width,
                                    color: bgColor[dark],
                                  ),
                                ),
                              ),
                              AnimatedOpacity(
                                duration: Duration(milliseconds: 300),
                                opacity: generatorButton ? 0 : 1,
                                child: Container(
                                  height: settingsState ? size.height * 0.1 : 0,
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 700),
                                    height: size.height * 0.1,
                                    width: size1.width,
                                    color: bgColor[dark],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      ListView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          AnimatedOpacity(
                            duration: Duration(milliseconds: 300),
                            opacity: logo ? 0 : 1,
                            child: Container(
                              height: size.height,
                              width: size1.width,
                              padding: EdgeInsets.fromLTRB(
                                  size.width * 0.04,
                                  size.width * 0.08,
                                  size.width * 0.04,
                                  size.width * 0.04),
                              child: ListView(
                                children: [
                                  Settings(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : SizedBox(),
            animate
                ? Container(
                    height: size.height,
                    width: size1.width,
                    color: Colors.transparent,
                  )
                : SizedBox(),
            animate
                ? ListView(
                    children: [
                      CircularRevealAnimation(
                        animation: animation,
                        centerAlignment: FractionalOffset(alignment, 0.867),
                        minRadius: size.width * 0.1,
                        child: Container(
                          height: size.height,
                          width: size1.width,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                colors: [
                                  bottomLeftColor[theme],
                                  topRightColor[theme]
                                ]),
                          ),
                          padding: EdgeInsets.fromLTRB(
                              size.width * 0.04,
                              size.width * 0.08,
                              size.width * 0.04,
                              size.width * 0.08),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    updatePassword
                                        ? editPage[lang]
                                        : addNew[lang],
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .headline1
                                        .copyWith(fontSize: ScreenUtil().setSp(size.width * 0.11)),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if(list){
                                        if (updatePassword) {
                                          close(true, false);
                                        } else {
                                          close(false, false);
                                        }
                                      } else {
                                        close(false, true);
                                      }
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      child: Icon(
                                        CustomIcons.cross,
                                        size: size.width * 0.1,
                                        color: Colors.white,
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
                                          .copyWith(fontSize: ScreenUtil().setSp(size.width * 0.08)),
                                    ),
                                    Stack(
                                      alignment: FractionalOffset(0.5, 0.95),
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            AnimatedContainer(
                                              duration:
                                                  Duration(milliseconds: 500),
                                              curve: Curves.easeInOut,
                                              height: size.height * 0.002,
                                              width:
                                                  active1 ? 0 : size.width * 0.46,
                                              color: color1,
                                            ),
                                            AnimatedContainer(
                                              duration:
                                                  Duration(milliseconds: 500),
                                              curve: Curves.easeInOut,
                                              height: size.height * 0.002,
                                              width:
                                                  active1 ? 0 : size.width * 0.46,
                                              color: color1,
                                            ),
                                          ],
                                        ),
                                        TextField(
                                          onTap: () {
                                            setState(() {
                                              active1 = true;
                                              active2 = false;
                                              active3 = false;
                                              active4 = false;

                                              titleHint = '';

                                              passHint = passField[lang];

                                              color1 = Colors.white;
                                              color2 = Colors.white;
                                            });
                                          },
                                          onSubmitted: (value) {
                                            fieldFocusChange(
                                                context, _titleFocus, _passFocus);

                                            setState(() {
                                              active1 = false;
                                              active2 = true;

                                              titleHint = titleField[lang];
                                            });
                                          },
                                          controller: _titleController,
                                          focusNode: _titleFocus,
                                          autocorrect: true,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          enabled: true,
                                          cursorColor: Colors.white,
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .headline2
                                              .copyWith(
                                                  fontSize: ScreenUtil().setSp(size.width * 0.057)),
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: titleHint,
                                              hintStyle: Theme.of(context)
                                                  .primaryTextTheme
                                                  .headline2
                                                  .copyWith(
                                                      fontSize:
                                                      ScreenUtil().setSp(size.width * 0.057),
                                                      color: color1
                                                          .withOpacity(0.6))),
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
                                          .copyWith(fontSize: ScreenUtil().setSp(size.width * 0.08)),
                                    ),
                                    Stack(
                                      alignment: FractionalOffset(0.5, 0.95),
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            AnimatedContainer(
                                              duration:
                                                  Duration(milliseconds: 500),
                                              curve: Curves.easeInOut,
                                              height: size.height * 0.002,
                                              width:
                                                  active2 ? 0 : size.width * 0.46,
                                              color: color2,
                                            ),
                                            AnimatedContainer(
                                              duration:
                                                  Duration(milliseconds: 500),
                                              curve: Curves.easeInOut,
                                              height: size.height * 0.002,
                                              width:
                                                  active2 ? 0 : size.width * 0.46,
                                              color: color2,
                                            ),
                                          ],
                                        ),
                                        TextField(
                                          onTap: () {
                                            setState(() {
                                              active1 = false;
                                              active2 = true;
                                              active3 = false;
                                              active4 = false;

                                              passHint = '';

                                              titleHint = titleField[lang];

                                              color1 = Colors.white;
                                              color2 = Colors.white;
                                            });
                                          },
                                          onSubmitted: (value) {
                                            fieldFocusChange(context, _passFocus,
                                                _usernameFocus);

                                            setState(() {
                                              active2 = false;
                                              active3 = true;

                                              passHint = passField[lang];
                                            });
                                          },
                                          controller: _passController,
                                          focusNode: _passFocus,
                                          autocorrect: false,
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          textInputAction: TextInputAction.next,
                                          enabled: true,
                                          obscureText: obs,
                                          cursorColor: Colors.white,
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .headline2
                                              .copyWith(
                                                  fontSize: ScreenUtil().setSp(size.width * 0.057)),
                                          decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                obs
                                                    ? CustomIcons.eye_off
                                                    : CustomIcons.eye,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  obs = !obs;
                                                });
                                              },
                                            ),
                                            border: InputBorder.none,
                                            hintText: passHint,
                                            hintStyle: Theme.of(context)
                                                .primaryTextTheme
                                                .headline2
                                                .copyWith(
                                                    fontSize: ScreenUtil().setSp(size.width * 0.057),
                                                    color:
                                                        color2.withOpacity(0.6)),
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
                                opacity: thirdField ? 1 : 0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      usernameField[lang],
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .headline1
                                          .copyWith(fontSize: ScreenUtil().setSp(size.width * 0.08)),
                                    ),
                                    Stack(
                                      alignment: FractionalOffset(0.5, 0.95),
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            AnimatedContainer(
                                              duration:
                                                  Duration(milliseconds: 500),
                                              curve: Curves.easeInOut,
                                              height: size.height * 0.002,
                                              width:
                                                  active3 ? 0 : size.width * 0.46,
                                              color: Colors.white,
                                            ),
                                            AnimatedContainer(
                                              duration:
                                                  Duration(milliseconds: 500),
                                              curve: Curves.easeInOut,
                                              height: size.height * 0.002,
                                              width:
                                                  active3 ? 0 : size.width * 0.46,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                        TextField(
                                          onTap: () {
                                            setState(() {
                                              active1 = false;
                                              active2 = false;
                                              active3 = true;
                                              active4 = false;

                                              titleHint = titleField[lang];
                                              passHint = passField[lang];

                                              color1 = Colors.white;
                                              color2 = Colors.white;
                                            });
                                          },
                                          onSubmitted: (value) {
                                            fieldFocusChange(context,
                                                _usernameFocus, _linkFocus);

                                            setState(() {
                                              active3 = false;
                                              active4 = true;
                                            });
                                          },
                                          controller: _usernameController,
                                          focusNode: _usernameFocus,
                                          autocorrect: false,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          enabled: true,
                                          cursorColor: Colors.white,
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .headline2
                                              .copyWith(
                                                  fontSize: ScreenUtil().setSp(size.width * 0.057)),
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: active3
                                                  ? ''
                                                  : usernameField[lang],
                                              hintStyle: Theme.of(context)
                                                  .primaryTextTheme
                                                  .headline2
                                                  .copyWith(
                                                      fontSize:
                                                      ScreenUtil().setSp(size.width * 0.057),
                                                      color: Colors.white
                                                          .withOpacity(0.6))),
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
                                          .copyWith(fontSize: ScreenUtil().setSp(size.width * 0.08)),
                                    ),
                                    Stack(
                                      alignment: FractionalOffset(0.5, 0.95),
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            AnimatedContainer(
                                              duration:
                                                  Duration(milliseconds: 500),
                                              curve: Curves.easeInOut,
                                              height: size.height * 0.002,
                                              width:
                                                  active4 ? 0 : size.width * 0.46,
                                              color: Colors.white,
                                            ),
                                            AnimatedContainer(
                                              duration:
                                                  Duration(milliseconds: 500),
                                              curve: Curves.easeInOut,
                                              height: size.height * 0.002,
                                              width:
                                                  active4 ? 0 : size.width * 0.46,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                        TextField(
                                          onTap: () {
                                            setState(() {
                                              active1 = false;
                                              active2 = false;
                                              active3 = false;
                                              active4 = true;

                                              titleHint = titleField[lang];
                                              passHint = passField[lang];

                                              color1 = Colors.white;
                                              color2 = Colors.white;
                                            });
                                          },
                                          onSubmitted: (value) {
                                            setState(() {
                                              active4 = false;
                                            });
                                          },
                                          controller: _linkController,
                                          focusNode: _linkFocus,
                                          autocorrect: false,
                                          keyboardType: TextInputType.url,
                                          textInputAction: TextInputAction.done,
                                          enabled: true,
                                          cursorColor: Colors.white,
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .headline2
                                              .copyWith(
                                                  fontSize: ScreenUtil().setSp(size.width * 0.057)),
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText:
                                                  active4 ? '' : linkField[lang],
                                              hintStyle: Theme.of(context)
                                                  .primaryTextTheme
                                                  .headline2
                                                  .copyWith(
                                                      fontSize:
                                                      ScreenUtil().setSp(size.width * 0.057),
                                                      color: Colors.white
                                                          .withOpacity(0.6))),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : SizedBox(),
            AnimatedPositioned(
              top: top,
              left: left,
              right: right,
              duration: Duration(milliseconds: settingsState ? 400 : 800),
              curve: settingsState ? Curves.easeInBack : Curves.easeInOut,
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
                              (addPassword || updatePassword)
                                  ? Colors.white.withOpacity(0.5)
                                  : bottomLeftColor[theme].withOpacity(0.5),
                              (addPassword || updatePassword)
                                  ? Colors.white.withOpacity(0.5)
                                  : topRightColor[theme].withOpacity(0.5)
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
                              (addPassword || updatePassword)
                                  ? Colors.white
                                  : bottomLeftColor[theme],
                              (addPassword || updatePassword)
                                  ? Colors.white
                                  : topRightColor[theme]
                            ],
                          ),
                          borderRadius:
                              BorderRadius.circular(size.width * 0.2 / 2),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (add1 && !addPassword) {
                            addPassFromList();
                          }
                          if (add2 && !addPassword) {
                            addPassFromGenerator();
                          }
                          if (addPassword) {
                            if (canSave) {
                              savePass();
                            }
                          }
                          if (edit && !updatePassword) {
                            editPassFromView();
                          }
                          if (edit) {
                            if (canSave) {
                              editPass();
                            }
                          }
                          if (settings && !settingsState) {
                            openSettings();
                          }
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
                                Transform.rotate(
                                  angle: pi,
                                  child: Container(
                                      child: AnimatedOpacity(
                                    duration: Duration(milliseconds: 400),
                                    opacity: (edit && updatePassword) ? 1 : 0,
                                    child: Icon(
                                      Icons.check,
                                      size: size.width * 0.1,
                                      color: colorAnimation.value,
                                    ),
                                  )),
                                ),
                                Container(
                                    child: AnimatedOpacity(
                                  duration: Duration(milliseconds: 400),
                                  opacity: (edit && !updatePassword) ? 1 : 0,
                                  child: Icon(
                                    CustomIcons.pencil,
                                    size: size.width * 0.07,
                                    color: colorAnimation.value,
                                  ),
                                )),
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
                                    color: colorAnimation.value,
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
      ),
    );
  }
}
