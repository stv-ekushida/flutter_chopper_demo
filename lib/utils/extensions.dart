import 'package:flutter_chopper_demo/models/db/database.dart';
import 'package:flutter_chopper_demo/models/news_model.dart';

extension CovertToArticleEntity on List<Article> {
  List<ArticleEntity> toArticleEntities(List<Article> articles) {
    var articleEntities = List<ArticleEntity>();

    articles.forEach((article) {
      articleEntities.add(ArticleEntity(
          title: article.title ?? "",
          description: article.description ?? "",
          url: article.url,
          urlToImage: article.urlToImage,
          publishDate: article.publishDate ?? "",
          content: article.content ?? ""));
    });
    return articleEntities;
  }
}

extension CovertToArticle on List<ArticleEntity> {
  List<Article> toArticles(List<ArticleEntity> articleEntities) {
    var articles = List<Article>();

    articleEntities.forEach((article) {
      articles.add(Article(
          title: article.title ?? "",
          description: article.description ?? "",
          url: article.url,
          urlToImage: article.urlToImage,
          publishDate: article.publishDate ?? "",
          content: article.content ?? ""));
    });
    return articles;
  }
}
