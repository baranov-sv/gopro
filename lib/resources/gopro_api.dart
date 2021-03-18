import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class GoProApi {
  static final GoProApi _instance = GoProApi._privateConstructor();
  final String _baseUrl = 'http://10.5.5.9';

  GoProApi._privateConstructor();

  factory GoProApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> fetchMediaList() async {
    return _getRequest(Uri.parse('$_baseUrl/gp/gpMediaList'));
  }

  Future<Map<String, dynamic>> fetchVideoInfo(String path) async {
    return _getRequest(
        Uri.parse('$_baseUrl/gp/gpMediaMetadata?p=$path&t=videoinfo'));
  }

  Future<Map<String, dynamic>> fetchPhotoInfo(String path) async {
    return _getRequest(
        Uri.parse('$_baseUrl/gp/gpMediaMetadata?p=$path&t=v4info'));
  }

  // String thumbnailUrl(String path) {
  //   return '$_baseUrl/$path';
  // }

  Future<Map<String, dynamic>> _getRequest(Uri uri) async {
    final response =
        await http.get(uri).timeout(const Duration(seconds: 3), onTimeout: () {
      throw TimeoutException('The connection has timed out, Please try again!');
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch media');
    }
  }
}
