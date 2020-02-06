import 'package:justrun/features/justrun/domain/entities/task.dart';
import 'package:justrun/features/justrun/domain/entities/training.dart';

enum ProcessState {
  Ready,
  InProcess,
  Paused,
  Done,
}

class TrainingProcessBloc {
  Training _training;
  ProcessState _state;

  void setTraining(Training training) {
    _training = Training(List.from(training.tasks));
    _state = ProcessState.Ready;
  }

  Training get training => _training;
  ProcessState get processState => _state;
  Task get currentTask => _training.tasks[0];

  void start() {
    if (processState == ProcessState.Ready || processState == ProcessState.Done) {
      //
    }
  }

  void pause() {
    if (processState == ProcessState.InProcess) {
      //
    }
  }

  void resume() {
    if (processState == ProcessState.Paused) {
      //
    }
  }

  void stop() {
    //
  }
}