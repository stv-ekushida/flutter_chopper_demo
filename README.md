# flutter_chopper_demo

## 1. APIクライアント(Chopper)の導入方法

### ①パッケージの追加

```
dependencies:
  flutter:
    sdk: flutter

  chopper: ^2.0.0
  json_annotation: ^3.0.1

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
      converter: JsonConverter(),
      interceptors: [
        (Request request) async {
              print("""
                =========HTTP Request logging=========
                baseUrl: ${request.baseUrl}
                url: ${request.url}
                parameter: ${request.parameters}
                method: ${request.method}
                headers: ${request.headers}
                body: ${request.body}
                multipart: ${request.multipart}
                parts: ${request.parts}
                ======================================
              """);

          return request;
        },
        (Response response) async {
          print("""
                =========HTTP Response logging=========
                url: ${response.base.request.url}
                status: ${response.statusCode}
                headers: ${response.headers}
                body: ${response.body}
                ======================================
              """);
              return response;
        }
      ]
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
  final String urlToImage;
  @JsonKey(name: "publishedAt") final String publishDate;
  final String content;

  Article({this.title, this.description, this.url, this.urlToImage, this.publishDate, this.content});

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

## 2. 状態管理(Providerの導入)

### ①パッケージの追加

```
dependencies:
  flutter:
    sdk: flutter

  provider: ^4.0.4
```

### ② ChangeNotifierの継承したクラスの生成

```
import 'package:flutter/material.dart';
import 'package:flutter_chopper_demo/data/searchtype.dart';
import 'package:flutter_chopper_demo/models/news_model.dart';
import 'package:flutter_chopper_demo/models/reposigory/news_repository.dart';

class NewsListViewModel extends ChangeNotifier {

  final NewsRepository _repository = NewsRepository();

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

  Future<void> getNews({
    @required SearchType searchType, String keyword, String category
  }) async {}

  @override
  void dispose() {
    super.dispose();
    _repository.dispose();
  }
}
```

### ③ notifyListenersで変更を通知

```
import 'package:flutter/material.dart';
import 'package:flutter_chopper_demo/data/searchtype.dart';
import 'package:flutter_chopper_demo/models/news_model.dart';
import 'package:flutter_chopper_demo/models/reposigory/news_repository.dart';

class NewsListViewModel extends ChangeNotifier {

  final NewsRepository _repository = NewsRepository();

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

  Future<void> getNews({
    @required SearchType searchType, String keyword, String category
  }) async {
    _searchType = searchType;    
    _keyword = keyword;
    _category = category;

    _isLoading = true;
    notifyListeners();

    _artcles = await _repository.getNews(serchType: _searchType, keyword: _keyword, category: _category);

    for(Article a in _artcles) {
     print(a.title);
    }

    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _repository.dispose();
  }
}
```

### ④ アプリのルートに、ChangeNotifierProviderを追加

```
import 'package:flutter/material.dart';
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
```

### ⑤ ChangeNotifierの継承したクラスのメソッドを操作

```
      final viewModel = Provider.of<NewsListViewModel>(context, listen: false);
      viewModel.getNews(searchType: SearchType.HEAD_LINE, );
 ```

## 3. 画面に表示させる

### ① ViewModel経由でAPIを呼ぶ

```
  _fetchNews() {
    final viewModel = Provider.of<NewsListViewModel>(context, listen: false);

    if(!viewModel.isLoading && viewModel.articles.isEmpty) {
      Future(() => viewModel.getNews(searchType: SearchType.HEAD_LINE));
    }

  }
```
### ②Consumerを利用して、データを取得する

```
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

  _openArticleWebPage(article, BuildContext context) {

  }
}
```

```
class ArticleTile extends StatelessWidget {

  final Article article;
  final ValueChanged onArticleClicked;

  ArticleTile({this.article, this.onArticleClicked});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () => onArticleClicked,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ImageFromUrl(imageUrl: article.urlToImage),
                ),
              ),
              Expanded(
                flex: 3,
                child: ArticleTileDescription(article: article)
              )
            ],
          ),

        ),
      ),

    );
  }
}
```

### ③flutter_advanced_networkimageを使って、サーバーから画像を取得する
パッケージに、下記を追加

```
  flutter_advanced_networkimage: ^0.7.0
```

```
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

class ImageFromUrl extends StatelessWidget {

  final String imageUrl;
  const ImageFromUrl({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    
    if(imageUrl == null) {
      return const Icon(Icons.broken_image);
    } else {
      return TransitionToImage(
        image: AdvancedNetworkImage(
          imageUrl, useDiskCache: true
        ),
        placeholder: const Icon(Icons.broken_image),
        fit: BoxFit.cover,
      );
    }
  }
}
```

### ④テキストのフォントテーマを利用する

https://api.flutter.dev/flutter/material/TextTheme-class.html

```

import 'package:flutter/material.dart';
import 'package:flutter_chopper_demo/models/news_model.dart';

class ArticleTileDescription extends StatelessWidget {

  final Article article;
  
  const ArticleTileDescription({this.article});

  @override
  Widget build(BuildContext context) {

    final textTheme = Theme.of(context).textTheme;

    var displayDesc = '';
    if(article.description != null) {
      displayDesc = article.description;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(article.title, style: textTheme.subhead.copyWith(fontWeight : FontWeight.bold)),
        Text(article.publishDate, style: textTheme.subhead.copyWith(fontStyle: FontStyle.italic)),
        Text(displayDesc),
      ]);
  }
}
```



