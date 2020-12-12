import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_squad/data/rest_api_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/post_model.dart';

class PostComments extends StatefulWidget {
  String postId;
  PostComments({Key key, @required this.postId}) : super(key : key);
  @override
  _PostCommentsState createState() => _PostCommentsState(postId);
}

class _PostCommentsState extends State<PostComments> {


  String postId;
  String accessToken;
  var post;
  String text;
  List<Comment> comments;
  int listSize;
  String username;
  int oldLength;
  bool isLoading = false;
  //var scrollController = ScrollController();

  _PostCommentsState(this.postId);

  final GlobalKey<AnimatedListState> key = GlobalKey();

  Future<void>loadPost() async{
    isLoading = true;
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('accessToken');
    final response1 = await Provider.of<RestApiService>(context, listen: false).loadMyProfile(accessToken);
    if(response1.statusCode == 200)
      {
        username = response1.body.user.username;
      }
    final response = await Provider.of<RestApiService>(context, listen: false).loadPost(postId, accessToken);
    if(response.statusCode == 200)
      {
        setState(() {
          post = response.body;
          Iterable inReverse = response.body.comments.reversed;
          comments = inReverse.toList();
          //scrollController.jumpTo(scrollController.offset + comments.length * 50);
          isLoading = false;
          listSize = comments.length == null ? 0 : comments.length;
          updateComments();
        });
      }
    else{
      print('something went wrong');
    }
  }

  Future<void> postComment() async {
    final response = await Provider.of<RestApiService>(context, listen: false).createComment(accessToken, postId, {"text" : text});
    if(response.statusCode == 200)
      {
        print('comment sent ${response.body[0].text}');
      }
    else {
      print('failed to send');
    }
  }

  Future<void> updateComments() async {
    var response = await Provider.of<RestApiService>(context, listen: false).loadPost(postId, accessToken);
    if(response.statusCode == 200)
      {
        if(response.body.comments.length > comments.length)
          {
            oldLength = comments.length;
            Iterable inReverse = response.body.comments.reversed;
            comments = inReverse.toList();

            /*for(int i = comments.length; i < response.body.comments.length; i++)
              {
                print(response.body.comments[0].text);
                comments.add(response.body.comments[i]);
                //key.currentState.insertItem(i);
              */
          }
        setState(() {
         // scrollController.jumpTo( scrollController.offset + 50 * (comments.length - oldLength));
        });
      }
    await Future.delayed(Duration(seconds: 2));
    updateComments();
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadPost();
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Theme(
        data: Theme.of(context).copyWith(accentColor: Colors.green[400],
        ),
        child: isLoading ? Scaffold(
          backgroundColor: Colors.grey[900],
          body: Center(
            child: SpinKitChasingDots(
              size: 30,
              color: Colors.green[400],
            ),
          ),
        ) : Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green[400],
            centerTitle: true,
            title: Text(post.title),
          ),
          backgroundColor: Colors.grey[900],
          bottomNavigationBar: BottomAppBar(
            color: Colors.grey[900],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  width: MediaQuery.of(context).size.width*0.8,
                  child: TextField(
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
                        hintText: "Комментарий" ,
                        hintStyle: TextStyle(
                            color: Colors.grey[400]
                        ),
                        filled: true,
                        fillColor: Colors.grey[850]
                    ),
                  ),
                ),
                SizedBox(width: 8,),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.green[400],),
                  onPressed: () {
                    postComment();
                  },
                )
              ],
            ),
          ),
          body: ListView.builder(
            itemCount: comments.length,
            shrinkWrap: true,
            itemBuilder: (context, index) => Card(
            color: username == comments[index].username ? Colors.green[400] : Colors.grey[800],
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    comments[index].username,
                    style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 25,
                        fontFamily: 'Oswald'
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(comments[index].text, style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 17,
                      fontFamily: 'Oswald'
                  ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    comments[index].date.toIso8601String(),
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontFamily: 'Oswald'
                    ),
                  ),
                )
              ],
            ),
          ),
          )
          /*SingleChildScrollView(
            child: Column(
              children: [


                /*AnimatedList(
                  key: key,
                  initialItemCount: comments.length == null ? 0 : comments.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,

                  itemBuilder: (context, index, animation) => SizeTransition(
                    sizeFactor: animation,
                    child:
                  ),
                ),*/
              ],
            ),
          ),*/
        ),
      ),
    );
  }
}
