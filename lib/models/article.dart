import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fali_shop/utils/data_values.dart';

class Article {
  final String id, name, description, articleType;
  final int price;
  final Color color;
  final List<dynamic> imageUrls;
  final bool isReserved;

  Article(
      {this.articleType,
      this.name,
      this.description,
      this.price,
      this.id,
      this.color,
      this.imageUrls,
      this.isReserved});

  Article.fromMap(Map snapshot, String id)
      : id = id ??snapshot['id'],
        name = snapshot['name'],
        description = snapshot['description'],
        price = snapshot['price'],
        articleType = snapshot['articleType'],
        imageUrls = jsonDecode(snapshot['imageUrls']),
        color = colorCollection[snapshot['colorIndex'] ?? 0],
        isReserved = snapshot['isReserved'] ?? false;

  toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "price": price,
      "articleType": articleType,
      "colorIndex": colorCollection.indexOf(color),
      "imageUrls": jsonEncode(imageUrls),
      "isReserved": isReserved,
    };
  }
}
