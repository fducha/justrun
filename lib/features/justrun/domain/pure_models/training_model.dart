import 'package:meta/meta.dart';

import '../entities/training.dart';
import '../repositories/repository.dart';
import 'process_state.dart';

class TrainingModel {
  final Repository repository;

  Training _training;
  ProcessState processState = ProcessState.Ready;
  int _trainingTime = -1;
  int currentTaskTime = 0;

  TrainingModel({@required this.repository});

  Future fetch() async {
    _training = await repository.getAllTrainings();
    if (_training.tasks == null) print('tasks is null');
    if (_training.tasks != null && _training.tasks.length > 0) {
      currentTaskTime = _training.tasks[0].duration;
      for (var task in _training.tasks) _trainingTime += task.duration;
      _trainingTime += _training.tasks.length - 1;
    }
  }

  Training get training => _training;

  int get trainingTime => _trainingTime;

  void nextTask() {
    if (_training.tasks.length > 0) _training.tasks.removeAt(0);
    if (_training.tasks.length == 0) processState = ProcessState.Done;
  }
}
