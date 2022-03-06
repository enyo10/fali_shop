import 'package:fali_shop/models/article.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ArticleData extends StatefulWidget {
  final Article article;

  const ArticleData({Key key, this.article}) : super(key: key);


  @override
  _ArticleDataState createState() => _ArticleDataState();
}

class _ArticleDataState extends State<ArticleData> {
  final articleNameController = TextEditingController();
  final articleDescription = TextEditingController();
  final articlePriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(

      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,

                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('assets/images/flutter-logo.png',width: 100.0, height: 100.0,)),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                textAlign: TextAlign.center,
                controller: articleNameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Article  name',
                    hintText: 'Enter article name'),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                textAlign: TextAlign.center,
                controller: articleDescription,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Description de l\'article",
                    hintText: " Décrire l\'article"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: articlePriceController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ], // Only numbers can be entered
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    // Only numbers can be entered
                    labelText: 'Prix',
                    hintText: 'Enter le prix de l\'article'),
              ),
            ),
           /* SizedBox(
              height: 80,
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ElevatedButton(
                onPressed: () {
                  var article = Article(
                    name: articleNameController.text,
                    description: articlePriceController.text,
                    price: articlePriceController.text as int
                  );

                  Navigator.pop(context);
                },
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 120,
            ),
            Text('Add new employee ?')*/
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    articleNameController.dispose();
    articlePriceController.dispose();
    articlePriceController.dispose();
    super.dispose();
  }


}
