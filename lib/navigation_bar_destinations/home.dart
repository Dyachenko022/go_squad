import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:math' as math;

import 'package:go_squad/data/rest_api_service.dart';
import 'package:go_squad/post_comments.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  Image image;
  Image thumbnail;
  String accessToken;
  String refreshToken;
  String comment;
  var posts;
  var post;
  var kbVisibility;

  _resizeImage(Image image, double height)
  {
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
      child: Text('к комментариям',
        style: TextStyle(
          fontFamily: 'Oswald',
          fontSize: 30,
          color: Colors.white,
          letterSpacing: 1,
        ),
      ),
    ),
  );

  Future<void> loadPost(int index) async
  {
    showDialog(context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: Dialog(
                backgroundColor:Colors.transparent,
                child: SpinKitChasingDots(
                  color: Colors.green[400],
                  size: 30,
                )
            ),
          );
        });
    final response = await Provider.of<RestApiService>(context, listen: false).loadPost(posts[index].id, accessToken);
      post = response.body;
      print(post.title);
      Navigator.pop(context);
      showDialog(context: context,
      barrierDismissible: false,
      builder:  (context) {
        return  PostDialog(post);
    });
    if(post == null)
      {
        print('fail');
      }
  }

  Future<void> loadPosts()
  async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('accessToken');
    print(accessToken);
    refreshToken = prefs.getString('refreshToken');
    final response = await Provider.of<RestApiService>(context, listen: false).
    loadPosts(accessToken);
    print(response);
    if(response.statusCode != 401)
      {
        setState(() {
          posts = response.body;
        });
      }else
        {
          print('unauthorized');
        }
  }
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    image = Image.asset('assets/gamepad.png',
    fit: BoxFit.cover,);
    loadPosts();
  }
  nested() {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
        return <Widget> [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height/2.5,
            floating: true,
            pinned: true,
            backgroundColor: Colors.grey[900],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text('Доступные лобби',
                style: TextStyle(
                  shadows: [
                    Shadow(
                      blurRadius: 7.5,
                      color: Colors.black,
                    )
                  ],
                  fontFamily: 'Oswald',
                  letterSpacing: 1.5,
                  color: Colors.grey[300],
                  fontSize: 16
                ),
              ),
              //background: SafeArea(child: image),
              background: SafeArea(child: ClipPath(
                clipper: MyClipper(),
                child: Container(
                  height: MediaQuery.of(context).size.height/3.5,
                  decoration: BoxDecoration(
                      color: Colors.green[400]
                  ),
                  child: image,
                ),
              )
              ),
            ),
          ),
          /*SliverList(
            delegate: SliverChildBuilderDelegate((context, index) => ListTile(
              title: Text('List item $index'),
            ),
            ),
          )*/
        ];
      },
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
          ),
          Expanded(
            child: Theme(
              data: Theme.of(context).copyWith(accentColor: Colors.green[400],
              ),
              child: posts != null ? ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: posts.length,
                itemBuilder: (context, index) => GestureDetector(
                  child: Container(
                    child: buildListViewCard1(context, index)
                  ),
                  // TODO: do the onTap() dialog with index
                  onTap: () {
                    loadPost(index);
                  },
                ),
              ) : Center(
                child: SpinKitChasingDots(
                  size: 30,
                  color: Colors.green[400],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Card buildAdCard(context, index) => Card(
    child: Text('Hello that is an ad $index'),
  );

  Card buildListViewCard1(context, index) => Card(
    color: Colors.grey[800],
    child: Column(
      children: [
        SizedBox(height: 8,),
        Row(
          children: [
            SizedBox(width: 10,),
            posts[index].avatar != null ? Image.network(posts[index].avatar,
            fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height/20,
              width: MediaQuery.of(context).size.height/20,
            ) : Image.network('https://gravatar.com/avatar/d2486fcf29a4f046af3086770549f1a4?d=mm&r=pg&s=200',
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height/20,
              width: MediaQuery.of(context).size.height/20,
            ),
            SizedBox(width: 10,),
            Text(posts[index].title,
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Oswald',
                  letterSpacing: 1,
                  color: Colors.grey[300]
              ),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Center(
          child: posts[index].text != null ? Text(
            posts[index].text,
            style: TextStyle(
                fontSize: 15,
                fontFamily: 'Oswald',
                letterSpacing: 1,
                color: Colors.grey[300]
            ),
          ) : Text(
            'Нет описания',
            style: TextStyle(
                fontSize: 15,
                fontFamily: 'Oswald',
                letterSpacing: 1,
                color: Colors.grey[300]
            ),
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    )
  );
  Card buildListViewCard(context, index) => Card(
    child: Column(
      children: [
        SizedBox(
          height: 8,
        ),
        Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Icon(Icons.person,
              color: Colors.green[400],
              size: MediaQuery.of(context).size.height/10,
            ),
            Text('Title $index',
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Oswald',
                  letterSpacing: 1,
                  color: Colors.grey[300]
              ),
            ),
          ],
        ),
        SizedBox(
          height: 4,
        ),

        Image.asset('assets/samurais.png',fit: BoxFit.cover,
        height: MediaQuery.of(context).size.height/4,
        ),
        SizedBox(
          height: 8,
        ),
        Text('Looking for a few players to play some games with',
        style: TextStyle(
          fontFamily: 'Oswald',
          fontSize: 14,
          color: Colors.grey[300]
        ),
        ),
        SizedBox(
          height: 8,
        ),

        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width/1.3,
            ),
            Text('0/10',
              style: TextStyle(
                  fontFamily: 'Oswald',
                  fontSize: 14,
                  color: Colors.grey[300]
              ),
            )
          ],
        ),
        SizedBox(
          height: 8,
        ),
      ],
    ),
    color: Colors.grey[900],
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
     child: Scaffold(
      backgroundColor: Colors.grey[900],
      body: nested()
    )
    );
  }
}

class PostDialog extends StatefulWidget {
  var post;


  PostDialog(this.post);

  @override
  _PostDialogState createState() => _PostDialogState(post);
}

class _PostDialogState extends State<PostDialog> {
  var post;
  _PostDialogState(this.post);
  String comment;
  bool isKbVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {
        isKbVisible = visible;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible)
      {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            setState(() {

            });
          },
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.only(
                      top: 70,
                      bottom: 16,
                      left: 16,
                      right: 16
                  ),
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                      color: Colors.grey[800],
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            blurRadius: 10,
                            offset: Offset(0,10)
                        )
                      ]
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 20,),
                      Text(post.title, style: TextStyle(
                          fontSize: 30,
                          letterSpacing: 1.5,
                          color: Colors.grey[400]
                      ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10, top: 10),
                        padding: EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.grey[700],
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        height: 200,
                        child: Center(
                          child: Text(post.text,
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey[400]
                            ),
                          ),
                        )
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => PostComments(postId: post.id),
                          ));
                        },
                        child: Container(
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
                            child: Text('к комментариям',
                              style: TextStyle(
                                fontFamily: 'Oswald',
                                fontSize: 30,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.bottomLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                                child: IconButton(
                                  color: Colors.green[400],
                                  icon: Icon(Foundation.like,
                                    color: Colors.green[400],
                                    size: 40,),
                                  onPressed: () {

                                  },
                                ),
                              ),
                              IconButton(
                                color: Colors.green[400],

                                icon: Icon(Foundation.dislike,
                                  color: Colors.green[400],
                                  size: 40,),
                                onPressed: () {

                                },
                              ),
                            ],
                          )
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 16,
                  right: 16,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[800],
                    child: ClipOval(
                      child: Image.network(post.avatar != null ? post.avatar : 'https://gravatar.com/avatar/d2486fcf29a4f046af3086770549f1a4?d=mm&r=pg&s=200',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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