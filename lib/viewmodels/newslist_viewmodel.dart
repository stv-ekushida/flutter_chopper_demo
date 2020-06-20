import 'package:flutter/material.dart';
import 'package:flutter_chopper_demo/data/newwork_status.dart';
import 'package:flutter_chopper_demo/data/searchtype.dart';
import 'package:flutter_chopper_demo/models/news_model.dart';
import 'package:flutter_chopper_demo/models/reposigory/news_repository.dart';

class NewsListViewModel extends ChangeNotifier {
  final NewsRepository _repository;

  NewsListViewModel({repository}) : _repository = repository;

  SearchType _searchType = SearchType.CATEGORY;
  SearchType get searchType => _searchType;

  String _keyword = "";
  String get keyword => _keyword;

  String _category = "technology";
  String get category => _category;

  NetworkStatus _status = NetworkStatus.NONE;
  NetworkStatus get status => _status;

  List<Article> _articles = List();
  List<Article> get articles => _articles;

  Future<void> getNews(
      {@required SearchType searchType,
      String keyword,
      String category}) async {
    _searchType = searchType;
    _keyword = keyword;
    _category = category;

    await _repository.getNews(
        serchType: _searchType, keyword: _keyword, category: _category);
  }

  @override
  void dispose() {
    super.dispose();
    _repository.dispose();
  }

  onRepositoryUpdated(NewsRepository repository) {
    _articles = repository.articles;
    _status = repository.status;
    notifyListeners();
  }
}
