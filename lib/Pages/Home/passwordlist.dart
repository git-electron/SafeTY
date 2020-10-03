import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safety/Cloud/auth.dart';
import 'package:safety/Cloud/cloud.dart';

import 'package:safety/Database/DBHelper.dart';
import 'package:safety/Database/password.dart';
import 'package:safety/Settings/texts.dart';
import 'package:safety/Settings/themes.dart';
import 'package:safety/functions.dart';
import 'package:safety/custom_icons_icons.dart';

import 'package:shared_preferences/shared_preferences.dart';

class PasswordList extends StatefulWidget {
  @override
  _PasswordListState createState() => _PasswordListState();
}

class _PasswordListState extends State<PasswordList> {
  int lang = 1;

  bool search = false;

  final _searchController = TextEditingController();

  var db = DBHelper();

  final AuthService _auth = AuthService();
  final DatabaseService _database = DatabaseService();

  void initState() {
    super.initState();

    sync();

    getLangState().then((value) {
      setState(() {
        lang = value;
      });
    });

    setState(() {
      _searchController.text = searchData;
    });

    if (searchData != '') {
      setState(() {
        search = true;
      });
    }

    Timer.periodic(Duration(seconds: 60), (timer) {
      try{
        sync();
      } catch(e){
        print(e.toString());
      }

      if(page != 1){
        timer.cancel();
      }
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
              print('\n\nPasswords are similar:\n${passwords[passwordIndex]['sortDate']}\n${password.sortDate}\n\n');
              setState(() {
                similar = true;
              });
            } else {
              print('\n\nPasswords are NOT similar:\n${passwords[passwordIndex]['sortDate']}\n${password.sortDate}\n\n');
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
              alignment: search ? Alignment.centerRight : Alignment.center,
              width: size.width,
              padding: EdgeInsets.only(
                  left: size.width * 0.04, right: size.width * 0.04),
              child: Stack(
                alignment: search ? Alignment.centerRight : Alignment.center,
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
                            manager[lang],
                            style: Theme.of(context)
                                .primaryTextTheme
                                .headline2
                                .copyWith(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(size.width * 0.076),
                                ),
                          )),
                      search
                          ? SizedBox(
                              width: size.width * 0.07,
                            )
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  search = true;

                                  _searchController.text = searchData;
                                });
                              },
                              child: Container(
                                height: size.width * 0.07,
                                width: size.width * 0.07,
                                child: Icon(
                                  CustomIcons.search,
                                  color: topRightColor[theme],
                                  size: size.width * 0.07,
                                ),
                              ),
                            ),
                    ],
                  ),
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity: search ? 1 : 0,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      height: size.height * 0.07,
                      width: search ? size.width : size.height * 0.07,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(
                          left: size.width * 0.04,
                          right: search ? size.width * 0.04 : 0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(size.height * 0.035),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 25,
                                spreadRadius: 5,
                                offset: Offset(0, 10))
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          AnimatedContainer(
                            alignment: Alignment.centerLeft,
                            duration: Duration(milliseconds: 100),
                            height: size.height * 0.07,
                            width: search ? size.width * 0.75 : 0,
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  searchData = value;
                                });
                              },
                              controller: _searchController,
                              autocorrect: false,
                              keyboardType: TextInputType.text,
                              enabled: search,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline2
                                  .copyWith(
                                      fontSize: ScreenUtil().setSp(size.width * 0.057),
                                      color: Colors.black.withOpacity(0.6)),
                              cursorColor: Colors.black12,
                              textInputAction: TextInputAction.search,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusColor: Colors.black,
                                  fillColor: Colors.black12,
                                  hintText: searchField[lang],
                                  hintStyle: Theme.of(context)
                                      .primaryTextTheme
                                      .headline2
                                      .copyWith(
                                          fontSize: ScreenUtil().setSp(size.width * 0.057),
                                          color:
                                              Colors.black.withOpacity(0.4))),
                            ),
                          ),
                          search
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      search = false;

                                      searchData = '';
                                    });
                                  },
                                  child: Container(
                                    height: size.width * 0.07,
                                    width: size.width * 0.07,
                                    child: Icon(
                                      CustomIcons.cancel,
                                      color: topRightColor[theme],
                                      size: size.width * 0.07,
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  width: size.width * 0.07,
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
        FutureBuilder(
          future: db.getPass(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            var data = snapshot.data;

            return snapshot.hasData
                ? PassList(data)
                : Center(
                    child: Container(
                      height: size.height * 0.6,
                      alignment: Alignment.center,
                      child: Text(
                        '${loading[lang]}...',
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline2
                            .copyWith(
                                fontSize: ScreenUtil().setSp(size.width * 0.051),
                                color: blackWhiteColor[dark].withOpacity(0.5)),
                      ),
                    ),
                  );
          },
        )
      ],
    );
  }
}

class PassList extends StatefulWidget {
  final List<Password> passdata;
  PassList(this.passdata, {Key key});

  @override
  _PassListState createState() => _PassListState();
}

class _PassListState extends State<PassList> with TickerProviderStateMixin {
  int lang = 1;
  int deleteIndex = -1;

  bool delete = false;
  bool opacity = false;

  List<double> widths = [];
  List<Color> colors = [];

  Animation<double> widthAnimation;
  AnimationController widthAnimationController;

  void initState() {
    super.initState();

    getLangState().then((value) {
      setState(() {
        lang = value;
      });
    });

    addWidths();
    addColors();

    widthAnimation =
        Tween<double>(begin: 0, end: 1).animate(widthAnimationController);
    widthAnimationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);

    Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (widget.passdata.length >= widths.length) {
        widths.add(0);
      }
      if (widget.passdata.length >= colors.length) {
        colors.add(Colors.redAccent);
      }
    });
  }

  void addWidths() {
    int i = 0;

    while (i <= widget.passdata.length) {
      widths.add(0);

      i++;
    }
    print(widths);
  }

  void addColors() {
    int i = 0;

    while (i <= widget.passdata.length) {
      colors.add(Colors.redAccent);

      i++;
    }
    print(colors);
  }

  var db = DBHelper();

  @override
  Widget build(BuildContext context) {
    Size size1 = MediaQuery.of(context).size;

    if (widget.passdata.length != 0) {
      return Container(
        width: size1.width,
        height: size.height * 0.83,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          itemCount:
              widget.passdata.length == null ? 0 : widget.passdata.length,
          itemBuilder: (BuildContext context, int i) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  passData = widget.passdata[i];

                  page = 4;

                  obscure = true;
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: (widget.passdata[i].title
                        .toLowerCase()
                        .contains(searchData.toLowerCase()))
                    ? size.height * 0.1
                    : 0,
                width: size1.width,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: size.height * 0.1,
                      width: size1.width,
                      color: colors[i],
                      child: DragTarget(
                        builder:
                            (context, List<int> candidateData, rejectedData) {
                          return null;
                        },
                        onWillAccept: (data) {
                          return true;
                        },
                        onAccept: (data) {
                          if (data == 1) {
                            print('true');
                            print(deleteIndex);

                            if (deleteIndex >= 0) {
                              if (deleteIndex == i) {
                                setState(() {
                                  delete = !delete;
                                });
                              } else {
                                if (!delete) {
                                  setState(() {
                                    deleteIndex = i;
                                    delete = !delete;
                                  });
                                } else {
                                  setState(() {
                                    deleteIndex = i;
                                  });
                                }
                              }
                            } else {
                              setState(() {
                                deleteIndex = i;
                                delete = !delete;
                              });
                            }

                            if (delete) {
                              setState(() {
                                widths[i] = size.width * 0.25;
                              });

                              int index = 0;
                              while (index < widget.passdata.length) {
                                if (index != i) {
                                  setState(() {
                                    widths[index] = 0;
                                  });
                                }
                                index++;
                              }
                            } else {
                              setState(() {
                                widths[i] = 0;
                              });
                            }
                          } else {
                            print('false');
                          }
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print('deleting started');

                        widthAnimationController.forward(from: 0.0);

                        Timer.periodic(Duration(milliseconds: 10), (timer) {
                          setState(() {
                            widths[i] =
                                widthAnimationController.value * size1.width +
                                    size.width * 0.3;
                          });

                          Future.delayed(Duration(milliseconds: 300), () {
                            timer.cancel();
                          });
                        });

                        Future.delayed(Duration(milliseconds: 300), () {
                          setState(() {
                            opacity = true;
                          });
                        });
                      },
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          AnimatedOpacity(
                            duration: Duration(
                                milliseconds:
                                    (colors[i] == Colors.white) ? 0 : 300),
                            opacity: opacity ? 1 : 0,
                            child: Container(
                              width: size.width * 0.9,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: size.width * 0.05,
                                  ),
                                  Text(
                                    sure[lang],
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .headline2
                                        .copyWith(fontSize: ScreenUtil().setSp(size.width * 0.042)),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.06,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      print('deleting cancelled');

                                      widthAnimationController.reverse(
                                          from: 1.0);

                                      setState(() {
                                        opacity = false;
                                      });

                                      Timer.periodic(Duration(milliseconds: 10),
                                          (timer) {
                                        setState(() {
                                          widths[i] =
                                              widthAnimationController.value *
                                                  size1.width;
                                        });

                                        Future.delayed(
                                            Duration(milliseconds: 300), () {
                                          timer.cancel();

                                          setState(() {
                                            widths[i] = 0;
                                            delete = false;
                                            deleteIndex = -1;
                                          });
                                        });
                                      });
                                    },
                                    child: Container(
                                      child: Icon(
                                        CustomIcons.cross,
                                        color: Colors.white,
                                        size: size.width * 0.07,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.04,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      print('deleted');

                                      setState(() {
                                        colors[i] =
                                            bgColor[dark];
                                      });

                                      setState(() {
                                        widths[i] =
                                            widthAnimationController.value *
                                                size1.width;
                                      });

                                      Future.delayed(
                                          Duration(milliseconds: 300), () {
                                        setState(() {
                                          widths[i] = 0;
                                          colors[i] = Colors.redAccent;
                                          delete = false;
                                          deleteIndex = -1;
                                        });
                                      });

                                      Future.delayed(
                                          Duration(milliseconds: 200), () {
                                        db.deletePass(widget.passdata[i]);
                                      });

                                      Future.delayed(
                                          Duration(milliseconds: 500), () {
                                        setState(() {
                                          widths[i] = 0;
                                          deleteIndex = -1;
                                          delete = false;
                                          opacity = false;
                                        });
                                        print(widths);
                                        widths.remove(i);
                                        print(widths);
                                      });
                                    },
                                    child: Container(
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: size.width * 0.07,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          AnimatedOpacity(
                            duration: Duration(milliseconds: 300),
                            opacity: opacity ? 0 : 1,
                            child: Container(
                              width: size.width * 0.2,
                              child: Icon(
                                CustomIcons.trash,
                                color: Colors.white,
                                size: size.width * 0.06,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: widths[i],
                      child: Draggable(
                        dragAnchor: DragAnchor.child,
                        feedbackOffset: Offset(100, 0),
                        maxSimultaneousDrags: 1,
                        affinity: Axis.horizontal,
                        data: 1,
                        axis: Axis.horizontal,
                        childWhenDragging: Container(
                          height: size.height * 0.1,
                          width: size1.width,
                          child: DragTarget(
                            builder: (context, List<int> candidateData,
                                rejectedData) {
                              return null;
                            },
                            onWillAccept: (data) {
                              return true;
                            },
                            onAccept: (data) {
                              if (data == 1) {
                                print('true');
                                print(deleteIndex);

                                if (deleteIndex >= 0) {
                                  if (deleteIndex == i) {
                                    setState(() {
                                      delete = !delete;
                                    });
                                  } else {
                                    if (!delete) {
                                      setState(() {
                                        deleteIndex = i;
                                        delete = !delete;
                                      });
                                    } else {
                                      setState(() {
                                        deleteIndex = i;
                                      });
                                    }
                                  }
                                } else {
                                  setState(() {
                                    deleteIndex = i;
                                    delete = !delete;
                                  });
                                }

                                if (delete) {
                                  setState(() {
                                    widths[i] = size.width * 0.25;
                                  });

                                  int index = 0;
                                  while (index < widget.passdata.length) {
                                    if (index != i) {
                                      setState(() {
                                        widths[index] = 0;
                                      });
                                    }
                                    index++;
                                  }
                                } else {
                                  setState(() {
                                    widths[i] = 0;
                                  });
                                }
                              } else {
                                print('false');
                              }
                            },
                          ),
                        ),
                        feedback: Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(
                              left: size.width * 0.04,
                              right: size.width * 0.04),
                          height: size.height * 0.1,
                          width: size1.width,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(size.height * 0.01),
                              color: bgColor[dark],
                              boxShadow: [
                                BoxShadow(
                                    color: buttonBgColor[dark]
                                        .withOpacity((dark == 1) ? 0.2 : 0.1),
                                    blurRadius: 25,
                                    spreadRadius: 5,
                                    offset: Offset(0, 5))
                              ]),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: size1.width * 0.8,
                                  child: Text(
                                    widget.passdata[i].title,
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .headline2
                                        .copyWith(
                                            fontSize: ScreenUtil().setSp(size.width * 0.065),
                                            color: blackWhiteColor[dark]
                                                .withOpacity(0.6)),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  child: Icon(
                                    CustomIcons.right_open,
                                    size: size.width * 0.07,
                                    color:
                                        blackWhiteColor[dark].withOpacity(0.6),
                                  ),
                                )
                              ]),
                        ),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(
                              left: size.width * 0.04,
                              right: size.width * 0.04),
                          height: size.height * 0.1,
                          width: size1.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                (widths[i] != 0) ? size.height * 0.01 : 0),
                            color: bgColor[dark],
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: size1.width * 0.8,
                                  child: Text(
                                    widget.passdata[i].title,
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .headline2
                                        .copyWith(
                                            fontSize: ScreenUtil().setSp(size.width * 0.065),
                                            color: blackWhiteColor[dark]
                                                .withOpacity(0.6)),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  child: Icon(
                                    CustomIcons.right_open,
                                    size: size.width * 0.07,
                                    color:
                                        blackWhiteColor[dark].withOpacity(0.6),
                                  ),
                                )
                              ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    } else {
      return Center(
        child: Container(
          height: size.height * 0.6,
          alignment: Alignment.center,
          child: Text(
            noPass[lang],
            style: Theme.of(context).primaryTextTheme.headline2.copyWith(
                fontSize: ScreenUtil().setSp(size.width * 0.051),
                color: blackWhiteColor[dark].withOpacity(0.5)),
          ),
        ),
      );
    }
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
