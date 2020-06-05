# flutter_chopper_demo

## Chopperの導入方法

### ①パッケージの追加

```
dependencies:
  flutter:
    sdk: flutter

  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^0.1.2
  chopper: ^2.0.0
  json_annotation: ^3.0.1
  provider: ^4.0.4


dev_dependencies:
  flutter_test:
    sdk: flutter

  build_runner: ^1.0.0
  chopper_generator: ^2.0.0
  json_serializable: ^3.3.0
```

### ②API Serviceの抽象クラスの作成

```
import 'package:chopper/chopper.dart';

part 'api_service.chopper.dart';

@ChopperApi()
abstract class ApiService extends ChopperService{

  //追加<S>
  @Get(path: '/top-headlines')
  Future<Response> getHeadLine({
    @Query('country') String country = "jp",
    @Query('pageSiz') int pageSize = 10,
    @Query('apiKey') String apiKey = ApiService.API_KEY,
    });

    @Get(path: 'top-headlines')
    Future<Response> getKeyword({
      @Query("country") String country = "jp",
      @Query('pageSize') int pageSize = 30,
      @Query('q') String keyword,
      @Query('apiKey') String apiKey = ApiService.API_KEY,
    });

    @Get(path: 'top-headlines')
    Future<Response> getCategoryNews({
      @Query("country") String country = "jp",
      @Query('pageSize') int pageSize = 30,
      @Query('category') String category,
      @Query('apiKey') String apiKey = ApiService.API_KEY,
    });
    //追加<E>
}
```
### ③flutterコマンドでコード生成

```
flutter packages pub run build_runner build
```

### ④ファクトリメソッドの追加

```
import 'package:chopper/chopper.dart';

part 'api_service.chopper.dart';

@ChopperApi()
abstract class ApiService extends ChopperService{

  //追加<S>
  static const BASE_URL = "http://newsapi.org/v2";
  static const API_KEY = "fd8bbb2658184db4992c16ce15b493a0";

  static ApiService create() {
    final client = ChopperClient(
      baseUrl: BASE_URL,
      services: [
        _$ApiService()
      ],
      converter: JsonConverter()
    );
    return _$ApiService(client);
  }
  //追加<E>

  @Get(path: '/top-headlines')
  Future<Response> getHeadLine({
    @Query('country') String country = "jp",
    @Query('pageSiz') int pageSize = 10,
    @Query('apiKey') String apiKey = ApiService.API_KEY,
    });

    @Get(path: 'top-headlines')
    Future<Response> getKeyword({
      @Query("country") String country = "jp",
      @Query('pageSize') int pageSize = 30,
      @Query('q') String keyword,
      @Query('apiKey') String apiKey = ApiService.API_KEY,
    });

    @Get(path: 'top-headlines')
    Future<Response> getCategoryNews({
      @Query("country") String country = "jp",
      @Query('pageSize') int pageSize = 30,
      @Query('category') String category,
      @Query('apiKey') String apiKey = ApiService.API_KEY,
    });
}
```

### ⑤レスポンス用のクラスの設定

```
import 'package:json_annotation/json_annotation.dart';

part 'news_model.g.dart';

@JsonSerializable()
class News {
  final List<Article> articles;
  News({this.articles});

  factory News.fromJson(Map<String, dynamic> json) => _$NewsFromJson(json);
  Map<String, dynamic> toJson() => _$NewsToJson(this);
}

@JsonSerializable()
class Article {
  final String title;
  final String description;
  final String url;
  final String urlImage;
  @JsonKey(name: "publishedAt") final String publishDate;
  final String content;

  Article({this.title, this.description, this.url, this.urlImage, this.publishDate, this.content});

  factory Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);
  Map<String, dynamic> toJson() => _$ArticleToJson(this);

}
```

### ⑥flutterコマンドでコード生成

```
flutter packages pub run build_runner build
```

### ⑦レスポンス処理の追加

```
import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chopper_demo/data/searchtype.dart';
import 'package:flutter_chopper_demo/models/networking/api_service.dart';
import 'package:flutter_chopper_demo/models/news_model.dart';

class NewsRepository {

  //追加
  final ApiService _apiService = ApiService.create();

  Future<List<Article>> getNews({@required SearchType serchType, String keyword, String category}) async {

    //追加<S>
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
    //追加<E>    
  }

  void dispose() {
    _apiService.dispose();
  }
}
```






