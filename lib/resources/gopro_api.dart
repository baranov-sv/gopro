import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:gopro/resources/gopro_exceptions.dart';

class GoProApi {
  static final GoProApi _instance = GoProApi._privateConstructor();
  final String _baseUrl = 'http://10.5.5.9';

  GoProApi._privateConstructor();

  factory GoProApi() {
    return _instance;
  }

  // [
  //   {
  //     'directoryName': <String>,
  //     'fileName': <String>,
  //     'createdAt': <String>,
  //     'modifiedAt': <String>,
  //     'size': <String>
  //   },
  //   ...
  // ]
  Future<List<Map<String, dynamic>>> fetchMediaList() async {
    final data = await _getRequest(Uri.parse('$_baseUrl/gp/gpMediaList'));
    List<Map<String, dynamic>> result = [];
    data['media'].forEach((json) {
      json['fs'].forEach((subJson) {
        final _path = '${json['d']}/${subJson['n']}';
        result.add({
          'directoryName': json['d'],
          'fileName': subJson['n'],
          'url': Uri.parse('$_baseUrl/videos/DCIM/$_path').toString(),
          'thumbnailUrl':
              Uri.parse('$_baseUrl/gp/gpMediaMetadata?p=$_path').toString(),
          'createdAt': subJson['cre'],
          'modifiedAt': subJson['mod'],
          'size': subJson['s']
        });
      });
    });

    return result;
  }

  Future<Map<String, dynamic>> fetchVideoInfo(String path) async {
    final data = await _getRequest(
        Uri.parse('$_baseUrl/gp/gpMediaMetadata?p=$path&t=v4info'));

    final _lrvPath = path.replaceAll(RegExp(r"\.MP4"), '.LRV');
    return {
      'lrvUrl':
          Uri.parse('$_baseUrl/gp/gpMediaMetadata?p=$_lrvPath').toString(),
      'duration': data['dur'],
      'width': data['w'],
      'heigh': data['h'],
    };
  }

  Future<Map<String, dynamic>> fetchPhotoInfo(String path) async {
    final data = await _getRequest(
        Uri.parse('$_baseUrl/gp/gpMediaMetadata?p=$path&t=v4info'));

    return {
      'width': data['w'],
      'heigh': data['h'],
    };
  }

  Future<Map<String, dynamic>> _getRequest(Uri uri) async {
    const Duration duration = Duration(seconds: 3);
    final response = await http.get(uri).timeout(duration, onTimeout: () {
      throw GoProTimeoutConnection(duration);
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw GoProFailedResponse();
    }
  }
}
