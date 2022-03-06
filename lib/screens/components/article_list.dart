import 'package:camera/camera.dart';
import 'package:fali_shop/data_base/api.dart';
import 'package:fali_shop/models/article.dart';
import 'package:fali_shop/providers/data_provider.dart';
import 'package:fali_shop/screens/components/article_card.dart';
import 'package:fali_shop/models/category.dart';
import 'package:fali_shop/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';

import 'add_article.dart';

class ArticleList extends StatefulWidget {
  final ArticleCategory articleCategory;

  const ArticleList({Key key, @required this.articleCategory})
      : assert(articleCategory != null),
        super(key: key);
  @override
  _ArticleListState createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList> {
  List<dynamic> list = [];
  CameraDescription camera;

  initCamera() async {
    final cameras = await availableCameras();
    // Get a specific camera from the list of available cameras.
    camera = cameras.first;
  }

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  @override
  Widget build(BuildContext context) {
    list = widget.articleCategory.articles;

    list.sort((a, b) => a.name.compareTo(b.name));
    DataProvider dataProvider = Provider.of<DataProvider>(context);

    return Scaffold(
      floatingActionButton: Visibility(
        visible: dataProvider.isUserAdmin,
        child: FloatingActionButton(
          child: Icon(
            Icons.add,
            size: 40,
            //   color: Colors.red,
          ),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddArticle(articleCategory: widget.articleCategory),
              ),
            );
            setState(() {});
          },
        ),
      ),
      appBar: AppBar(
        title: Text(" Liste d'article"),
      ),
      body: list.isEmpty
          ? Container(
              child: Center(child: Text(" No data.")),
            )
          : Container(
              child: ListView.builder(
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return list.length != 0
                    ? Card(
                        child: ArticleCard(
                            article: list[index], onDelete: _showAlertDialog),
                      )
                    : Center(
                        child: Text(" No data found"),
                      );
              },
            )),
    );
  }

  _showAlertDialog(BuildContext context, Article article) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(" NON"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("OUI"),
      onPressed: () {
        _deleteArticle(article);
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(" Confirmation"),
      content: Text("Es tu sûr de supprimer ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _deleteArticle(Article article) async {
    List<dynamic> list = [];
    var api = Api("falishop");
    for (int i = 0; i < article.imageUrls.length; i++) {
      list.add(getImageUrl(article, i));
    }

    if (list.length > 0) {
      list.forEach((imageUrl) async {
        await api.deleteImage(imageUrl);
      });
      await api
          .removeArticle(widget.articleCategory, article.id)
          .onError((error, stackTrace) => print(error));
    }
    setState(() {});

  }

}
