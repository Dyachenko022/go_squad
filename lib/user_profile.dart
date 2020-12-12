import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_squad/data/rest_api_service.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> with SingleTickerProviderStateMixin {

  AnimationController controller;
  File imageFile;
  var accessToken;
  double _scale;
  bool hasProfile = false;
  bool isLoading = false;
  var userProfile;

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
      child: Text('Создать профиль',
        style: TextStyle(
          fontFamily: 'Oswald',
          fontSize: 30,
          color: Colors.white,
          letterSpacing: 1,
        ),
      ),
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
        ) : hasProfile ? Column(
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

                        ) : Image.network(userProfile.user.avatar),
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
          ],
        ) : SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Профиль пользователя был загружен неправильно',
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
}