import 'dart:io';

//import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class ImageItem extends StatelessWidget {

  final File file;
 // final File imageFile;
  final int index;
  final Color color;
  final VoidCallback onDeleteItem;

  const ImageItem(
      {Key key, @required this.file, @required this.index, this.onDeleteItem, this.color, })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(" In image item $file");
    return Container(
           padding: EdgeInsets.all(kDefaultPadding),
           // margin: EdgeInsets.fromLTRB(100, 10, 100, 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.file(
                  file,
                  width: 100,
                  height: 100,
                  fit: BoxFit.fitHeight,
                ),
                InkWell(
                    child: Icon(Icons.delete),
                    onDoubleTap: () => onDeleteItem())
              ],
            ),
          );
  }
}
