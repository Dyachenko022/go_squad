import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_squad/data/rest_api_service.dart';
import 'package:go_squad/edit_profile.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {

  AnimationController controller;
  File imageFile;
  var accessToken;
  double _scale;
  bool hasProfile = false;
  bool isLoading = false;
  var userProfile;

  _openGallery() async
  {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {

    });
  }

  void onTapDown(TapDownDetails tapDownDetails)
  {
    controller.forward();
  }

  void onTapCancel()
  {
    controller.reverse();
  }

  void onTapUp(TapUpDetails tapUpDetails) {
    controller.reverse();
    Navigator.pushNamed(context, '/createProfile');
  }

  Widget get _animatedButtonUi => Container(
    height: MediaQuery.of(context).size.height/11,
    width: MediaQuery.of(context).size.width/1.1,
    decoration: BoxDecoration(
      color: Colors.green[400],
      borderRadius: new BorderRadius.all(const Radius.circular(10)),
      boxShadow:  [
        BoxShadow(
            color: Colors.black,
            offset: Offset(4.0, 3.0),
            blurRadius: 15,
            spreadRadius: 1
        ),
        BoxShadow(
            color: Colors.grey[800],
            offset: Offset(-4.0, -4.0),
            blurRadius: 15,
            spreadRadius: 1
        ),
      ],
    ),
    child: Center(
      child: hasProfile ? Text('Редактировать профиль',
        style: TextStyle(
          fontFamily: 'Oswald',
          fontSize: 30,
          color: Colors.white,
          letterSpacing: 1,
        ),
      ) : Text('Создать профиль',
        style: TextStyle(
          fontFamily: 'Oswald',
          fontSize: 30,
          color: Colors.white,
          letterSpacing: 1,
        ),
      ),
    ),
  );

  Widget get _logoutButtonUi => Container(
    height: MediaQuery.of(context).size.height/12,
    width: MediaQuery.of(context).size.width/5,
    decoration: BoxDecoration(
      color: Colors.green[400],
      borderRadius: new BorderRadius.all(const Radius.circular(10)),
      boxShadow:  [
        BoxShadow(
            color: Colors.black,
            offset: Offset(4.0, 3.0),
            blurRadius: 15,
            spreadRadius: 1
        ),
        BoxShadow(
            color: Colors.grey[800],
            offset: Offset(-4.0, -4.0),
            blurRadius: 15,
            spreadRadius: 1
        ),
      ],
    ),
    child: Center(
      child: Icon(SimpleLineIcons.logout,
      color: Colors.white,)
    ),
  );

  Future<void>loadProfile() async {
    setState(() {
      isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('accessToken');
    final response = await Provider.of<RestApiService>(context, listen: false).loadMyProfile(accessToken);
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
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 75),
      lowerBound: 0.0,
      upperBound: 0.05,
    )..addListener(() {
      setState(() {

      });
    });
  }
  @override
  Widget build(BuildContext context) {
    _scale = 1 - controller.value;
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
                          child: userProfile.user.avatar == null ? imageFile == null ? Image.asset('assets/profile_icon.png',
                          width: MediaQuery.of(context).size.height/5,
                          height: MediaQuery.of(context).size.height/5,
                          fit: BoxFit.cover,

                          ) : Image.file(imageFile,
                            width: MediaQuery.of(context).size.height/5,
                            fit: BoxFit.cover,
                            ) : Image.network(userProfile.user.avatar,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width/3,),
                        ),
                        radius: MediaQuery.of(context).size.height/10,
                      ),
                      onTap: () {
                      _openGallery();
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
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => EditProfile(),
                  ));
                },
                child: _animatedButtonUi,
              ),
              SizedBox(
                height: 10,
              ),
             Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    child: _logoutButtonUi,
                    onTap: () {
                      logout();
                    },
                  ),
                ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ) : SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('У вас пока нет личного профиля',
              style: TextStyle(
                color: Colors.grey[400],
                fontFamily: 'Oswald',
                fontSize: 20
              ),
              ),
              SizedBox(height: 8,),
              GestureDetector(
                  onTapDown: onTapDown,
                  onTapUp: onTapUp,
                  onTapCancel: onTapCancel,
                  child: Transform.scale(
                    scale: _scale,
                    child: _animatedButtonUi,
                  )
              ),
            ],
          ),
        ),
      )
    );
  }

  void logout() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('accessToken', '');
    prefs.setString('refreshToken', '');
    Navigator.popAndPushNamed(context, '/register');
  }
}
