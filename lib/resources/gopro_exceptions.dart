class GoProTimeoutConnection implements Exception {
  /// The duration that was exceeded.
  final Duration? duration;

  GoProTimeoutConnection([this.duration]);

  String toString() {
    String result = "The connection to GoPro has timed out";
    int _durationInSeconds = duration?.inSeconds ?? 0;
    if (_durationInSeconds > 0) {
      result = "$result after $_durationInSeconds seconds.";
    } else {
      result = "$result.";
    }

    return "$result Check WiFi connection to GoPro.";
  }
}

class GoProFailedResponse implements Exception {
  String toString() {
    return "Failed to fetch data from GoPro. Check WiFi connection to GoPro.";
  }
}
