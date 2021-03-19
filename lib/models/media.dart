import 'package:gopro/utils/filesize.dart';

class Media {
  final String directoryName;
  final String fileName;
  final String thumbnailUrl;
  final String url;
  final String createdAt;
  final String modifiedAt;
  final String size;

  Media(
      {required this.directoryName,
      required this.fileName,
      required this.thumbnailUrl,
      required this.url,
      required this.createdAt,
      required this.modifiedAt,
      required this.size});

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
        directoryName: json['directoryName'] as String,
        fileName: json['fileName'] as String,
        thumbnailUrl: json['thumbnailUrl'] as String,
        url: json['url'] as String,
        createdAt: json['createdAt'] as String,
        modifiedAt: json['modifiedAt'] as String,
        size: json['size'] as String);
  }

  String get humanSize {
    return filesize(size);
  }

  String get path {
    return '$directoryName/$fileName';
  }

  bool get isVideo {
    return fileName.endsWith('.MP4');
  }

  bool get isPhoto {
    return fileName.endsWith('.JPG');
  }
}
