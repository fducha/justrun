import 'package:justrun/features/justrun/domain/training_process_bloc.dart';
import 'package:meta/meta.dart';

import '../entities/training.dart';
import '../repositories/repository.dart';

enum TrainingProcessState {
  Ready,
  InProcess,
  Paused,
  Done,
}

class TrainingModel {
  final Repository repository;
  
  Training _training;
  TrainingProcessState _processState = TrainingProcessState.Ready;

  TrainingModel({@required this.repository});

  void fetch() async {
    _training = await repository.getAllTrainings();
  }

  Training get training => _training;
  
  TrainingProcessState get processState => _processState;
  set processState(TrainingProcessState state) {
    _processState = state;
  }

  void nextTask() {
    if (_training.tasks.length > 0) _training.tasks.removeAt(0);
    if (_training.tasks.length == 0) _processState = TrainingProcessState.Done;
  }
}
