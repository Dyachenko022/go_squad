import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_squad/data/rest_api_service.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class OtherUserProfile extends StatefulWidget {
  String id;
  OtherUserProfile({Key key, @required this.id}) : super(key : key);

  @override
  _OtherUserProfileState createState() => _OtherUserProfileState(this.id);
}

class _OtherUserProfileState extends State<OtherUserProfile> with SingleTickerProviderStateMixin {



  String id;
  var accessToken;
  bool hasProfile = false;
  bool isLoading = false;
  var userProfile;




  Future<void>loadProfile() async {
    setState(() {
      isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('accessToken');
    final response = await Provider.of<RestApiService>(context, listen: false).loadSelectedUserProfile(accessToken, id);
    if(response.statusCode == 200)
    {
      userProfile = response.body;
      print(userProfile.platform[0]);
      setState(() {
        hasProfile = true;
        isLoading = false;
      });
    }
    else if(response.statusCode == 400)
    {
      print('user not created');
      setState(() {
        hasProfile = false;
        isLoading = false;
      });
    }
    else{
      print('something went wrong');
      setState(() {
        isLoading = false;
      });
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadProfile();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.grey[900],
        body: isLoading ? Center(
          child: SpinKitChasingDots(
            size: 30,
            color: Colors.green[400],
          ),
        ) : hasProfile ? Theme(
          data: Theme.of(context).copyWith(accentColor: Colors.green[400]),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Center(
                      child: GestureDetector(
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[400],
                          child: ClipOval(
                            child: userProfile.user.avatar == null ? Image.asset('assets/profile_icon.png',
                              width: MediaQuery.of(context).size.height/5,
                              fit: BoxFit.cover,

                            ) : Image.network(userProfile.user.avatar,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width/3,),
                          ),
                          radius: MediaQuery.of(context).size.height/10,
                        ),
                        onTap: () {
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(userProfile.user.username,
                  style: TextStyle(
                      fontFamily: 'Oswald',
                      fontSize: 20,
                      letterSpacing: 2,
                      color: Colors.grey[300]
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Divider(
                  height: 50,
                  color: Colors.grey[400],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text(userProfile.firstname,
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Oswald',
                                color: Colors.grey[400]
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(userProfile.lastname,
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Oswald',
                                color: Colors.grey[400]
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(userProfile.location,
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Oswald',
                                color: Colors.grey[400]
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width/4,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Icon(FontAwesome5Brands.discord, size: 30, color: Colors.green[400],),
                            SizedBox(width: 10,),
                            Text(userProfile.social.discord, style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Oswald',
                                color: Colors.grey[400]
                            ),)
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Icon(FontAwesome5Brands.youtube, size: 30, color: Colors.green[400],),
                            SizedBox(width: 10,),
                            Text(userProfile.social.youtube, style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Oswald',
                                color: Colors.grey[400]
                            ),)
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Icon(FontAwesome5Brands.steam, size: 30, color: Colors.green[400],),
                            SizedBox(width: 10,),
                            Text(userProfile.social.steam, style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Oswald',
                                color: Colors.grey[400]
                            ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Card(
                    shape: StadiumBorder(
                        side: BorderSide(
                            color: Colors.grey[400],
                            width: 1
                        )
                    ),
                    color: Colors.grey[900],
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Обо мне',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Oswald',
                                  color: Colors.grey[400]
                              ),
                            ),
                            Divider(
                              height: 8,
                              color: Colors.grey[400],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Center(
                              child: Text(
                                userProfile.about,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Oswald',
                                    color: Colors.grey[400]
                                ),
                              ),
                            ),
                          ],
                        )
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Card(
                    shape: StadiumBorder(
                        side: BorderSide(
                            color: Colors.grey[400],
                            width: 1
                        )
                    ),
                    color: Colors.grey[900],
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Платформы',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Oswald',
                                  color: Colors.grey[400]
                              ),
                            ),
                            Divider(
                              indent: 20,
                              endIndent: 20,
                              height: 8,
                              color: Colors.grey[400],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Theme(
                              data: Theme.of(context).copyWith(accentColor: Colors.transparent),
                              child: ListView.builder(itemBuilder: (context, index) => Container(
                                padding: EdgeInsets.all(10),
                                child: Center(
                                  child: Text(userProfile.platform[index],
                                    style: TextStyle(
                                        color: Colors.grey[400],
                                        fontFamily: 'Oswald',
                                        fontSize: 17
                                    ),
                                  ),
                                ),
                              ),
                                itemCount: userProfile.platform.length,
                                scrollDirection: Axis.vertical,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,),
                            )
                          ],
                        )
                    ),
                  ),
                ),
              ],
            ),
          ),
        ) : SafeArea(
          child: Center(
            child: Text(
              'Что-то пошло не так, хотя не должно было :/', style: TextStyle(
              fontSize: 30,
              fontFamily: 'Oswald',
              color: Colors.grey[400]
            ),
            )
          ),
        )
    );
  }

  _OtherUserProfileState(this.id);
}