import 'package:flutter_chopper_demo/models/networking/api_service.dart';
import 'package:flutter_chopper_demo/models/reposigory/news_repository.dart';
import 'package:flutter_chopper_demo/viewmodels/newslist_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> globalProviders = [
  ...independentModels,
  ...dependentModels,
  ...viewModels
];

List<SingleChildWidget> independentModels = [
  Provider<ApiService>(
    create: (_) => ApiService.create(),
    dispose: (_, apiService) => apiService.dispose(),
  ),
];

List<SingleChildWidget> dependentModels = [
  ProxyProvider<ApiService, NewsRepository>(
    update: (_, apiService, repository) =>
        NewsRepository(apiService: apiService),
  )
];

List<SingleChildWidget> viewModels = [
  ChangeNotifierProvider<NewsListViewModel>(
    create: (context) => NewsListViewModel(
      repository: Provider.of<NewsRepository>(context, listen: false),
    ),
  )
];
