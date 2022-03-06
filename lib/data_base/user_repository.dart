import 'package:cloud_firestore/cloud_firestore.dart';

class AppUserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String UserCollection = "Users";
  CollectionReference ref;

  AppUserRepository() {
    ref = _db.collection(UserCollection);
  }

  Future<DocumentSnapshot> getAppUserById(String uid) {
    return ref.doc(uid).get();
  }


  Future<void> removeAppUser(String uid) => ref.doc(uid).delete();
}
