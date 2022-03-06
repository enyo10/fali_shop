import 'package:fali_shop/data_base/api.dart';
import 'package:fali_shop/models/article.dart';
import 'package:fali_shop/models/category.dart';
import 'package:fali_shop/utils/data_values.dart';
import 'package:flutter/material.dart';

List<Color> _colorCollection = colorCollection;
List<String> _colorNames = colorNames;
int _selectedColorIndex = 0;

class AddArticleCategory extends StatefulWidget {
  @override
  _AddArticleCategoryState createState() => _AddArticleCategoryState();
}

class _AddArticleCategoryState extends State<AddArticleCategory> {
  final articleCategoryNameController = TextEditingController();
  final articleCategoryDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Ajouter une categorie"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var name = articleCategoryNameController.text;
          var desc = articleCategoryDescriptionController.text;
          if (name.isNotEmpty && name.length > 2) {
            List<Article> articles = [];
            var backgroundColor = _colorCollection[_selectedColorIndex];
            var cat = ArticleCategory(
                name: name,
                articles: articles,
                backgroundColor: backgroundColor,
                desc: desc);

            Api("falishop").addCategory(cat.toJson());
          }
        },
        child: Icon(Icons.save),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                textAlign: TextAlign.center,
                controller: articleCategoryNameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Article  type',
                    hintText: 'Enter article type'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: articleCategoryDescriptionController,
                // Only numbers can be entered
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    // Only numbers can be entered
                    labelText: 'Description de la categorie',
                    hintText: 'Une petite description de la catégorie'),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(50, 20, 50, 20),
              child: ListTile(
                //contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                leading: Icon(Icons.lens,
                    color: _colorCollection[_selectedColorIndex]),
                title: Text(
                  _colorNames[_selectedColorIndex],
                ),
                onTap: () {
                  showDialog<Widget>(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return ColorPicker();
                    },
                  ).then((dynamic value) => setState(() {
                        print("$_selectedColorIndex");
                      }));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ColorPicker extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ColorPickerState();
  }
}

class ColorPickerState extends State<ColorPicker> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            padding: const EdgeInsets.all(0),
            itemCount: _colorCollection.length - 1,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                contentPadding: const EdgeInsets.all(0),
                leading: Icon(
                  index == _selectedColorIndex ? Icons.lens : Icons.trip_origin,
                  color: _colorCollection[index],
                ),
                title: Text(_colorNames[index]),
                onTap: () {
                  setState(() {
                    _selectedColorIndex = index;
                  });

                  // ignore: always_specify_types
                  Future.delayed(const Duration(milliseconds: 200), () {
                    // When task is over, close the dialog
                    Navigator.pop(context);
                  });
                },
              );
            },
          )),
    );
  }
}
