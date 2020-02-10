import '../entities/task.dart';
import 'process_state.dart';

class TaskModel {
  Task _task;
  int _time = 0;
  ProcessState _processState = ProcessState.Ready;

  Task get task => _task;
  set task(Task task) {
    _task = task;
  }

  int get time => _time;
  set time(int t) {
    _time = _task.duration - t;
  }

  ProcessState get processState => _processState;
  set processState(ProcessState state) => _processState = state;
}