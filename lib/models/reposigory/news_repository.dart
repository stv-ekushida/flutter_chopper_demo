import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chopper_demo/data/newwork_status.dart';
import 'package:flutter_chopper_demo/data/searchtype.dart';
import 'package:flutter_chopper_demo/models/db/dao.dart';
import 'package:flutter_chopper_demo/models/networking/api_service.dart';
import 'package:flutter_chopper_demo/models/news_model.dart';
import 'package:flutter_chopper_demo/utils/extensions.dart';

class NewsRepository extends ChangeNotifier {
  final ApiService _apiService;
  final NewsDao _dao;

  NewsRepository({dao, apiService})
      : _apiService = apiService,
        _dao = dao;

  List<Article> _articles = List();
  List<Article> get articles => _articles;

  NetworkStatus _status = NetworkStatus.NONE;
  NetworkStatus get status => _status;

  Future<void> getNews(
      {@required SearchType searchType,
      String keyword,
      String category}) async {
    Response response;

    _status = NetworkStatus.LOADING;
    notifyListeners();

    try {
      switch (searchType) {
        case SearchType.CATEGORY:
          response = await _apiService.getCategoryNews();
          break;
        case SearchType.HEAD_LINE:
          response = await _apiService.getHeadLine();
          break;
        case SearchType.KEYWORD:
          response = await _apiService.getKeyword(keyword: keyword);
          break;
      }

      if (response.isSuccessful) {
        final responseBody = response.body;
        await insertAndReadFromDB(responseBody);
      } else {
        final errorCode = response.statusCode;
        final error = response.error;
        print("response is not successful : $errorCode");
        print("error info. $error");

        //エラーのときも、DBの値を表示しておく
        final articleEntities = await _dao.articleFromDB;
        _articles = articleEntities.toArticles(articleEntities);

        if (errorCode == 400) {
          _status = NetworkStatus.SESSION_TIMEOUT;
        } else {
          _status = NetworkStatus.FAILURE;
        }
      }
    } on Exception catch (_) {
      _status = NetworkStatus.FAILURE;
    } finally {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _apiService.dispose();
  }

  Future<void> insertAndReadFromDB(responseBody) async {
    final articles = News.fromJson(responseBody).articles;

    final articleEntities = await _dao
        .insertAndReadNewsFromDB(articles.toArticleEntities(articles));

    _articles = articleEntities.toArticles(articleEntities);
    _status = NetworkStatus.SUCCESS;
  }
}
