class Activity {
  late String? id;
  late String description;
  late String day;
  late String beginTime;
  late String endTime;
  String? imagePath;

  Activity(this.id, this.description, this.day, this.beginTime, this.endTime,
      this.imagePath);

  Activity.fromMap(Map<String, dynamic> map, String id) {
    id = id;
    description = map['description'].toString();
    day = map['day'].toString();
    beginTime = map['beginTime'].toString();
    endTime = map['endTime'].toString();
    imagePath = map['imagePath']?.toString();
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id ?? '',
      'description': description,
      'day': day,
      'beginTime': beginTime,
      'endTime': endTime,
      'imagePath': imagePath
    };
  }
}
