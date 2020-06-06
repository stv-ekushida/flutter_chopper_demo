import 'package:flutter/material.dart';
import 'package:flutter_chopper_demo/data/searchtype.dart';
import 'package:flutter_chopper_demo/viewmodels/newslist_viewmodel.dart';
import 'package:flutter_chopper_demo/views/compornents/article_tile.dart';
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
    _fetchNews();

    return Scaffold(
      appBar: AppBar(
        title: Text('News'),
      ),
      body: Container(
        child: Consumer<NewsListViewModel>(
          builder: (context, model, child) {
            return model.isLoading ? Center(child: CircularProgressIndicator()) : 
            ListView.builder(itemCount: model.articles.length,
            itemBuilder: (context, int postion) => ArticleTile(
              article: model.articles[postion],
              onArticleClicked: (article) => _openArticleWebPage(article, context))
            );
          },
        ),
      )
    );
  }

  _fetchNews() {
    final viewModel = Provider.of<NewsListViewModel>(context, listen: false);

    if(!viewModel.isLoading && viewModel.articles.isEmpty) {
      Future(() => viewModel.getNews(searchType: SearchType.HEAD_LINE));
    }

  }

  _openArticleWebPage(article, BuildContext context) {

  }
}
