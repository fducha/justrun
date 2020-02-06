import 'package:justrun/features/justrun/domain/entities/training.dart';

abstract class Repository {
  Future<Training> getAllTrainings();
}