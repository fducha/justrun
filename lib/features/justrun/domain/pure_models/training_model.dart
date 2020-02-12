import 'package:meta/meta.dart';

import '../entities/training.dart';
import '../repositories/repository.dart';
import 'process_state.dart';

class TrainingModel {
  final Repository repository;
  
  Training _training;
  ProcessState _processState = ProcessState.Ready;
  int _trainingTime = -1;

  TrainingModel({@required this.repository});

  void fetch() async {
    _training = await repository.getAllTrainings();
    for (var task in _training.tasks) {
      _trainingTime += task.duration;
    }
    // _trainingTime += _training.tasks.length - 1;
  }

  Training get training => _training;
  
  ProcessState get processState => _processState;
  set processState(ProcessState state) {
    _processState = state;
  }

  int get trainingTime => _trainingTime;

  void nextTask() {
    if (_training.tasks.length > 0) _training.tasks.removeAt(0);
    if (_training.tasks.length == 0) _processState = ProcessState.Done;
  }
}
