import 'package:easy_http_request/easy_http_request.dart';

class PostModel implements HttpDataParser<PostModel> {
  PostModel({
    this.userId,
    this.id,
    this.title,
    this.body,
  });

  int? userId;
  int? id;
  String? title;
  String? body;

  @override
  PostModel fromJson(Map<String, dynamic> json) => PostModel(
        userId: json['userId'],
        id: json['id'],
        title: json['title'],
        body: json['body'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'userId': userId,
        'id': id,
        'title': title,
        'body': body,
      };
}
