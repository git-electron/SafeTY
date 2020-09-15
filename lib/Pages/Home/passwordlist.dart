import 'package:flutter/material.dart';

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

  var db = DBHelper();

  void initState() {
    super.initState();

    getLangState().then((value) {
      setState(() {
        lang = value;
      });
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
              width: size.width,
              padding: EdgeInsets.only(
                  left: size.width * 0.04, right: size.width * 0.04),
              child: Row(
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
                                fontSize: size.height * 0.04),
                      )),
                  Container(
                    height: size.width * 0.07,
                    width: size.width * 0.07,
                    child: Icon(
                      CustomIcons.search,
                      color: topRightColor[theme],
                      size: size.width * 0.07,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: size.height * 0.03,
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
                        style: Theme.of(context).primaryTextTheme.headline2.copyWith(
                            fontSize: size.height * 0.027,
                            color: Colors.black.withOpacity(0.5)),
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

class _PassListState extends State<PassList> {

  int lang = 1;

  void initState() {
    super.initState();

    getLangState().then((value) {
      setState(() {
        lang = value;
      });
    });
  }

  var db = DBHelper();

  @override
  Widget build(BuildContext context) {
    if (widget.passdata.length != 0) {
      return ListView.separated(
        separatorBuilder: (BuildContext context, int i) {
          return Divider(
            color: Colors.white38,
          );
        },
        physics: BouncingScrollPhysics(),
        itemCount: widget.passdata.length == null ? 0 : widget.passdata.length,
        itemBuilder: (BuildContext context, int i) {
          return GestureDetector(
            onTap: () {},
            child: Container(
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.width * 0.95,
              child: Row(children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    widget.passdata[i].title,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    maxLines: 1,
                    textAlign: TextAlign.start,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  child: Center(
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ),
                )
              ]),
            ),
          );
        },
      );
    } else {
      return Center(
        child: Container(
          height: size.height * 0.6,
          alignment: Alignment.center,
          child: Text(
            noPass[lang],
            style: Theme.of(context).primaryTextTheme.headline2.copyWith(
                fontSize: size.height * 0.027,
                color: Colors.black.withOpacity(0.5)),
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

    var controlPoint1 = Offset(s.width * 1 / 3 - 50, s.height * 0.6);
    var endPoint1 = Offset(s.width * 1 / 3, s.height * 0.6);

    path.quadraticBezierTo(
        controlPoint1.dx, controlPoint1.dy, endPoint1.dx, endPoint1.dy);

    var controlPoint2 = Offset(s.width * 1 / 3 + 50, s.height * 0.6);
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
