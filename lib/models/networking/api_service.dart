

import 'package:chopper/chopper.dart';

part 'api_service.chopper.dart';

@ChopperApi()
abstract class ApiService extends ChopperService{
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