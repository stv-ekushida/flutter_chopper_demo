// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

News _$NewsFromJson(Map<String, dynamic> json) {
  return News(
    articles: (json['articles'] as List)
        ?.map((e) =>
            e == null ? null : Article.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$NewsToJson(News instance) => <String, dynamic>{
      'articles': instance.articles,
    };

Article _$ArticleFromJson(Map<String, dynamic> json) {
  return Article(
    title: json['title'] as String,
    description: json['description'] as String,
    url: json['url'] as String,
    urlImage: json['urlImage'] as String,
    publishDate: json['publishedAt'] as String,
    content: json['content'] as String,
  );
}

Map<String, dynamic> _$ArticleToJson(Article instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'url': instance.url,
      'urlImage': instance.urlImage,
      'publishedAt': instance.publishDate,
      'content': instance.content,
    };
