import 'dart:async';

import 'package:meta/meta.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../../domain/entities/task.dart';
import '../../domain/pure_models/process_state.dart';
import '../../domain/pure_models/task_model.dart';

class TaskModelTrigger {
  final ReactiveModel<TaskModel> _rxModel;
  final Function onDoneTask;

  TaskModelTrigger({@required this.onDoneTask})
      : _rxModel = Injector.getAsReactive<TaskModel>();

  ReactiveModel<TaskModel> get rxModel => _rxModel;
  ProcessState get processState => _rxModel.state.processState;

  Task get task => _rxModel.state.task;
  void setTask(Task task) => _rxModel.setState((s) => s.task = task);

  int get time => _rxModel.state.time;

  Stream<int> _tickStream;
  StreamSubscription<int> _tickSubsription;

  void start() {
    if (processState == ProcessState.Ready) {
      _tickStream = Stream.periodic(
        Duration(seconds: 1),
        (x) => x,
      ).take(task.duration);

      _tickSubsription = _tickStream.listen(
        (int time) => _rxModel.setState(
          (s) {
            s.time = time;
            return s.processState = ProcessState.InProcess;
          },
          filterTags: ['current_task'],
        ),
        onDone: () {
          _tickSubsription.cancel();
          _tickSubsription = null;
          _rxModel.setState((s) => s.processState = ProcessState.Done);
          onDoneTask();
        },
      );

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
