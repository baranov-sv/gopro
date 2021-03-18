import 'dart:async';
import 'dart:convert';
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
    final data = await _api.fetchMediaList();
    List<Media> result = [];
    data['media'].forEach((json) {
      json['fs'].forEach((subJson) {
        Media media = Media.fromJson({
          'directoryName': json['d'],
          'fileName': subJson['n'],
          'createdAt': subJson['cre'],
          'modifiedAt': subJson['mod'],
          'size': subJson['s']
        });

        result.add(media);
      });
    });

    return result;
  }
}
