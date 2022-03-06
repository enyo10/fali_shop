import 'package:fali_shop/models/article.dart';
import 'package:fali_shop/models/category.dart';
import 'package:fali_shop/models/user.dart';
import 'package:flutter/material.dart';

class DataProvider extends ChangeNotifier {
  AppUser _user;
  ArticleCategory _articleCategory;
  Article _article;

  get user => _user;

  void setUser(AppUser usr) {
    _user = usr;
    notifyListeners();
  }

  void setArticleCategory(ArticleCategory actualArticleCategory) {
    _articleCategory = actualArticleCategory;
    notifyListeners();
  }

  get actualArticleCategory => _articleCategory;

  void setArticle(Article article) {
    _article = article;
    notifyListeners();
  }

  get article => _article;

  get isUserAdmin => _user != null && _user.isAdmin;
}
