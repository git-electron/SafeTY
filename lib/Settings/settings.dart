import 'package:flutter/material.dart';
import 'package:safety/Settings/texts.dart';

import 'package:safety/Settings/themes.dart';
import 'package:safety/custom_icons_icons.dart';
import 'package:safety/functions.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  int lang = 0;

  bool container = true;

  void initState(){
    super.initState();

    getLangState().then((value) {
      setState(() {
        lang = value;
      });
    });

    Future.delayed(Duration(milliseconds: 300), (){
      setState(() {
        container = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size1 = MediaQuery.of(context).size;

    return Column(
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
                style: Theme.of(context)
                    .primaryTextTheme
                    .headline1
                    .copyWith(fontSize: size.width * 0.11),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  container = true;

                  page = 5;
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
        SizedBox(
          height: size.height * 0.05,
        ),
        Text(
          appearance[lang],
          style: Theme.of(context).primaryTextTheme.headline1.copyWith(fontSize: size.width * 0.08, color: Colors.black),
        ),
        Text(
          language[lang],
          style: Theme.of(context).primaryTextTheme.headline1.copyWith(fontSize: size.width * 0.08, color: Colors.black),
        ),
        Text(
          masterPassSettings[lang],
          style: Theme.of(context).primaryTextTheme.headline1.copyWith(fontSize: size.width * 0.08, color: Colors.black),
        ),
        Text(
          other[lang],
          style: Theme.of(context).primaryTextTheme.headline1.copyWith(fontSize: size.width * 0.08, color: Colors.black),
        ),
      ],
    );
  }
}
