import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_squad/data/rest_api_service.dart';
import 'package:go_squad/navigation_bar_destinations/other_user_profile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}



class _ChatState extends State<Chat> {

  String accessToken;
  var userProfiles;

  void loadProfile1(index) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => OtherUserProfile(id: userProfiles[index].user.id),
    ));
  }

  Future<void> loadProfile(index) async{
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
    final response = await Provider.of<RestApiService>(context, listen: false).loadSelectedUserProfile(accessToken, userProfiles[index].user.id);
    Navigator.pop(context);
    switch (response.statusCode) {
      case  200:
        {
          print(response.body.about);
          //showDialog(context: context,
          //);
          break;
        }
      case 400:
        {
          print('can not load profile');
         break;
        }
      default: {
        print('Something went wrong');
        break;
      }
    }
  }

  Future<void> loadAllProfiles() async{
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('accessToken');
    final response = await Provider.of<RestApiService>(context, listen: false).loadUsersProfile(accessToken);
    final response1 = await Provider.of<RestApiService>(context, listen: false).loadMyProfile(accessToken);
    for(int i = 0; i < response.body.length; i++)
      {
        if(response.body[i].user.id == response1.body.user.id){
          response.body.removeAt(i);
          break;
        }
      }
    setState(() {
      userProfiles = response.body;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAllProfiles();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Theme(
        data: Theme.of(context).copyWith(accentColor: Colors.green[400],
        ),
        child: Scaffold(
            backgroundColor: Colors.grey[900],
          body: userProfiles == null ? Center(
            child: SpinKitChasingDots(
              color: Colors.green[400],
              size: 30,
            )
          ) : ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: userProfiles.length,
            itemBuilder: (context, index) => GestureDetector(
              child: Container(
                child: buildChatCard(context, index),
              ),
              onTap: () {
                loadProfile1(index);
              },
            ),
          ),
        ),
      ),
    );
  }

  Card buildChatCard(context, index) => Card(
    color: Colors.grey[800],
    child: Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            SizedBox(
              width: 3,
            ),
            CircleAvatar(
              backgroundColor: Colors.grey[400],
              child: ClipOval(
                child: userProfiles[index].user.avatar == null ? Image.asset('assets/profile_icon.png', fit: BoxFit.cover, height: MediaQuery.of(context).size.width/10,) :
                Image.network(userProfiles[index].user.avatar,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width/4,),
              ),
              radius: MediaQuery.of(context).size.width/8,
            ),

            SizedBox(
              width: MediaQuery.of(context).size.width/5,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(userProfiles[index].user.username,
                  style: TextStyle(
                      fontFamily: 'Oswald',
                      fontSize: 16,
                      color: Colors.grey[300]
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(userProfiles[index].about,
                  style: TextStyle(
                      fontFamily: 'Oswald',
                      fontSize: 12,
                      color: Colors.grey[300]
                  ),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            )
          ],
        ),
        SizedBox(
          height: 10,
        )
      ],
    ),
  );
}
