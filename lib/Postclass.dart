class Postclass {
  int id;
  String title;
  String description;
  String status;
  // var posted;

  Postclass(
      {required this.title,
      required this.status,
      required this.description,
      required this.id});

  factory Postclass.fromJson(Map<String, dynamic> json) {
    return Postclass(
        title: json['title'],
        status: json['status'],
        description: json['description'],
        id: json['id']);
  }
}
