import 'package:camera/camera.dart';
import 'package:fali_shop/models/article.dart';
import 'package:fali_shop/providers/data_provider.dart';
import 'package:fali_shop/screens/components/add_article.dart';
import 'package:fali_shop/screens/components/footer_widget.dart';
import 'package:fali_shop/utils/helper.dart';
import 'package:flutter/material.dart';

import 'package:fali_shop/constants.dart';
import 'package:provider/provider.dart';

class ArticleDetails extends StatefulWidget {
  //final Article article;

  const ArticleDetails({Key key}) : super(key: key);

  @override
  _ArticleDetailsState createState() => _ArticleDetailsState();
}

class _ArticleDetailsState extends State<ArticleDetails> {
  CameraDescription camera;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  initCamera() async {
    final cameras = await availableCameras();
    // Get a specific camera from the list of available cameras.
    camera = cameras.first;
  }

  @override
  Widget build(BuildContext context) {
    // It provide us total height and width
    Size size = MediaQuery.of(context).size;
    var provider = Provider.of<DataProvider>(context);
    return Scaffold(
      // backgroundColor: Colors.black12,
      bottomNavigationBar: BottomAppBar(),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            // backgroundColor: Colors.white,
            title: Text(
              "",
              //widget.article.name,
              style: TextStyle(
                  fontFamily: 'Charmonman',
                  fontWeight: FontWeight.bold,
                  fontSize: 28),
            ),
            expandedHeight: 300.0,
            floating: true,
            flexibleSpace: Container(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    //  widget.article.description,
                    provider.article.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              Visibility(
                child: IconButton(
                  icon: Icon(Icons.update),
                  onPressed: () {
                    _navigateToAddArticlePage();
                  },
                  iconSize: 34,
                ),
                visible: provider.isUserAdmin,
              )
            ],
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              // padding: EdgeInsets.all(2),
              height: 500.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: provider.article.imageUrls.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: size.width,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Image.network(
                          getImageUrl(provider.article, index),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: FooterWidget(),
          ),
        ],
      ),
    );
  }

  /*String getImageUrl(Article article, int i) {
    return kStorageBaseUrl +
        Uri.encodeComponent("${article.articleType}/${article.id}/") +
        article.imageUrls[i];
  }*/

  _navigateToAddArticlePage() async {
    var provider = Provider.of<DataProvider>(context, listen: false);
    await Navigator.push(
      context,
      MaterialPageRoute<Article>(
        builder: (context) => AddArticle(
          articleCategory: provider.actualArticleCategory,
          article: provider.article,
        ),
      ),
    );
    setState(() {});
  }
}
