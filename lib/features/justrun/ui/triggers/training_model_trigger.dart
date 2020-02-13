import 'package:states_rebuilder/states_rebuilder.dart';

import '../../../../core/utils/ticker.dart';
import '../../domain/entities/task.dart';
import '../../domain/pure_models/process_state.dart';
import '../../domain/pure_models/training_model.dart';

class TrainingModelTrigger {
  final ReactiveModel<TrainingModel> _rxModel;
  Ticker _ticker;
  int _doneTasksTime = 0;

  TrainingModelTrigger() : _rxModel = Injector.getAsReactive<TrainingModel>() {
    _ticker = Ticker(
      duration: _rxModel.state.trainingTime,
      onTick: (int tick) {
        int taskTime = currentTask.duration - (tick - _doneTasksTime);
        rxModel.setState(
          (s) => s.currentTaskTime = taskTime,
          filterTags: ['currentTask'],
        );
        if (taskTime <= 0) {
          _doneTasksTime += currentTask.duration;

          rxModel.setState((s) => s.nextTask());

          if (rxModel.state.training.tasks.isNotEmpty)
            _onTaskStarted();
          else
            _onTrainingEnded();
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
      _ticker.start(delay: 5);
      await _onTrainingStarted();
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

  Future _onTrainingStarted() async {
    _getSound('Ready');
    for (var i = 3; i > 0; i--) {
      await Future.delayed(Duration(seconds: 1));
      _getSound('$i');
    }
    await Future.delayed(Duration(seconds: 1));
    _getSound('Start');
    await Future.delayed(Duration(seconds: 1));
    _onTaskStarted();
  }

  void _onTaskStarted() {
    _getSound('beep');
    _getSound('Task started');
  }

  void _onTrainingEnded() {
    _getSound('beep');
    _getSound('Training done');
  }
}
