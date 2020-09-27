import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safety/Database/password.dart';

class DatabaseService {

  final String uid;
  DatabaseService({this.uid});

  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  Future createUserCollection() async {
    return await usersCollection.doc(uid).set(null);
  }

  Future updateUserData(List<Map<String, dynamic>> passwords, String uid) async {


    return await usersCollection.doc(uid).set({
      'passwords': passwords
    });
  }

  Future getUserData(id) async {
    return await usersCollection.doc(id).get();
  }

  Stream<QuerySnapshot> get users {
    return usersCollection.snapshots();
  }

}