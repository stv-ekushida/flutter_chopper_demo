

import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chopper_demo/data/searchtype.dart';
import 'package:flutter_chopper_demo/models/networking/api_service.dart';
import 'package:flutter_chopper_demo/models/news_model.dart';

class NewsRepository {

  final ApiService _apiService = ApiService.create();

  Future<List<Article>> getNews({@required SearchType serchType, String keyword, String category}) async {

    List<Article> result = List<Article>();
    Response response;

    try {
      switch(serchType) {
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

      if(response.isSuccessful) {
        final responseBody = response.body;
        result = News.fromJson(responseBody).articles;
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
}