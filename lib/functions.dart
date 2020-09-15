import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import 'package:safety/Settings/themes.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//Shared Preferences --->

Future<bool> saveLangState(int lang) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('language', lang);

  print('[v] Language state saved successfully. (id: ${lang})');

  return prefs.commit();
}

Future<int> getLangState() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int lang = prefs.getInt('language');

  return lang;
}

Future<bool> saveThemeState(int theme) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('theme', theme);

  print(
      '[v] Theme state saved successfully. (id: $theme, name: ${names[theme]})');

  loadTheme();

  return prefs.commit();
}

Future<int> getThemeState() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int theme = prefs.getInt('theme');

  return theme;
}

Future<bool> saveEncryptedPass(String pass) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('pass', pass);

  print('[v] Decrypted pass saved successfully. (value: $pass)');

  return prefs.commit();
}

Future<String> getEncryptedPass() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String pass = prefs.getString('pass');

  return pass;
}

//Shared Preferences <---

void loadTheme() {
  getThemeState().then((value) {
    if (value != null) {
      theme = value;
      print('Current theme state: $theme');
    }
  });
}

void screenUtil(context, double height, double width) {
  ScreenUtil.init(context,
      height: height, width: width, allowFontScaling: false);
}

void encryptPass(String pass) async {
  final cryptor = new PlatformStringCryptor();
  final String key = await cryptor.generateKeyFromPassword(pass, 'salt');

  print(key);

  final String encrypted = await cryptor.encrypt(pass, key);

  print(encrypted);

  saveEncryptedPass(encrypted);

  transition = true;
}

Future<bool> decryptPass(String pass) async {

  String encrypted;
  bool matches = false;

  getEncryptedPass().then((value){
    encrypted = value;
  });

  final cryptor = new PlatformStringCryptor();

  final String key = await cryptor.generateKeyFromPassword(pass, 'salt');

  print(key);

  try {
    final String decrypted = await cryptor.decrypt(encrypted, key);

    print(decrypted);
    print('[v] > Password matches');
    matches = true;

  } catch (e) {
    print('[x] > Cannot login. Exception:\n');
    print(e);
  }

  return matches;
}
