// To parse this JSON data, do
//
//     final createPostResponseModel = createPostResponseModelFromJson(jsonString);

import 'dart:convert';

CreatePostResponseModel createPostResponseModelFromJson(String str) => CreatePostResponseModel.fromJson(json.decode(str));

String createPostResponseModelToJson(CreatePostResponseModel data) => json.encode(data.toJson());

class CreatePostResponseModel {
  CreatePostResponseModel({
    this.title,
    this.id,
    this.text,
    this.postedBy,
    this.name,
    this.date,
    this.comments,
    this.likes,
  });

  String title;
  String id;
  String text;
  PostedBy postedBy;
  String name;
  DateTime date;
  List<dynamic> comments;
  List<dynamic> likes;

  factory CreatePostResponseModel.fromJson(Map<String, dynamic> json) => CreatePostResponseModel(
    title: json["title"],
    id: json["_id"],
    text: json["text"],
    postedBy: PostedBy.fromJson(json["postedBy"]),
    name: json["name"],
    date: DateTime.parse(json["date"]),
    comments: List<dynamic>.from(json["comments"].map((x) => x)),
    likes: List<dynamic>.from(json["likes"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "_id": id,
    "text": text,
    "postedBy": postedBy.toJson(),
    "name": name,
    "date": date.toIso8601String(),
    "comments": List<dynamic>.from(comments.map((x) => x)),
    "likes": List<dynamic>.from(likes.map((x) => x)),
  };
}

class PostedBy {
  PostedBy({
    this.avatar,
    this.id,
    this.username,
  });

  String avatar;
  String id;
  String username;

  factory PostedBy.fromJson(Map<String, dynamic> json) => PostedBy(
    avatar: json["avatar"],
    id: json["_id"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "avatar": avatar,
    "_id": id,
    "username": username,
  };
}
