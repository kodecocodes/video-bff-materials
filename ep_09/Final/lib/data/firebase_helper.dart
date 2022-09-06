import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  late FirebaseFirestore firestore;
  late CollectionReference activities;

  FirebaseHelper() {
    firestore = FirebaseFirestore.instance;
    activities = firestore.collection('activities');
  }
}
