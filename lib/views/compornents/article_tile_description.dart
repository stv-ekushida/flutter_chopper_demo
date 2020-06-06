
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
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