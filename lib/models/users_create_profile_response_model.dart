// To parse this JSON data, do
//
//     final usersCreateProfileResponseModel = usersCreateProfileResponseModelFromJson(jsonString);

import 'dart:convert';

UsersCreateProfileResponseModel usersCreateProfileResponseModelFromJson(String str) => UsersCreateProfileResponseModel.fromJson(json.decode(str));

String usersCreateProfileResponseModelToJson(UsersCreateProfileResponseModel data) => json.encode(data.toJson());

class UsersCreateProfileResponseModel {
  UsersCreateProfileResponseModel({
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
  String user;
  String about;
  DateTime birthdate;
  List<dynamic> favorite;
  String firstname;
  List<dynamic> followers;
  List<dynamic> following;
  String lastname;
  String location;
  List<dynamic> posts;
  List<dynamic> recent;
  String status;

  factory UsersCreateProfileResponseModel.fromJson(Map<String, dynamic> json) => UsersCreateProfileResponseModel(
    social: Social.fromJson(json["social"]),
    platform: List<String>.from(json["platform"].map((x) => x)),
    id: json["_id"],
    user: json["user"],
    about: json["about"],
    birthdate: DateTime.parse(json["birthdate"]),
    favorite: List<dynamic>.from(json["favorite"].map((x) => x)),
    firstname: json["firstname"],
    followers: List<dynamic>.from(json["followers"].map((x) => x)),
    following: List<dynamic>.from(json["following"].map((x) => x)),
    lastname: json["lastname"],
    location: json["location"],
    posts: List<dynamic>.from(json["posts"].map((x) => x)),
    recent: List<dynamic>.from(json["recent"].map((x) => x)),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "social": social.toJson(),
    "platform": List<dynamic>.from(platform.map((x) => x)),
    "_id": id,
    "user": user,
    "about": about,
    "birthdate": birthdate.toIso8601String(),
    "favorite": List<dynamic>.from(favorite.map((x) => x)),
    "firstname": firstname,
    "followers": List<dynamic>.from(followers.map((x) => x)),
    "following": List<dynamic>.from(following.map((x) => x)),
    "lastname": lastname,
    "location": location,
    "posts": List<dynamic>.from(posts.map((x) => x)),
    "recent": List<dynamic>.from(recent.map((x) => x)),
    "status": status,
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
