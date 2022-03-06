import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fali_shop/models/category.dart';
import 'package:fali_shop/providers/data_provider.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:fali_shop/models/article.dart';

class Api {

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final String path;
  CollectionReference ref;

  Api(this.path) {
    ref = _db.collection(this.path);
  }

  Future<void> addCategory(Map category) {
    var id = category['id'] = ref.doc().id;
    return ref.doc(id).set(category);
  }

 Future<void> removeCategory(ArticleCategory articleCategory)async {
    return ref.doc(articleCategory.id).delete();
  }


 Future<DocumentSnapshot<ArticleCategory>> getArticleCategory(String articleCategoryId){
    return ref.doc(articleCategoryId).get();
  }

  Future<QuerySnapshot> getCategoryCollection() {
    return ref.get();
  }

  Stream<QuerySnapshot> streamArticleCollection() {
    return ref.snapshots();
  }

  Future<void> addArticle(
      {@required Map article,
      @required ArticleCategory category,
      @required List<io.File> files,
      @required DataProvider dataProvider}) async {
    var id = article['id'] ??=
        ref.doc("${category.id}").collection("articles").doc().id;
    List<String> urls = [];

    for (io.File file in files) {
      var imageName = "${DateTime.now().hashCode}.jpg";

      firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('${category.name}')
          .child('$id')
          .child('/$imageName');
      try {
        await storageRef.putFile(file);

        String url = await storageRef.getDownloadURL();
        urls.add(url.split("%2F")[2]);
      } on firebase_core.FirebaseException catch (e) {
        print(e);
      }
    }
    article['imageUrls'] = jsonEncode(urls);
    var articleToBeAdd = Article.fromMap(article, article['id']);
    dataProvider.setArticle(articleToBeAdd);
    category.addArticle(articleToBeAdd);

    updateDocument(category);
  }

  Future<void> updateDocument(ArticleCategory category) async{
    return ref.doc(category.id).update(category.toJson());
  }


  Future<void> removeArticle(ArticleCategory category, String articleId) async {
    for (var i = 0; i < category.articles.length; i++) {
      if (category.articles[i].id == articleId) {
        try {

         await  ref.doc("${category.id}").update({
            'articles': FieldValue.arrayRemove(
              [category.articles[i].toJson()],
            )
          });
         category.articles.removeAt(i);
        } catch (e) {
          print(e);
        }
      }
    }
  }


  Future<void> deleteImage(String url) async {
     firebase_storage.Reference storageRef =
         firebase_storage.FirebaseStorage.instance.refFromURL(url);
     return storageRef
         .delete()
         .onError((error, stackTrace) => print(stackTrace.toString()));
  }


}
