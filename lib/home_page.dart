import 'package:flutter/material.dart';
import 'package:go_squad/data/rest_api_service.dart';
import 'package:go_squad/navigation_bar_destinations/chat.dart';
import 'package:go_squad/navigation_bar_destinations/create_game.dart';
import 'package:go_squad/navigation_bar_destinations/home.dart';
import 'package:go_squad/navigation_bar_destinations/profile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_squad/data/rest_api_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{

  int _currentIndex = 0;
  double _iconSize = 25;
  String accessToken;
  double _iconSizePressed = 20;

  var posts;


   _resetLoggedIn() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
  }


  Future<void> setAccessToken() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken =  prefs.getString('accessToken');
  }

  void autoLogIn() async
  {
    await setAccessToken();
    if(accessToken == null || accessToken == '')
      {
        Navigator.popAndPushNamed(context, '/register');
      }
    else{
      await loadPosts();
    }
  }

  Future<void> loadPosts() async{
    final response = await Provider.of<RestApiService>(context, listen: false).
    loadPosts(accessToken);
    posts = response.body;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    autoLogIn();
  }

  final tabs = [
    Home(),
    CreateGame(),
    Chat(),
    Profile(),
  ];
  int numberOfTabs = 4;




  Widget buildNavBarItem(IconData icon, int index)
  {
    return GestureDetector(
      onTap: (){
        setState(() {
          _currentIndex = index;

        });
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width/numberOfTabs,

        decoration: BoxDecoration(),
        child: Icon(icon,
          color: index == _currentIndex ? Colors.green[400] : Colors.grey[400],
          size: index == _currentIndex ? _iconSizePressed : _iconSize,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Colors.grey[900],
      body: IndexedStack(
        index: _currentIndex,
        children: tabs,
      ),
     bottomNavigationBar: Container(
       decoration: BoxDecoration(
         color: Colors.grey[900],
         boxShadow: [
           BoxShadow(
             color: Colors.grey[400],
           ),
         ],
       ),
       child: Row(
         children: [
           buildNavBarItem(Icons.home, 0),
           buildNavBarItem(Icons.gamepad, 1),
           buildNavBarItem(Icons.person_add, 2),
           buildNavBarItem(Icons.person, 3),
         ],
       ),
     ),
    );
  }
}
