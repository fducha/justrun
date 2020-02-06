import 'package:justrun/features/justrun/domain/entities/training.dart';
import 'package:meta/meta.dart';

import '../repositories/repository.dart';

class TrainingModel {
  final Repository repository;
  Training _training;

  TrainingModel({@required this.repository});

  void fetch() async {
    _training = await repository.getAllTrainings();
  }

  Training get training => _training;
}
