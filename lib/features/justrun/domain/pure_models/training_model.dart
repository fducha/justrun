import 'package:meta/meta.dart';

import '../entities/training.dart';
import '../repositories/repository.dart';
import 'process_state.dart';

class TrainingModel {
  final Repository repository;
  
  Training _training;
  ProcessState _processState = ProcessState.Ready;

  TrainingModel({@required this.repository});

  void fetch() async {
    _training = await repository.getAllTrainings();
  }

  Training get training => _training;
  
  ProcessState get processState => _processState;
  set processState(ProcessState state) {
    _processState = state;
  }

  void nextTask() {
    if (_training.tasks.length > 0) _training.tasks.removeAt(0);
    if (_training.tasks.length == 0) _processState = ProcessState.Done;
  }
}
