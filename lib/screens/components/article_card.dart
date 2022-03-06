import 'package:cached_network_image/cached_network_image.dart';
import 'package:fali_shop/providers/data_provider.dart';
import 'package:fali_shop/screens/details/article_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/article.dart';
import '../../utils/helper.dart';

class ArticleCard extends StatefulWidget {
  final Article article;
  final Function onClicked;
  final Function onDelete;

  const ArticleCard({Key key, this.onClicked, this.onDelete, this.article})
      : super(key: key);

  @override
  _ArticleCardState createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  //Article article;
  @override
  Widget build(BuildContext context) {
    var dataProvider = Provider.of<DataProvider>(context);
    bool hasImage = widget.article.imageUrls.length > 0;

    return GestureDetector(
      onDoubleTap: () {
        dataProvider.setArticle(widget.article);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleDetails(),
            ));
      },
      child: Container(
        height: 300,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                  child: IconButton(
                    icon: Icon(Icons.delete),
                    iconSize: 30.0,
                    onPressed: () {
                        widget.onDelete(context,widget.article);

                    },
                  ),
                  visible: Provider.of<DataProvider>(context).isUserAdmin,
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: kDefaultPadding),
                    decoration: BoxDecoration(
                      //color: widget.article.color,
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                    child: Hero(
                        tag: "${widget.article.id}",
                        child: hasImage
                            ? CachedNetworkImage(
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                imageUrl: getImageUrl(widget.article, 0),
                              )
                            : Image.asset(
                                'assets/images/flutter-logo.png',
                                //   width: 100.0,
                                //   height: 100.0,
                              )),
                  ),
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.article.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w400,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    Text(
                      "Prix :\n ${widget.article.price} CFA",
                      style: TextStyle(
                          fontFamily: 'Charmonman',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.purple),
                    ),
                  ],
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }

}
