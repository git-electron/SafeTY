import 'package:firebase_auth/firebase_auth.dart';
import 'package:safety/Database/cloud.dart';

import 'package:safety/Utils/models/user.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppUser _userFromFirebaseUser(User user) {
    return user != null ? AppUser(uid: user.uid) : null;
  }

  Stream<AppUser> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future signIn(String email, String pass) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: pass);
      User user = result.user;

      if(!user.emailVerified){
        user.sendEmailVerification();
      }

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      signUp(email, pass);
      return null;
    }
  }

  Future signUp(String email, String pass) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      User user = result.user;
      user.sendEmailVerification();
      return false;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      await _auth.signOut();
      return true;
    } catch(e){
      print(e.toString());
      return null;
    }
}

Future getUser() async {
    try{
      User user = _auth.currentUser;
      return user;
    } catch(e){
      print(e);
      return null;
    }
}

}