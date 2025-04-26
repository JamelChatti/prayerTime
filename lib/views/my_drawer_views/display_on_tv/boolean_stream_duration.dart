import 'dart:async';

class BooleanStreamDuration {
  final StreamController<bool> _streamController = StreamController<bool>();

  Stream<bool> get stream => _streamController.stream;

  void addBooleanToStream(bool value) {
    _streamController.sink.add(value);
  }

  void dispose() {
    _streamController.close();
  }
}
