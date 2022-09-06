import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'activity.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseHelper {
  late FirebaseFirestore firestore;
  late CollectionReference activities;
  late firebase_storage.FirebaseStorage storage;
  final folder = 'activity_images/';

  FirebaseHelper() {
    firestore = FirebaseFirestore.instance;
    activities = firestore.collection('activities');
    storage = firebase_storage.FirebaseStorage.instance;
  }

  Future<DocumentReference?> insertActivity(Activity activity) async {
    try {
      final newActivity = await activities.add(activity.toMap());
      return newActivity;
    } on Exception catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<List<Activity>> readActivities() async {
    try {
      final QuerySnapshot<dynamic> snapshot = await activities.get();
      final List<Activity> list = [];
      for (var i = 0; i < snapshot.docs.length; i++) {
        final activity = Activity.fromMap(
            snapshot.docs[i].data() as Map<String, dynamic>,
            snapshot.docs[i].id);
        activity.id = snapshot.docs[i].id;
        list.add(activity);
      }
      return list;
    } on Exception catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future updateActivity(Activity activity, String id) async {
    try {
      await activities.doc(id).update(activity.toMap());
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  Future deleteActivity(String activityId) async {
    try {
      await activities.doc(activityId).delete();
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  Future testData() async {
    await insertActivity(
        Activity(null, 'Running', '12/12/2022', '8.30', '9.30', null));
    final activities = await readActivities();
    print(activities[0].description);
  }

  Future<bool> uploadImage(File file) async {
    final path = folder + basename(file.path);
    try {
      await storage.ref(path).putFile(file);
      return true;
    } catch (error) {
      return false;
    }
  }
}
