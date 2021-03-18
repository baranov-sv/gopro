class Media {
  final String directoryName;
  final String fileName;
  final String createdAt;
  final String modifiedAt;
  final String size;

  Media(
      {required this.directoryName,
      required this.fileName,
      required this.createdAt,
      required this.modifiedAt,
      required this.size});

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
        directoryName: json['directoryName'] as String,
        fileName: json['fileName'] as String,
        createdAt: json['createdAt'] as String,
        modifiedAt: json['modifiedAt'] as String,
        size: json['size'] as String);
  }
}
