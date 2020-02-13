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
        int taskTime = currentTask.duration - (tick - _doneTasksTime) - 1;
        rxModel.setState(
          (s) => s.currentTaskTime = taskTime,
          filterTags: ['currentTask'],
        );
        if (taskTime == 0) {
          if (rxModel.state.training.tasks.isNotEmpty) {
            _doneTasksTime += currentTask.duration;
          }
          rxModel.setState((s) => s.nextTask());
        }
      },
    );
  }

  ReactiveModel<TrainingModel> get rxModel => _rxModel;
  ProcessState get processState => _rxModel.state.processState;

  Task task(int index) => _rxModel.state.training.tasks[index];
  int get taskCount => _rxModel.state.training.tasks.length;
  Task get currentTask => _rxModel.state.training.tasks[0];

  void start() {
    _ticker.start();
    if (processState == ProcessState.Ready) {
      rxModel.setState(
        (s) => s.processState = ProcessState.InProcess,
        filterTags: ['fabTrainingPage'],
      );
    }
  }

  void pause() {
    _ticker.pause();
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
}
