library add_article;

import 'dart:core';
import 'package:fali_shop/providers/data_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:fali_shop/data_base/api.dart';
import 'package:fali_shop/screens/components/image_item.dart';
import 'package:fali_shop/models/article.dart';
import 'package:fali_shop/models/category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fali_shop/utils/data_values.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

part '../../utils/resource_picker.dart';
part '../../utils/color_picker.dart';

List<Color> _colorCollection;
List<String> _colorNames = colorNames;
int _selectedColorIndex;
List<String> _nameCollection = colorNames;

class AddArticle extends StatefulWidget {
  final ArticleCategory articleCategory;
  final Article article;

  const AddArticle({Key key, @required this.articleCategory, this.article})
      : assert(articleCategory != null),
        super(key: key);

  @override
  _AddArticleState createState() => _AddArticleState();
}

class _AddArticleState extends State<AddArticle> {
  final _articleNameController = TextEditingController();

  final _articleDescriptionController = TextEditingController();
  final _articlePriceController = TextEditingController();

  bool get updateState => widget.article != null;

  CameraController _controller;
  ImagePicker _imagePicker = ImagePicker();
  // List<PickedFile> _pickedImages = [];
  List<ImageItem> _imageItems = [];
  List<File> _files = [];
  List<String> urls = [];
  bool isUploading = false;
  var camera;
  var api = Api("falishop");

  @override
  void initState() {
    super.initState();
    initCamera();
    _selectedColorIndex = 0;
    _colorNames = colorNames;
    _colorCollection = colorCollection;
    _updateData();
  }

  void _updateData() {
    if (updateState) {
      _articleNameController.text = widget.article.name;
      _articleDescriptionController.text = widget.article.description;
      _articlePriceController.text = widget.article.price.toString();

      for (int i = 0; i < widget.article.imageUrls.length; i++) {
        _imgFromWeb(widget.article, i);
      }
    }
  }

  Future<File> urlToFile(String imageUrl, String imageName) async {
// get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
    String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
    File file = new File('$tempPath' + imageName);
// call http.get method and pass imageUrl into it to get response.
    var url = Uri.parse(imageUrl);

    http.Response response = await http.get(url);

// write bodyBytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);
// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.

    return file;
  }

  String getImageUrl(Article article, int i) {
    return kStorageBaseUrl +
        Uri.encodeComponent("${article.articleType}/${article.id}/") +
        article.imageUrls[i];
  }

  initCamera() async {
    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();
    camera = cameras.first;

    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      // widget.camera,
      camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );
  }

  _imgFromCamera() async {
    PickedFile image = await _imagePicker.getImage(
        source: ImageSource.camera, imageQuality: 50);
    if (image != null)
      setState(() {
        //  _pickedImages.add(image);
        _files.add(File(image.path));
      });
  }

  _imgFromGallery() async {
    PickedFile image = await _imagePicker.getImage(
        source: ImageSource.gallery, imageQuality: 50);

    if (image != null)
      setState(() {
        // _pickedImages.add(image);
        _files.add(File(image.path));
      });
  }

  _imgFromWeb(Article article, int index) async {
    var imageUrl = getImageUrl(article, index);
    urls.add(imageUrl);
    var name = article.imageUrls[index].split('?')[0];

    File image = await urlToFile(imageUrl, name);
    if (image != null)
      setState(() {
        _files.add(image);
      });
  }

  _removePickedImage(int index) async {
    setState(() {
      _files.removeAt(index);
    });

    if (updateState) {
      await api.deleteImage(
          // widget.articleCategory, widget.article, urls[index], index
          urls[index]);
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _updateImageFromFiles() {
    _imageItems.clear();
    if (_files.isNotEmpty)
      for (int i = 0; i < _files.length; i++) {
        _imageItems.add(ImageItem(
          file: _files[i],
          index: i,
          onDeleteItem: () {
            _removePickedImage(i);
          },
        ));
      }
  }

  void _showInfo(context, String text) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
                child: Center(
              child: Text(
                text,
                style: TextStyle(fontSize: 20),
              ),
            )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    _updateImageFromFiles();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var name = _articleNameController.text;
          var description = _articleDescriptionController.text;
          var price = _articlePriceController.text;

          var provider = Provider.of<DataProvider>(context, listen: false);

          if (description.length > 3 &&
              name.isNotEmpty &&
              price.isNotEmpty &&
              _imageItems.length != 0) {
            print(" Data is not null");

            var article = Article(
                name: name,
                articleType: widget.articleCategory.name,
                description: description,
                price: int.parse(price),
                isReserved: false,
                color: _colorCollection[_selectedColorIndex],
                id: updateState ? widget.article.id : null);

            setState(() {
              isUploading = true;
            });

            await Api("falishop")
                .addArticle(
                    article: article.toJson(),
                    files: _files,
                    category: widget.articleCategory,
                    dataProvider: provider)
                .whenComplete(
                  () => setState(
                    () {
                      isUploading = false;
                    },
                  ),
                );
            Navigator.pop(context);

            //Navigator.of(context).pop(provider.article);
          } else
            _showInfo(context, " Data must be provide");
        },
        child: Icon(Icons.save),
      ),
      appBar: AppBar(
        title: Text(" Ajouter un article "),
        actions: [
          IconButton(
              icon: Icon(Icons.add_a_photo),
              onPressed: () {
                _showPicker(context);
              })
        ],
      ),
      body: isUploading
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: Column(children: [
                Expanded(
                  child: Card(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 15, bottom: 0),
                            //padding: EdgeInsets.symmetric(horizontal: 15),
                            child: TextField(
                              controller: _articleNameController,
                              // Only numbers can be entered
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  // Only numbers can be entered
                                  labelText: 'Name',
                                  hintText: 'Enter le nom de l\'article'),
                            ),
                          ),
                          Padding(
                            //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 15, bottom: 0),
                            child: TextField(
                              //textAlign: TextAlign.center,
                              keyboardType: TextInputType.multiline,
                              minLines:
                                  1, //Normal textInputField will be displayed
                              maxLines: 5,
                              controller: _articleDescriptionController,
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
                              controller: _articlePriceController,
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
                          ListTile(
                            contentPadding:
                                const EdgeInsets.fromLTRB(5, 2, 5, 2),
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
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: ListView.builder(
                        //  shrinkWrap: true,
                        itemCount: _imageItems.length,
                        itemBuilder: (context, index) {
                          return _imageItems[index];
                        }),
                  ),
                ),
              ]),
            ),
    );
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    _articleNameController.dispose();
    _articleDescriptionController.dispose();
    _articlePriceController.dispose();

    super.dispose();
  }
}
