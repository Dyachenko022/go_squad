// To parse this JSON data, do
//
//     final postModel = postModelFromJson(jsonString);

import 'dart:convert';

List<PostModel> postModelFromJson(String str) => List<PostModel>.from(json.decode(str).map((x) => PostModel.fromJson(x)));

String postModelToJson(List<PostModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PostModel {
  PostModel({
    this.title,
    this.id,
    this.text,
    this.postedBy,
    this.name,
    this.date,
    this.comments,
    this.likes,
    this.avatar,
  });

  String title;
  String id;
  String text;
  PostedBy postedBy;
  String name;
  DateTime date;
  List<Comment> comments;
  List<Like> likes;
  String avatar;

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    title: json["title"],
    id: json["_id"],
    text: json["text"],
    postedBy: PostedBy.fromJson(json["postedBy"]),
    name: json["name"],
    date: DateTime.parse(json["date"]),
    comments: List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
    likes: List<Like>.from(json["likes"].map((x) => Like.fromJson(x))),
    avatar: json["avatar"] == null ? null : json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "_id": id,
    "text": text,
    "postedBy": postedBy.toJson(),
    "name": name,
    "date": date.toIso8601String(),
    "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
    "likes": List<dynamic>.from(likes.map((x) => x.toJson())),
    "avatar": avatar == null ? null : avatar,
  };
}

class Comment {
  Comment({
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

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json["_id"],
    text: json["text"],
    username: json["username"],
    commentedBy: json["commentedBy"],
    avatar: json["avatar"] == null ? null : json["avatar"],
    date: DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "text": text,
    "username": username,
    "commentedBy": commentedBy,
    "avatar": avatar == null ? null : avatar,
    "date": date.toIso8601String(),
  };
}

class Like {
  Like({
    this.id,
    this.likedBy,
  });

  String id;
  String likedBy;

  factory Like.fromJson(Map<String, dynamic> json) => Like(
    id: json["_id"],
    likedBy: json["likedBy"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "likedBy": likedBy,
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
