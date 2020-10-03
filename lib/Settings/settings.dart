import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import 'package:safety/Database/DBHelper.dart';
import 'package:safety/Database/password.dart';
import 'package:safety/Settings/texts.dart';
import 'package:safety/Cloud/auth.dart';
import 'package:safety/Cloud/models/user.dart';
import 'package:safety/Cloud/cloud.dart';

import 'package:safety/Settings/themes.dart';
import 'package:safety/Utils/fieldFocusChange.dart';
import 'package:safety/custom_icons_icons.dart';
import 'package:safety/functions.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with TickerProviderStateMixin {
  int lang = 0;

  bool container = true;

  bool pressed1 = false;
  bool pressed2 = false;
  bool pressed3 = false;
  bool pressed4 = false;
  bool pressed5 = false;
  bool pressed6 = false;
  bool pressed7 = false;
  bool pressed8 = false;
  bool pressed9 = false;
  bool pressed10 = false;
  bool themeSelect = false;
  bool languageSelect = false;
  bool changeMail = false;
  bool changePass = false;
  bool donateWindow = false;
  bool aboutWindow = false;

  bool selection = false;
  bool langSelection = false;
  bool mailChanging = false;
  bool passChanging = false;
  bool donating = false;
  bool aboutInfo = false;

  bool rus = false;
  bool buttons = false;

  bool obs1 = true;
  bool obs2 = true;
  bool obs3 = true;

  bool active1 = false;
  bool active2 = false;
  bool active3 = false;

  bool finished = false;

  bool passChanged = false;
  bool mailChanged = false;

  bool loggedIn = false;
  bool anim = false;
  bool reg = false;

  double width1 = size.width * 0.75;
  double width2 = size.width * 0.75;
  double width3 = size.width * 0.75;

  Color color1 = Colors.white;
  Color color2 = Colors.white;
  Color color3 = Colors.white;

  String text = '';

  int t = 0;

  Animation<Color> colorAnimation;
  AnimationController colorController;

  Animation<Color> color2Animation;
  AnimationController color2Controller;

  AnimationController rotateController;
  AnimationController rotateController1;

  final _oldMasterPassController = TextEditingController();
  final _newMasterPassController = TextEditingController();
  final _repeatMasterPassController = TextEditingController();

  final _emailController = TextEditingController();
  final _masterPassController = TextEditingController();

  final FocusNode _firstFocus = FocusNode();
  final FocusNode _secondFocus = FocusNode();
  final FocusNode _thirdFocus = FocusNode();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _masterPassFocus = FocusNode();

  final db = DBHelper();

  final AuthService _auth = AuthService();
  final DatabaseService _database = DatabaseService();

  void initState() {
    super.initState();

    getLangState().then((value) {
      setState(() {
        lang = value;
      });
    });

    getThemeState().then((value) {
      if (value != null) {
        setState(() {
          t = value;
        });
      }
    });

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

    getLoginState().then((value) {
      if (value != null) {
        setState(() {
          loggedIn = value;
          anim = value;
        });
      } else {
        setState(() {
          loggedIn = false;
        });
      }
    });

    rotateController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    rotateController1 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    colorController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    colorAnimation = ColorTween(begin: Colors.white, end: Colors.black)
        .animate(colorController);

    color2Controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    color2Animation = ColorTween(begin: Colors.black, end: Colors.white)
        .animate(colorController);

    if (dark == 1) {
      setState(() {
        colorController.forward();
      });
    }

    Future.delayed((Duration(milliseconds: 100)), () {
      setState(() {
        width1 = MediaQuery.of(context).size.width * 0.75;
        width2 = MediaQuery.of(context).size.width * 0.75;
        width3 = MediaQuery.of(context).size.width * 0.75;
      });
    });

    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        container = false;
      });
    });
  }

  void changeMasterPass() {
    checkMasterPass(_oldMasterPassController.text);

    Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (finished) {
        Future.delayed(Duration(milliseconds: 100), () {
          setState(() {
            finished = false;
          });

          print('text = $text');

          if (text == '') {
            setMasterPass().then((correct) {
              if (text == '') {
                reEncryptCloud();
              }
            });
          } else {
            print('false');
          }
        });

        timer.cancel();
      }
    });
  }

  void changeEmail() async {
    checkMasterPass(_masterPassController.text);

    Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (finished) {
        timer.cancel();
        Future.delayed(Duration(milliseconds: 100), () async {
          setState(() {
            finished = false;
          });

          print('text = $text');

          if (text == '') {
            User user = await _auth.getUser();
            try {
              user.updateEmail(_emailController.text);
              getEmail().then((emails) {
                emails.add(_emailController.text);
                saveEmail(emails);
              });
            } catch (e) {
              setState(() {
                print(e.toString());
                text = e.toString();
              });
            }

            rotateController.forward();
            setState(() {
              mailChanged = true;
            });
            FocusScope.of(context).unfocus();
            Future.delayed(Duration(milliseconds: 1000), () {
              setState(() {
                mailChanging = false;
                changeMail = false;
              });
            });

            Future.delayed(Duration(milliseconds: 2000), () {
              rotateController.reverse();
              setState(() {
                mailChanged = false;

                _masterPassController.text = '';
                _emailController.text = '';
              });
            });
          } else {
            print('false');
          }
        });
      }
    });
  }

  void checkMasterPass(String masterPass) async {
    if (masterPass != '') {
      getEmail().then((emails) async {
        int i = 0;

        while (i < emails.length) {
          String result = await _auth.signIn(emails[i], masterPass);

          print(result);

          try {
            result = result.split(']')[1].substring(1);
            print('[AUTH] result is: ' + result);

            if (result.toLowerCase().contains('the password is invalid')) {
              setState(() {
                text = incorrectPass[lang];
                color1 = Colors.red;
                finished = true;
              });
            } else {}
          } catch (e) {
            print('Success');
            setState(() {
              text = '';
              finished = true;
            });
          }

          i++;
        }
      });
    } else {
      setState(() {
        text = enterMasterPass[lang];
        color1 = Colors.red;
        finished = true;
      });
    }

    print(text);
  }

  Future<bool> setMasterPass() async {
    bool correct = false;

    if (_newMasterPassController.text != '') {
      if (_newMasterPassController.text == _repeatMasterPassController.text) {
        if (_newMasterPassController.text.length >= 8) {
          setState(() {
            text = '';

            correct = true;

            oldDecryptKey = decryptKey;
          });

          generateKeyFromPassword(_newMasterPassController.text);

          User user = await _auth.getUser();
          try {
            user.updatePassword(_newMasterPassController.text);
          } catch (e) {
            setState(() {
              print(e.toString());
              text = e.toString();
            });
          }
        } else {
          setState(() {
            text = less[lang];
            color2 = Colors.red;
          });
        }
      } else {
        setState(() {
          text = notEqual[lang];
          color2 = Colors.red;
          color3 = Colors.red;
        });
      }
    } else {
      setState(() {
        text = enterMasterPass[lang];
        color2 = Colors.red;
      });
    }

    print(text);

    return correct;
  }

  void reEncryptDB() async {
    int id = 0;
    db.getPass().then((value) {
      while (id < value.length) {
        Password password = value[id];

        print(password.title);
        print(password.pass);
        print(password.name);
        print(password.link);
        print(password.id);

        print(id);

        List<String> cell = [
          password.title,
          password.pass,
          password.name,
          password.link
        ];

        decryptCell(cell, true).then((value) {
          print('\n\ntitle: ${value[0]}');
          print('pass: ${value[1]}');
          print('username: ${value[2]}');
          print('link: ${value[3]}\n\n');

          encryptCell(value).then((encryptedCell) async {
            var db = DBHelper();

            var newPassword = Password(encryptedCell[0], encryptedCell[1],
                encryptedCell[2], encryptedCell[3], password.sortDate);
            newPassword.setPassId(password.id);

            print('\n\ntitle: ${password.title}');
            print('pass: ${password.pass}');
            print('username: ${password.name}');
            print('link: ${password.link}');
            print('id: ${password.id}\n\n');

            await db.updatePass(newPassword);
            print('updated');
          });
        });

        id++;
      }
      rotateController.forward();
      setState(() {
        passChanged = true;
      });
      FocusScope.of(context).unfocus();
      Future.delayed(Duration(milliseconds: 1000), () {
        setState(() {
          passChanging = false;
          changePass = false;
        });
      });

      Future.delayed(Duration(milliseconds: 2000), () {
        rotateController.reverse();
        setState(() {
          passChanged = false;

          _oldMasterPassController.text = '';
          _newMasterPassController.text = '';
          _repeatMasterPassController.text = '';
        });
      });
    });
  }

  void reEncryptCloud() async {
    int deviceIndex = 0;

    User user = await _auth.getUser();

    DocumentSnapshot doc = await _database.getUserData(user.uid);
    List<dynamic> userDevices = doc.get('devices');

    while (deviceIndex < userDevices.length) {
      int passwordIndex = 0;

      List<dynamic> passwords = doc.get('${userDevices[deviceIndex]}');
      List<Map<String, dynamic>> newPasswords = [];

      while (passwordIndex < passwords.length) {
        Map<String, dynamic> passFromCloud = {
          'title': passwords[passwordIndex]['title'],
          'pass': passwords[passwordIndex]['pass'],
          'name': passwords[passwordIndex]['name'],
          'link': passwords[passwordIndex]['link'],
          'sortDate': passwords[passwordIndex]['sortDate'],
        };

        print('> Cloud response:\n' + passFromCloud.toString() + '\n\n');

        List<String> cell = [
          passFromCloud['title'],
          passFromCloud['pass'],
          passFromCloud['name'],
          passFromCloud['link']
        ];

        decryptCell(cell, true).then((value) {
          print('\n\ntitle: ${value[0]}');
          print('pass: ${value[1]}');
          print('username: ${value[2]}');
          print('link: ${value[3]}\n\n');

          encryptCell(value).then((encryptedCell) async {
            Map<String, dynamic> cell = {
              'title': encryptedCell[0],
              'pass': encryptedCell[1],
              'name': encryptedCell[2],
              'link': encryptedCell[3],
              'sortDate': passFromCloud['sortDate'],
            };

            newPasswords.add(cell);
          });
        });

        passwordIndex++;
      }

      DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo device = await _deviceInfo.androidInfo;

      List<dynamic> devices = [];

      try {
        DocumentSnapshot doc = await _database.getUserData(user.uid);
        devices = doc.get('devices');
      } catch (e) {
        print(e.toString());
      }

      int i = 0;
      bool exists = false;
      while (i < devices.length) {
        if(devices[i] == device.androidId){
          setState(() {
            exists = true;
          });
        }

        i++;
      }

      if(!exists){
        devices.add(device.androidId);
      }

      print(newPasswords);
      _database.updateUserData(
          newPasswords, devices, user.uid, device.androidId);

      deviceIndex++;
    }

    reEncryptDB();
  }

  void backup() async {
    int i = 0;

    User user = await _auth.getUser();
    List<Map<String, dynamic>> passwords = [];

    db.getPass().then((value) async {
      while (i < value.length) {
        Password password = value[i];

        Map<String, dynamic> cell = {
          'title': password.title,
          'pass': password.pass,
          'name': password.name,
          'link': password.link,
          'sortDate': password.sortDate,
        };

        print(cell['sortDate']);

        passwords.add(cell);

        i++;
      }

      DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo device = await _deviceInfo.androidInfo;

      List<dynamic> devices = [];

      try {
        DocumentSnapshot doc = await _database.getUserData(user.uid);
        devices = doc.get('devices');
      } catch (e) {
        print(e.toString());
      }

      int index = 0;
      bool exists = false;
      while (index < devices.length) {
        if(devices[index] == device.androidId){
          setState(() {
            exists = true;
          });
        }

        index++;
      }

      if(!exists){
        devices.add(device.androidId);
      }

      print(passwords);
      _database.updateUserData(passwords, devices, user.uid, device.androidId);
    });
  }

  void sync() async {
    print('\n\nSyncing...\n\n');

    int deviceIndex = 0;

    User user = await _auth.getUser();

    DocumentSnapshot doc = await _database.getUserData(user.uid);
    List<dynamic> devices = doc.get('devices');
    List passwordsFromDB = [];

    db.getPass().then((value) {
      setState(() {
        passwordsFromDB = value;
      });

      while (deviceIndex < devices.length) {
        int passwordIndex = 0;

        List<dynamic> passwords = doc.get('${devices[deviceIndex]}');

        while (passwordIndex < passwords.length) {
          bool similar = false;

          Map<String, dynamic> passFromCloud = {
            'title': passwords[passwordIndex]['title'],
            'pass': passwords[passwordIndex]['pass'],
            'name': passwords[passwordIndex]['name'],
            'link': passwords[passwordIndex]['link'],
            'sortDate': passwords[passwordIndex]['sortDate'],
          };

          print('> Cloud response:\n' + passFromCloud.toString() + '\n\n');

          int index = 0;

          while (index < passwordsFromDB.length) {
            Password password = passwordsFromDB[index];

            if (passwords[passwordIndex]['sortDate'] == password.sortDate) {
              print('Passwords are similar');
              setState(() {
                similar = true;
              });
            }

            index++;
          }

          if (!similar) {
            print(
                '\n\nResult for ${passwords[passwordIndex]['title']}: will be pushed into db');

            Password password = Password(
                passwords[passwordIndex]['title'],
                passwords[passwordIndex]['pass'],
                passwords[passwordIndex]['name'],
                passwords[passwordIndex]['link'],
                passwords[passwordIndex]['sortDate']);
            db.savePass(password);
            print('[v] saved\n\n');
          } else {
            print(
                '\n\nResult for ${passwords[passwordIndex]['title']}: will NOT be pushed into db\n\n');
          }

          passwordIndex++;
        }

        deviceIndex++;
      }
    });
  }

  Future<bool> closeSettings() async {
    setState(() {
      page = 5;
    });

    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        container = true;
      });
    });

    return false;
  }

  @override
  Widget build(BuildContext context) {
    Size size1 = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: closeSettings,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOut,
            height: container ? size.height * 0.1 : 0,
          ),
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
                  settingsTitle[lang],
                  style: Theme.of(context).primaryTextTheme.headline1.copyWith(
                      fontSize: ScreenUtil().setSp(size.width * 0.11)),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    page = 5;
                  });

                  Future.delayed(Duration(milliseconds: 200), () {
                    setState(() {
                      container = true;
                    });
                  });
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
          Container(
            height: size1.height * 0.868,
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                SizedBox(
                  height: size.height * 0.05,
                ),
                Text(
                  appearance[lang],
                  style: Theme.of(context).primaryTextTheme.headline1.copyWith(
                      fontSize: ScreenUtil().setSp(size.width * 0.08),
                      color: color2Animation.value),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: themeSelect ? size.height * 0.62 : size.height * 0.12,
                  width: size1.width,
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        pressed1 = true;

                        themeSelect = !themeSelect;
                      });

                      if (selection) {
                        setState(() {
                          selection = false;
                        });
                      } else {
                        Future.delayed(Duration(milliseconds: 300), () {
                          setState(() {
                            selection = true;
                          });
                        });
                      }

                      Future.delayed(Duration(milliseconds: 300), () {
                        setState(() {
                          pressed1 = false;
                        });
                      });
                    },
                    onTapDown: (details) {
                      setState(() {
                        pressed1 = true;
                      });
                    },
                    onLongPress: () {
                      setState(() {
                        pressed1 = true;
                      });
                    },
                    onLongPressEnd: (details) {
                      setState(() {
                        pressed1 = true;

                        themeSelect = !themeSelect;
                      });

                      if (selection) {
                        setState(() {
                          selection = false;
                        });
                      } else {
                        Future.delayed(Duration(milliseconds: 300), () {
                          setState(() {
                            selection = true;
                          });
                        });
                      }

                      Future.delayed(Duration(milliseconds: 300), () {
                        setState(() {
                          pressed1 = false;
                        });
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      height: themeSelect
                          ? size.height * 0.6
                          : (pressed1
                              ? size.height * 0.1 - size.width * 0.02
                              : size.height * 0.1),
                      width: pressed1
                          ? size1.width * 0.92 - size.width * 0.02
                          : size1.width * 0.92,
                      child: AnimatedContainer(
                        padding: EdgeInsets.only(
                            left: size.width * 0.04, right: size.width * 0.04),
                        alignment: Alignment.topCenter,
                        height: size.height * 0.1,
                        width: size1.width,
                        duration: Duration(milliseconds: 700),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(size.height * 0.02),
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [
                              bottomLeftColor[theme],
                              topRightColor[theme]
                            ],
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              alignment: Alignment.centerLeft,
                              height: pressed1
                                  ? size.height * 0.1 - size.width * 0.02
                                  : size.height * 0.1,
                              width: size1.width * 0.92,
                              child: Text(
                                themeButton[lang],
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline1
                                    .copyWith(
                                        fontSize: ScreenUtil()
                                            .setSp(size.width * 0.07),
                                        color: colorAnimation.value),
                              ),
                            ),
                            AnimatedContainer(
                              alignment: Alignment.center,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              height: themeSelect ? size.height * 0.45 : 0,
                              width: size.height * 0.45,
                              child: AnimatedOpacity(
                                duration: Duration(milliseconds: 300),
                                opacity: selection ? 1 : 0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                      width: (t == 5 || t == 4)
                                          ? size.width * 0.3
                                          : size.width * 0.2,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                              duration:
                                                  Duration(milliseconds: 300),
                                              curve: Curves.easeInOut,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular((t ==
                                                            5)
                                                        ? size.width * 0.3 / 2
                                                        : size.width * 0.2 / 2),
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 3),
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
                                              duration:
                                                  Duration(milliseconds: 300),
                                              curve: Curves.easeInOut,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular((t ==
                                                            4)
                                                        ? size.width * 0.3 / 2
                                                        : size.width * 0.2 / 2),
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 3),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                              duration:
                                                  Duration(milliseconds: 300),
                                              curve: Curves.easeInOut,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular((t ==
                                                            0)
                                                        ? size.width * 0.3 / 2
                                                        : size.width * 0.2 / 2),
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 3),
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
                                              duration:
                                                  Duration(milliseconds: 300),
                                              curve: Curves.easeInOut,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular((t ==
                                                            3)
                                                        ? size.width * 0.3 / 2
                                                        : size.width * 0.2 / 2),
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 3),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                              duration:
                                                  Duration(milliseconds: 300),
                                              curve: Curves.easeInOut,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular((t ==
                                                            1)
                                                        ? size.width * 0.3 / 2
                                                        : size.width * 0.2 / 2),
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 3),
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
                                              duration:
                                                  Duration(milliseconds: 300),
                                              curve: Curves.easeInOut,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular((t ==
                                                            2)
                                                        ? size.width * 0.3 / 2
                                                        : size.width * 0.2 / 2),
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 3),
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: size.height * 0.12,
                  width: size1.width,
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        pressed2 = true;
                      });

                      if (dark == 0) {
                        setState(() {
                          dark = 1;
                        });
                        colorController.forward();
                        color2Controller.forward();
                        saveDarkThemeState(dark);
                      } else {
                        setState(() {
                          dark = 0;
                        });
                        colorController.reverse();
                        color2Controller.reverse();
                        saveDarkThemeState(dark);
                      }

                      Future.delayed(Duration(milliseconds: 200), () {
                        setState(() {
                          pressed2 = false;
                        });
                      });
                    },
                    onTapDown: (details) {
                      setState(() {
                        pressed2 = true;
                      });
                    },
                    onLongPress: () {
                      setState(() {
                        pressed2 = true;
                      });
                    },
                    onLongPressEnd: (details) {
                      setState(() {
                        pressed2 = false;
                      });

                      if (dark == 0) {
                        setState(() {
                          dark = 1;
                        });
                        colorController.forward();
                        color2Controller.forward();
                        saveDarkThemeState(dark);
                      } else {
                        setState(() {
                          dark = 0;
                        });
                        colorController.reverse();
                        color2Controller.reverse();
                        saveDarkThemeState(dark);
                      }
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 100),
                      height: pressed2
                          ? size.height * 0.1 - size.width * 0.02
                          : size.height * 0.1,
                      width: pressed2
                          ? size1.width * 0.92 - size.width * 0.02
                          : size1.width * 0.92,
                      child: AnimatedContainer(
                        padding: EdgeInsets.only(
                            left: size.width * 0.04, right: size.width * 0.04),
                        alignment: Alignment.centerLeft,
                        height: size.height * 0.1,
                        width: size1.width,
                        duration: Duration(milliseconds: 700),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(size.height * 0.02),
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [
                              (dark == 1)
                                  ? Color.fromRGBO(200, 200, 200, 1)
                                  : Color.fromRGBO(120, 120, 120, 1),
                              (dark == 1)
                                  ? Color.fromRGBO(120, 120, 120, 1)
                                  : Color.fromRGBO(40, 40, 40, 1)
                            ],
                          ),
                        ),
                        child: Text(
                          (dark == 1)
                              ? setLightTheme[lang]
                              : setDarkTheme[lang],
                          style: Theme.of(context)
                              .primaryTextTheme
                              .headline1
                              .copyWith(
                                  fontSize:
                                      ScreenUtil().setSp(size.width * 0.07),
                                  color: colorAnimation.value),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Text(
                  language[lang],
                  style: Theme.of(context).primaryTextTheme.headline1.copyWith(
                      fontSize: ScreenUtil().setSp(size.width * 0.08),
                      color: color2Animation.value),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height:
                      languageSelect ? size.height * 0.47 : size.height * 0.12,
                  width: size1.width,
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        pressed3 = true;

                        languageSelect = !languageSelect;
                      });

                      if (langSelection) {
                        setState(() {
                          langSelection = false;
                        });
                      } else {
                        Future.delayed(Duration(milliseconds: 300), () {
                          setState(() {
                            langSelection = true;
                          });
                        });
                      }

                      Future.delayed(Duration(milliseconds: 300), () {
                        setState(() {
                          pressed3 = false;
                        });
                      });
                    },
                    onTapDown: (details) {
                      setState(() {
                        pressed3 = true;
                      });
                    },
                    onLongPress: () {
                      setState(() {
                        pressed3 = true;
                      });
                    },
                    onLongPressEnd: (details) {
                      setState(() {
                        pressed3 = true;

                        languageSelect = !languageSelect;
                      });

                      if (langSelection) {
                        setState(() {
                          langSelection = false;
                        });
                      } else {
                        Future.delayed(Duration(milliseconds: 300), () {
                          setState(() {
                            langSelection = true;
                          });
                        });
                      }

                      Future.delayed(Duration(milliseconds: 300), () {
                        setState(() {
                          pressed3 = false;
                        });
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      height: languageSelect
                          ? size.height * 0.45
                          : (pressed3
                              ? size.height * 0.1 - size.width * 0.02
                              : size.height * 0.1),
                      width: pressed3
                          ? size1.width * 0.92 - size.width * 0.02
                          : size1.width * 0.92,
                      child: AnimatedContainer(
                        padding: EdgeInsets.only(
                            left: size.width * 0.04, right: size.width * 0.04),
                        alignment: Alignment.topCenter,
                        height: size.height * 0.1,
                        width: size1.width,
                        duration: Duration(milliseconds: 700),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(size.height * 0.02),
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [
                              rus
                                  ? Colors.lightBlueAccent
                                  : Colors.redAccent.shade100,
                              rus ? Colors.blueAccent : Colors.redAccent
                            ],
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              alignment: Alignment.centerLeft,
                              height: pressed3
                                  ? size.height * 0.1 - size.width * 0.02
                                  : size.height * 0.1,
                              width: size1.width * 0.92,
                              child: Text(
                                language[lang],
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline1
                                    .copyWith(
                                        fontSize: ScreenUtil()
                                            .setSp(size.width * 0.07),
                                        color: colorAnimation.value),
                              ),
                            ),
                            AnimatedContainer(
                              alignment: Alignment.center,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              height: languageSelect ? size.height * 0.3 : 0,
                              child: AnimatedOpacity(
                                duration: Duration(milliseconds: 500),
                                opacity: langSelection ? 1 : 0,
                                child: Container(
                                  height: size.height * 0.28,
                                  width: size1.width,
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          if (langSelection) {
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
                                              duration:
                                                  Duration(milliseconds: 300),
                                              curve: Curves.easeInOut,
                                              height: size.height * 0.09,
                                              width: !rus
                                                  ? size1.width * 0.8
                                                  : size.height * 0.085,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        size.height * 0.1 / 2),
                                                color: Colors.white
                                                    .withOpacity(0.3),
                                              ),
                                            ),
                                            AnimatedContainer(
                                              duration:
                                                  Duration(milliseconds: 300),
                                              height: size.height * 0.09,
                                              width: size1.width * 0.8,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: !rus ? 4 : 2),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        size.height * 0.1 / 2),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    height: size.height * 0.09,
                                                    width: size.height * 0.085,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    size.height *
                                                                        0.1 /
                                                                        2),
                                                        color: Colors.white,
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                              'assets/images/english.png'),
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
                                                              fontSize: ScreenUtil()
                                                                  .setSp(
                                                                      size.width *
                                                                          0.095),
                                                              fontWeight: !rus
                                                                  ? FontWeight
                                                                      .w300
                                                                  : FontWeight
                                                                      .w200))
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
                                          if (langSelection) {
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
                                              duration:
                                                  Duration(milliseconds: 300),
                                              curve: Curves.easeInOut,
                                              height: size.height * 0.09,
                                              width: rus
                                                  ? size1.width * 0.8
                                                  : size.height * 0.085,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        size.height * 0.1 / 2),
                                                color: Colors.white
                                                    .withOpacity(0.3),
                                              ),
                                            ),
                                            AnimatedContainer(
                                              duration:
                                                  Duration(milliseconds: 300),
                                              height: size.height * 0.09,
                                              width: size1.width * 0.8,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: rus ? 4 : 2),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        size.height * 0.1 / 2),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    height: size.height * 0.09,
                                                    width: size.height * 0.085,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    size.height *
                                                                        0.1 /
                                                                        2),
                                                        color: Colors.white,
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                              'assets/images/russian.png'),
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
                                                              fontSize: ScreenUtil()
                                                                  .setSp(
                                                                      size.width *
                                                                          0.095),
                                                              fontWeight: rus
                                                                  ? FontWeight
                                                                      .w300
                                                                  : FontWeight
                                                                      .w200))
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Text(
                  accountSettings[lang],
                  style: Theme.of(context).primaryTextTheme.headline1.copyWith(
                      fontSize: ScreenUtil().setSp(size.width * 0.08),
                      color: color2Animation.value),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: changeMail ? size.height * 0.72 : size.height * 0.12,
                  width: size1.width,
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        pressed4 = true;

                        changeMail = !changeMail;

                        changePass = false;
                        passChanging = false;

                        active1 = false;
                        width1 = size.width * 0.75;
                        color1 = Colors.white;
                        active2 = false;
                        width2 = size.width * 0.75;
                        color2 = Colors.white;
                        active3 = false;
                        width3 = size.width * 0.75;
                        color3 = Colors.white;

                        text = '';
                      });

                      if (mailChanging) {
                        setState(() {
                          mailChanging = false;

                          active1 = false;
                          width1 = size.width * 0.75;
                          color1 = Colors.white;
                          active2 = false;
                          width2 = size.width * 0.75;
                          color2 = Colors.white;
                          active3 = false;
                          width3 = size.width * 0.75;
                          color3 = Colors.white;

                          text = '';
                        });
                      } else {
                        Future.delayed(Duration(milliseconds: 300), () {
                          setState(() {
                            mailChanging = true;
                          });
                        });
                      }

                      Future.delayed(Duration(milliseconds: 300), () {
                        setState(() {
                          pressed4 = false;
                        });
                      });
                    },
                    onTapDown: (details) {
                      if (!mailChanging) {
                        setState(() {
                          pressed4 = true;
                        });
                      }
                    },
                    onLongPress: () {
                      setState(() {
                        pressed4 = true;
                      });
                    },
                    onLongPressEnd: (details) {
                      setState(() {
                        pressed4 = true;

                        changeMail = !changeMail;

                        changePass = false;
                        passChanging = false;

                        active1 = false;
                        width1 = size.width * 0.75;
                        color1 = Colors.white;
                        active2 = false;
                        width2 = size.width * 0.75;
                        color2 = Colors.white;
                        active3 = false;
                        width3 = size.width * 0.75;
                        color3 = Colors.white;

                        text = '';
                      });

                      if (mailChanging) {
                        setState(() {
                          mailChanging = false;

                          active1 = false;
                          width1 = size.width * 0.75;
                          color1 = Colors.white;
                          active2 = false;
                          width2 = size.width * 0.75;
                          color2 = Colors.white;
                          active3 = false;
                          width3 = size.width * 0.75;
                          color3 = Colors.white;

                          text = '';
                        });
                      } else {
                        Future.delayed(Duration(milliseconds: 300), () {
                          setState(() {
                            mailChanging = true;
                          });
                        });
                      }

                      Future.delayed(Duration(milliseconds: 300), () {
                        setState(() {
                          pressed4 = false;
                        });
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      height: changeMail
                          ? size.height * 0.7
                          : (pressed4
                              ? size.height * 0.1 - size.width * 0.02
                              : size.height * 0.1),
                      width: pressed4
                          ? size1.width * 0.92 - size.width * 0.02
                          : size1.width * 0.92,
                      child: AnimatedContainer(
                        padding: EdgeInsets.only(
                            left: size.width * 0.04, right: size.width * 0.04),
                        alignment: Alignment.topCenter,
                        height: size.height * 0.1,
                        width: size1.width,
                        duration: Duration(milliseconds: 700),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(size.height * 0.02),
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [bottomLeftColor[5], topRightColor[5]],
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              alignment: Alignment.centerLeft,
                              height: pressed4
                                  ? size.height * 0.1 - size.width * 0.02
                                  : size.height * 0.1,
                              width: size1.width * 0.92,
                              child: Text(
                                changeEmailButton[lang],
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline1
                                    .copyWith(
                                        fontSize: ScreenUtil()
                                            .setSp(size.width * 0.07),
                                        color: colorAnimation.value),
                              ),
                            ),
                            AnimatedContainer(
                              alignment: Alignment.center,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              height: changeMail ? size.height * 0.6 : 0,
                              child: AnimatedOpacity(
                                duration: Duration(milliseconds: 500),
                                opacity: mailChanging ? 1 : 0,
                                child: Container(
                                  height: size.height * 0.55,
                                  width: size1.width,
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: <Widget>[
                                      AnimatedContainer(
                                        padding: EdgeInsets.only(
                                            left: size.width * 0.05,
                                            right: size.width * 0.05),
                                        alignment: Alignment.centerLeft,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                        height: size.height * 0.09,
                                        width: width1,
                                        decoration: BoxDecoration(
                                            color: color1.withOpacity(
                                                active1 ? 0.3 : 0.1),
                                            borderRadius: BorderRadius.circular(
                                                size.height * 0.1 / 2),
                                            border: Border.all(
                                                color: color1, width: 3)),
                                        child: TextField(
                                          focusNode: _masterPassFocus,
                                          controller: _masterPassController,
                                          autocorrect: false,
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          textInputAction: TextInputAction.next,
                                          obscureText: obs1,
                                          enabled: true,
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .headline2
                                              .copyWith(
                                                  fontSize: ScreenUtil().setSp(
                                                      size.width * 0.057)),
                                          onTap: () {
                                            setState(() {
                                              active1 = true;
                                              width1 = size.width * 0.85;
                                              active2 = false;
                                              width2 = size.width * 0.75;
                                              active3 = false;
                                              width3 = size.width * 0.75;
                                            });
                                          },
                                          onChanged: (value) {
                                            color1 = Colors.white;
                                            color2 = Colors.white;
                                            color3 = Colors.white;

                                            text = '';
                                          },
                                          onSubmitted: (value) {
                                            fieldFocusChange(context,
                                                _masterPassFocus, _emailFocus);

                                            setState(() {
                                              active1 = false;
                                              width1 = size.width * 0.75;
                                              active2 = true;
                                              width2 = size.width * 0.85;
                                            });
                                          },
                                          cursorColor: Colors.white,
                                          decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                obs1
                                                    ? CustomIcons.eye_off
                                                    : CustomIcons.eye,
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
                                                    fontSize: ScreenUtil()
                                                        .setSp(
                                                            size.width * 0.057),
                                                    color: Colors.white
                                                        .withOpacity(0.6)),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.02,
                                      ),
                                      AnimatedContainer(
                                        padding: EdgeInsets.only(
                                            left: size.width * 0.05,
                                            right: size.width * 0.05),
                                        alignment: Alignment.centerLeft,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                        height: size.height * 0.09,
                                        width: width2,
                                        decoration: BoxDecoration(
                                            color: color2.withOpacity(
                                                active2 ? 0.3 : 0.1),
                                            borderRadius: BorderRadius.circular(
                                                size.height * 0.1 / 2),
                                            border: Border.all(
                                                color: color2, width: 3)),
                                        child: TextField(
                                          focusNode: _emailFocus,
                                          controller: _emailController,
                                          autocorrect: false,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          textInputAction: TextInputAction.done,
                                          enabled: true,
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .headline2
                                              .copyWith(
                                                  fontSize: ScreenUtil().setSp(
                                                      size.width * 0.057)),
                                          onTap: () {
                                            setState(() {
                                              active1 = false;
                                              width1 = size.width * 0.75;
                                              active2 = true;
                                              width2 = size.width * 0.85;
                                              active3 = false;
                                              width3 = size.width * 0.75;
                                            });
                                          },
                                          onChanged: (value) {
                                            color1 = Colors.white;
                                            color2 = Colors.white;
                                            color3 = Colors.white;

                                            text = '';
                                          },
                                          onSubmitted: (value) {
                                            setState(() {
                                              active2 = false;
                                              width2 = size.width * 0.75;
                                              active3 = true;
                                              width3 = size.width * 0.85;
                                            });
                                          },
                                          cursorColor: Colors.white,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: newEmail[lang],
                                            hintStyle: Theme.of(context)
                                                .primaryTextTheme
                                                .headline2
                                                .copyWith(
                                                    fontSize: ScreenUtil()
                                                        .setSp(
                                                            size.width * 0.057),
                                                    color: Colors.white
                                                        .withOpacity(0.6)),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.03,
                                      ),
                                      AnimatedContainer(
                                        duration: Duration(milliseconds: 200),
                                        curve: Curves.easeInOut,
                                        width: size.width,
                                        height: (text == '')
                                            ? size.height * 0.058
                                            : size.height * 0.108,
                                        alignment: Alignment.center,
                                        child: AnimatedOpacity(
                                          duration: Duration(milliseconds: 200),
                                          opacity: (text == '') ? 0 : 1,
                                          child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                size.width * 0.04,
                                                size.height * 0.008,
                                                size.width * 0.04,
                                                size.height * 0.008),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        size.height)),
                                            child: Text(
                                              text,
                                              style: Theme.of(context)
                                                  .primaryTextTheme
                                                  .headline2
                                                  .copyWith(
                                                    fontSize: ScreenUtil()
                                                        .setSp(
                                                            size.width * 0.047),
                                                    color: Colors.red,
                                                  ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.02,
                                      ),
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          AnimatedContainer(
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.easeInOut,
                                            height: size.width * 0.25,
                                            width: size.width * 0.25,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.bottomLeft,
                                                end: Alignment.topRight,
                                                colors: [
                                                  Colors.white.withOpacity(0.5),
                                                  Colors.white.withOpacity(0.5)
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      size.width * 0.25 / 2),
                                            ),
                                          ),
                                          AnimatedContainer(
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.easeInOut,
                                            height: size.width * 0.2,
                                            width: size.width * 0.2,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.bottomLeft,
                                                end: Alignment.topRight,
                                                colors: [
                                                  Colors.white,
                                                  Colors.white
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      size.width * 0.2 / 2),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              changeEmail();
                                            },
                                            child: Container(
                                              height: size.width * 0.25,
                                              width: size.width * 0.25,
                                              color: Colors.transparent,
                                              alignment: Alignment.center,
                                              child: RotationTransition(
                                                turns: Tween(
                                                        begin: 0.0, end: 1.0)
                                                    .animate(rotateController),
                                                child: Container(
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: <Widget>[
                                                      AnimatedOpacity(
                                                        duration: Duration(
                                                            milliseconds: 300),
                                                        opacity:
                                                            mailChanged ? 0 : 1,
                                                        child: Icon(
                                                          CustomIcons
                                                              .right_open,
                                                          size:
                                                              size.width * 0.1,
                                                          color: buttonColor[5],
                                                        ),
                                                      ),
                                                      AnimatedOpacity(
                                                        duration: Duration(
                                                            milliseconds: 300),
                                                        opacity:
                                                            mailChanged ? 1 : 0,
                                                        child: Icon(
                                                          Icons.done,
                                                          size:
                                                              size.width * 0.1,
                                                          color: buttonColor[5],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
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
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: changePass ? size.height * 0.82 : size.height * 0.12,
                  width: size1.width,
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        pressed5 = true;

                        changePass = !changePass;

                        changeMail = false;
                        mailChanging = false;

                        active1 = false;
                        width1 = size.width * 0.75;
                        color1 = Colors.white;
                        active2 = false;
                        width2 = size.width * 0.75;
                        color2 = Colors.white;
                        active3 = false;
                        width3 = size.width * 0.75;
                        color3 = Colors.white;

                        text = '';
                      });

                      if (passChanging) {
                        setState(() {
                          passChanging = false;

                          active1 = false;
                          width1 = size.width * 0.75;
                          color1 = Colors.white;
                          active2 = false;
                          width2 = size.width * 0.75;
                          color2 = Colors.white;
                          active3 = false;
                          width3 = size.width * 0.75;
                          color3 = Colors.white;

                          text = '';
                        });
                      } else {
                        Future.delayed(Duration(milliseconds: 300), () {
                          setState(() {
                            passChanging = true;
                          });
                        });
                      }

                      Future.delayed(Duration(milliseconds: 300), () {
                        setState(() {
                          pressed5 = false;
                        });
                      });
                    },
                    onTapDown: (details) {
                      if (!passChanging) {
                        setState(() {
                          pressed5 = true;
                        });
                      }
                    },
                    onLongPress: () {
                      setState(() {
                        pressed5 = true;
                      });
                    },
                    onLongPressEnd: (details) {
                      setState(() {
                        pressed5 = true;

                        changePass = !changePass;

                        changeMail = false;
                        mailChanging = false;

                        active1 = false;
                        width1 = size.width * 0.75;
                        color1 = Colors.white;
                        active2 = false;
                        width2 = size.width * 0.75;
                        color2 = Colors.white;
                        active3 = false;
                        width3 = size.width * 0.75;
                        color3 = Colors.white;

                        text = '';
                      });

                      if (passChanging) {
                        setState(() {
                          passChanging = false;

                          active1 = false;
                          width1 = size.width * 0.75;
                          color1 = Colors.white;
                          active2 = false;
                          width2 = size.width * 0.75;
                          color2 = Colors.white;
                          active3 = false;
                          width3 = size.width * 0.75;
                          color3 = Colors.white;

                          text = '';
                        });
                      } else {
                        Future.delayed(Duration(milliseconds: 300), () {
                          setState(() {
                            passChanging = true;
                          });
                        });
                      }

                      Future.delayed(Duration(milliseconds: 300), () {
                        setState(() {
                          pressed5 = false;
                        });
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      height: changePass
                          ? size.height * 0.8
                          : (pressed5
                              ? size.height * 0.1 - size.width * 0.02
                              : size.height * 0.1),
                      width: pressed5
                          ? size1.width * 0.92 - size.width * 0.02
                          : size1.width * 0.92,
                      child: AnimatedContainer(
                        padding: EdgeInsets.only(
                            left: size.width * 0.04, right: size.width * 0.04),
                        alignment: Alignment.topCenter,
                        height: size.height * 0.1,
                        width: size1.width,
                        duration: Duration(milliseconds: 700),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(size.height * 0.02),
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [bottomLeftColor[5], topRightColor[5]],
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              alignment: Alignment.centerLeft,
                              height: pressed5
                                  ? size.height * 0.1 - size.width * 0.02
                                  : size.height * 0.1,
                              width: size1.width * 0.92,
                              child: Text(
                                changeMasterPassButton[lang],
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline1
                                    .copyWith(
                                        fontSize: ScreenUtil()
                                            .setSp(size.width * 0.07),
                                        color: colorAnimation.value),
                              ),
                            ),
                            AnimatedContainer(
                              alignment: Alignment.center,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              height: changePass ? size.height * 0.7 : 0,
                              child: AnimatedOpacity(
                                duration: Duration(milliseconds: 500),
                                opacity: passChanging ? 1 : 0,
                                child: Container(
                                  height: size.height * 0.65,
                                  width: size1.width,
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: <Widget>[
                                      AnimatedContainer(
                                        padding: EdgeInsets.only(
                                            left: size.width * 0.05,
                                            right: size.width * 0.05),
                                        alignment: Alignment.centerLeft,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                        height: size.height * 0.09,
                                        width: width1,
                                        decoration: BoxDecoration(
                                            color: color1.withOpacity(
                                                active1 ? 0.3 : 0.1),
                                            borderRadius: BorderRadius.circular(
                                                size.height * 0.1 / 2),
                                            border: Border.all(
                                                color: color1, width: 3)),
                                        child: TextField(
                                          focusNode: _firstFocus,
                                          controller: _oldMasterPassController,
                                          autocorrect: false,
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          textInputAction: TextInputAction.next,
                                          obscureText: obs1,
                                          enabled: true,
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .headline2
                                              .copyWith(
                                                  fontSize: ScreenUtil().setSp(
                                                      size.width * 0.057)),
                                          onTap: () {
                                            setState(() {
                                              active1 = true;
                                              width1 = size.width * 0.85;
                                              active2 = false;
                                              width2 = size.width * 0.75;
                                              active3 = false;
                                              width3 = size.width * 0.75;
                                            });
                                          },
                                          onChanged: (value) {
                                            color1 = Colors.white;
                                            color2 = Colors.white;
                                            color3 = Colors.white;

                                            text = '';
                                          },
                                          onSubmitted: (value) {
                                            fieldFocusChange(context,
                                                _firstFocus, _secondFocus);

                                            setState(() {
                                              active1 = false;
                                              width1 = size.width * 0.75;
                                              active2 = true;
                                              width2 = size.width * 0.85;
                                            });
                                          },
                                          cursorColor: Colors.white,
                                          decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                obs1
                                                    ? CustomIcons.eye_off
                                                    : CustomIcons.eye,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  obs1 = !obs1;
                                                });
                                              },
                                            ),
                                            border: InputBorder.none,
                                            hintText: oldMasterPassField[lang],
                                            hintStyle: Theme.of(context)
                                                .primaryTextTheme
                                                .headline2
                                                .copyWith(
                                                    fontSize: ScreenUtil()
                                                        .setSp(
                                                            size.width * 0.057),
                                                    color: Colors.white
                                                        .withOpacity(0.6)),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.02,
                                      ),
                                      AnimatedContainer(
                                        padding: EdgeInsets.only(
                                            left: size.width * 0.05,
                                            right: size.width * 0.05),
                                        alignment: Alignment.centerLeft,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                        height: size.height * 0.09,
                                        width: width2,
                                        decoration: BoxDecoration(
                                            color: color2.withOpacity(
                                                active2 ? 0.3 : 0.1),
                                            borderRadius: BorderRadius.circular(
                                                size.height * 0.1 / 2),
                                            border: Border.all(
                                                color: color2, width: 3)),
                                        child: TextField(
                                          focusNode: _secondFocus,
                                          controller: _newMasterPassController,
                                          autocorrect: false,
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          textInputAction: TextInputAction.next,
                                          obscureText: obs2,
                                          enabled: true,
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .headline2
                                              .copyWith(
                                                  fontSize: ScreenUtil().setSp(
                                                      size.width * 0.057)),
                                          onTap: () {
                                            setState(() {
                                              active1 = false;
                                              width1 = size.width * 0.75;
                                              active2 = true;
                                              width2 = size.width * 0.85;
                                              active3 = false;
                                              width3 = size.width * 0.75;
                                            });
                                          },
                                          onChanged: (value) {
                                            color1 = Colors.white;
                                            color2 = Colors.white;
                                            color3 = Colors.white;

                                            text = '';
                                          },
                                          onSubmitted: (value) {
                                            fieldFocusChange(context,
                                                _secondFocus, _thirdFocus);
                                            setState(() {
                                              active2 = false;
                                              width2 = size.width * 0.75;
                                              active3 = true;
                                              width3 = size.width * 0.85;
                                            });
                                          },
                                          cursorColor: Colors.white,
                                          decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                obs2
                                                    ? CustomIcons.eye_off
                                                    : CustomIcons.eye,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  obs2 = !obs2;
                                                });
                                              },
                                            ),
                                            border: InputBorder.none,
                                            hintText: newMasterPassField[lang],
                                            hintStyle: Theme.of(context)
                                                .primaryTextTheme
                                                .headline2
                                                .copyWith(
                                                    fontSize: ScreenUtil()
                                                        .setSp(
                                                            size.width * 0.057),
                                                    color: Colors.white
                                                        .withOpacity(0.6)),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.02,
                                      ),
                                      AnimatedContainer(
                                        padding: EdgeInsets.only(
                                            left: size.width * 0.05,
                                            right: size.width * 0.05),
                                        alignment: Alignment.centerLeft,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                        height: size.height * 0.09,
                                        width: width3,
                                        decoration: BoxDecoration(
                                            color: color3.withOpacity(
                                                active3 ? 0.3 : 0.1),
                                            borderRadius: BorderRadius.circular(
                                                size.height * 0.1 / 2),
                                            border: Border.all(
                                                color: color3, width: 3)),
                                        child: TextField(
                                          focusNode: _thirdFocus,
                                          controller:
                                              _repeatMasterPassController,
                                          autocorrect: false,
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          textInputAction: TextInputAction.done,
                                          obscureText: obs3,
                                          enabled: true,
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .headline2
                                              .copyWith(
                                                  fontSize: ScreenUtil().setSp(
                                                      size.width * 0.057)),
                                          onTap: () {
                                            setState(() {
                                              active1 = false;
                                              width1 = size.width * 0.75;
                                              active2 = false;
                                              width2 = size.width * 0.75;
                                              active3 = true;
                                              width3 = size.width * 0.85;
                                            });
                                          },
                                          onChanged: (value) {
                                            color1 = Colors.white;
                                            color2 = Colors.white;
                                            color3 = Colors.white;

                                            text = '';
                                          },
                                          onSubmitted: (value) {
                                            setState(() {
                                              active3 = false;
                                              width3 = size.width * 0.75;
                                            });
                                          },
                                          cursorColor: Colors.white,
                                          decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                obs3
                                                    ? CustomIcons.eye_off
                                                    : CustomIcons.eye,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  obs3 = !obs3;
                                                });
                                              },
                                            ),
                                            border: InputBorder.none,
                                            hintText: repeatField[lang],
                                            hintStyle: Theme.of(context)
                                                .primaryTextTheme
                                                .headline2
                                                .copyWith(
                                                    fontSize: ScreenUtil()
                                                        .setSp(
                                                            size.width * 0.057),
                                                    color: Colors.white
                                                        .withOpacity(0.6)),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.03,
                                      ),
                                      AnimatedContainer(
                                        duration: Duration(milliseconds: 200),
                                        curve: Curves.easeInOut,
                                        width: size.width,
                                        height: (text == '')
                                            ? size.height * 0.058
                                            : size.height * 0.108,
                                        alignment: Alignment.center,
                                        child: AnimatedOpacity(
                                          duration: Duration(milliseconds: 200),
                                          opacity: (text == '') ? 0 : 1,
                                          child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                size.width * 0.04,
                                                size.height * 0.008,
                                                size.width * 0.04,
                                                size.height * 0.008),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        size.height)),
                                            child: Text(
                                              text,
                                              style: Theme.of(context)
                                                  .primaryTextTheme
                                                  .headline2
                                                  .copyWith(
                                                    fontSize: ScreenUtil()
                                                        .setSp(
                                                            size.width * 0.047),
                                                    color: Colors.red,
                                                  ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.02,
                                      ),
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          AnimatedContainer(
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.easeInOut,
                                            height: size.width * 0.25,
                                            width: size.width * 0.25,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.bottomLeft,
                                                end: Alignment.topRight,
                                                colors: [
                                                  Colors.white.withOpacity(0.5),
                                                  Colors.white.withOpacity(0.5)
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      size.width * 0.25 / 2),
                                            ),
                                          ),
                                          AnimatedContainer(
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.easeInOut,
                                            height: size.width * 0.2,
                                            width: size.width * 0.2,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.bottomLeft,
                                                end: Alignment.topRight,
                                                colors: [
                                                  Colors.white,
                                                  Colors.white
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      size.width * 0.2 / 2),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              changeMasterPass();
                                            },
                                            child: Container(
                                              height: size.width * 0.25,
                                              width: size.width * 0.25,
                                              color: Colors.transparent,
                                              alignment: Alignment.center,
                                              child: RotationTransition(
                                                turns: Tween(
                                                        begin: 0.0, end: 1.0)
                                                    .animate(rotateController),
                                                child: Container(
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: <Widget>[
                                                      AnimatedOpacity(
                                                        duration: Duration(
                                                            milliseconds: 300),
                                                        opacity:
                                                            passChanged ? 0 : 1,
                                                        child: Icon(
                                                          CustomIcons
                                                              .right_open,
                                                          size:
                                                              size.width * 0.1,
                                                          color: buttonColor[5],
                                                        ),
                                                      ),
                                                      AnimatedOpacity(
                                                        duration: Duration(
                                                            milliseconds: 300),
                                                        opacity:
                                                            passChanged ? 1 : 0,
                                                        child: Icon(
                                                          Icons.done,
                                                          size:
                                                              size.width * 0.1,
                                                          color: buttonColor[5],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
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
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Text(
                  cloud[lang],
                  style: Theme.of(context).primaryTextTheme.headline1.copyWith(
                      fontSize: ScreenUtil().setSp(size.width * 0.08),
                      color: color2Animation.value),
                ),
                Container(
                  height: size.height * 0.12,
                  width: size1.width,
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () async {
                      if (loggedIn) {
                        setState(() {
                          pressed6 = true;
                        });

                        backup();

                        Future.delayed(Duration(milliseconds: 200), () {
                          setState(() {
                            pressed6 = false;
                          });
                        });
                      }
                    },
                    onTapDown: (details) {
                      if (loggedIn) {
                        setState(() {
                          pressed6 = true;
                        });
                      }
                    },
                    onLongPress: () {
                      if (loggedIn) {
                        setState(() {
                          pressed6 = true;
                        });
                      }
                    },
                    onLongPressEnd: (details) {
                      if (loggedIn) {
                        setState(() {
                          pressed6 = false;
                        });

                        backup();
                      }
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 100),
                      height: pressed6
                          ? size.height * 0.1 - size.width * 0.02
                          : size.height * 0.1,
                      width: pressed6
                          ? size1.width * 0.92 - size.width * 0.02
                          : size1.width * 0.92,
                      child: AnimatedContainer(
                        padding: EdgeInsets.only(
                            left: size.width * 0.04, right: size.width * 0.04),
                        alignment: Alignment.centerLeft,
                        height: size.height * 0.1,
                        width: size1.width,
                        duration: Duration(milliseconds: 700),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(size.height * 0.02),
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [
                              loggedIn
                                  ? bottomLeftColor[1]
                                  : Color.fromRGBO(200, 200, 200, 1),
                              loggedIn
                                  ? topRightColor[1]
                                  : Color.fromRGBO(160, 160, 160, 1)
                            ],
                          ),
                        ),
                        child: Text(
                          backupButton[lang],
                          style: Theme.of(context)
                              .primaryTextTheme
                              .headline1
                              .copyWith(
                                  fontSize:
                                      ScreenUtil().setSp(size.width * 0.07),
                                  color: colorAnimation.value),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: size.height * 0.12,
                  width: size1.width,
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () async {
                      if (loggedIn) {
                        setState(() {
                          pressed7 = true;
                        });

                        sync();

                        Future.delayed(Duration(milliseconds: 200), () {
                          setState(() {
                            pressed7 = false;
                          });
                        });
                      }
                    },
                    onTapDown: (details) {
                      if (loggedIn) {
                        setState(() {
                          pressed7 = true;
                        });
                      }
                    },
                    onLongPress: () {
                      if (loggedIn) {
                        setState(() {
                          pressed7 = true;
                        });
                      }
                    },
                    onLongPressEnd: (details) {
                      if (loggedIn) {
                        setState(() {
                          pressed7 = false;
                        });

                        sync();
                      }
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 100),
                      height: pressed7
                          ? size.height * 0.1 - size.width * 0.02
                          : size.height * 0.1,
                      width: pressed7
                          ? size1.width * 0.92 - size.width * 0.02
                          : size1.width * 0.92,
                      child: AnimatedContainer(
                        padding: EdgeInsets.only(
                            left: size.width * 0.04, right: size.width * 0.04),
                        alignment: Alignment.centerLeft,
                        height: size.height * 0.1,
                        width: size1.width,
                        duration: Duration(milliseconds: 700),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(size.height * 0.02),
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [
                              loggedIn
                                  ? bottomLeftColor[1]
                                  : Color.fromRGBO(200, 200, 200, 1),
                              loggedIn
                                  ? topRightColor[1]
                                  : Color.fromRGBO(160, 160, 160, 1)
                            ],
                          ),
                        ),
                        child: Text(
                          syncButton[lang],
                          style: Theme.of(context)
                              .primaryTextTheme
                              .headline1
                              .copyWith(
                                  fontSize:
                                      ScreenUtil().setSp(size.width * 0.07),
                                  color: colorAnimation.value),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Text(
                  other[lang],
                  style: Theme.of(context).primaryTextTheme.headline1.copyWith(
                      fontSize: ScreenUtil().setSp(size.width * 0.08),
                      color: color2Animation.value),
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: size.height * 0.01, bottom: size.height * 0.01),
                  width: size1.width,
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        pressed9 = true;

                        donateWindow = !donateWindow;
                      });

                      if (donating) {
                        setState(() {
                          donating = false;
                        });
                      } else {
                        Future.delayed(Duration(milliseconds: 300), () {
                          setState(() {
                            donating = true;
                          });
                        });
                      }

                      Future.delayed(Duration(milliseconds: 300), () {
                        setState(() {
                          pressed9 = false;
                        });
                      });
                    },
                    onTapDown: (details) {
                      if (!donating) {
                        setState(() {
                          pressed9 = true;
                        });
                      }
                    },
                    onLongPress: () {
                      setState(() {
                        pressed9 = true;
                      });
                    },
                    onLongPressEnd: (details) {
                      setState(() {
                        pressed9 = true;

                        donateWindow = !donateWindow;
                      });

                      if (donating) {
                        setState(() {
                          donating = false;
                        });
                      } else {
                        Future.delayed(Duration(milliseconds: 300), () {
                          setState(() {
                            donating = true;
                          });
                        });
                      }

                      Future.delayed(Duration(milliseconds: 300), () {
                        setState(() {
                          pressed9 = false;
                        });
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      height: donateWindow
                          ? size.height * 0.45
                          : (pressed9
                              ? size.height * 0.1 - size.width * 0.02
                              : size.height * 0.1),
                      width: pressed9
                          ? size1.width * 0.92 - size.width * 0.02
                          : size1.width * 0.92,
                      child: AnimatedContainer(
                        padding: EdgeInsets.only(
                            left: size.width * 0.04, right: size.width * 0.04),
                        alignment: Alignment.topCenter,
                        height: size.height * 0.1,
                        width: size1.width,
                        duration: Duration(milliseconds: 700),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(size.height * 0.02),
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [
                              Color.fromRGBO(170, 170, 170, 1),
                              Color.fromRGBO(130, 130, 130, 1)
                            ],
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              alignment: Alignment.centerLeft,
                              height: pressed9
                                  ? size.height * 0.1 - size.width * 0.02
                                  : size.height * 0.1,
                              width: size1.width * 0.92,
                              child: Text(
                                donate[lang],
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline1
                                    .copyWith(
                                        fontSize: ScreenUtil()
                                            .setSp(size.width * 0.07),
                                        color: colorAnimation.value),
                              ),
                            ),
                            AnimatedContainer(
                              alignment: Alignment.center,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              height: donateWindow ? size.height * 0.3 : 0,
                              child: AnimatedOpacity(
                                duration: Duration(milliseconds: 500),
                                opacity: donating ? 1 : 0,
                                child: Container(
                                  height: size.height * 0.28,
                                  width: size1.width,
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: size.height * 0.01, bottom: size.height * 0.01),
                  width: size1.width,
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        pressed10 = true;

                        aboutWindow = !aboutWindow;
                      });

                      if (aboutInfo) {
                        setState(() {
                          aboutInfo = false;
                        });
                      } else {
                        Future.delayed(Duration(milliseconds: 300), () {
                          setState(() {
                            aboutInfo = true;
                          });
                        });
                      }

                      Future.delayed(Duration(milliseconds: 300), () {
                        setState(() {
                          pressed10 = false;
                        });
                      });
                    },
                    onTapDown: (details) {
                      if (!aboutInfo) {
                        setState(() {
                          pressed10 = true;
                        });
                      }
                    },
                    onLongPress: () {
                      setState(() {
                        pressed10 = true;
                      });
                    },
                    onLongPressEnd: (details) {
                      setState(() {
                        pressed10 = true;

                        aboutWindow = !aboutWindow;
                      });

                      if (aboutInfo) {
                        setState(() {
                          aboutInfo = false;
                        });
                      } else {
                        Future.delayed(Duration(milliseconds: 300), () {
                          setState(() {
                            aboutInfo = true;
                          });
                        });
                      }

                      Future.delayed(Duration(milliseconds: 300), () {
                        setState(() {
                          pressed10 = false;
                        });
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      height: aboutWindow
                          ? size.height * 1.05
                          : (pressed10
                              ? size.height * 0.1 - size.width * 0.02
                              : size.height * 0.1),
                      width: pressed10
                          ? size1.width * 0.92 - size.width * 0.02
                          : size1.width * 0.92,
                      child: AnimatedContainer(
                        padding: EdgeInsets.only(
                            left: size.width * 0.04, right: size.width * 0.04),
                        alignment: Alignment.topCenter,
                        height: size.height * 0.1,
                        width: size1.width,
                        duration: Duration(milliseconds: 700),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(size.height * 0.02),
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [
                              Color.fromRGBO(170, 170, 170, 1),
                              Color.fromRGBO(130, 130, 130, 1)
                            ],
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              alignment: Alignment.centerLeft,
                              height: pressed10
                                  ? size.height * 0.1 - size.width * 0.02
                                  : size.height * 0.1,
                              width: size1.width * 0.92,
                              child: Text(
                                about[lang],
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline1
                                    .copyWith(
                                        fontSize: ScreenUtil()
                                            .setSp(size.width * 0.07),
                                        color: colorAnimation.value),
                              ),
                            ),
                            AnimatedContainer(
                              alignment: Alignment.center,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              height: aboutWindow ? size.height * 0.9 : 0,
                              child: AnimatedOpacity(
                                duration: Duration(milliseconds: 500),
                                opacity: aboutInfo ? 1 : 0,
                                child: Container(
                                  height: size.height * 0.9,
                                  width: size1.width,
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        height: size.width * 0.25,
                                        width: size.width * 0.25,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/dev_logo.png'),
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              size.width * 0.25 / 2),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * 0.02),
                                        child: Text(
                                          'ELECTRON',
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .headline1
                                              .copyWith(
                                                  fontSize: ScreenUtil().setSp(
                                                      size.width * 0.08)),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * 0.02),
                                        child: Text(
                                          'is the novice mobile and web developer with 1 year experience and some finished projects, one of which is this app.\n\nOn all questions and issues you can contact with developer by e-mail:\n\nelectron.devf@gmail.com\n',
                                          softWrap: true,
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .headline1
                                              .copyWith(
                                                  fontSize: ScreenUtil().setSp(
                                                      size.width * 0.06)),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          await launch('https://elya.dev');
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: size.height * 0.08,
                                          width: size.width * 0.7,
                                          decoration: BoxDecoration(
                                            color: bgColor[dark],
                                            borderRadius: BorderRadius.circular(
                                                size.height * 0.08 / 2),
                                          ),
                                          child: ShaderMask(
                                            blendMode: BlendMode.srcATop,
                                            shaderCallback: (Rect bounds) {
                                              return LinearGradient(
                                                begin: Alignment.bottomLeft,
                                                end: Alignment.topRight,
                                                colors: [
                                                  bottomLeftColor[1],
                                                  topRightColor[1]
                                                ],
                                              ).createShader(bounds);
                                            },
                                            child: Text(
                                              'Website',
                                              style: Theme.of(context)
                                                  .primaryTextTheme
                                                  .headline2
                                                  .copyWith(
                                                      color:
                                                          blackWhiteColor[dark]
                                                              .withOpacity(
                                                                  0.6)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.02,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          await launch(
                                              'https://play.google.com/store/apps/dev?id=6575145471832299540');
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: size.height * 0.08,
                                          width: size.width * 0.7,
                                          decoration: BoxDecoration(
                                            color: bgColor[dark],
                                            borderRadius: BorderRadius.circular(
                                                size.height * 0.08 / 2),
                                          ),
                                          child: ShaderMask(
                                            blendMode: BlendMode.srcATop,
                                            shaderCallback: (Rect bounds) {
                                              return LinearGradient(
                                                begin: Alignment.bottomLeft,
                                                end: Alignment.topRight,
                                                colors: [
                                                  bottomLeftColor[1],
                                                  topRightColor[1]
                                                ],
                                              ).createShader(bounds);
                                            },
                                            child: Text(
                                              'Dev page',
                                              style: Theme.of(context)
                                                  .primaryTextTheme
                                                  .headline2
                                                  .copyWith(
                                                      color:
                                                          blackWhiteColor[dark]
                                                              .withOpacity(
                                                                  0.6)),
                                            ),
                                          ),
                                        ),
                                      ),
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
                ),
                SizedBox(
                  height: size.height * 0.1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
