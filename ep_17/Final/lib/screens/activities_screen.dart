import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../data/activity.dart';
import '../data/firebase_helper.dart';
import 'activity_detail_screen.dart';
import 'authentication_screen.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({Key? key}) : super(key: key);

  @override
  _ActivitiesScreenState createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  late Future<List<Activity>> activities;
  late FirebaseHelper helper = FirebaseHelper();

  @override
  void initState() {
    activities = helper.readActivities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Authenticated!'),
        actions: [
          IconButton(
            onPressed: () {
              logout();
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
          ),
        ],
      ),
      body: FutureBuilder(
        future: activities,
        builder: (context, snapshot) {
          final List<Activity> activityList =
              snapshot.hasData ? snapshot.data as List<Activity> : [];
          return ListView.builder(
            itemCount: activityList.length,
            itemBuilder: (context, position) {
              final activity = activityList[position];
              return Dismissible(
                onDismissed: (_) {
                  helper.deleteActivity(activity.id!);
                },
                key: Key(activity.id.toString()),
                child: ListTile(
                  title: Text(activity.description),
                  subtitle: Text(
                      'Date: ${activity.day} - From ${activity.beginTime}' +
                          ' to  ${activity.endTime}'),
                  onTap: () {
                    final route = MaterialPageRoute<dynamic>(
                        builder: (context) => ActivityDetailScreen(activity));
                    final Future push = Navigator.push(context, route);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            final activity = Activity('', '', '', '', '', '');
            final route = MaterialPageRoute<dynamic>(
                builder: (context) => ActivityDetailScreen(activity));
            final Future push = Navigator.push(context, route);
          }),
    );
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
    return const AuthenticationScreen();
  }
}
