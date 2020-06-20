// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

class _$ApiService extends ApiService {
  _$ApiService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  final definitionType = ApiService;

  Future<Response> getHeadLine(
      {String country = "jp",
      int pageSize = 10,
      String apiKey = ApiService.API_KEY}) {
    final $url = '/top-headlines';
    final Map<String, dynamic> $params = {
      'country': country,
      'pageSiz': pageSize,
      'apiKey': apiKey
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getKeyword(
      {String country = "jp",
      int pageSize = 30,
      String keyword,
      String apiKey = ApiService.API_KEY}) {
    final $url = '/top-headlines';
    final Map<String, dynamic> $params = {
      'country': country,
      'pageSize': pageSize,
      'q': keyword,
      'apiKey': apiKey
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getCategoryNews(
      {String country = "jp",
      int pageSize = 30,
      String category,
      String apiKey = ApiService.API_KEY}) {
    final $url = '/top-headlines';
    final Map<String, dynamic> $params = {
      'country': country,
      'pageSize': pageSize,
      'category': category,
      'apiKey': apiKey
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }
}
