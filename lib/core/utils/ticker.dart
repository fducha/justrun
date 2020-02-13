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

  void start({int delay = 0}) {
    _tickStream = Stream.periodic(
      Duration(seconds: 1),
      (x) {
        print(x);
        return x - delay + 1;
      },
    ).take(duration + delay + 1).skip(delay);

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
