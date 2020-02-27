import 'package:flutter/material.dart';
import 'package:hv_progress_indicator/hv_progress_indicator.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../../../../core/localization/app_localization.dart';
import '../../../../core/utils/utils.dart';
import '../../domain/entities/task.dart';
import '../../domain/pure_models/process_state.dart';
import '../../domain/pure_models/training_model.dart';
import '../triggers/training_model_trigger.dart';

class TrainingPage extends StatefulWidget {
  final BuildContext parentContext;

  TrainingPage({
    Key key,
    @required this.parentContext,
  }) : super(key: key);

  @override
  _TrainingPageState createState() => _TrainingPageState(parentContext);
}

class _TrainingPageState extends State<TrainingPage> {
  final TrainingModelTrigger _trigger;

  _TrainingPageState(BuildContext parentContext)
      : _trigger = TrainingModelTrigger(context: parentContext);

  @override
  Widget build(BuildContext context) {
    double itemHeight = MediaQuery.of(context).size.height / 10;
    double itemWidth = MediaQuery.of(context).size.width - 16.0;

    final rxTrainingModel = Injector.getAsReactive<TrainingModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.of(context).appTitle),
        centerTitle: true,
      ),
      body: StateBuilder<TrainingModel>(
        models: [rxTrainingModel],
        builder: (context, rxModel) => ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: _trigger.taskCount,
          itemBuilder: (context, index) {
            return index == 0
                ? _buildCurrentItem(
                    _trigger.currentTask,
                    index,
                    itemHeight * 2,
                    itemWidth,
                    Theme.of(context).textTheme.body1.copyWith(
                          fontSize: 48,
                          color: Colors.white,
                        ),
                  )
                : _buildItem(
                    _trigger.task(index),
                    index,
                    itemHeight,
                    Theme.of(context).textTheme.body1.copyWith(
                          fontSize: 26,
                          color: Colors.white,
                        ),
                  );
          },
        ),
      ),
      floatingActionButton: StateBuilder<TrainingModel>(
        models: [_trigger.rxModel],
        tag: ['fabTrainingPage'],
        builder: (context, rxModel) => FloatingActionButton.extended(
          backgroundColor: Colors.red,
          onPressed: () {
            switch (rxModel.state.processState) {
              case ProcessState.Ready:
                _trigger.start();
                break;
              case ProcessState.InProcess:
                _trigger.pause();
                break;
              case ProcessState.Paused:
                _trigger.resume();
                break;
              case ProcessState.Done:
                _trigger.repeat();
                break;
            }
          },
          icon: _getFABIcon(context, rxModel.state.processState),
          label: Text(
            _getFABText(context, rxModel.state.processState),
            style: Theme.of(context)
                .textTheme
                .body1
                .copyWith(fontSize: 28.0, color: Colors.white),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildItem(Task task, int index, double height, TextStyle style) {
    return Card(
      color: task.exercise.color,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(height / 5)),
      child: Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 36.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              task.exercise.title,
              style: style,
            ),
            Text(
              timeToString(task.duration),
              style: style,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentItem(
      Task task, int index, double height, double width, TextStyle style) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(height / 10)),
      color: task.exercise.color,
      child: Container(
        padding: EdgeInsets.all(0.0),
        height: height,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  task.exercise.title,
                  style: style.copyWith(
                    fontSize: 28.0,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: StateBuilder<TrainingModel>(
                models: [Injector.getAsReactive<TrainingModel>()],
                tag: ['currentTask', 'fabTrainingPage'],
                builder: (context, rxModel) {
                  return rxModel.state.processState == ProcessState.Paused
                      ? Icon(
                          Icons.pause,
                          size: height / 2,
                          color: style.color,
                        )
                      : Container();
                },
              ),
            ),
            Align(
              child: StateBuilder<TrainingModel>(
                models: [Injector.getAsReactive<TrainingModel>()],
                tag: ['currentTask'],
                builder: (context, rxModel) => Text(
                  timeToString(rxModel.state.currentTaskTime),
                  style: style,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: StateBuilder<TrainingModel>(
                models: [Injector.getAsReactive<TrainingModel>()],
                tag: ['currentTask'],
                builder: (context, rxModel) => HVProgressIndicator(
                  width: width,
                  height: height / 5,
                  percentage: 100 *
                      rxModel.state.currentTaskTime /
                      _trigger.currentTask.duration,
                  backgroundColor: Colors.amber,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getFABText(BuildContext context, ProcessState state) {
    switch (state) {
      case ProcessState.Ready:
        return AppLocalization.of(context).fabTrainingPageStartText;
      case ProcessState.InProcess:
        return AppLocalization.of(context).fabTrainingPagePauseText;
      case ProcessState.Paused:
        return AppLocalization.of(context).fabTrainingPageResumeText;
      case ProcessState.Done:
        return AppLocalization.of(context).fabTrainingPageRepeatText;
      default:
        return AppLocalization.of(context).fabTrainingPageStopText;
    }
  }

  Icon _getFABIcon(BuildContext context, ProcessState state) {
    switch (state) {
      case ProcessState.Ready:
        return Icon(Icons.play_arrow, size: 36.0);
      case ProcessState.InProcess:
        return Icon(Icons.pause, size: 36.0);
      case ProcessState.Paused:
        return Icon(Icons.play_arrow, size: 36.0);
      case ProcessState.Done:
        return Icon(Icons.replay, size: 36.0);
      default:
        return Icon(Icons.stop, size: 36.0);
    }
  }
}
