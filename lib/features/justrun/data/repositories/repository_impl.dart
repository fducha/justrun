import 'package:flutter/material.dart';
import 'package:justrun/features/justrun/domain/entities/exercise.dart';
import 'package:justrun/features/justrun/domain/entities/task.dart';
import 'package:justrun/features/justrun/domain/entities/training.dart';
import 'package:justrun/features/justrun/domain/repositories/repository.dart';

class RepositoryImpl implements Repository {
  @override
  Future<Training> getAllTrainings() async {
    await Future.delayed(Duration(seconds: 2));

    final running = Exercise(
      title: 'Running',
      color: Colors.green[500],
    );
    final walking = Exercise(
      title: 'Walking',
      color: Colors.pink[300],
    );

    return Training(<Task>[
      Task(exercise: running, duration: 20),
      Task(exercise: walking, duration: 20),
      Task(exercise: running, duration: 20),
      Task(exercise: walking, duration: 20),
      Task(exercise: running, duration: 20),
      Task(exercise: walking, duration: 20),
    ]);
  }
}