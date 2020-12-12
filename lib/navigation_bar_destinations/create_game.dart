import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_squad/data/rest_api_service.dart';
import 'package:provider/provider.dart';
import 'package:go_squad/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateGame extends StatefulWidget {
  @override
  _CreateGameState createState() => _CreateGameState();
}

class _CreateGameState extends State<CreateGame> with SingleTickerProviderStateMixin {

  String title;
  String text;
  double _scale;
  String accessToken;
  AnimationController controller;
  var userProfile;


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
      'title' : title,
      'text' : text,
    };
    print(body);
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('accessToken');
    print(accessToken);
    final response = await Provider.of<RestApiService>(context, listen: false).createPost(accessToken, body);
    if(response.statusCode == 200)
    {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
    }
    else {
      Navigator.pop(context);
      print('Post creation went wrong');
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
      child: Text('Создать пост',
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

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('accessToken');
    final response = await Provider.of<RestApiService>(context, listen: false).loadMyProfile(accessToken);
    if(response.statusCode == 200)
      {
        userProfile = response.body;
      }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //loadUserData();
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
      body: Theme(
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
                      color: Colors.green[400],
                  ),
                  child: Center(
                    child: Text('Создание поста', style: TextStyle(
                      fontFamily: 'Oswald',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[400],
                      letterSpacing: 2
                    ),
                    )
                  ),
                ),
              ),
              SizedBox(height: 80),
              TextField(
                style: TextStyle(
                  color: Colors.grey[400],
                ),
                onChanged: (String title)
                {
                  this.title = title;
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
                    hintText: "Заголовок поста" ,
                    hintStyle: TextStyle(
                        color: Colors.grey[400]
                    ),
                    filled: true,
                    fillColor: Colors.grey[850]
                ),
              ),
              SizedBox(height: 8,),
              TextField(
                style: TextStyle(
                  color: Colors.grey[400],
                ),
                onChanged: (String text)
                {
                  this.text = text;
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
                    hintText: "Описание поста" ,
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
                onTapCancel: onTapCancel,
                onTapDown: onTapDown,
                onTapUp: onTapUp,
                child: Transform.scale(scale: _scale, child: _animatedButtonUi,),
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      )
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