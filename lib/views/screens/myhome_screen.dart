import 'package:flutter/material.dart';
import 'package:flutter_chopper_demo/data/newwork_status.dart';
import 'package:flutter_chopper_demo/data/searchtype.dart';
import 'package:flutter_chopper_demo/viewmodels/newslist_viewmodel.dart';
import 'package:flutter_chopper_demo/views/compornents/article_tile.dart';
import 'package:provider/provider.dart';

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
            builder: (context, viewModel, child) {
              return _afterNewsAPI(viewModel);
            },
          ),
        ));
  }

  _fetchNews() {
    final viewModel = Provider.of<NewsListViewModel>(context, listen: false);

    if (viewModel.status != NetworkStatus.LOADIND &&
        viewModel.articles.isEmpty) {
      Future(() => viewModel.getNews(searchType: SearchType.HEAD_LINE));
    }
  }

  Widget _afterNewsAPI(NewsListViewModel viewModel) {
    switch (viewModel.status) {
      case NetworkStatus.LOADIND:
        return Center(child: CircularProgressIndicator());

      case NetworkStatus.SESSION_TIMEOUT:
        Future.delayed(Duration(milliseconds: 1000))
            .then((_) => openDialog(title: "警告", msg: "セッションタイムアウト"));
        continue newsList;

      case NetworkStatus.FAIRIE:
        Future.delayed(Duration(milliseconds: 1000))
            .then((_) => openDialog(title: "警告", msg: "その他のエラー"));
        continue newsList;

      newsList:
      default:
        return ListView.builder(
            itemCount: viewModel.articles.length,
            itemBuilder: (context, int position) => ArticleTile(
                article: viewModel.articles[position],
                onArticleClicked: (article) =>
                    _openArticleWebPage(article, context)));
    }
  }

  _openArticleWebPage(article, BuildContext context) {}

  openDialog({String title, String msg}) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: Text(msg),
          actions: <Widget>[
            FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                  //do something
                }),
          ],
        );
      },
    );
  }
}
