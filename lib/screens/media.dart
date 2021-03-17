import 'package:flutter/material.dart';

class Media extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Media')),
        body: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: 10,
            itemBuilder: (context, index) {
              return MediaItem(
                  thumbnail: Image.asset('media.jpeg'),
                  title: 'Media',
                  size: 5,
                  duration: 2);
            }));
  }
}

class MediaItem extends StatelessWidget {
  const MediaItem({
    Key? key,
    required this.thumbnail,
    required this.title,
    required this.size,
    this.duration,
  }) : super(key: key);

  final Widget thumbnail;
  final String title;
  final int size;
  final int? duration;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: thumbnail,
          ),
          Expanded(
            flex: 3,
            child: _MediaDescription(
              title: title,
              size: size,
              duration: duration,
            ),
          )
        ],
      ),
    );
  }
}

class _MediaDescription extends StatelessWidget {
  const _MediaDescription({
    Key? key,
    required this.title,
    required this.size,
    this.duration,
  }) : super(key: key);

  final String title;
  final int size;
  final int? duration;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgets = <Widget>[
      _title(),
      const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
      _size()
    ];

    final List<Widget>? _optinalWidgets =
        (duration != null) ? <Widget>[_duration()] : null;
    return Container(
      child: Center(
        // padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [..._widgets, ...?_optinalWidgets]),
      ),
    );
  }

  Widget _title() {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
      ),
    );
  }

  Widget _size() {
    return Text(
      '$size MB',
      style: const TextStyle(fontSize: 12.0),
    );
  }

  Widget _duration() {
    return Text(
      '$duration min',
      style: const TextStyle(fontSize: 12.0),
    );
  }
}
