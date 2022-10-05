import 'package:flutter_themoviedb/configuration/configuration.dart';

class ImageUrlMaker {
  static String imageUrl(String path) => Configuration.imageUrl + path;
}