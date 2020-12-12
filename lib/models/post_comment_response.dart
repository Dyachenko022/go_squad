// To parse this JSON data, do
//
//     final postCommentResponse = postCommentResponseFromJson(jsonString);

import 'dart:convert';

List<PostCommentResponse> postCommentResponseFromJson(String str) => List<PostCommentResponse>.from(json.decode(str).map((x) => PostCommentResponse.fromJson(x)));

String postCommentResponseToJson(List<PostCommentResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PostCommentResponse {
  PostCommentResponse({
    this.id,
    this.text,
    this.username,
    this.commentedBy,
    this.avatar,
    this.date,
  });

  String id;
  String text;
  String username;
  String commentedBy;
  String avatar;
  DateTime date;

  factory PostCommentResponse.fromJson(Map<String, dynamic> json) => PostCommentResponse(
    id: json["_id"],
    text: json["text"],
    username: json["username"],
    commentedBy: json["commentedBy"],
    avatar: json["avatar"],
    date: DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "text": text,
    "username": username,
    "commentedBy": commentedBy,
    "avatar": avatar,
    "date": date.toIso8601String(),
  };
}
