import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicBox {
  static AudioPlayer _player;
  final AudioCache _cache = AudioCache(prefix: 'audio/', fixedPlayer: _player);

  MusicBox() {
    AudioPlayer.logEnabled = false;
  }

  void playShortBeep() async {
    await _cache.play('short_beep.mp3', mode: PlayerMode.LOW_LATENCY);
  }

  void playLongBeep() async {
    await _cache.play('long_beep.mp3', mode: PlayerMode.LOW_LATENCY);
  }

  void stop() {
    if (_player.state == AudioPlayerState.PLAYING) _player.stop();
  }
}