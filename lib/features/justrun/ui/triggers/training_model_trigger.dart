import 'package:states_rebuilder/states_rebuilder.dart';

import '../../../../core/utils/music_box.dart';
import '../../../../core/utils/ticker.dart';
import '../../domain/entities/task.dart';
import '../../domain/pure_models/process_state.dart';
import '../../domain/pure_models/training_model.dart';

class TrainingModelTrigger {
  final ReactiveModel<TrainingModel> _rxModel;
  Ticker _ticker;
  int _doneTasksTime = 0;
  static const int _countDownTime = 5;

  final _musicBox = MusicBox();

  TrainingModelTrigger() : _rxModel = Injector.getAsReactive<TrainingModel>() {
    _ticker = Ticker(
      duration: _rxModel.state.trainingTime + _countDownTime,
      onTick: (int tick) {
        print(tick);
        if (tick <= _countDownTime) {
          _onTrainingStarted(tick);
        } else {
          int taskTime =
              currentTask.duration - (tick - _doneTasksTime - _countDownTime);
          _onMiddleTime(taskTime, currentTask.duration);
          rxModel.setState(
            (s) => s.currentTaskTime = taskTime,
            filterTags: ['currentTask'],
          );
          _onBeforeTrainingEnded(taskTime, currentTask.duration);
          if (taskTime <= 0) {
            _doneTasksTime += currentTask.duration;

            rxModel.setState((s) => s.nextTask());

            if (rxModel.state.training.tasks.isNotEmpty)
              _onTaskStarted();
            else {
              _onTrainingEnded();
              _ticker.stop();
            }
          }
        }
      },
    );
  }

  ReactiveModel<TrainingModel> get rxModel => _rxModel;
  ProcessState get processState => _rxModel.state.processState;

  Task task(int index) => _rxModel.state.training.tasks[index];
  int get taskCount => _rxModel.state.training.tasks.length;
  Task get currentTask => _rxModel.state.training.tasks[0];

  void start() async {
    if (processState == ProcessState.Ready) {
      rxModel.setState(
        (s) => s.processState = ProcessState.InProcess,
        filterTags: ['fabTrainingPage'],
      );
      _ticker.start();
    }
  }

  void pause() {
    if (_ticker != null) _ticker.pause();
    if (processState == ProcessState.InProcess) {
      rxModel.setState(
        (s) => s.processState = ProcessState.Paused,
        filterTags: ['fabTrainingPage'],
      );
    }
  }

  void resume() {
    _ticker.resume();
    if (processState == ProcessState.Paused) {
      rxModel.setState(
        (s) => s.processState = ProcessState.InProcess,
        filterTags: ['fabTrainingPage'],
      );
    }
  }

  void stop() {
    //
  }

  void repeat() {
    if (processState == ProcessState.Done) {
      rxModel.setState(
        (s) => s.processState = ProcessState.Ready,
        // filterTags: ['fabTrainingPage'],
      );
      rxModel.setState((s) => s.fetch());
    }
  }

  void _getSound(String text) {
    print('Sounded ... $text');
  }

  Future _onTrainingStarted(int tick) async {
    switch (tick) {
      case 1:
        _getSound('Ready');
        break;
      case 2:
        _getSound('3');
        _musicBox.playShortBeep();
        break;
      case 3:
        _getSound('2');
        _musicBox.playShortBeep();
        break;
      case 4:
        _getSound('1');
        _musicBox.playShortBeep();
        break;
      case 5:
        _onTaskStarted();
        break;
    }
  }

  void _onMiddleTime(int taskTime, int taskDuration) {
    if (taskTime == (taskDuration / 2)) _getSound('the middle of time');
  }

  void _onBeforeTrainingEnded(int taskTime, int taskDuration) {
    switch (taskTime) {
      case 4:
        _getSound('stop in');
        break;
      case 3:
        _getSound('3');
        _musicBox.playShortBeep();
        break;
      case 2:
        _getSound('2');
        _musicBox.playShortBeep();
        break;
      case 1:
        _getSound('1');
        _musicBox.playShortBeep();
        break;
    }
  }

  void _onTaskStarted() {
    _musicBox.playLongBeep();
    _getSound('Task started');
  }

  void _onTrainingEnded() {
    _musicBox.playLongBeep();
    _getSound('Training done');
  }
}
