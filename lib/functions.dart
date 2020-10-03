import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import 'package:safety/Settings/themes.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//Shared Preferences --->

Future<bool> saveLangState(int lang) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('language', lang);

  print('[SHARED PREFERENCES] Language state saved successfully. (id: $lang)');

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
      '[SHARED PREFERENCES] Theme state saved successfully. (id: $theme, name: ${names[theme]})');

  loadTheme();

  return prefs.commit();
}

Future<int> getThemeState() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int theme = prefs.getInt('theme');

  return theme;
}

Future<bool> saveDarkThemeState(int darkThemeState) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('dark theme', darkThemeState);

  print(
      '[SHARED PREFERENCES] Dark theme state saved successfully. (state: $darkThemeState)');

  return prefs.commit();
}

Future<int> getDarkThemeState() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int darkThemeState = prefs.getInt('dark theme');

  return darkThemeState;
}

Future<bool> saveEncryptedPass(String pass) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('pass', pass);

  print('[SHARED PREFERENCES] Encrypted pass saved successfully. (value: $pass)');

  return prefs.commit();
}

Future<String> getEncryptedPass() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String pass = prefs.getString('pass');

  return pass;
}

Future<bool> saveLoginState(bool logged) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('login state', logged);

  print('[SHARED PREFERENCES] Login state saved successfully. (value: $logged)');

  return prefs.commit();
}

Future<bool> getLoginState() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool logged = prefs.getBool('login state');

  return logged;
}

Future<bool> saveEmail(List<String> mails) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList('emails', mails);

  print('[SHARED PREFERENCES] Mail saved successfully. (value: $mails)');

  return prefs.commit();
}

Future<List<String>> getEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> mail = prefs.getStringList('emails');

  return mail;
}

//Shared Preferences <---

void loadTheme() {
  getThemeState().then((value) {
    if (value != null) {
      theme = value;
      print('[SHARED PREFERENCES] Current theme state: $theme');
    }
  });
}

void screenUtil(context, double height, double width) {
  ScreenUtil.init(context,
      height: height, width: width, allowFontScaling: false);
}

void generateKeyFromPassword(String pass) async {
  final cryptor = new PlatformStringCryptor();
  final String key = await cryptor.generateKeyFromPassword(pass, 'salt');

  decryptKey = key;
  print('\n\n[SHARED PREFERENCES] Key to encrypt/decrypt passwords: $key');
  print('[SHARED PREFERENCES] Old key for passwords: $oldDecryptKey\n\n');

  transition = true;
}

Future<bool> decryptPass(String pass) async {
  String encrypted;
  bool matches = false;

  getEncryptedPass().then((value) {
    encrypted = value;
  });

  final cryptor = new PlatformStringCryptor();

  final String key = await cryptor.generateKeyFromPassword(pass, 'salt');

  decryptKey = key;
  print('[SHARED PREFERENCES] Key to encrypt/decrypt passwords: $key');

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

Future<List<String>> encryptCell(List cellToEncrypt) async {
  String title = cellToEncrypt[0];
  String pass = cellToEncrypt[1];
  String username = cellToEncrypt[2];
  String link = cellToEncrypt[3];

  String key = decryptKey;
  print('[SHARED PREFERENCES] Key to encrypt/decrypt passwords: $key');

  final cryptor = new PlatformStringCryptor();

  final String encryptedPass = await cryptor.encrypt(pass, key);
  final String encryptedUsername = await cryptor.encrypt(username, key);
  final String encryptedLink = await cryptor.encrypt(link, key);

  List<String> encryptedCell = [
    title,
    encryptedPass,
    encryptedUsername,
    encryptedLink
  ];

  print('[SHARED PREFERENCES] encrypted cell with key $key');

  return encryptedCell;
}

Future<List<String>> decryptCell(List cellToDecrypt, bool decryptWithOldKey) async {
  String title = cellToDecrypt[0];
  String encryptedPass = cellToDecrypt[1];
  String encryptedUsername = cellToDecrypt[2];
  String encryptedLink = cellToDecrypt[3];

  String key = decryptWithOldKey ? oldDecryptKey : decryptKey;

  print('[SHARED PREFERENCES] Key to encrypt/decrypt passwords: $key');

  final cryptor = new PlatformStringCryptor();

  final String pass = await cryptor.decrypt(encryptedPass, key);
  final String username = await cryptor.decrypt(encryptedUsername, key);
  final String link = await cryptor.decrypt(encryptedLink, key);

  List<String> decryptedCell = [
    title,
    pass,
    username,
    link
  ];

  return decryptedCell;
}