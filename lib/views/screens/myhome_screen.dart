import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/searchtype.dart';
import '../../viewmodels/newslist_viewmodel.dart';
import '../compornents/article_tile.dart';

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
              return model.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: model.articles.length,
                      itemBuilder: (context, int postion) => ArticleTile(
                          article: model.articles[postion],
                          onArticleClicked: (article) =>
                              _openArticleWebPage(article, context)));
            },
          ),
        ));
  }

  _fetchNews() {
    final viewModel = Provider.of<NewsListViewModel>(context, listen: false);

    if (!viewModel.isLoading && viewModel.articles.isEmpty) {
      Future(() => viewModel.getNews(searchType: SearchType.HEAD_LINE));
    }
  }

  _openArticleWebPage(article, BuildContext context) {}
}
