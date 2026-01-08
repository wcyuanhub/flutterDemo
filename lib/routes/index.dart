import 'package:flutter/material.dart';
import 'package:flutter_project/views/main/index.dart';
import 'package:flutter_project/views/login/index.dart';

Widget getRootApp() {
  return MaterialApp(
    initialRoute: "/",
    routes: _getRoutes(),
  );
}

Map<String, WidgetBuilder> _getRoutes() {
  return {
    '/': (context) => MainPage(),
    "/login": (context) => LoginPage()
  };
}
