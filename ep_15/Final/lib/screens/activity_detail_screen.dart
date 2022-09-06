import 'package:flutter/material.dart';
import '../data/activity.dart';
import '../data/firebase_helper.dart';
import 'activities_screen.dart';

class ActivityDetailScreen extends StatefulWidget {
  const ActivityDetailScreen(this.activity, {Key? key}) : super(key: key);

  final Activity activity;

  @override
  State<ActivityDetailScreen> createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends State<ActivityDetailScreen> {
  List<ActivityTextField> controls = [];
  final TextEditingController txtDescription = TextEditingController();
  final TextEditingController txtDay = TextEditingController();
  final TextEditingController txtBeginTime = TextEditingController();
  final TextEditingController txtEndTime = TextEditingController();
  final helper = FirebaseHelper();

  @override
  void initState() {
    controls = [
      ActivityTextField('Description', txtDescription),
      ActivityTextField('Date', txtDay),
      ActivityTextField('Begin', txtBeginTime),
      ActivityTextField('End', txtEndTime),
    ];

    txtDescription.text = widget.activity.description;
    txtDay.text = widget.activity.day;
    txtBeginTime.text = widget.activity.beginTime;
    txtEndTime.text = widget.activity.endTime;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activity')),
      body: ListView.builder(
          itemCount: controls.length,
          itemBuilder: (context, position) {
            return Card(
              child: controls[position],
            );
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            saveUser();
            final route = MaterialPageRoute<dynamic>(
                builder: (context) => const ActivitiesScreen());
            final Future push = Navigator.push(context, route);
          },
          child: const Icon(Icons.save)),
    );
  }

  Future saveUser() async {
    widget.activity.description = txtDescription.text;
    widget.activity.day = txtDay.text;
    widget.activity.beginTime = txtBeginTime.text;
    widget.activity.endTime = txtEndTime.text;
    if (widget.activity.id == null) {
      await helper.insertActivity(widget.activity);
    } else {
      await helper.updateActivity(widget.activity, widget.activity.id!);
    }
  }
}

class ActivityTextField extends StatelessWidget {
  const ActivityTextField(this.label, this.controller, {Key? key})
      : super(key: key);

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: label,
            labelText: label),
      ),
    );
  }
}
