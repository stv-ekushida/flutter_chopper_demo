import 'package:flutter/material.dart';
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

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Article> _artcles = List();
  List<Article> get articles => _artcles;

  Future<void> getNews(
      {@required SearchType searchType,
      String keyword,
      String category}) async {
    _searchType = searchType;
    _keyword = keyword;
    _category = category;

    _isLoading = true;
    notifyListeners();

    _artcles = await _repository.getNews(
        serchType: _searchType, keyword: _keyword, category: _category);
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _repository.dispose();
  }
}
