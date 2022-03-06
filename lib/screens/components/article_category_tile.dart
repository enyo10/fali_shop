import 'package:fali_shop/providers/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:fali_shop/models/category.dart';
import 'package:provider/provider.dart';
import 'article_list.dart';

class ArticleCategoryTile extends StatelessWidget {
  const ArticleCategoryTile({
    Key key,
    @required this.articleCategory,
  })  : assert(articleCategory != null),
        super(key: key);

  final ArticleCategory articleCategory;

  @override
  Widget build(BuildContext context) {
   // final userProvider = Provider.of<DataProvider>(context);
    final dataProvider =Provider.of<DataProvider>(context);
    return InkWell(
      onTap: () => routeToAddArticlePage(context, dataProvider),
      child: Card(
        elevation: 2,
        margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Container(
          color: articleCategory.backgroundColor,
          height: 150,
          child: ListTile(
            title: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Text(
                articleCategory.name??"",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ),

            subtitle: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                articleCategory.desc??"",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            //tileColor: articleCategory.backgroundColor,
          ),
        ),
      ),
    );
  }

  Future routeToAddArticlePage(BuildContext context, DataProvider provider) {
    provider.setArticleCategory(articleCategory);
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticleList(articleCategory: articleCategory),
      ),
    );
  }
}
