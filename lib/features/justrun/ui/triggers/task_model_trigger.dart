import 'package:states_rebuilder/states_rebuilder.dart';

import '../../domain/entities/task.dart';
import '../../domain/pure_models/process_state.dart';
import '../../domain/pure_models/task_model.dart';

class TaskModelTrigger {
  final ReactiveModel<TaskModel> _rxModel;

  TaskModelTrigger() : _rxModel = Injector.getAsReactive<TaskModel>();

  ReactiveModel<TaskModel> get rxModel => _rxModel;
  ProcessState get processState => _rxModel.state.processState;
  Task get task => _rxModel.state.task;
  int get time => _rxModel.state.time;
  set time(int t) => _rxModel.setState((s) => s.time = t);

  // Task task(int index) => _rxModel.state.training.tasks[index];
  // int get taskCount => _rxModel.state.training.tasks.length;
  // Task get currentTask => taskCount > 0 ? task(0) : null;

  void start() {
    if (processState == ProcessState.Ready) {
      rxModel.setState(
        (s) => s.processState = ProcessState.InProcess,
      );
    }
  }

  void pause() {
    if (processState == ProcessState.InProcess) {
      rxModel.setState(
        (s) => s.processState = ProcessState.Paused,
      );
    }
  }

  void resume() {
    if (processState == ProcessState.Paused) {
      rxModel.setState(
        (s) => s.processState = ProcessState.InProcess,
      );
    }
  }

  void stop() {
    //
  }

  void repeat() {
    if (processState == ProcessState.Done) {
      //
    }
  }
}
