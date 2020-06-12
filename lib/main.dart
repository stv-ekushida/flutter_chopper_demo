import 'package:flutter/material.dart';
import 'package:flutter_chopper_demo/viewmodels/newslist_viewmodel.dart';
import 'package:flutter_chopper_demo/views/screens/myhome_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<NewsListViewModel>(
            create: (context) => NewsListViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
