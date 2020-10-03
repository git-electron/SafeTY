import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safety/Database/password.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future updateUserData(List<Map<String, dynamic>> passwords,
      List<dynamic> devices, String uid, String device) async {
    return await usersCollection
        .doc(uid)
        .set({'$device': passwords, 'devices': devices});
  }

  Future getUserData(id) async {
    return await usersCollection.doc(id).get();
  }

  Stream<QuerySnapshot> get users {
    return usersCollection.snapshots();
  }
}
