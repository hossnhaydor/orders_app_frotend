class NotificationModel {
  final int id;
  final String date;
  final String content;
  NotificationModel({
    required this.id,
    required this.date,
    required this.content,
  });
  int get getId => id;
  String get getDate => date;
  String get getContent => content;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      date: json['created_at'],
      content: json['content'],
    );
  }
}
