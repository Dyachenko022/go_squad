import 'package:flutter/material.dart';
import 'package:go_squad/create_profile.dart';
import 'package:go_squad/finish_registration.dart';
import 'package:go_squad/register.dart';
import 'package:go_squad/data/rest_api_service.dart';
import 'package:go_squad/home_page.dart';
import 'package:go_squad/login.dart';
import 'dart:async';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => RestApiService.create(),
      dispose: (_, RestApiService service) => service.client.dispose(),
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/' : (context) => HomePage(),
          '/register' : (context) => Register(),
          '/login' : (context) => Login(),
          '/createProfile' : (context) => FinishRegistration(),
        },
      ),
    );
  }
}





