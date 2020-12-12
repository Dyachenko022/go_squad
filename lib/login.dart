import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_squad/models/token_model1.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_squad/data/rest_api_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'models/tokens_model.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin{

  AnimationController controller;
  double _scale;
  double _scale_google;
  String email;
  String password;
  String username;

  @override
  void initState() {
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
      child: Text('Sign in',
        style: TextStyle(
          fontFamily: 'Oswald',
          fontSize: 30,
          color: Colors.white,
          letterSpacing: 1.5,
        ),
      ),
    ),
  );

  void onTapDown(TapDownDetails tapDownDetails)
  {
    controller.forward();
  }

  void onTapUp(TapUpDetails tapUpDetails) async
  {
    controller.reverse();
    showDialog(context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: SpinKitChasingDots(
              color: Colors.green[400],
              size: 30,
            ),
          );
        }
    );
    final response = await Provider.of<RestApiService>(context, listen: false).
    logUserIn({'username' : username, 'password' : password});
    print(response.body);
    final prefs = await SharedPreferences.getInstance();
    var tokens = response.body;
    print('${tokens.tokens.accessToken} ${tokens.tokens.refreshToken}');
    await prefs.setString('accessToken', tokens.tokens.accessToken);
    await prefs.setString('refreshToken', tokens.tokens.refreshToken);
    Navigator.pop(context);
    Navigator.popAndPushNamed(context, '/');
  }

  void onTapCancel()
  {
    controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - controller.value;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('GoSquad',
                style: TextStyle(
                    fontFamily:'Oswald',
                    fontSize: 20,
                    letterSpacing: 2,
                    color: Colors.grey[400]
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height/9,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: TextField(
                  style: TextStyle(
                    color: Colors.grey[400],
                  ),
                  onChanged: (String username)
                  {
                    this.username = username;
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
                      prefixIcon: Icon(Icons.person_outline, color: Colors.grey[400],
                      ),
                      hintText: "Username" ,
                      hintStyle: TextStyle(
                          color: Colors.grey[400]
                      ),
                      filled: true,
                      fillColor: Colors.grey[850]
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height/20,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: TextField(
                  style: TextStyle(
                    color: Colors.grey[400],
                  ),
                  onChanged: (String password)
                  {
                    this.password = password;
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
                      prefixIcon: Icon(Icons.enhanced_encryption, color: Colors.grey[400],
                      ),
                      hintText: "password" ,
                      hintStyle: TextStyle(
                          color: Colors.grey[400]
                      ),
                      filled: true,
                      fillColor: Colors.grey[850]
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height/20,
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height/15,
              ),
              GestureDetector(
                  onTapDown: onTapDown,
                  onTapUp: onTapUp,
                  onTapCancel: onTapCancel,
                  child: Transform.scale(
                    scale: _scale,
                    child: _animatedButtonUi,
                  )
              ),
              SizedBox(
                height: 10,
              ),
              RichText(
                  text: TextSpan(
                      style: TextStyle(color: Colors.grey[400]),
                      children: <TextSpan> [
                        TextSpan(text: 'Do not have an account yet? '),
                        TextSpan(
                            text: 'Sign up',
                            style: TextStyle(color: Colors.green[400]),
                            recognizer: TapGestureRecognizer()..onTap = ()
                            {
                              Navigator.popAndPushNamed(context, '/register');
                            }..onTapCancel = () {}
                        )
                      ]
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

