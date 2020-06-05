import 'package:flutter/material.dart';
import 'package:flutter_chopper_demo/data/searchtype.dart';
import 'package:flutter_chopper_demo/viewmodels/newslist_viewmodel.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<NewsListViewModel>(create: (context) => NewsListViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AAA'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:() {
          _fetch();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _fetch() {
      final viewModel = Provider.of<NewsListViewModel>(context, listen: false);
      viewModel.getNews(searchType: SearchType.HEAD_LINE, );

  }
}
