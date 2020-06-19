import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chopper_demo/data/searchtype.dart';
import 'package:flutter_chopper_demo/models/db/dao.dart';
import 'package:flutter_chopper_demo/models/db/database.dart';
import 'package:flutter_chopper_demo/models/networking/api_service.dart';
import 'package:flutter_chopper_demo/models/news_model.dart';
import 'package:flutter_chopper_demo/utils/extensions.dart';

class NewsRepository {
  final ApiService _apiService;
  final NewsDao _dao;

  NewsRepository({dao, apiService})
      : _apiService = apiService,
        _dao = dao;

  Future<List<Article>> getNews(
      {@required SearchType serchType, String keyword, String category}) async {
    List<Article> result = List<Article>();
    Response response;

    try {
      switch (serchType) {
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
        result = await insertAndReadFromDB(responseBody);
      } else {
        final errorCode = response.statusCode;
        print("response is not successful : $errorCode");
      }
    } on Exception catch (error) {
      print(error);
    }
    return result;
  }

  void dispose() {
    _apiService.dispose();
  }

  Future<List<Article>> insertAndReadFromDB(responseBody) async {
    final articles = News.fromJson(responseBody).articles;

    final articleEntities = await _dao
        .insertAndReadNewsFromDB(articles.toArticleEntities(articles));

    return articleEntities.toArticles(articleEntities);
  }
}
