import 'package:fali_shop/models/article.dart';

import '../constants.dart';

String getImageUrl(Article article,int i) {
  return kStorageBaseUrl +
      Uri.encodeComponent(
          "${article.articleType}/${article.id}/") +
      article.imageUrls[i];
}