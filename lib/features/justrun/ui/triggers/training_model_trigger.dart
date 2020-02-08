import 'package:justrun/features/justrun/domain/entities/task.dart';
import 'package:justrun/features/justrun/domain/pure_models/training_model.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class TrainingModelTrigger {
  final ReactiveModel<TrainingModel> _rxModel;

  TrainingModelTrigger() : _rxModel = Injector.getAsReactive<TrainingModel>();

  ReactiveModel<TrainingModel> get rxModel => _rxModel;
  TrainingProcessState get processState => _rxModel.state.processState;

  Task task(int index) => _rxModel.state.training.tasks[index];
  int get taskCount => _rxModel.state.training.tasks.length;
  Task get currentTask => taskCount > 0 ? task(0) : null;

  void start() {
    if (processState == TrainingProcessState.Ready) {
      rxModel.setState(
        (s) => s.processState = TrainingProcessState.InProcess,
        filterTags: ['fabTrainingPage'],
      );
    }
  }

  void pause() {
    if (processState == TrainingProcessState.InProcess) {
      rxModel.setState(
        (s) => s.processState = TrainingProcessState.Paused,
        filterTags: ['fabTrainingPage'],
      );
    }
  }

  void resume() {
    if (processState == TrainingProcessState.Paused) {
      rxModel.setState(
        (s) => s.processState = TrainingProcessState.InProcess,
        filterTags: ['fabTrainingPage'],
      );
    }
  }

  void stop() {
    //
  }

  void repeat() {
    if (processState == TrainingProcessState.Done) {
      rxModel.setState(
        (s) => s.processState = TrainingProcessState.Ready,
        // filterTags: ['fabTrainingPage'],
      );
      rxModel.setState((s) => s.fetch());
    }
  }
}
