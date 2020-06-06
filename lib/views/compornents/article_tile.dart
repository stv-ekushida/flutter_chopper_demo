
import 'package:flutter/material.dart';
import 'package:flutter_chopper_demo/models/news_model.dart';
import 'package:flutter_chopper_demo/views/compornents/article_tile_description.dart';
import 'package:flutter_chopper_demo/views/compornents/image_from_url.dart';

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