import 'package:justrun/features/justrun/domain/entities/task.dart';
import 'package:justrun/features/justrun/domain/entities/training.dart';

enum TrainingProcessState {
  Ready,
  InProcess,
  Paused,
  Done,
}

class TrainingProcessBloc {
  Training _training;
  TrainingProcessState _state;

  void setTraining(Training training) {
    _training = Training(List.from(training.tasks));
    _state = TrainingProcessState.Ready;
  }

  Training get training => _training;
  TrainingProcessState get processState => _state;
  Task get currentTask => _training.tasks[0];

  void start() {
    if (processState == TrainingProcessState.Ready || processState == TrainingProcessState.Done) {
      //
    }
  }

  void pause() {
    if (processState == TrainingProcessState.InProcess) {
      //
    }
  }

  void resume() {
    if (processState == TrainingProcessState.Paused) {
      //
    }
  }

  void stop() {
    //
  }
}