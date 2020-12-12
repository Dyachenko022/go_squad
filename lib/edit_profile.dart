import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_squad/data/rest_api_service.dart';
import 'package:go_squad/home_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> with SingleTickerProviderStateMixin {

  String accessToken;
  String firstname;
  String lastname;
  String location;
  String about;
  String status;
  String platform = '';
  String discord;
  double _scale;
  String youtube;
  bool isLoading = false;
  var userProfile;
  var hasProfile = false;
  AnimationController controller;
  String steam;

  setupInfo() {
    firstname = userProfile.firstname;
    lastname = userProfile.lastname;
    location = userProfile.location;
    about = userProfile.about;
    status = userProfile.status;
    for(int i = 0; i < userProfile.platform.length; i++)
      {
        i == userProfile.platform.length - 1 ?platform = platform + userProfile.platform[i] : platform = platform + userProfile.platform[i] + ', ';
      }
    discord = userProfile.social.discord;
    youtube = userProfile.social.youtube;
    steam = userProfile.social.steam;
  }

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
        setupInfo();
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

  Future<void> compileRequest() async {
    showDialog(context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: SpinKitChasingDots(
                color: Colors.green[400],
                size: 30,
              ),
            ),
          );
        }
    );
    Map<String, String> body = {
      'firstname' : firstname,
      'lastname' : lastname,
      'location' : location,
      'about' : about,
      'status': status,
      'platform' : platform,
      'discord' : discord,
      'youtube' : youtube,
      'steam' : steam
    };
    print(body);
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('accessToken');
    print(accessToken);
    final response = await Provider.of<RestApiService>(context, listen: false).createProfile(accessToken, body);
    if(response.statusCode == 200)
    {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
    }
    else {
      Navigator.pop(context);
      print('Registration went wrong');
    }
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
      child: Text('Закончить',
        style: TextStyle(
          fontFamily: 'Oswald',
          fontSize: 30,
          color: Colors.white,
          letterSpacing: 1,
        ),
      ),
    ),
  );

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
    compileRequest();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 75),
      lowerBound: 0.0,
      upperBound: 0.05,
    )..addListener(() {
      setState(() {

      });
    });
    loadProfile();
  }
  @override
  Widget build(BuildContext context) {
    _scale = 1 - controller.value;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[900],

        body: isLoading ? Center(
          child: SpinKitChasingDots(
            color: Colors.green[400],
            size: 30,
          ),
        ) : Theme(
          data: Theme.of(context).copyWith(accentColor: Colors.green[400]),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipPath(
                  clipper: MyClipper(),
                  child: Container(
                    height: MediaQuery.of(context).size.height/3.5,
                    decoration: BoxDecoration(
                        color: Colors.green[400]
                    ),
                    child: Center(
                      child: Text('Изменение профиля',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontFamily:'Oswald',
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            color: Colors.grey[400]
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                TextField(
                  controller: new TextEditingController(
                    text: firstname,
                  ),
                  style: TextStyle(
                    color: Colors.grey[400],
                  ),
                  onChanged: (String firstname)
                  {
                    this.firstname = firstname;
                  },
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey[400],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey[400],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      hintText: "Имя" ,
                      hintStyle: TextStyle(
                          color: Colors.grey[400]
                      ),
                      filled: true,
                      fillColor: Colors.grey[850]
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: new TextEditingController(
                    text: lastname,
                  ),
                  style: TextStyle(
                    color: Colors.grey[400],
                  ),
                  onChanged: (String lastname)
                  {
                    this.lastname = lastname;
                  },
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey[400],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey[400],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      hintText: "Фамилия" ,
                      hintStyle: TextStyle(
                          color: Colors.grey[400]
                      ),
                      filled: true,
                      fillColor: Colors.grey[850]
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: new TextEditingController(
                    text: location,
                  ),
                  style: TextStyle(
                    color: Colors.grey[400],
                  ),
                  onChanged: (String location)
                  {
                    this.location = location;
                  },
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey[400],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey[400],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      hintText: "Откуда я" ,
                      hintStyle: TextStyle(
                          color: Colors.grey[400]
                      ),
                      filled: true,
                      fillColor: Colors.grey[850]
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  height: 200,
                  child: TextField(
                    controller: new TextEditingController(
                      text: about,
                    ),
                    maxLines: 8,
                    style: TextStyle(
                      color: Colors.grey[400],
                    ),
                    onChanged: (String about)
                    {
                      this.about = about;
                    },
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey[400],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey[400],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(5))
                        ),

                        hintText: "Обо мне" ,
                        hintStyle: TextStyle(
                            color: Colors.grey[400]
                        ),
                        filled: true,
                        fillColor: Colors.grey[850]
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: new TextEditingController(
                    text: status,
                  ),
                  style: TextStyle(
                    color: Colors.grey[400],
                  ),
                  onChanged: (String status)
                  {
                    this.status = status;
                  },
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey[400],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey[400],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      hintText: "Статус" ,
                      hintStyle: TextStyle(
                          color: Colors.grey[400]
                      ),
                      filled: true,
                      fillColor: Colors.grey[850]
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: new TextEditingController(
                    text: platform,
                  ),
                  style: TextStyle(
                    color: Colors.grey[400],
                  ),
                  onChanged: (String platform)
                  {
                    this.platform = platform;
                  },
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey[400],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey[400],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      hintText: "Платформы" ,
                      hintStyle: TextStyle(
                          color: Colors.grey[400]
                      ),
                      filled: true,
                      fillColor: Colors.grey[850]
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: new TextEditingController(
                    text: discord,
                  ),
                  style: TextStyle(
                    color: Colors.grey[400],
                  ),
                  onChanged: (String discord)
                  {
                    this.discord = discord;

                  },
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey[400],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey[400],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      hintText: "Профиль в discord" ,
                      prefixIcon: Icon(FontAwesome5Brands.discord),
                      hintStyle: TextStyle(
                          color: Colors.grey[400]
                      ),
                      filled: true,
                      fillColor: Colors.grey[850]
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: new TextEditingController(
                    text: youtube,
                  ),
                  style: TextStyle(
                    color: Colors.grey[400],
                  ),
                  onChanged: (String youtube)
                  {
                    this.youtube = youtube;

                  },
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey[400],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey[400],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      hintText: "Профиль YouTube" ,
                      prefixIcon: Icon(FontAwesome5Brands.youtube),
                      hintStyle: TextStyle(
                          color: Colors.grey[400]
                      ),
                      filled: true,
                      fillColor: Colors.grey[850]
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: new TextEditingController(
                    text: steam,
                  ),
                  style: TextStyle(
                    color: Colors.grey[400],
                  ),
                  onChanged: (String steam)
                  {
                    this.steam = steam;
                  },
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey[400],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey[400],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      hintText: "Профиль Steam" ,
                      prefixIcon: Icon(FontAwesome5Brands.steam),
                      hintStyle: TextStyle(
                          color: Colors.grey[400]
                      ),
                      filled: true,
                      fillColor: Colors.grey[850]
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTapUp: onTapUp,
                  onTapDown: onTapDown,
                  onTapCancel: onTapCancel,
                  child: Transform.scale(child: _animatedButtonUi, scale: _scale,),
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    var path = new Path();
    path.lineTo(0, size.height-80);
    var controllPoint = Offset(20, size.height);
    var endPoint = Offset(size.width/2, size.height);
    path.quadraticBezierTo(controllPoint.dx, controllPoint.dy, endPoint.dx, endPoint.dy);
    //throw UnimplementedError();
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    //throw UnimplementedError();
    return true;
  }

}