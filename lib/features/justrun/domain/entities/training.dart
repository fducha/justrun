import 'package:equatable/equatable.dart';
import 'package:justrun/features/justrun/domain/entities/task.dart';

class Training extends Equatable {
  final List<Task> tasks;

  Training(this.tasks);
  
  @override
  List<Object> get props => [];
}