import 'package:flutter/material.dart';
import 'package:fali_shop/utils/data_values.dart';

import 'article.dart';

class ArticleCategory {
  final String id;
  final String name;
  final String desc;
  final String imagePath;
  final Color backgroundColor;
  final List<Article> articles;

  ArticleCategory(
      {@required this.name,
      this.id,
      this.imagePath,
      this.backgroundColor,
      this.desc,
      this.articles});

  ArticleCategory.fromMap(Map snapshot, String id)
      : id = id ?? "",
        name = snapshot['name'],
        imagePath = snapshot['imagePath'],
        backgroundColor = colorCollection[snapshot['backgroundColor'] ?? 0],
        //articles = jsonDecode(snapshot['articles'])as List<dynamic>,
        desc = snapshot['desc'],
        articles = List<Article>.from(
            snapshot['articles'].map((e) => Article.fromMap(e, e['id'])));

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "imagePath": imagePath,
      "backgroundColor": colorCollection.indexOf(backgroundColor),
      "articles": articles.map((article) => article.toJson()).toList(),
      "desc": desc
    };
  }

  int _checkValue(Article article) {
    var value = -1;
    if (articles != null)
      for (int i = 0; i < articles.length; i++) {
        if (article.id == articles[i].id) value = i;
      }
    return value;
  }

  addArticle(Article article) {
    var value = _checkValue(article);
    if (value == -1)
      articles.add(article);
    else
      articles[value] = article;
  }

  bool removeArticle(String articleID) {
    articles.forEach((article)  {
      if (article.id == articleID)
        return articles.remove(article);
    });
    return false;

  }
}
