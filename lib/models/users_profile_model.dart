// To parse this JSON data, do
//
//     final usersProfileModel = usersProfileModelFromJson(jsonString);

import 'dart:convert';

List<UsersProfileModel> usersProfileModelFromJson(String str) => List<UsersProfileModel>.from(json.decode(str).map((x) => UsersProfileModel.fromJson(x)));

String usersProfileModelToJson(List<UsersProfileModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UsersProfileModel {
  UsersProfileModel({
    this.social,
    this.platform,
    this.id,
    this.user,
    this.about,
    this.birthdate,
    this.favorite,
    this.firstname,
    this.followers,
    this.following,
    this.lastname,
    this.location,
    this.posts,
    this.recent,
    this.status,
  });

  Social social;
  List<String> platform;
  String id;
  User user;
  String about;
  DateTime birthdate;
  List<Favorite> favorite;
  String firstname;
  List<dynamic> followers;
  List<dynamic> following;
  String lastname;
  String location;
  List<dynamic> posts;
  List<Favorite> recent;
  String status;

  factory UsersProfileModel.fromJson(Map<String, dynamic> json) => UsersProfileModel(
    social: Social.fromJson(json["social"]),
    platform: List<String>.from(json["platform"].map((x) => x)),
    id: json["_id"],
    user: User.fromJson(json["user"]),
    about: json["about"],
    birthdate: json["birthdate"] == null ? null : DateTime.parse(json["birthdate"]),
    favorite: List<Favorite>.from(json["favorite"].map((x) => Favorite.fromJson(x))),
    firstname: json["firstname"],
    followers: json["followers"] == null ? null : List<dynamic>.from(json["followers"].map((x) => x)),
    following: json["following"] == null ? null : List<dynamic>.from(json["following"].map((x) => x)),
    lastname: json["lastname"],
    location: json["location"],
    posts: List<dynamic>.from(json["posts"].map((x) => x)),
    recent: List<Favorite>.from(json["recent"].map((x) => Favorite.fromJson(x))),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "social": social.toJson(),
    "platform": List<dynamic>.from(platform.map((x) => x)),
    "_id": id,
    "user": user.toJson(),
    "about": about,
    "birthdate": birthdate == null ? null : birthdate.toIso8601String(),
    "favorite": List<dynamic>.from(favorite.map((x) => x.toJson())),
    "firstname": firstname,
    "followers": followers == null ? null : List<dynamic>.from(followers.map((x) => x)),
    "following": following == null ? null : List<dynamic>.from(following.map((x) => x)),
    "lastname": lastname,
    "location": location,
    "posts": List<dynamic>.from(posts.map((x) => x)),
    "recent": List<dynamic>.from(recent.map((x) => x.toJson())),
    "status": status,
  };
}

class Favorite {
  Favorite({
    this.id,
    this.title,
    this.platform,
    this.hours,
  });

  String id;
  String title;
  String platform;
  String hours;

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
    id: json["_id"],
    title: json["title"],
    platform: json["platform"],
    hours: json["hours"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "platform": platform,
    "hours": hours,
  };
}

class Social {
  Social({
    this.discord,
    this.youtube,
    this.steam,
  });

  String discord;
  String youtube;
  String steam;

  factory Social.fromJson(Map<String, dynamic> json) => Social(
    discord: json["discord"],
    youtube: json["youtube"],
    steam: json["steam"],
  );

  Map<String, dynamic> toJson() => {
    "discord": discord,
    "youtube": youtube,
    "steam": steam,
  };
}

class User {
  User({
    this.avatar,
    this.id,
    this.username,
  });

  String avatar;
  String id;
  String username;

  factory User.fromJson(Map<String, dynamic> json) => User(
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
