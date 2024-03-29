import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  Image? activityImage;
  XFile? galleryImage;

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

    if (widget.activity.imagePath != null && widget.activity.imagePath != '') {
      helper.getImage(widget.activity.imagePath!).then((dynamic value) {
        activityImage = Image.network(value.toString());
        setState(() {});
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (galleryImage == null && activityImage == null) {
      activityImage = Image.asset('assets/running.png');
    } else if (galleryImage != null) {
      activityImage = Image.file(File(galleryImage!.path));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Activity')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: controls.length,
                itemBuilder: (context, position) {
                  return Card(
                    child: controls[position],
                  );
                }),
          ),
          SizedBox(
            height: 100,
            child: activityImage,
          ),
          SizedBox(
            width: 100,
            height: 100,
            child: IconButton(
              icon: const Icon(Icons.image),
              onPressed: choosePicture,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            saveUser();
            uploadPicture(); 
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
    if (galleryImage != null) {
      widget.activity.imagePath = galleryImage?.path ?? '';
    }
    if (widget.activity.id == null) {
      await helper.insertActivity(widget.activity);
    } else {
      await helper.updateActivity(widget.activity, widget.activity.id!);
    }
  }

  Future choosePicture() async {
    final _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      galleryImage = image;
    });
  }

  Future uploadPicture() async {
    if (galleryImage != null) {
      final file = File(galleryImage!.path);
      helper.uploadImage(file);
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
