import 'package:states_rebuilder/states_rebuilder.dart';

import '../../../../core/utils/ticker.dart';
import '../../domain/entities/task.dart';
import '../../domain/pure_models/process_state.dart';
import '../../domain/pure_models/training_model.dart';

class TrainingModelTrigger {
  final ReactiveModel<TrainingModel> _rxModel;
  Ticker _ticker;
  int _doneTasksTime = 0;
  int _currentTaskTime = 0;

  TrainingModelTrigger() : _rxModel = Injector.getAsReactive<TrainingModel>() {
    if (currentTask != null) {
      _currentTaskTime = currentTask.duration;
    }
    _ticker = Ticker(
      duration: _rxModel.state.trainingTime,
      onTick: (int tick) {
        int outTime = _currentTaskTime - (tick - _doneTasksTime);
        print(outTime);
        if (outTime == 0) {
          _doneTasksTime = currentTask.duration;
          _ticker.stop();
        }
      },
    );
  }

  ReactiveModel<TrainingModel> get rxModel => _rxModel;
  ProcessState get processState => _rxModel.state.processState;

  Task task(int index) => _rxModel.state.training.tasks[index];
  int get taskCount => _rxModel.state.training.tasks.length;
  Task get currentTask => taskCount > 0 ? task(0) : null;

  void start() {
    if (processState == ProcessState.Ready) {
      rxModel.setState(
        (s) => s.processState = ProcessState.InProcess,
        filterTags: ['fabTrainingPage'],
      );
      _ticker.start();
    }
  }

  void pause() {
    if (processState == ProcessState.InProcess) {
      rxModel.setState(
        (s) => s.processState = ProcessState.Paused,
        filterTags: ['fabTrainingPage'],
      );
      _ticker.pause();
    }
  }

  void resume() {
    if (processState == ProcessState.Paused) {
      rxModel.setState(
        (s) => s.processState = ProcessState.InProcess,
        filterTags: ['fabTrainingPage'],
      );
      _ticker.resume();
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
}
