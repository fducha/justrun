import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../../../../core/localization/app_localization.dart';
import '../../../../core/utils/utils.dart';
import '../../domain/entities/task.dart';
import '../../domain/pure_models/training_model.dart';

class TrainingPage extends StatelessWidget {
  TrainingPage({Key key}) : super(key: key);

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
        builder: (context, rxModel) => rxModel.whenConnectionState(
          onIdle: () => Container(),
          onWaiting: () => Center(child: CircularProgressIndicator()),
          onError: (error) => Center(child: Text(error.toString())),
          onData: (TrainingModel pureModel) => ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemCount: pureModel.training.tasks.length,
            itemBuilder: (context, index) {
              final _tasks = pureModel.training.tasks;
              return index == 0
                  ? _buildCurrentItem(
                      _tasks[index],
                      index,
                      itemHeight * 2,
                      itemWidth,
                      Theme.of(context).textTheme.body1.copyWith(
                            fontSize: 48,
                            color: Colors.white,
                          ),
                    )
                  : _buildItem(
                      _tasks[index],
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
      ),
      floatingActionButton: StateBuilder<TrainingModel>(
        models: [rxTrainingModel],
        tag: ['fabTrainingPage'],
        builder: (context, rxModel) => rxModel.whenConnectionState(
          onIdle: () => Container(),
          onWaiting: () => Container(),
          onError: (error) => Center(child: Text(error.toString())),
          onData: (pureModel) => FloatingActionButton.extended(
            backgroundColor: Colors.red,
            onPressed: () {
              // rxModel.setState((s) => s.nextTask());
              switch (pureModel.processState) {
                case TrainingProcessState.Ready:
                  rxModel.setState(
                    (s) => s.processState = TrainingProcessState.InProcess,
                    filterTags: ['fabTrainingPage'],
                  );
                  break;
                case TrainingProcessState.InProcess:
                  rxModel.setState(
                    (s) => s.processState = TrainingProcessState.Paused,
                    filterTags: ['fabTrainingPage'],
                  );
                  break;
                case TrainingProcessState.Paused:
                  rxModel.setState(
                    (s) => s.processState = TrainingProcessState.InProcess,
                    filterTags: ['fabTrainingPage'],
                  );
                  break;
                case TrainingProcessState.Done:
                  rxModel.setState(
                    (s) => s.processState = TrainingProcessState.Ready,
                    filterTags: ['fabTrainingPage'],
                  );
                  break;
              }
            },
            icon: _getFABIcon(context, pureModel.processState),
            label: Text(
              _getFABText(context, pureModel.processState),
              style: Theme.of(context).textTheme.body1
                  .copyWith(fontSize: 28.0, color: Colors.white),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildItem(Task task, int index, double height, TextStyle style) {
    return Card(
      color: task.exercise.color,
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
              child: Text(
                timeToString(task.duration),
                style: style,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: height / 4,
                color: Colors.green[300],
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                height: height / 4,
                width: width * 0.67,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getFABText(BuildContext context, TrainingProcessState state) {
    switch (state) {
      case TrainingProcessState.Ready:
        return AppLocalization.of(context).fabTrainingPageStartText;
      case TrainingProcessState.InProcess:
        return AppLocalization.of(context).fabTrainingPagePauseText;
      case TrainingProcessState.Paused:
        return AppLocalization.of(context).fabTrainingPageResumeText;
      case TrainingProcessState.Done:
        return AppLocalization.of(context).fabTrainingPageRepeatText;
      default:
        return AppLocalization.of(context).fabTrainingPageStopText;
    }
  }

  Icon _getFABIcon(BuildContext context, TrainingProcessState state) {
    switch (state) {
      case TrainingProcessState.Ready:
        return Icon(Icons.play_arrow, size: 36.0);
      case TrainingProcessState.InProcess:
        return Icon(Icons.pause, size: 36.0);
      case TrainingProcessState.Paused:
        return Icon(Icons.play_arrow, size: 36.0);
      case TrainingProcessState.Done:
        return Icon(Icons.replay, size: 36.0);
      default:
        return Icon(Icons.stop, size: 36.0);
    }
  }
}
