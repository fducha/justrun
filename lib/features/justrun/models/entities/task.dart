import 'package:equatable/equatable.dart';
import 'package:justrun/features/justrun/models/entities/exercise.dart';
import 'package:meta/meta.dart';

// enum Exercise {
//   Walking,
//   SlowRun,
//   NormalRun,
//   AcceleratedRun
// }

class Task extends Equatable {
  final Exercise exercise;
  final int duration;
  // final Color color;

  Task({
    @required this.exercise,
    @required this.duration,
    // @required this.color,
  });

  @override
  List<Object> get props => [exercise, duration];
}
