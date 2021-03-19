import 'dart:async';
import 'package:gopro/models/media.dart';
import 'package:gopro/resources/gopro_api.dart';

class GoProProvider {
  static final GoProProvider _instance = GoProProvider._privateConstructor();
  final GoProApi _api = GoProApi();

  GoProProvider._privateConstructor();

  factory GoProProvider() {
    return _instance;
  }

  Future<List<Media>> fetchMediaList() async {
    final _mediaList = await _api.fetchMediaList();

    return _mediaList.map<Media>((json) => Media.fromJson(json)).toList();
  }

  // Future<Video> fetchVideo(Media media) async {}

  // Future<Photo> fetchPhoto(Media media) async {}
}
