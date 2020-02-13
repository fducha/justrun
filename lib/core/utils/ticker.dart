import 'dart:async';

import 'package:meta/meta.dart';

class Ticker {
  final int duration;
  final Function onTick;

  Stream<int> _tickStream;
  StreamSubscription<int> _tickSubsription;

  Ticker({
    @required this.duration,
    @required this.onTick,
  });

  void start() {
    _tickStream = Stream.periodic(
      Duration(seconds: 1),
      (x) => x + 1,
    ).take(duration + 1);

    _tickSubsription = _tickStream.listen(
      (int x) => onTick(x),
    );
  }

  void pause() {
    _tickSubsription.pause();
  }

  void resume() {
    _tickSubsription.resume();
  }

  void stop() {
    _tickStream = null;

    _tickSubsription.cancel();
    _tickSubsription = null;
  }
}
