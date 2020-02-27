import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:justrun/core/localization/app_localization.dart';

class MusicBox {
  final BuildContext context;
  static AudioPlayer _player;
  final AudioCache _cache = AudioCache(prefix: 'audio/', fixedPlayer: _player);

  String _getReadySoundFileName;
  String _startRunningSoundFileName;

  MusicBox({@required this.context}) {
    AudioPlayer.logEnabled = false;
    final langCode = AppLocalization.of(context).locale.languageCode;
    _getReadySoundFileName = 'get_ready_$langCode.mp3';
    _startRunningSoundFileName = 'start_running_$langCode.mp3';
    _cache.loadAll([
      'short_beep.mp3',
      'long_beep.mp3',
      _getReadySoundFileName,
      _startRunningSoundFileName,
    ]);
  }

  void playShortBeep() async {
    await _cache.play('short_beep.mp3', mode: PlayerMode.LOW_LATENCY);
  }

  void playLongBeep() async {
    await _cache.play('long_beep.mp3', mode: PlayerMode.LOW_LATENCY);
  }

  void playGetReady() async {
    await _cache.play(_getReadySoundFileName, mode: PlayerMode.LOW_LATENCY);
  }

  void playStartRunning() async {
    await _cache.play(_startRunningSoundFileName, mode: PlayerMode.LOW_LATENCY);
  }

  void stop() {
    if (_player.state == AudioPlayerState.PLAYING) _player.stop();
  }
}
