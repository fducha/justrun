import 'package:justrun/features/justrun/ui/triggers/task_model_trigger.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../../domain/entities/task.dart';
import '../../domain/pure_models/process_state.dart';
import '../../domain/pure_models/training_model.dart';

class TrainingModelTrigger {
  final ReactiveModel<TrainingModel> _rxModel;
  TaskModelTrigger _taskTrigger;

  TrainingModelTrigger() : _rxModel = Injector.getAsReactive<TrainingModel>() {
    _taskTrigger = TaskModelTrigger(onDoneTask: () {
      rxModel.setState((s) => s.nextTask());
      _taskTrigger.setTask(currentTask);
    });
    if (currentTask != null) _taskTrigger.setTask(currentTask);
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
      _taskTrigger.start();
    }
  }

  void pause() {
    if (processState == ProcessState.InProcess) {
      rxModel.setState(
        (s) => s.processState = ProcessState.Paused,
        filterTags: ['fabTrainingPage'],
      );
    }
  }

  void resume() {
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
